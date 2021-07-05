# encoding: utf-8

#
# autor: Diego Bertaso
# clase: AcumuladoAgrupacionIndustrial
# descripción: Migración a Rails 3
#

class AcumuladoAgrupacionIndustrial < ActiveRecord::Base

  self.table_name = 'acumulado_agrupacion_industrial'
  
  belongs_to :agrupacion_industrial
  
  validates_numericality_of :anio, :only_integer=>true,
    :message => I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')
    
  validates_numericality_of :mes, :only_integer=>true,
    :message => I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')
    
  validates_numericality_of :trimestre, :only_integer=>true,
    :message => I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')
    
  validates_numericality_of :semestre, :only_integer=>true,
    :message => I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')
    
  validates_numericality_of :creditos_realizados, :only_integer=>true,
    :message => I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')
    
  validates_numericality_of :creditos_aprobados, :only_integer=>true,
    :message => I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')
    
  validates_numericality_of :creditos_diferidos, :only_integer=>true,
    :message => I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')
    
  validates_numericality_of :creditos_rechazados, :only_integer=>true,
    :message => I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')
    
  validates_numericality_of :monto_liquidado,
    :message => I18n.t('Sistema.Body.Modelos.Errores.monto_invalido')
    
    
  def after_initialize
    
    self.anio = 0 unless self.anio
    self.mes = 0 unless self.mes
    self.trimestre = 0 unless self.trimestre
    self.semestre = 0 unless self.semestre
    self.creditos_realizados = 0 unless self.creditos_realizados
    self.creditos_aprobados = 0 unless self.creditos_aprobados
    self.creditos_diferidos = 0 unless self.creditos_diferidos
    self.creditos_rechazados = 0 unless self.creditos_rechazados
    self.monto_liquidado = 0 unless self.monto_liquidado
    
  end
    
  def monto_liquidado_fm
    unless @monto_liquidado.nil?
      valor = sprintf('%01.2f', @monto_liquidado).sub('.', ',')
      valor.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
    end
  end
  
  def monto_liquidado_fm=(valor)
    @monto_liquidado = valor.sub(',', '.')
  end

end



# == Schema Information
#
# Table name: acumulado_agrupacion_industrial
#
#  id                       :integer         not null
#  anio                     :integer         default(0), not null
#  mes                      :integer         default(0), not null
#  trimestre                :integer         default(0), not null
#  semestre                 :integer         default(0), not null
#  agrupacion_industrial_id :integer         not null
#  creditos_realizados      :integer         default(0), not null
#  creditos_aprobados       :integer         default(0), not null
#  creditos_diferidos       :integer         default(0), not null
#  creditos_rechazados      :integer         default(0), not null
#  monto_liquidado          :float           default(0.0), not null
#

