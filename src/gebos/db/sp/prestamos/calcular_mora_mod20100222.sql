-- Function: calcular_mora_mod(integer, date, date, boolean, double precision)

-- DROP FUNCTION calcular_mora_mod(integer, date, date, boolean, double precision);

CREATE OR REPLACE FUNCTION calcular_mora_mod(p_prestamo_id integer, p_fecha_evento date, p_fecha_auxiliar date, p_proyeccion boolean, p_valor double precision)
  RETURNS boolean AS
$BODY$

declare
  _prestamo prestamo%rowtype;
  _plan_pago plan_pago%rowtype;
  _plan_pago_cuota plan_pago_cuota%rowtype;
  _parametro_general parametro_general%rowtype;
  _tasa_valor tasa_valor%rowtype;
  _fecha_calculo date;
  _tasa_calculo float = 0;
  _cur_plan_pago_cuota refcursor;
  _intereses_mora float = 0;
  _intereses_mora_total numeric(16,2) = 0;
  _dias_mora integer = 0;
  _dias_mora_total integer = 0;
  _primera_cuota bool = true;
  _pago_interes_mora numeric(16,2) = 0;
  _base_calculo_intereses integer = 0;
  _fecha_inicio_mora_intermediado date;
  _fecha_mora_intermediado_anterior date;
  _fecha_mora_intermediado date;
  _vencido bool = false;
  _fecha_inicio date;
  _fecha_fin date;
  _plan_pago_mora plan_pago_mora%rowtype;
  _plan_pago_mora_aux plan_pago_mora%rowtype;
  _monto_base numeric(16,2) = 0;
  _plan_pago_mora_id integer;
  _cantidad_cuotas_mora integer = 0;
  _contador int8;
  _pago_mora numeric(16,2) = 0;

  begin

    select into _parametro_general * from parametro_general limit 1;

    /*
    ----------------------
    Lectura del prestamo
    ----------------------
    */

    select into
                _prestamo *
    from
                prestamo
    where
                id = p_prestamo_id;

    raise notice 'ESTADO DEL PRESTAMO ===========> %', _prestamo.estatus;

    /*
    --------------------------------------
    Lectura de la tasa asignada por mora
    --------------------------------------
    */

    select into
                _tasa_valor *
    from
                tasa_valor
    where
                tasa_id = _prestamo.tasa_mora_id
    order by
                fecha_actualizacion desc
    limit 1;

    if not found then

      _tasa_calculo = _parametro_general.tasa_maxima_mora;
    else
      _tasa_calculo = _tasa_valor.valor;
    end if;

    if _parametro_general.penalizacion_mora = true then
      _tasa_calculo = _tasa_calculo + _prestamo.tasa_vigente;
    end if;


    /*
    --------------------------------------------------------------
    Si el estatus del prestamo es vencido el calculo de mora
    se aplica al saldo deudor y se le suma 1 dia a los dias de
    mora del prestamo ya que no aplica la fecha de vencimiento de
    la cuota
    --------------------------------------------------------------
    */

    if _prestamo.estatus = 'E' then

      _base_calculo_intereses = _prestamo.base_calculo_intereses;

      /*
      -------------------------------------------
      Lectura de plan_pago asociado al préstamo
      -------------------------------------------
      */

      select into
                 _plan_pago *
      from
                 plan_pago
      where
                 prestamo_id  = p_prestamo_id     and
                 activo       = not(p_proyeccion) and
                 proyeccion   = p_proyeccion;

      if found then

        /*
        --------------------------------------------------
        Se busca la ultima cuota parcialmente pagada
        para determinar la fecha de calculo de la mora
        --------------------------------------------------
        */

        select into
                    _plan_pago_cuota *
        from
                    plan_pago_cuota
        where
                    plan_pago_id = _plan_pago.id and
                    tipo_cuota = 'C'             and
                    estatus_pago = 'P'
        order by
                    fecha asc
        limit 1;

        if found then

          /*
          -------------------------------------------------------
          De existir una cuota parcialmente pagada se determina
          si la fecha de la cuota es diferente de la del ultimo
          pago de mora
          -------------------------------------------------------
          */

          if _plan_pago_cuota.fecha <> _plan_pago_cuota.fecha_ultima_mora then

            /*
            -----------------------------------------------------
            Se toma la fecha de ultimo pago mora para calcular
            los dias de mora para recalcular la mora, se asigna
            a una variable el monto pagado de la mora
            ----------------------------------------------------
            */

            _fecha_inicio = _plan_pago_cuota.fecha_ultima_mora;
            _fecha_fin = p_fecha_evento;

            if _base_calculo_intereses = 360 then

              _dias_mora = (calcular_dias_360(_fecha_inicio, _fecha_fin))+1;

            else

              _dias_mora = (_fecha_fin - _fecha_inicio)+1;

            end if;   ----> if _base_calculo_intereses = 360 then

            _monto_base = _plan_pago_cuota.saldo_insoluto - _plan_pago_cuota.pago_capital;
            _pago_mora = _plan_pago_cuota.pago_interes_mora;

          else

            /*
            ---------------------------------------------------
            Si las fechas son iguales se le suma 1 a los dias
            de mora que tiene el prestamo
            ---------------------------------------------------
            */

            _dias_mora = _prestamo.dias_mora + 1;
            _monto_base = _prestamo.saldo_insoluto;
            _pago_mora = 0;
          end if;

        else     -----> if found then plan_pago_cuota

          /*
          ----------------------------------------------------
          Si no hay cuotas parcialmente pagadas se le suma 1
          a los dias de mora que tiene el prestamo
          ----------------------------------------------------
          */

          _dias_mora = _prestamo.dias_mora + 1;
          _monto_base = _prestamo.saldo_insoluto;
          _pago_mora = 0;

        end if;     -----> if found then plan_pago_cuota

      end if;       -----> if found then plan_pago

      /*
      ---------------------------------------------
      En todos los casos la base de calculo para
      la mora es el saldo insoluto
      ---------------------------------------------
      */

      raise notice 'Dias de Mora -------------------------> %', _dias_mora;
      raise notice 'Tasa de Mora -------------------------> %', _tasa_calculo;
      raise notice 'Monto Base ---------------------------> %', _monto_base;
      raise notice 'Base de Calculo ----------------------> %', _base_calculo_intereses;

      _intereses_mora = ((( _tasa_calculo / 100) / _base_calculo_intereses) * _monto_base) * _dias_mora;
      _intereses_mora_total = _intereses_mora_total + _intereses_mora;

      raise notice 'Intereses Mora -----------------------> %', _intereses_mora;

      /*
      ---------------------------
      Actualiacion del prestamo
      ---------------------------
      */

      update
             prestamo
      set
             dias_mora = _dias_mora,
             monto_mora = _intereses_mora
      where
             prestamo.id = _prestamo.id;

      return true;

    end if;           ---> if _prestamo.estatus = 'E' then

    /*
    -----------------------------------------
    Fin calculo de la mora préstamo vencido
    -----------------------------------------
    */


    raise notice 'ENTRO POR PRESTAMO VIGENTE-DEMORADO ==========================> %, %', _prestamo.estatus, _prestamo.numero;

    if _prestamo.intermediado = true and p_proyeccion = false then

      _fecha_inicio_mora_intermediado =  agregar_dias(_prestamo.fecha_cobranza_intermediario,+_parametro_general.dias_gracia_mora+1);
      _fecha_mora_intermediado_anterior = agregar_meses(_prestamo.fecha_cobranza_intermediario,-_prestamo.frecuencia_pago_intermediario);
      _fecha_mora_intermediado_anterior = agregar_dias(_fecha_mora_intermediado_anterior,+_parametro_general.dias_gracia_mora+1);

      if _fecha_inicio_mora_intermediado > p_fecha_evento and not(_prestamo.estatus = 'E') then
        return true;
      end if;

      if _fecha_inicio_mora_intermediado > p_fecha_evento then

        _fecha_mora_intermediado = _fecha_mora_intermediado_anterior;
      else
        _fecha_mora_intermediado = _fecha_inicio_mora_intermediado;
      end if;

    end if;       ---> if _prestamo.intermediado = true and p_proyeccion = false then

    if p_proyeccion = false then

      update prestamo set dias_mora = 0, monto_mora = 0 where id = p_prestamo_id;
    else
      update prestamo set proyeccion_dias_mora = 0, proyeccion_monto_mora = 0 where id = p_prestamo_id;
    end if;

    _base_calculo_intereses = _prestamo.base_calculo_intereses;

    /*
    -------------------------------------------
    Lectura de plan_pago asociado al préstamo
    -------------------------------------------
    */

    select into
                _plan_pago *
    from
                plan_pago
    where
                prestamo_id  = p_prestamo_id     and
                activo       = not(p_proyeccion) and
                proyeccion   = p_proyeccion;

    raise notice '************************* fecha_evento  (calcular_mora_mod)______________%', p_fecha_evento;

    if p_fecha_auxiliar = p_fecha_evento then
      _fecha_calculo = agregar_dias(p_fecha_evento, -(_parametro_general.dias_gracia_mora-1));
    else
      _fecha_calculo = agregar_dias(p_fecha_auxiliar, -(_parametro_general.dias_gracia_mora-1));
    end if;

    raise notice '************************* fecha_calculo_en_calcular_mora_mod (calcular_mora_mod)_____________%',_fecha_calculo;
    raise notice '************************* Tasa Calculo ============================> %', _tasa_calculo;
    raise notice '************************* Plan Pago ============================> %', _plan_pago.id;
    /*
    ---------------------------------------------------------------------------------
    Se comento la verificacion del prestamo intermediado para el calculo de mora
    se calculara la mora de prestamos intermediados y no intermediados de la
    misma manera
    ---------------------------------------------------------------------------------

    if _prestamo.intermediado = false then

      --if _prestamo.numero =  8000000764 then
      --   raise notice '************************* VA HACER EL SELECT PARA BUSCAR LAS CUOTAS VENCIDAS____________';
      --end if;

      open _cur_plan_pago_cuota for

           select
                  *
           from
                  plan_pago_cuota
          where
                  plan_pago_id = _plan_pago.id and
                  fecha <= _fecha_calculo and
                  (tipo_cuota = 'C' or tipo_cuota = 'G') and
                  (estatus_pago = 'N' or estatus_pago = 'P' and
                  vencida = true )
          order by
                  fecha asc;

      -- Originalmente antes de -467.88 cambiar a tasa_nominal_anual
      --_tasa_calculo = _tasa_valor.valor + _prestamo.tasa_vigente;
    else

      open _cur_plan_pago_cuota for

           select
                  *
           from
                  plan_pago_cuota
           where
                  plan_pago_id = _plan_pago.id and
                  fecha <= _fecha_mora_intermediado and
                  (tipo_cuota = 'C' or tipo_cuota = 'G') and
                  (estatus_pago = 'N' or estatus_pago = 'P' and
                   vencida = true )
           order by
                   fecha asc;
    end if;

    */

    open _cur_plan_pago_cuota for

         select
                *
         from
                plan_pago_cuota
         where
                plan_pago_id = _plan_pago.id and
                fecha <= _fecha_calculo      and
                tipo_cuota in ('C','G')      and
                estatus_pago in ('N','P')    and
                vencida = true
         order by
                fecha asc;

         -- Fin de la modificacion

    _contador = 0;

    loop

      fetch _cur_plan_pago_cuota INTO _plan_pago_cuota;
      exit when not found;

      raise notice 'ENTRO EN FETCH DE CUOTAS VENCIDAS =====> %', _plan_pago_cuota.id;

      _vencido = true;
      _contador = _contador + 1;

      if _plan_pago_cuota.tipo_cuota = 'C' then

        -- _tasa_calculo = _tasa_valor.valor;

        /*
        -----------------------------------------------------
        Se modifico el calculo de dias de mora, usando como
        inicio la fecha de la cuota o la fecha de ultimo pago
        de la mora(fecha_ultima_mora)
        -----------------------------------------------------
        */

        if _plan_pago_cuota.pago_capital > 0 then

          _monto_base = _plan_pago_cuota.amortizado - _plan_pago_cuota.pago_capital;

        else

          _monto_base = _plan_pago_cuota.amortizado;

        end if;

        raise notice 'MONTO BASE ==============> %', _monto_base;

        _fecha_fin = p_fecha_evento;

        if _plan_pago_cuota.fecha <> _plan_pago_cuota.fecha_ultima_mora then
          _fecha_inicio = _plan_pago_cuota.fecha_ultima_mora;
        else
          _fecha_inicio = _plan_pago_cuota.fecha;
        end if;


        raise notice 'FECHA INICIO        =======> %', _fecha_inicio;
        raise notice 'FECHA FIN           =======> %', _fecha_fin;
        raise notice 'BASE CALCULO        =======> %', _base_calculo_intereses;

        if _base_calculo_intereses = 360 then

          _dias_mora = (calcular_dias_360(_fecha_inicio, _fecha_fin))+1;

          raise notice '????????????????_dias_mora__ %', _dias_mora;

        else

          /* Se modifico la funcion dias mora para base 365, se reemplazo la coma por el signo - Diego Bertaso */

          _dias_mora = (_fecha_fin - _fecha_inicio)+1;

        end if;   ----> if _base_calculo_intereses = 360 then


        _intereses_mora = ( ( ( _tasa_calculo / 100 ) / _base_calculo_intereses ) * _monto_base) * _dias_mora;
        _intereses_mora_total = _intereses_mora_total + _intereses_mora;

        raise notice '????????????????_interes_mora__ %', _intereses_mora;

      end if;

      if _dias_mora > 0 then

        update
               plan_pago_cuota
        set
               vencida      = true,
               dias_mora    = _dias_mora,
               interes_mora = _intereses_mora
        where
               id = _plan_pago_cuota.id;
      else

        update
               plan_pago_cuota
        set
               vencida = false,
               dias_mora = 0,
               interes_mora = 0
        where
               id = _plan_pago_cuota.id;
      end if;

      /*
      -------------------------------------
      fin del cursor _cur_plan_pago_cuota
      -------------------------------------
      */

    end loop;

    if _contador = 0 then

      update
             plan_pago_cuota
      set
             dias_mora = 0,
             interes_mora = 0
      where
             plan_pago_id = _plan_pago.id and
             fecha >= _fecha_calculo  and
             tipo_cuota in ('C','G')  and
             (estatus_pago in ('N','P') and
             vencida = true );

     else

       update
              plan_pago_cuota
       set
              dias_mora = 0,
              interes_mora = 0
       where
              plan_pago_id = _plan_pago.id and
              fecha >= _fecha_calculo and
              tipo_cuota in ('C', 'G') and
              (estatus_pago in ('N','P') and
               vencida = true );

     end if;

     if _vencido = true then

       if p_proyeccion = false then

         --update prestamo set dias_mora = _dias_mora_total, monto_mora =  _intereses_mora_total - _pago_interes_mora, estatus = 'E' where id = p_prestamo_id;

         /* Actualiza los dias de mora tomando como base la primera cuota vencida del plan_pago_cuota
            Diego Bertaso 2008-02-20*/

         select into
                     _plan_pago *
         from
                     plan_pago
         where
                     plan_pago.prestamo_id = _prestamo.id and
                     activo = true;

         select into
                     _plan_pago_cuota *
         from
                     plan_pago_cuota
         where
                     estatus_pago in ('N', 'P') and
                     vencida = true and
                     pago_capital = 0 and
                     pago_interes_mora = 0 and
                     plan_pago_id = _plan_pago.id
         order by
                     plan_pago_cuota.numero
         limit 1;

         /*
         ----------------------------------------
         Actualiza los días de mora el prestamo
         ----------------------------------------
         */

         if found then

           update
                  prestamo
           set
                  dias_mora = _plan_pago_cuota.dias_mora
           where
                  prestamo.id = _prestamo.id;

         else

           select into
                     _plan_pago_cuota *
           from
                     plan_pago_cuota
           where
                     estatus_pago in ('P') and
                     vencida = true and
                     plan_pago_id = _plan_pago.id
           order by
                     plan_pago_cuota.numero
           limit 1;

           if found then

             update
                  prestamo
             set
                  dias_mora = _plan_pago_cuota.dias_mora
             where
                  prestamo.id = _prestamo.id;

             end if;

         end if;

        /*
        ----------------------------------------------
        Actualiza el monto de la mora en el préstamo
        ----------------------------------------------
        */

        update
               prestamo
        set
               monto_mora = (select sum(abs(interes_mora))

                             from
                                  plan_pago_cuota
                             where
                                  vencida = true and
                                  estatus_pago in ('N', 'P') and
                                  plan_pago_id in (select
                                                           id
                                                   from
                                                           plan_pago
                                                   where
                                                           prestamo_id = _prestamo.id and
                                                           activo = true))
        where
              id = p_prestamo_id;
      else

        update
              prestamo
        set
              proyeccion_dias_mora = _dias_mora_total,
              proyeccion_monto_mora = _intereses_mora_total - _pago_interes_mora
        where
              id = p_prestamo_id;

        /* if p_proyeccion = false then */

      end if;

    /*if _vencido = true then */

    end if;

    /*
    ---------------------------------------
    Si el conteo de cuotas vencidas es
    mayor que uno se actualiza el crédito
    a vencido
    ---------------------------------------
    */

    select into

               _cantidad_cuotas_mora count(*)
    from
               plan_pago_cuota
    where
               plan_pago_id = _plan_pago.id and
               estatus_pago in ('N', 'P');

    if _cantidad_cuotas_mora = 0 then
      update
            prestamo
      set
            estatus = 'V'
      where
            id = p_prestamo_id;

    end if;

    if _cantidad_cuotas_mora > 0 and
       _cantidad_cuotas_mora <= 1 then

      raise notice 'ENTRO POR CUOTAS VENCIDAS = 1 ===========================> ';

      update
            prestamo
      set
            estatus = 'H'
      where
            id = p_prestamo_id;

    end if;

    if _cantidad_cuotas_mora >= 2 then
      update
            prestamo
      set
            estatus = 'E'
      where
            id = p_prestamo_id;
    end if;


    perform actualizar_deuda_exigible(p_prestamo_id, p_proyeccion);

    return true;

  end;
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
ALTER FUNCTION calcular_mora_mod(integer, date, date, boolean, double precision) OWNER TO cartera;
