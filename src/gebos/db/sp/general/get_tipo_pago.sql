CREATE OR REPLACE FUNCTION get_tipo_pago(_pago_id integer)
  RETURNS varchar AS
$BODY$
/*
PROPOSITO: Devolver indicador si el pago fue un pago REZAGADO -REZ- o fue a tiempo -MES-
PARAMETROS: _pago_id
*/
declare
	_mes_fecha_realizacion integer;
	_mes_fecha_contable integer;
	_valor_final varchar;
begin 

/*
Se precisa el id del cliente, bien sea este empresa o persona
*/
_mes_fecha_contable = (SELECT EXTRACT(MONTH FROM pago_cliente.fecha::date) FROM pago_cliente where id = _pago_id); 
_mes_fecha_realizacion = (SELECT EXTRACT(MONTH FROM pago_cliente.fecha_realizacion::date) FROM pago_cliente where id = _pago_id); 


if (_mes_fecha_contable = _mes_fecha_realizacion) then
	_valor_final = 'MES';
else
	_valor_final = 'REZ';
end if;

return _valor_final;
end;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE; 
ALTER FUNCTION get_tipo_pago(_pago_id integer) OWNER TO cartera;
