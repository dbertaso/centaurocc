# encoding: utf-8

#
# autor: Luis Rojas
# clase: ComunidadIndigena
# descripción: Migración a Rails 3
#
class ComunidadIndigena < ActiveRecord::Base
  
  self.table_name = 'comunidad_indigena'
  
  attr_accessible :id, :estado_id, :municipio_id, :parroquia_id,:pueblo_indigena, :comunidad_indigena

  belongs_to :estado
  belongs_to :municipio
  belongs_to :parroquia

  validates :estado_id, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.estado')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
    
  validates :municipio_id, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.municipio')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :parroquia_id, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.parroquia')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :comunidad_indigena, :presence => {:message => I18n.t('Sistema.Body.Modelos.ComunidadIndigena.Errores.comunidad_requerido')},
    :uniqueness =>{:uniqueness => true, :message => I18n.t('Sistema.Body.Modelos.ComunidadIndigena.Errores.registro_existe')}

  validates :pueblo_indigena, :presence => {:message => I18n.t('Sistema.Body.Modelos.ComunidadIndigena.Errores.pueblo_requerido')},
    :format => {:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio_numero_puntuacion')}/, 
    :message => "#{I18n.t('Sistema.Body.Vistas.General.pueblo_indigena')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}"}
  
  def self.search(search, page, sort)
  
    paginate :per_page => @records_by_page, :page => page,
             :conditions => search, :order => sort
  end

  def eliminar_acentos(nombre)
    nombre = nombre.to_s
    nombre.downcase!
    nombre.gsub!(/[á|Á]/,'a')
    nombre.gsub!(/[é|É]/,'e')
    nombre.gsub!(/[í|Í]/,'i')
    nombre.gsub!(/[ó|Ó]/,'o')
    nombre.gsub!(/[ú|Ú]/,'u')
    return nombre
  end

end

# == Schema Information
#
# Table name: comunidad_indigena
#
#  id                 :integer         not null, primary key
#  estado_id          :integer
#  municipio_id       :integer
#  parroquia_id       :integer
#  pueblo_indigena    :string(30)
#  comunidad_indigena :text
#

