# encoding: utf-8

#
# autor: Diego Bertaso
# clase: ViewEnvioAsientoContable
# descripción: Build in Rails 3

class ViewEnvioAsientoContable < ActiveRecord::Base

  self.table_name = 'view_envio_asiento_contable'
  
  attr_accessible :comprobante_contable_id,
                  :monto,
                  :tipo,
                  :codigo_contable,
                  :auxiliar_contable

end
# == Schema Information
#
# Table name: view_envio_asiento_contable
#
#  comprobante_contable_id :integer
#  monto                   :float
#  tipo                    :string(1)
#  codigo_contable         :string(25)
#  auxiliar_contable       :string(20)
#

