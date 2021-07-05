# encoding: UTF-8

#
# autor: Marvin Alfonzo
# clase: CondicionesEspeciesSolicitadas
# descripción: Migración a Rails 3
#

class CondicionesEspeciesSolicitadas < ActiveRecord::Base
  
  self.table_name = 'condiciones_especies_solicitadas'
  
  attr_accessible :id, :tipo_especie_acuicultura_id, :unidad_produccion_condicion_acuicultura_id, :descripcion_otro

  belongs_to :unidad_produccion_condicion_acuicultura
  belongs_to :tipo_especie_acuicultura
  



  
end



# == Schema Information
#
# Table name: condiciones_especies_solicitadas
#
#  id                                         :integer         not null, primary key
#  tipo_especie_acuicultura_id                :integer         not null
#  unidad_produccion_condicion_acuicultura_id :integer         not null
#  descripcion_otro                           :text
#

