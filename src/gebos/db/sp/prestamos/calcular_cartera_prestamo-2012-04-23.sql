/*****************************************************************************************************

 Función que ejecuta el cierre de cartera por prestamo (Calculo de Devengos, cuotas vencidas, cambios
 de tasa).
 Params:
 @p_fecha         Fecha de Proceso data por la tabla control cierre
 @p_oficina_id    Oficina que origina el proceso
 @p_ultimo        Número del último financiamiento procesado

 Desarrollado por: Diego Bertaso y Paúl Feo
 Última Modificación: 11/10/2010
*****************************************************************************************************/
-- Function: calcular_cartera_programa(integer, date, date)

-- DROP FUNCTION calcular_cartera_programa(integer, date, date);

CREATE OR REPLACE FUNCTION calcular_cartera_prestamo(p_fecha date, p_oficina_id integer, p_primero integer, p_ultimo integer)
  RETURNS boolean AS
$BODY$

  declare
    _prestamo prestamo%rowtype;
    _prestamo_t prestamo%rowtype;
    _cuota plan_pago_cuota%rowtype;
    _control_cierre control_cierre%rowtype;
    _plan plan_pago%rowtype;          ---> db 20070816
    _cuota1 plan_pago_cuota%rowtype;  ---> db 20070816
    _programa programa%rowtype;       ---> db 20071029
    _cur_prestamo refcursor;
   _tasa_historico tasa_valor%rowtype;
    _producto producto%rowtype;
    _fecha_revision_tasa date;
    _tiene_tasa bool = false;
    _valor_tasa float = 0;
    _cheques text[][];
    _fecha_fin_mes date;
    _cur_cuotas_por_cobrar refcursor;
    _row_cuotas_por_cobrar record;
    _tiene_historico bool;
    _tiene_abono bool = false;
    _abono_monto_cuotas float;
    _titulo varchar;
    _plan_pago_id integer;
    _nombre_programa varchar;
    _contador integer = 0;
    _prestamo_id integer = 0;
    
    begin
    
      -- Determina cual es la fecha de fin de mes

      raise info '[GEBOS] calcular_cartera_prestamo {p_fecha: %, p_oficina_id: %, p_ultimo : %', p_fecha, p_oficina_id, p_ultimo;

      if extract(day from p_fecha) = 31 then
          _fecha_fin_mes = p_fecha;
      else
        _fecha_fin_mes = agregar_meses(p_fecha, 1);
        _fecha_fin_mes = agregar_dias(_fecha_fin_mes, -cast(extract(day from _fecha_fin_mes) as integer));
      end if;
                      
      /*
      ----------------------------
      Lectura de control cierre
      ----------------------------
      */
      
      raise notice 'Último préstamo procesado =======================>% ', p_ultimo;
          
      select
      into
              _control_cierre *
      from
              control_cierre
      where
              control_cierre.senal_enproceso 	= true and
              control_cierre.senal_cerrado	= false and
              control_cierre.senal_shell	= false;
      
      
      /*
      -----------------------------------------------------------------------------
       Primer cursor (se selecciona solamente los prestamos vigentes para actuali
       zar, cuotas vencidas, interes causado, capital vencido, actualizar cuotas,
       saldo. Si el prestamo es intermediado calcula adicionalemente la fecha de
       cobranza
      -----------------------------------------------------------------------------
      */
      
      open 
        _cur_prestamo
         
        for
         
        select 
                * 
        from
                prestamo inner join solicitud on (prestamo.solicitud_id = solicitud.id)

        where 
                prestamo.estatus not in ('S', 'Q', 'R', 'C', 'F', 'A', 'X','K') and
                (prestamo.id > p_primero and prestamo.id  <= p_ultimo)
        order by 
                prestamo.numero;

      loop
      
        fetch 
              _cur_prestamo 
        INTO 
              _prestamo;
        exit 
        when 
        not found;

        _contador = _contador + 1;
        _prestamo_id = _prestamo.id;
        
        raise notice 'PRESTAMO NUMERO ++++++++++++++++++++ %', _prestamo.numero;

        if _prestamo.intermediado = false then
        -- raise debug 'no es intermediado PRETAMO NUMERO ++++++++++++++++++++ %', _prestamo.numero;
          perform actualizar_cuotas(_prestamo.id, p_fecha, false);
        else
          perform actualizar_cuotas_intermediado(_prestamo.id, p_fecha);
          perform actualizar_fecha_cobranza_intermediado(_prestamo.id, p_fecha);
        end if;


        perform calcular_saldo_insoluto_dos(_prestamo.id, p_fecha, false);
        perform calcular_interes_vencido(_prestamo.id, p_fecha, false);
        perform calcular_capital_vencido(_prestamo.id, p_fecha, false);
        -- 10OCT2010
        --Comentado por AB. Interés Causado será calculado por la rutina ajustar_intereses
        --perform calcular_interes_causado(_prestamo.id, p_fecha, false);

        -- Agregado por AB. Ajustes de intereses por cambio de tasa. Cálculo de interes causado
        perform ajustar_intereses(_prestamo.id, p_fecha);
        -- Agregado por AB. Calculo de devengo de intereses Ordinarios (O)
        perform calcular_interes_devengado(_prestamo.id, p_fecha, 'O');

        --perform calcular_interes_gracia_devengado(_prestamo.id, p_fecha, false);
        perform calcular_cuotas_vencidas(_prestamo.id, p_fecha, false);

        if _prestamo.estatus not in ('L','K') then
          perform calcular_mora_mod(_prestamo.id, p_fecha, p_fecha, false,0);
        end if;

        perform actualizar_deuda_exigible(_prestamo.id, false);

        --perform calcular_montos_recuperados(_prestamo.id,false);
        
        raise notice 'Contador ===========> % ', _contador;
         
      end loop;

      update 
              control_cierre 
      set
              ultimo_prestamo = p_ultimo;
      where
              id = _control_cierre.id;

      close _cur_prestamo;


      /*
      -------------------------------------------------------------------------------
      La rutina que viene a continuacion verifica si aplica una generacion de un nue
      vo plan pago producto de un abono extraordinario o un cambio de tasa o ambos
      inclusive

      Modificacion realizada por Diego Bertaso
      Fecha: 16/08/2007
      ------------------------------------------------------------------------------
      */

      _contador = 0;
                      
      open 
          _cur_prestamo for 
          
          select 
                    * 
          from 
                    prestamo 
                          inner join solicitud on (prestamo.solicitud_id = solicitud.id)
          where
                    prestamo.estatus not in ('S', 'Q', 'R', 'C', 'F', 'A', 'X', 'K') and
                    (prestamo.id > p_primero and prestamo.id  <= p_ultimo)
          order by 
                    prestamo.numero;

          loop
          
            fetch 
                  _cur_prestamo 
            INTO 
                  _prestamo;
            exit 
            when 
            not found;
            
            _tiene_abono = false;
          
            _contador = _contador + 1;

            raise notice 'PRESTAMO NUMERO ++++++++++++++++++++ %', _prestamo.numero;

            /*
            ------------------------------------------------------------------------------------------
            Diego Bertaso
            Se incluyo la validacion del mes y el ano de la cuota ya que en los prestamos trimestrales
            se generaba un plan pago antes de la fecha focal (cuando coincidia el dia de facturacion
            fecha: 20070816
            ------------------------------------------------------------------------------------------
            */

            select 
            into 
                  _plan * 
            from 
                  plan_pago 
            where 
                  prestamo_id = _prestamo.id and 
                  activo = true and 
                  proyeccion = false;

            select 
            into 
                    _cuota1 * 
            from 
                    plan_pago_cuota
            where 
                    fecha = p_fecha and
                    plan_pago_id = _plan.id;


            --raise debug 'id de la cuota +++++++%', _cuota1.id;

            if _cuota1.id is not null then

              --raise debug 'entro en el primer if +++++++%', _prestamo.numero;

              if cast(extract(day from _cuota1.fecha) as integer) = cast(extract(day from p_fecha) as integer) then

                if _prestamo.estatus = 'V' and _prestamo.remanente_por_aplicar > 0 then

                  --raise debug 'Entro a _prestamo.estatus = V and _prestamo.remanente_por_aplicar > 0 ++++++++++++++++++++ %', _prestamo.remanente_por_aplicar;

                  open 
                        _cur_cuotas_por_cobrar
                  for 
                        select 
                                count(id) as cantidad 
                        from 
                                plan_pago_cuota
                        where
                                fecha > p_fecha  and 
                                tipo_cuota = 'C' and 
                                plan_pago_id in (select 
                                                        id 
                                                 from 
                                                        plan_pago
                                                 where 
                                                        prestamo_id = _prestamo.id and 
                                                        activo = true and 
                                                        proyeccion = false);

                  fetch 
                    _cur_cuotas_por_cobrar 
                  INTO 
                    _row_cuotas_por_cobrar;

                  if _row_cuotas_por_cobrar.cantidad >= 1  then

                    select 
                    into 
                            _producto * 
                    from 
                            producto 
                    where 
                            id = _prestamo.producto_id;

                    if _producto.abono_cantidad_cuotas > 0 then
                    
                      select 
                      into 
                            _cuota * 
                      from 
                            plan_pago_cuota 
                      where 
                            estatus_pago = 'X' and 
                            plan_pago_id in (select 
                                                    id 
                                             from 
                                                    plan_pago
                                             where 
                                                    prestamo_id = _prestamo.id and 
                                                    activo = true and 
                                                    proyeccion = false);

                      --raise debug 'parametro general exige 1 cuota minimo ++++++++++++++++++++ %', _prestamo.numero;

                      if _cuota.id is null then
                        select 
                        into 
                              _cuota * 
                        from 
                              plan_pago_cuota 
                        where 
                              tipo_cuota  = 'G' and 
                              plan_pago_id in (select 
                                                        id 
                                               from 
                                                        plan_pago
                                               where 
                                                        prestamo_id = _prestamo.id and 
                                                        activo = true and 
                                                        proyeccion = false) 
                                               order by 
                                                        numero asc;
                      end if;   ----> Fin if _cuota.id is null then

                      if _cuota.id is null then
                        select 
                        into 
                                _cuota * 
                        from 
                                plan_pago_cuota 
                        where 
                                tipo_cuota  = 'C' and 
                                plan_pago_id in (select 
                                                          id 
                                                 from 
                                                          plan_pago
                                                 where 
                                                          prestamo_id = _prestamo.id and 
                                                          activo = true and 
                                                          proyeccion = false) 
                                                 order by 
                                                          numero asc;
                                                          
                      end if;     ---> fin if _cuota.id is null then

                      if (_cuota.valor_cuota*_producto.abono_cantidad_cuotas) <= _prestamo.remanente_por_aplicar then
                  
                        _tiene_abono = true;
                      end if;
                              
                    else     ---> if _producto.abono_cantidad_cuotas > 0 then
                  
                      --raise debug 'Tiene abono = true ++++++++++++++++++++ %', _prestamo.numero;
                      _tiene_abono = true;
              
                    end if;   --> Fin if _producto.abono_cantidad_cuotas > 0 then
                          
                  end if;     --> Fin if _row_cuotas_por_cobrar.cantidad >= 1  then
                        
                  /*
                  --------------------------------------------------------------
                  Diego Bertaso
                  Se incluyo la instruccion cerrar el cursor ya que si existia
                      mas de un prestamo con la condicion de abono se producia un
                      error y finalizaba abruptamente el cierre
                      fecha: 20070816
                  --------------------------------------------------------------
                  */

                  close _cur_cuotas_por_cobrar;
                        
                end if;   ----> if _prestamo.estatus = 'V' and _prestamo.remanente_por_aplicar > 0 then

                _valor_tasa = 0;

                _tiene_tasa = false;
                _tiene_historico = false;
                _fecha_revision_tasa = _prestamo.fecha_revision_tasa;

                select 
                into 
                      _tasa_historico * 
                from 
                      tasa_valor
                where 
                      tasa_valor.tasa_id = _prestamo.tasa_id and
                      fecha_resolucion_hasta is null and
                      fecha_resolucion_desde <= p_fecha;


                if (_tasa_historico.valor <> _prestamo.tasa_vigente)  and
                    _prestamo.tasa_fija = false and
                    (( _fecha_revision_tasa is null) or
                    ( _fecha_revision_tasa is not null and
                      _fecha_revision_tasa = p_fecha))  then

                  _valor_tasa = _tasa_historico.valor;
                  raise debug 'VALOR TASA ==========================> %', _valor_tasa;

                  _tiene_historico = true;
                  _tiene_tasa = true;
                end if;

                if _fecha_revision_tasa is not null and _fecha_revision_tasa = p_fecha then
                  _fecha_revision_tasa = agregar_meses(_fecha_revision_tasa, _prestamo.meses_fijos_sin_cambio_tasa);
                  
                  update 
                        prestamo 
                  set  
                        fecha_revision_tasa =  _fecha_revision_tasa
                  where 
                        id = _prestamo.id;
                end if;

                if _prestamo.tasa_forzada = true and _prestamo.tasa_forzada_fecha_vigencia < p_fecha then
                
                  update 
                        prestamo 
                  set  
                        tasa_forzada = false
                  where 
                        id = _prestamo.id;
                end if;

                if _prestamo.tasa_forzada = true and 
                  _prestamo.tasa_vigente <> _prestamo.tasa_forzada_monto then
               
                    _valor_tasa = _prestamo.tasa_forzada_monto;
                
                    update 
                          prestamo 
                    set 
                          tasa_vigente = _valor_tasa
                    where 
                          id = _prestamo.id;
                          _tiene_tasa = true;
                end if;

                if _prestamo.tasa_forzada = false and 
                  _tiene_tasa = true then
                
                    update 
                          prestamo 
                    set 
                          tasa_vigente = _valor_tasa
                    where 
                          id = _prestamo.id;
                        
                    _tiene_tasa = true;
                  
                end if;

                /*
                ----------------------------------------------------------------------
                El cursor que se agrega a continuacion verifica la ultima cuota del
                prestamo. Si es la ultima cuota del prestamo no procede el cambio de
                tasa ya que no existen mas cuotas y no se puede hacer una equivalencia
                financiera

                Diego Bertaso
                Fecha:  2008-02-29
                -----------------------------------------------------------------------
                */

                open 
                  _cur_cuotas_por_cobrar
                for 
                  select 
                          count(id) as cantidad 
                  from 
                          plan_pago_cuota
                  where
                          fecha >= p_fecha and 
                          tipo_cuota = 'C' and 
                          plan_pago_id in (select 
                                                    id 
                                           from 
                                                    plan_pago
                                           where 
                                                    prestamo_id = _prestamo.id and 
                                                    activo = true and 
                                                    proyeccion = false);

                fetch 
                      _cur_cuotas_por_cobrar 
                INTO 
                      _row_cuotas_por_cobrar;

                  if _row_cuotas_por_cobrar.cantidad = 1 then
                    _tiene_tasa = false;
                    _tiene_abono = false;
                  end if;

                close _cur_cuotas_por_cobrar;

                /* Fin de modificacion validacion ultima cuota */

                if _tiene_abono = true and _tiene_tasa = false then

                --raise debug 'Tiene abono = true y tiene tasa = false ++++++++++++++++++++ %', _prestamo.numero;
                  perform iniciar_transaccion(_prestamo.id, 1, 'p_nuevo_plan_pago', 'L', 'Nuevo Plan Pago Abono Extraordinario (Cierre) para el préstamo Número '||_prestamo.numero);
              
                  perform generar_plan_pago_evento(false, _prestamo.id, p_fecha, false, 0, false, 0, true, _prestamo.remanente_por_aplicar,0,0);
                  
                end if;

                if _tiene_tasa = true then
            
                  if _tiene_abono = true then
                    _titulo = 'Nuevo Plan Pago Cambio de Tasa/Abono Extraordinario (Cierre) para el préstamo Número ';
                  else
                    _titulo = 'Nuevo Plan Pago Cambio de Tasa (Cierre) para el préstamo Número ';
                  
                  end if;      ----> Fin _tiene_abono = true then 
                  
                  perform iniciar_transaccion(_prestamo.id, 1, 'p_nuevo_plan_pago', 'L', _titulo||_prestamo.numero);
                
                  perform generar_plan_pago_evento(false, _prestamo.id, p_fecha, false, 0, _tiene_tasa, _valor_tasa, _tiene_abono, _prestamo.remanente_por_aplicar,0,0);
                
                  if _tiene_historico = true and _prestamo.tasa_forzada = false then
                
                    insert 
                    into 
                          prestamo_tasa_historico
                                        (tasa_cliente, prestamo_id, tasa_id, fecha)
                                values
                                        (_tasa_historico.valor, _prestamo.id, _tasa_historico.tasa_id, p_fecha);
                    else
                
                      insert 
                      into 
                            prestamo_tasa_historico
                                        (tasa_cliente, prestamo_id, tasa_id, fecha)
                                values
                                        (_valor_tasa, _prestamo.id, null, p_fecha);
                                      
                  end if;       --->  Fin if _tiene_historico = true and _prestamo.tasa_forzada = false then
                
                end if;         --->  Fin if _tiene_tasa = true then
                            
                if _tiene_abono = true then

                  --raise debug 'Actualizo remanente por aplicar = 0 ++++++++++++++++++++ %', _prestamo.numero;
                  update 
                        prestamo 
                  set 
                        remanente_por_aplicar = 0 
                  where 
                        id = _prestamo.id;
                        
                end if;    ----> Fin if _tiene_abono = true then
                          
              end if; --> if cast(extract(day from plan_pago_cuota.fecha) as integer) = _prestamo.dia_facturacion then

            end if; ---> _cuota1.id is not null then

            /*
            -----------------------------------------------------------------------------------------------------------
            Si la señal de tine tasa es true o la señal de tiene abono es true se actualiza la señal de visita a true
            -----------------------------------------------------------------------------------------------------------
            */

            if _tiene_tasa = true or
               _tiene_abono = true then

            update
              prestamo
            set
              senal_visita = true
            where
              prestamo.id = _prestamo.id;
            end if;

          end loop;

          close _cur_prestamo;

          raise debug 'Finalizo loop de abono y cambio de tasa ++++++++++++++++++++ %', _prestamo.numero;
                      
          /*
          ----------------------------------------------------
          Se verifica si algun prestamo fue visitado  para
          determinar si aplica el ultimo loop
          ----------------------------------------------------
          */
          
          
          select
          into
                  _prestamo *
          from
                  prestamo
          where
                  (prestamo.id > p_primero and prestamo.id <= p_ultimo) and
                  prestamo.senal_visita = true;
                  
          if not found then
          
            return true;
          
          else

            _contador = 0;
            
            open 
                  _cur_prestamo 
            for 
              select 
                      * 
              from
                        prestamo inner join solicitud on (prestamo.solicitud_id = solicitud.id)

              where 
                        prestamo.estatus not in ('S', 'Q', 'R', 'C', 'F', 'A', 'X','K') and
                        prestamo.senal_visita = true and
                        (prestamo.id > p_primero and prestamo.id  <= p_ultimo)
              order by 
                        prestamo.numero;


            loop
            
              fetch 
                    _cur_prestamo 
              INTO 
                    _prestamo;
              exit 
              when 
              not found;
            
              _contador = _contador + 1;
              
              if _prestamo.intermediado = false then
                perform actualizar_cuotas(_prestamo.id, p_fecha, false);
              else
                perform actualizar_cuotas_intermediado(_prestamo.id, p_fecha);
              end if;

              raise notice 'Ejecutando ultimo loop ++++++++++++++++++++ %', _prestamo.numero;


              perform calcular_saldo_insoluto_dos(_prestamo.id, p_fecha, false);
              perform calcular_interes_vencido(_prestamo.id, p_fecha, false);
              perform calcular_capital_vencido(_prestamo.id, p_fecha, false);
              perform calcular_cuotas_vencidas(_prestamo.id, p_fecha, false);

              if _prestamo.estatus not in ('L','K') then
                perform calcular_mora_mod(_prestamo.id, p_fecha, p_fecha, false,0);
              end if;

              perform actualizar_deuda_exigible(_prestamo.id, false);
              --NO VA perform reclasificar_cuota(_prestamo.id, p_fecha);
              if _fecha_fin_mes = p_fecha  then
                perform interes_devengado_fin_mes(_prestamo.id, p_fecha);
              end if;
              if (extract (day from p_fecha) = extract(day from _prestamo.fecha_inicio)) then
                perform eventos_vencimiento_cuota(_prestamo.id, p_fecha);
              end if;
              if _prestamo.meses_fijos_sin_cambio_tasa > 0 and _prestamo.fecha_revision_tasa = p_fecha then
                perform actualizar_fecha_cambio_tasa(_prestamo.id, p_fecha);
              end if;
            

            end loop;
            
          end if;
           
          close _cur_prestamo;

          /*
          -----------------------------------------------------------------------------------
          Se coloca senal de visita a false a todos aquellos prestamos que fueron visitados
          -----------------------------------------------------------------------------------
          */
          
          select 
          into
                _prestamo *
          from
                prestamo
          order by
                  id desc
          limit 1;
          
          if p_ultimo >= _prestamo.id then
          
            raise notice 'Actualizó ultimo prestamo en control_cierre';
            update
                control_cierre
            set
                ultimo_prestamo = 0
            where
                id = _control_cierre.id;
                
          end if;     

          update
            prestamo
          set
            senal_visita = false
          where
            senal_visita = true;

          raise info '[GEBOS] calcular_prestamo finalizado';
          
          return true;

        end;
    $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
  

