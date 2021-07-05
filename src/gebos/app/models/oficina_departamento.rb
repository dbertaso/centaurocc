# encoding: utf-8
class OficinaDepartamento < ActiveRecord::Base

  self.table_name = 'oficina_departamento'
  
  attr_accessible  :id,
    :oficina_id,
    :departamento_id
  
  belongs_to :oficina
  belongs_to :departamento

  # ASI ESTABAN ANTES DE YO MODIFICARLO (ROBERT)
  #  validates :departamento, :presence => {
  #    :message => "#{I18n.t('Sistema.Body.Vistas.Filtros.oficina')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  #    
  #  validates :oficina, :presence => {
  #    :message => "#{I18n.t('Sistema.Body.Vistas.Filtros.oficina')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :departamento_id, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.oficina')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
      
  validates :oficina_id, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.oficina')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates_uniqueness_of :departamento_id, :scope=>'oficina_id',
    :message => "#{I18n.t('Sistema.Body.Vistas.General.departamento')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"

  def before_destroy
    valid = true
    if Estacion.find_by_oficina_departamento_id(id)
      errors.add(:oficina_departamento, I18n.t('Sistema.Body.Modelos.OficinaDepartamento.Errores.oficina_departamento_no_puede_eliminarse'))
      valid = false
    end
    valid
  end

end

# == Schema Information
#
# Table name: oficina_departamento
#
#  id              :integer         not null, primary key
#  oficina_id      :integer         not null
#  departamento_id :integer         not null
#

