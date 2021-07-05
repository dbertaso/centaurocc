# encoding: utf-8

#
# autor: Luis Rojas
# clase: UnidadProduccionMaquinaria
# descripción: Migración a Rails 3
#
class UnidadProduccionMaquinaria < ActiveRecord::Base

  self.table_name = 'unidad_produccion_maquinaria'
  
  attr_accessible :id,
    :solicitud_id,
    :unidad_produccion_id,
    :seguimiento_visita_id,
    :descripcion_item,
    :cantidad,
    :marca,
    :modelo,
    :anio,
    :condicion,
    :tipo_tenencia,
    :serial,
    :nro_chasis,
    :clase,
    :clase_id 

  belongs_to :solicitud
  belongs_to :unidad_produccion
  belongs_to :seguimiento_visita
  #belongs_to :clase, :class_name=>'Clase', :foreign_key =>'clase_id'
  

  validates  :clase_id,
    :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.clase')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates  :clase,
    :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.tipo')} #{I18n.t('Sistema.Body.Vistas.General.maquinaria')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates  :anio,
    :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.año')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}",
    :numericality => {:message => "#{I18n.t('Sistema.Body.Vistas.General.año')} #{I18n.t('Sistema.Body.Modelos.Errores.monto_invalido')}", :allow_blank => true } }
    
  validates  :cantidad,
    :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.cantidad')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}",
    :numericality => {:message => "#{I18n.t('Sistema.Body.Vistas.General.cantidad')} #{I18n.t('Sistema.Body.Modelos.Errores.monto_invalido')}", :allow_blank => true } }
    
  validates  :modelo,
    :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.modelo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}  

  validates  :marca,
    :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.marca')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates  :condicion,
    :presence => { :message => "#{I18n.t('Sistema.Body.Modelos.Embarcacion.Columnas.condicion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
      
  validates  :tipo_tenencia,
    :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.tipo')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.tenencia')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  def condicion_nombre
    case self.condicion
    when 'E'
      I18n.t('Sistema.Body.Vistas.General.excelente')
    when 'B'
      I18n.t('Sistema.Body.Vistas.General.buena')
    when 'R'
      I18n.t('Sistema.Body.Vistas.General.regular')
    when 'M'
      I18n.t('Sistema.Body.Vistas.General.mala')
    end
  end
  
  def  tenencia_nombre
    case self.tipo_tenencia
    when 'PR'
      I18n.t('Sistema.Body.Vistas.General.propia')
    when 'AQ'
      I18n.t('Sistema.Body.Vistas.General.alquilada')
    when 'FI'
      I18n.t('Sistema.Body.Vistas.General.financiada')
    when 'AD'
      I18n.t('Sistema.Body.Vistas.General.adjudicada')
    end
  end
  
  def self.search(search, page, orden)
    paginate :per_page=>@records_by_page, :page=>page, :conditions=>search, :order=>orden
  end
end



# == Schema Information
#
# Table name: unidad_produccion_maquinaria
#
#  id                    :integer         not null, primary key
#  solicitud_id          :integer         not null
#  unidad_produccion_id  :integer         not null
#  seguimiento_visita_id :integer         not null
#  clase                 :text            not null
#  descripcion_item      :text            not null
#  cantidad              :text            not null
#  marca                 :text            not null
#  modelo                :text            not null
#  anio                  :integer         not null
#  condicion             :text            not null
#  tipo_tenencia         :text            not null
#  serial                :string(50)
#  nro_chasis            :string(50)
#  clase_id              :integer
#

