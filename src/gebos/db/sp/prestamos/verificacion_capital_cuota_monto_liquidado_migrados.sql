-- Function: eliminaprestamosmigracion(bigint)

-- DROP FUNCTION eliminaprestamosmigracion(bigint);

CREATE OR REPLACE FUNCTION actualizadiferido(pnumero bigint, monto_diferido decimal(16,2))
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

	/*
	----------------------
	Lectura del prestamo
	----------------------
	*/
	
	select 
		into _prestamo * 
	from 
		prestamo
	where
		prestamo.numero = pnumero;


	/*
	----------------------
	Lectura de Plan Pago
	----------------------
	*/

	if found then
	
		select 
			into _plan_pago *
		from
			plan_pago
		where
			plan_pago.prestamo_id	= _prestamo.id	and
			plan_pago.activo 	= true;

	end if;

	/*
	----------------------------------------------------------------
	Si el plan_pago existe se procede a actualizar plan_pago_cuota
	----------------------------------------------------------------
	*/
	
	if found then

		/*
		--------------------------------------------------------
		Actualización de cuotas de gracia a totalmente pagadas
		antes de actualizar los montos diferidos
		--------------------------------------------------------
		*/
		
		update
			plan_pago_cuota
		set
			estatus_pago	= 'T'
		where
			plan_pago_cuota.tipo_cuota 	= 'G' 		and
			plan_pago_cuota.plan_pago_id 	= _plan_pago.id;

		/*
		----------------------------------------------------------------
		Actualización del monto diferido en las cuotas que estan
		exigibles y no exigibles. (Se excluyen las cuotas parcialmente 
		pagadas y totalmente pagadas)
		-----------------------------------------------------------------
		*/

		update 
			plan_pago_cuota
		set
			interes_diferido = monto_diferido
		where
			plan_pago_cuota.plan_pago_id 	= _plan_pago.id	and
			plan_pago_cuota.tipo_cuota	= 'C'		and
			plan_pago_cuota.estatus_pago	in ('N', 'X');
		
	end if;



  return true;
 
end;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE;
ALTER FUNCTION actualizadiferido(bigint,decimal(16,2)) OWNER TO cartera;
