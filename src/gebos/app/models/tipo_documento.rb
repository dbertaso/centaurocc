# encoding: utf-8

#
# autor: Luis Rojas
# clase: TipoDocumento
# descripción: Migración a Rails 3
#

class TipoDocumento < ActiveRecord::Base
  
  self.table_name = 'tipo_documento'
  
  attr_accessible :id,
    :tipo,
    :descripcion,
    :activo
  
  validates :tipo, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :format => {:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio_numero_puntuacion')}/, 
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}"}
  
  validates :descripcion, :presence => {:message => "#{I18n.t('Sistema.Body.General.descripcion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :format => {:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio_numero_puntuacion')}/, 
    :message => "#{I18n.t('Sistema.Body.General.descripcion')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}"}

  validates_uniqueness_of :tipo, 
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"

  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
             :conditions => search, :order => sort
  end
  
  before_save :before_save
  
  def before_save
    tipo = eliminar_acentos(self.tipo)
    self.tipo = tipo.upcase
  end
  
  def eliminar_acentos(tipo)
    tipo = tipo.to_s
    tipo.downcase!
    tipo.gsub!(/[á|Á]/,'a')
    tipo.gsub!(/[é|É]/,'e')
    tipo.gsub!(/[í|Í]/,'i')
    tipo.gsub!(/[ó|Ó]/,'o')
    tipo.gsub!(/[ú|Ú]/,'u')
    return tipo
  end

end

# == Schema Information
#
# Table name: tipo_documento
#
#  id          :integer         not null, primary key
#  tipo        :string(100)     not null
#  descripcion :string(250)     not null
#  activo      :boolean         default(TRUE)
#

