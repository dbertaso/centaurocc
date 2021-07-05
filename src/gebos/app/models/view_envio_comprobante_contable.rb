# encoding: utf-8

#
# autor: Diego Bertaso
# clase: ViewEnvioComprobanteContable
# descripción: Build in Rails 3

class ViewEnvioComprobanteContable < ActiveRecord::Base

  self.table_name = 'view_envio_comprobante_contable'
  
  attr_accessible :id,
                  :fecha_registro,
                  :fecha_comprobante,
                  :fecha_envio,
                  :referencia,
                  :factura_id,
                  :prestamo_id,
                  :anio,
                  :transaccion_id,
                  :total_debe,
                  :total_haber
                  
end

# == Schema Information
#
# Table name: view_envio_comprobante_contable
#
#  id                :integer
#  fecha_registro    :date
#  fecha_comprobante :date
#  fecha_envio       :date
#  referencia        :text
#  factura_id        :integer
#  prestamo_id       :integer
#  anio              :integer
#  transaccion_id    :integer
#  total_debe        :float
#  total_haber       :float
#

