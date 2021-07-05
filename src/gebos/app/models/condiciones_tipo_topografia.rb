# encoding: utf-8

#
# autor: Luis Rojas
# clase: CondicionesTipoTopografia
# descripción: Migración a Rails 3
#
class CondicionesTipoTopografia < ActiveRecord::Base
  
  self.table_name = 'condiciones_tipo_topografia'
  
  attr_accessible :id, :tipo_topografia_id, :unidad_produccion_condicion_acuicultura_id, :descripcion_otro, :porcentaje

  belongs_to :UnidadProduccionCondicionAcuicultura
  belongs_to :tipo_topografia
  
  validates_numericality_of :porcentaje,
      :only_integer => false, :allow_nil => true,
      :message => " topografía, número inválido"

  def validar_procentajes(condiciones,porcentaje,tipo_topografia)
  
    validacion = CondicionesTipoTopografia.sum(:porcentaje, :conditions=>['unidad_produccion_condicion_acuicultura_id = ? and tipo_topografia_id <> ?', condiciones,tipo_topografia])
    suma_porcentajes = validacion.to_f + porcentaje.to_f
    if suma_porcentajes > 100
      return false
    else
      return true
    end  
  end
 
end



# == Schema Information
#
# Table name: condiciones_tipo_topografia
#
#  id                                         :integer         not null, primary key
#  tipo_topografia_id                         :integer         not null
#  unidad_produccion_condicion_acuicultura_id :integer         not null
#  descripcion_otro                           :text
#  porcentaje                                 :float
#

