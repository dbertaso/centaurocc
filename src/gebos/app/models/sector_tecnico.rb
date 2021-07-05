# encoding: utf-8
class SectorTecnico < ActiveRecord::Base
  
  self.table_name = 'sector_tecnico'
  
  attr_accessible  :id,
    :tecnico_campo_id,
    :sector_id

  belongs_to :tecnico_campo
  belongs_to :sector
  
  validates :sector_id, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.sector')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validate :valida_sector
  
  def valida_sector
    total = SectorTecnico.count(:conditions => ['sector_id = ? and tecnico_campo_id = ?', self.sector_id, self.tecnico_campo_id])
    if total > 0
      errors.add(:sector_tecnico, I18n.t('Sistema.Body.Modelos.SectorTecnico.Errores.sector_seleccionado'))
    end
  end
  
  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
      :conditions => search, :order => sort
  end
  
end




# == Schema Information
#
# Table name: sector_tecnico
#
#  id               :integer         not null, primary key
#  tecnico_campo_id :integer         not null
#  sector_id        :integer         not null
#

