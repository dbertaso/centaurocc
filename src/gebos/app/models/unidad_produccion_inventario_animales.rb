# encoding: utf-8

#
# autor: Luis Rojas
# clase: UnidadProduccionInventarioAnimales
# descripción: Migración a Rails 3
#
class UnidadProduccionInventarioAnimales < ActiveRecord::Base
  
  self.table_name = 'unidad_produccion_inventario_animales'
  
  attr_accessible :id, :solicitud_id, :unidad_produccion_id, :seguimiento_visita_id,
    :cantidad_bovinos, :cantidad_bufalinos, :cantidad_equinos, :cantidad_porcinos,
    :cantidad_caprinos, :cantidad_aves, :cantidad_ovinos, :cantidad_piscicolas,
    :cantidad_otros, :observaciones

  belongs_to :solicitud
  belongs_to :unidad_produccion
  belongs_to :seguimiento_visita
  
  
  validates :cantidad_bovinos, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.cantidad')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.bovinos')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}, 
    :numericality =>{:numericality => true, :message => "#{I18n.t('Sistema.Body.Vistas.General.cantidad')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.bovinos')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}", :allow_blank => true}

  validates :cantidad_bufalinos, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.cantidad')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.bufalinos')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}, 
    :numericality =>{:numericality => true, :message => "#{I18n.t('Sistema.Body.Vistas.General.cantidad')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.bufalinos')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}", :allow_blank => true}

  validates :cantidad_equinos, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.cantidad')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.equinos')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}, 
    :numericality =>{:numericality => true, :message => "#{I18n.t('Sistema.Body.Vistas.General.cantidad')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.equinos')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}", :allow_blank => true}  

  validates :cantidad_porcinos, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.cantidad')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.porcinos')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}, 
    :numericality =>{:numericality => true, :message => "#{I18n.t('Sistema.Body.Vistas.General.cantidad')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.porcinos')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}", :allow_blank => true}

  validates :cantidad_caprinos, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.cantidad')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.caprinos')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}, 
    :numericality =>{:numericality => true, :message => "#{I18n.t('Sistema.Body.Vistas.General.cantidad')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.caprinos')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}", :allow_blank => true}
  
  validates :cantidad_aves, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.cantidad')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.aves')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}, 
    :numericality =>{:numericality => true, :message => "#{I18n.t('Sistema.Body.Vistas.General.cantidad')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.aves')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}", :allow_blank => true}
  
  validates :cantidad_ovinos, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.cantidad')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.ovinos')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}, 
    :numericality =>{:numericality => true, :message => "#{I18n.t('Sistema.Body.Vistas.General.cantidad')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.ovinos')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}", :allow_blank => true}
  
  validates :cantidad_piscicolas, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.cantidad')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.piscicolas')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}, 
    :numericality =>{:numericality => true, :message => "#{I18n.t('Sistema.Body.Vistas.General.cantidad')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.piscicolas')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}", :allow_blank => true}
  
  validates :cantidad_otros, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.cantidad')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.otros')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}, 
    :numericality =>{:numericality => true, :message => "#{I18n.t('Sistema.Body.Vistas.General.cantidad')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.otros')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}", :allow_blank => true}

end

# == Schema Information
#
# Table name: unidad_produccion_inventario_animales
#
#  id                    :integer         not null, primary key
#  solicitud_id          :integer         not null
#  unidad_produccion_id  :integer         not null
#  seguimiento_visita_id :integer         not null
#  cantidad_bovinos      :integer
#  cantidad_bufalinos    :integer
#  cantidad_equinos      :integer
#  cantidad_porcinos     :integer
#  cantidad_caprinos     :integer
#  cantidad_aves         :integer
#  cantidad_ovinos       :integer
#  cantidad_piscicolas   :integer
#  cantidad_otros        :integer
#  observaciones         :text
#

