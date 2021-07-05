CREATE OR REPLACE FUNCTION get_ultimo_desembolso(_prestamo_id integer)
  RETURNS varchar AS
$BODY$
/*
PROPOSITO: alcanzar facilmente atributos de cliente que pueden estar en las tablas EMPRESA o PERSONA.
PARAMETROS: info_request : [nombre, cedula_rif]
*/
declare

	_resultado varchar = '';

begin 



_resultado = (select fecha_realizacion from desembolso where prestamo_id = _prestamo_id and realizado = true order by fecha_realizacion desc limit 1);
if _resultado IS NULL  then
 _resultado = '';
end if;

	return _resultado;

 
end;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE; 
ALTER FUNCTION get_datos_cliente(_cliente_id integer, info_request varchar) OWNER TO cartera;

