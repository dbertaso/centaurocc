# encoding: utf-8
class OpcionGrupo < ActiveRecord::Base

  self.table_name = 'opcion_grupo'
  
  attr_accessible :id, :nombre, :descripcion
 
  has_many :opcion
 
 
  validates :nombre, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :length => { :in => 4..50, :allow_blank => false,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('errors.messages.too_long.other')}"},
    :uniqueness =>{:uniqueness => true, :message =>"#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Usuario.Errores.cedula_ya_existe')}"}

  validates :descripcion, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.Form.descripcion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :length => { :in => 4..50, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.Form.descripcion')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.Form.descripcion')} #{I18n.t('errors.messages.too_long.other')}"}
  
  
end

# == Schema Information
#
# Table name: opcion_grupo
#
#  id          :integer         not null, primary key
#  nombre      :string(50)      not null
#  descripcion :string(300)
#

