CREATE OR REPLACE FUNCTION get_ventas_analista_cartera(_p_mes integer, _p_ano integer, _p_tipo_cartera_id integer, _p_nombre_completo_analista varchar,  _p_banco_origen varchar)
  RETURNS numeric(16,2) AS
$BODY$
/*
PROPOSITO: alcanzar facilmente atributos de cliente que pueden estar en las tablas EMPRESA o PERSONA.
PARAMETROS: info_request : [nombre, cedula_rif]
*/
declare
	_resultado numeric(16,2) = 0;
begin 

_resultado =  (select sum(capital + abono_capital) from view_resumen_pagos_cierre_extendido where EXTRACT(MONTH FROM view_resumen_pagos_cierre_extendido.fecha::date)::integer = _p_mes AND EXTRACT(YEAR FROM view_resumen_pagos_cierre_extendido.fecha::date)::integer = _p_ano  AND banco_origen = _p_banco_origen AND analista = _p_nombre_completo_analista AND tipo_cartera_id = _p_tipo_cartera_id);

if _resultado is null then
_resultado = 0;
end if;



	return _resultado;
end;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE; 
