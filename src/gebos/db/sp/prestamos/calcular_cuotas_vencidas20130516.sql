-- Function: calcular_cuotas_vencidas(integer, date, boolean)

-- DROP FUNCTION calcular_cuotas_vencidas(integer, date, boolean);

CREATE OR REPLACE FUNCTION calcular_cuotas_vencidas(p_prestamo_id integer, p_fecha_evento date, p_proyeccion boolean)
  RETURNS boolean AS
$BODY$

declare

  _plan_pago plan_pago%rowtype;
  _plan_pago_cuota record;
  _cliente cliente%rowtype;
  _persona persona%rowtype;
  _empresa empresa%rowtype;
  _prestamo prestamo%rowtype;
  _solicitud solicitud%rowtype;
  _origen_fondo origen_fondo%rowtype;
  _cur_plan_pago_cuota refcursor;
  _cur_total_cuotas refcursor;
  _parametro parametro_general%rowtype;
  _estado char(1) = 'N';
  _dias_demorado integer = 0;
  _dias_vencido integer = 0;
  _dias_vigente integer = 0;
  _capital_pagado numeric(14,2) = 0;
  _capital_por_pagar numeric(14,2) = 0;
  _cuotas_pagadas integer = 0;
  _cuotas_pendientes integer = 0;
  _total_cuotas integer = 0;
  _fuente_recursos_id integer = 0;
  _sector_economico_id integer = 0;
  _nombre_cliente character varying = '';
  _entidad_financiera entidad_financiera%rowtype;
  _estado_prestamo character varying;
  _distincion_cobranza  character varying = '';
  _analista character varying = '';
  _cantidad_cuotas_vencidas integer = 0;
  _monto_cuotas_vencidas numeric(14,2) = 0;


  begin

    select into
                _parametro *
    from
                parametro_general
    limit 1;

    update
          prestamo
    set
          monto_cuotas_vencidas = 0,
          cantidad_cuotas_vencidas = 0
    where
          id = p_prestamo_id;

    select into
               _prestamo *
    from
               prestamo
    where
              id = p_prestamo_id;



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

    select
    into
           _entidad_financiera *
    from
           entidad_financiera
    where
           entidad_financiera.id = _cliente.entidad_financiera_id;

    select 
    into
          _plan_pago *
    from
          plan_pago
    where
          prestamo_id = p_prestamo_id and
          activo = not(p_proyeccion)  and
          proyeccion = p_proyeccion;


    delete 
    from
            plan_pago_mora
    where
            plan_pago_cuota_id
    in
           (select
                   id
            from
                   plan_pago_cuota
            where
                   plan_pago_id =  _plan_pago.id and
                   fecha      >  p_fecha_evento and
                   estatus_pago =  'N' and
                   tipo_cuota   <> 'M' and
                   (vencida = true or
                    vencida = false))  and
                   plan_pago_mora.valor = 1;

    update
           plan_pago_cuota
    set
           estatus_pago = 'X',
           vencida = false,
           interes_mora = 0,
           dias_mora = 0
    where
           plan_pago_id = _plan_pago.id and
           (fecha - p_fecha_evento) > 1 and
           estatus_pago = 'N' and
           tipo_cuota <> 'M' and
           (vencida = true or
            vencida = false);

    open _cur_plan_pago_cuota for
       select
              sum((valor_cuota + interes_desembolso + cuota_extra)-(pago_interes_corriente + pago_capital  + pago_interes_desembolso + pago_cuota_extra)) as total_monto,
              count(id) as total_cantidad
       from
              plan_pago_cuota
       where
              vencida = true     and
              estatus_pago in ('N','P') and
              tipo_cuota in ('C','G') and
              plan_pago_id = _plan_pago.id;

    fetch _cur_plan_pago_cuota INTO _plan_pago_cuota;

    if found then

      if _plan_pago_cuota.total_monto is not null then
        _cantidad_cuotas_vencidas = _cantidad_cuotas_vencidas + _plan_pago_cuota.total_cantidad;
        _monto_cuotas_vencidas = _monto_cuotas_vencidas +  _plan_pago_cuota.total_monto;
         --raise notice 'Monto Cuotas Vencidas Gracia ==============> %', _monto_cuotas_vencidas;
         --raise notice 'Monto Cuotas Vencidas Gracia DB ===========> %', _plan_pago_cuota.total_monto;
      end if;

    end if;

    close _cur_plan_pago_cuota;

    if p_proyeccion = false then

      _estado = _prestamo.estatus;

       /*
       --------------------------------
       Cursor de total cuotas pagadas
       --------------------------------
       */

      open _cur_plan_pago_cuota for

         select
               sum(pago_capital) as capital_pagado,
               count(id) as cantidad_pagadas
         from
               plan_pago_cuota

         where
               estatus_pago = 'T' and
               plan_pago_id = _plan_pago.id;


      fetch _cur_plan_pago_cuota INTO _plan_pago_cuota;

        --raise notice 'PLAN_PAGO_CUOTA.CANTIDAD_PAGADAS ============> %', _plan_pago_cuota.cantidad_pagadas;
        --raise notice 'PLAN_PAGO_CUOTA.CAPITAL_PAGADO ============> %', _plan_pago_cuota.capital_pagado;

        if _plan_pago_cuota.capital_pagado is not null then
          _cuotas_pagadas = _plan_pago_cuota.cantidad_pagadas;
          _capital_pagado = _plan_pago_cuota.capital_pagado;
        end if;

        --raise notice 'CUOTAS PAGADAS ============> %', _cuotas_pagadas;
        --raise notice 'CAPITAL PAGADO  ============> %', _capital_pagado;

      close _cur_plan_pago_cuota;

      /*
      --------------------------
      Cursor de Cuotas Totales
      --------------------------
      */

      open _cur_plan_pago_cuota for

        select
              count(id) as total_cuotas
        from
              plan_pago_cuota
        where
              plan_pago_id = _plan_pago.id and
              plan_pago_cuota.estatus_pago <> 'D';

        fetch _cur_plan_pago_cuota INTO _plan_pago_cuota;

        if _plan_pago_cuota.total_cuotas is not null then
          _total_cuotas = _plan_pago_cuota.total_cuotas;
        end if;

        --raise notice 'TOTAL CUOTAS  ============> %', _total_cuotas;

      close _cur_plan_pago_cuota;

      _cuotas_pendientes = _total_cuotas - _cuotas_pagadas - _cantidad_cuotas_vencidas;

      if _cantidad_cuotas_vencidas > 0 then
      
        update
                cliente
        set
                moroso = true
        where
                id = _cliente.id;
      else
      
        update
                cliente
        set
                moroso = false
        where
                id = _cliente.id;
        
      end if;

      select
      into
            _plan_pago_cuota *
      from
            plan_pago_cuota
      where
            plan_pago_cuota.plan_pago_id = _plan_pago.id
      order by
            fecha desc
      limit 1;

      if _cantidad_cuotas_vencidas  >= _parametro.cuotas_pase_vencido  then
        _estado = 'E';
      else
        _estado = 'V';
      end if;

      
      --if _plan_pago_cuota.vencida = true then
      --  _estado = 'E';
      --else
      --  _estado = 'V';
      --end if;
      

      /*
      ---------------------
        Proceso contable
      ---------------------
      */
    
      if _estado = 'E' and
        _prestamo.estatus not in  ('E','J','L','K') then
        
        if _prestamo.banco_origen = 'FONDAS' then
          _fuente_recursos_id = 1;
        end if;
        
        if _prestamo.banco_origen = 'AGROVENEZUELA' then
          _fuente_recursos_id = 2;
        end if;
        
        if _prestamo.banco_origen = 'FONDAFA' then
          _fuente_recursos_id = 3;
          
        end if;
        
        _estado_prestamo = 'P';
        _distincion_cobranza = 'PAS';
        _analista = 'Admin' ;
          
         raise notice 'Programa =============> %', _solicitud.programa_id;
         perform registro_contable(23,
              cast('X' as character varying),
              _fuente_recursos_id,
              _solicitud.programa_id,
              cast('X' as character varying),
              0,
              0,
              cast(_prestamo.interes_vencido as double precision),
              0,
              0,
              cast(_prestamo.saldo_insoluto as double precision),
              0,
              0,
              0,
              0,
              0,
              0,
              0,
              0,
              0,
              p_fecha_evento,
              p_fecha_evento,
              _prestamo.id,
              0,
              cast(date_part('year', current_date) as integer),
              cast(date_part('year',current_date) as character varying) || '-' || cast       (_prestamo.numero as character varying),
              cast(' ' as character varying),
              _nombre_cliente,
              cast('Pase de Vigente a Vencido' as character varying),
              cast(_prestamo.numero as character varying),
              _prestamo.reestructurado,
              0);
      end if;
      
      /*
      if (_cantidad_cuotas_vencidas + _cuotas_pagadas) < _total_cuotas and _prestamo.estatus not in ('J','L','K') then
        _estado = 'V';
      else
        _estado = 'E';
      end if;
      */

      raise notice 'CUOTAS VENCIDAS ==============> %', _cantidad_cuotas_vencidas;
      raise notice 'CUOTAS TOTALES  ==============> %', _total_cuotas;
      raise notice 'CUOTAS PAGADAS  ==============> %', _cuotas_pagadas;
      raise notice 'ESTADO          ==============> %', _estado;

      IF _estado = 'E' then
         _dias_vencido = 1;
      END IF;

      IF _estado = 'V' then
         _dias_vigente = 1;
      END IF;

      raise notice ' ===========> %', _monto_cuotas_vencidas;

      update
           prestamo
      set
            monto_cuotas_vencidas = _monto_cuotas_vencidas,
            cantidad_cuotas_vencidas = _cantidad_cuotas_vencidas,
            estatus = _estado,
            dias_demorado = dias_demorado + _dias_demorado,
            dias_vencido = dias_vencido + _dias_vencido,
            dias_vigente = dias_vigente + _dias_vigente,
            cuotas_pagadas = _cuotas_pagadas,
            cuotas_pendientes = _cuotas_pendientes,
            --capital_pagado = _capital_pagado,
            capital_por_pagar = monto_liquidado - _prestamo.capital_pagado
      where
           id = _prestamo.id;

    --raise notice 'ACTUALIZO PRESTAMO =====================> %, %', _estado, _prestamo.numero;

    else
      update
           prestamo
      set
           proyeccion_monto_cuotas_vencidas = _plan_pago_cuota.total_monto,
           proyeccion_cantidad_cuotas_vencidas = _plan_pago_cuota.total_cantidad
      where
           id = p_prestamo_id;
    end if;

  return true;

 end;

 $BODY$
  LANGUAGE 'plpgsql' VOLATILE;


