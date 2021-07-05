# encoding: utf-8

#
# autor: 
# clase: CaracterizacionTipoVialidad
# descripción: Migración a Rails 3
#
class CaracterizacionTipoVialidad < ActiveRecord::Base

  self.table_name = 'caracterizacion_tipo_vialidad'
  
  attr_accessible :id,
				  :tipo_vialidad_id,
				  :unidad_produccion_caracterizacion_id,
				  :descripcion_otro

  belongs_to :unidad_produccion_caracterizacion
  belongs_to :tipo_vialidad
  



  
end



# == Schema Information
#
# Table name: caracterizacion_tipo_vialidad
#
#  id                                   :integer         not null, primary key
#  tipo_vialidad_id                     :integer         not null
#  unidad_produccion_caracterizacion_id :integer         not null
#  descripcion_otro                     :text
#

