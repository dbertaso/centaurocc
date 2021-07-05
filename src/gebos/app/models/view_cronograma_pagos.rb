
# encoding: utf-8

#
# autor: Diego Bertaso
# clase: ViewCronogramaPagos
# descripcion: Migracion a Rails 3

class ViewCronogramaPagos < ActiveRecord::Base

  self.table_name = 'view_cronograma_pagos'
  
  attr_accessible :id,
                  :prestamo_id,
                  :activo,
                  :fecha_fin,
                  :fecha,
                  :numero,
                  :valor_cuota,
                  :capital,
                  :tipo_cuota,
                  :estatus_pago,
                  :interes_corriente,
                  :interes_diferido,
                  :interes_mora,
                  :saldo_insoluto

  public
  
  def estatus
  
    case self.estatus_pago
      when 'X'
        I18n.t('Sistema.Body.Modelos.PlanPagoCuota.EstatusPago.no_exigible')
      when 'T'
        I18n.t('Sistema.Body.Modelos.PlanPagoCuota.EstatusPago.pagada')
      when 'P'
        I18n.t('Sistema.Body.Modelos.PlanPagoCuota.EstatusPago.parcialmente_pagada')
      when 'D'
        I18n.t('Sistema.Body.Modelos.PlanPagoCuota.EstatusPago.diferida')
      when 'N'
        I18n.t('Sistema.Body.Modelos.PlanPagoCuota.EstatusPago.exigible')
    end
    
  end

  def tipo

    case self.tipo_cuota
    
      when 'G'
        I18n.t('Sistema.Body.Modelos.PlanPagoCuota.TipoCuota.gracia')
      when 'M'
        I18n.t('Sistema.Body.Modelos.PlanPagoCuota.TipoCuota.muerto')
      when 'C'
        I18n.t('Sistema.Body.Modelos.PlanPagoCuota.TipoCuota.amortizacion')
    end
    
  end
  
  def valor_cuota_fm
    valor = sprintf('%01.2f', self.valor_cuota).sub('.', ',')
    valor.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
  end

  def capital_fm
    valor = sprintf('%01.2f', self.capital).sub('.', ',')
    valor.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
  end

  def interes_corriente_fm
    valor = sprintf('%01.2f', self.interes_corriente).sub('.', ',')
    valor.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
  end

  def interes_diferido_fm
    valor = sprintf('%01.2f', self.interes_diferido).sub('.', ',')
    valor.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
  end
 
  def interes_mora_fm
    valor = sprintf('%01.2f', self.interes_mora).sub('.', ',')
    valor.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
  end

  def saldo_insoluto_fm
    valor = sprintf('%01.2f', self.saldo_insoluto).sub('.', ',')
    valor.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
  end
    
  def total_pagar_fm
    total_pagar = self.valor_cuota + self.interes_diferido + self.interes_mora
    
    valor = sprintf('%01.2f', total_pagar).sub('.', ',')
    valor.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
  end  
  
end

# == Schema Information
#
# Table name: view_cronograma_pagos
#
#  id                :integer
#  prestamo_id       :integer
#  activo            :boolean
#  fecha_fin         :date
#  fecha             :date
#  numero            :integer(2)
#  valor_cuota       :decimal(16, 2)
#  capital           :decimal(16, 2)
#  tipo_cuota        :string(1)
#  estatus_pago      :string(1)
#  interes_corriente :decimal(16, 2)
#  interes_diferido  :decimal(16, 2)
#  interes_mora      :decimal(16, 2)
#  saldo_insoluto    :decimal(16, 2)
#

