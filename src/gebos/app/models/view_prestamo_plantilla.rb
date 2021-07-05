# encoding: utf-8

#
# 
# clase: ViewPrestamoPlantilla
# descripción: Migración a Rails 3
#

class ViewPrestamoPlantilla < ActiveRecord::Base

  self.table_name = 'view_prestamo_plantilla'
  
  attr_accessible   :numero_prestamo,:monto_solicitado,:monto_solicitado_letras,:monto_aprobado,:monto_aprobado_letras,:fecha_aprobacion,:tasa_fija,:diferencial_tasa,:diferencial_tasa_letras,:tasa_referencia_inicial,:tasa_referencia_inicial_letras,:plazo,:plazo_letras,:cuotas,:cuotas_letras,:meses_fijos_sin_cambio_tasa,:meses_fijos_sin_cambio_tasa_letras,:meses_gracia,:meses_gracia_letras,:meses_muertos,:meses_muertos_letras,:frecuencia_pago,:frecuencia_pago2,:tasa_valor,:tasa_valor_letras,:tasa_inicial,:tasa_inicial_letras,:tasa_vigente,:tasa_vigente_letras,:tasa_mora,:tasa_mora_letras,:saldo_insoluto,:saldo_insoluto_letras,:monto_liquidado,:monto_liquidado_letras,:fecha_liquidacion,:saldo_capital,:saldo_capital_letras,:meses_diferidos,:meses_diferidos_letras,:dia_facturacion,:plan_inversion,:plan_inversion_pesca,:solicitud_id

end

# == Schema Information
#
# Table name: view_prestamo_plantilla
#
#  numero_prestamo                    :integer(8)
#  monto_solicitado                   :text
#  monto_solicitado_letras            :decimal(16, 2)
#  monto_aprobado                     :text
#  monto_aprobado_letras              :decimal(16, 2)
#  fecha_aprobacion                   :text
#  tasa_fija                          :boolean
#  diferencial_tasa                   :text
#  diferencial_tasa_letras            :float
#  tasa_referencia_inicial            :text
#  tasa_referencia_inicial_letras     :float
#  plazo                              :text
#  plazo_letras                       :integer(2)
#  cuotas                             :text
#  cuotas_letras                      :integer
#  meses_fijos_sin_cambio_tasa        :text
#  meses_fijos_sin_cambio_tasa_letras :integer(2)
#  meses_gracia                       :text
#  meses_gracia_letras                :integer(2)
#  meses_muertos                      :text
#  meses_muertos_letras               :integer(2)
#  frecuencia_pago                    :text
#  frecuencia_pago2                   :text
#  tasa_valor                         :text
#  tasa_valor_letras                  :float
#  tasa_inicial                       :text
#  tasa_inicial_letras                :float
#  tasa_vigente                       :text
#  tasa_vigente_letras                :float
#  tasa_mora                          :text
#  tasa_mora_letras                   :float
#  saldo_insoluto                     :text
#  saldo_insoluto_letras              :decimal(16, 2)
#  monto_liquidado                    :text
#  monto_liquidado_letras             :decimal(16, 2)
#  fecha_liquidacion                  :text
#  saldo_capital                      :text
#  saldo_capital_letras               :float
#  meses_diferidos                    :text
#  meses_diferidos_letras             :integer
#  dia_facturacion                    :integer(2)
#  plan_inversion                     :
#  plan_inversion_pesca               :
#  solicitud_id                       :integer
#

