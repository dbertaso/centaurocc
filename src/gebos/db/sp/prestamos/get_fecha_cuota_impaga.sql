CREATE OR REPLACE FUNCTION get_fecha_cuota_impaga(_prestamo_id integer)
  RETURNS varchar AS
$BODY$
/*
PROPOSITO: alcanzar facilmente atributos de cliente que pueden estar en las tablas EMPRESA o PERSONA.
PARAMETROS: info_request : [nombre, cedula_rif]
*/
declare
	_resultado varchar = '';
begin 


_resultado = (select fecha from plan_pago_cuota  where plan_pago_id IN ( select id from plan_pago where prestamo_id = _prestamo_id) and estatus_pago = 'N' order by id asc limit 1);



if _resultado IS NULL  then
 _resultado = '';
end if;

	return _resultado;

 
end;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE; 
ALTER FUNCTION get_datos_cliente(_cliente_id integer, info_request varchar) OWNER TO cartera;

