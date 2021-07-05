# encoding: utf-8
#
# autor: Diego Bertaso
# clase: ConfiguracionAvance
# descripción: Migración a Rails 3
#

class ConfiguracionAvance < ActiveRecord::Base

  self.table_name = 'configuracion_avance'
  
  attr_accessible :id,
                  :estatus_origen_id,
                  :estatus_destino_id,
                  :condicionado,
                  :programa_id,
                  :ruta_primaria

  belongs_to :programa
  belongs_to :estatus_origen, :class_name=>'Estatus', :foreign_key =>'estatus_origen_id'
  belongs_to :estatus_destino, :class_name=>'Estatus', :foreign_key =>'estatus_destino_id'
  
  validates_presence_of :programa_id,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.programa')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"

  validates_presence_of :estatus_origen_id,
    :message => "#{I18n.t('Sistema.Body.Vistas.Form.estatus')} #{I18n.t('Sistema.Body.Vistas.General.origen')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"

  validates_presence_of :estatus_destino_id,
    :message => "#{I18n.t('Sistema.Body.Vistas.Form.estatus')} #{I18n.t('Sistema.Body.Vistas.Form.destino')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"

  #validates_presence_of :condicionado,
    #:message => "#{I18n.t('Sistema.Body.Vistas.General.condicionado')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"

  validates_presence_of :ruta_primaria,
    :message => "#{I18n.t('Sistema.Body.Modelos.ConfiguracionAvance.Columnas.ruta_primaria')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"

  def validate
    total = ConfiguracionAvance.count(:conditions=>['estatus_origen_id = ? and estatus_destino_id = ? and programa_id =? ', self.estatus_origen_id, self.estatus_destino_id, self.programa_id])
    if total > 0
      errors.add(:configuracion_avance, "La configuración ya se encuentra registrada en la base de datos.")
    elsif self.estatus_origen_id == self.estatus_destino_id
      errors.add(:configuracion_avance, "El estatus destino debe ser diferente al estatus origen.")
    end
  end

  after_initialize :after_initialize

  def self.search(search, page, sort)

    paginate :per_page => @records_by_page, :page => page,
             :conditions => search, :order => sort, :include => [:programa, :estatus_origen, :estatus_destino]
  end

  def after_initialize
    if new_record?
      self.accion = 'avanzar'
    end
  end 
  
  def origen
    estatus = Estatus.find(self.estatus_origen_id)
    estatus.nombre
  end

  def destino
    estatus = Estatus.find(self.estatus_destino_id)
    estatus.nombre
  end
 
end

# == Schema Information
#
# Table name: configuracion_avance
#
#  id                 :integer         not null, primary key
#  estatus_origen_id  :integer
#  estatus_destino_id :integer
#  condicionado       :boolean
#  programa_id        :integer         default(0), not null
#  ruta_primaria      :text
#  accion             :text            default("avanzar")
#

