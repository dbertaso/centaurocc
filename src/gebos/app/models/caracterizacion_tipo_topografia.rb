# encoding: utf-8

#
# autor: 
# clase: CaracterizacionTipoTopografia
# descripción: Migración a Rails 3
#

class CaracterizacionTipoTopografia < ActiveRecord::Base

self.table_name = 'caracterizacion_tipo_topografia'

attr_accessible :id,
				:tipo_topografia_id,
				:unidad_produccion_caracterizacion_id,
				:descripcion_otro,
				:porcentaje
  
  
  belongs_to :tipo_topografia
  belongs_to :unidad_produccion_caracterizacion
  belongs_to :tipo_suelo
  
  validates_numericality_of :porcentaje,
      :only_integer => false, :allow_nil => true,
      :message => " topografía, número inválido" 

def validar_procentajes(caracterizacion,porcentaje,tipo_topografia)
  #@validacion = CaracterizacionTipoTopografia.sum(porcentaje, :condition=>['unidad_produccion_caracterizacion_id = ? and tipo_topografia_id = ?',caracterizacion,tipo_topografia])
  validacion = CaracterizacionTipoTopografia.sum(:porcentaje, :conditions=>['unidad_produccion_caracterizacion_id = ? and tipo_topografia_id <> ?', caracterizacion,tipo_topografia])
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
# Table name: caracterizacion_tipo_topografia
#
#  id                                   :integer         not null, primary key
#  tipo_topografia_id                   :integer         not null
#  unidad_produccion_caracterizacion_id :integer         not null
#  descripcion_otro                     :text
#  porcentaje                           :float
#

