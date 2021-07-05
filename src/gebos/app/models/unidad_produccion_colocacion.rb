# encoding: utf-8

class UnidadProduccionColocacion < ActiveRecord::Base

  self.table_name = 'unidad_produccion_colocacion'

  attr_accessible :id,
    :solicitud_id,
    :unidad_produccion_id,
    :seguimiento_visita_id,
    :sitio_colocacion_id,
    :ubicacion

  belongs_to :solicitud
  belongs_to :unidad_produccion
  belongs_to :seguimiento_visita
  belongs_to :sitio_colocacion

  validates :sitio_colocacion_id, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.SitioColocacion.Etiquetas.sitio')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :ubicacion, #:presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.ubicacion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :numericality =>{:numericality => true, :only_integer => false, :allow_blank => true, :message => "#{I18n.t('Sistema.Body.Vistas.General.ubicacion')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}"}
    
  validate :validacion
  
  def validacion
    unless self.sitio_colocacion_id.blank?
      unless self.sitio_colocacion.sitio == 'Autoconsumo'
        if self.ubicacion.blank?
          errors.add(:unidad_produccion_colocacion, "#{I18n.t('Sistema.Body.Vistas.General.ubicacion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
        end
      end
    end
  end

  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
      :conditions => search, :order => sort
  end
end

# == Schema Information
#
# Table name: unidad_produccion_colocacion
#
#  id                    :integer         not null, primary key
#  solicitud_id          :integer
#  unidad_produccion_id  :integer
#  seguimiento_visita_id :integer
#  sitio_colocacion_id   :integer
#  ubicacion             :text
#

