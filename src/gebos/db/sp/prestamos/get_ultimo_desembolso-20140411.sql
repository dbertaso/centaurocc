-- Function: get_ultimo_desembolso(integer)

-- DROP FUNCTION get_ultimo_desembolso(integer);

CREATE OR REPLACE FUNCTION get_ultimo_desembolso(_prestamo_id integer)
  RETURNS character varying AS
$BODY$
/*
PROPOSITO: alcanzar facilmente atributos de cliente que pueden estar en las tablas EMPRESA o PERSONA.
PARAMETROS: info_request : [nombre, cedula_rif]
*/
declare

  _resultado varchar = '';

begin 



_resultado = (select fecha_valor from desembolso where prestamo_id = _prestamo_id and realizado = true order by fecha_valor desc limit 1);
if _resultado IS NULL  then
 _resultado = '';
end if;

  return _resultado;

 
end;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

