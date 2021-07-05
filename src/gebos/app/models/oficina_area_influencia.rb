# encoding: utf-8
class OficinaAreaInfluencia < ActiveRecord::Base

  self.table_name = 'oficina_area_influencia'
  
  attr_accessible  :id,
    :estado_id,
    :municipio_id,
    :parroquia_id,
    :oficina_id
  
  belongs_to :municipio
  belongs_to :estado
  belongs_to :parroquia
  belongs_to :oficina

  validates :estado_id, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.estado')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :municipio_id, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.municipio')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :parroquia_id, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.parroquia')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validate :oficina_bloque


  def oficina_bloque
    unless self.parroquia_id.nil?
      if self.new_record?
        total = OficinaAreaInfluencia.count(:conditions=>['parroquia_id = ? and oficina_id = ?', self.parroquia_id, self.oficina_id])
      else
        total = OficinaAreaInfluencia.count(:conditions=>['parroquia_id = ? and oficina_id = ? and id <> ?', self.parroquia_id, self.oficina_id, self.id])
      end
      if total > 0
        errors.add(:oficina_area_influencia, I18n.t('Sistema.Body.Modelos.OficinaAreaInfluencia.Errores.parroquia_ya_fue_registrada'))
      end
    end
  end
  
  
  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
             :conditions => search, :order => sort,
             :select=>'oficina_area_influencia.*',
             :include=>['municipio', 'parroquia']
  end
  
end

# == Schema Information
#
# Table name: oficina_area_influencia
#
#  id           :integer         not null, primary key
#  estado_id    :integer         not null
#  municipio_id :integer         not null
#  parroquia_id :integer         not null
#  oficina_id   :integer         not null
#

