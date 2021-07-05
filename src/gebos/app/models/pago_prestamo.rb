# encoding: utf-8

#
# autor: Diego Bertaso
# clase: PagoPrestamo
# Migrado a Rails 3
#

class PagoPrestamo < ActiveRecord::Base

  self.table_name = 'pago_prestamo'
  
  attr_accessible :id,
                  :monto,
                  :prestamo_id,
                  :interes_corriente,
                  :interes_diferido,
                  :interes_mora,
                  :capital,
                  :pago_cliente_id,
                  :remanente_por_aplicar,
                  :interes_desembolso,
                  :interes_causado,
                  :saldo_insoluto,
                  :observacion_precancelacion,
                  :monto_f,
                  :interes_corrinte_f,
                  :interes_diferido_f,
                  :capital_f,
                  :interes_desembolso_f,
                  :interes_mora_f,
                  :remanente_por_aplicar_f
  
  belongs_to :pago_cliente
  belongs_to :prestamo
  has_many :cuotas, :class_name=>'PagoCuota'



  def saldo_insoluto_fm
    format_fm(self.saldo_insoluto)
  end

  def interes_causado_fm
  
    format_fm(self.interes_causado)

  end

  def monto_f=(valor)
    self.monto = format_valor(valor)
  end

  def monto_f
    format_f(self.monto) 
  end

  def monto_fm

    format_fm(self.monto)

  end

  def interes_corriente_f=(valor)
    self.interes_corriente = format_valor(valor)
  end

  def interes_corriente_f
    format_f(self.interes_corriente)
  end

  def interes_corriente_fm
    format_fm(self.interes_corriente)
  end

  def interes_diferido_f=(valor)
    self.interes_diferido = format_valor(valor)
  end

  def interes_diferido_f
    format_fm(self.interes_diferido)
  end

  def interes_diferido_fm

    format_fm(self.interes_diferido)

  end

  def interes_mora_f=(valor)
    self.interes_mora = format_valor(valor)
  end

  def interes_mora_f
    format_f(self.interes_mora)
  end

  def interes_mora_fm

    format_fm(self.interes_mora)

  end
  def capital_f=(valor)
    self.capital = format_valor(valor)
  end

  def capital_f
    format_f(self.capital)
  end

  def capital_fm
    format_fm(self.capital)
  end

  def interes_desembolso_f=(valor)
    self.interes_desembolso = format(valor)
  end

  def interes_desembolso_f
    format_f(self.interes_desembolso)
  end

  def interes_desembolso_fm
    format_fm(self.interes_desembolso)
  end

  def remanente_por_aplicar_f=(valor)
    self.remanente_por_aplicar = format_valor(valor)
  end

  def remanente_por_aplicar_f
    format_f(self.remanente_por_aplicar)
  end

  def remanente_por_aplicar_fm
    format_fm(self.remanente_por_aplicar)
  end


end


# == Schema Information
#
# Table name: pago_prestamo
#
#  id                         :integer         not null, primary key
#  monto                      :decimal(16, 2)  default(0.0)
#  prestamo_id                :integer         not null
#  interes_corriente          :decimal(16, 2)  default(0.0)
#  interes_diferido           :decimal(16, 2)  default(0.0)
#  interes_mora               :decimal(16, 2)  default(0.0)
#  capital                    :decimal(16, 2)  default(0.0)
#  pago_cliente_id            :integer         not null
#  remanente_por_aplicar      :decimal(16, 2)  default(0.0)
#  interes_desembolso         :decimal(16, 2)  default(0.0)
#  interes_causado            :decimal(16, 2)  default(0.0)
#  saldo_insoluto             :decimal(16, 2)  default(0.0)
#  observacion_precancelacion :text
#

