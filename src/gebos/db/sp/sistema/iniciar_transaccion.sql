-- Function: iniciar_transaccion(integer, integer, character varying, character, character varying)

-- DROP FUNCTION iniciar_transaccion(integer, integer, character varying, character, character varying);

CREATE OR REPLACE FUNCTION iniciar_transaccion(p_prestamo_id integer,
                                               p_usuario_id integer,
                                               p_nombre character varying,
                                               p_tipo character,
                                               p_descripcion character varying,
                                               p_monto numeric(16,2))
  RETURNS boolean AS
$BODY$

 declare

   _meta_transaccion meta_transaccion%rowtype;

 begin


   select into _meta_transaccion * from meta_transaccion

     where nombre = p_nombre;

	if p_nombre <> 'p_dummy' then

		   insert into transaccion (prestamo_id, meta_transaccion_id, usuario_id, fecha, tipo, descripcion, monto)


		     values(p_prestamo_id, _meta_transaccion.id, p_usuario_id, current_timestamp, p_tipo, p_descripcion, p_monto);

	else
		   insert into transaccion (prestamo_id, meta_transaccion_id, usuario_id, fecha, tipo, descripcion,reversada, monto)


		     values(p_prestamo_id, _meta_transaccion.id, p_usuario_id, current_timestamp, p_tipo, p_descripcion, true, p_monto);
	end if;

   return true;

 end;

 $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
