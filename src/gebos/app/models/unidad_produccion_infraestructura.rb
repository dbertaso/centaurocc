# encoding: utf-8

#
# autor: Luis Rojas
# clase: UnidadProduccionInfraestructura
# descripción: Migración a Rails 3
#
class UnidadProduccionInfraestructura < ActiveRecord::Base

  self.table_name = 'unidad_produccion_infraestructura'
  
  attr_accessible :id,
    :solicitud_id,
    :unidad_produccion_id,
    :seguimiento_visita_id,
    :tipo_infraestructura_id,
    :cantidad,
    :dimension,
    :unidad_medida_id,
    :material_construccion,
    :observaciones,
    :condicion

  belongs_to :solicitud
  belongs_to :unidad_produccion
  belongs_to :seguimiento_visita
  belongs_to :tipo_infraestructura
  belongs_to :unidad_medida

  validates  :condicion,
    :presence => { :message => "#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Errores.Confirmar.condiciones')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates  :cantidad,
    :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.cantidad')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}",
    :numericality => {:message => "#{I18n.t('Sistema.Body.Vistas.General.cantidad')} #{I18n.t('Sistema.Body.Modelos.Errores.monto_invalido')}", :allow_blank => true } }

  validates  :cantidad,
    :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.dimension')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}",
    :numericality => {:message => "#{I18n.t('Sistema.Body.Vistas.General.dimension')} #{I18n.t('Sistema.Body.Modelos.Errores.monto_invalido')}", :allow_blank => true } }
    
  validates  :material_construccion,
    :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.material_construccion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates  :observaciones,
    :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.observaciones')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
    
    
  def cantidad_fm
    unless @cantidad.nil?
      valor = sprintf('%01.2f', @cantidad).sub('.', ',')
      valor.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
    end
  end
    
  def dimension_fm
    unless @dimension.nil?
      valor = sprintf('%01.2f', @dimension).sub('.', ',')
      valor.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
    end
  end
    
  def self.search(search, page, orden)
    paginate :per_page=>@records_by_page, :page=>page, :conditions=>search, :order=>orden
  end
end

# == Schema Information
#
# Table name: unidad_produccion_infraestructura
#
#  id                      :integer         not null, primary key
#  solicitud_id            :integer
#  unidad_produccion_id    :integer
#  seguimiento_visita_id   :integer
#  tipo_infraestructura_id :integer
#  cantidad                :float           not null
#  dimension               :float
#  unidad_medida_id        :integer
#  material_construccion   :text
#  observaciones           :text
#  condicion               :text
#

