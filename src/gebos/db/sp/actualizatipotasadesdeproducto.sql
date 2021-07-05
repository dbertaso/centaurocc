-- Function: actualizatipotasadesdeproducto()

-- DROP FUNCTION actualizatipotasadesdeproducto();

CREATE OR REPLACE FUNCTION actualizatipotasadesdeproducto()
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

                select into _producto * from producto where _solicitud.programa_id = producto.programa_id and
							    _prestamo.partida_id = producto.partida_id;

		if _producto.tasa_fija <> _prestamo.tasa_fija then

			update prestamo set prestamo.tasa_fija  = _producto.tasa_fija
			where prestamo.id = _prestamo.id;

		end if;

	end loop;

	close _cur_prestamos;

  return true;
 
end;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;
ALTER FUNCTION actualizatipotasadesdeproducto() OWNER TO cartera;
