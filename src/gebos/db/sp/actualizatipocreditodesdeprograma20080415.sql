-- Function: actualizatipocreditodesdeprograma()

-- DROP FUNCTION actualizatipocreditodesdeprograma();

CREATE OR REPLACE FUNCTION actualizatipocreditodesdeprograma()
  RETURNS bool AS
$BODY$
declare
  
  _rechazos rechazos%rowtype;
  _solicitud solicitud%rowtype;
  _prestamo prestamo%rowtype;
  _programa programa%rowtype;
  _producto producto%rowtype;
  _fecha_proceso_next date;

  -- Cursor para recorrer los programas sociales y efectuar el cierre diario de cartera
  _cur_programa refcursor;
  _cur_prestamos refcursor;
 
  
  
begin

	/*
	-------------------------------------------------------------------------------
	Crea cursor de rechazos
	-------------------------------------------------------------------------------
	*/

	open _cur_prestamos for 

		select 
			*
		from
			prestamo;

	loop

		fetch _cur_prestamos INTO _prestamo;
		exit when not found;


		select into _solicitud * from solicitud where _prestamo.solicitud_id = solicitud.id;

                select into _programa * from programa where _solicitud.programa_id = programa.id;

		if _programa.tipo_credito_id <> _prestamo.tipo_credito_id then

			if _programa.tipo_credito_id = 2 then
				update prestamo set
						tipo_credito_id = _programa.tipo_credito_id,
						intermediado = true
				where
				       prestamo.id = _prestamo.id;
			else

				update prestamo set 
						tipo_credito_id  = _programa.tipo_credito_id,
						intermediado = false
				where 
					prestamo.id = _prestamo.id;
			end if;

		end if;

	end loop;

	close _cur_prestamos;


	update prestamo set intermediado = true where tipo_credito_id = 2;

  return true;
 
end;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;
ALTER FUNCTION actualizatipocreditodesdeprograma() OWNER TO cartera;
