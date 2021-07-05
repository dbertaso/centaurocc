-- Function: eliminaprestamos()

-- DROP FUNCTION eliminaprestamos();

CREATE OR REPLACE FUNCTION eliminaprestamos()
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
  _cur_prestamo refcursor;
 
  
  
begin

	/*
	--------------------------
	Crea cursor de prestamos
	--------------------------
	*/

	open _cur_prestamo for

		select
			* 
		from
		 
			prestamo;

	
	loop

		fetch _cur_prestamo INTO _prestamo;
		exit when not found;

		raise notice 'Comienza proceso de eliminación de prestamo nro: ------->%;', _prestamo.numero;

		open _cur_plan_pago for
	
			select 
				 *
			from
				plan_pago
			where
				plan_pago.prestamo_id	= _prestamo.id;

		loop

			fetch _cur_plan_pago INTO _plan_pago;
			exit when not found;
	
			open _cur_plan_pago_cuota for 

				select 
					*
				from
					plan_pago_cuota
				where
					plan_pago_cuota.plan_pago_id = _plan_pago.id;

			loop

				fetch _cur_plan_pago_cuota INTO _plan_pago_cuota;
				exit when not found;


				delete from pago_cuota where pago_cuota.plan_pago_cuota_id = _plan_pago_cuota.id;
				delete from plan_pago_mora where plan_pago_mora.plan_pago_cuota_id = _plan_pago_cuota.id;
				delete from plan_pago_interes where plan_pago_interes.plan_pago_cuota_id = _plan_pago_cuota.id;
				delete from plan_pago_cuota where plan_pago_cuota.id = _plan_pago_cuota.id;
				
				SELECT setval('pago_cuota_id_seq', 1);
				SELECT setval('plan_pago_mora_id_seq', 1);
				SELECT setval('plan_pago_interes_id_seq', 1);
				SELECT setval('plan_pago_cuota_id_seq', 1);
				
			end loop;
		
			close _cur_plan_pago_cuota;

		end loop;

		delete from plan_pago where plan_pago.id = _plan_pago.id;
		SELECT setval('plan_pago_id_seq', 1);

		close _cur_plan_pago;

		/*eliminacion de plan_pago*/

		delete from plan_pago where plan_pago.prestamo_id = _prestamo.id;
	
		/* Eliminacion de desembolos y registros de tablas asociadas al desembolso */

	
		open _cur_desembolso for 

			select 
				*
			from
				desembolso
			where
				desembolso.prestamo_id = _prestamo.id;

		loop

			fetch _cur_desembolso INTO _desembolso;
			exit when not found;


			delete from desembolso_pago where desembolso_pago.desembolso_id = _desembolso.id;
			delete from factura where factura.desembolso_id = _desembolso.id;
			delete from condicionamiento_desembolso where condicionamiento_desembolso.desembolso_id = _desembolso.id;
			delete from desembolso where desembolso.id = _desembolso.id;
			
			SELECT setval('desembolso_pago_id_seq', 1);
			SELECT setval('factura_id_seq', 1);
			SELECT setval('condicionamiento_desembolso_id_seq', 1);
			SELECT setval('desembolso_id_seq', 1);
				
		end loop;
		
		close  _cur_desembolso;

		delete from factura where factura.prestamo_id = _prestamo.id;
		delete from pago_prestamo where pago_prestamo.prestamo_id = _prestamo.id;
		delete from prestamo_tasa_historico where prestamo_tasa_historico.prestamo_id = _prestamo.id;
		delete from prestamo where prestamo.id = _prestamo.id;
		
		SELECT setval('desembolso_pago_id_seq', 1);
		SELECT setval('factura_id_seq', 1);
		SELECT setval('condicionamiento_desembolso_id_seq', 1);
		SELECT setval('desembolso_id_seq', 1);

		raise notice 'Eliminado prestamo nro: ------->%;', _prestamo.numero;

		delete from prestamo_modificacion where prestamo_id = _prestamo.id;
		SELECT setval('desembolso_id_seq', 1);
		
	end loop;

	close _cur_prestamo;

	
  return true;
 
end;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION eliminaprestamos() OWNER TO gprotec;
