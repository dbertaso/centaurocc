# encoding: utf-8

#
# autor: Diego Bertaso
# clase: PagosCompromiso
# creado con Rails 3
#
class PagosCompromiso < ActiveRecord::Base

  self.table_name = 'pagos_compromiso'

  attr_accessible :id,
                  :compromiso_pago_id,
                  :pago_cliente_id,
                  :pago_prestamo_id

end

# == Schema Information
#
# Table name: pagos_compromiso
#
#  id                 :integer         not null, primary key
#  compromiso_pago_id :integer         not null
#  pago_cliente_id    :integer         not null
#  pago_prestamo_id   :integer         not null
#

