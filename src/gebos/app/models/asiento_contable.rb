# encoding: utf-8

#
# autor: Diego Bertaso
# clase: AsientoContable
# descripción: Migración a Rails 3
#

class AsientoContable < ActiveRecord::Base
  
  self.table_name = 'asiento_contable'
  
  attr_accessible :id,
                  :comprobante_contable_id,
                  :monto,
                  :tipo,
                  :codigo_contable,
                  :auxiliar_contable

  belongs_to :comprobante_contable
  belongs_to :cuenta_contable
  belongs_to :cuenta_contable_presupuesto

  validates :comprobante_contable, :presence => {:message => "#{I18n.t('Sistema.Body.Modelos.AsientoContable.Columnas.fecha_registro')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :cuenta_contable, :presence => {:message => "#{I18n.t('Sistema.Body.Modelos.AsientoContable.Columnas.fecha_registro')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :monto, :numericality => {:numericality => true,
    :message => "#{I18n.t('Sistema.Body.Modelos.AsientoContable.Columnas.monto')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_numerico')}"}
      
  def after_initialize
    self.monto = 0.0 unless self.monto
  end

  def monto_f=(valor)
    self.monto = valor.sub(',', '.')
  end
    
  def monto_f
    sprintf('%01.2f', self.monto).sub('.', ',') unless self.monto.nil?
  end
    
  def monto_fm
    unless self.monto.nil?
      valor = sprintf('%01.2f', self.monto).sub('.', ',')
      valor.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
    end
  end
  
  def debe_f
    monto = self.tipo == 'D' ? self.monto : 0.0
    sprintf('%01.2f', monto).sub('.', ',') unless monto.nil?
  end
    
  def debe_fm
    monto = self.tipo == 'D' ? self.monto : 0.0
    unless monto.nil?
      valor = sprintf('%01.2f', monto).sub('.', ',')
      valor.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
    end
  end
  
  def haber_f
    monto = self.tipo == 'H' ? monto : 0.0
    sprintf('%01.2f', monto).sub('.', ',') unless monto.nil?
  end
    
  def haber_fm
    monto = self.tipo == 'H' ? self.monto : 0.0
    unless monto.nil?
      valor = sprintf('%01.2f', monto).sub('.', ',')
      valor.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
    end
  end

  def auxiliar_banco

 
    entidad = EntidadFinanciera.find_by_auxiliar_contable(self.auxiliar_contable)
    
    if !entidad.nil?
    
      entidad.alias
    else
      nil
    end
    

  end

  def tipo_w
    case self.tipo
    when "D"
      return t('Sistema.Body.Vistas.AsientoContable.Etiquetas.debe')
    when "H"
      return t('Sistema.Body.Vistas.AsientoContable.Etiquetas.haber')
    end
  end

  def tipo_st
    case self.tipo
    when "D"
      return I18n.t('Sistema.Body.Vistas.AsientoContable.Etiquetas.debe')
    when "H"
      return I18n.t('Sistema.Body.Vistas.AsientoContable.Etiquetas.haber')
    end
  end
  
end

# == Schema Information
#
# Table name: asiento_contable
#
#  id                      :integer         not null, primary key
#  comprobante_contable_id :integer         not null
#  monto                   :float           not null
#  tipo                    :string(1)       not null
#  codigo_contable         :string(25)
#  auxiliar_contable       :string(20)
#

