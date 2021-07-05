
# encoding: utf-8

#
# autor: Diego Bertaso
# clase: ViewPagosEstadoCuenta
# descripcion: Migracion a Rails 3

class ViewPagosEstadoCuenta < ActiveRecord::Base
  
  self.table_name = 'view_pagos_estado_cuenta'

  attr_accessible :prestamo_id,
                  :pago_cliente_id,
                  :fecha_realizacion,
                  :fecha,
                  :tipo,
                  :monto_pago,
                  :remanente_por_aplicar,
                  :abono_capital,
                  :pago_interes,
                  :pago_interes_diferido,
                  :pago_interes_mora,
                  :pago_capital

  public
  
  def tipo_w
      case self.tipo
        when 'P'
          I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.pago_deposito')
        when 'R'
          I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.pago_arrime')
      end  
  end
  
  def monto_pago_fm
    valor = sprintf('%01.2f', self.monto_pago).sub('.', ',')
    valor.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
  end

  def abono_capital_fm
    valor = sprintf('%01.2f', self.abono_capital).sub('.', ',')
    valor.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
  end

  def pago_interes_fm
    valor = sprintf('%01.2f', self.pago_interes).sub('.', ',')
    valor.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
  end
  
  def pago_interes_diferido_fm
    valor = sprintf('%01.2f', self.pago_interes_diferido).sub('.', ',')
    valor.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
  end
  
  def pago_interes_mora_fm
    valor = sprintf('%01.2f', self.pago_interes_mora).sub('.', ',')
    valor.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
  end
  
  def pago_capital_fm
    valor = sprintf('%01.2f', self.pago_capital).sub('.', ',')
    valor.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
  end
  
  def remanente_por_aplicar_fm
    valor = sprintf('%01.2f', self.remanente_por_aplicar).sub('.', ',')
    valor.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
  end
    
end

# == Schema Information
#
# Table name: view_pagos_estado_cuenta
#
#  prestamo_id           :integer
#  pago_cliente_id       :integer
#  fecha_realizacion     :date
#  fecha                 :date
#  tipo                  :string(1)
#  monto_pago            :float
#  remanente_por_aplicar :float
#  abono_capital         :float
#  pago_interes          :float
#  pago_interes_diferido :float
#  pago_interes_mora     :float
#  pago_capital          :float
#

