# encoding: utf-8
class TipoRiego < ActiveRecord::Base

  self.table_name = 'tipo_riego'

  attr_accessible  :id,
    :nombre,
    :descripcion,
    :activo 
  
  has_many :unidad_produccion_caracterizacion
  
  validates :nombre, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.Form.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :format =>{:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio_numero_otro')}/, :allow_blank =>true, :message =>"#{I18n.t('Sistema.Body.Vistas.Form.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalido')}"},
    :length => { :in => 3..40, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.Form.nombre')} es demasiado corto (mínimo %d)",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.Form.nombre')}  es demasiado largo (máximo %d)"},
    :uniqueness =>{:uniqueness => true, :message => "#{I18n.t('Sistema.Body.Vistas.Form.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"}

    
    
  
  validates :descripcion, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.Form.descripcion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
    
#  validates_length_of :nombre, :within => 3..40, :allow_blank => true,
#    :too_short => "#{I18n.t('Sistema.Body.Vistas.Form.nombre')} es demasiado corto (mínimo %{count})",
#    :too_long => "#{I18n.t('Sistema.Body.Vistas.Form.nombre')}  es demasiado largo (máximo %{count})"
      
  validates_length_of :descripcion, :within => 3..300, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.General.descripcion')} es demasiado corto (mínimo %{count})",
    :too_long => " #{I18n.t('Sistema.Body.General.descripcion')} es demasiado largo (máximo %{count})"
      
#  validates_uniqueness_of :nombre, 
#    :message =>"#{I18n.t('Sistema.Body.Vistas.Filtros.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"
  
  def after_initialize
    # self.activo = true
  end
  
  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
      :conditions => search, :order => sort
  end
  
end


# == Schema Information
#
# Table name: tipo_riego
#
#  id          :integer         not null, primary key
#  nombre      :text            not null
#  descripcion :text            not null
#  activo      :boolean         not null
#

