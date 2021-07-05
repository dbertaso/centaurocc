# encoding: utf-8
class TipoEmbarcacion < ActiveRecord::Base

  self.table_name = 'tipo_embarcacion'

  attr_accessible :id,
    :tipo,
    :descripcion,
    :activo

  has_many :embarcacion

  validates :tipo, :presence=> {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.tipo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :format =>{:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio_numero_otro')}/, :allow_blank =>true, :message =>"#{I18n.t('Sistema.Body.Vistas.General.tipo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalido')}"},
    :length => { :in => 3..40, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.tipo')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.tipo')}  #{I18n.t('errors.messages.too_long.other')}"},
    :uniqueness =>{:uniqueness => true, :message => "#{I18n.t('Sistema.Body.Vistas.General.tipo')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"}

  validates :descripcion, :presence=>{
    :message => "#{I18n.t('Sistema.Body.Vistas.Form.descripcion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

#  validates_uniqueness_of :tipo,
#    :message => "#{I18n.t('Sistema.Body.Vistas.General.tipo')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"
#  
#  validates_length_of :tipo, :within => 3..40, :allow_blank => true,
#    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.tipo')} #{I18n.t('errors.messages.too_short.other')}",
#    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.tipo')}  #{I18n.t('errors.messages.too_long.other')}"

  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
      :conditions => search, :order => sort
  end
  
end

# == Schema Information
#
# Table name: tipo_embarcacion
#
#  id          :integer         not null, primary key
#  tipo        :string(100)     not null
#  descripcion :string(250)     not null
#  activo      :boolean         default(TRUE), not null
#

