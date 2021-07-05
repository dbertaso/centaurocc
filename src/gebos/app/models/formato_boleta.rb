# encoding: utf-8
class FormatoBoleta < ActiveRecord::Base

  self.table_name = 'formato_boleta'
  
  attr_accessible :id,
    :usuario_id,
    :status,
    :sector_id,
    :sub_sector_id,
    :rubro_id,
    :sub_rubro_id,
    :actividad_id,
    :formato_operacion 
  
  belongs_to :sector
  belongs_to :sub_sector
  belongs_to :rubro
  belongs_to :sub_rubro
  belongs_to :actividad
  
  
  validates :actividad_id, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.Form.actividad')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :uniqueness => {:message => "#{I18n.t('Sistema.Body.Vistas.Form.actividad')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"}
    
  validate :block_validate
  
  def block_validate
    unless self.formato_operacion.nil? || self.formato_operacion.empty?
      a = self.formato_operacion[/#{I18n.t('Sistema.Body.ExpresionesRegulares.validar_formato_boleta')}/]
      if a.nil?
        errors.add(:formato_boleta, I18n.t('Sistema.Body.Modelos.FormatoBoleta.Errores.formato_de_boleta_invalido'))
      end
    end
  end
  
def self.search(page, sort)
    paginate :per_page => @records_by_page, :page => page,
       :order => sort, :include => [:actividad, :sub_rubro, :rubro, :sub_sector, :sector],
      :select=>'formato_boleta.id, formato_boleta.status, formato_boleta.formato_operacion, formato_boleta.sub_rubro_id, 
      formato_boleta.rubro_id, formato_boleta.sub_sector_id, formato_boleta.sector_id, actividad.nombre as actividad, sub_rubro.nombre as sub_rubro, 
      rubro.nombre as rubro, sub_sector.nombre as sub_sector, sector.nombre as sector'
  end

  
end

# == Schema Information
#
# Table name: formato_boleta
#
#  id                :integer         not null, primary key
#  usuario_id        :integer         not null
#  status            :boolean
#  sector_id         :integer
#  sub_sector_id     :integer
#  rubro_id          :integer
#  sub_rubro_id      :integer
#  actividad_id      :integer
#  formato_operacion :string(200)
#

