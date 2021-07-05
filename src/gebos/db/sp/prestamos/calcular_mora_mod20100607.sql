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
      _tasa_calculo float;
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

    begin

        /*
        ------------------------------------
        Lectura de tabla paramétro general
        ------------------------------------
        */

        select 
        into 
            _parametro_general * 
        from 
            parametro_general 
        limit 1;

        /*
        ---------------------------------
        Lectura del registro de crédito
        ---------------------------------
        */

        select 
        into 
            _prestamo * 
        from 
            prestamo
        where 
            id = p_prestamo_id;

        _base_calculo_intereses = _prestamo.base_calculo_intereses;

        _monto_base = _prestamo.saldo_insoluto - _prestamo.capital_pago_parcial;

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

        _tasa_calculo = _tasa_valor.valor;

        if _parametro_general.penalizacion_mora = true then
          _tasa_calculo = _tasa_calculo + _prestamo.tasa_vigente;
        end if;

        raise notice 'Fecha Calculo ==============> %', _tasa_calculo;
        /*
        --------------------------------------------------
        Se determina la fecha de calculo de inicio de la
        mora tomando en cuenta los días de gracia de la
        mora
        --------------------------------------------------
        */

        if p_fecha_auxiliar = p_fecha_evento then
          _fecha_calculo = agregar_dias(p_fecha_evento, -(_parametro_general.dias_gracia_mora-1));
        else
          _fecha_calculo = agregar_dias(p_fecha_auxiliar, -(_parametro_general.dias_gracia_mora-1));
        end if;

        if 
            _prestamo.intermediado = true and 
            p_proyeccion = false then

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
        end if;

        if p_proyeccion = false then
          update prestamo set dias_mora = 0, monto_mora = 0 where id = p_prestamo_id;
        else
          update prestamo set proyeccion_dias_mora = 0, proyeccion_monto_mora = 0 where id = p_prestamo_id;
        end if;


        /*
        ------------------------------------
        Lectura del plan pago asociado al 
        préstamo
        ------------------------------------
        */

        select 
        into 
                _plan_pago * 
        from 
                plan_pago
        where 
                prestamo_id = p_prestamo_id and 
                activo = not(p_proyeccion)  and 
                proyeccion = p_proyeccion;

        /*
        -----------------------------------------
        Lectura del plan pago cuota relacionado
        con el plan pago del crédito
        -----------------------------------------
        */
                
        open _cur_plan_pago_cuota for

            select
                    *
            from
                    plan_pago_cuota
            where
                    plan_pago_id = _plan_pago.id                and
                    fecha <= _fecha_calculo                     and 
                    tipo_cuota in ('C','G')                     and 
                    estatus_pago in ('N','P')                   and 
                    vencida = true
            order by
                    fecha asc;

        -- Fin de la modificacion

      _contador = 0;

      loop

        fetch _cur_plan_pago_cuota INTO _plan_pago_cuota;
        exit when not found;

        _vencido = true;
        _contador = _contador + 1;

        if _plan_pago_cuota.tipo_cuota = 'C' then

          /*
          -----------------------------------------------------
          Se modifico el calculo de dias de mora, usando como
          inicio la fecha de la cuota o la fecha de ultimo pago
          de la mora(fecha_ultima_mora)
          -----------------------------------------------------
          */


          _fecha_fin = p_fecha_evento;

          if _plan_pago_cuota.fecha <> _plan_pago_cuota.fecha_ultima_mora then
            _fecha_inicio = _plan_pago_cuota.fecha_ultima_mora;
          else
            _fecha_inicio = _plan_pago_cuota.fecha;
          end if;


          if _base_calculo_intereses = 360 then
            _dias_mora = (calcular_dias_360(_fecha_inicio, _fecha_fin));

          else

          /* Se modifico la funcion dias mora para base 365, se reemplazo la coma por el signo - Diego Bertaso */

            _dias_mora = (_fecha_fin - _fecha_inicio);

          end if;



          _intereses_mora = ( ( ( _tasa_calculo / 100 ) / _base_calculo_intereses ) * _monto_base) * _dias_mora;
          _intereses_mora_total = _intereses_mora_total + _intereses_mora;

          raise notice 'PRESTAMO NUMERO ===============> %', _prestamo.numero;
          raise notice 'Monto Base ====================> %', _monto_base;
          raise notice 'DIAS MORA =====================> %', _dias_mora;
          raise notice 'TASA DE CALCULO ===============> %', _tasa_calculo;
          raise notice 'INTERES MORA ==================> %', _intereses_mora;

        /*
        ----------------------------------------------
        if _plan_pago_cuota.tipo_cuota = 'C' then
        ----------------------------------------------
        */

        end if;


        /*
        ----------------------------------------------
        Actualización de los días y monto de la mora
        para la cuota a la cual se calculo la misma
        ----------------------------------------------
        */

        if _dias_mora > 0 then
          update
            plan_pago_cuota
          set
            vencida 	= true,
            dias_mora 	= _dias_mora,
            interes_mora = _intereses_mora
          where
            id = _plan_pago_cuota.id;

        else

          update
            plan_pago_cuota
          set
            vencida = false ,
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
          tipo_cuota in ('C','G')	and
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

          select
            into _plan_pago *
          from
            plan_pago
          where
            plan_pago.prestamo_id = _prestamo.id and
            activo = true;


          select
            into _plan_pago_cuota *
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
          end if;

          /*
          ----------------------------------------------
          Actualiza el monto de la mora en el préstamo
          ----------------------------------------------
          */

          update
            prestamo
          set
            monto_mora = (select
                                    sum(abs(interes_mora - pago_interes_mora))

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
                                                                activo = true)),
            estatus = 'E'
          where
            id = p_prestamo_id;
        else

          update
            prestamo
          set
            proyeccion_dias_mora = _dias_mora_total,
            proyeccion_monto_mora = _intereses_mora_total - _pago_interes_mora,
            proyeccion_estatus = 'E'
          where
            id = p_prestamo_id;

        /* if p_proyeccion = false then */

        end if;

        /* if _vencido = true then */

        end if;

        /*
        ---------------------------------------
        Si el conteo de cuotas vencidas es
        mayor que uno se actualiza el crédito
        a vencido
        ---------------------------------------
        */

        select
        into
                _cantidad_cuotas_mora count(*)
        from
                plan_pago_cuota
        where
                plan_pago_id = _plan_pago.id and
                estatus_pago in ('N', 'P') and
                vencida = true and
                dias_mora > 0;

        if _cantidad_cuotas_mora > 0 then
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
