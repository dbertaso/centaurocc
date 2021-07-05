-- Function: EliminaPrestamosMigracion()

-- DROP FUNCTION EliminaPrestamosMigracion();

CREATE OR REPLACE FUNCTION EliminaPrestamosMigracion(pnumero int8)
  RETURNS bool AS
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

	
	if found

		select 
			into _plan_pago *
		from
			plan_pago
		where
			plan_pago.prestamo_id	= _prestamo.id and
			plan_pago.activo	= true;

	
		open _cur_plan_pago_cuota for 

			select 
				*
			from
				plan_pago_cuota
			where
				plan_pago_cuota.plan_pago_id = _plan_pago.id

		loop

			fetch _cur_plan_pago_cuota INTO _plan_pago_cuota;
			exit when not found;


			delete from pago_cuota where pago_cuota.plan_pago_cuota_id = _plan_pago_cuota.id;
			delete from plan_pago_mora where plan_pago_mora.plan_pago_cuota_id = _plan_pago_cuota.id;
			delete from plan_pago_interes where plan_pago_interes.plan_pago_cuota_id = _plan_pago_cuota.id;
			delete from plan_pago_cuota where plan_pago.id = _plan_pago_cuota.id;
			
		end loop;
		
		close cursor _cur_plan_pago_cuota;

		/*eliminacion de plan_pago*/

		delete from plan_pago where plan_pago.id = _plan_pago.id;
	
		/* Eliminacion de desembolos y registros de tablas asociadas al desembolso */

	
		open _cur_desembolso for 

			select 
				*
			from
				desembolso
			where
				desembolso.prestamo_id = _prestamo.id

		loop

			fetch _cur_desembolso INTO _desembolso;
			exit when not found;


			delete from desembolso_pago where desembolso_pago.desembolso_id = _desembolso.id;
			delete from factura where factura.desembolso_id = _desembolso.id;
			delete from condicionamiento_desembolso where condicionamiento_desembolso.desembolso_id = _desembolso.id;
			delete from desembolso where desembolso.id = _desembolso.id;
			
		end loop;
		
		close cursor _cur_desembolso;

		delete from factura where factura.prestamo_id = _prestamo.id;
		delete from pago_prestamo where pago_prestamo.prestamo_id = _prestamo.id;
		delete from prestamo_tasa_historico where prestamo_tasa_historico = _prestamo.id;
		delete from prestamo where prestamo.id = _prestamo.id;

	end;



  return true;
 
end;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;
ALTER FUNCTION EliminaPrestamosMigracion(pnumero int8) OWNER TO cartera;

