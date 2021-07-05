
# encoding: utf-8

#
# autor: Diego Bertaso
# clase: ViewMegaSabana
# descripción: Migración a Rails 3
#

class ViewMegaSabana < ActiveRecord::Base

  self.table_name = 'view_mega_sabana'

  attr_accessible :tipo_organizacion,
                  :nombre_organizacion,
                  :rif,
                  :beneficiario_nombre,
                  :cedula,
                  :capital_suscrito,
                  :sector_economico,
                  :estado,
                  :municipio,
                  :parroquia,
                  :localidad,
                  :avenida,
                  :edificio_casa,
                  :telefonos,
                  :banco_recaudador,
                  :numero_cuenta,
                  :tamano,
                  :monto_credito,
                  :monto_liquidado,
                  :fecha_liquidacion,
                  :mes,
                  :ano,
                  :alias,
                  :solicitud_cai,
                  :propuesta,
                  :tamano_organizacion,
                  :fecha_vencimiento,
                  :observaciones,
                  :intereses_mora,
                  :total_recuperado_intereses_ordinarios,
                  :total_intereses_mora_pagados,
                  :saldo_capital,
                  :fecha_ultimo_vencimiento_no_pagado,
                  :prestamo_interes_diferido_vencido,
                  :prestamo_interes_diferido_por_vencer,
                  :prestamo_interes_mora,
                  :modalidad_pago,
                  :plazo,
                  :periodo_gracia,
                  :periodo_diferimiento_intereses,
                  :tasa,
                  :codigo_contable,
                  :provision_contrato_bandes,
                  :conversion_cuotas_mensuales_sudeban,
                  :clasificacion_riesgo_sudeban,
                  :porcentaje_individual_provision_sudeban,
                  :conversion_cuotas_mensuales_bandes,
                  :clasificacion_riesgo_bandes,
                  :intereses_ordinarios_vencidos,
                  :prestamo_cuotas_pagadas,
                  :cuotas_diferidas_capital,
                  :cuotas_vencidas,
                  :interes_mora,
                  :monto_recuperado,
                  :capital_vencido,
                  :prestamo_capital_por_pagar,
                  :banco_origen,
                  :porcentaje_individual_provision_bandes,
                  :prestamo_dias_vigente,
                  :prestamo_dias_demorado,
                  :prestamo_banco_origen,
                  :dias_vencido,
                  :prestamo_cuotas_pendientes,
                  :prestamo_capital_vencido,
                  :prestamo_saldo_insoluto,
                  :prestamo_exigible,
                  :prestamo_deuda,
                  :prestamo_tabla,
                  :indice_mora,
                  :get_fecha_cuota_impaga,
                  :get_ultimo_desembolso,
                  :estatus,
                  :total_recuperado_capital,
                  :monto_aprobado,
                  :objeto_proyecto,
                  :fecha_aprobacion,
                  :solicitud_van,
                  :solicitud_tir,
                  :solicitud_origen_fondo,
                  :solicitud_modalidad_financiam6iento,
                  :actividad_economica_unidad_negocio,
                  :fecha_ultima_cuota,
                  :pago_interes_corriente,
                  :pago_interes_mora,
                  :solicitud_region,
                  :solicitud_estado,
                  :solicitud_programa,
                  :solicitud_municipio,
                  :solicitud_ciudad,
                  :solicitud_parroquia

end


# == Schema Information
#
# Table name: view_mega_sabana
#
#  tipo_organizacion                       :string
#  nombre_organizacion                     :string
#  rif                                     :string
#  beneficiario_nombre                     :string
#  cedula                                  :string
#  capital_suscrito                        :string
#  sector_economico                        :string
#  estado                                  :string
#  municipio                               :string
#  parroquia                               :string
#  localidad                               :string
#  avenida                                 :string
#  edificio_casa                           :string
#  telefonos                               :string
#  banco_recaudador                        :string
#  numero_cuenta                           :string
#  tamano                                  :string
#  monto_credito                           :decimal(16, 2)
#  monto_liquidado                         :decimal(16, 2)
#  fecha_liquidacion                       :date
#  mes                                     :integer
#  ano                                     :integer
#  alias                                   :string(255)
#  solicitud_cai                           :
#  propuesta                               :string(100)
#  tamano_organizacion                     :
#  fecha_vencimiento                       :date
#  observaciones                           :
#  intereses_mora                          :
#  total_recuperado_intereses_ordinarios   :decimal(16, 2)
#  total_intereses_mora_pagados            :decimal(16, 2)
#  saldo_capital                           :decimal(16, 2)
#  fecha_ultimo_vencimiento_no_pagado      :
#  prestamo_interes_diferido_vencido       :decimal(16, 2)
#  prestamo_interes_diferido_por_vencer    :decimal(16, 2)
#  prestamo_interes_mora                   :decimal(16, 2)
#  modalidad_pago                          :text
#  plazo                                   :integer(2)
#  periodo_gracia                          :integer
#  periodo_diferimiento_intereses          :integer
#  tasa                                    :float
#  codigo_contable                         :string(6)
#  provision_contrato_bandes               :decimal(16, 2)
#  conversion_cuotas_mensuales_sudeban     :decimal(16, 2)
#  clasificacion_riesgo_sudeban            :string(4)
#  porcentaje_individual_provision_sudeban :decimal(16, 6)
#  conversion_cuotas_mensuales_bandes      :decimal(16, 2)
#  clasificacion_riesgo_bandes             :string(4)
#  intereses_ordinarios_vencidos           :decimal(16, 2)
#  prestamo_cuotas_pagadas                 :integer
#  cuotas_diferidas_capital                :integer
#  cuotas_vencidas                         :integer(2)
#  interes_mora                            :decimal(16, 2)
#  monto_recuperado                        :decimal(, )
#  capital_vencido                         :decimal(16, 2)
#  prestamo_capital_por_pagar              :decimal(14, 2)
#  banco_origen                            :string(25)
#  porcentaje_individual_provision_bandes  :decimal(16, 6)
#  prestamo_dias_vigente                   :integer
#  prestamo_dias_demorado                  :integer
#  prestamo_banco_origen                   :string(25)
#  dias_vencido                            :integer
#  prestamo_cuotas_pendientes              :integer
#  prestamo_capital_vencido                :decimal(16, 2)
#  prestamo_saldo_insoluto                 :decimal(16, 2)
#  prestamo_exigible                       :decimal(16, 2)
#  prestamo_deuda                          :decimal(16, 2)
#  prestamo_tabla                          :text
#  indice_mora                             :string
#  get_fecha_cuota_impaga                  :string
#  get_ultimo_desembolso                   :string
#  estatus                                 :string
#  total_recuperado_capital                :decimal(14, 2)
#  monto_aprobado                          :float
#  objeto_proyecto                         :string(400)
#  fecha_aprobacion                        :date
#  solicitud_van                           :decimal(16, 2)
#  solicitud_tir                           :decimal(16, 2)
#  solicitud_origen_fondo                  :string(40)
#  solicitud_modalidad_financiamiento      :string(40)
#  actividad_economica_unidad_negocio      :string(500)
#  fecha_ultima_cuota                      :date
#  pago_interes_corriente                  :decimal(, )
#  pago_interes_mora                       :decimal(, )
#  solicitud_region                        :string(40)
#  solicitud_estado                        :string(40)
#  solicitud_programa                      :string(255)
#  solicitud_municipio                     :string(40)
#  solicitud_ciudad                        :string(40)
#  solicitud_parroquia                     :string(40)
#

