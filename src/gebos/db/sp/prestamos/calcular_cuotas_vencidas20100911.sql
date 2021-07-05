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


  begin

    select into
                _parametro *
    from
                parametro_general
    limit 1;

    update
          prestamo
    set
          monto_cuotas_vencidas = 0
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

    select into
               _plan_pago *
    from
               plan_pago
    where
               prestamo_id = p_prestamo_id and
               activo = not(p_proyeccion)  and
               proyeccion = p_proyeccion;


    delete from
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
                       fecha	    >  p_fecha_evento and
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
              sum((valor_cuota + interes_diferido + interes_desembolso + cuota_extra)-(pago_interes_corriente + pago_capital + pago_interes_diferido + pago_interes_desembolso + pago_cuota_extra)) as total_monto,
              count(id) as total_cantidad
       from
              plan_pago_cuota
       where
              vencida = true     and
              estatus_pago in ('N','P') and
              tipo_cuota = 'C' and
              plan_pago_id = _plan_pago.id;

   fetch _cur_plan_pago_cuota INTO _plan_pago_cuota;


   --raise notice 'Cantidad cuotas vencidas ========>  %', _plan_pago_cuota.total_cantidad;

   if found then

     _cantidad_cuotas_vencidas = _plan_pago_cuota.total_cantidad;

     if p_proyeccion = false then

       _estado = _prestamo.estatus;

       if _plan_pago_cuota.total_cantidad <= 0 and _prestamo.estatus not in ('J','L','K') then
          _estado = 'V';
       end if;

       if (_plan_pago_cuota.total_cantidad > 0 and
           _plan_pago_cuota.total_cantidad < _parametro.cuotas_pase_vencido) and
            _prestamo.estatus not in ('J','L','K') then

         _estado = 'H';
       end if;

       --raise notice 'FUENTE RECURSOS ========>  %', _fuente_recursos_id;
       --raise notice 'SECTOR ECONOMICO ========>  %', _sector_economico_id;


       if _plan_pago_cuota.total_cantidad >= _parametro.cuotas_pase_vencido and
          _prestamo.estatus not in  ('E','J','L','K') then

         _estado = 'E';

            _estado_prestamo = 'P';
            _distincion_cobranza = 'PAS';
            _analista = 'Admin' ;

           perform registro_contable(cast('PASE VENCIDO' as character varying),
                cast('N' as character varying),
                _fuente_recursos_id,
                _sector_economico_id,
                cast('P' as character varying),
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


       --raise notice 'CUOTAS VENCIDAS ==============> %', _plan_pago_cuota.total_cantidad;
       --raise notice 'ESTADO          ==============> %', _estado;

       IF _estado = 'H' then
           _dias_demorado = 1;
       END IF;

       IF _estado = 'E' then
           _dias_vencido = 1;
       END IF;

       IF _estado = 'V' then
           _dias_vigente = 1;
       END IF;

       update
             prestamo
       set
             monto_cuotas_vencidas = _plan_pago_cuota.total_monto,
             cantidad_cuotas_vencidas = _plan_pago_cuota.total_cantidad,
             estatus = _estado,
             dias_demorado = dias_demorado + _dias_demorado,
             dias_vencido = dias_vencido + _dias_vencido,
             dias_vigente = dias_vigente + _dias_vigente
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

   end if;

   close _cur_plan_pago_cuota;

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

    --raise notice 'CUOTAS PENDIENTES  ============> %', _cuotas_pendientes;

   update
          prestamo
   set
          cuotas_pagadas = _cuotas_pagadas,
          cuotas_pendientes = _cuotas_pendientes,
          capital_pagado = _capital_pagado,
          capital_por_pagar = monto_liquidado - _capital_pagado
   where
          id = _prestamo.id;

   return true;

 end;

 $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
ALTER FUNCTION calcular_cuotas_vencidas(integer, date, boolean) OWNER TO cartera;

