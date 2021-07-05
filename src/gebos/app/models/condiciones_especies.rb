# encoding: UTF-8

#
# autor: Marvin Alfonzo
# clase: CondicionesEspecies
# descripción: Migración a Rails 3
#
class CondicionesEspecies < ActiveRecord::Base
  
  self.table_name = 'condiciones_especies'
  
  attr_accessible :id, :tipo_especie_acuicultura_id, :unidad_produccion_condicion_acuicultura_id, :descripcion_otro

  belongs_to :UnidadProduccionCondicionAcuicultura
  belongs_to :tipo_especie_acuicultura
  



  
end



# == Schema Information
#
# Table name: condiciones_especies
#
#  id                                         :integer         not null, primary key
#  tipo_especie_acuicultura_id                :integer         not null
#  unidad_produccion_condicion_acuicultura_id :integer         not null
#  descripcion_otro                           :text
#

