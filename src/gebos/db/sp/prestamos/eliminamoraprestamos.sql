-- Function: eliminaprestamosmigracion(bigint)

-- DROP FUNCTION eliminamoraprestamos(bigint);

CREATE OR REPLACE FUNCTION eliminamoraprestamos(pnumero bigint)
  RETURNS boolean AS
$BODY$
declare
  
  _rechazos rechazos%rowtype;
  _solicitud solicitud%rowtype;
  _prestamo prestamo%rowtype;
  _programa programa%rowtype;
  _plan_pago plan_pago%rowtype;
  _plan_pago_cuota plan_pago_cuota%rowtype;
  _desembolso desembolso%rowtype;
  _fecha_proceso_next date;

  -- Cursor para recorrer los programas sociales y efectuar el cierre diario de cartera
  _cur_plan_pago_cuota refcursor;
  _cur_plan_pago refcursor;
  _cur_desembolso refcursor;
 
  
  
begin

	/*
	-------------------------------------------------------------------------------
	Crea cursor de rechazos
	-------------------------------------------------------------------------------
	*/

	select 
		into _prestamo * 
	from 
		prestamo
	where
		prestamo.numero = pnumero;

	
	if found then


		select INTO
		
			_plan_pago * 
		from 
			plan_pago 
		where 
			plan_pago.prestamo_id 	= _prestamo.id and 
			activo 			= true;
		
		if _plan_pago.id <> 0 or _plan_pago.id is not null then

			delete 
			from 
				plan_pago_mora 
			where 
				plan_pago_mora.plan_pago_cuota_id in (	select 
										plan_pago_cuota.id 
									from 
										plan_pago_cuota 
									where 
										plan_pago_cuota.plan_pago_id = _plan_pago.id	and 
										plan_pago_cuota.estatus_pago in ('P', 'N') 	and 
										vencida = true);
		end if;


	end if;



  return true;
 
end;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;
ALTER FUNCTION eliminamoraprestamos(bigint) OWNER TO cartera;
