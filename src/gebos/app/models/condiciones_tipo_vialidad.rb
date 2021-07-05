# encoding: utf-8

#
# autor: Marvin Alfonzo
# clase: CondicionesTipoVialidad
# descripción: Migración a Rails 3
#
class CondicionesTipoVialidad < ActiveRecord::Base
  
  self.table_name = 'condiciones_tipo_vialidad'
  
  attr_accessible :id, :tipo_vialidad_id, :unidad_produccion_condicion_acuicultura_id, :descripcion_otro

  belongs_to :unidad_produccion_condicion_acuicultura
  belongs_to :tipo_vialidad
  



  
end



# == Schema Information
#
# Table name: condiciones_tipo_vialidad
#
#  id                                         :integer         not null, primary key
#  tipo_vialidad_id                           :integer         not null
#  unidad_produccion_condicion_acuicultura_id :integer         not null
#  descripcion_otro                           :text
#

