-- Function: EliminaTransaccionAccion(pid_programa int4)

-- DROP FUNCTION EliminaTransaccionAccion(pid_programa int4);

CREATE OR REPLACE FUNCTION EliminaTransaccionAccion(pid_desde int8, pid_hasta int8)
  RETURNS bool AS
$BODY$
declare
  
  _rechazos rechazos%rowtype;
  _solicitud solicitud%rowtype;
  _prestamo prestamo%rowtype;
  _plan_pago plan_pago%rowtype;
  _plan_pago_cuota plan_pago_cuota%rowtype;
  _programa programa%rowtype;
  _producto producto%rowtype;
  _fecha_proceso_next date;

  -- Cursor para recorrer los programas sociales y efectuar el cierre diario de cartera
  _cur_programa refcursor;
  _cur_prestamos refcursor;
 
  
  
begin

	delete from transaccion_accion where transaccion_accion.id >= pid_desde and transaccion_accion.id <= pid_hasta;

	return true;
 
end;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;
ALTER FUNCTION EliminaTransaccionAccion(pid_desde int8, pid_hasta int8) OWNER TO cartera;
