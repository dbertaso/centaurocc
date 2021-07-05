# encoding: utf-8

#
# autor: 
# clase: CaracterizacionTipoSuelo
# descripción: Migración a Rails 3
#

class CaracterizacionTipoSuelo < ActiveRecord::Base

  self.table_name = 'caracterizacion_tipo_suelo'

attr_accessible :id,
				:tipo_suelo_id,
				:unidad_produccion_caracterizacion_id,
				:porcentaje
  
  belongs_to :unidad_produccion_caracterizacion
  belongs_to :tipo_suelo
  
  validates_numericality_of :porcentaje,
      :only_integer => false, :allow_nil => true,
      :message => " número inválido"
  
end



# == Schema Information
#
# Table name: caracterizacion_tipo_suelo
#
#  id                                   :integer         not null, primary key
#  tipo_suelo_id                        :integer         not null
#  unidad_produccion_caracterizacion_id :integer         not null
#  porcentaje                           :float
#

