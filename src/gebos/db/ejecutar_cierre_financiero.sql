CREATE OR REPLACE FUNCTION ejecutar_cierre_financiero(p_ano int, p_mes int)
  RETURNS boolean AS
$BODY$
declare
--  _programa programa%rowtype;
  _control_cierre control_cierre%rowtype;
  _prestamo_historico prestamo_historico%rowtype;
  _mes_cierre int;
  _ano_cierre int;
--  _fecha_proceso_next date;

--   Cursor para recorrer los programas sociales y efectuar el cierre diario de cartera
--  _cur_programa refcursor;


begin



	  _mes_cierre = p_mes;
	  _ano_cierre = p_ano;

    /*
    ---------------------------------------------------------
    Se elimina el registro si existe para evitar duplicidad
    de datos en el histórico
    ---------------------------------------------------------
    */

    select into _prestamo_historico *
    from
         prestamo_historico
    where
		      mes = _mes_cierre and
		      ano = _ano_cierre
		limit 1;

		if found then
		  delete
		  from
		        prestamo_historico
		  where
		        mes = _mes_cierre and
		        ano = _ano_cierre;
		end if;

    /*
    ----------------------------------------------------------
    Se genera el histórico de préstamos del mes y año
    correspndiente al cierre financiero
    ----------------------------------------------------------
    */

		insert
		into
		      prestamo_historico
		                          (id, mes, ano, numero, producto_id,
		                           monto_solicitado, monto_aprobado, fecha_aprobacion, formula_id,
		                           tasa_fija, tasa_id, diferencial_tasa, tasa_referencia_inicial,
		                           plazo, meses_fijos_sin_cambio_tasa, meses_gracia_si,
		                           meses_gracia, meses_muertos_si, meses_muertos, cliente_id,
		                           tipo_credito_id, oficina_id, solicitud_id, estatus,
		                           tasa_mora_id, forma_calculo_intereses, base_calculo_intereses,
                               permitir_abonos, abono_forma, abono_porcentaje, abono_cantidad_cuotas,
                               abono_monto_minimo, abono_lapso_minimo, abono_dias_vencimiento,
                               exonerar_intereses_mora, base_cobro_mora, diferir_intereses,
                               exonerar_intereses_diferidos, frecuencia_pago, tasa_valor, exonerar_intereses,
                               partida_id, numero_veces_mora, fecha_cambio_estatus, tasa_inicial,
                               tasa_vigente, dia_facturacion, estatus_desembolso, saldo_insoluto,
                               interes_vencido, dias_mora, monto_mora, causado_no_devengado,
                               interes_diferido_vencido, remanente_por_aplicar, cantidad_cuotas_vencidas,
                               monto_cuotas_vencidas, deuda, exigible, capital_vencido, fecha_revision_tasa,
                               porcentaje_riesgo_foncrei, porcentaje_riesgo_intermediario, porcentaje_tasa_foncrei,
                               porcentaje_tasa_intermediario, frecuencia_pago_intermediario, intermediado,
                               entidad_financiera_id, interes_desembolso_vencido, destinatario,
                               fecha_cobranza_intermediario, tasa_cero, monto_liquidado,
                               fecha_liquidacion, liberada, causa_liberacion, aumento_capital,
                               reestructurado, prestamo_origen_id, prestamo_destino_id, traslado_origen,
                               traslado_destino, tasa_forzada, tasa_forzada_fecha_vigencia,
                               tasa_forzada_monto, fecha_inicio, fecha_ultimo_cierre, migrado_d3,
                               codigo_d3, interes_diferido_por_vencer, capital_pago_parcial,
                               saldo_capital, meses_diferidos, senal_visita, numero_d3, porcentaje_riesgo_sudeban,
                               clasificacion_riesgo_sudeban, conversion_cuotas_mensuales_sudeban,
                               provision_individual_sudeban, porcentaje_riesgo_bandes, clasificacion_riesgo_bandes,
                               conversion_cuotas_mensuales_bandes, provision_individual_bandes,
                               fecha_base, ultimo_desembolso, codigo_contable, banco_origen,
                               tipo_cartera_id, abono_capital, dias_demorado, dias_vencido,
                               dias_vigente, cuotas_pagadas, cuotas_pendientes, cuotas_especiales_pagadas,
                               cuotas_especiales_vencidas, cuotas_especiales_pendientes, capital_pagado,
                               capital_por_pagar, intereses_pagados, mora_pagada, tipo_diferimiento,
                               porcentaje_diferimiento, consolidar_deuda)
          select
                               id, _mes_cierre as mes, _ano_cierre as ano, numero, producto_id,
                               monto_solicitado, monto_aprobado, fecha_aprobacion, formula_id,
                               tasa_fija, tasa_id, diferencial_tasa, tasa_referencia_inicial,
                               plazo, meses_fijos_sin_cambio_tasa, meses_gracia_si, meses_gracia,
                               meses_muertos_si, meses_muertos, cliente_id, tipo_credito_id,
                               oficina_id, solicitud_id, estatus, tasa_mora_id, forma_calculo_intereses,
                               base_calculo_intereses, permitir_abonos, abono_forma, abono_porcentaje,
                               abono_cantidad_cuotas, abono_monto_minimo, abono_lapso_minimo, abono_dias_vencimiento,
                               exonerar_intereses_mora, base_cobro_mora, diferir_intereses,
                               exonerar_intereses_diferidos, frecuencia_pago, tasa_valor, exonerar_intereses,
                               partida_id, numero_veces_mora, fecha_cambio_estatus, tasa_inicial,
                               tasa_vigente, dia_facturacion, estatus_desembolso, saldo_insoluto,
                               interes_vencido, dias_mora, monto_mora, causado_no_devengado,
                               interes_diferido_vencido, remanente_por_aplicar, cantidad_cuotas_vencidas,
                               monto_cuotas_vencidas, deuda, exigible, capital_vencido, fecha_revision_tasa,
                               porcentaje_riesgo_foncrei, porcentaje_riesgo_intermediario, porcentaje_tasa_foncrei,
                               porcentaje_tasa_intermediario, frecuencia_pago_intermediario,
                               intermediado, entidad_financiera_id, interes_desembolso_vencido,
                               destinatario, fecha_cobranza_intermediario, tasa_cero, monto_liquidado,
                               fecha_liquidacion, liberada, causa_liberacion, aumento_capital,
                               reestructurado, prestamo_origen_id, prestamo_destino_id, traslado_origen,
                               traslado_destino, tasa_forzada, tasa_forzada_fecha_vigencia,
                               tasa_forzada_monto, fecha_inicio, fecha_ultimo_cierre, migrado_d3,
                               codigo_d3, interes_diferido_por_vencer, capital_pago_parcial,
                               saldo_capital, meses_diferidos, senal_visita, numero_d3, porcentaje_riesgo_sudeban,
                               clasificacion_riesgo_sudeban, conversion_cuotas_mensuales_sudeban,
                               provision_individual_sudeban, porcentaje_riesgo_bandes, clasificacion_riesgo_bandes,
                               conversion_cuotas_mensuales_bandes, provision_individual_bandes,
                               fecha_base, ultimo_desembolso, codigo_contable, banco_origen,
                               tipo_cartera_id, abono_capital, dias_demorado, dias_vencido,
                               dias_vigente, cuotas_pagadas, cuotas_pendientes, cuotas_especiales_pagadas,
                               cuotas_especiales_vencidas, cuotas_especiales_pendientes, capital_pagado,
                               capital_por_pagar, intereses_pagados, mora_pagada, tipo_diferimiento,
                               porcentaje_diferimiento, consolidar_deuda
from
    prestamo;

    --raise notice 'se activa %', _ano_cierre;

    return true;

end;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION ejecutar_cierre_financiero() OWNER TO cartera;

