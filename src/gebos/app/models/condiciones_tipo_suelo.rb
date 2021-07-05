# encoding: utf-8

#
# autor: Luis Rojas
# clase: CondicionesTipoSuelo
# descripción: Migración a Rails 3
#
class CondicionesTipoSuelo < ActiveRecord::Base
  
  self.table_name = 'condiciones_tipo_suelo'
  
  attr_accessible :id, :tipo_suelo_id, :unidad_produccion_condicion_acuicultura_id, :porcentaje

  belongs_to :unidad_produccion_condicion_acuicultura
  belongs_to :tipo_suelo
  
  validates_numericality_of :porcentaje,
    :only_integer => false, :allow_nil => true,
    :message => " número inválido"

  def validar_suelo_procentajes(condiciones,porcentaje,tipo_suelo)

    validacion = CondicionesTipoSuelo.sum(:porcentaje, :conditions=>['unidad_produccion_condicion_acuicultura_id = ? and tipo_suelo_id <> ?', condiciones,tipo_suelo])
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
# Table name: condiciones_tipo_suelo
#
#  id                                         :integer         not null, primary key
#  tipo_suelo_id                              :integer         not null
#  unidad_produccion_condicion_acuicultura_id :integer         not null
#  porcentaje                                 :float
#

