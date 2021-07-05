# encoding: utf-8
class CultivoLaguna < ActiveRecord::Base

  self.table_name = 'cultivo_laguna'
  
  attr_accessible :id, 
    :numero_laguna,
    :espejo_agua,
    :cantidad_peces,
    :fecha_siembra,
    :fecha_cosecha,
    :peso_promedio,
    :kilo_cosechado,
    :coordenadas_utm,
    :solicitud_id,
    :seguimiento_visita_id

  
  belongs_to :solicitud
  
  
  
  validates :cantidad_peces, :numericality =>{:numericality => true, :only_integer =>true,
    :message => "#{I18n.t('Sistema.Body.Modelos.CultivoLaguna.Columnas.antidad_peces')} #{I18n.t('errors.messages.not_a_number')}"},
    :inclusion =>{:in=>1..100000000, :message => "#{I18n.t('Sistema.Body.Modelos.CultivoLaguna.Columnas.antidad_peces')} #{I18n.t('errors.messages.inclusion')}"}

  validates :peso_promedio, :numericality =>{:numericality => true, :only_integer =>true,
    :message => "#{I18n.t('Sistema.Body.Modelos.CultivoLaguna.Columnas.peso_promedio')} #{I18n.t('errors.messages.not_a_number')}"},
    :inclusion =>{:in=>1..1000000, :message => "#{I18n.t('Sistema.Body.Modelos.CultivoLaguna.Columnas.peso_promedio')} #{I18n.t('errors.messages.inclusion')}"}

  validates :numero_laguna, :length => { :in => 1..160, :allow_blank => false,
    :too_short => "#{I18n.t('Sistema.Body.Modelos.FaenasPesca.Columnas.numero_laguna')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Modelos.FaenasPesca.Columnas.numero_laguna')}  #{I18n.t('errors.messages.too_long.other')}"}

  validates :espejo_agua, :numericality =>{:numericality => true, :only_integer =>true,
    :message => "#{I18n.t('Sistema.Body.Modelos.CondicionesAcuicultura.Columnas.espejo_agua')} #{I18n.t('errors.messages.not_a_number')}"},
    :inclusion =>{:in=>1..1000000, :message => "#{I18n.t('Sistema.Body.Modelos.CondicionesAcuicultura.Columnas.espejo_agua')} #{I18n.t('errors.messages.inclusion')}"}

  validates :kilo_cosechado, :numericality =>{:numericality => true, :only_integer =>true,
    :message => "#{I18n.t('Sistema.Body.Modelos.CultivoLaguna.Columnas.kilo_cosechado')} #{I18n.t('errors.messages.not_a_number')}"},
    :inclusion =>{:in=>1..100000000, :message => "#{I18n.t('Sistema.Body.Modelos.CultivoLaguna.Columnas.kilo_cosechado')} #{I18n.t('errors.messages.inclusion')}"}

  #validacion  de los flotantes

  def espejo_agua_f=(valor)
    self.espejo_agua = format_valor(valor)
  end

  def espejo_agua_f
    format_f(self.espejo_agua)
  end

  def espejo_agua_fm
    format_fm(self.espejo_agua)
  end

  def peso_promedio_f=(valor)
    self.peso_promedio = format_valor(valor)
  end

  def peso_promedio_f
    format_f(self.peso_promedio)
  end

  def peso_promedio_fm
    format_fm(self.peso_promedio)
  end

  def kilo_cosechado_f=(valor)
    self.kilo_cosechado = format_valor(valor)
  end

  def kilo_cosechado_f
    format_f(self.kilo_cosechado)
  end

  def kilo_cosechado_fm
    format_fm(self.kilo_cosechado)
  end
  #validar fecha de siembra

  validates :fecha_siembra,
    :date => {:message =>"#{I18n.t('Sistema.Body.Modelos.SeguimientoCultivo.Columnas.fecha_siembra')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalida')}"}

  
  def fecha_siembra_f=(fecha)
    self.fecha_siembra = fecha
  end

  def fecha_siembra_f
    format_fecha(self.fecha_siembra)
  end  

  #validar fecha de cosecha
  validates :fecha_cosecha,
    :date => {:message =>"#{I18n.t('Sistema.Body.Modelos.SeguimientoCultivo.Columnas.fecha_estimada_cosecha')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalida')}"}

  def fecha_cosecha_f=(fecha)
    self.fecha_cosecha = fecha
  end

  def fecha_cosecha_f
    format_fecha(self.fecha_cosecha)
  end


  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
      :conditions => search, :order => sort, :select=>'*'
  end
  
  
end



# == Schema Information
#
# Table name: cultivo_laguna
#
#  id                    :integer         not null, primary key
#  numero_laguna         :string(20)
#  espejo_agua           :float
#  cantidad_peces        :integer
#  fecha_siembra         :date
#  fecha_cosecha         :date
#  peso_promedio         :float
#  kilo_cosechado        :float
#  coordenadas_utm       :string(80)
#  solicitud_id          :integer
#  seguimiento_visita_id :integer
#

