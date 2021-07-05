-- Function: actualizartasavigente()

-- DROP FUNCTION actualizartasavigente();

--select actualizartasavigente();

CREATE OR REPLACE FUNCTION actualizartasavigente()
  RETURNS boolean AS
$BODY$
declare

  _rechazos rechazos%rowtype;
  _prestamo prestamo%rowtype;
  _solicitud solicitud%rowtype;
  _plan_pago_cuota plan_pago_cuota%rowtype;
  _plan_pago plan_pago%rowtype;
  _cliente cliente%rowtype;
  _persona persona%rowtype;
  _empresa empresa%rowtype;
  _garantia garantia%rowtype;
  _solicitud_evento solicitud_evento%rowtype;
  _solicitud_capacidad solicitud_capacidad%rowtype;
  _evaluacion evaluacion%rowtype;
  _resultado_cualitativa resultado_cualitativa%rowtype;
  _evaluacion_cualitativa evaluacion_cualitativa%rowtype;
  _evaluacion_flujo_caja evaluacion_flujo_caja%rowtype;
  _evaluacion_flujo_caja_detalle evaluacion_flujo_caja_detalle%rowtype;
  _desembolso desembolso%rowtype;
  _fecha_proceso_next date;
  _total_capital decimal(16,2) = 0;
  _pago_parcial decimal(16,2) = 0;
  _nombre character varying(300) = '';
  _documento character varying(20) = '';


  -- Cursor para recorrer los programas sociales y efectuar el cierre diario de cartera
  _cur_cliente refcursor;
  _cur_prestamo refcursor;
  _cur_plan_pago_cuota refcursor;
  _exito boolean;


begin


	/*
	---------------------------------------------------
	Apertura de cursor de prestamos, de todos los re-
	gistros validos para procesar pagos parciales
	---------------------------------------------------
	*/

	open _cur_prestamo for

		select
			*
		from
			prestamo
		where
			codigo_d3 is not null and
			estatus <> 'C' and
			ultimo_desembolso = 0 and
			tipo_cartera_id = 1;


		loop

          /*
          -----------------------------------
          Recorrido del cursor de préstamos
          -----------------------------------
          */

          fetch _cur_prestamo INTO _prestamo;
          exit when not found;


            /*
            --------------------------------------------
            Lectura del plan pago asociado al préstamo
            --------------------------------------------
            */

            select
            into
                    _plan_pago *
		    from
                    plan_pago
            where
                    plan_pago.prestamo_id = _prestamo.id and
                    activo = true;

            raise notice 'Plan Pago =========================> %', _plan_pago.id;

            if found then

              /*
              ------------------------------------------------
              Búsqueda de la ultima cuota de la tabla para
              comparar las tasa con el préstamo
              ------------------------------------------------
              */

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

              if found then

                /*
                ---------------------------------------------------------------
                Si la tasa vigente del prestamo es diferente a la de plan_pago
                cuota se actualiza
                ---------------------------------------------------------------
                */

                if _plan_pago_cuota.tasa_nominal_anual <>_prestamo.tasa_vigente then

                  update
                         prestamo
                  set
                         tasa_vigente = _plan_pago_cuota.tasa_nominal_anual
                  where
                         id = _prestamo.id;

                end if;

            end if;

              /*
              ------------------------------------------------
              Búsqueda de la ultima cuota de gracia para
              actualizar la tasa de gracia
              ------------------------------------------------
              */

              select
              into
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

                /*
                ------------------------------------------------------------
                Si la tasa del plan pago cuota es diferente a la del
                plan pago se actualiza
                -------------------------------------------------------------
                */

                if _plan_pago_cuota.tasa_nominal_anual <> _plan_pago.tasa_gracia then

                  update
                         plan_pago
                  set
                         tasa_gracia = _plan_pago_cuota.tasa_nominal_anual
                  where
                         id = _plan_pago.id;

                end if;

            end if;

          end if;

          /*
          ------------------------------------------
          loop de recorrido de cursor de prestamos
          ------------------------------------------
          */

		  end loop;

        /*
        -------------------------------
        Cierre del cursor de préstamo
        -------------------------------
        */

		close _cur_prestamo;

  return true;

end;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;
ALTER FUNCTION actualizartasavigente() OWNER TO cartera;

