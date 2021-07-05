-- Function: actualizaplazograciamigrados()

-- DROP FUNCTION actualizaplazograciamigrados();

CREATE OR REPLACE FUNCTION actualizaplazograciamigrados()
  RETURNS boolean AS
$BODY$
declare
  
  _rechazos rechazos%rowtype;
  _prestamo prestamo%rowtype;
  _solicitud solicitud%rowtype;
  _cliente cliente%rowtype;
  _garantia garantia%rowtype;
  _solicitud_evento solicitud_evento%rowtype;
  _solicitud_capacidad solicitud_capacidad%rowtype;
  _evaluacion evaluacion%rowtype;
  _resultado_cualitativa resultado_cualitativa%rowtype;
  _evaluacion_cualitativa evaluacion_cualitativa%rowtype;
  _evaluacion_flujo_caja evaluacion_flujo_caja%rowtype;
  _evaluacion_flujo_caja_detalle evaluacion_flujo_caja_detalle%rowtype;
  _plan_pago plan_pago%rowtype;
  _plan_pago_cuota plan_pago_cuota%rowtype;
  _desembolso desembolso%rowtype;
  _fecha_proceso_next date;

  -- Cursor para recorrer los programas sociales y efectuar el cierre diario de cartera
  _cur_cliente refcursor;
  _cur_prestamo refcursor;
  _exito boolean;

  
begin


	/*
	---------------------------------------------------
	Lectura de solicitud para comenzar la eliminación
	---------------------------------------------------
	*/

	open _cur_prestamo for
	
		select 
			*
		from 
			prestamo
		where
			codigo_d3 is not null;

	

		loop

			fetch _cur_prestamo INTO _prestamo;
			exit when not found;

			select into _plan_pago *
			from
				plan_pago
			where
				plan_pago.prestamo_id = _prestamo.id;

			if found then

				update 
					plan_pago
				set
					meses_gracia = cast((select count(*) from plan_pago_cuota where tipo_cuota = 'G' and plan_pago_id = _plan_pago.id) as smallint) * frecuencia_pago_gracia
				where
					plan_pago.id = _plan_pago.id;
					
			
			end if;
			
		end loop;

		close _cur_prestamo;

		

  return true;
 
end;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;
ALTER FUNCTION actualizaplazograciamigrados() OWNER TO cartera;
