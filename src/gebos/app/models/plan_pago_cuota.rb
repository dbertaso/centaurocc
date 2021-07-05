# encoding: utf-8

#
#
# clase: PlanPagoCuota
# autor: Diego Bertaso
# descripción: Migración a Rails 3
#

class PlanPagoCuota < ActiveRecord::Base

  self.table_name = 'plan_pago_cuota'

  attr_accessible :id,
                  :plan_pago_id,
                  :fecha,
                  :numero,
                  :valor_cuota,
                  :amortizado,
                  :amortizado_acumulado,
                  :interes_corriente,
                  :interes_corriente_acumulado,
                  :interes_diferido,
                  :interes_mora,
                  :saldo_insoluto,
                  :tasa_periodo,
                  :tipo_cuota,
                  :vencida,
                  :estatus_pago,
                  :fecha_ultimo_pago,
                  :pago_interes_mora,
                  :pago_interes_corriente,
                  :pago_interes_diferido,
                  :pago_interes_corriente_acumulado,
                  :pago_capital,
                  :remanente_por_aplicar,
                  :causado_no_devengado,
                  :desembolso,
                  :cambio_tasa,
                  :abono_extraordinario,
                  :monto_desembolso,
                  :monto_abono,
                  :dias_mora,
                  :tasa_nominal_anual,
                  :interes_desembolso,
                  :cantidad_dias,
                  :pago_interes_desembolso,
                  :cancelacion_prestamo,
                  :reclasificada,
                  :intereses_por_cobrar_al_30,
                  :mora_exonerada,
                  :migrado_d3,
                  :bolivar_fuerte,
                  :fecha_ultima_mora,
                  :interes_ord_devengado_mes,
                  :fecha_ord_devengado,
                  :interes_ord_devengado_acum,
                  :ajuste_devengo,
                  :pago_total_cliente,
                  :cuota_extra,
                  :pago_cuota_extra,
                  :interes_dif_devengado_mes,
                  :fecha_ultimo_pago_mora_f,
                  :fecha_ultimo_pago_f


  belongs_to :plan_pago


  validates :numero,
  :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.numero')} #{I18n.t('Sistema.Body.Vistas.Form.cuota')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
  :numericality => {  :only_integer => true,
                      :message => "#{I18n.t('Sistema.Body.Vistas.General.numero')} #{I18n.t('Sistema.Body.Vistas.Form.cuota')} #{I18n.t('Sistema.errors.messages.not_an_integer')}" }

  validates :fecha,
  :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.Form.fecha')} #{I18n.t('Sistema.Body.Vistas.Form.cuota')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :plan_pago,
  :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.Form.plan_pago')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :fecha_ultimo_pago,
    :date => {:message => "#{I18n.t('Sistema.Body.Vistas.Form.fecha')} #{I18n.t('Sistema.Body.Vistas.Form.ultimo_pago')} #{I18n.t('Sistema.Body.Modelos.Errores.fecha_invalida')}"}

  validates :fecha,
    :date => {:message => "#{I18n.t('Sistema.Body.Vistas.Form.fecha')} #{I18n.t('Sistema.Body.Vistas.General.vemcimiento')} #{I18n.t('Sistema.Body.Modelos.Errores.fecha_invalida')}"}


  validates :dias_mora, :numericality => { :only_integer => true,
    :message => "#{I18n.t('Sistema.Body.Modelos.PlanPagoCuota.Columnas.dias_mora')} #{I18n.t('Sistema.errors.messages.not_an_integer')}"}

  validates :valor_cuota, :numericality => {:message => "#{I18n.t('Sistema.Body.Modelos.PlanPagoCuota.Columnas.dias_mora')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_numerico')}"}

  validates :amortizado, :numericality => {:message => "#{I18n.t('Sistema.Body.Modelos.PlanPagoCuota.Columnas.capital')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_numerico')}"}

  validates :amortizado_acumulado, :numericality => {:message => "#{I18n.t('Sistema.Body.Modelos.PlanPagoCuota.Columnas.capital_acumulado')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_numerico')}"}

  validates :interes_corriente, :numericality => {:message => "#{I18n.t('Sistema.Body.Modelos.PlanPagoCuota.Columnas.interes_corriente')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_numerico')}"}

  validates :interes_corriente_acumulado, :numericality => {:message => "#{I18n.t('Sistema.Body.Modelos.PlanPagoCuota.Columnas.interes_corriente_acumulado')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_numerico')}"}

  validates :interes_diferido, :numericality => {:message => "#{I18n.t('Sistema.Body.Modelos.PlanPagoCuota.Columnas.interes_diferido')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_numerico')}"}

  validates :interes_mora, :numericality => {:message => "#{I18n.t('Sistema.Body.Modelos.PlanPagoCuota.Columnas.interes_mora')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_numerico')}"}

  validates :saldo_insoluto, :numericality => {:message => "#{I18n.t('Sistema.Body.Modelos.PlanPagoCuota.Columnas.saldo_insoluto')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_numerico')}"}

  validates :tasa_periodo, :numericality => {:message => "#{I18n.t('Sistema.Body.Modelos.PlanPagoCuota.Columnas.tasa_periodo')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_numerico')}"}

  validates :pago_interes_corriente, :numericality => {:message => "#{I18n.t('Sistema.Body.Modelos.PlanPagoCuota.Columnas.pago_interes_corriente')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_numerico')}"}

  validates :pago_interes_mora, :numericality => {:message => "#{I18n.t('Sistema.Body.Modelos.PlanPagoCuota.Columnas.pago_interes_mora')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_numerico')}"}

  validates :pago_interes_diferido,  :numericality => {:message => "#{I18n.t('Sistema.Body.Modelos.PlanPagoCuota.Columnas.pago_interes_diferido')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_numerico')}"}

  validates :pago_capital, :numericality => {:message => "#{I18n.t('Sistema.Body.Modelos.PlanPagoCuota.Columnas.pago_capital')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_numerico')}"}

  validates :remanente_por_aplicar, :numericality => {:message => "#{I18n.t('Sistema.Body.Modelos.PlanPagoCuota.Columnas.remanente_por_aplicar')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_numerico')}"}

  validates :causado_no_devengado, :numericality => {:message => "#{I18n.t('Sistema.Body.Modelos.PlanPagoCuota.Columnas.causado_no_devengado')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_numerico')}"}

  validates :monto_abono, :numericality => {:message => "#{I18n.t('Sistema.Body.Modelos.PlanPagoCuota.Columnas.monto_abono')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_numerico')}"}

  validates :monto_desembolso, :numericality => {:message => "#{I18n.t('Sistema.Body.Modelos.PlanPagoCuota.Columnas.monto_desembolso')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_numerico')}"}

  def mora_exonerada_fm
  
    format_fm(self.mora_exonerada)
  end

  def tipo_cuota_w
    case self.tipo_cuota
      when 'C'
        I18n.t('Sistema.Body.Modelos.PlanPagoCuota.TipoCuota.amortizacion')
      when 'G'
        I18n.t('Sistema.Body.Modelos.PlanPagoCuota.TipoCuota.gracia')
      when 'M'
        I18n.t('Sistema.Body.Modelos.PlanPagoCuota.TipoCuota.muerto')
    end
  end

  def after_initialize
    self.causado_no_devengado = 0 unless self.causado_no_devengado
    self.pago_capital= 0 unless self.pago_capital
    self.pago_interes_diferido = 0 unless self.pago_interes_diferido
    self.pago_interes_mora = 0 unless self.pago_interes_mora
    self.interes_mora = 0 unless self.interes_mora
    self.valor_cuota = 0 unless self.valor_cuota
    self.interes_diferido = 0 unless self.interes_diferido
    self.remanente_por_aplicar = 0 unless self.remanente_por_aplicar
    self.pago_interes_corriente = 0 unless self.pago_interes_corriente
    self.amortizado = 0 unless self.amortizado
    self.amortizado_acumulado = 0 unless self.amortizado_acumulado
  end

  def total

    if self.tipo_cuota == 'C'
      return self.valor_cuota + self.interes_mora + self.interes_diferido + self.cuota_extra
    end
    if self.tipo_cuota == 'G'
      return self.valor_cuota + self.interes_mora  + self.cuota_extra
    end

  end
  
  def total_pago
    return self.pago_interes_corriente + self.pago_interes_diferido + self.pago_interes_mora + self.pago_capital + self.pago_cuota_extra
  end
  
  def total_deuda
    return self.total - self.total_pago
  end

  def total_fm
  
    format_fm(self.total)
  end
  
  def total_pago_fm
    format_fm(self.total_pago)
  end

  def total_deuda_fm
    format_fm(self.total_deuda)
  end
  
  def causado_no_devengado_fm
  
    format_fm(self.causado_no_devengado)
  end

  def monto_abono_f=(valor)
    self.monto_abono = format_valor(valor)
  end

  def monto_abono_f
    format_f(self.monto_abono)
  end

  def monto_abono_fm
  
    format_fm(self.monto_abono)
  end

  def monto_desembolso_f=(valor)
    self.monto_desembolso = format_valor(valor)
  end

  def monto_desembolso_f
    format_f(self.monto_desembolso)
  end

  def monto_desembolso_fm
    format_fm(self.monto_desembolso)
  end

  def tasa_periodo_f=(valor)
    self.tasa_periodo = format_valor(valor)
  end

  def tasa_periodo_f
    format_f(self.tasa_periodo)
  end

  def valor_cuota_f=(valor)
    self.valor_cuota = tasa_valor(valor)
  end

  def valor_cuota_f
    format_f(self.valor_cuota)
  end

  def valor_cuota_fm
    format_fm(self.valor_cuota)
  end

  def cuota_extra_f=(valor)
    self.cuota_extra = format_valor(valor)
  end

  def cuota_extra_f
    format_f(self.cuota_extra)
  end

  def pago_cuota_extra_fm

    format_fm(self.pago_cuota_extra)

  end

  def cuota_extra_fm
  
    format_fm(self.cuota_extra)
  end

  def pago_total_cliente

    if self.tipo_cuota == 'G'
      (self.valor_cuota + self.cuota_extra)
    elsif self.tipo_cuota == 'M'
      0
    else
      (self.valor_cuota + self.cuota_extra + self.interes_diferido)
    end
  end

  def pago_total_cliente_fm
  
    format_fm(self.pago_total_cliente)
  end

  def amortizado_f=(valor)
    self.amortizado = format_valor(valor)
  end

  def amortizado_f
    format_f(self.amortizado)
  end

  def amortizado_fm
  
    format_fm(self.amortizado)
  end

  def amortizado_acumulado_f=(valor)
    self.amortizado_acumulado = format_valor(valor)
  end

  def amortizado_acumulado_f
    format_f(self.amortizado_acumulado)
  end

  def amortizado_acumulado_fm
  
    format_fm(self.amortizado_acumulado)
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

  def interes_corriente_acumulado_f=(valor)
    self.interes_corriente_acumulado = format_valor(valor)
  end

  def interes_corriente_acumulado_f
  
    format_f(self.interes_corriente_acumulado)
  end

  def interes_corriente_acumulado_fm
  
    format_fm(self.interes_corriente_acumulado)
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

  def saldo_insoluto_f=(valor)
  
    self.saldo_insoluto = format_valor(valor)
  end

  def saldo_insoluto_f
  
    format_f(self.saldo_insoluto)
  end

  def saldo_insoluto_fm
  
    format_fm(self.saldo_insoluto)
  end

  def fecha_f=(fecha)
    self.fecha = fecha
  end

  def fecha_f
    format_fecha(self.fecha)
  end

  def fecha_ultimo_pago_f=(fecha)
    self.fecha_ultimo_pago = fecha
  end

  def fecha_ultimo_pago_f
    fecha_format(self.fecha_ultimo_pago)
  end

  def estatus_pago_w
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

  def vencida_w
    case self.vencida
    when true
      I18n.t('Sistema.Body.General.si')
    when false
      I18n.t('Sistema.Body.General.no')
    end
  end

  def pago_interes_desembolso_f=(valor)
  
    self.pago_interes_desembolso = format_valor(valor)
  end

  def pago_interes_desembolso_f
  
    format_f(self.pago_interes_desembolso)
  end

  def pago_interes_desembolso_fm
  
    format_fm(self.pago_interes_desembolso)
  end
  
  def def pago_interes_diferido_f=(valor)
  
    self.pago_interes_diferido = format_valor(valor)
  end

  def pago_interes_diferido_f
  
    format_f(self.pago_interes_diferido)
  end

  def pago_interes_diferido_fm
  
    format_fm(self.pago_interes_diferido)
  end

  def pago_interes_mora_f=(valor)
  
    self.pago_interes_mora = format_valor(valor)
  end

  def pago_interes_mora_f
  
    format_f(self.pago_interes_mora)
  end

  def pago_interes_mora_fm
  
    format_fm(self.pago_interes_mora)
  end
  
  def pago_interes_corriente_f=(valor)
    self.pago_interes_corriente = format_valor(valor)
  end

  def pago_interes_corriente_f
  
    format_f(self.pago_interes_corriente)
  end

  def pago_interes_corriente_fm
  
    format_fm(self.pago_interes_corriente)
  end
  
  def pago_capital_f=(valor)
  
    self.pago_capital = format_valor(valor)
  end

  def pago_capital_f
  
    format_f(self.pago_capital)
  end

  def pago_capital_fm
    format_fm(self.pago_capital)
  end
  
  def tasa_nominal_anual_f=(valor)
    self.tasa_nominal_anual = format_valor(valor)
  end

  def tasa_nominal_anual_f
    format_f(self.tasa_nominal_anual)
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
  
  def monto_abono_f=(valor)
    self.monto_abono = format_valor(valor)
  end

  def monto_abono_f
    format_f(self.monto_abono)
  end

  def monto_abono_fm
  
    format_fm(self.monto_abono)
  end
  
  def interes_foncrei_f=(valor)
    self.interes_foncrei = tasa_valor(valor)
  end

  def interes_foncrei_f
  
    format_f(self.interes_foncrei)
  end

  def interes_foncrei_fm
  
    format_fm(self.interes_foncrei)
  end

  def interes_intermediario_f=(valor)
    self.interes_intermediario = tasa_valor(valor)
  end

  def interes_intermediario_f
  
    format_f(self.interes_intermediario)
  end

  def interes_intermediario_fm
  
    format_fm(self.interes_intermediario)
  end

  def monto_mora_proyectado( fecha, fecha_cierre )

   if self.tipo_cuota == 'G' or self.tipo_cuota == 'M'
      return 0
   end

   if dias_mora_proyectado(fecha, fecha_cierre ) == 0
      return 0
   end

   parametro = ParametroGeneral.find_by_id(1)

   factormora = (self.tasa_nominal_anual + parametro.tasa_maxima_mora) / 36000
   moradiaria = self.amortizado * factormora
   return dias_mora_proyectado(fecha, fecha_cierre) * moradiaria

  end

  def monto_mora_proyectado_fm(fecha, fecha_cierre)
  
    unless self.monto_mora_proyectado(fecha, fecha_cierre).nil?
      format_fm(self.monto_mora_proyectado(fecha, fecha_cierre))
    end
  end

  def dias_mora_proyectado( fecha, fecha_cierre )

    fechahoy = Date.new(Time.now.year,Time.now.month,Time.now.day)
    if fecha >= fecha_cierre
      a = fecha.split('/')
      fecha_hasta = Date.new(a[2].to_i,a[1].to_i,a[0].to_i)
    else
      a = fecha_cierre.split('-')
      fecha_hasta = Date.new(a[0].to_i,a[1].to_i,a[2].to_i)
    end


    fechatrans = fecha_cierre.to_s

    a = fechatrans.split('-')
    fecha_limite = a[2].to_s << "/" << a[1].to_s << "/" << a[0].to_s

    if conversionfecha(fecha) > conversionfecha(fecha_limite)

      return 1

    end

    if self.tipo_cuota == 'G' or self.tipo_cuota == 'M'
      return 0
    end

    return diasentrefechas(fechahoy,fecha_hasta,false)

  end

  def total_monto_mora_proyectado( fecha, fecha_cierre )

    if self.tipo_cuota == 'G' or self.tipo_cuota == 'M'
      return 0
    end

    if monto_mora_proyectado(fecha, fecha_cierre) == 0
        return self.interes_mora
    end

    return self.interes_mora.to_f + monto_mora_proyectado( fecha, fecha_cierre )
  end

  def total_monto_mora_proyectado_fm(fecha, fecha_cierre)
  
    unless self.total_monto_mora_proyectado(fecha, fecha_cierre).nil?
      format_fm(self.total_monto_mora_proyectado(fecha, fecha_cierre))
    end
  end

  def total_dias_mora_proyectado( fecha, fecha_cierre )

    if self.tipo_cuota == 'G' or self.tipo_cuota == 'M'
      return 0
    end

    return  self.dias_mora_proyectado(fecha, fecha_cierre)

  end

  def monto_total_proyectado( fecha, fecha_cierre )

    if self.tipo_cuota == 'G' or self.tipo_cuota == 'M'
      return 0
    end

    return self.valor_cuota.to_f + total_monto_mora_proyectado( fecha, fecha_cierre )
  end

  def monto_total_proyectado_fm(fecha, fecha_cierre)

    unless self.monto_total_proyectado(fecha,fecha_cierre).nil?
      format_fm(self.monto_total_proyectado(fecha, fecha_cierre))
    end
  end

  def conversionfecha(valor, formato = I18n.t('time.formats.gebos_corto'))

    Date.strptime(valor, formato)

  end

  def fecha?(valor, formato = I18n.t('time.formats.gebos_corto'))

    Date.strptime(valor, formato)
    rescue ArgumentError
    false
  end

  def fecha_ultimo_pago_mora_f
  
    format_fecha(self.fecha_ultima_mora)
  end

  private

  def diasentrefechas(from_time,to_time = 0,include_seconds = false)

    from_time = from_time.to_time if from_time.respond_to?(:to_time)
    to_time = to_time.to_time if to_time.respond_to?(:to_time)
    return ((((to_time - from_time).abs)/86400).round)


  end


end



# == Schema Information
#
# Table name: plan_pago_cuota
#
#  id                               :integer         not null, primary key
#  plan_pago_id                     :integer         not null
#  fecha                            :date
#  numero                           :integer(2)      default(1)
#  valor_cuota                      :decimal(16, 2)  default(0.0)
#  amortizado                       :decimal(16, 2)  default(0.0)
#  amortizado_acumulado             :decimal(16, 2)  default(0.0)
#  interes_corriente                :decimal(16, 2)  default(0.0)
#  interes_corriente_acumulado      :decimal(16, 2)  default(0.0)
#  interes_diferido                 :decimal(16, 2)  default(0.0)
#  interes_mora                     :decimal(16, 2)  default(0.0)
#  saldo_insoluto                   :decimal(16, 2)  default(0.0)
#  tasa_periodo                     :float           default(0.0)
#  tipo_cuota                       :string(1)
#  vencida                          :boolean         default(FALSE)
#  estatus_pago                     :string(1)       default("X")
#  fecha_ultimo_pago                :date
#  pago_interes_mora                :decimal(16, 2)  default(0.0)
#  pago_interes_corriente           :decimal(16, 2)  default(0.0)
#  pago_interes_diferido            :decimal(16, 2)  default(0.0)
#  pago_interes_corriente_acumulado :decimal(16, 2)  default(0.0)
#  pago_capital                     :decimal(16, 2)  default(0.0)
#  remanente_por_aplicar            :decimal(16, 2)  default(0.0)
#  causado_no_devengado             :decimal(16, 2)  default(0.0)
#  desembolso                       :boolean         default(FALSE)
#  cambio_tasa                      :boolean         default(FALSE)
#  abono_extraordinario             :boolean         default(FALSE)
#  monto_desembolso                 :decimal(16, 2)  default(0.0)
#  monto_abono                      :decimal(16, 2)  default(0.0)
#  dias_mora                        :integer(2)      default(0)
#  tasa_nominal_anual               :float           default(0.0)
#  interes_desembolso               :decimal(16, 2)  default(0.0)
#  cantidad_dias                    :integer(2)      default(0)
#  pago_interes_desembolso          :decimal(16, 2)  default(0.0)
#  cancelacion_prestamo             :boolean         default(FALSE)
#  reclasificada                    :boolean         default(FALSE)
#  intereses_por_cobrar_al_30       :decimal(16, 2)  default(0.0)
#  mora_exonerada                   :decimal(16, 2)  default(0.0)
#  migrado_d3                       :boolean         default(FALSE)
#  bolivar_fuerte                   :boolean
#  fecha_ultima_mora                :date            default(Mon, 01 Jan 1900)
#  interes_ord_devengado_mes        :decimal(16, 2)  default(0.0)
#  fecha_ord_devengado              :date
#  interes_ord_devengado_acum       :decimal(16, 2)  default(0.0)
#  ajuste_devengo                   :decimal(16, 2)  default(0.0)
#  pago_total_cliente               :decimal(16, 2)  default(0.0)
#  cuota_extra                      :decimal(16, 2)  default(0.0)
#  pago_cuota_extra                 :decimal(16, 2)  default(0.0)
#  interes_dif_devengado_mes        :decimal(16, 2)  default(0.0)
#

