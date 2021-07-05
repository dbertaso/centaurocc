# encoding: utf-8

#
# autor: Luis Rojas
# clase: RolComite
# descripción: Migración a Rails 3
#
class RolComite < ActiveRecord::Base
  
  self.table_name = 'rol_comite'
  
  attr_accessible :id, :nombre, :descripcion, :activo

  validates :nombre, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
	:uniqueness => {:message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"},
    :format => {:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio_numero_puntuacion')}/, 
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}"}
  
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
# Table name: rol_comite
#
#  id          :integer         not null, primary key
#  nombre      :string(100)     not null
#  descripcion :string(255)
#  activo      :boolean         default(TRUE)
#

