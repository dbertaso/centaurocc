/*
-------------------------------------------------------------------------------------------------
  Función para agregar monto de insumos a la tabla de amortización el cual no fue agregado
  durante el proceso de liquidación
  
  Esta función debe ser ejecutada una sola vez.
-------------------------------------------------------------------------------------------------
*/ 

  CREATE OR REPLACE FUNCTION generar_plan_pago_insumos_pesca() 
  
  RETURNS boolean AS
  $BODY$

  declare
  
    _prestamo prestamo%rowtype;
    _factura factura%rowtype;
    _orden_despacho orden_despacho%rowtype;
    _plan_pago plan_pago%rowtype;
    _plan_pago_cuota plan_pago_cuota%rowtype;
    _plan_pago_cuota_ultima plan_pago_cuota%rowtype;
    _cur_plan_pago_cuota refcursor;
    _cur_prestamo refcursor;
    _monto_insoluto numeric(16,2) = 0;
    _fecha_corte date;
    _fecha_inicio date;
    _fecha_calculo date;
    _plan_pago_id integer;
    _plan_pago_cuota_id integer;
    
  begin
  
    open
        _cur_prestamo
    for
        select  
               prestamo.*
        from 
                prestamo_temporal prestamo
                  inner join solicitud on (solicitud.id = prestamo.solicitud_id)
                  inner join unidad_produccion up on (solicitud.unidad_produccion_id = up.id)
                  inner join ciudad on (up.ciudad_id = ciudad.id)
                  inner join estado on (ciudad.estado_id = estado.id)
        where 
                monto_insumos > 0 and
                monto_facturado > 0 and 
                monto_despachado > 0 and monto_facturado = monto_despachado and 
                monto_liquidado_insumos = 0 and 
                solicitud.estatus_id in (10090) and 
                prestamo.estatus <> 'C' and
                saldo_insoluto <= (monto_banco + monto_insumos + monto_sras_total + monto_gasto_total)
        order by  
                prestamo.id;
                
    loop
    
      fetch _cur_prestamo INTO _prestamo;
      exit when not found;
      
      /*
      -----------------------
      Lectura de plan pago
      -----------------------
      */
      raise notice 'Prestamo Número ---------> %', _prestamo.numero;

      select 
      into 
            _plan_pago *
      from
            plan_pago
      where
            plan_pago.prestamo_id = _prestamo.id and
            plan_pago.activo = true;
            
      if found then
      
        /*
        ---------------------------------------------------------------
        Búsquea de la última cuota pagada del periodo de amortizacion
        ---------------------------------------------------------------
        */   
           
        select into
                 _plan_pago_cuota_ultima *
          from
                 plan_pago_cuota
          where
                 plan_pago_cuota.plan_pago_id = _plan_pago.id and
                 plan_pago_cuota.tipo_cuota = 'C'  and
                 plan_pago_cuota.estatus_pago = 'T'
          order by
                 fecha desc
          limit 1;

        if found then

          _fecha_inicio = _plan_pago_cuota_ultima.fecha;

        end if;

        /*
        -------------------------------------------------------------
        Si no tiene cuotas pagadas en el périodo de amortizacion
        se toma como referencia la fecha de la ultima cuota del
        periodo de gracia
        -------------------------------------------------------------
        */

        if not found then

          select into
               _plan_pago_cuota_ultima *
          from
               plan_pago_cuota
          where
               plan_pago_cuota.plan_pago_id = _plan_pago.id and
               plan_pago_cuota.tipo_cuota = 'G' and
               plan_pago_cuota.estatus_pago = 'T'
          order by
               fecha desc
          limit 1;

          if found then

            _fecha_inicio = _plan_pago_cuota_ultima.fecha;

          else
            _fecha_inicio = _prestamo.fecha_liquidacion;

          end if;

        end if;


        if _prestamo.monto_facturado > 0 then
       
          update
                prestamo
          set
                monto_liquidado_insumos = monto_liquidado_insumos + _prestamo.monto_facturado
          where
                id = _prestamo.id;

        end if;
  
        if _prestamo.monto_facturado > 0 and
           _prestamo.frecuencia_pago > 0 then


          raise notice 'FECHA INICIO ===================================> %', _fecha_inicio;

          perform generar_plan_pago_evento(false, _prestamo.id, _fecha_inicio,
                                           true, _prestamo.monto_facturado, false, 0, false, 0, 0, 0, 0, 0, 0, 0);

        end if;
        
      else
      
        select 
        into
                _orden_despacho *
        from
                orden_despacho
        where
                prestamo_id = _prestamo.id;
                
        if found then 
        
          raise notice 'Fecha orden despacho ============> %', _orden_despacho.fecha_orden_despacho;
          raise notice 'Frecuencia de pago ==============> %', _prestamo.frecuencia_pago;
          raise notice 'Plazo ===========================> %', _prestamo.plazo;
          update 
                  prestamo
          set
                  fecha_liquidacion = _orden_despacho.fecha_orden_despacho
          where
                  id = _prestamo.id;
                  
          if _prestamo.monto_facturado > 0 then
         
            update
                  prestamo
            set
                  monto_liquidado_insumos = monto_liquidado_insumos + _prestamo.monto_facturado
            where
                  id = _prestamo.id;


            perform generar_plan_pago

                  (

                    false,
                    _prestamo.formula_id,
                    _prestamo.id,
                    0,
                    0,
                    'Z',
                    0,
                    0,
                    _orden_despacho.fecha_orden_despacho,
                    _prestamo.monto_facturado,
                    _prestamo.plazo,
                    _prestamo.frecuencia_pago,
                    _prestamo.tasa_inicial,
                    _prestamo.meses_muertos,
                    _prestamo.meses_gracia,
                    0,
                    false,
                    _prestamo.tasa_inicial,
                    _prestamo.frecuencia_pago,
                    0,
                    true,
                    _orden_despacho.fecha_orden_despacho,
                    _prestamo.monto_facturado,
                    0,
                    0,
                    _prestamo.monto_facturado,
                    0);
                    
          end if;   -----> Fin del if _prestamo.monto_facturado > 0 then
          
        end if;     -----> Fin del if found then (select orden_despacho)

      end if;       ----> Fin del if found then (select plan_pago)
      
      perform calcular_prestamo(_prestamo.id, agregar_dias(current_date, -1), false);
      perform calcular_mora_mod(_prestamo.id, agregar_dias(current_date, -1), agregar_dias(current_date, -1), false,0);

    end loop;
    
    close _cur_prestamo;
    
    return true;
    
  end;
  
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
