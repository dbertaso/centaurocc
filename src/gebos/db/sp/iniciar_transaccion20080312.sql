-- Function: iniciar_transaccion(p_prestamo_id int4, p_usuario_id int4, p_nombre "varchar", p_tipo bpchar, p_descripcion "varchar")

-- DROP FUNCTION iniciar_transaccion(p_prestamo_id int4, p_usuario_id int4, p_nombre "varchar", p_tipo bpchar, p_descripcion "varchar");

CREATE OR REPLACE FUNCTION iniciar_transaccion(p_prestamo_id int4, p_usuario_id int4, p_nombre "varchar", p_tipo bpchar, p_descripcion "varchar")
  RETURNS bool AS
$BODY$





 declare





   _meta_transaccion meta_transaccion%rowtype;





 begin





   





   select into _meta_transaccion * from meta_transaccion





     where nombre = p_nombre;





 




	if p_nombre <> 'p_dummy' then

		   insert into transaccion (prestamo_id, meta_transaccion_id, usuario_id, fecha, tipo, descripcion)


		     values(p_prestamo_id, _meta_transaccion.id, p_usuario_id, current_timestamp, p_tipo, p_descripcion);

	else
		   insert into transaccion (prestamo_id, meta_transaccion_id, usuario_id, fecha, tipo, descripcion,reversada)


		     values(p_prestamo_id, _meta_transaccion.id, p_usuario_id, current_timestamp, p_tipo, p_descripcion, true);
	end if;





 





   return true;





 





 end;





 $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
ALTER FUNCTION iniciar_transaccion(p_prestamo_id int4, p_usuario_id int4, p_nombre "varchar", p_tipo bpchar, p_descripcion "varchar") OWNER TO cartera;
