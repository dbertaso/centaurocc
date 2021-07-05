# encoding: utf-8

#
# autor: Diego Bertaso
# clase: RechazoEnvioComprobante
# descripción: Build in Rails 3

class RechazoEnvioComprobante < ActiveRecord::Base

  self.table_name = 'rechazo_envio_comprobante'
  
  attr_accessible :id,
                  :fecha_comprobante,
                  :referencia,
                  :motivo,
                  :total_debe,
                  :total_haber,
                  :numero,
                  :usuario_id,
                  :fecha_proceso

end

# == Schema Information
#
# Table name: rechazo_envio_comprobante
#
#  id                :integer         not null, primary key
#  fecha_comprobante :date
#  referencia        :text
#  motivo            :text
#  total_debe        :decimal(16, 2)
#  total_haber       :decimal(16, 2)
#  numero            :integer
#  usuario_id        :integer
#  fecha_proceso     :date
#

