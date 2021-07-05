# encoding: utf-8
# To change this template, choose Tools | Templates
# and open the template in the editor.
class RechazoLiquidacion < ActiveRecord::Base
  
  self.table_name = 'rechazo_liquidacion'
  
  attr_accessible :id ,
    :fecha,
    :archivo,
    :prestamo_numero,
    :solicitud_numero,
    :cliente_id,
    :monto_pago,
    :codigo_error,
    :descripcion_error,
    :entidad_financiera_id,
    :procesado
  
  
end

# == Schema Information
#
# Table name: rechazo_liquidacion
#
#  id                    :integer         not null, primary key
#  fecha                 :date            default(Mon, 01 Jan 1900)
#  archivo               :string(100)
#  prestamo_numero       :integer(8)      default(0)
#  solicitud_numero      :integer(8)      default(0)
#  cliente_id            :integer         default(0)
#  monto_pago            :decimal(, )     default(0.0)
#  codigo_error          :integer         default(0)
#  descripcion_error     :string(255)
#  entidad_financiera_id :integer         default(0)
#  procesado             :boolean         default(FALSE)
#

