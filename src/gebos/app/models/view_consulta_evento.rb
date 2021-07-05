# encoding: UTF-8

#
# autor: Luis Rojas
# clase: Solicitudes::SolicitudConsultaEventoController
# descripción: Migración a Rails 3
#
class ViewConsultaEvento < ActiveRecord::Base
    
  self.table_name = 'view_consulta_evento'
  
  attr_accessible :solicitud_id, :accion2, :fecha_evento, :estatus_origen, :estatus_destino,
    :accion, :observacion, :cuenta_usuario
    
  def fecha_evento_f
    self.fecha_evento.strftime('%d/%m/%Y %H:%M:%S') unless self.fecha_evento.nil?
  end
  
  def self.search(search, page, orden)    
    paginate :per_page=>@records_by_page, :page=>page, :conditions=>search, :order=>orden
  end
  
end

# == Schema Information
#
# Table name: view_consulta_evento
#
#  solicitud_id    :integer
#  accion2         :string(50)
#  fecha_evento    :datetime
#  estatus_origen  :text
#  estatus_destino :text
#  accion          :text
#  observacion     :string(1800)
#  cuenta_usuario  :string(30)
#

