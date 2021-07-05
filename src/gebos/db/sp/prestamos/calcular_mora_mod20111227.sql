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

        if not found then

          _tasa_calculo = _parametro_general.tasa_maxima_mora;
        else
          _tasa_calculo = _tasa_valor.valor;
        end if;
                 -- if _prestamo.numero =8000000764 then
                  --  raise notice 'entra a calcular la mora ++++++++++++++++ ';
                  --end if;

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
        end if;

        if p_proyeccion = false then
          update prestamo set dias_mora = 0, monto_mora = 0 where id = p_prestamo_id;
        else
          update prestamo set proyeccion_dias_mora = 0, proyeccion_monto_mora = 0 where id = p_prestamo_id;
        end if;

          _base_calculo_intereses = _prestamo.base_calculo_intereses;


          select into _plan_pago * from plan_pago
            where prestamo_id = p_prestamo_id and activo = not(p_proyeccion) and proyeccion = p_proyeccion;

           --raise notice '************************* fecha_evento  (calcular_mora_mod)______________%', p_fecha_evento;
           --raise notice '************************* fecha_calculo (calcular_mora)_____________%', _fecha_calculo;
          if p_fecha_auxiliar = p_fecha_evento then
            _fecha_calculo = agregar_dias(p_fecha_evento, -(_parametro_general.dias_gracia_mora-1));
          else
            _fecha_calculo = agregar_dias(p_fecha_auxiliar, -(_parametro_general.dias_gracia_mora-1));
          end if;

          --raise notice '************************* fecha_calculo_en_calcular_mora_mod (calcular_mora_mod)_____________%',_fecha_calculo;

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

              open _cur_plan_pago_cuota for select * from plan_pago_cuota
                where plan_pago_id = _plan_pago.id and fecha <= _fecha_calculo and (tipo_cuota = 'C' or tipo_cuota = 'G')
                and (estatus_pago = 'N' or estatus_pago = 'P' and vencida = true ) order by fecha asc;

             -- Originalmente antes de -467.88 cambiar a tasa_nominal_anual
             --_tasa_calculo = _tasa_valor.valor + _prestamo.tasa_vigente;
          else
              open _cur_plan_pago_cuota for select * from plan_pago_cuota
                where plan_pago_id = _plan_pago.id and fecha <= _fecha_mora_intermediado and (tipo_cuota = 'C' or tipo_cuota = 'G')
                and (estatus_pago = 'N' or estatus_pago = 'P' and vencida = true ) order by fecha asc;
          end if;
          */

          open _cur_plan_pago_cuota for

            select  *
            from
              plan_pago_cuota
            where
              plan_pago_id = _plan_pago.id and
              fecha <= _fecha_calculo
              and (tipo_cuota = 'C' or tipo_cuota = 'G')
              and (estatus_pago = 'N' or estatus_pago = 'P' and vencida = true )
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

              -- se elimino la penalizacion se sumar la tasa a la tasa de mora para calcular esta.
              -- 04/03/2008 Orden Ejecutiva de Miguel Torres

              -- Se revirtio la modificacion arriba mencionada por orden ejecutiva de Miguel Torres
              -- 07/04/2008

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


              _fecha_fin = p_fecha_evento;

              if _plan_pago_cuota.fecha <> _plan_pago_cuota.fecha_ultima_mora then
                _fecha_inicio = _plan_pago_cuota.fecha_ultima_mora;
              else
                _fecha_inicio = _plan_pago_cuota.fecha;
              end if;


              if _base_calculo_intereses = 360 then
                _dias_mora = (calcular_dias_360(_fecha_inicio, _fecha_fin))+1;

              --raise notice '????????????????_dias_mora__%', _dias_mora;

              else

              /* Se modifico la funcion dias mora para base 365, se reemplazo la coma por el signo - Diego Bertaso */

                _dias_mora = (_fecha_fin - _fecha_inicio)+1;

              end if;


              _intereses_mora = ( ( ( _tasa_calculo / 100 ) / _base_calculo_intereses ) * _monto_base) * _dias_mora;
              _intereses_mora_total = _intereses_mora_total + _intereses_mora;

              --raise notice '????????????????_interes_mora__%', _intereses_mora;

              /*
              ----------------------------------------------
              if _plan_pago_cuota.tipo_cuota = 'C' then
              ----------------------------------------------
              */

            end if;


            /*
            -------------------------------------------------------
            Se comento la eliminación de plan_pago_mora por no
            ser necesario al eliminar el registro en plan_pago_mora
            Diego Bertaso    Fecha: 2009-06-09
            -------------------------------------------------------


            delete from plan_pago_mora where plan_pago_cuota_id in (
            select id from plan_pago_cuota where
            plan_pago_id = _plan_pago.id and fecha > _fecha_calculo and fecha <= p_fecha_auxiliar and (tipo_cuota = 'C' or tipo_cuota = 'G')
            and (estatus_pago = 'N' or estatus_pago = 'P' and vencida = true ));
            ------------------------------------------------------------------------
            */

            if _dias_mora > 0 then
              update
                      plan_pago_cuota
              set
                      vencida   = true,
                      dias_mora   = _dias_mora,
                      interes_mora  = _intereses_mora
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
                  tipo_cuota in ('C','G') and
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
            into 
                    _plan_pago *
            from
                    plan_pago
            where
                    plan_pago.prestamo_id = _prestamo.id and
                    activo = true;


            select
            into 
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
                                          case 
                                            when 
                                                  sum(interes_mora) > sum(pago_interes_mora)
                                            then
                                                  sum(abs(interes_mora - pago_interes_mora))
                                            else
                                                  sum(interes_mora)
                                          end

                                  from
                                          plan_pago_cuota
                                  where
                                          vencida = true and
                                          estatus_pago in ('N', 'P') and
                                          plan_pago_id in ( select
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
