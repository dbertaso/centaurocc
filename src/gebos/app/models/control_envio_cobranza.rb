# encoding: utf-8

#
# autor: Diego Bertaso
# clase: ControlEnvioCobranza
# descripción: Inclusión y Migración a Rails 3

class ControlEnvioCobranza < ActiveRecord::Base
  

self.table_name = 'control_envio_cobranza'

attr_accessible :id,
                :fecha,
                :archivo,
                :estatus_proceso,
                :numero_procesado,
                :monto_procesado,
                :entidad_financiera_id,
                :fecha_proceso,
                :numero_cuenta,
                :tipo_cuenta

belongs_to :entidad_financiera

#Definición de métodos no presentes en la base de datos (columnas calculadas

def tipo_cuenta_w

  case tipo_cuenta
    when 'C'
      I18n.t('Sistema.Body.Vistas.General.corriente')
    when 'A'
      I18n.t('Sistema.Body.Vistas.General.ahorro')
  else
      I18n.t('Sistema.Body.Vistas.General.corriente')
  end 
end

def estado

  case self.estatus_proceso

  when 0
    I18n.t('Sistema.Body.Modelos.ControlEnvioCobranzas.Estatus.por_procesar')
  when 1
    I18n.t('Sistema.Body.Modelos.ControlEnvioCobranzas.Estatus.en_proceso')
  when 2
    I18n.t('Sistema.Body.Modelos.ControlEnvioCobranzas.Estatus.procesado')
  end
  
end

def self.search(search, page, sort)

  paginate :per_page => @records_by_page, :page => page,
           :conditions => search, :order => sort
end

def numero_procesado_fm

  unless self.numero_procesado.nil?
    format_int(self.numero_procesado)
  end

end

def monto_procesado_fm

  unless self.monto_procesado.nil?
    format_fm(self.monto_procesado)
  end

 end

 
end

# == Schema Information
#
# Table name: control_envio_cobranza
#
#  id                    :integer         not null, primary key
#  fecha                 :date            default(Mon, 01 Jan 1900)
#  archivo               :string(100)
#  estatus_proceso       :integer         default(0)
#  numero_procesado      :integer         default(0)
#  monto_procesado       :decimal(, )     default(0.0)
#  entidad_financiera_id :integer
#  fecha_proceso         :date            default(Mon, 01 Jan 1900)
#  numero_cuenta         :string(20)
#  tipo_cuenta           :string(1)
#

