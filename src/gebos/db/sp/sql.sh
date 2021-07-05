
#cat ./ejecutar_cierre_financiero.sql
#cat ./ejecutar_cierre_financiero20101014.sql
#cat ./ejecutar_cierre_financiero20101129.sql

#sistema
cat sistema/tabla_transaccion_prestamo.sql
#cliente

#cat cliente/get_datos_cliente.sql
#cat cliente/get_datos_cliente20101014.sql
#cat cliente/get_datos_cliente20101021.sql
cat cliente/get_datos_cliente-20140411.sql

# general

 #cat general/agregar_dias.sql
 #cat general/agregar_meses.sql
 #cat general/calcular_dias_360.sql
# cat general/calcular_tasa_promedio.sql

#cat general/calcular_tasa_promedio20101011.sql
#cat general/last_day.sql
#cat general/get_tipo_pago.sql
#cat general/actualizar_estatus_solicitud.sql
#cat general/actualizar_estatus_tramite.sql
#cat general/actualizar_monto_insumos_bancos.sql

#contabilidad
#cat contabilidad/registro_contable.sql
#cat contabilidad/elimina_comprobante_contable.sql
#cat contabilidad/carga_reglas_contables.sql
#cat contabilidad/insert_regla_contable.sql
cat contabilidad/registro_contable_fondas.sql

# prestamos
# cat prestamos/actualizar_cuotas.sql
#cat prestamos/actualizar_cuotas20100918.sql
 cat prestamos/actualizar_deuda_exigible.sql
 cat prestamos/actualizacion_indicadores_cobranzas.sql
# cat prestamos/calcular_cuotas_vencidas.sql
#cat prestamos/calcular_interes_causado.sql
#cat prestamos/calcular_interes_vencido.sql
cat prestamos/calcular_interes_vencido20140408.sql
# cat prestamos/calcular_capital_vencido.sql
# cat prestamos/calcular_mora.sql
# cat prestamos/calcular_saldo_insoluto.sql
# cat prestamos/generar_plan_pago_evento.sql
# cat prestamos/generar_plan_pago.sql
# cat prestamos/ejecutar_pago.sql
# cat prestamos/calcular_prestamo_proyeccion.sql
# cat prestamos/calcular_prestamo.sql
# cat prestamos/ejecutar_abono_extraordinario.sql
# cat prestamos/calcular_cartera.sql
# cat prestamos/cancelar_prestamo.sql
cat prestamos/campos_tabla_prestamo.sql
# cat prestamos/reclasificar_cuota.sql
#cat prestamos/interes_devengado_fin_mes.sql
#cat prestamos/interes_devengado_fin_mes-20101203.sql
#cat prestamos/get_ultimo_desembolso.sql
cat prestamos/get_ultimo_desembolso-20140411.sql
#cat prestamos/get_fecha_cuota_impaga.sql
#cat prestamos/mask_indice_mora.sql
# cat prestamos/ejecutar_pago_general.sql
# cat prestamos/eventos_vencimiento_cuota.sql
# cat prestamos/actualizar_cuotas_intermediado.sql
# cat prestamos/actualizar_fecha_cobranza_intermediado.sql
# cat prestamos/actualizar_fecha_cambio_tasa.sql
# cat prestamos/generar_plan_pago_reestructuracion.sql
# cat prestamos/calcular_cartera_programa20100609.sql
# cat prestamos/calcular_cartera_programa20100714.sql
# cat prestamos/calcular_cartera_programa20100719.sql
# cat prestamos/calcular_cartera_programa20100918.sql
# cat prestamos/calcular_cartera_programa20101011.sql
# cat prestamos/ejecutar_cierre_batch20091006.sql
# cat prestamos/calcular_mora_mod20100607.sql
# cat prestamos/calcular_mora_mod20100911.sql
#cat prestamos/calcular_mora_mod20111227.sql
# cat prestamos/ajustar_intereses.sql
# cat prestamos/ajustar_intereses20101011.sql
# cat prestamos/calcular_interes_devengado.sql
# cat prestamos/calcular_interes_devengado20100802.sql
# cat prestamos/ajustarriesgoyprovision.sql
# cat prestamos/calcular_interes_gracia_devengado.sql
# cat prestamos/calcular_interes_gracia_desembolso.sql
# cat prestamos/leyenda_estatus.sql
# cat prestamos/leyenda_estatus20101013.sql
# cat prestamos/buscar_interes_causado.sql
# cat prestamos/get_fecha_aprobacion_credito.sql
# cat prestamos/calcula_cuenta_proyectado.sql
# cat prestamos/calcula_cuenta_proyectado20101016.sql
# cat prestamos/generaplanpagoinicial2010111.sql
# cat prestamos/resolver_estatus.sql
# cat prestamos/resolver_estatus_20100128.sql
# cat prestamos/generar_plan_pago_inicial20100113.sql
# cat prestamos/total_interes_gracia.sql
# cat prestamos/actualizartasavigente.sql
# cat prestamos/generar_plan_pago_20100115.sql
# cat prestamos/calcular_saldo_insoluto_dos.sql
# cat prestamos/calcular_prestamo2010-01-21.sql
#cat prestamos/calcular_prestamo_20100918.sql
# cat prestamos/calcular_saldo_insoluto_dos.sql
# cat prestamos/calcular_prestamo_20100125.sql
# cat prestamos/generar_plan_pago_20100126.sql
# cat prestamos/generar_plan_pago_inicial20100127.sql
# cat prestamos/generar_plan_pago_general20100127.sql
# cat prestamos/generar_plan_pago_inicial20100715.sql
# cat prestamos/generar_plan_pago_inicial20111108.sql
# cat prestamos/generar_plan_pago_inicial20111219.sql
#cat prestamos/actualizar_compromiso.sql
#cat prestamos/generar_plan_pago_inicial20120322.sql
# cat prestamos/generar_plan_pago_inicial20130319.sql
  cat prestamos/generar_plan_pago_inicial20140502.sql
# cat prestamos/generar_plan_pago_general20100715.sql
# cat prestamos/generar_plan_pago_general20101018.sql
# cat prestamos/generar_plan_pago_general20111110.sql
# cat prestamos/generar_plan_pago_general20111219.sql
# cat prestamos/generar_plan_pago_general20101003.sql
# cat prestamos/generar_plan_pago_general20130319.sql
  cat prestamos/generar_plan_pago_general20140403.sql
# cat prestamos/generar_plan_pago_evento20100208.sql
# cat prestamos/generar_plan_pago_evento20101018.sql
#cat prestamos/generar_plan_pago_evento20101018.sql
# cat prestamos/generar_plan_pago_evento20111222.sql
  cat prestamos/generar_plan_pago_insumos.sql
  cat prestamos/generar_plan_pago_insumos_pesca.sql
  cat prestamos/generar_factura_insumos.sql
# cat prestamos/fix_ultima_cuota.sql
# cat prestamos/ejecutar_pago_20100126.sql
# cat prestamos/ejecutar_pago_20100202.sql
# cat prestamos/ejecutar_pago_20100126_1era_llamada.sql
# cat prestamos/ejecutar_pago_201002.sql
# cat prestamos/ejecutar_pago_cobranzas_20130409.sql
  cat prestamos/ejecutar_pago_cobranzas_20140415.sql
# cat prestamos/resolver_estatus_20100128.sql
# cat prestamos/totalizador_pagos_estadistica.sql
# cat prestamos/totalizador_pagos_estadistica_estado_geografico.sql
  cat prestamos/totalizador_pagos_estadistica-20140401.sql
  cat prestamos/totalizador_pagos_estadistica_estado_geografico-20140401.sql
# cat prestamos/get_ventas_analista_cartera_20100204.sql
# cat prestamos/get_ventas_analista_cartera_consultoria_juridica_20100205.sql
# cat prestamos/get_tipo_cartera_20100202.sql
# cat prestamos/generar_plan_pago_20100125.sql
# cat prestamos/generar_plan_pago_20100124.sql
# cat prestamos/generarplanpagoinicial20080806.sql
# cat prestamos/generar_plan_pago_20100126_a.sql
# cat prestamos/generar_plan_pago_20100126_b.sql
# cat prestamos/ejecutar_pago_20100407.sql
# cat prestamos/ejecutar_pago_20100708.sq
# cat prestamos/ejecutar_pago_20100813.sql
# cat prestamos/ejecutar_pago_20101003.sql
# cat prestamos/ejecutar_pago_20111117.sql
# cat prestamos/ejecutar_pago_20111223.sql
# cat prestamos/ejecutar_pago_20111223-2.sql
# cat prestamos/ejecutar_pago_20111226.sql
# cat prestamos/ejecutar_pago_20120105.sql
# cat prestamos/ejecutar_pago_20120210.sql
#cat prestamos/ejecutar_pago_20130515.sql
#cat prestamos/ejecutar_pago_arrime.sql
# cat prestamos/actualizar_abono_capital.sql
#cat prestamos/actualizar_abono_capital_2012-05-07.sql
cat prestamos/actualizar_abono_capital_2014-04-09.sql
# cat prestamos/generar_factura.sql
# cat prestamos/generar_factura_20100813.sql
cat prestamos/generar_factura_20140418.sql
cat prestamos/ejecutar_cierre_financiero20140324.sql
cat prestamos/ejecutar_cierre_financiero_mes_ano_20140330.sql
# cat prestamos/calcular_cuotas_vencidas20100210.sql
# cat prestamos/calcular_cuotas_vencidas20100830.sql
# cat prestamos/calcular_cuotas_vencidas20100911.sql
# cat prestamos/calcular_cuotas_vencidas20101013.sql
# cat prestamos/calcular_cuotas_vencidas20101218.sql
#cat prestamos/ejecutar_pago_20130515.sql
# cat prestamos/generar_plan_pago_migracion-2012-04-17.sql
# cat prestamos/generar_plan_pago_maquinaria.sql
  #cat prestamos/ejecutar_cierre_batch-2012-04-21.sql
#  cat prestamos/ejecutar_cierre_batch-2012-04-23.sql
#  cat ejecutar_cierre_shell-2012-04-21.sql
  #cat prestamos/calcular_cartera_prestamo-2012-04-20.sql
  #cat prestamos/calcular_cartera_prestamo-2012-04-23.sql
cat prestamos/calcular_cartera_prestamo-2012-05-08.sql
# cat prestamos/calcular_montos_recuperados.sql
# cat prestamos/cancelar_prestamo.sql
# cat prestamos/cancelar_prestamo_20100720.sql
# cat prestamos/cancelar_prestamo_20100723.sql
# cat prestamos/cancelar_prestamo_20100730.sql
# cat prestamos/cancelar_prestamo_20100820.sql
# cat prestamos/cancelar_prestamo_20101016.sql
# cat prestamos/ejecutar_pago_cancelacion.sql
# cat prestamos/ejecutar_pago_cancelacion_20100813.sql
# cat prestamos/ejecutar_cierre_batch20091006.sql
# cat prestamos/calcular_mora_mod20091006.sql
  cat prestamos/calcular_mora_mod20130403.sql
# cat prestamos/calcular_interes_gracia_desembolso.sql
# cat prestamos/actualizarpagosparciales.sql
  cat prestamos/actualizacion_plan_inversion_costo_fijo.sql
  cat prestamos/actualizacion_plan_inversion_costo_variable.sql
  cat prestamos/apertura_comite.sql
  cat prestamos/aprobacion_comite_estadal.sql
  cat prestamos/aprobacion_comite_nacional.sql
  cat prestamos/calcular_cuotas_vencidas20130516.sql
  cat prestamos/generar_compromiso.sql
# sistema
# cat sistema/campos_tabla.sql
# cat sistema/tabla_transaccion.sql
# cat sistema/preparar_tablas.sql
# cat sistema/iniciar_transaccion.sql
# cat sistema/log_transaccion.sql
# cat sistema/reversar_transaccion.sql
# cat sistema/reversar_transaccion-20100808.sql

# cat sistema/chkpass.sql

