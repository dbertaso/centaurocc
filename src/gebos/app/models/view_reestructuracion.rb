# encoding: utf-8

#
# 
# clase: ViewReestructuracion
# descripción: Migración a Rails 3
#

class ViewReestructuracion < ActiveRecord::Base

  self.table_name = 'view_reestructuracion'
  
  attr_accessible :monto_abono,:monto_abono_letras,:referencia_abono,:banco_abono,:fecha_abono,:numero_cuenta,:interes_diferido,:interes_diferido_letras,:interes_moratorio,:interes_moratorio_letras,:interes_ordinarios,:interes_ordinarios_letras,:interes_causado_no_devengado,:interes_causado_no_devengado_letras,:porcentaje_arrime,:porcentaje_arrime_letras,:monto_reestructurado,:monto_reestructurado_letras,:frecuencia,:cuotas,:saldo_insoluto_reestructuracion,:saldo_insoluto_reestructuracion_letras,:solicitud_id
 
end



# == Schema Information
#
# Table name: view_reestructuracion
#
#  monto_abono                            :text
#  monto_abono_letras                     :decimal(16, 2)
#  referencia_abono                       :string
#  banco_abono                            :string(80)
#  fecha_abono                            :text
#  numero_cuenta                          :string(20)
#  interes_diferido                       :text
#  interes_diferido_letras                :decimal(, )
#  interes_moratorio                      :text
#  interes_moratorio_letras               :decimal(, )
#  interes_ordinarios                     :text
#  interes_ordinarios_letras              :decimal(, )
#  interes_causado_no_devengado           :text
#  interes_causado_no_devengado_letras    :decimal(, )
#  porcentaje_arrime                      :text
#  porcentaje_arrime_letras               :float
#  monto_reestructurado                   :text
#  monto_reestructurado_letras            :decimal(16, 2)
#  frecuencia                             :text
#  cuotas                                 :text
#  saldo_insoluto_reestructuracion        :text
#  saldo_insoluto_reestructuracion_letras :decimal(16, 2)
#  solicitud_id                           :integer
#

