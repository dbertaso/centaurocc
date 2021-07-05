CREATE OR REPLACE FUNCTION totalizador_pagos_estadistica_estado_geografico(_p_mes integer, _p_ano integer,  _p_estado_geografico_id integer, _p_estatus_requerido varchar, _p_monto_concurrencia integer, _p_banco_origen varchar)
  RETURNS numeric(16,2) AS
$BODY$
/*
PROPOSITO: alcanzar facilmente atributos de cliente que pueden estar en las tablas EMPRESA o PERSONA.
PARAMETROS: info_request : [nombre, cedula_rif]
*/
declare
	_resultado numeric(16,2) = 0;
      --  _resultado_cancelados numeric(16,2) = 0;
begin 

if (_p_monto_concurrencia = 1) then
_resultado =  (select sum(capital + abono_capital) from view_resumen_pagos_cierre_extendido where EXTRACT(MONTH FROM view_resumen_pagos_cierre_extendido.fecha_contable::date)::integer = _p_mes AND EXTRACT(YEAR FROM view_resumen_pagos_cierre_extendido.fecha_contable::date)::integer = _p_ano AND estatus_despues_del_pago = _p_estatus_requerido AND estado = _p_estado_geografico_id::varchar AND banco_origen = _p_banco_origen);

	--if (_p_estatus_requerido = 'V') then
	--_resultado =  (select sum(capital) from view_resumen_pagos_cierre_extendido where EXTRACT(MONTH FROM view_resumen_pagos_cierre_extendido.fecha::date)::integer = _p_mes AND EXTRACT(YEAR FROM 		 view_resumen_pagos_cierre_extendido.fecha::date)::integer = _p_ano AND estatus_despues_del_pago = _p_estatus_requerido AND estado = _p_estado_geografico_id::varchar AND banco_origen = _p_banco_origen);

   --     end if;
else
_resultado = (select count(*) from view_resumen_pagos_cierre_extendido where EXTRACT(MONTH FROM view_resumen_pagos_cierre_extendido.fecha_contable::date)::integer = _p_mes AND EXTRACT(YEAR FROM view_resumen_pagos_cierre_extendido.fecha_contable::date)::integer = _p_ano AND estatus_despues_del_pago = _p_estatus_requerido  AND estado = _p_estado_geografico_id::varchar AND banco_origen = _p_banco_origen);


	--if (_p_estatus_requerido = 'V') then
        --end if;



end if;

if _resultado is null then
_resultado = 0;
end if;

	return _resultado;
end;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE; 
ALTER FUNCTION  totalizador_pagos_estadistica_estado_geografico(_p_mes integer, _p_ano integer,  _p_estado_geografico_id integer, _p_estatus_requerido varchar, _p_monto_concurrencia integer, _p_banco_origen varchar) OWNER TO cartera;

