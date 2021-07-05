# encoding: utf-8
class SectorTipo < ActiveRecord::Base
  
  self.table_name = 'sector_tipo'
  
  attr_accessible :id, 
    :nombre,
    :sector_economico_id
  
  has_many :actividad_economica
  belongs_to :sector_economico

  validates :nombre, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :length => { :in => 3..100, :allow_blank => false,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.nombre')}  #{I18n.t('errors.messages.too_long.other')}"},
    :uniqueness =>{:uniqueness => true, :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_registrado')}"}

  validates :nombre, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.sector_economico')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}


      
end

# == Schema Information
#
# Table name: sector_tipo
#
#  id                  :integer         not null, primary key
#  nombre              :string(100)     not null
#  sector_economico_id :integer         not null
#

