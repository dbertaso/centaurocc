-- Function: actualizamontodesembolsocuota(pid_programa int4)

-- DROP FUNCTION actualizamontodesembolsocuota(pid_programa int4);

CREATE OR REPLACE FUNCTION ajustarriesgoyprovision()
  RETURNS bool AS
$BODY$

begin

UPDATE
prestamo
SET
porcentaje_riesgo_sudeban =
	(SELECT porcentaje_riesgo
	FROM
	riesgo_sudeban
	WHERE
	(prestamo.cantidad_cuotas_vencidas*prestamo.frecuencia_pago)*30  BETWEEN dias_vencidos_cota_inferior AND dias_vencidos_cota_superior),

clasificacion_riesgo_sudeban =
	(SELECT categoria
	FROM
	riesgo_sudeban
	WHERE
	(prestamo.cantidad_cuotas_vencidas*prestamo.frecuencia_pago)*30   BETWEEN dias_vencidos_cota_inferior AND dias_vencidos_cota_superior),

conversion_cuotas_mensuales_sudeban =
        ((prestamo.cantidad_cuotas_vencidas*prestamo.frecuencia_pago)*30/30),

provision_individual_sudeban =
	(prestamo.saldo_insoluto*(SELECT porcentaje_riesgo
	FROM
	riesgo_sudeban
	WHERE
	(prestamo.cantidad_cuotas_vencidas*prestamo.frecuencia_pago)*30  BETWEEN dias_vencidos_cota_inferior AND dias_vencidos_cota_superior)/100),
--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXx
porcentaje_riesgo_bandes =
	(SELECT porcentaje_riesgo
	FROM
	riesgo_institucion
	WHERE
	(prestamo.cantidad_cuotas_vencidas*prestamo.frecuencia_pago)*30  BETWEEN dias_vencidos_cota_inferior AND dias_vencidos_cota_superior),

clasificacion_riesgo_bandes =
	(SELECT categoria
	FROM
	riesgo_institucion
	WHERE
	(prestamo.cantidad_cuotas_vencidas*prestamo.frecuencia_pago)*30  BETWEEN dias_vencidos_cota_inferior AND dias_vencidos_cota_superior),

conversion_cuotas_mensuales_bandes =
        ((prestamo.cantidad_cuotas_vencidas*prestamo.frecuencia_pago)*30/30),

provision_individual_bandes =
	(prestamo.saldo_insoluto*(SELECT porcentaje_riesgo
	FROM
	riesgo_institucion
	WHERE
	(prestamo.cantidad_cuotas_vencidas*prestamo.frecuencia_pago)*30  BETWEEN dias_vencidos_cota_inferior AND dias_vencidos_cota_superior)/100);


return true;

end;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;
ALTER FUNCTION actualizamontodesembolsocuota(p_numero int8, p_monto decimal(16,2)) OWNER TO cartera;

