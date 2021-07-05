#encding: utf-8
class CondicionesAcuicultura < ActiveRecord::Base

  self.table_name = 'condiciones_acuicultura'
  
  attr_accessible :id, 
    :tipo_especie_id,
    :solicitud_id,
    :calidad_agua_id,
    :espejo_agua,
    :espejo_agua_up,
    :espejo_agua_produccion,
    :duracion_ciclo,
    :lagunas_efectivas,
    :lagunas_totales,
    :peso_cosecha,
    :densidad_siembra,
    :seguimiento_visita_id

  belongs_to :solicitud
  belongs_to :calidad_agua_alimento
  belongs_to :tipo_especie_acuicultura

  
  
  validates :tipo_especie_id, :presence =>{
    :message => "#{I18n.t('Sistema.Body.Modelos.FaenasPesca.Columnas.tipo_especie_id')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :lagunas_efectivas, :numericality =>{:numericality => true, :only_integer =>true,
    :message => "#{I18n.t('Sistema.Body.Modelos.CondicionesAcuicultura.Columnas.lagunas_efectivas')} #{I18n.t('errors.messages.not_a_number')}"},
    :inclusion =>{:in=>0..100, :message => "#{I18n.t('Sistema.Body.Modelos.CondicionesAcuicultura.Columnas.lagunas_efectivas')} #{I18n.t('errors.messages.inclusion')}"}

  validates :espejo_agua, :numericality =>{:numericality => true, :only_integer =>true,
    :message => "#{I18n.t('Sistema.Body.Modelos.CondicionesAcuicultura.Columnas.espejo_agua')} #{I18n.t('errors.messages.not_a_number')}"},
    :inclusion =>{:in=>1..1000000, :message => "#{I18n.t('Sistema.Body.Modelos.CondicionesAcuicultura.Columnas.espejo_agua')} #{I18n.t('errors.messages.inclusion')}"}

  validates :espejo_agua_up, :numericality =>{:numericality => true, :only_integer =>true,
    :message => "#{I18n.t('Sistema.Body.Modelos.CondicionesAcuicultura.Columnas.espejo_agua_up')} #{I18n.t('errors.messages.not_a_number')}"},
    :inclusion =>{:in=>1..1000000, :message => "#{I18n.t('Sistema.Body.Modelos.CondicionesAcuicultura.Columnas.espejo_agua_up')} #{I18n.t('errors.messages.inclusion')}"}

  validates :espejo_agua_produccion, :numericality =>{:numericality => true, :only_integer =>true,
    :message => "#{I18n.t('Sistema.Body.Modelos.CondicionesAcuicultura.Columnas.espejo_agua_produccion')} #{I18n.t('errors.messages.not_a_number')}"},
    :inclusion =>{:in=>1..1000000, :message => "#{I18n.t('Sistema.Body.Modelos.CondicionesAcuicultura.Columnas.espejo_agua_produccion')} #{I18n.t('errors.messages.inclusion')}"}

  validates :duracion_ciclo, :numericality =>{:numericality => true, :only_integer =>true,
    :message => "#{I18n.t('Sistema.Body.Modelos.CondicionesAcuicultura.Columnas.duracion_ciclo')} #{I18n.t('errors.messages.not_a_number')}"},
    :inclusion =>{:in=>1..999, :message => "#{I18n.t('Sistema.Body.Modelos.CondicionesAcuicultura.Columnas.duracion_ciclo')} #{I18n.t('errors.messages.inclusion')}"}

  validates :peso_cosecha, :numericality =>{:numericality => true, :only_integer =>true,
    :message => "#{I18n.t('Sistema.Body.Modelos.CondicionesAcuicultura.Columnas.peso_cosecha')} #{I18n.t('errors.messages.not_a_number')}"},
    :inclusion =>{:in=>1..1000000, :message => "#{I18n.t('Sistema.Body.Modelos.CondicionesAcuicultura.Columnas.peso_cosecha')} #{I18n.t('errors.messages.inclusion')}"}

  validates :densidad_siembra, :numericality =>{:numericality => true, :only_integer =>true,
    :message => "#{I18n.t('Sistema.Body.Modelos.CondicionesAcuicultura.Columnas.densidad_siembra')} #{I18n.t('errors.messages.not_a_number')}"},
    :inclusion =>{:in=>1..1000000, :message => "#{I18n.t('Sistema.Body.Modelos.CondicionesAcuicultura.Columnas.densidad_siembra')} #{I18n.t('errors.messages.inclusion')}"}

  validates :lagunas_totales, :numericality =>{:numericality => true, :only_integer =>true,
    :message => "#{I18n.t('Sistema.Body.Modelos.CondicionesAcuicultura.Columnas.lagunas_totales')} #{I18n.t('errors.messages.not_a_number')}"},
    :inclusion =>{:in=>1..100, :message => "#{I18n.t('Sistema.Body.Modelos.CondicionesAcuicultura.Columnas.lagunas_totales')} #{I18n.t('errors.messages.inclusion')}"}


  def espejo_agua_f=(valor)
    self.espejo_agua = format_valor(valor)
  end

  def espejo_agua_f
    format_f(self.espejo_agua)
  end

  def espejo_agua_fm
    format_fm(self.espejo_agua)
  end

  def espejo_agua_up_f=(valor)
    self.espejo_agua_up = format_valor(valor)
  end

  def espejo_agua_up_f
    format_f(self.espejo_agua_up)
  end

  def espejo_agua_up_fm
    format_fm(self.espejo_agua_up)
  end

  def espejo_agua_produccion_f=(valor)
    self.espejo_agua_produccion = format_valor(valor)
  end

  def espejo_agua_produccion_f
    format_f(self.espejo_agua_produccion)
  end

  def espejo_agua_produccion_fm
    format_fm(self.espejo_agua_produccion)
  end

  def peso_cosecha_f=(valor)  
    self.peso_cosecha = format_valor(valor)
  end

  def peso_cosecha_f
    format_f(self.peso_cosecha)
  end

  def peso_cosecha_fm
    format_fm(self.peso_cosecha)
  end

  def densidad_siembra_f=(valor)  
    self.densidad_siembra = format_valor(valor)
  end

  def densidad_siembra_f
    format_f(self.densidad_siembra)
  end

  def densidad_siembra_fm
    format_fm(self.densidad_siembra)
  end

  
  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
      :conditions => search, :order => sort, :select=>'*'
  end
  
  

end



# == Schema Information
#
# Table name: condiciones_acuicultura
#
#  id                     :integer         not null, primary key
#  tipo_especie_id        :integer
#  solicitud_id           :integer
#  calidad_agua_id        :integer
#  espejo_agua            :float
#  espejo_agua_up         :float
#  espejo_agua_produccion :float
#  duracion_ciclo         :integer
#  lagunas_efectivas      :integer
#  lagunas_totales        :integer
#  peso_cosecha           :float
#  densidad_siembra       :float
#  seguimiento_visita_id  :integer
#

