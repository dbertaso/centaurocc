# encoding: utf-8

#
# autor: Luis Rojas
# clase: Solicitudes::SolicitudPreEvaluacionCaracterizacionController
# descripción: Migración a Rails 3
#
class CondicionesFuenteAgua < ActiveRecord::Base
  
  self.table_name = 'condiciones_fuente_agua'
  
  attr_accessible  :id, :tipo_fuente_agua_id, :unidad_produccion_condicion_acuicultura_id, :descripcion_otro

  belongs_to :unidad_produccion_condicion_acuicultura
  belongs_to :tipo_fuente_agua
  
end



# == Schema Information
#
# Table name: condiciones_fuente_agua
#
#  id                                         :integer         not null, primary key
#  tipo_fuente_agua_id                        :integer         not null
#  unidad_produccion_condicion_acuicultura_id :integer         not null
#  descripcion_otro                           :text
#

