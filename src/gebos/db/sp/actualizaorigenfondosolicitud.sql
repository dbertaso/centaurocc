-- Function: actualizaorigenfondosolicitud(pnumero int8)

-- DROP FUNCTION actualizaorigenfondosolicitud(pnumero int8);

CREATE OR REPLACE FUNCTION actualizaorigenfondosolicitud(pnumero int8, porigen_fondo_id int8)
  RETURNS bool AS
$BODY$
declare
  
  _rechazos rechazos%rowtype;
  _solicitud solicitud%rowtype;
  _prestamo prestamo%rowtype;
  _programa programa%rowtype;
  _plan_pago plan_pago%rowtype;
  _plan_pago_cuota plan_pago_cuota%rowtype;
  _origen_fondo origen_fondo%rowtype;
  _desembolso desembolso%rowtype;
  _fecha_proceso_next date;

  -- Cursor para recorrer los programas sociales y efectuar el cierre diario de cartera
  _cur_plan_pago_cuota refcursor;
  _cur_plan_pago refcursor;
  _cur_desembolso refcursor;
 
  
  
begin

	/*
	-------------------------------------------------------------------------------
	Actualiza el prestamo
	-------------------------------------------------------------------------------
	*/

	update 
		solicitud
	set
		origen_fondo_id = porigen_fondo_id
	where
		numero = pnumero;


  return true;
 
end;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;
ALTER FUNCTION actualizaorigenfondosolicitud(pnumero int8, origen_fondo int8) OWNER TO cartera;
