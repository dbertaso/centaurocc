# encoding: utf-8

#
# autor: Luis Rojas
# clase: Solicitudes::SolicitudPreEvaluacionCaracterizacionController
# descripción: Migración a Rails 3
#
class CondicionesSistemaCultivoActual < ActiveRecord::Base
  
  self.table_name = 'condiciones_sistema_cultivo_actual'
  
  attr_accessible :id, :tipo_sistema_acuicultura_id, :unidad_produccion_condicion_acuicultura_id, :descripcion_otr

  belongs_to :UnidadProduccionCondicionAcuicultura
  belongs_to :tipo_sistema_acuicultura
  



  
end



# == Schema Information
#
# Table name: condiciones_sistema_cultivo_actual
#
#  id                                         :integer         not null, primary key
#  tipo_sistema_acuicultura_id                :integer         not null
#  unidad_produccion_condicion_acuicultura_id :integer         not null
#  descripcion_otro                           :text
#

