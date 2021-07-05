# encoding: utf-8

#
#
# clase: PlanPago
# autor: Diego Bertaso
# descripción: Migración a Rails 3
#

class PlanPago < ActiveRecord::Base

  self.table_name = 'plan_pago'

  attr_accessible :id,
                  :fecha_inicio,
                  :fecha_fin,
                  :prestamo_id,
                  :activo,
                  :proyeccion,
                  :plazo,
                  :tasa,
                  :monto,
                  :meses_gracia,
                  :meses_muertos,
                  :diferir_intereses,
                  :exonerar_intereses_diferidos,
                  :tasa_gracia,
                  :frecuencia_pago,
                  :frecuencia_pago_gracia,
                  :dia_facturacion,
                  :fecha_evento,
                  :motivo_evento,
                  :migrado_d3,
                  :fecha_evento_f,
                  :fecha_inicio_f


  belongs_to :prestamo

  has_many :cuotas, :class_name=>"PlanPagoCuota", :dependent=>:destroy

  validates :fecha_inicio,
    :presence => { :message => "#{I18n.t('Sistema.Body.General.fecha_inicio')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :fecha_fin,
    :presence => { :message => "#{I18n.t('Sistema.Body.General.fecha_fin')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :prestamo,
    :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.prestamo')}} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :fecha_inicio,
    :date => {:message => "#{I18n.t('Sistema.Body.General.fecha_inicio')} #{I18n.t('Sistema.Body.Modelos.Errores.fecha_invalida')}"}

  validates :fecha_fin,
    :date => {:message => "#{I18n.t('Sistema.Body.General.fecha_fin')} #{I18n.t('Sistema.Body.Modelos.Errores.fecha_invalida')}"}

  validates :fecha_evento,
    :date => {:message => "#{I18n.t('Sistema.Body.General.fecha_evento')} #{I18n.t('Sistema.Body.Modelos.Errores.fecha_invalida')}"}

  validates :tasa, :numericality => {:message => "#{I18n.t('Sistema.Body.Vistas.General.tasa')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_numerico')}"}

  validates :monto, :numericality => {:message => "#{I18n.t('Sistema.Body.Vistas.General.monto')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_numerico')}"}

  validates :monto, :numericality => {:message => "#{I18n.t('Sistema.Body.Vistas.General.tasa')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.gracia')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_numerico')}"}

  validates :plazo, :numericality => { :only_integer => true,
    :message => "#{I18n.t('Sistema.Body.Modelos.PlanPago.Columnas.plazo')} #{I18n.t('Sistema.errors.messages.not_an_integer')}" }


  validates :meses_gracia, :numericality => { :only_integer => true,
    :message => "#{I18n.t('Sistema.Body.Modelos.PlanPago.Columnas.meses_gracia')} #{I18n.t('Sistema.errors.messages.not_an_integer')}" }

  validates :meses_muertos, :numericality => { :only_integer => true,
    :message => "#{I18n.t('Sistema.Body.Modelos.PlanPago.Columnas.meses_muertos')} #{I18n.t('Sistema.errors.messages.not_an_integer')}" }

  validates :frecuencia_pago, :numericality => { :only_integer => true,
    :message => "#{I18n.t('Sistema.Body.Modelos.PlanPago.Columnas.frecuencia_pago')} #{I18n.t('Sistema.errors.messages.not_an_integer')}" }

  validates :frecuencia_pago_gracia, :numericality => { :only_integer => true,
    :message => "#{I18n.t('Sistema.Body.Modelos.PlanPago.Columnas.frecuencia_pago_gracia')} #{I18n.t('Sistema.errors.messages.not_an_integer')}" }


  def motivo_evento_w
    case self.motivo_evento
      when 'D'
        I18n.t('Sistema.Body.Modelos.PlanPago.MotivoEvento.desembolso')
      when 'T'
        I18n.t('Sistema.Body.Modelos.PlanPago.MotivoEvento.cambio_tasa')
      when 'A'
        I18n.t('Sistema.Body.Modelos.PlanPago.MotivoEvento.abono_extraordinario')
      when 'M'
        I18n.t('Sistema.Body.Modelos.PlanPago.MotivoEvento.extension_muerto')
    end
  end

  def fecha_evento_f=(fecha)
    self.fecha_evento = fecha
  end

  def fecha_evento_f
    format_fecha(self.fecha_evento)
  end

  def fecha_inicio_f=(fecha)
    self.fecha_inicio = fecha
  end

  def fecha_inicio_f
    format_fecha(self.fecha_inicio)
  end

  def diferir_intereses_w
    if self.prestamo.meses_diferidos > 0
      I18n.t('Sistema.Body.General.si')
    else
      I18n.t('Sistema.Body.General.negacion')
    end
  end

  def exonerar_intereses_diferidos_w
    self.exonerar_intereses_diferidos ? I18n.t('Sistema.Body.General.si') : I18n.t('Sistema.Body.General.no')
  end

  def frecuencia_pago_w
    case self.frecuencia_pago
      when 0
        I18n.t('Sistema.Body.General.Periodos.pago_unico')
       when 1
        I18n.t('Sistema.Body.General.Periodos.mensual')
      when 2
        I18n.t('Sistema.Body.General.Periodos.bimestral')
      when 3
        I18n.t('Sistema.Body.General.Periodos.trimestral')
      when 5
        I18n.t('Sistema.Body.General.Periodos.pentamestral')
      when 6
        I18n.t('Sistema.Body.General.Periodos.semestral')
      when 7
        I18n.t('Sistema.Body.General.Periodos.heptamestral')
      when 12
        I18n.t('Sistema.Body.General.Periodos.anual')
    else
       I18n.t('Sistema.Body.General.Periodos.pago_unico')
    end
  end

  def frecuencia_pago_gracia_w
    case self.frecuencia_pago_gracia
      when 0
        I18n.t('Sistema.Body.General.Periodos.pago_unico')
       when 1
        I18n.t('Sistema.Body.General.Periodos.mensual')
      when 2
        I18n.t('Sistema.Body.General.Periodos.bimestral')
      when 3
        I18n.t('Sistema.Body.General.Periodos.trimestral')
      when 5
        I18n.t('Sistema.Body.General.Periodos.pentamestral')
      when 6
        I18n.t('Sistema.Body.General.Periodos.semestral')
      when 6
        I18n.t('Sistema.Body.General.Periodos.heptamestral')
      when 12
        I18n.t('Sistema.Body.General.Periodos.anual')
    end
  end

  def tasa_f=(valor)
    self.tasa = format_valor(valor)
  end

  def tasa_f
    format_f(self.tasa)
  end

  def tasa_gracia_f=(valor)
    self.tasa_gracia = format_valor(valor)
  end

  def tasa_gracia_f
    format_f(self.tasa_gracia)
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
end


# == Schema Information
#
# Table name: plan_pago
#
#  id                           :integer         not null, primary key
#  fecha_inicio                 :date            not null
#  fecha_fin                    :date            not null
#  prestamo_id                  :integer         not null
#  activo                       :boolean         default(TRUE)
#  proyeccion                   :boolean         default(TRUE)
#  plazo                        :integer(2)
#  tasa                         :float
#  monto                        :decimal(16, 2)  default(0.0)
#  meses_gracia                 :integer(2)
#  meses_muertos                :integer(2)
#  diferir_intereses            :boolean         default(FALSE)
#  exonerar_intereses_diferidos :boolean         default(FALSE)
#  tasa_gracia                  :float
#  frecuencia_pago              :integer(2)      default(1)
#  frecuencia_pago_gracia       :integer(2)      default(1)
#  dia_facturacion              :integer(2)
#  fecha_evento                 :date            not null
#  motivo_evento                :string(1)
#  migrado_d3                   :boolean         default(FALSE)
#

