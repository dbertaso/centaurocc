# encoding: utf-8
class HistoricoLiquidacionTransferencia < ActiveRecord::Base

  self.table_name = 'historico_liquidacion_transferencia'
  
  attr_accessible :id, 
    :solicitud_id,
    :prestamo_id,
    :cliente_id,
    :fecha_liquidacion,
    :archivo,
    :monto_liquidacion,
    :entidad_financiera_liquidadora_id,
    :numero_cuenta_liquidadora,
    :entidad_financiera_cliente_id,
    :numero_cuenta_cliente
  
end




# == Schema Information
#
# Table name: historico_liquidacion_transferencia
#
#  id                                :integer         not null, primary key
#  solicitud_id                      :integer         not null
#  prestamo_id                       :integer         not null
#  cliente_id                        :integer         not null
#  fecha_liquidacion                 :date
#  archivo                           :string(100)
#  monto_liquidacion                 :decimal(16, 2)  default(0.0)
#  entidad_financiera_liquidadora_id :integer
#  numero_cuenta_liquidadora         :string(20)
#  entidad_financiera_cliente_id     :integer         not null
#  numero_cuenta_cliente             :string(20)      not null
#

