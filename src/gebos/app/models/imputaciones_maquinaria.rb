# encoding: utf-8

#
# autor: Diego Bertaso
# clase: ImputacionesMaquinaria
# descripción: Migración a Rails 3
#
class ImputacionesMaquinaria < ActiveRecord::Base
  
  self.table_name = 'imputaciones_maquinaria'
  
  attr_accessible :id, 
                  :fecha_registro, 
                  :seguro_nacional, 
                  :flete_nacional, 
                  :gastos_administrativos, 
                  :seguro_internacional, 
                  :flete_internacional,
                  :nacionalizacion_impuestos, 
                  :almacenamiento, 
                  :observacion

  validate :validate
  
  validates_presence_of :seguro_nacional, 
    :message => "#{I18n.t('Sistema.Body.Modelos.ImputacionesMaquinaria.Columnas.seguro_nacional')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"
 
  validates_presence_of :flete_nacional,
    :message => "#{I18n.t('Sistema.Body.Modelos.ImputacionesMaquinaria.Columnas.flete_nacional')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"
    
  validates_presence_of :gastos_administrativos,
    :message => "#{I18n.t('Sistema.Body.Modelos.ImputacionesMaquinaria.Columnas.gastos_administrativos')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"
  
  validates_presence_of :seguro_internacional,
    :message => "#{I18n.t('Sistema.Body.Modelos.ImputacionesMaquinaria.Columnas.seguro_internacional')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"

  validates_presence_of :flete_internacional, 
    :message => "#{I18n.t('Sistema.Body.Modelos.ImputacionesMaquinaria.Columnas.flete_internacional')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"

  validates_presence_of :nacionalizacion_impuestos,
    :message => "#{I18n.t('Sistema.Body.Modelos.ImputacionesMaquinaria.Columnas.nacionalizacion_impuestos')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"

  validates_presence_of :almacenamiento, 
    :message => "#{I18n.t('Sistema.Body.Modelos.ImputacionesMaquinaria.Columnas.almacenamiento')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"
    
  validates_presence_of :observacion,
    :message => "#{I18n.t('Sistema.Body.Modelos.ImputacionesMaquinaria.Columnas.observacion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"

  validates_presence_of :fecha_registro,
    :message => "#{I18n.t('Sistema.Body.Modelos.ImputacionesMaquinaria.Columnas.observacion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"
    
  validate :validate  
  def validate
    unless self.seguro_nacional.nil? and self.flete_nacional.nil? and self.gastos_administrativos.nil? and self.seguro_internacional.nil?
        self.flete_internacional.nil? and self.nacionalizacion_impuestos.nil? and self.almacenamiento.nil?
     
      unless self.seguro_nacional > 0 and self.seguro_nacional < 100
        errors.add(:imputaciones_maquinaria, "#{I18n.t('Sistema.Body.Modelos.ImputacionesMaquinaria.Columnas.seguro_nacional')}: #{I18n.t('Sistema.Body.Modelos.Errores.porcentaje_invalido')}")
      end
      unless self.flete_nacional > 0 and self.flete_nacional < 100
        errors.add(:imputaciones_maquinaria, "#{I18n.t('Sistema.Body.Modelos.ImputacionesMaquinaria.Columnas.flete_nacional')}: #{I18n.t('Sistema.Body.Modelos.Errores.porcentaje_invalido')}")
      end
      unless self.gastos_administrativos > 0 and self.gastos_administrativos < 100
        errors.add(:imputaciones_maquinaria, "#{I18n.t('Sistema.Body.Modelos.ImputacionesMaquinaria.Columnas.gastos_administrativos')}: #{I18n.t('Sistema.Body.Modelos.Errores.porcentaje_invalido')}")
      end
      unless self.seguro_internacional > 0 and self.seguro_internacional < 100
        errors.add(:imputaciones_maquinaria, "#{I18n.t('Sistema.Body.Modelos.ImputacionesMaquinaria.Columnas.seguro_internacional')}: #{I18n.t('Sistema.Body.Modelos.Errores.porcentaje_invalido')}")
      end
      unless self.flete_internacional > 0 and self.flete_internacional < 100
        errors.add(:imputaciones_maquinaria, "#{I18n.t('Sistema.Body.Modelos.ImputacionesMaquinaria.Columnas.flete_internacional')}: #{I18n.t('Sistema.Body.Modelos.Errores.porcentaje_invalido')}")
      end
      unless self.nacionalizacion_impuestos > 0 and self.nacionalizacion_impuestos < 100
        errors.add(:imputaciones_maquinaria, "#{I18n.t('Sistema.Body.Modelos.ImputacionesMaquinaria.Columnas.nacionalizacion_impuestos')}: #{I18n.t('Sistema.Body.Modelos.Errores.porcentaje_invalido')}")
      end
      unless (self.almacenamiento > 0 and self.almacenamiento < 100)
        errors.add(:imputaciones_maquinaria, "#{I18n.t('Sistema.Body.Modelos.ImputacionesMaquinaria.Columnas.almacenamiento')}: #{I18n.t('Sistema.Body.Modelos.Errores.porcentaje_invalido')}")
      end
    end
  end

  def self.search(search, page, sort)

    unless search.nil?
      paginate  :per_page => @records_by_page, :page => page,
                :conditions => search, :order => sort
    else
      paginate  :per_page => @records_by_page, :page => page,
                :order => sort

    end
    
  end
   
  def fecha_registro_f
    format_fecha(self.fecha_registro)    
  end
  
  def seguro_nacional_fm
    unless self.seguro_nacional.nil?
      format_fm(self.seguro_nacional)      
    end
  end 

  def flete_nacional_fm
    unless self.flete_nacional.nil?
      format_fm(self.flete_nacional)      
    end
  end 

  def gastos_administrativos_fm
    unless self.gastos_administrativos.nil?
      format_fm(self.gastos_administrativos)      
    end
  end 
 
  def seguro_internacional_fm
    unless self.seguro_internacional.nil?
      format_fm(self.seguro_internacional)
    end
  end 

  def flete_internacional_fm
    unless self.flete_internacional.nil?
      format_fm(self.flete_internacional)
    end
  end 

  def nacionalizacion_impuestos_fm
    unless self.nacionalizacion_impuestos.nil?
      format_fm(self.nacionalizacion_impuestos)
    end
  end 

  def almacenamiento_fm
    unless self.almacenamiento.nil?
      format_fm(self.almacenamiento)
    end
  end 
            
end

# == Schema Information
#
# Table name: imputaciones_maquinaria
#
#  id                        :integer         not null, primary key
#  fecha_registro            :date
#  seguro_nacional           :float           not null
#  flete_nacional            :float           not null
#  gastos_administrativos    :float           not null
#  seguro_internacional      :float           not null
#  flete_internacional       :float           not null
#  nacionalizacion_impuestos :float           not null
#  almacenamiento            :float           not null
#  observacion               :text            not null
#  indicador                 :string(1)
#

