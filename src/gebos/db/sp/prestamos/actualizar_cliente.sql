-- Function: actualizar_cliente()

-- DROP FUNCTION actualizar_cliente();

CREATE OR REPLACE FUNCTION actualizar_cliente()
  RETURNS boolean AS
$BODY$
declare
  
  _persona persona%rowtype;
  _fecha_proceso_next date;

  -- Cursor para recorrer los programas sociales y efectuar el cierre diario de cartera
  _cur_persona refcursor;
  
  
begin

	/*
	-------------------------
	Crea cursor de personas
	-------------------------
	*/

	open _cur_persona for 

    select
            * 
    from 
          persona 
              left join cliente on (persona.id = cliente.persona_id)
    where 
          cliente.persona_id is null and
          cliente.empresa_id is null;

	loop

		fetch _cur_persona INTO _persona;
		exit when not found;


    insert
    into
            cliente
                    (persona_id,
                     tipo_cliente_id,
                     "type")
            values
                     (_persona.id,
                      52,
                      'ClientePersona'
                      );

	end loop;

	close _cur_persona;

  return true;
 
end;
$BODY$
  LANGUAGE plpgsql VOLATILE;

