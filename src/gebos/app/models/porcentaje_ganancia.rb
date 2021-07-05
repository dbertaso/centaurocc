# encoding: utf-8

#
# autor: Luis Rojas
# clase: PorcentajeGanancia
# descripción: Migración a Rails 3
#
class PorcentajeGanancia < ActiveRecord::Base
  
  self.table_name = 'porcentaje_ganancia'
  
  attr_accessible :id, :nombre
  
  has_many :unidad_negocio
  
  validates :nombre, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :format => {:with => /^[0-9%\- ]+$/, 
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalido')}"}

  validates_uniqueness_of :nombre,
    :message => I18n.t('Sistema.Body.Vistas.General.nombre') << " " << I18n.t('Sistema.Body.Modelos.Errores.ya_existe')
    
  validates_length_of :nombre, :within => 3..100, :allow_blank => true
  
  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
             :conditions => search, :order => sort
  end
      
end

# == Schema Information
#
# Table name: porcentaje_ganancia
#
#  id     :integer         not null, primary key
#  nombre :string(100)     not null
#

