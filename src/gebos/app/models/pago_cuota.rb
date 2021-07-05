# encoding: utf-8

#
# autor: Diego Bertaso
# clase: PagoCuota
# Migrado a Rails 3
#

class PagoCuota < ActiveRecord::Base

  self.table_name = 'pago_cuota'
  
  attr_accessible :id,
                  :plan_pago_cuota_id,
                  :pago_prestamo_id,
                  :monto,
                  :aplicado,
                  :interes_corriente,
                  :interes_diferido,
                  :interes_mora,
                  :capital,
                  :remanente_por_aplicar,
                  :interes_desembolso,
                  :cuota_extra,
                  :estatus_pago,
                  :fecha_vencimiento,
                  :fecha_pago,
                  :dias_atraso,
                  :monto_f,
                  :interes_corriente_f,
                  :interes_diferido_f,
                  :interes_mora_f,
                  :capital_f,
                  :interes_desembolso_f,
                  :remanente_por_aplicar_f

  belongs_to :plan_pago_cuota
  belongs_to :pago_prestamo
  
  
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
    format_f(self.interes_diferido)
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
    self.interes_desembolso = format_valor(valor)
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
  
  def estatus_pago_w
  
    unless self.estatus_pago.nil?

      case self.estatus_pago
        when 'N'
          I18n.t('Sistema.Body.Modelos.PlanPagoCuota.EstatusPago.exigible')
        when 'P'
          I18n.t('Sistema.Body.Modelos.PlanPagoCuota.EstatusPago.parcialmente_pagada')
        when 'T'
          I18n.t('Sistema.Body.Modelos.PlanPagoCuota.EstatusPago.pagada')
        when 'X'
          I18n.t('Sistema.Body.Modelos.PlanPagoCuota.EstatusPago.no_exigible')
        when 'D'
          I18n.t('Sistema.Body.Modelos.PlanPagoCuota.EstatusPago.diferida')
      end
      
    end
  
  end

end


# == Schema Information
#
# Table name: pago_cuota
#
#  id                    :integer         not null, primary key
#  plan_pago_cuota_id    :integer         not null
#  pago_prestamo_id      :integer         not null
#  monto                 :decimal(16, 2)  default(0.0)
#  aplicado              :boolean         default(FALSE)
#  interes_corriente     :decimal(16, 2)  default(0.0)
#  interes_diferido      :decimal(16, 2)  default(0.0)
#  interes_mora          :decimal(16, 2)  default(0.0)
#  capital               :decimal(16, 2)  default(0.0)
#  remanente_por_aplicar :decimal(16, 2)  default(0.0)
#  interes_desembolso    :decimal(16, 2)  default(0.0)
#  cuota_extra           :decimal(16, 2)  default(0.0)
#  estatus_pago          :string
#  fecha_vencimiento     :date
#  fecha_pago            :date
#  dias_atraso           :integer
#

