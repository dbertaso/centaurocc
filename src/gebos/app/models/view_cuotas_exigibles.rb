
class ViewCuotasExigibles < ActiveRecord::Base

end

# == Schema Information
#
# Table name: view_cuotas_exigibles
#
#  prestamo_numero       :integer(8)
#  plan_pago_id          :integer
#  tipo_cuota            :string(1)
#  cuota_numero          :integer(2)
#  fecha                 :date
#  monto_cuota           :decimal(, )
#  estatus_pago          :string(1)
#  exigible              :decimal(16, 2)
#  deuda                 :decimal(16, 2)
#  entidad_financiera_id :integer
#  numero_cuenta         :string(20)
#

