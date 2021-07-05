# encoding: utf-8
# autor: Diego Bertaso
# clase: ProgramaTipoGasto
# descripción: Migración a Rails 3
class ProgramaTipoGasto < ActiveRecord::Base

  self.table_name = 'programa_tipo_gasto'

  attr_accessible :id,
    :tipo_gasto_id,
    :programa_id,
    :porcentaje,
    :monto_fijo,
    :forma_cobro,
    :monto_fijo_f,
    :porcentaje_f


  belongs_to :programa
  belongs_to :tipo_gasto

  validates :programa,
    :presence => { :message => "#{I18n.t('Sistema.Body.Modelos.ProgramaTipoGasto.Columnas.programa')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :tipo_gasto,
    :presence => { :message => "#{I18n.t('Sistema.Body.Modelos.ProgramaTipoGasto.Columnas.tipo_gasto')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  #  validates :porcentaje,
  #  :presence => {:message => "#{I18n.t('Sistema.Body.Modelos.ProgramaTipoGasto.Columnas.porcentaje')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates_uniqueness_of :programa_id,
    :scope => [:tipo_gasto_id],
    :message => "#{I18n.t('Sistema.Body.Modelos.ProgramaTipoGasto.Columnas.programa')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"

  validates_numericality_of :monto_fijo, :allow_blank => true,
    :message => "#{I18n.t('Sistema.Body.Modelos.ProgramaTipoGasto.Columnas.monto_fijo')} #{I18n.t('errors.messages.not_a_number')}"

  validates_numericality_of :porcentaje, :allow_blank => true,
    :message => "#{I18n.t('Sistema.Body.Modelos.ProgramaTipoGasto.Columnas.porcentaje')} #{I18n.t('errors.messages.not_a_number')}"

  
  def self.search(search, page, sort)
    joins = 'INNER JOIN tipo_gasto ON programa_tipo_gasto.tipo_gasto_id = tipo_gasto.id'
    unless search.nil?
      paginate  :per_page => @records_by_page, :page => page,
        :conditions => search, :order => sort, :joins=>joins
    else
      paginate  :per_page => @records_by_page, :page => page,
        :order => sort, :joins=>joins
    end
  end
  


  #  after_initialize :after_initialize
  
  def after_initialize
    self.monto_fijo = 0 unless self.monto_fijo
    self.porcentaje = 0 unless self.porcentaje
  end

  def monto_fijo_f=(valor)
    self.monto_fijo = format_valor(valor)
  end
  
  def monto_fijo_f
    format_fm(self.monto_fijo) unless self.monto_fijo.nil?
  end

  def porcentaje_f=(valor)
    self.porcentaje = format_valor(valor)
  end
  
  def porcentaje_f
    format_fm(self.porcentaje) unless self.porcentaje.nil?
  end
  
  

  def forma_cobro_w
    case self.forma_cobro
    when '1'
      return I18n.t('Sistema.Body.Modelos.ProgramaTipoGasto.FormaCobro.al_cobrar_cuotas')
    when '2'
      return I18n.t('Sistema.Body.Modelos.ProgramaTipoGasto.FormaCobro.pago_unico')
    when '3'
      return I18n.t('Sistema.Body.Modelos.ProgramaTipoGasto.FormaCobro.al_liquidar')
    end
  end

  validate :validate_valor
  
  def validate_valor
    if ((self.porcentaje.nil? and self.monto_fijo.nil?) or (self.porcentaje <= 0 and self.monto_fijo <= 0))
      errors.add(:programa_tipo_gasto, "#{I18n.t('Sistema.Body.Modelos.ProgramaTipoGasto.Columnas.porcentaje')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
      errors.add(:programa_tipo_gasto, "#{I18n.t('Sistema.Body.Modelos.ProgramaTipoGasto.Columnas.monto_fijo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
    end
  end
  
end

# == Schema Information
#
# Table name: programa_tipo_gasto
#
#  id            :integer         not null, primary key
#  tipo_gasto_id :integer         not null
#  programa_id   :integer         not null
#  porcentaje    :decimal(16, 2)
#  monto_fijo    :decimal(16, 2)
#  forma_cobro   :string(1)       default("3")
#

