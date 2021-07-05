# encoding: utf-8
class TipoDrenaje < ActiveRecord::Base

  self.table_name = 'tipo_drenaje'
  
  attr_accessible  :id,
    :nombre,
    :descripcion,
    :activo
  
  has_many :unidad_produccion_caracterizacion
  has_many :unidad_produccion_condicion_acuicultura

  validates :nombre, :presence => {
    :message => "#{I18n.t('Sistema.Body.Controladores.TipoDrenaje.FormTitles.form_title_record')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :format =>{:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio_numero_otro')}/, :allow_blank =>true, :message =>"#{I18n.t('Sistema.Body.Controladores.TipoDrenaje.FormTitles.form_title_record')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalido')}"},
    :length => { :in => 3..40, :allow_blank => false,
    :too_short => "#{I18n.t('Sistema.Body.Controladores.TipoDrenaje.FormTitles.form_title_record')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Controladores.TipoDrenaje.FormTitles.form_title_record')}  #{I18n.t('errors.messages.too_long.other')}"},
    :uniqueness =>{:uniqueness => true, :message => "#{I18n.t('Sistema.Body.Controladores.TipoDrenaje.FormTitles.form_title_record')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"}
  
  validates :descripcion, :presence => {
    :message => "#{I18n.t('Sistema.Body.General.descripcion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :length => { :in => 3..300, :allow_blank => false,
    :too_short => "#{I18n.t('Sistema.Body.General.descripcion')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => " #{I18n.t('Sistema.Body.General.descripcion')} #{I18n.t('errors.messages.too_long.other')}"}
  
      
#  validates_uniqueness_of :nombre, 
#    :message =>"#{I18n.t('Sistema.Body.Controladores.TipoDrenaje.FormTitles.form_title_record')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"
  
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
# Table name: tipo_drenaje
#
#  id          :integer         not null, primary key
#  nombre      :text            not null
#  descripcion :text            not null
#  activo      :boolean         not null
#

