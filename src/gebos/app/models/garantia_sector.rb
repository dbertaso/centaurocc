# encoding: utf-8

#
# autor: Diego Bertaso
# clase: GarantiaSector
# descripción: Migración a Rails 3
#

class GarantiaSector < ActiveRecord::Base

  self.table_name = 'garantia_sector'
  
  attr_accessible :id,
                  :sub_sector_id,
                  :tipo_garantia_id,
                  :garantia
                  
  belongs_to :sub_sector
  belongs_to :tipo_garantia
  
  validates_presence_of :sub_sector_id,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.sub_sector')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"
    
  validates_presence_of :tipo_garantia_id,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.tipo_garantia')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerida')}"
  
  validates :sub_sector_id, :uniqueness => { :scope => [:tipo_garantia_id],
    :message => "#{I18n.t('Sistema.Body.Modelos.GarantiaSector.Columnas.tipo_garantia')} #{I18n.t('Sistema.Body.Modelos.GarantiaSector.Errores.ya_asignado_sector_productivo')}" }

  def self.search(search, page, sort)

    unless search.nil?
      paginate  :per_page => @records_by_page, :page => page,
                :conditions => search, :order => sort
    else
      paginate  :per_page => @records_by_page, :page => page,
                :order => sort

    end
    
  end

  def garantia
    tipo_garantia = TipoGarantia.find(self.tipo_garantia_id)
    garantia = tipo_garantia.nombre.to_s
    return garantia
  end

end

# == Schema Information
#
# Table name: garantia_sector
#
#  id               :integer         not null, primary key
#  sub_sector_id    :integer         not null
#  tipo_garantia_id :integer         not null
#

