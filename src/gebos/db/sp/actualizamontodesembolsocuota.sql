-- Function: actualizamontodesembolsocuota(pid_programa int4)

-- DROP FUNCTION actualizamontodesembolsocuota(pid_programa int4);

CREATE OR REPLACE FUNCTION actualizamontodesembolsocuota(p_numero int8, p_monto decimal(16,2))
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

	/*
	--------------------------
	Crea rowset de prestamos
	--------------------------
	*/

		select into _prestamo * 
			from 
				prestamo 
			where 
				prestamo.numero = p_numero;

		select into _plan_pago * 
				from 
					plan_pago 

				where 
					prestamo_id = _prestamo.id and activo = true;



		select into _plan_pago_cuota * 

				from 
					plan_pago_cuota 

				where 
					plan_pago_id = _plan_pago.id and (estatus_pago = 'T' or estatus_pago = 'P')

		     order by fecha desc limit 1;

		if found then

			update plan_pago_cuota 
			set
				monto_desembolso = p_monto
			where
				plan_pago_cuota.id = _plan_pago_cuota.id;

			raise notice 'Numero de Prestamo__%', _prestamo.numero;
			raise notice 'Numero de Cuota__%', _plan_pago_cuota.numero;
			raise notice 'Monto de Cuota__%', _plan_pago_cuota.monto_desembolso;
			raise notice '*****************************************************************';
		end if;


  return true;
 
end;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;
ALTER FUNCTION actualizamontodesembolsocuota(p_numero int8, p_monto decimal(16,2)) OWNER TO cartera;
