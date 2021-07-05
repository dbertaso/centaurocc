# encoding: utf-8

#
# autor: Luis Rojas
# clase: SolicitudRecaudo
# descripción: Migración a Rails 3
#

class SolicitudRecaudo < ActiveRecord::Base

  self.table_name = 'solicitud_recaudo'
  
  attr_accessible :id,
				  :solicitud_id,
				  :recaudo_id,
				  :entregado,
				  :tramite,
				  :revisado_consultoria,
				  :no_revisado_consultoria,
				  :observaciones,
				  :no_aplica
  
  belongs_to :solicitud
  belongs_to :recaudo  

  validates :solicitud_id, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.tipo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerida')}"}

  validates :recaudo_id, :presence => {:message => "#{I18n.t('Sistema.Body.Controladores.Recaudo.FormTitles.form_title')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  def self.update_observaciones(solicitud, params)
    unless params[:consultoria].nil? || params[:consultoria].empty?
      unless params[:observacion].nil? || params[:observacion].empty?
        solicitud.consultoria = params[:consultoria]
        solicitud.observacion = params[:observacion]
        solicitud.save
        return true 
      else
        solicitud.errors.add(:solicitud_recaudo, "#{I18n.t('Sistema.Body.Vistas.General.observacion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
        return false
      end
    else
      solicitud.errors.add(:solicitud_recaudo, "#{I18n.t('Sistema.Body.Vistas.General.viable_juridicamente')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
      return false
    end
  end  
end

# == Schema Information
#
# Table name: solicitud_recaudo
#
#  id                      :integer         not null, primary key
#  solicitud_id            :integer         not null
#  recaudo_id              :integer         not null
#  entregado               :boolean         default(FALSE)
#  tramite                 :boolean         default(FALSE)
#  revisado_consultoria    :boolean
#  no_revisado_consultoria :boolean
#  observaciones           :string(250)
#  no_aplica               :boolean         default(FALSE), not null
#

