CREATE OR REPLACE FUNCTION buscar_interes_causado(_pago_prestamo_id integer)
  RETURNS numeric(16,2) AS
$BODY$
/*
PROPOSITO: Buscar el interes causado de un prestamo [e.g. V = Vigente]
PARAMETROS: _pago_prestamo_id : 
*/
declare
	_resultado numeric(16,2) = 0;
	_pago_cuota pago_cuota%rowtype;
begin 

	

	select into _pago_cuota * from pago_cuota where pago_prestamo_id  = _pago_prestamo_id order by id desc limit 1;
	if (_pago_cuota.interes_diferido = 0 and _pago_cuota.interes_mora = 0 and _pago_cuota.capital = 0 and _pago_cuota.remanente_por_aplicar = 0 and _pago_cuota.interes_corriente <> 0) then

	_resultado = _pago_cuota.interes_corriente;
	
	else
	_resultado = 0;

	end if;

	return _resultado;

 
end;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE; 
ALTER FUNCTION buscar_interes_causado(_pago_prestamo_id integer) OWNER TO cartera;
