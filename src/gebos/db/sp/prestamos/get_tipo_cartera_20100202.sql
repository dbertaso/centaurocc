-- Function: resolver_estatus(character varying)

-- DROP FUNCTION resolver_estatus(character varying);

CREATE OR REPLACE FUNCTION get_tipo_cartera(_p_tipo_cartera_id integer)
  RETURNS character varying AS
$BODY$
/*
PROPOSITO: alcanzar facilmente atributos de cliente que pueden estar en las tablas EMPRESA o PERSONA.
PARAMETROS: info_request : [nombre, cedula_rif]
*/
declare
	
	_resultado varchar = 'INI';
     
begin 

  _resultado = (select nombre from tipo_cartera where tipo_cartera.id = _p_tipo_cartera_id);



	return _resultado;

 
end;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION get_tipo_cartera(_p_tipo_cartera_id integer) OWNER TO cartera;

