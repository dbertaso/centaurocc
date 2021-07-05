# encoding: utf-8

#
# autor: Luis Rojas
# clase: LinderosCoordenadas
# descripcion: Migracion a Rails 3
#
class LinderosCoordenadas < ActiveRecord::Base
  
  self.table_name = 'linderos_coordenadas'
  
  attr_accessible :id, :solicitud_id, :unidad_produccion_id, :seguimiento_visita_id,
    :lindero_norte, :lindero_sur, :lindero_este, :lindero_oeste, :utm_norte, :utm_sur,
    :utm_este, :utm_oeste, :direccion_correcta, :superficie_correcta, :lindero_correcto,
    :referencial_utm

  belongs_to :solicitud
  belongs_to :unidad_produccion
  belongs_to :seguimiento_visita
  
end



# == Schema Information
#
# Table name: linderos_coordenadas
#
#  id                    :integer         not null, primary key
#  solicitud_id          :integer         not null
#  unidad_produccion_id  :integer         not null
#  seguimiento_visita_id :integer         not null
#  lindero_norte         :text
#  lindero_sur           :text
#  lindero_este          :text
#  lindero_oeste         :text
#  utm_norte             :text
#  utm_sur               :text
#  utm_este              :text
#  utm_oeste             :text
#  direccion_correcta    :boolean
#  superficie_correcta   :boolean
#  lindero_correcto      :boolean
#  referencial_utm       :text
#

