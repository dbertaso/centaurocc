-- Function: actualizacion_indicadores_cobranzas(p_prestamo_id integer, p_fecha date);

--DROP FUNCTION if exists actualizacion_indicadores_cobranzas(p_prestamo_id integer, p_fecha date);

CREATE OR REPLACE FUNCTION  actualizacion_indicadores_cobranzas(p_prestamo_id integer, p_fecha date) RETURNS integer AS

$BODY$

  declare
    
     -- Variables para el cálculo de indicadores
     
    _cantidad_cuotas_amortizacion integer = 0;
    _total_dias_prestamo integer = 0;
    _capital_cuotas_fecha numeric(16,2) = 0;   -- Sumatoria del capital de las cuotas vencidas a la fecha del cierre
    _porcentaje_recuperacion_esperada_capital numeric(6,2) = 0;
    _porcentaje_recuperacion_real_capital numeric(6,2) = 0;
    _dias_atraso_pagos integer = 0;   -- Sumatoria de los días de atraso en los pagos a la fecha
    _cantidad_pagos integer = 0;  --Cantidad de pagos realizados por el cliente a la fecha del cierre
    _total_interes_prestamo numeric(16,2) = 0; --Sumatoria de los intereses de todas las cuotas del préstamo
    _interes_cuotas_fecha numeric(16,2) = 0;   --Sumatoria de los intereses de las cuotas vencidas a la fecha del cierre
    _porcentaje_recuperacion_esperada_intereses numeric(16,2) = 0;
    _porcentaje_recuperacion_real_intereses numeric(16,2) = 0;
    _cantidad_cuotas_exigibles integer = 0;
    _cantidad_total_cuotas integer = 0;
    _total_financiamiento numeric(16,2) = 0;
    _cantidad_promesas_incumplidas integer = 0;
    _porcentaje_promesas_incumplidas numeric(5,2) = 0;
    
    _porcentaje_veces_mora numeric(6,2) = 0;
    _porcentaje_dias_mora numeric(6,2) = 0;
    _indice_morosidad numeric(6,2) = 0;
    _desviacion_recuperacion_capital numeric(6,2) = 0;
    _dias_atraso_promedio numeric(6,2) = 0;
    _desviacion_recuperacion_intereses numeric(6,2) = 0;
    _porcentaje_pagos_incumplidos numeric(6,2) = 0;
    
    
    -- Variables para registros de tablas leidas
    
    _prestamo prestamo%rowtype;
    _plan_pago plan_pago%rowtype;
    _plan_pago_cuota plan_pago_cuota%rowtype;
    _solicitud solicitud%rowtype;
    _compromiso_pago compromiso_pago%rowtype;
    _performance_cobranzas performance_cobranzas%rowtype;
    _numero_error integer = 0;
  begin
  
    /*
    ----------------------
    Lectura del préstamo
    ----------------------
    */
    
    select
    into
            _prestamo *
    from
            prestamo
    where
            id = p_prestamo_id;
            
            
    if not found then
      
      --RETURN cast(10100 as integer);       --> Préstamo no existe
      _numero_error = 10100;
    end if;
    
    /*
    --------------------------------------------p_fecha
    Lectura del trámite asociado al préstamo
    --------------------------------------------
    */
    
    select
    into
            _solicitud *
    from
            solicitud 
    where
            id = _prestamo.solicitud_id;
            
    if not found then
    
      --RETURN cast(10300 AS integer);   ----> 'Solicitud no existe'
      _numero_error = 10300;
    end if;
    
    /*
    -----------------------------------------
    Cálculo del monto todal del financimiento
    del crédito
    -----------------------------------------
    */
    
    if _solicitud.por_inventario = true then
    
      _total_financiamiento = _prestamo.monto_liquidado + _prestamo.monto_sras_total + _prestamo.monto_gasto_total;
    else
      _total_financiamiento = _prestamo.monto_liquidado + _prestamo.monto_insumos + _prestamo.monto_sras_total +
                              _prestamo.monto_gasto_total;
    end if;
    
    /*
    --------------------------------------------
    Lectura del plan_pago asociado al préstamo
    --------------------------------------------
    */
    
    select
    into
            _plan_pago *
    from
            plan_pago
    where
            prestamo_id = p_prestamo_id and
            activo = true;
            
    if not found then
      --RETURN cast(10200 as integer);         --> Plan Pago no existe
      _numero_error = 10200;
    end if;
    
    /*
    --------------------------------------------
    Cálculo del capital de las cuotas vencidas
    a la fecha
    --------------------------------------------
    */
    
    
    select
    into
            _capital_cuotas_fecha sum(amortizado)
    from
            plan_pago_cuota
    where
            plan_pago_id = _plan_pago.id and
            fecha <= p_fecha and
            tipo_cuota = 'C';

    select
    into
            _interes_cuotas_fecha sum(interes_corriente + interes_diferido)
    from
            plan_pago_cuota
    where
            plan_pago_id = _plan_pago.id and
            fecha <= p_fecha and
            tipo_cuota = 'C';
    
    if found then
      if _capital_cuotas_fecha is null then
      
        _capital_cuotas_fecha = 0;
      end if;     

      if _interes_cuotas_fecha is null then
      
        _interes_cuotas_fecha = 0;
      end if; 
    end if; 
    
            
    /*
    -------------------------------------------
    Sumatoria de los días de atraso en los 
    pagos
    -------------------------------------------
    */
    
    select
    into
          _dias_atraso_pagos sum(dias_atraso)
    from
          pago_cuota
              inner join pago_prestamo on (pago_cuota.pago_prestamo_id = pago_prestamo.id)
              inner join prestamo on (pago_prestamo.prestamo_id = prestamo.id and
                                        prestamo.id = _prestamo.id)
    where
          pago_cuota.fecha_pago <= p_fecha;
              
    if _dias_atraso_pagos is null then
      _dias_atraso_pagos = 0;
    end if;
  
    /*
    --------------------------------
    Conteo de los pagos realizados
    --------------------------------
    */
    
    select
    into 
            _cantidad_pagos count(id) 
    from
            pago_prestamo
    where
            prestamo_id = p_prestamo_id;
            
    if _cantidad_pagos is null then
    
      _cantidad_pagos = 0;
    end if;
            
    -- Cantidad de cuotas del préstamo
    
    if _prestamo.frecuencia_pago = 0 then
      _cantidad_cuotas_amortizacion = _prestamo.plazo / _prestamo.plazo;
    else
      _cantidad_cuotas_amortizacion = _prestamo.plazo / _prestamo.frecuencia_pago;
    end if;
    
    -- Total días del préstamo
    
    raise notice 'Cantidad cuotas amortización ==============> % % % %', _prestamo.plazo, _prestamo.frecuencia_pago, _cantidad_cuotas_amortizacion, _cantidad_pagos;
    _total_dias_prestamo = _prestamo.plazo * 30;
    
    /*
    -----------------------------------------------------
    Cáculo de los indicadores de cobranzas del prestamo
    -----------------------------------------------------
    */
    
    if _cantidad_cuotas_amortizacion > 0 then
        _porcentaje_veces_mora = (_prestamo.cantidad_veces_mora / _cantidad_cuotas_amortizacion) * 100;
    else
        _porcentaje_veces_mora = 0;
    end if;

    if _total_dias_prestamo > 0 then
        _porcentaje_dias_mora = (_prestamo.cantidad_dias_mora_acumulados / _total_dias_prestamo) * 100;
    else
        _porcentaje_dias_mora = 0;
    end if;

    if _prestamo.monto_liquidado > 0 then
        _indice_morosidad = (_prestamo.capital_vencido / _total_financiamiento) * 100;
    else
        _indice_morosidad = 0;
    end if;

    if _total_financiamiento > 0 then
      _porcentaje_recuperacion_real_capital = (_prestamo.capital_pagado / _total_financiamiento) * 100;
      _porcentaje_recuperacion_esperada_capital = (_capital_cuotas_fecha / _total_financiamiento) * 100;
    else
      _porcentaje_recuperacion_real_capital = 0;
      _porcentaje_recuperacion_esperada_capital = 0;
    end if;

    _desviacion_recuperacion_capital = _porcentaje_recuperacion_esperada_capital - _porcentaje_recuperacion_real_capital;

    if _cantidad_pagos > 0 then
      _dias_atraso_promedio = _dias_atraso_pagos / _cantidad_pagos;
    else
      _dias_atraso_promedio = _dias_atraso_pagos;
    end if;

    if _prestamo.total_interes > 0 then
      _porcentaje_recuperacion_real_intereses = (_prestamo.intereses_pagados / _prestamo.total_interes) * 100;
      _porcentaje_recuperacion_esperada_intereses = (_interes_cuotas_fecha / _prestamo.total_interes) * 100;
    else
      _porcentaje_recuperacion_real_intereses = 0;
      _porcentaje_recuperacion_esperada_intereses = 0;
    end if;

    if _porcentaje_recuperacion_real_intereses > 0 then
      _desviacion_recuperacion_intereses = _porcentaje_recuperacion_esperada_intereses - _porcentaje_recuperacion_real_intereses;
    else
      _desviacion_recuperacion_intereses = 0;
    end if;

    if _cantidad_cuotas_amortizacion > 0 then
      _porcentaje_pagos_incumplidos = _prestamo.cantidad_cuotas_vencidas / _cantidad_cuotas_amortizacion;
    else
      _porcentaje_pagos_incumplidos = 0;
    end if;

    /*
    -----------------------------------------------------
    Verificación de vencimiento del compromiso de pago
    -----------------------------------------------------
    */

    select
    into
          _compromiso_pago *
    from
          compromiso_pago
    where
          prestamo_id = _prestamo.id and
          estatus = 'E';

    if found then

      if p_fecha  >= _compromiso_pago.fecha_limite_pago then

        /*
        ----------------------------------------------------
        Actualización del compromiso de pago a no cumplido
        ----------------------------------------------------
        */

        update
                compromiso_pago

        set
                estatus = 'N'
        where
                id = _compromiso_pago.id;


        /*
        -----------------------------------------------
        Lectura del registro de performance_cobranzas
        -----------------------------------------------
        */

        select
        into
                _performance_cobranzas *
        from
                performance_cobranzas
        where
                prestamo_id = _prestamo.id and
                cliente_id = _prestamo.cliente_id;

        if found then

          _cantidad_promesas_incumplidas = _performance_cobranzas.cantidad_promesas_incumplidas + 1;
          _porcentaje_promesas_incumplidas = _cantidad_promesas_incumplidas / _performance_cobranzas.cantidad_promesas_pago * 100;

          /*
          -------------------------------------------------------
          Actualización de performance_cobranzas
          -------------------------------------------------------
          */

          update
                  performance_cobranzas
          set

                  cantidad_promesas_incumplidas = _cantidad_promesas_incumplidas,
                  porcentaje_promesas_pago_incumplidas = _porcentaje_promesas_incumplidas
          where
                  id = _performance_cobranzas.id;

        end if;

      end if;
    end if;
    
    /*
    ---------------------------------------
    Actualización de indicadores en el 
    préstamo
    ---------------------------------------
    */
    
    update
            prestamo
    set
            porcentaje_veces_mora = _porcentaje_veces_mora,
            porcentaje_dias_mora = _porcentaje_dias_mora,
            indice_morosidad = _indice_morosidad,
            porcentaje_recuperacion_real_capital = _porcentaje_recuperacion_real_capital,
            porcentaje_recuperacion_esperada_capital = _porcentaje_recuperacion_esperada_capital,
            desviacion_recuperacion_capital = _desviacion_recuperacion_capital,
            dias_atraso_promedio = _dias_atraso_promedio,
            porcentaje_recuperacion_real_intereses = _porcentaje_recuperacion_real_intereses,
            porcentaje_recuperacion_esperado_intereses = _porcentaje_recuperacion_esperada_intereses,
            desviacion_recuperacion_intereses = _desviacion_recuperacion_intereses,
            porcentaje_pagos_incumplidos = _porcentaje_pagos_incumplidos
    where
            id = _prestamo.id;
  
    RETURN _numero_error;
    
  end;
    
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;  
