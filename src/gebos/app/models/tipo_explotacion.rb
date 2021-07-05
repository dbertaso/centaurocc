# encoding: utf-8
class TipoExplotacion < ActiveRecord::Base

  self.table_name = 'tipo_explotacion'
  
  attr_accessible   :id,
    :nombre
  
  has_many :unidad_negocio
  
  validates :nombre, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.Form.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :format =>{:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio_numero_otro')}/, :allow_blank =>true, :message =>"#{I18n.t('Sistema.Body.Vistas.General.tipo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalido')}"},
    :length => { :in => 3..40, :within => 3..40, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.Form.nombre')} es demasiado corto (mínimo %{count})",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.Form.nombre')}  es demasiado largo (máximo %{count})"},
    :uniqueness =>{:uniqueness => true, :message => "#{I18n.t('Sistema.Body.Vistas.Form.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"}

#  validates_uniqueness_of :nombre,
#    :message => "#{I18n.t('Sistema.Body.Vistas.Filtros.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"
#
#  validates_length_of :nombre, :within => 3..40, :allow_blank => true,
#    :too_short => "#{I18n.t('Sistema.Body.Vistas.Form.nombre')} es demasiado corto (mínimo %{count})",
#    :too_long => "#{I18n.t('Sistema.Body.Vistas.Form.nombre')}  es demasiado largo (máximo %{count})"
  
  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
      :conditions => search, :order => sort
  end

end

# == Schema Information
#
# Table name: tipo_explotacion
#
#  id     :integer         not null, primary key
#  nombre :string(100)     not null
#

