# encoding: utf-8
class ControlEnvioDesembolso < ActiveRecord::Base

  self.table_name = 'control_envio_desembolso'

  attr_accessible  :id,
    :fecha,
    :archivo,
    :numero_procesado,
    :monto_procesado,
    :entidad_financiera_id,
    :estatus

  #  def estatus
  #
  #    case self.estatus
  #
  #        when 0
  #          'Por Procesar'
  #        when 1
  #          'En Proceso'
  #        when 2
  #          'Procesado'
  #    end
  #
  #end

  def fecha_f
    format_fecha(self.fecha)
  end

end

# == Schema Information
#
# Table name: control_envio_desembolso
#
#  id                    :integer         not null, primary key
#  fecha                 :date            default(Mon, 01 Jan 1900)
#  archivo               :string(100)
#  numero_procesado      :integer         default(0)
#  monto_procesado       :decimal(16, 2)  default(0.0)
#  entidad_financiera_id :integer
#  estatus               :integer
#

