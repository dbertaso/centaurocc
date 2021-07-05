
class CaracterizacionFuenteAgua < ActiveRecord::Base

self.table_name = 'caracterizacion_fuente_agua'

attr_accessible :id,
				:tipo_fuente_agua_id,
				:unidad_produccion_caracterizacion_id,
				:descripcion_otro

  belongs_to :unidad_produccion_caracterizacion
  belongs_to :tipo_fuente_agua
  



  
end



# == Schema Information
#
# Table name: caracterizacion_fuente_agua
#
#  id                                   :integer         not null, primary key
#  tipo_fuente_agua_id                  :integer         not null
#  unidad_produccion_caracterizacion_id :integer         not null
#  descripcion_otro                     :text
#

