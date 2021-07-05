# encoding: utf-8

#
# autor: Diego Bertaso
# clase: CasoMedida
# descripción: Migración a Rails 3
#

class CasoMedida < ActiveRecord::Base

  self.table_name = 'caso_medida'
  
  attr_accessible :id,
                  :nombre,
                  :descripcion,
                  :activo
  
  validates_presence_of :nombre,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"

  validates_length_of :nombre, :within => 1..100, :allow_nil => false,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('errors.messages.too_long.other')}"

  validates_length_of :descripcion, :within => 1..255, :allow_nil => false,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.Form.descripcion')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.Form.descripcion')} #{I18n.t('errors.messages.too_long.other')}"

  validates_uniqueness_of :nombre,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"

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
# Table name: caso_medida
#
#  id          :integer         not null, primary key
#  nombre      :string(100)
#  descripcion :string(100)
#  activo      :boolean
#

