# encoding: utf-8

#
# autor: Marvin Alfonzo
# clase: ControlEnvioAbonoExcedenteCosecha
# descripcion: Migracion a Rails 3



class ControlEnvioAbonoExcedenteCosecha < ActiveRecord::Base


self.table_name = 'control_envio_abono_excedente_cosecha'
  
attr_accessible :id,
                :fecha,
                :archivo,
                :numero_procesado,
                :monto_procesado,
                :entidad_financiera_id,
                :estatus,
                :tipo_operacion,
                :numero_lote,
                :fecha_f

  def fecha_f
    format_fecha(self.fecha)
  end


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

end

# == Schema Information
#
# Table name: control_envio_abono_excedente_cosecha
#
#  id                    :integer         not null, primary key
#  fecha                 :date            default(Mon, 01 Jan 1900)
#  archivo               :string(100)
#  numero_procesado      :integer         default(0)
#  monto_procesado       :decimal(16, 2)  default(0.0)
#  entidad_financiera_id :integer
#  estatus               :integer
#  tipo_operacion        :string(1)
#  numero_lote           :string(20)
#

