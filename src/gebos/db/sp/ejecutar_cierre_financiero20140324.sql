CREATE OR REPLACE FUNCTION ejecutar_cierre_financiero()
  RETURNS boolean AS
$BODY$
declare  
--  _programa programa%rowtype;
  _control_cierre control_cierre%rowtype;
  _mes_cierre int;
  _ano_cierre int;
  _sql_execute varchar;
  _sql_fields varchar;

--  _fecha_proceso_next date;

--   Cursor para recorrer los programas sociales y efectuar el cierre diario de cartera
--  _cur_programa refcursor;
  
  
begin


	select into 
      _control_cierre * 
	from 
      control_cierre 
    where 
      fecha_ejecucion <> '1900-01-01'
	
	order by	
			fecha_proceso desc
       
	limit 1;


	 raise notice '%', last_day(_control_cierre.fecha_proceso);      

	 if (_control_cierre.fecha_proceso::date = last_day(_control_cierre.fecha_proceso)::date and _control_cierre.senal_cerrado and _control_cierre.fecha_ejecucion <> '1900-01-01') then

    perform tabla_transaccion_prestamo('prestamo');
    
    _sql_fields = campos_tabla_prestamo('prestamo',false,false);

    _mes_cierre =  EXTRACT(MONTH FROM _control_cierre.fecha_proceso::date);
    _ano_cierre =  EXTRACT(YEAR FROM _control_cierre.fecha_proceso::date);

    _sql_execute = 'insert into prestamo_historico ' || ' (mes, ano, ' || _sql_fields
     || ') select ' || _mes_cierre || ', ' || _ano_cierre || ', ' || _sql_fields || ' from ' || 'prestamo'

    delete from prestamo_historico where mes = _mes_cierre and ano = _ano_cierre;

    execute _sql_execute;
    
-- 		insert into prestamo_historico(id, mes, ano, numero, producto_id, monto_solicitado, monto_aprobado, 
--             fecha_aprobacion, formula_id, tasa_fija, tasa_id, diferencial_tasa, 
--             tasa_referencia_inicial, plazo, meses_fijos_sin_cambio_tasa, 
--             meses_gracia_si, meses_gracia, meses_muertos_si, meses_muertos, 
--             cliente_id, tipo_credito_id, oficina_id, solicitud_id, estatus, 
--             tasa_mora_id, forma_calculo_intereses, base_calculo_intereses, 
--             permitir_abonos, abono_forma, abono_porcentaje, abono_cantidad_cuotas, 
--             abono_monto_minimo, abono_lapso_minimo, abono_dias_vencimiento, 
--             exonerar_intereses_mora, base_cobro_mora, diferir_intereses, 
--             exonerar_intereses_diferidos, frecuencia_pago, tasa_valor, exonerar_intereses, 
--             partida_id, numero_veces_mora, fecha_cambio_estatus, tasa_inicial, 
--             tasa_vigente, dia_facturacion, estatus_desembolso, saldo_insoluto, 
--             interes_vencido, dias_mora, monto_mora, causado_no_devengado, 
--             interes_diferido_vencido, remanente_por_aplicar, cantidad_cuotas_vencidas, 
--             monto_cuotas_vencidas, deuda, exigible, capital_vencido, fecha_revision_tasa, 
--             porcentaje_riesgo_foncrei, porcentaje_riesgo_intermediario, porcentaje_tasa_foncrei, 
--             porcentaje_tasa_intermediario, frecuencia_pago_intermediario, 
--             intermediado, entidad_financiera_id, interes_desembolso_vencido, 
--             destinatario, fecha_cobranza_intermediario, tasa_cero, monto_liquidado, 
--             fecha_liquidacion, liberada, causa_liberacion, aumento_capital, 
--             reestructurado, prestamo_origen_id, prestamo_destino_id, traslado_origen, 
--             traslado_destino, tasa_forzada, tasa_forzada_fecha_vigencia, 
--             tasa_forzada_monto, fecha_inicio, fecha_ultimo_cierre, migrado_d3, 
--             codigo_d3, interes_diferido_por_vencer, capital_pago_parcial, 
--             saldo_capital, meses_diferidos, senal_visita, numero_d3, porcentaje_riesgo_sudeban, 
--             clasificacion_riesgo_sudeban, conversion_cuotas_mensuales_sudeban, 
--             provision_individual_sudeban, porcentaje_riesgo_bandes, clasificacion_riesgo_bandes, 
--             conversion_cuotas_mensuales_bandes, provision_individual_bandes, 
--             fecha_base, ultimo_desembolso, codigo_contable, banco_origen, 
--             tipo_cartera_id, abono_capital, dias_demorado, dias_vencido, 
--             dias_vigente, cuotas_pagadas, cuotas_pendientes, cuotas_especiales_pagadas, 
--             cuotas_especiales_vencidas, cuotas_especiales_pendientes, capital_pagado, 
--             capital_por_pagar, intereses_pagados, mora_pagada, tipo_diferimiento, 
--             porcentaje_diferimiento, consolidar_deuda) 
--     select  
--             id, _mes_cierre as mes,  _ano_cierre as ano, numero, producto_id, monto_solicitado, monto_aprobado, 
--             fecha_aprobacion, formula_id, tasa_fija, tasa_id, diferencial_tasa, 
--             tasa_referencia_inicial, plazo, meses_fijos_sin_cambio_tasa, 
--             meses_gracia_si, meses_gracia, meses_muertos_si, meses_muertos, 
--             cliente_id, tipo_credito_id, oficina_id, solicitud_id, estatus, 
--             tasa_mora_id, forma_calculo_intereses, base_calculo_intereses, 
--             permitir_abonos, abono_forma, abono_porcentaje, abono_cantidad_cuotas, 
--             abono_monto_minimo, abono_lapso_minimo, abono_dias_vencimiento, 
--             exonerar_intereses_mora, base_cobro_mora, diferir_intereses, 
--             exonerar_intereses_diferidos, frecuencia_pago, tasa_valor, exonerar_intereses, 
--             partida_id, numero_veces_mora, fecha_cambio_estatus, tasa_inicial, 
--             tasa_vigente, dia_facturacion, estatus_desembolso, saldo_insoluto, 
--             interes_vencido, dias_mora, monto_mora, causado_no_devengado, 
--             interes_diferido_vencido, remanente_por_aplicar, cantidad_cuotas_vencidas, 
--             monto_cuotas_vencidas, deuda, exigible, capital_vencido, fecha_revision_tasa, 
--             porcentaje_riesgo_foncrei, porcentaje_riesgo_intermediario, porcentaje_tasa_foncrei, 
--             porcentaje_tasa_intermediario, frecuencia_pago_intermediario, 
--             intermediado, entidad_financiera_id, interes_desembolso_vencido, 
--             destinatario, fecha_cobranza_intermediario, tasa_cero, monto_liquidado, 
--             fecha_liquidacion, liberada, causa_liberacion, aumento_capital, 
--             reestructurado, prestamo_origen_id, prestamo_destino_id, traslado_origen, 
--             traslado_destino, tasa_forzada, tasa_forzada_fecha_vigencia, 
--             tasa_forzada_monto, fecha_inicio, fecha_ultimo_cierre, migrado_d3, 
--             codigo_d3, interes_diferido_por_vencer, capital_pago_parcial, 
--             saldo_capital, meses_diferidos, senal_visita, numero_d3, porcentaje_riesgo_sudeban, 
--             clasificacion_riesgo_sudeban, conversion_cuotas_mensuales_sudeban, 
--             provision_individual_sudeban, porcentaje_riesgo_bandes, clasificacion_riesgo_bandes, 
--             conversion_cuotas_mensuales_bandes, provision_individual_bandes, 
--             fecha_base, ultimo_desembolso, codigo_contable, banco_origen, 
--             tipo_cartera_id, abono_capital, dias_demorado, dias_vencido, 
--             dias_vigente, cuotas_pagadas, cuotas_pendientes, cuotas_especiales_pagadas, 
--             cuotas_especiales_vencidas, cuotas_especiales_pendientes, capital_pagado, 
--             capital_por_pagar, intereses_pagados, mora_pagada, tipo_diferimiento, 
--             porcentaje_diferimiento, consolidar_deuda
-- from prestamo;





		
		
		raise notice 'se activa %', _ano_cierre;

	else
		raise notice 'no se activa';
	end if;
	

  return true;
 
end;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION ejecutar_cierre_financiero() OWNER TO cartera;


