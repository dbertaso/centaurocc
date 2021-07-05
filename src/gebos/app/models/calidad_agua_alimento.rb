# encoding: utf-8
class CalidadAguaAlimento < ActiveRecord::Base

  self.table_name = 'calidad_agua_alimento'
  
  attr_accessible :id, 
    :condiciones,
    :temperatura,
    :ph,
    :oxigeno_disuelto,
    :alimento_disponible,
    :consumo_diario,
    :dias_duracion,
    :solicitud_id,
    :seguimiento_visita_id

  
  belongs_to :solicitud


  validates :alimento_disponible, :length => { :in => 1..120, :allow_blank => false,
    :too_short => "#{I18n.t('Sistema.Body.Modelos.CalidadAguaAlimento.Columnas.alimento_disponible')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Modelos.CalidadAguaAlimento.Columnas.alimento_disponible')}  #{I18n.t('errors.messages.too_long.other')}"}

  validates :dias_duracion, :numericality =>{:numericality => true, :only_integer =>true,
    :message => "#{I18n.t('Sistema.Body.Modelos.CalidadAguaAlimento.Columnas.dias_duracion')} #{I18n.t('errors.messages.not_a_number')}"},
    :inclusion =>{:in=>1..1000, :message => "#{I18n.t('Sistema.Body.Modelos.CalidadAguaAlimento.Columnas.dias_duracion')} #{I18n.t('errors.messages.inclusion')}"}

  validates :consumo_diario, :numericality =>{:numericality => true,
    :message => "#{I18n.t('Sistema.Body.Modelos.CalidadAguaAlimento.Columnas.consumo_diario')} #{I18n.t('errors.messages.not_a_number')}"},
    :inclusion =>{:in=>1..1000000, :message => "#{I18n.t('Sistema.Body.Modelos.CalidadAguaAlimento.Columnas.consumo_diario')} #{I18n.t('errors.messages.inclusion')}"}

  validates :oxigeno_disuelto, :numericality =>{:numericality => true,
    :message => "#{I18n.t('Sistema.Body.Modelos.CalidadAguaAlimento.Columnas.oxigeno_disuelto')} #{I18n.t('errors.messages.not_a_number')}"},
    :inclusion =>{:in=>-100..100000, :message => "#{I18n.t('Sistema.Body.Modelos.CalidadAguaAlimento.Columnas.oxigeno_disuelto')} #{I18n.t('errors.messages.inclusion')}"}

  validates :temperatura, :numericality =>{:numericality => true,
    :message => "#{I18n.t('Sistema.Body.Modelos.CalidadAguaAlimento.Columnas.temperatura')} #{I18n.t('errors.messages.not_a_number')}"},
    :inclusion =>{:in=>-100..100, :message => "#{I18n.t('Sistema.Body.Modelos.CalidadAguaAlimento.Columnas.temperatura')} #{I18n.t('errors.messages.inclusion')}"}

  validates :ph, :numericality =>{:numericality => true,
    :message => "#{I18n.t('Sistema.Body.Modelos.CalidadAguaAlimento.Columnas.ph')} #{I18n.t('errors.messages.not_a_number')}"},
    :inclusion =>{:in=>0..14, :message => "#{I18n.t('Sistema.Body.Modelos.CalidadAguaAlimento.Columnas.ph')} #{I18n.t('errors.messages.inclusion')}"}


  def temperatura_f=(valor)
    self.temperatura = format_valor(valor)
  end

  def temperatura_f
    format_f(self.temperatura)
  end
  
  def temperatura_fm
    format_fm(self.temperatura)
  end
  
  def ph_f=(valor)
    self.ph = format_valor(valor)
  end

  def ph_f
    format_f(self.ph)
  end

  def ph_fm
    format_fm(self.ph)
  end
  
  def oxigeno_disuelto_f=(valor)
    self.oxigeno_disuelto = format_valor(valor)
  end

  def oxigeno_disuelto_f
    format_f(self.oxigeno_disuelto)
  end
  
  def oxigeno_disuelto_fm
    format_fm(self.oxigeno_disuelto)
  end

  def consumo_diario_f=(valor)
    self.consumo_diario = format_valor(valor)
  end

  def consumo_diario_f
    format_f(self.consumo_diario)
  end

  def consumo_diario_fm
    format_fm(self.consumo_diario)
  end


  
  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
      :conditions => search, :order => sort, :select=>'*'
  end
  
  
  
end




# == Schema Information
#
# Table name: calidad_agua_alimento
#
#  id                    :integer         not null, primary key
#  condiciones           :string(50)
#  temperatura           :float
#  ph                    :float
#  oxigeno_disuelto      :float
#  alimento_disponible   :string(120)
#  consumo_diario        :float
#  dias_duracion         :integer
#  solicitud_id          :integer
#  seguimiento_visita_id :integer
#

