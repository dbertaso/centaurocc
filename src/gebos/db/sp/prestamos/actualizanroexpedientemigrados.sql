-- Function: actualizanroexpedientemigrados()

-- DROP FUNCTION actualizanroexpedientemigrados();

--select actualizanroexpedientemigrados();

CREATE OR REPLACE FUNCTION actualizanroexpedientemigrados()
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
  _plan_pago_cuota plan_pago_cuota%rowtype;
  _desembolso desembolso%rowtype;
  _fecha_proceso_next date;

  -- Cursor para recorrer los programas sociales y efectuar el cierre diario de cartera
  _cur_cliente refcursor;
  _exito boolean;

  
begin


	/*
	---------------------------------------------------
	Lectura de solicitud para comenzar la eliminación
	---------------------------------------------------
	*/

	open _cur_cliente for
	
		select 
			*
		from 
			cliente
		where
			codigo_d3 is not null;

	

		loop

			fetch _cur_cliente INTO _cliente;
			exit when not found;

			select into _solicitud *
			from
				solicitud
			where
				solicitud.cliente_id = _cliente.id;

			if found then
			
				update 
					cliente
				set
					nro_expediente = _solicitud.numero
				where
					cliente.id = _solicitud.cliente_id;
			end if;
			
		end loop;

		close _cur_cliente;

		

  return true;
 
end;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;
ALTER FUNCTION actualizanroexpedientemigrados() OWNER TO cartera;
