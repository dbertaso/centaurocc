-- Function: eliminacliente()

-- DROP FUNCTION eliminacliente();

CREATE OR REPLACE FUNCTION eliminacliente()
  RETURNS boolean AS
$BODY$
declare
  
  _rechazos rechazos%rowtype;
  _prestamo prestamo%rowtype;
  _solicitud solicitud%rowtype;
  _cliente cliente%rowtype;
  _persona persona%rowtype;
  _empresa empresa%rowtype;
  _pago_cliente pago_cliente%rowtype;
  _garantia garantia%rowtype;
  _empresa_integrante empresa_integrante %rowtype;
  _empresa_integrante_tipo empresa_integrante_tipo%rowtype;
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
  _cliente_id int8;

  -- Cursor para recorrer los programas sociales y efectuar el cierre diario de cartera
  _cur_plan_pago_cuota refcursor;
  _cur_plan_pago refcursor;
  _cur_solicitud refcursor;
  _cur_desembolso refcursor;
  _cur_prestamo refcursor;
  _cur_resultado_cualitativa refcursor;
  _cur_evaluacion_flujo_caja_detalle refcursor;
  _cur_solicitud_evento refcursor;
  _cur_solicitud_capacidad refcursor;
  _cur_garantia refcursor;
  _cur_cliente refcursor;
  _cur_empresa_integrante refcursor;
  _cur_pago_cliente refcursor;
  _exito boolean;

  
begin

	/*
	--------------------------------------------
	Se crea cursor de cliente para eliminarlos
	--------------------------------------------
	*/

	open _cur_cliente for

		select 
			 *
		from
			cliente;

	loop

		fetch _cur_cliente INTO _cliente;
		exit when not found;
		
		/*
		----------------------------------------------------------------------------
		Se crea cursor de solicitudes relacionadas con el cliente para eliminarlas
		----------------------------------------------------------------------------
		*/

		open _cur_solicitud for

			select 
				 *
			from
				solicitud
			where
				solicitud.cliente_id = _cliente.id;
		loop

			--raise notice 'paso por cursor solicitud-------------------% ', _cliente.id;
			
			fetch _cur_solicitud INTO _solicitud;
			exit when not found;
			
			--raise notice 'Solicitud Nro.-------------------% ', _solicitud.numero;

			/* Eliminación de solicitud */
			
			raise notice 'Eliminando solicitud nro.-------------------% ', _solicitud.numero;
			
			_exito = eliminasolicitud(_solicitud.numero);

			if _exito = false then
				return false;
			end if;
		
		end loop; --> _cur_solicitud

		close _cur_solicitud;		

  end loop;	--> fin _cur_cliente
  
  close _cur_cliente;


/*
-----------------------------------------------------------------------
Eliminando registro de cliente_antecedente relacionado con el cliente
-----------------------------------------------------------------------
*/

delete from cliente_antecedente;
SELECT setval('cliente_antecedente_id_seq', 1);


/*
-----------------------------------------------------------------------------------
Se crea cursor de pago_cliente relacionadas con el cliente para eliminarlos
-----------------------------------------------------------------------------------
*/

open _cur_pago_cliente for

	select 
		 *
	from
		pago_cliente;
loop

	fetch _cur_pago_cliente INTO _pago_cliente;
	exit when not found;

	/*
	------------------------------------------------------------------------------------------------
	Se elimina el registro de pago_cliente y pago_cliente_forma relacionado con empresa_integrante
	------------------------------------------------------------------------------------------------
	*/


	delete from pago_forma where pago_cliente_id = _pago_cliente.id;
	SELECT setval('pago_forma_id_seq', 1);
	
end loop; --> Fin _cur_pago_cliente

close _cur_pago_cliente;

delete from pago_cliente;
SELECT setval('pago_cliente_id_seq', 1);

/*
--------------------------------
Eliminando registro de cliente
--------------------------------
*/		

raise notice 'Eliminando Cliente.-------------------% ', _cliente.id;

delete from cliente where empresa_id = _cliente.id;
SELECT setval('cliente_id_seq', 1);

/*
--------------------------------------
Comienza eliminación persona/empresa
--------------------------------------
*/

open _cur_empresa_integrante for

	select 
		 *
	from
		empresa_integrante;
loop

	fetch _cur_empresa_integrante INTO _empresa_integrante;
	exit when not found;

	/*
	--------------------------------------------------------------------------------------
	Se elimina el registro de empresa_integrante_tipo relacionado con empresa_integrante
	--------------------------------------------------------------------------------------
	*/

	delete from empresa_integrante_tipo where empresa_integrante_id = _empresa_integrante.id;
	delete from prestamo_rubro_atributo;
	delete from prestamo_rubro;
	delete from empresa_integrante where id = _empresa_integrante.id;

	SELECT setval('empresa_integrante_tipo_id_seq', 1);
	SELECT setval('prestamo_rubro_atributo_id_seq', 1);
	SELECT setval('prestamo_rubro_id_seq', 1);
	SELECT setval('empresa_integrante_id_seq', 1);

	
end loop; -- Fin _cur_empresa_integrante

close _cur_empresa_integrante;

/*
------------------------------------
Eliminando telefono de la empresa
------------------------------------
*/

delete from empresa_telefono;
SELECT setval('empresa_telefono_id_seq', 1);

/*
------------------------------------
Eliminando dirección de la empresa
------------------------------------
*/

delete from empresa_direccion;
delete from empresa_email;

SELECT setval('empresa_direccion_id_seq', 1);
SELECT setval('empresa_email_id_seq', 1);


/*
-----------------------
Eliminando la empresa
-----------------------
*/


raise notice 'Eliminando empresa -------------------% ', _cliente_id;
delete from empresa;
SELECT setval('empresa_id_seq', 1);


/*
------------------------------------
Eliminando telefono de la persona
------------------------------------
*/

delete from persona_telefono;
SELECT setval('persona_telefono_id_seq', 1);

/*
------------------------------------
Eliminando dirección de la persona
------------------------------------
*/

delete from persona_direccion;
delete from persona_email;

SELECT setval('persona_direccion_id_seq', 1);
SELECT setval('persona_email_id_seq', 1);

/*
--------------------
Eliminando persona
--------------------
*/

raise notice 'Eliminando persona -------------------% ', _cliente_id;
delete from persona;
SELECT setval('persona_id_seq', 1);

	
  return true;
 
end;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION eliminacliente() OWNER TO gprotec;
