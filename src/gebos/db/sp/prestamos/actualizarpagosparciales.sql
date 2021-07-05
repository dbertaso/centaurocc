-- Function: actualizarpagosparciales()

-- DROP FUNCTION actualizarpagosparciales();

--select actualizarpagosparciales();

CREATE OR REPLACE FUNCTION actualizarpagosparciales()
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
			ultimo_desembolso = 0;


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
            Lectura del cliente para obtener los datos
            necesarios para actualizar la tabla de pagos
            parciales de la migración
            --------------------------------------------
            */

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

                if found then

                  _documento = _empresa.rif;
                  _nombre = _empresa.nombre;
                end if;

              else

                select
                into
                      _persona *
                from
                      persona
                where
                      persona.id = _cliente.persona_id;

                if found then
                  _nombre = ' ';
                  _documento = _persona.cedula_nacionalidad || '-' || _persona.cedula::character varying;
                  _nombre = nullif(_persona.primer_nombre,' ') || ' ' || nullif(_persona.primer_apellido,' ');
                end if;

              end if;

            end if;

            raise notice 'Nombre Cliente =====================>, %', _nombre;
            raise notice 'Documento      =====================>, %', _documento;

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
              Creación del cursor de las cuotas del prétamo
              para totalizar los capitales
              ------------------------------------------------
              */

              open _cur_plan_pago_cuota for
              select
                     *
              from
                     plan_pago_cuota
              where
                     plan_pago_cuota.plan_pago_id = _plan_pago.id and
                     tipo_cuota = 'C' and
                     estatus_pago <> 'T'
              order by
                     plan_pago_cuota.id;

              loop

                fetch
                      _cur_plan_pago_cuota
                into
                    _plan_pago_cuota;
                exit when not found;


                _total_capital = _total_capital + _plan_pago_cuota.amortizado;

              /*
              ------------------------------------
              loop recorrido de cursor de cuotas
              ------------------------------------
              */

              end loop;

              close _cur_plan_pago_cuota;


              if _prestamo.saldo_insoluto < _total_capital then

                _pago_parcial = _total_capital - _prestamo.saldo_insoluto;

                select
                into
                       _plan_pago_cuota *
                from
                       plan_pago_cuota
                where
                       plan_pago_id = _plan_pago.id and
                       tipo_cuota = 'C' and
                       estatus_pago <> 'T'
                order by
                       fecha
                limit 1;

                if found then

                  /*
                  ------------------------------------------------------------
                  Si el pago parcial es menor o igual que el capital de la
                  cuota se procede a actualizar la primera cuota impaga del
                  préstamos
                  -------------------------------------------------------------
                  */

                  if _pago_parcial <= _plan_pago_cuota.amortizado then
                    raise notice 'Capital de las cuotas =======================> %', _total_capital;
                    raise notice 'Saldo Deudor          =======================> %', _prestamo.saldo_insoluto;
                    raise notice 'Pago Parcial =========================> %', _pago_parcial;
                    update
                           plan_pago_cuota
                    set
                           pago_capital = _pago_parcial,
                           pago_interes_corriente = _plan_pago_cuota.interes_corriente,
                           pago_interes_diferido = _plan_pago_cuota.interes_diferido
                    where
                           id = _plan_pago_cuota.id;
                    /*
                    ---------------------------------------------------
                    Inserción de registro de control del pago parcial
                    ---------------------------------------------------
                    */

                    insert
                    into
                         m_pago_parcial

                           (
                             nombre,
                             documento,
                             numero_prestamo,
                             monto_pago_parcial,
                             monto_capital_cuotas,
                             saldo_deudor
                           )
                    values
                           (
                             _nombre,
                             _documento,
                             _prestamo.numero,
                             _pago_parcial,
                             _total_capital,
                             _prestamo.saldo_insoluto
                           );
                    --end if;
                    _total_capital = 0;

                  else
                    _total_capital = 0;
                  end if;

                end if;

              end if;

            end if;  -- Fin del if found del plan_pago

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
ALTER FUNCTION actualizarpagosparciales() OWNER TO cartera;

