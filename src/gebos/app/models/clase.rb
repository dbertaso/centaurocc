# encoding: utf-8

#
# autor: Luis Rojas
# clase: Clase
# descripción: Migración a Rails 3
#
class Clase < ActiveRecord::Base
  
  self.table_name = 'clase'
  
  attr_accessible :id, :nombre, :descripcion, :activo, :tipo_maquinaria_id

  has_many :solicitud_maquinaria
  has_many :stock_maquinaria
  has_many :catalogo
  has_many :unidad_produccion_maquinaria
  belongs_to :tipo_maquinaria

  validates :nombre, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :format => {:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio_numero_puntuacion')}/, 
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}"},
    :uniqueness =>{:uniqueness => true, :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_registrado')}"}
  
  validates :descripcion, :presence => {:message => "#{I18n.t('Sistema.Body.General.descripcion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :format => {:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio_numero_puntuacion')}/, 
    :message => "#{I18n.t('Sistema.Body.General.descripcion')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}"}
  
  validates :tipo_maquinaria_id, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.rubro')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
    
  validates_length_of :nombre, :within => 3..100, :allow_blank => true
    
  validates_length_of :descripcion, :within => 3..255, :allow_blank => true
   
  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
      :conditions => search, :order => sort,
      :include => 'tipo_maquinaria'
  end  
end

# == Schema Information
#
# Table name: clase
#
#  id                 :integer         not null, primary key
#  nombre             :string(100)     not null
#  descripcion        :string(255)
#  activo             :boolean         default(FALSE), not null
#  tipo_maquinaria_id :integer         not null
#

