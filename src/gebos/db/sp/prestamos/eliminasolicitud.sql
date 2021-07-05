-- Function: eliminasolicitud(bigint)

-- DROP FUNCTION eliminasolicitud(bigint);

CREATE OR REPLACE FUNCTION eliminasolicitud(pnumero bigint)
  RETURNS boolean AS
$BODY$
declare
  
  _rechazos rechazos%rowtype;
  _prestamo prestamo%rowtype;
  _solicitud solicitud%rowtype;
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
  _cur_plan_pago_cuota refcursor;
  _cur_plan_pago refcursor;
  _cur_desembolso refcursor;
  _cur_prestamo refcursor;
  _cur_resultado_cualitativa refcursor;
  _cur_evaluacion_flujo_caja_detalle refcursor;
  _cur_solicitud_evento refcursor;
  _cur_solicitud_capacidad refcursor;
  _cur_garantia refcursor;
  _exito boolean;

  
begin


	/*
	---------------------------------------------------
	Lectura de solicitud para comenzar la eliminación
	---------------------------------------------------
	*/

	select 
		into _solicitud * 
	from 
		solicitud
	where
		solicitud.numero = pnumero;

	
	if found then

		/*
		--------------------------------------------------------------
		Se crea cursor de prestamos dependientes de la solicitud que
		se esta eliminando para eliminarlos
		--------------------------------------------------------------
		*/

		open _cur_prestamo for

			select 
				 *
			from
				prestamo
			where
				prestamo.solicitud_id	= _solicitud.id;

		loop

			fetch _cur_prestamo INTO _prestamo;
			exit when not found;
			
			_exito = eliminaprestamosmigracion(_prestamo.numero);

			if _exito = false then
				return false;
			end if;
			
		end loop;

		close _cur_prestamo;

		/*
		------------------------------------
		Lectura del registro de evaluacion
		------------------------------------
		*/
		
		select 
			into _evaluacion *
		from
			evaluacion
		where
			evaluacion.solicitud_id = _solicitud.id;


		if found then

			/*
			-----------------------------------------------------------------------------------
			Lectura de evaluacion cualitativa para eliminar registro de resultado_cualitativa
			-----------------------------------------------------------------------------------
			*/
			
			select into _evaluacion_cualitativa *
			from
				evaluacion_cualitativa
			where
				evaluacion_cualitativa.evaluacion_id = _evaluacion.id;

			/*
			-------------------------------------------------------------
			Cursor de resultado cualitativa para eliminar los registros
			-------------------------------------------------------------
			*/

			if found then
			
				open _cur_resultado_cualitativa for

					select 
						 *
					from
						resultado_cualitativa
					where
						resultado_cualitativa.evaluacion_cualitativa_id = _evaluacion_cualitativa.id;

				loop

					fetch _cur_resultado_cualitativa INTO _resultado_cualitativa;
					exit when not found;

					/*
					--------------------------------------------------------
					Eliminación de registro de tabla resultado_cualitativa
					--------------------------------------------------------
					*/

					delete from 
						resultado_cualitativa
					where 
						resultado_cualitativa.id = _resultado_cualitativa.id;
					
				end loop;

				close _cur_resultado_cualitativa;

			end if;
			
			/*
			-------------------------------------------------------------
			Eliminación de registro de tabla evaluacion_analisis_costos
			-------------------------------------------------------------
			*/

			delete from 
				evaluacion_analisis_costos
			where 
				evaluacion_analisis_costos.evaluacion_id = _evaluacion_cualitativa.id;
				
			/*
			---------------------------------------------------------
			Eliminación de registro de tabla evaluacion_cualitativa
			---------------------------------------------------------
			*/

			delete from 
				evaluacion_cualitativa
			where 
				evaluacion_cualitativa.id = _evaluacion.id;
				
			/*
			-------------------------------------------------------------
			Eliminación de registro de tabla evaluacion_financiera
			-------------------------------------------------------------
			*/

			delete from 
				evaluacion_financiera
			where 
				evaluacion_financiera.evaluacion_id = _evaluacion.id;

			/*
			------------------------------------------------------------------------------------------
			Lectura de evaluacion_flujo_caja para eliminar registro de evaluacion_flujo_caja_detalle
			------------------------------------------------------------------------------------------
			*/
			
			select
				into _evaluacion_flujo_caja *
			from
				evaluacion_flujo_caja
			where
				evaluacion_flujo_caja.evaluacion_id = _evaluacion.id;


			if found then

				/*
				------------------------------------------------------------
				Cursor de evaluacion_flujo_caja_detalle para eliminar los registros
				------------------------------------------------------------
				*/
				
				open _cur_evaluacion_flujo_caja_detalle for

					select 
						 *
					from
						evaluacion_flujo_caja_detalle
					where
						evaluacion_flujo_caja_detalle.evaluacion_flujo_caja_id = _evaluacion_flujo_caja.id;

				loop

					fetch _cur_evaluacion_flujo_caja_detalle INTO _evaluacion_flujo_caja_detalle;
					exit when not found;

					/*
					----------------------------------------------------------------
					Eliminación de registro de tabla evaluacion_flujo_caja_detalle
					----------------------------------------------------------------
					*/

					delete from 
						evaluacion_flujo_caja_detalle
					where 
						evaluacion_flujo_caja_detalle.id = evaluacion_flujo_caja_detalle.id;
					
				end loop;

				close _cur_evaluacion_flujo_caja_detalle;

			end if;
			
			/*
			--------------------------------------------------------
			Eliminación de registro de tabla evaluacion_flujo_caja
			--------------------------------------------------------
			*/

			delete from 
				evaluacion_flujo_caja
			where 
				evaluacion_flujo_caja.evaluacion_id = _evaluacion.id;
				
			/*
			------------------------------------------------------------
			Eliminación de registro de tabla evaluacion_plan_inversion
			------------------------------------------------------------
			*/

			delete from 
				evaluacion_plan_inversion
			where 
				evaluacion_plan_inversion.evaluacion_id = _evaluacion.id;

		end if;
		
		/*
		------------------------------------------------
		Cursor de garantia para eliminar los registros
		------------------------------------------------
		*/
		
		open _cur_garantia for

			select 
				 *
			from
				garantia
			where
				garantia.solicitud_id = _solicitud.id;

		loop

			fetch _cur_garantia INTO _garantia;
			exit when not found;

			/*
			-------------------------------------------
			Eliminación de registro de tabla garantia
			-------------------------------------------
			*/

			delete from 
				garantia
			where 
				garantia.id = _garantia.id;
				
		end loop;

		close _cur_garantia;

		/*
		-------------------------------------------
		Eliminación de registro de tabla garantia
		-------------------------------------------
		*/

		delete from 
			garantia
		where 
			garantia.id = _solicitud.id;


		/*
		----------------------------------------------------
		Cursor de solicitud_evento para eliminar registros
		----------------------------------------------------
		*/
		
		open _cur_solicitud_evento for

			select 
				 *
			from
				solicitud_evento
			where
				solicitud_evento.solicitud_id = _solicitud.id;

		loop

			fetch _cur_solicitud_evento INTO _solicitud_evento;
			exit when not found;

			/*
			----------------------------------------------------------------
			Eliminación de registro de tabla evaluacion_flujo_caja_detalle
			----------------------------------------------------------------
			*/

			delete from 
				solicitud_evento
			where 
				solicitud_evento.id = _solicitud_evento.id;
			
		end loop;

		close _cur_solicitud_evento;

		/*
		------------------------------------------------------------------
		Elimina los registros de capacidad relacionados con la solicitud
		------------------------------------------------------------------
		*/

		delete from 
			solicitud_capacidad
		where 
			solicitud_capacidad.solicitud_id = _solicitud.id;

		/*
		------------------------------------------------------------------
		Elimina los registros de historico relacionados con la solicitud
		------------------------------------------------------------------
		*/

		delete from 
			solicitud_historico
		where 
			solicitud_historico.solicitud_id = _solicitud.id;

		/*
		-----------------------------------------------------------------
		Elimina los registros de recaudos relacionados con la solicitud
		-----------------------------------------------------------------
		*/

		delete from 
			solicitud_recaudo
		where 
			solicitud_recaudo.solicitud_id = _solicitud.id;

		/*
		-----------------------------------------------------------------
		Elimina el registro de evaluacion relacionados con la solicitud
		-----------------------------------------------------------------
		*/

		delete from 
			evaluacion
		where 
			evaluacion.solicitud_id = _solicitud.id;
			
	end if;

	/*
	-----------------------------
	Eliminación de la solicitud
	-----------------------------
	*/
	
	delete from 
		solicitud
	where
		solicitud.numero = pnumero;
		

  return true;
 
end;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;
ALTER FUNCTION eliminasolicitud(bigint) OWNER TO cartera;


