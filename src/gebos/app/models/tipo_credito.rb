# encoding: utf-8
# 
# autor: Luis Rojas
# clase: RolComite
# descripción: Migración a Rails 3
#
class TipoCredito < ActiveRecord::Base

  self.table_name = 'tipo_credito'
  
  attr_accessible :id, :nombre, :descripcion, :activo

  validates :nombre, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :format => {:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio')}/, 
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}"}
  
  validates :descripcion, :presence => {:message => "#{I18n.t('Sistema.Body.General.descripcion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :format => {:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio')}/, 
    :message => "#{I18n.t('Sistema.Body.General.descripcion')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}"}
    
  validates_length_of :nombre, :within => 3..40, :allow_blank => true
    
  validates_length_of :descripcion, :within => 3..400, :allow_blank => true
      
  validates_uniqueness_of :nombre, 
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"
   
  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
      :conditions => search, :order => sort
  end

end

# == Schema Information
#
# Table name: tipo_credito
#
#  id          :integer         not null, primary key
#  nombre      :string(40)      not null
#  descripcion :string(300)
#  activo      :boolean         default(TRUE)
#

