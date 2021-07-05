-- Function: ejecutar_pago(integer, character varying[], integer, character, double precision, integer, date, date, character varying, double precision, integer, boolean, boolean, boolean, boolean, boolean, character varying, character varying)

-- DROP FUNCTION ejecutar_pago(integer, character varying[], integer, character, double precision, integer, date, date, character varying, double precision, integer, boolean, boolean, boolean, boolean, boolean, character varying, character varying);

CREATE OR REPLACE FUNCTION ejecutar_pago(p_cliente_id integer,
                                         p_cheques character varying[],
                                         p_prestamo_id integer,
                                         p_modalidad character,
                                         p_monto double precision,
                                         p_oficina_id integer,
                                         p_fecha_realizacion date,
                                         p_fecha date,
                                         p_numero_voucher character varying,
                                         p_monto_efectivo double precision,
                                         p_entidad_financiera_id integer,
                                         p_proceso_nocturno boolean,
                                         p_cancelacion_prestamo boolean,
                                         p_hay_cheques boolean,
                                         p_exonerar_mora boolean,
                                         p_consultoria_juridica boolean,
                                         p_observaciones_analista character varying,
                                         p_analista_nombre_completo character varying,
                                         p_recuperaciones boolean,
                                         p_tipo_pago character = 'P')
  RETURNS integer AS
$BODY$
  declare
      _factura factura%rowtype;
      _cliente cliente%rowtype;
      _persona persona%rowtype;
      _empresa empresa%rowtype;
      _solicitud solicitud%rowtype;
      _origen_fondo origen_fondo%rowtype;
      _entidad_financiera entidad_financiera%rowtype;
      _pago_cliente_id integer;
      _plan_pago plan_pago%rowtype;
      _plan_pago_cuota plan_pago_cuota%rowtype;
      _plan_pago_cuota_pagada plan_pago_cuota%rowtype;
      _cur_plan_pago_cuota refcursor;
      _deuda_cuota float;
      _pago_monto_prestamo float;
      _prestamo_id integer;
      _pago_prestamo_id integer;
      _deuda_interes_corriente NUMERIC(14,2);
      _deuda_interes_mora NUMERIC(14,2);
      _deuda_interes_diferido NUMERIC(14,2);
      _deuda_interes_desembolso NUMERIC(14,2);
      _deuda_capital NUMERIC(14,2);
      _pago_interes_corriente NUMERIC(14,2);
      _pago_acumulado_interes_corriente float;
      _pago_interes_mora NUMERIC(14,2);
      _pago_acumulado_interes_mora NUMERIC(14,2);
      _pago_interes_diferido NUMERIC(14,2);
      _pago_acumulado_interes_diferido NUMERIC(14,2);
      _pago_interes_desembolso NUMERIC(14,2);
      _pago_acumulado_interes_desembolso NUMERIC(14,2);
      _pago_capital NUMERIC(14,2);
      _pago_acumulado_capital NUMERIC(14,2);
      _pago_cuota_total NUMERIC(14,2);
      _remanente_por_aplicar NUMERIC(14,2);
      _remanente_por_aplicar_inicial NUMERIC(14,2) = 0;
      _remanente_por_aplicar_cuota float;
      _abono_capital NUMERIC(14,2) = 0;
      _pago_incompleto bool = false;
      _factura_id integer;
      _estatus_pago char;
      _prepago bool;
      _prestamo prestamo%rowtype;
      _prestamo_post prestamo%rowtype;
      _pago_cuota_id integer;
      _pago_cuota pago_cuota%rowtype;
      _pago_interes_mora_aux float = 0;
      _p_exonerar_mora bool = false;      ---> Diego Bertaso
      _saldo_insoluto_nuevo NUMERIC(14,2) = 0;

      _pago_real_interes_corriente NUMERIC(14,2);
      _pago_real_interes_diferido NUMERIC(14,2);
      _pago_real_interes_mora NUMERIC(14,2);
      _pago_real_interes_desembolso NUMERIC(14,2);
      _pago_real_capital NUMERIC(14,2);
      _monto_factura NUMERIC(14,2);
      _mora_exonerada NUMERIC(14,2);
      _interes_intermediario NUMERIC(16,2);

      -- INICIO CONTABILIDAD
      _con_entidad_financiera entidad_financiera%rowtype;
      _con_cuenta_contable_banco cuenta_contable%rowtype;
      _con_codigo_cuenta_contable_banco integer;
      _con_remanente_por_aplicar_inicial NUMERIC(14,2) = 0;

      _con_programa_origen_fondo programa_origen_fondo%rowtype;
      _con_solicitud solicitud%rowtype;


      -- cuando la cuota esta vigente
      _con_monto_intereses_por_cobrar NUMERIC(14,2) = 0;
      _con_monto_intereses_por_cobrar_anio_2 NUMERIC(14,2) = 0;
      _con_monto_ingreso_intereses NUMERIC(14,2) = 0;
      _con_monto_capital_cuota NUMERIC(14,2) = 0;
      _con_monto_capital_cuota_anio_2 NUMERIC(14,2) = 0;

      --cuando la cuota esta vencido
      _con_monto_intereses_por_cobrar_vencido NUMERIC(14,2) = 0;
      _con_monto_intereses_por_cobrar_vencido_anio_2 NUMERIC(14,2) = 0;
      -----este es el capital
      _con_monto_credito_cuota_vencido NUMERIC(14,2) = 0;
      _con_monto_credito_cuota_vencido_anio_2 NUMERIC(14,2) = 0;


      _anio_1 integer = 0;
      _anio_2 integer = 0;
      _monto_anio_1 numeric(14,2) = 0;
      _monto_anio_2 numeric(14,2) = 0;
      _monto_mora_anio_1 numeric(14,2) = 0;
      _monto_mora_anio_2 numeric(14,2) = 0;
      _estatus char(1);
      _estatus_ini char(1);
      _fuente_recursos_id integer;
      _sector_economico_id integer;
      _nombre_cliente character varying;
      _con_monto_comision_intermediario numeric(14,2) = 0;
      _transaccion_id integer;

      -- FIN CONTABILIDAD
        _parametro parametro_general%rowtype;
        _fecha_calculo date;

       -- AUXILIARES PARA BUSCAR DATOS A INTRODUCIR EN FACTUTA
       _sector_economico varchar;
       _estado_prestamo varchar;
       _distincion_cobranza  varchar;
       _analista varchar;

  begin

    -- raise notice 'monto%',p_monto;
    -- Inserta el pago_cliente

     _p_exonerar_mora = p_exonerar_mora;    ---> Diego Bertaso

     _transaccion_id = currval('transaccion_id_seq');

     select
     into
            _prestamo *
     from
            prestamo
     where id = p_prestamo_id;

     if found then

       /*
       --------------------------------------
       Lectura de la solicitud relacionada
       con el préstamo
       --------------------------------------
       */

       select
       into
            _solicitud *
       from
            solicitud
       where
            solicitud.id = _prestamo.solicitud_id;

       if found then

         /*
         ----------------------------------------
         Seleccion del origen de fondo asignado
         a la solicitud
         ----------------------------------------
         */

         select
         into
              _origen_fondo *
         from
              origen_fondo
         where
              origen_fondo.id = _solicitud.origen_fondo_id;

         if found then

           /*
           -----------------------------------------------
           Si el origen de fondo existe se le asigna la
           fuente de recursos relacionada al origen del
           fondo
           -----------------------------------------------
           */

           _fuente_recursos_id = _origen_fondo.banco_origen;

         end if;


       end if;

       select
       into
             _cliente *
       from
             cliente
       where
             cliente.id = _prestamo.cliente_id;

       if found then

         if _cliente.type = 'ClienteEmpresa' then

           select
           into
                  _empresa *
           from
                  empresa
           where
                  empresa.id = _cliente.empresa_id;

           _sector_economico_id := _empresa.sector_economico_id;
           _nombre_cliente := _empresa.nombre;

         else

           select
           into
                 _persona *
           from
                 persona
           where
                 persona.id = _cliente.persona_id;

           _sector_economico_id := _persona.sector_economico_id;
           _nombre_cliente := _persona.primer_apellido || ' ' || _persona.primer_nombre;

         end if;

       end if;

     end if;

     _estatus_ini = _prestamo.estatus;
   -- if p_proceso_nocturno = true then
   --   perform iniciar_transaccion(_prestamo_id, 'p_pago_ordinario', 'L', 'Pago Ordinario (Cierre) para el préstamo Número '+_prestamo.numero, 1);
   -- end if;
    insert into pago_cliente (fecha, modalidad, monto, cliente_id, oficina_id, fecha_realizacion, numero_voucher, entidad_financiera_id, efectivo)
      values (p_fecha, p_modalidad, p_monto, p_cliente_id, p_oficina_id, p_fecha_realizacion, p_numero_voucher, p_entidad_financiera_id, p_monto_efectivo);

    _pago_cliente_id = currval('pago_cliente_id_seq');

    --INICIO CONTABILIDAD
    if p_modalidad = 'R' or p_modalidad = 'B' then
      select into _con_entidad_financiera * from entidad_financiera where id = p_entidad_financiera_id;
      select into _con_cuenta_contable_banco * from cuenta_contable where id = _con_entidad_financiera.cuenta_contable_id;
      _con_codigo_cuenta_contable_banco = _con_cuenta_contable_banco.id;
    end if;
    --FIN CONTABILIDAD


    -- Inserta las pago_forma
    if p_proceso_nocturno = false then
        if p_hay_cheques = true then
      for i in array_lower(p_cheques,1) .. array_upper(p_cheques,1) loop
        insert into pago_forma (forma, entidad_financiera_id, referencia, monto, pago_cliente_id)
            values ( p_cheques[i][1], cast(p_cheques[i][2] as integer), p_cheques[i][3],
            cast(p_cheques[i][4] as float), _pago_cliente_id );
      end loop;
      end if;
    end if;
    -- Paga los prestamos, recorre primero los prestamos que quiere pagar
    --for i in array_lower(p_prestamos,1) .. array_upper(p_prestamos,1) loop

      _pago_acumulado_interes_desembolso = 0;
      _pago_acumulado_interes_corriente = 0;
      _pago_acumulado_interes_diferido = 0;
      _pago_acumulado_interes_mora = 0;
      _pago_acumulado_capital = 0;

      --_pago_monto_prestamo = cast(p_prestamos[i][2] as float);
      _pago_monto_prestamo = p_monto;
      _prestamo_id = p_prestamo_id;

      raise notice '________________prestamo_id_%',_prestamo_id;

      _prepago = false;

       -- Inicio Contabilidad

          select into _con_solicitud * from solicitud
              where id = _prestamo.solicitud_id;

          select into _con_programa_origen_fondo * from programa_origen_fondo
              where programa_id = _con_solicitud.programa_id
              and origen_fondo_id = _con_solicitud.origen_fondo_id;


       -- Fin Contabilidad

      _con_remanente_por_aplicar_inicial = _prestamo.remanente_por_aplicar;
      _remanente_por_aplicar = _pago_monto_prestamo + _prestamo.remanente_por_aplicar;
      _remanente_por_aplicar_inicial =  _remanente_por_aplicar;
      raise notice 'remanente_por_aplicar antes de iniciar___________________%',_remanente_por_aplicar;
      if _prestamo.estatus = 'V' then
        _prepago = true;
      end if;

      /*
      --------------------------------------------------------------------------
      Diego Bertaso
      Se exonera la mora si el monto del pago es mayor o igual que el exigible
      fecha: 20/08/2007
      --------------------------------------------------------------------------
      */


      --if _p_exonerar_mora = true and
    --_pago_monto_prestamo  < _prestamo.exigible then
        --_p_exonerar_mora = false;
      --end if;

       ---> fin modificacion

      insert into pago_prestamo (monto, prestamo_id, pago_cliente_id)
          values(_pago_monto_prestamo, _prestamo_id, _pago_cliente_id);

      _pago_prestamo_id = currval('pago_prestamo_id_seq');

      if p_fecha_realizacion < p_fecha and
         _prestamo.estatus <> 'L'      and
         _p_exonerar_mora = false      then

         select into
                    _parametro *
         from
                    parametro_general
         limit 1;

        _fecha_calculo = p_fecha_realizacion;
        --_fecha_calculo = agregar_dias(p_fecha_realizacion, +(_parametro_general.dias_gracia_mora+1));
        --raise notice 'fecha_calculo antes de calcular mora______________%',_fecha_calculo;

        perform calcular_mora_mod(_prestamo_id, p_fecha_realizacion, _fecha_calculo, false, 2);

      end if;

      -- Paga las cuotas, recorre las cuotas del prestamo actual que quiere pagar
      -- Si es prepago solo busca una cuota
      --if _prepago = false then
        --  raise notice 'NO es prepago';

      --if _prestamo.estatus = 'E' then

        -- _deuda_interes_mora = _prestamo.monto_mora;

      --end if;

      open
           _cur_plan_pago_cuota
      for
           select
                    *
            from
                    plan_pago_cuota
                            inner join plan_pago on
                                    plan_pago_cuota.plan_pago_id = plan_pago.id
            where
                    prestamo_id = _prestamo_id and
                    estatus_pago in ('N', 'P') and
                    plan_pago.activo = true    and
                    plan_pago.proyeccion = false and
                    tipo_cuota in ('C', 'G')
            order by
                    plan_pago_cuota.id;

      --else
      --raise notice 'es prepago';
      -- open _cur_plan_pago_cuota for select * from plan_pago_cuota inner join plan_pago
      -- on plan_pago_cuota.plan_pago_id = plan_pago.id
      -- where prestamo_id = _prestamo_id
      -- and estatus_pago <> 'T'
      -- and plan_pago.activo = true
      -- and plan_pago.proyeccion = false
      -- and tipo_cuota in ('C', 'G') order by plan_pago_cuota.id limit 1;
      -- end if;

      loop

            fetch
                 _cur_plan_pago_cuota
            INTO
                 _plan_pago_cuota;

            exit when not found or _remanente_por_aplicar = 0 or
            _pago_incompleto = true;

            raise notice 'cuota_numero_____________%',_plan_pago_cuota.numero;
            raise notice 'tipo_____________%',_plan_pago_cuota.tipo_cuota;
            raise notice 'estatus_pago_____________%',_plan_pago_cuota.estatus_pago;

            -- Si la fecha de realización es menor a la fecha de real
            -- recalcula la mora de las cuotas impagas anteriores a la fecha de realización

            _pago_real_interes_desembolso = 0;
            _pago_real_interes_corriente = 0;
            _pago_real_interes_diferido = 0;
            _pago_real_interes_mora = 0;
            _pago_real_capital = 0;
            _mora_exonerada = 0;
            _interes_intermediario = 0;

            if _prestamo.estatus in ('V','H','E') then

                if _plan_pago_cuota.interes_mora >= _plan_pago_cuota.pago_interes_mora  then
                  _deuda_interes_mora = _plan_pago_cuota.interes_mora - _plan_pago_cuota.pago_interes_mora;
                else
                  _deuda_interes_mora =  _plan_pago_cuota.interes_mora;
                end if;

            end if;

            _deuda_cuota = _plan_pago_cuota.valor_cuota +
                           _deuda_interes_mora          +
                           _plan_pago_cuota.interes_diferido -
                           (_plan_pago_cuota.pago_interes_corriente +
                            _plan_pago_cuota.pago_interes_diferido +
                            _plan_pago_cuota.pago_capital);

            _deuda_interes_desembolso = _plan_pago_cuota.interes_desembolso - _plan_pago_cuota.pago_interes_desembolso;
            _deuda_interes_diferido = _plan_pago_cuota.interes_diferido - _plan_pago_cuota.pago_interes_diferido;
            _deuda_interes_corriente = _plan_pago_cuota.interes_corriente - _plan_pago_cuota.pago_interes_corriente;
            _deuda_capital = _plan_pago_cuota.amortizado - _plan_pago_cuota.pago_capital;

            --_remanente_por_aplicar = _remanente_por_aplicar + _plan_pago_cuota.remanente_por_aplicar;
            --_pago_interes_desembolso = _plan_pago_cuota.pago_interes_desembolso;
            --_pago_interes_diferido = _plan_pago_cuota.pago_interes_diferido;
            --_pago_interes_mora = _plan_pago_cuota.pago_interes_mora;
            --_pago_interes_corriente = _plan_pago_cuota.pago_interes_corriente;
            --_pago_capital = _plan_pago_cuota.pago_capital;

            _pago_interes_desembolso = 0;
            _pago_interes_diferido = 0;
            _pago_interes_mora = 0;
            _pago_interes_corriente = 0;
            _pago_capital = 0;

            _remanente_por_aplicar_cuota = 0;
            -- raise notice 'numero_cuota___________________%',_plan_pago_cuota.numero;

            /*
            ----------------------
            Procesa Pago de Mora
            ----------------------
            */

            if (_remanente_por_aplicar > 0) then
              if (_deuda_interes_mora > 0) then
                if _p_exonerar_mora = false then
                  if _remanente_por_aplicar >= _deuda_interes_mora then
                    _pago_interes_mora = _deuda_interes_mora;
                    /*
                      Se eliminó el uso de plan_pago_mora 10-06-2009
                    */
                    update
                           plan_pago_cuota
                    set
                           fecha_ultima_mora = p_fecha_realizacion
                    where
                           plan_pago_cuota.id = _plan_pago_cuota.id;
                  else
                       _pago_interes_mora = _remanente_por_aplicar;
                       _pago_incompleto = true;

                       update
                              plan_pago_cuota
                       set
                              fecha_ultima_mora = p_fecha_realizacion
                       where
                             plan_pago_cuota.id = _plan_pago_cuota.id;

                  end if; ---> if _remanente_por_aplicar >= _deuda_interes_mora then
                  _remanente_por_aplicar = _remanente_por_aplicar - _pago_interes_mora;
                  raise notice 'pago_interes_mora ____________-%', _pago_interes_mora;
                  raise notice 'remanente_por_aplicar ____________-%', _remanente_por_aplicar;

                else    ---> if _p_exonerar_mora = false then
                    _mora_exonerada = _mora_exonerada + _deuda_interes_mora;
                end if; ---> if _p_exonerar_mora = false then
              end if;   ---> if (_deuda_interes_mora > 0) then
               else
                 _pago_incompleto = true;
           end if;     ---> if (_remanente_por_aplicar > 0) then

            /*
            -------------------------------------
            Procesa el pago de interes diferido
            -------------------------------------
            */

            if _pago_incompleto = false and _deuda_interes_diferido > 0 and
               p_proceso_nocturno = false and _plan_pago_cuota.tipo_cuota in ('C','G') then

               if _deuda_interes_diferido > 0 and _plan_pago_cuota.tipo_cuota = 'C' then

                 if (_remanente_por_aplicar > 0) then

                   if (_remanente_por_aplicar >= _deuda_interes_diferido) then
                       _pago_interes_diferido = _deuda_interes_diferido;
                   else
                       _pago_interes_diferido = _remanente_por_aplicar;
                   end if;

                   _pago_acumulado_interes_diferido = _pago_acumulado_interes_diferido + _pago_interes_diferido;
                   _remanente_por_aplicar = _remanente_por_aplicar - _pago_interes_diferido;

                 else
                   _pago_incompleto = true;

                 end if;

               end if;

               if _deuda_interes_diferido > 0 and _plan_pago_cuota.tipo_cuota = 'G' then

                 if (_remanente_por_aplicar > 0) then

                   if _prestamo.codigo_d3 is not null then

                     if (_remanente_por_aplicar >= _deuda_interes_diferido) then
                         _pago_interes_diferido = _deuda_interes_diferido;
                     else
                         _pago_interes_diferido = _remanente_por_aplicar;
                     end if;

                     _pago_acumulado_interes_diferido = _pago_acumulado_interes_diferido + _pago_interes_diferido;
                     _remanente_por_aplicar = _remanente_por_aplicar - _pago_interes_diferido;

                  end if;

                 else
                   _pago_incompleto = true;

                end if;

              end if;

            end if; --> if _pago_incompleto = false and _deuda_interes_diferido > 0 and p_proceso_nocturno = false then

            /*
            -------------------------------------------
            Procesa el pago de interes por desembolso
            -------------------------------------------
            */

            if _pago_incompleto = false and _deuda_interes_desembolso > 0 then

              if (_remanente_por_aplicar > 0 ) then

                if (_remanente_por_aplicar >= _deuda_interes_desembolso ) then
                  _pago_interes_desembolso = _deuda_interes_desembolso;

                else
                  _pago_interes_desembolso = _remanente_por_aplicar;
                  _pago_incompleto = true;

                end if;

                  _remanente_por_aplicar = _remanente_por_aplicar - _pago_interes_desembolso;
              else
                  _pago_incompleto = true;
            end if;

               --raise notice 'remanente_por_aplicar despues de interes desembolso___________________%',_remanente_por_aplicar;
            end if;


            /*
            --------------------------------------
            Procesa el pago de interes ordinario
            --------------------------------------
            */

            if _pago_incompleto = false and _deuda_interes_corriente > 0 then

              -- if ((_remanente_por_aplicar >= _deuda_interes_corriente) or (_deuda_interes_corriente -_remanente_por_aplicar<1)) then

              if (_remanente_por_aplicar > 0) then

                /* Comentado por diego bertaso porque no debe sumar los intereses intermediarios en el remanente por aplicar

                if _interes_intermediario > 0 then

                  raise notice 'Interes Intermediario____________%', _interes_intermediario;

                  _remanente_por_aplicar = _remanente_por_aplicar + _interes_intermediario;

                  raise notice 'remanente_por_aplicar despues de sumar interes inter.____________%',_remanente_por_aplicar;
                end if;
                */

                if (_remanente_por_aplicar >= _deuda_interes_corriente) then
                  _pago_interes_corriente = _deuda_interes_corriente;
                else
                  _pago_interes_corriente = _remanente_por_aplicar;
                 _pago_incompleto = true;
                end if;

                _remanente_por_aplicar = _remanente_por_aplicar - _pago_interes_corriente;

                --Inicio Contabilidad

                --if p_modalidad = 'B' then
                  -- _con_monto_comision_intermediario = _con_monto_comision_intermediario + _plan_pago_cuota.interes_intermediario;
                --end if;

                  --Fin Contabilidad

              else        ---> if (_remanente_por_aplicar > 0) then

                _pago_incompleto = true;

              end if;     ---> if (_remanente_por_aplicar > 0) then

                --raise notice 'remanente_por_aplicar despues de interes___________________%',_remanente_por_aplicar;

            end if;  --->if _pago_incompleto = false and _deuda_interes_corriente > 0 then


            /*
            ----------------------------
            Procesa el pago de capital
            ----------------------------
            */

           if _pago_incompleto = false and _deuda_capital > 0 then

              -- if ((_remanente_por_aplicar >= _deuda_capital) or (_deuda_capital -_remanente_por_aplicar<1)) then

              if (_remanente_por_aplicar > 0)  then

                if (_remanente_por_aplicar >= _deuda_capital)  then
                  _pago_capital = _deuda_capital;
                else
                  _pago_capital = _remanente_por_aplicar;
                  _pago_incompleto = true;

                  /*
                    Se eliminó el uso de plan_pago_mora 10-06-2009
                  */

                  update
                         plan_pago_cuota
                  set
                         fecha_ultima_mora = p_fecha_realizacion
                  where
                         plan_pago_cuota.id = _plan_pago_cuota.id;

                  /*
                   Insert de plan_pago_mora debido a cancelación de la totalidad de la mora y por lo
                   tanto se actualiza la nueva fecha para calculo de mora
                  */

                  --insert into plan_pago_mora(plan_pago_cuota_id, tasa_valor, fecha_inicio, fecha_fin, capital,valor) values(_plan_pago_cuota.id, 0, p_fecha_realizacion, p_fecha_realizacion, 0,2);

                end if;          --> if (_remanente_por_aplicar >= _deuda_capital)  then

                _remanente_por_aplicar = _remanente_por_aplicar - _pago_capital;

                raise notice 'pago_capital ____________%', _pago_capital;
                raise notice 'remanente_por_aplicar ____________%', _remanente_por_aplicar;

              else

                _pago_incompleto = true;

              end if;           ---> if (_remanente_por_aplicar > 0)  then

               --raise notice 'remanente_por_aplicar despues de capital___________________%',_remanente_por_aplicar;

            end if;             ---> if _pago_incompleto = false and _deuda_capital > 0 then

            /*
            -----------------------------------------------------------------------
            Diego Bertaso
            Se resta el monto de mora exonerada del remanente por aplicar despues
            de haberse descargado cada uno de los rubros que conforman la cuota
            fecha: 20/08/2007
            -----------------------------------------------------------------------
            */

            /*

            if _p_exonerar_mora = true then

               _mora_exonerada = _deuda_interes_mora;

               raise notice 'Entro por exonerar mora = true___________________%',_deuda_interes_mora;

               if (_deuda_interes_mora > 0) then

                 raise notice 'Entro por mora exonerada mayor que cero___________________%',_mora_exonerada;

                 if (_remanente_por_aplicar >= _mora_exonerada)  then

                   raise notice 'Entro por remanente mayor = que la mora___________________%',_mora_exonerada;

                   _remanente_por_aplicar = _remanente_por_aplicar - _mora_exonerada;
                 else
                   raise notice 'Entro por remanente menor que la mora___________________%',_mora_exonerada;
                   _mora_exonerada = _remanente_por_aplicar;
                   _remanente_por_aplicar = _remanente_por_aplicar - _mora_exonerada;

                 end if;

                 raise notice 'resultado despues del calculo del remanente__________________%',_remanente_por_aplicar;
               end if;
             end if;

             ---> Fin de la Modificacion
            */

            --if _remanente_por_aplicar < 1 then
            --  _remanente_por_aplicar = 0;
            --end if;

            if _pago_incompleto = true then

              if (_pago_interes_diferido + _pago_interes_mora + _pago_interes_desembolso + _pago_interes_corriente + _pago_capital) > 0 then
                _estatus_pago = 'P';
              else
                _estatus_pago = _plan_pago_cuota.estatus_pago;
              end if;
            else
                _estatus_pago = 'T';

            /* Una vez que la cuota este totalmente pagada se elimina el plan pago mora de la cuota */

             --delete from plan_pago_mora where plan_pago_cuota_id = _plan_pago_cuota.id;
            end if;


            --_remanente_por_aplicar_cuota = _remanente_por_aplicar - _prestamo.remanente_por_aplicar;


            --_pago_cuota_total = _pago_interes_diferido + _pago_interes_mora + _pago_interes_desembolso +
            --_pago_interes_corriente + _pago_capital + _remanente_por_aplicar_cuota;




            --_pago_real_interes_diferido = _pago_interes_diferido -_plan_pago_cuota.pago_interes_diferido;
            --_pago_real_interes_mora = _pago_interes_mora -_plan_pago_cuota.pago_interes_mora;
            --_pago_real_interes_corriente = _pago_interes_corriente -_plan_pago_cuota.pago_interes_corriente;
            --_pago_real_interes_desembolso = _pago_interes_desembolso -_plan_pago_cuota.pago_interes_desembolso;
            --_pago_real_capital = _pago_capital -_plan_pago_cuota.pago_capital;


            _pago_real_interes_diferido = _pago_interes_diferido ;
            _pago_real_interes_mora = _pago_interes_mora ;
            _pago_real_interes_corriente = _pago_interes_corriente ;
            _pago_real_interes_desembolso = _pago_interes_desembolso ;
            _pago_real_capital = _pago_capital ;


            _pago_cuota_total =
             _pago_real_interes_diferido
              + _pago_real_interes_mora
              + _pago_real_interes_desembolso
              + _pago_real_interes_corriente
              + _pago_real_capital;

            -- Actualiza la cuota

            raise notice 'Remanente por Aplicar %, % ', _remanente_por_aplicar, _plan_pago_cuota.id;

            update
                    plan_pago_cuota
            set
                    pago_interes_diferido = pago_interes_diferido +  _pago_interes_diferido,
                    pago_interes_mora = pago_interes_mora + _pago_interes_mora,
                    pago_interes_desembolso = pago_interes_desembolso + _pago_interes_desembolso,
                    pago_interes_corriente = pago_interes_corriente+ _pago_interes_corriente,
                    pago_capital = pago_capital + _pago_capital,
                    mora_exonerada = mora_exonerada + _mora_exonerada,
                    --remanente_por_aplicar = _remanente_por_aplicar_cuota,
                    estatus_pago = _estatus_pago
            where
                    id = _plan_pago_cuota.id;

            insert into pago_cuota (plan_pago_cuota_id, pago_prestamo_id,
                                    monto, interes_corriente, interes_diferido,
                                    interes_mora, interes_desembolso, capital, remanente_por_aplicar)
                        values
                                   (_plan_pago_cuota.id, _pago_prestamo_id, _pago_cuota_total,
                                    _pago_real_interes_corriente, _pago_real_interes_diferido,
                                    _pago_real_interes_mora, _pago_real_interes_desembolso,
                                    _pago_real_capital, _remanente_por_aplicar);

            -- insert into pago_cuota (plan_pago_cuota_id, pago_prestamo_id,
            --  monto, interes_corriente, interes_diferido, interes_mora, interes_desembolso, capital)
            -- values(_plan_pago_cuota.id, _pago_prestamo_id, _pago_cuota_total,
            -- _pago_interes_corriente, _pago_interes_diferido, _pago_interes_mora, _pago_interes_desembolso,
            -- _pago_capital);

            _pago_cuota_id = currval('pago_cuota_id_seq');

            --INICIO CONTABILIDAD

            _pago_acumulado_interes_mora = _pago_acumulado_interes_mora + _pago_real_interes_mora;

            _con_monto_capital_cuota = _con_monto_capital_cuota + _pago_real_capital;
            _con_monto_intereses_por_cobrar = _con_monto_intereses_por_cobrar + _plan_pago_cuota.intereses_por_cobrar_al_30;


           if _pago_real_interes_corriente > 0 then

             _con_monto_ingreso_intereses = _con_monto_ingreso_intereses + (_pago_real_interes_corriente - _plan_pago_cuota.intereses_por_cobrar_al_30);
             raise notice 'con_monto_ingreso_intereses-----------------------%',_con_monto_ingreso_intereses;
           end if;

           if _pago_real_interes_desembolso > 0 then

             _con_monto_ingreso_intereses = _con_monto_ingreso_intereses + _pago_real_interes_desembolso;
           end if;

           --Diego Bertaso (Se incluyo pago de interes diferido)

           if _deuda_interes_diferido > 0 then
              _con_monto_ingreso_intereses = _con_monto_ingreso_intereses;
           end if;



           --FIN CONTABILIDAD
           --raise notice '******************************* STEP 1';

      end loop;

      /*
      ---------------------------------------------------------------------------
      Se incluye la llamada a calcular_mora para recalcular la mora despues
      de haber efectuado todos los pagos
      ---------------------------------------------------------------------------
      */

      _fecha_calculo = p_fecha;

      perform calcular_cuotas_vencidas(_prestamo_id,p_fecha,false);


      /*
      --------------------------------------------------------------
      Si el remanente por aplicar es mayor que cero se procede
      a la verificación de abono a capital/cancelación de préstamo
      y si aplica la generación de una nueva tabla de amortización
      --------------------------------------------------------------
      */

      select into
                _plan_pago *
      from
                plan_pago
      where
                plan_pago.prestamo_id = _prestamo_id and
                activo = true;

      if not found then

         raise notice 'No existe plan_pago del prestamo Nro.   %', _prestamo.numero;
         return false;
      end if;

      raise notice 'Prestamo Estatus   %, % ', _estatus_ini, _prestamo.estatus;

      _estatus = _prestamo.estatus;

      if (_remanente_por_aplicar > 0) then

        raise notice 'Entro al if _remanente_por_aplicar       %', _remanente_por_aplicar;

        if _plan_pago_cuota.id is not null then

          raise notice 'Entro por plan pago cuota is not null ';

          if _plan_pago_cuota.saldo_insoluto > 0 then

            /*
            -----------------------------------------------------------------------------
            Remanente por aplicar menor o igual que saldo insoluto de la ultima cuota
            pagada, se procede con la generacion de la nueva tabla de amortización
            tomando como base la fecha de la ultima cuota pagada y su saldo insoluto
            -----------------------------------------------------------------------------
            */

            if _remanente_por_aplicar <= _plan_pago_cuota.saldo_insoluto then

              /*  Abono a Capital */

              _abono_capital = _remanente_por_aplicar;
              _con_monto_capital_cuota = _con_monto_capital_cuota + _abono_capital;
              _remanente_por_aplicar = 0;

            end if;      ---> _remanente_por_aplicar  <= _plan_pago_cuota_ultima.saldo_insoluto then

          end if;    ---> if _plan_pago_cuota.saldo_insoluto > 0 then

        end if;   ---> _plan_pago_cuota.id is not null then

        if _plan_pago_cuota.saldo_insoluto is null then

          raise notice 'Entro por saldo insoluto is null --------------------------->';

          select into
                  _plan_pago_cuota *
          from
                  plan_pago_cuota
          where
                  plan_pago_cuota.plan_pago_id = _plan_pago.id and
                  plan_pago_cuota.tipo_cuota = 'C' and
                  plan_pago_cuota.estatus_pago = 'T'
          order by
                  fecha desc
          limit 1;

          if found then

            raise notice 'Entro por if found --------------------------->';

            if _plan_pago_cuota.saldo_insoluto > 0 then

              RAISE NOTICE 'Entro por ultima cuota saldo_insoluto > 0   %', _estatus_ini;

              /*
              -----------------------------------------------------------------------------
              Remanente por aplicar menor o igual que saldo insoluto de la ultima cuota
              pagada, se procede con la generacion de la nueva tabla de amortización
              tomando como base la fecha de la ultima cuota pagada y su saldo insoluto
              -----------------------------------------------------------------------------
              */

              if _remanente_por_aplicar  <= _plan_pago_cuota.saldo_insoluto then

                 /*  Abono a Capital */

                 _abono_capital = _remanente_por_aplicar;
                 _con_monto_capital_cuota = _con_monto_capital_cuota + _abono_capital;
                 _remanente_por_aplicar = 0;

               end if;      ---> _remanente_por_aplicar  <= _plan_pago_cuota_ultima.saldo_insoluto then

             end if;    ---> if _plan_pago_cuota.saldo_insoluto > 0 then

           else

             select into
                   _plan_pago_cuota *
             from
                   plan_pago_cuota
             where
                   plan_pago_cuota.plan_pago_id = _plan_pago.id and
                   plan_pago_cuota.tipo_cuota = 'G'
             order by
                  fecha desc
             limit 1;

             if found then

               if _plan_pago_cuota.saldo_insoluto > 0 then

                 RAISE NOTICE 'Entro por ultima cuota saldo_insoluto > 0   %', _estatus_ini;

                 /*
                 -----------------------------------------------------------------------------
                 Cuando el pago en situación vigente se produce antes del vencimiento de la
                 primera cuota se toma con referencia el saldo de la primera cuota vigente
                 -----------------------------------------------------------------------------
                 */

                 if _remanente_por_aplicar  <= _plan_pago_cuota.saldo_insoluto then

                   /*  Abono a Capital */

                   _abono_capital = _remanente_por_aplicar;
                   _con_monto_capital_cuota = _con_monto_capital_cuota + _abono_capital;
                   _remanente_por_aplicar = 0;

                 end if;      ---> _remanente_por_aplicar  <= _plan_pago_cuota_ultima.saldo_insoluto then

               end if;    ---> if _plan_pago_cuota.saldo_insoluto > 0 then

             else

               if _remanente_por_aplicar  <= _plan_pago_cuota.saldo_insoluto then

                /*  Abono a Capital */

                _abono_capital = _remanente_por_aplicar;
                _con_monto_capital_cuota = _con_monto_capital_cuota + _abono_capital;
                _remanente_por_aplicar = 0;

               end if;      ---> _remanente_por_aplicar  <= _plan_pago_cuota_ultima.saldo_insoluto then

             end if;  ---> if found lectura plan tipo_cuota = 'G'

           end if;    ---> if found then

        end if;  ---> if _plan_pago_cuota.saldo_insoluto is null then


          _fecha_calculo = p_fecha;

      end if;  ----> if (_remanente_por_aplicar > 0) then


      update
             pago_prestamo
      set
             interes_diferido = _pago_acumulado_interes_diferido,
             interes_mora = _pago_real_interes_mora,
             interes_desembolso = _pago_acumulado_interes_desembolso,
             interes_corriente = _pago_acumulado_interes_corriente,
             capital = _pago_acumulado_capital,
             remanente_por_aplicar = _remanente_por_aplicar,
             monto = _pago_monto_prestamo
      where
             id = _pago_prestamo_id;


      --raise notice '******************************* SETP 2';
      update prestamo set remanente_por_aplicar = _remanente_por_aplicar,
                          abono_capital = _abono_capital,
                          estatus = _estatus
        where id = _prestamo_id;

      if p_proceso_nocturno = false then
        perform calcular_prestamo(_prestamo_id, p_fecha, false);

        select into
                  _prestamo_post *
        from
                  prestamo
        where
                  prestamo.id = p_prestamo_id;

        RAISE NOTICE 'SALDO INSOLUTO DESPUES CALCULAR PRESTAMO ==========> % ', _prestamo_post.saldo_insoluto;

        perform calcular_mora_mod(_prestamo_id, p_fecha, _fecha_calculo, false,1);
        raise notice 'Prestamo Estatus   (despues calcular préstamo ) %, % ', _estatus, _prestamo.estatus;
        _monto_factura = p_monto;
      else
        _monto_factura = _remanente_por_aplicar_inicial - _remanente_por_aplicar;
      end if;


      select into
                  _prestamo_post *
      from
                  prestamo
      where
                  prestamo.id = p_prestamo_id;

      if _estatus <> 'C' then

        _estatus = _prestamo_post.estatus;

         raise notice 'Prestamo Estatus   (estatus diferente de C ) %, % ', _estatus, _prestamo_post.estatus;
      end if;

      raise notice 'Estatus del prestamo antes de la factura   %', _estatus;

      if  not (_remanente_por_aplicar =  _remanente_por_aplicar_inicial and p_proceso_nocturno = true ) then

        _sector_economico = (SELECT get_datos_cliente(_prestamo_post.cliente_id, 'sector_economico'));
        _estado_prestamo = (SELECT resolver_estatus(_estatus));
        _distincion_cobranza = (SELECT get_tipo_pago(_pago_cliente_id));
        _analista = p_analista_nombre_completo;

        raise notice 'Estatus del prestamo despues de leer %', _prestamo_post.estatus;

        perform generar_factura((select ultima_factura from parametro_general) + 1, _monto_factura, p_fecha,
                                 p_fecha_realizacion, _pago_cliente_id, p_tipo_pago, p_proceso_nocturno,
                                 _prestamo_id, _remanente_por_aplicar, _prestamo.tipo_cartera_id,
                                 _prestamo.codigo_contable, _sector_economico, _estatus,
                                 p_observaciones_analista, _distincion_cobranza, _analista,
                                 p_consultoria_juridica, _abono_capital, p_recuperaciones);

     -- select into _factura * from factura order by id desc limit 1;

      _factura_id = currval('factura_id_seq');

      --_factura_id = _factura.id;

      raise notice 'factura_id__%',_factura_id;


      update parametro_general set ultima_factura = ultima_factura + 1;

    end if;   ---> if  not (_remanente_por_aplicar =  _remanente_por_aplicar_inicial and p_proceso_nocturno = true ) then

    raise notice '******************************* STEP 3';


    select into
                _prestamo *
    from
                prestamo
    where
                id = _prestamo_id;

    raise notice 'situacion___%',_prestamo_post.estatus;

    raise notice 'pago_acumulado_interes_mora______________%',_pago_acumulado_interes_mora;
   -- raise exception 'error';
    if p_modalidad = 'B' then
      _monto_factura = _monto_factura - _con_monto_comision_intermediario;
    end if;

    if _prestamo.intermediado = true then
      --_con_monto_ingreso_intereses = _con_monto_ingreso_intereses - (_pago_real_interes_corriente
    end if;

   _anio_1 = extract (year from p_fecha);


   if p_cancelacion_prestamo = false then

       -- INICIO CONTABILIDAD

       select
       into
                _entidad_financiera *
       from
                entidad_financiera
       where
                entidad_financiera.id = p_entidad_financiera_id;

       raise notice 'ENTRO POR PAGO AV______________%',cast(_con_monto_intereses_por_cobrar as float);

        RAISE NOTICE '(DEL PAGO) MONTO CAPITAL CUOTA %', _con_monto_capital_cuota;
        RAISE NOTICE '(DEL PAGO) MONTO INGRESO INTERESES %', _con_monto_ingreso_intereses;
        RAISE NOTICE '(DEL PAGO) MONTO INTERES DIFERIDO %', _pago_acumulado_interes_diferido;
        RAISE NOTICE '(DEL PAGO) MONTO INGRESO MORA %', _pago_acumulado_interes_mora;

       if _estatus_ini = 'H' then
          _estatus_ini = 'V';
       end if;



       perform registro_contable('PAGO CUOTA',
            cast(p_modalidad as varchar),
            _fuente_recursos_id,
            _sector_economico_id,
            _estatus_ini,
            p_entidad_financiera_id,
            cast(_monto_factura as float),
            _con_monto_ingreso_intereses ,
            _con_monto_intereses_por_cobrar,
            _remanente_por_aplicar,
            _con_monto_capital_cuota,
            _pago_acumulado_interes_mora,
            _con_remanente_por_aplicar_inicial,
            _con_monto_comision_intermediario,
            _pago_acumulado_interes_diferido,
            0,
            p_fecha,
            p_fecha_realizacion,
            _prestamo.id,
            _factura_id,
            _anio_1,
            p_numero_voucher,
            _entidad_financiera.nombre,
            _nombre_cliente,
            'Pago de Cuota',
            cast(_prestamo.numero as character varying),
            _prestamo.reestructurado,
            _transaccion_id);


    end if;            ---> if p_cancelacion_prestamo = false then

    close _cur_plan_pago_cuota;

    if (_estatus_ini = 'E') then

      if (_prestamo.estatus = 'V' or
          _prestamo.estatus = 'H') then

        RAISE NOTICE 'Entro en el proceso de pase a vigente';

        RAISE NOTICE 'ENTRO A PROCESAR EL REGISTRO CONTABLE=========>';

        perform registro_contable('PASE VIGENTE',
             'N',
             _fuente_recursos_id,
             _sector_economico_id,
             'P',
             p_entidad_financiera_id,
             0,
             0,
             0,
             0,
             _prestamo.saldo_insoluto,
             0,
             0,
             0,
             0,
             0,
             p_fecha,
             p_fecha_realizacion,
             _prestamo.id,
             _factura_id,
             _anio_1,
             p_numero_voucher,
             _entidad_financiera.nombre,
             _nombre_cliente,
             'Pase de Vencido a Vigente',
             cast(_prestamo.numero as character varying),
             _prestamo.reestructurado,
             _transaccion_id);

      end if;

    end if;

    raise notice '******************************* STEP 4';
    raise notice '____________________EJECUTO EL SP DE CONTABILIDAD';

    -- FIN CONTABILIDAD


    update
           prestamo
    set
           estatus = 'C'
    where
           prestamo.saldo_insoluto = 0 and
           prestamo.id = _prestamo.id;


    /*
    -------------------------------
    Calculo de montos recuperados
    -------------------------------
    */

    if _abono_capital = 0 then
        perform calcular_montos_recuperados(p_prestamo_id,false);
    end if;

    return _factura_id;


    end;  ---> Begin

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;

