CREATE OR REPLACE FUNCTION totalizador_pagos_estadistica(_p_mes integer, _p_ano integer,  _p_sector_economico_id integer, _p_estatus_requerido varchar, _p_monto_concurrencia integer, _p_banco_origen varchar)
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
_resultado =  (select sum(capital + abono_capital) from view_resumen_pagos_cierre_extendido where EXTRACT(MONTH FROM view_resumen_pagos_cierre_extendido.fecha_contable::date)::integer = _p_mes AND EXTRACT(YEAR FROM view_resumen_pagos_cierre_extendido.fecha_contable::date)::integer = _p_ano AND estatus_despues_del_pago = _p_estatus_requerido AND sector_economico = _p_sector_economico_id::varchar AND banco_origen = _p_banco_origen);


--	if (_p_estatus_requerido = 'V') then
--	_resultado_cancelados = (select sum(capital) from view_resumen_pagos_cierre_extendido where EXTRACT(MONTH FROM view_resumen_pagos_cierre_extendido.fecha::date)::integer = _p_mes AND EXTRACT(YEAR FROM 	view_resumen_pagos_cierre_extendido.fecha::date)::integer = _p_ano AND estatus_despues_del_pago = 'C' AND sector_economico = _p_sector_economico_id::varchar AND banco_origen = _p_banco_origen);
  --      end if;


else
_resultado = (select count(*) from view_resumen_pagos_cierre_extendido where EXTRACT(MONTH FROM view_resumen_pagos_cierre_extendido.fecha_contable::date)::integer = _p_mes AND EXTRACT(YEAR FROM view_resumen_pagos_cierre_extendido.fecha_contable::date)::integer = _p_ano AND estatus_despues_del_pago = _p_estatus_requerido  AND sector_economico = _p_sector_economico_id::varchar AND banco_origen = _p_banco_origen);


	--if (_p_estatus_requerido = 'V') then
	--_resultado_cancelados = (select count(*) from view_resumen_pagos_cierre_extendido where EXTRACT(MONTH FROM view_resumen_pagos_cierre_extendido.fecha::date)::integer = _p_mes AND EXTRACT(YEAR FROM 		view_resumen_pagos_cierre_extendido.fecha::date)::integer = _p_ano AND estatus_despues_del_pago =  'C'  AND sector_economico = _p_sector_economico_id::varchar AND banco_origen = _p_banco_origen);
	--end if;

end if;

if _resultado is null then
_resultado = 0;
end if;

--if _resultado_cancelados is null then
--_resultado_cancelados = 0;
--end if;


	return _resultado;
end;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE; 
