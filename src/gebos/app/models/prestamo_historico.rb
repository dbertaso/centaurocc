# encoding: utf-8

#
# autor: Diego Bertaso
# clase: PrestamoHistorico
# descripción: Migración a Rails 3
#


class PrestamoHistorico < ActiveRecord::Base

  self.table_name = 'prestamo_historico'

  attr_accessible :id,
                  :numero,
                  :monto_solicitado,
                  :monto_aprobado,
                  :fecha_aprobacion,
                  :formula_id,
                  :tasa_fija,
                  :tasa_id,
                  :diferencial_tasa,
                  :tasa_referencia_inicial,
                  :plazo,
                  :meses_fijos_sin_cambio_tasa,
                  :meses_gracia_si,
                  :meses_gracia,
                  :meses_muertos_si,
                  :meses_muertos,
                  :cliente_id,
                  :tipo_credito_id,
                  :oficina_id,
                  :solicitud_id,
                  :estatus,
                  :tasa_mora_id,
                  :forma_calculo_intereses,
                  :base_calculo_intereses,
                  :permitir_abonos,
                  :abono_forma,
                  :abono_porcentaje,
                  :abono_cantidad_cuotas,
                  :abono_monto_minimo,
                  :abono_lapso_minimo,
                  :abono_dias_vencimiento,
                  :exonerar_intereses_mora,
                  :base_cobro_mora,
                  :diferir_intereses,
                  :exonerar_intereses_diferidos,
                  :frecuencia_pago,
                  :tasa_valor,
                  :exonerar_intereses,
                  :numero_veces_mora,
                  :fecha_cambio_estatus,
                  :tasa_inicial,
                  :tasa_vigente,
                  :dia_facturacion,
                  :estatus_desembolso,
                  :saldo_insoluto,
                  :interes_vencido,
                  :dias_mora,
                  :monto_mora,
                  :causado_no_devengado,
                  :interes_diferido_vencido,
                  :remanente_por_aplicar,
                  :cantidad_cuotas_vencidas,
                  :monto_cuotas_vencidas,
                  :deuda,
                  :exigible,
                  :capital_vencido,
                  :fecha_revision_tasa,
                  :porcentaje_riesgo_foncrei,
                  :porcentaje_riesgo_intermediario,
                  :porcentaje_tasa_foncrei,
                  :porcentaje_tasa_intermediario,
                  :frecuencia_pago_intermediario,
                  :intermediado,
                  :entidad_financiera_id,
                  :interes_desembolso_vencido,
                  :destinatario,
                  :fecha_cobranza_intermediario,
                  :tasa_cero,
                  :monto_liquidado,
                  :fecha_liquidacion,
                  :liberada,
                  :causa_liberacion,
                  :aumento_capital,
                  :reestructurado,
                  :prestamo_origen_id,
                  :prestamo_destino_id,
                  :traslado_origen,
                  :traslado_destino,
                  :tasa_forzada,
                  :tasa_forzada_fecha_vigencia,
                  :tasa_forzada_monto,
                  :fecha_inicio,
                  :fecha_ultimo_cierre,
                  :migrado_d3,
                  :codigo_d3,
                  :interes_diferido_por_vencer,
                  :capital_pago_parcial,
                  :saldo_capital,
                  :meses_diferidos,
                  :senal_visita,
                  :numero_d3,
                  :porcentaje_riesgo_sudeban,
                  :clasificacion_riesgo_sudeban,
                  :conversion_cuotas_mensuales_sudeban,
                  :provision_individual_sudeban,
                  :porcentaje_riesgo_bandes,
                  :clasificacion_riesgo_bandes,
                  :conversion_cuotas_mensuales_bandes,
                  :provision_individual_bandes,
                  :fecha_base,
                  :ultimo_desembolso,
                  :codigo_contable,
                  :banco_origen,
                  :tipo_cartera_id,
                  :abono_capital,
                  :dias_demorado,
                  :dias_vencido,
                  :dias_vigente,
                  :cuotas_pagadas,
                  :cuotas_pendientes,
                  :cuotas_especiales_pagadas,
                  :cuotas_especiales_vencidas,
                  :cuotas_especiales_pendientes,
                  :capital_pagado,
                  :capital_por_pagar,
                  :intereses_pagados,
                  :mora_pagada,
                  :tipo_diferimiento,
                  :porcentaje_diferimiento,
                  :consolidar_deuda,
                  :pago_mora_migracion,
                  :cuotas_pagadas_migracion,
                  :monto_banco,
                  :monto_insumos,
                  :fecha_vencimiento,
                  :monto_cuota,
                  :monto_cuota_gracia,
                  :rubro_id,
                  :producto_id,
                  :monto_sras_primer_ano,
                  :monto_sras_anos_subsiguientes,
                  :monto_sras_total,
                  :monto_facturado,
                  :monto_despachado,
                  :fecha_instruccion_pago,
                  :instruccion_pago,
                  :monto_inventario,
                  :monto_liquidado_insumos,
                  :sub_rubro_id,
                  :actividad_id,
                  :monto_gasto_total,
                  :moneda_id,
                  :cantidad_veces_mora,
                  :cantidad_veces_vigente,
                  :cantidad_dias_mora_acumulados,
                  :cantidad_compromisos_incumplidos,
                  :empresa_cobranza_id,
                  :tasa_conversion,
                  :fecha_tasa_conversion,
                  :valor_moneda_nacional,
                  :porcentaje_veces_mora,
                  :porcentaje_dias_mora,
                  :indice_morosidad,
                  :porcentaje_recuperacion_real_capital,
                  :porcentaje_recuperacion_esperada_capital,
                  :capital_cuotas_fecha,
                  :desviacion_recuperacion_capital,
                  :dias_atraso_promedio,
                  :porcentaje_recuperacion_real_intereses,
                  :total_interes,
                  :porcentaje_recuperacion_esperado_intereses,
                  :interes_cuota_fecha,
                  :desviacion_recuperacion_intereses,
                  :porcentaje_pagos_incumplidos,
                  :analista_cobranzas_id,
                  :ano,
                  :mes


end


# == Schema Information
#
# Table name: prestamo_historico
#
#  id                                         :integer         not null, primary key
#  numero                                     :integer(8)
#  monto_solicitado                           :decimal(16, 2)
#  monto_aprobado                             :decimal(16, 2)
#  fecha_aprobacion                           :date
#  formula_id                                 :integer
#  tasa_fija                                  :boolean
#  tasa_id                                    :integer
#  diferencial_tasa                           :float
#  tasa_referencia_inicial                    :float
#  plazo                                      :integer(2)
#  meses_fijos_sin_cambio_tasa                :integer(2)
#  meses_gracia_si                            :boolean
#  meses_gracia                               :integer(2)
#  meses_muertos_si                           :boolean
#  meses_muertos                              :integer(2)
#  cliente_id                                 :integer
#  tipo_credito_id                            :integer
#  oficina_id                                 :integer
#  solicitud_id                               :integer
#  estatus                                    :string(1)
#  tasa_mora_id                               :integer
#  forma_calculo_intereses                    :string(1)
#  base_calculo_intereses                     :integer
#  permitir_abonos                            :boolean
#  abono_forma                                :string(1)
#  abono_porcentaje                           :float
#  abono_cantidad_cuotas                      :integer(2)
#  abono_monto_minimo                         :float
#  abono_lapso_minimo                         :integer(2)
#  abono_dias_vencimiento                     :float
#  exonerar_intereses_mora                    :boolean
#  base_cobro_mora                            :string(1)
#  diferir_intereses                          :boolean
#  exonerar_intereses_diferidos               :boolean
#  frecuencia_pago                            :integer(2)
#  tasa_valor                                 :float
#  exonerar_intereses                         :boolean
#  numero_veces_mora                          :integer(2)
#  fecha_cambio_estatus                       :date
#  tasa_inicial                               :float
#  tasa_vigente                               :float
#  dia_facturacion                            :integer(2)
#  estatus_desembolso                         :string(1)
#  saldo_insoluto                             :decimal(16, 2)
#  interes_vencido                            :decimal(16, 2)
#  dias_mora                                  :integer(2)
#  monto_mora                                 :decimal(16, 2)
#  causado_no_devengado                       :decimal(16, 2)
#  interes_diferido_vencido                   :decimal(16, 2)
#  remanente_por_aplicar                      :decimal(16, 2)
#  cantidad_cuotas_vencidas                   :integer(2)
#  monto_cuotas_vencidas                      :decimal(16, 2)
#  deuda                                      :decimal(16, 2)
#  exigible                                   :decimal(16, 2)
#  capital_vencido                            :decimal(16, 2)
#  fecha_revision_tasa                        :date
#  porcentaje_riesgo_foncrei                  :float
#  porcentaje_riesgo_intermediario            :float
#  porcentaje_tasa_foncrei                    :float
#  porcentaje_tasa_intermediario              :float
#  frecuencia_pago_intermediario              :integer(2)
#  intermediado                               :boolean
#  entidad_financiera_id                      :integer
#  interes_desembolso_vencido                 :decimal(16, 2)
#  destinatario                               :string(1)
#  fecha_cobranza_intermediario               :date
#  tasa_cero                                  :boolean
#  monto_liquidado                            :decimal(16, 2)
#  fecha_liquidacion                          :date
#  liberada                                   :boolean
#  causa_liberacion                           :string(1)
#  aumento_capital                            :decimal(16, 2)
#  reestructurado                             :string(1)
#  prestamo_origen_id                         :integer
#  prestamo_destino_id                        :integer
#  traslado_origen                            :float
#  traslado_destino                           :float
#  tasa_forzada                               :boolean
#  tasa_forzada_fecha_vigencia                :date
#  tasa_forzada_monto                         :float
#  fecha_inicio                               :date
#  fecha_ultimo_cierre                        :date
#  migrado_d3                                 :boolean
#  codigo_d3                                  :string(20)
#  interes_diferido_por_vencer                :decimal(16, 2)
#  capital_pago_parcial                       :decimal(16, 2)
#  saldo_capital                              :float
#  meses_diferidos                            :integer
#  senal_visita                               :boolean
#  numero_d3                                  :integer(8)
#  porcentaje_riesgo_sudeban                  :decimal(16, 6)
#  clasificacion_riesgo_sudeban               :string(4)
#  conversion_cuotas_mensuales_sudeban        :decimal(16, 2)
#  provision_individual_sudeban               :decimal(16, 2)
#  porcentaje_riesgo_bandes                   :decimal(16, 6)
#  clasificacion_riesgo_bandes                :string(4)
#  conversion_cuotas_mensuales_bandes         :decimal(16, 2)
#  provision_individual_bandes                :decimal(16, 2)
#  fecha_base                                 :date
#  ultimo_desembolso                          :integer
#  codigo_contable                            :string(6)
#  banco_origen                               :string(25)
#  tipo_cartera_id                            :integer
#  abono_capital                              :decimal(16, 2)
#  dias_demorado                              :integer
#  dias_vencido                               :integer
#  dias_vigente                               :integer
#  cuotas_pagadas                             :integer
#  cuotas_pendientes                          :integer
#  cuotas_especiales_pagadas                  :integer
#  cuotas_especiales_vencidas                 :integer
#  cuotas_especiales_pendientes               :integer
#  capital_pagado                             :decimal(14, 2)
#  capital_por_pagar                          :decimal(14, 2)
#  intereses_pagados                          :decimal(16, 2)
#  mora_pagada                                :decimal(16, 2)
#  tipo_diferimiento                          :boolean
#  porcentaje_diferimiento                    :decimal(5, 2)
#  consolidar_deuda                           :boolean
#  pago_mora_migracion                        :decimal(16, 2)
#  cuotas_pagadas_migracion                   :integer
#  monto_banco                                :decimal(16, 2)
#  monto_insumos                              :decimal(16, 2)
#  fecha_vencimiento                          :date
#  monto_cuota                                :decimal(16, 2)
#  monto_cuota_gracia                         :decimal(16, 2)
#  rubro_id                                   :integer
#  producto_id                                :integer
#  monto_sras_primer_ano                      :decimal(16, 2)
#  monto_sras_anos_subsiguientes              :decimal(16, 2)
#  monto_sras_total                           :decimal(16, 2)
#  monto_facturado                            :decimal(16, 2)
#  monto_despachado                           :decimal(16, 2)
#  fecha_instruccion_pago                     :date
#  instruccion_pago                           :boolean
#  monto_inventario                           :decimal(16, 2)
#  monto_liquidado_insumos                    :decimal(16, 2)
#  sub_rubro_id                               :integer
#  actividad_id                               :integer
#  monto_gasto_total                          :decimal(16, 2)
#  moneda_id                                  :integer
#  cantidad_veces_mora                        :integer
#  cantidad_veces_vigente                     :integer
#  cantidad_dias_mora_acumulados              :integer
#  cantidad_compromisos_incumplidos           :integer
#  empresa_cobranza_id                        :integer
#  tasa_conversion                            :decimal(16, 2)
#  fecha_tasa_conversion                      :date
#  valor_moneda_nacional                      :decimal(16, 2)
#  porcentaje_veces_mora                      :decimal(5, 2)
#  porcentaje_dias_mora                       :decimal(5, 2)
#  indice_morosidad                           :decimal(5, 2)
#  porcentaje_recuperacion_real_capital       :decimal(5, 2)
#  porcentaje_recuperacion_esperada_capital   :decimal(5, 2)
#  capital_cuotas_fecha                       :decimal(16, 2)
#  desviacion_recuperacion_capital            :decimal(5, 2)
#  dias_atraso_promedio                       :integer
#  porcentaje_recuperacion_real_intereses     :decimal(5, 2)
#  total_interes                              :decimal(16, 2)
#  porcentaje_recuperacion_esperado_intereses :decimal(5, 2)
#  interes_cuota_fecha                        :decimal(16, 2)
#  desviacion_recuperacion_intereses          :decimal(5, 2)
#  porcentaje_pagos_incumplidos               :decimal(5, 2)
#  analista_cobranzas_id                      :integer
#  ano                                        :integer         not null
#  mes                                        :integer         not null
#

