# encoding: utf-8

#
# autor: Luis Rojas
# clase: Profesion
# descripción: Migración a Rails 3
#
class Profesion < ActiveRecord::Base
  
  self.table_name = 'profesion'
  
  attr_accessible :id, :nombre, :descripcion
  
  has_many :tecnico_campo
  
  validates :nombre, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :format => {:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio')}/, 
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}"},
    :uniqueness =>{:uniqueness => true, :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_registrado')}"}
  
  validates :descripcion, :presence => {:message => "#{I18n.t('Sistema.Body.General.descripcion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :format => {:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio_numero_puntuacion')}/, 
    :message => "#{I18n.t('Sistema.Body.General.descripcion')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}"}
    
  validates_length_of :nombre, :within => 3..40, :allow_blank => true
    
  validates_length_of :descripcion, :within => 3..400, :allow_blank => true
  
  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
             :conditions => search, :order => sort
  end

end

# == Schema Information
#
# Table name: profesion
#
#  id          :integer         not null, primary key
#  nombre      :string(60)      not null
#  descripcion :string(400)
#

