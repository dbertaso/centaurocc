-- Function: ejecutar_cierre_batch()

-- DROP FUNCTION ejecutar_cierre_batch();

CREATE OR REPLACE FUNCTION ejecutar_cierre_batch()
  RETURNS boolean AS
$BODY$
declare
  _programa programa%rowtype;
  _control_cierre control_cierre%rowtype;
  _fecha_proceso_next date;

  -- Cursor para recorrer los programas sociales y efectuar el cierre diario de cartera
  _cur_programa refcursor;


begin

	/*
	-------------------------------------------------------------------------------
	Se verifica que el cierre no se encuentre ejecutandose o que ya fue ejecutado.
	-------------------------------------------------------------------------------
	*/

	select into
			_control_cierre *
	from
			control_cierre
	where
			control_cierre.senal_enproceso 	= false and
			control_cierre.senal_cerrado	= false and
      control_cierre.senal_shell	= false;

	if _control_cierre.fecha_proceso is not null then

		/*
		------------------------------------------------------------------
		Actualizacion de la senal en proceso para la tabla control_cierre
		-------------------------------------------------------------------
		*/

		update control_cierre set
					senal_enproceso = true
		where
					control_cierre.id = _control_cierre.id;

		/*
		------------------------------------------------------------------
		Construccion del cursor de programas
		------------------------------------------------------------------
		*/

		select  into _programa *

				from
					programa
				where
					programa.fecha_cierre < _control_cierre.fecha_proceso
				order by
					programa.id
        limit 1;


		/*
		----------------------------------------------------
		Inicio del loop del cierre de cartera por programa
		----------------------------------------------------
		*/

		if _programa.id is not null then

			raise notice 'Cerrando el programa__________________________________ % ', _programa.nombre;

			perform calcular_cartera_programa(_control_cierre.fecha_proceso,1,_programa.id);

			raise notice 'Fin del cierre del programa___________________________ % ', _programa.nombre;

			/*
			-------------------------------------------
			Actualiza la fecha de cierre del programa
			-------------------------------------------
			*/

      if _control_cierre.ultimo_prestamo = 0 then

          update programa set
              fecha_cierre = _control_cierre.fecha_proceso
          where
              programa.id = _programa.id;

      end if;

			/*
			------------------------------------------------------------------
			Actualizacion de la senal en proceso para la tabla control_cierre
			-------------------------------------------------------------------
			*/

			update control_cierre set
						senal_enproceso = false
			where
						control_cierre.id = _control_cierre.id;

			/*
			-------------------------------------------------------
			Se retorna el valor false para continuar con el cierre
			de los siguientes programas desde el shell
			-------------------------------------------------------
			*/

			return false;

		else

			/*
			----------------------------------------------------------------
			Actualizacion de la senal cerrado para la tabla control_cierre
			----------------------------------------------------------------
			*/

			update control_cierre set
						senal_cerrado = true,
						fecha_ejecucion = current_date
			where
						control_cierre.id = _control_cierre.id;

			/*
			-----------------------------------------------------------------
			Generacion de nuevo registro en la tabla control_cierre para la
			proxima ejecucion del cierre de cartera
			-----------------------------------------------------------------
			*/

			_fecha_proceso_next = _control_cierre.fecha_proceso + 1;

			insert into control_cierre
						(
							fecha_proceso
						)
					values
						(
							_fecha_proceso_next
						);

		end if;			--> if _programa.id not is null then

	end if;				--> if _control_cierre.fecha_proceso is not null then

  raise notice 'Finalizo el proceso de Cierre de Cartera_________________________';
  return true;

end;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION ejecutar_cierre_batch() OWNER TO cartera;
