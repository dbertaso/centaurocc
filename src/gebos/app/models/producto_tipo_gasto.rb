# encoding: utf-8

#
# autor: Diego Bertaso
# clase: ProductoTipoGasto
# descripción: Migración a Rails 3
#
class ProductoTipoGasto < ActiveRecord::Base

  self.table_name = 'producto_tipo_gasto'

  attr_accessible :id,
                  :tipo_gasto_id,
                  :producto_id,
                  :porcentaje,
                  :monto_fijo,
                  :forma_cobro,
                  :monto_fijo_f,
                  :porcentaje_f

  belongs_to :producto
  belongs_to :tipo_gasto

  validates_presence_of :producto,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.producto')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"

  validates_presence_of :tipo_gasto,
  :message => "#{I18n.t('Sistema.Body.Modelos.ProgramaTipoGasto.Columnas.tipo_gasto')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"

    validates_presence_of :porcentaje,
    :message => "#{I18n.t('Sistema.Body.Modelos.ProgramaTipoGasto.Columnas.porcentaje')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"

   validates_uniqueness_of :producto_id,
    :scope => [:tipo_gasto_id],
    :message => "#{I18n.t('Sistema.Body.Vistas.General.producto')} #{I18n.t('Sistema.Body.Modelos.Errores.ya existe')}"

  validates_numericality_of :monto_fijo,
    :message => "#{I18n.t('Sistema.Body.Modelos.ProgramaTipoGasto.Columnas.monto_fijo')}#{I18n.t('errors.messages.not_a_number')}"

  validates_numericality_of :porcentaje,
    :message => "#{I18n.t('Sistema.Body.Modelos.ProgramaTipoGasto.Columnas.porcentaje')}#{I18n.t('errors.messages.not_a_number')}"

  def after_initialize
    self.monto_fijo = 0 unless self.monto_fijo
    self.porcentaje = 0 unless self.porcentaje
  end

  def monto_fijo_f=(valor)
    self.monto_fijo = valor.sub(',', '.')
  end

  def monto_fijo_f
    sprintf('%01.2f', self.monto_fijo).sub('.', ',') unless self.monto_fijo.nil?
  end

  def porcentaje_f=(valor)
    self.porcentaje = valor.sub(',', '.')
  end

  def porcentaje_f
    sprintf('%01.2f', self.porcentaje).sub('.', ',') unless self.porcentaje.nil?
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

end

# == Schema Information
#
# Table name: producto_tipo_gasto
#
#  id            :integer         not null, primary key
#  tipo_gasto_id :integer         not null
#  producto_id   :integer         not null
#  porcentaje    :float
#  monto_fijo    :float
#  forma_cobro   :string(1)       default("3")
#

