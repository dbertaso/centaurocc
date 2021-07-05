# encoding: utf-8

#
# autor: Diego Bertaso
# clase: PerformanceCobranzas
# creado con Rails 3
#


class PerformanceCobranzas < ActiveRecord::Base
  
  self.table_name = 'performance_cobranzas'
  
  attr_accessible :id,
                  :prestamo_id,
                  :cliente_id,
                  :cantidad_intentos,
                  :cantidad_contactos,
                  :cantidad_contactos_exitosos,
                  :cantidad_promesas_pago,
                  :cantidad_promesas_cumplidas,
                  :cantidad_promesas_cumplidas_parcialmente,
                  :cantidad_promesas_incumplidas,
                  :porcentaje_contactos,
                  :porcentaje_contactos_exitosos,
                  :porcentaje_promesas_pago,
                  :porcentaje_promesas_pago_cumplidas,
                  :porcentaje_promesas_pago_incumplidas,
                  :porcentaje_promesas_pago_parcialmente_cumplidas,
                  :cantidad_email_enviados,
                  :cantidad_sms_enviados

  validates_presence_of :prestamo_id,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.financiamiento')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"
    
  validates_presence_of :cliente_id,
    :message => "#{I18n.t('Sistema.Body.General.beneficiario')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"
  
end

# == Schema Information
#
# Table name: performance_cobranzas
#
#  id                                              :integer         not null, primary key
#  prestamo_id                                     :integer         not null
#  cliente_id                                      :integer         not null
#  cantidad_intentos                               :integer         default(0), not null
#  cantidad_contactos                              :integer         default(0), not null
#  cantidad_contactos_exitosos                     :integer         default(0), not null
#  cantidad_promesas_pago                          :integer         default(0), not null
#  cantidad_promesas_cumplidas                     :integer         default(0), not null
#  cantidad_promesas_cumplidas_parcialmente        :integer         default(0), not null
#  cantidad_promesas_incumplidas                   :integer         default(0), not null
#  porcentaje_contactos                            :decimal(5, 2)   default(0.0), not null
#  porcentaje_contactos_exitosos                   :decimal(5, 2)   default(0.0), not null
#  porcentaje_promesas_pago                        :decimal(5, 2)   default(0.0), not null
#  porcentaje_promesas_pago_cumplidas              :decimal(5, 2)   default(0.0), not null
#  porcentaje_promesas_pago_incumplidas            :decimal(5, 2)   default(0.0), not null
#  porcentaje_promesas_pago_parcialmente_cumplidas :decimal(5, 2)   default(0.0), not null
#  cantidad_email_enviados                         :integer         default(0), not null
#  cantidad_sms_enviados                           :integer         default(0), not null
#

