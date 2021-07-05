# encoding: utf-8

#
# autor: Diego Bertaso
# clase: CompromisoPagos
# creado con Rails 3
#

class CompromisoPago < ActiveRecord::Base

  self.table_name = 'compromiso_pago'

  attr_accessible :id,
                  :telecobranzas_id,
                  :prestamo_id,
                  :fecha_pago,
                  :fecha_limite_pago,
                  :monto_pago,
                  :estatus,
                  :observacion,
                  :fecha_pago_f,
                  :fecha_limite_pago_f

  validates :telecobranzas_id, :presence => {:message => "#{I18n.t('Sistema.Body.Modelos.CompromisoPago.Columnas.telecobranzas')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :prestamo_id, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.financiamiento')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :fecha_pago, :presence => {:message => "#{I18n.t('Sistema.Body.Modelos.CompromisoPago.Columnas.fecha_pago')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
                         :date => {:message =>"#{I18n.t('Sistema.Body.Modelos.CompromisoPago.Columnas.fecha_pago')} #{I18n.t('errors.messages.not_a_date')}"}
                         #:after_or_equal_to => Proc.new { Time.now.strftime("%d/%m/%Y") }, :message => "#{I18n.t('Sistema.Body.Modelos.CompromisoPago.Columnas.fecha_pago')} #{I18n.t('errors.messages.after_or_equal_to')}"}
   
  validates :fecha_limite_pago, :presence => {:message => "#{I18n.t('Sistema.Body.Modelos.CompromisoPago.Columnas.fecha_limite_pago')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
                                :date => {:message =>"#{I18n.t('Sistema.Body.Modelos.CompromisoPago.Columnas.fecha_limite_pago')} #{I18n.t('errors.messages.not_a_date')}"}
                                #:after_or_equal_to => Proc.new { Time.now.strftime("%d/%m/%Y") }, :message => "#{I18n.t('Sistema.Body.Modelos.CompromisoPago.Columnas.fecha_limite_pago')} #{I18n.t('errors.messages.after_or_equal_to')}"}
   
  validates :monto_pago, :presence => {:message => "#{I18n.t('Sistema.Body.Modelos.CompromisoPago.Columnas.monto_pago')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
                         :numericality => {:message => "#{I18n.t('Sistema.Body.Modelos.CompromisoPago.Columnas.monto_pago')} #{I18n.t('Sistema.Body.Modelos.Errores.monto_invalido')}"}
                       
  validates :estatus, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.Form.estatus')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validate :validar_fecha

  def validar_fecha

    if self.fecha_pago.strftime("%Y%m%d") < Time.now.strftime("%Y%m%d")
      errors.add(:compromiso_pago, "#{I18n.t('Sistema.Body.Vistas.Form.fecha')} #{I18n.t('Sistema.Body.Vistas.General.del')} #{I18n.t('Sistema.Body.Vistas.General.compromiso')} #{I18n.t('errors.messages.after_or_equal_to', :date=>Time.now.strftime("%d/%m/%Y"))}")
    end

    # if self.fecha_limite_pago.strftime("%Y%m%d") < Time.now.strftime("%Y%m%d")
    #   add.errors(:compromiso_pago, "#{I18n.t('Sistema.Body.Modelos.CompromisoPago.Columnas.fecha_limite_pago')} #{I18n.t('errors.messages.after_or_equal_to')}")
    # end
  end

  def fecha_pago_f=(fecha)
    self.fecha_pago = fecha
  end

  def fecha_pago_f
    format_fecha(self.fecha_pago)
  end

  def fecha_limite_pago_f=(fecha)
    self.fecha_limite_pago = fecha
  end

  def fecha_limite_pago_f
    format_fecha(self.fecha_limite_pago)
  end
end

# == Schema Information
#
# Table name: compromiso_pago
#
#  id                       :integer         not null, primary key
#  telecobranzas_id         :integer         not null
#  prestamo_id              :integer         not null
#  fecha_pago               :date            not null
#  fecha_limite_pago        :date            not null
#  monto_pago               :decimal(16, 2)  not null
#  estatus                  :string(1)       not null
#  observacion              :text
#  monto_efectivamente_pago :decimal(16, 2)  default(0.0)
#

