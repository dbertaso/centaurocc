# encoding: utf-8

#
# autor: Diego Bertaso
# clase: MensajesCorreo
# creado con Rails 3
#

class MensajesCorreo < ActiveRecord::Base

  self.table_name = 'mensajes_correo'

  attr_accessible :descripcion, 
                  :id, 
                  :nombre,
                  :activo

  validates_presence_of :nombre,
    :message => "#{I18n.t('Sistema.Body.Vistas.MensajesCorreo.Etiquetas.mensaje')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"

  validates_presence_of :descripcion,
    :message => "#{I18n.t('Sistema.Body.Vistas.MensajesCorreo.Etiquetas.contenido')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"

  after_initialize :after_initialize

  def after_initialize
    self.activo = true
  end
  def self.search(search, page, sort)

    unless search.nil?
      paginate  :per_page => @records_by_page, :page => page,
                :conditions => search, :order => sort
    else
      paginate  :per_page => @records_by_page, :page => page,
                :order => sort

    end
    
  end  

end

# == Schema Information
#
# Table name: mensajes_correo
#
#  id          :integer         not null, primary key
#  nombre      :string(255)
#  descripcion :text
#  activo      :boolean
#

