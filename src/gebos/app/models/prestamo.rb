# encoding: utf-8

#
#
# clase: Prestamo
# autor: Diego Bertaso
# descripción: Migración a Rails 3
#

class Prestamo < ActiveRecord::Base

  COD_MICROCREDITO     = '800000'
  COD_FONDOS_AUTONOMOS = '200900'
  COD_GENERIC          = '000000'

  self.table_name = 'prestamo'

  attr_accessible :id,:numero,:monto_solicitado,:monto_aprobado,:fecha_aprobacion,:formula_id,:tasa_fija,:tasa_id,:diferencial_tasa,:tasa_referencia_inicial,:plazo,:meses_fijos_sin_cambio_tasa,:meses_gracia_si,:meses_gracia,:meses_muertos_si,:meses_muertos,:cliente_id,:tipo_credito_id,:oficina_id,:solicitud_id,:estatus,:tasa_mora_id,:forma_calculo_intereses,:base_calculo_intereses,:permitir_abonos,:abono_forma,:abono_porcentaje,:abono_cantidad_cuotas,:abono_monto_minimo,:abono_lapso_minimo,:abono_dias_vencimiento,:exonerar_intereses_mora,:base_cobro_mora,:diferir_intereses,:exonerar_intereses_diferidos,:frecuencia_pago,:tasa_valor,:exonerar_intereses,:numero_veces_mora,:fecha_cambio_estatus,:tasa_inicial,:tasa_vigente,:dia_facturacion,:estatus_desembolso,:saldo_insoluto,:interes_vencido,:dias_mora,:monto_mora,:causado_no_devengado,:interes_diferido_vencido,:remanente_por_aplicar,:cantidad_cuotas_vencidas,:monto_cuotas_vencidas,:deuda,:exigible,:capital_vencido,:fecha_revision_tasa,:porcentaje_riesgo_foncrei,:porcentaje_riesgo_intermediario,:porcentaje_tasa_foncrei,:porcentaje_tasa_intermediario,:frecuencia_pago_intermediario,:intermediado,:entidad_financiera_id,:interes_desembolso_vencido,:destinatario,:fecha_cobranza_intermediario,:tasa_cero,:monto_liquidado,:fecha_liquidacion,:liberada,:causa_liberacion,:aumento_capital,:reestructurado,:prestamo_origen_id,:prestamo_destino_id,:traslado_origen,:traslado_destino,:tasa_forzada,:tasa_forzada_fecha_vigencia,:tasa_forzada_monto,:fecha_inicio,:fecha_ultimo_cierre,:migrado_d3,:codigo_d3,:interes_diferido_por_vencer,:capital_pago_parcial,:saldo_capital,:meses_diferidos,:senal_visita,:numero_d3,:porcentaje_riesgo_sudeban,:clasificacion_riesgo_sudeban,:conversion_cuotas_mensuales_sudeban,:provision_individual_sudeban,:porcentaje_riesgo_bandes,:clasificacion_riesgo_bandes,:conversion_cuotas_mensuales_bandes,:provision_individual_bandes,:fecha_base,:ultimo_desembolso,:codigo_contable,:banco_origen,:tipo_cartera_id,:abono_capital,:dias_demorado,:dias_vencido,:dias_vigente,:cuotas_pagadas,:cuotas_pendientes,:cuotas_especiales_pagadas,:cuotas_especiales_vencidas,:cuotas_especiales_pendientes,:capital_pagado,:capital_por_pagar,:intereses_pagados,:mora_pagada,:tipo_diferimiento,:porcentaje_diferimiento,:consolidar_deuda,:pago_mora_migracion,:cuotas_pagadas_migracion,:monto_banco,:monto_insumos,:fecha_vencimiento,:monto_cuota,:monto_cuota_gracia,:rubro_id,:producto_id,:monto_sras_primer_ano,
  :monto_sras_anos_subsiguientes,
  :monto_sras_total,
  :monto_facturado,
  :monto_despachado,
  :fecha_instruccion_pago,
  :instruccion_pago,
  :monto_inventario,
  :monto_liquidado_insumos,
  :sub_rubro_id,
  :actividad_id,
  :monto_gasto_total,
  :moneda_id,
  :cantidad_veces_mora,
  :cantidad_veces_vigente,
  :cantidad_dias_mora_acumulados,
  :cantidad_compromisos_incumplidos,
  :empresa_cobranza_id,
  :tasa_conversion,
  :fecha_tasa_conversion,
  :valor_moneda_nacional,
  :porcentaje_veces_mora,
  :porcentaje_dias_mora,
  :indice_morosidad,
  :porcentaje_recuperacion_real_capital,
  :porcentaje_recuperacion_esperada_capital,
  :capital_cuotas_fecha,
  :desviacion_recuperacion_capital,
  :dias_atraso_promedio,
  :porcentaje_recuperacion_real_intereses,
  :total_interes,
  :porcentaje_recuperacion_esperado_intereses,
  :interes_cuota_fecha,
  :desviacion_recuperacion_intereses,
  :porcentaje_pagos_incumplidos,
  :cantidad_intentos,
  :interes_vencido_f,
  :saldo_insoluto_f,
  :fecha_revision_tasa_f,
  :solicitud,
  :oficina,
  :producto,
  :plan_inversion,
  :analista_cobranzas_id

  belongs_to :solicitud
  belongs_to :producto
  belongs_to :cliente
  belongs_to :tipo_credito
  belongs_to :oficina
  belongs_to :formula
  belongs_to :tasa
  belongs_to :partida
  belongs_to :entidad_financiera
  belongs_to :tasa_mora, :class_name=>'Tasa'
  belongs_to :prestamo_origen, :class_name=>'Prestamo', :foreign_key =>'prestamo_origen_id'
  belongs_to :prestamo_destino, :class_name=>'Prestamo', :foreign_key =>'prestamo_destino_id'
  belongs_to :tipo_cartera
  belongs_to :moneda
  belongs_to :analista_cobranzas

  has_many :prestamo, :class_name=>'Prestamo'
  has_many :desembolsos, :class_name=>'Desembolso'
  has_many :planes_pago, :class_name=>'PlanPago'
  has_many :prestamo_rubros, :class_name=>'PrestamoRubro'

  validates :numero, :uniqueness => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.numero')} #{I18n.t('Sistema.Body.Vistas.General.prestamo')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"}

  validates :producto, :presence => {:message => "#{I18n.t('Sistema.Body.General.producto')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :cliente, :presence => {:message => "#{I18n.t('Sistema.Body.General.cliente')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :solicitud, :presence => {:message => "#{I18n.t('Sistema.Body.General.solicitud')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :tipo_credito, :presence => {:message => "#{I18n.t('Sistema.Body.General.tipo_credito')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :oficina, :presence => {:message => "#{I18n.t('Sistema.Body.General.oficina')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :tasa, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.tasa')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :tasa_mora_id, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.tasa_mora')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :monto_solicitado, :numericality => {:numericality => true, :message => "#{I18n.t('Sistema.Body.Vistas.General.monto_solicitado')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_numerico')}"}

  validates :tasa_inicial, :numericality => {:message => "#{I18n.t('Sistema.Body.Modelos.Prestamo.Columnas.tasa_inicial')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_numerico')}"}

  validates :monto_aprobado, :numericality => {:numericality => true, :message => "#{I18n.t('Sistema.Body.Modelos.Prestamo.Columnas.monto_aprobado')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_numerico')}"}

  validates :monto_liquidado, :numericality => {:numericality => true, :message => "#{I18n.t('Sistema.Body.Modelos.Prestamos.Columnas.monto_liquidado')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_numerico')}"}

  validates :aumento_capital, :numericality => {:numericality => true, :message => "#{I18n.t('Sistema.Body.Modelos.Prestamo.Columnas.aumento_capital')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_numerico')}"}

  validates :abono_porcentaje, :numericality => {:numericality => true,:message => "#{I18n.t('Sistema.Body.Modelos.Prestamo.Columnas.abono_porcentaje')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_numerico')}"}

  validates :abono_monto_minimo, :numericality => {:numericality => true, :message => "#{I18n.t('Sistema.Body.Modelos.Prestamo.Columnas.abono_monto_minimo')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_numerico')}"}

  validates :tasa_vigente, :numericality => {:numericality => true, :message => "#{I18n.t('Sistema.Body.Modelos.Prestamo.Columnas.tasa_vigente')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_numerico')}"}

  validates :saldo_insoluto, :numericality => {:numericality => true, :message => "#{I18n.t('Sistema.Body.Modelos.PlanPagoCuota.Columnas.saldo_insoluto')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_numerico')}"}

  validates :interes_vencido, :numericality => {:numericality => true, :message => "#{I18n.t('Sistema.Body.Modelos.PlanPagoCuota.Columnas.interes_vencido')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_numerico')}"}, :allow_nil => true

  validates :monto_mora, :numericality => {:numericality => true, :message => "#{I18n.t('Sistema.Body.Modelos.Prestamo.Columnas.monto_mora')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_numerico')}"}, :allow_nil => true

  validates :causado_no_devengado, :numericality => {:numericality => true,  :message => "#{I18n.t('Sistema.Body.Modelos.PlanPagoCuota.Columnas.causado_no_devengado')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_numerico')}"}, :allow_nil => true

  validates :remanente_por_aplicar, :numericality => {:numericality => true, :message => "#{I18n.t('Sistema.Body.Modelos.PlanPagoCuota.Columnas.remanente_por_aplicar')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_numerico')}"}, :allow_nil => true

  validates :monto_cuotas_vencidas, :numericality => {:numericality => true, :message => "#{I18n.t('Sistema.Body.Modelos.Prestamo.Columnas.monto_cuotas_vencidas')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_numerico')}"}, :allow_nil => true

  validates :deuda, :numericality => {:message => "#{I18n.t('Sistema.Body.Modelos.Prestamo.Columnas.deuda')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_numerico')}"}, :allow_nil => true

  validates :exigible, :numericality => {:numericality => true, :message => "#{I18n.t('Sistema.Body.Modelos.Prestamo.Columnas.exigible')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_numerico')}"}, :allow_nil => true

  validates :frecuencia_pago, :numericality => {:only_integer => true,
    :message => "#{I18n.t('Sistema.Body.Modelos.PlanPago.Columnas.frecuencia_pago')} #{I18n.t('Sistema.errors.messages_not_an_integer')}"}

  validates :dia_facturacion, :numericality => {:only_integer => true,
    :message => "#{I18n.t('Sistema.Body.Modelos.Prestamo.Columnas.dia_facturacion')} #{I18n.t('Sistema.errors.messages_not_an_integer')}"}

  validates  :plazo, :numericality => {:only_integer => true,
    :message => "#{I18n.t('Sistema.Body.Modelos.PlanPago.Columnas.plazo')} #{I18n.t('Sistema.errors.messages_not_an_integer')}"}

  validates :meses_gracia, :numericality => {:only_integer => true,
    :message => "#{I18n.t('Sistema.Body.Modelos.PlanPago.Columnas.meses_gracia')} #{I18n.t('Sistema.errors.messages_not_an_integer')}", :allow_nil => true}

  validates :meses_muertos, :numericality => {:only_integer => true,
    :message => "#{I18n.t('Sistema.Body.Modelos.PlanPago.Columnas.meses_gracia')} #{I18n.t('Sistema.errors.messages_not_an_integer')}", :allow_nil => true}

  validates  :abono_cantidad_cuotas, :numericality => {:only_integer => true,
    :message => "#{I18n.t('Sistema.Body.Modelos.Prestamo.Columnas.abono_cantidad_cuotas')} #{I18n.t('Sistema.errors.messages_not_an_integer')}", :allow_nil => true}

  validates :abono_lapso_minimo, :numericality => {:only_integer => true,
    :message => "#{I18n.t('Sistema.Body.Modelos.Prestamo.Columnas.abono_lapso_minimo')} #{I18n.t('Sistema.errors.messages_not_an_integer')}", :allow_nil => true}

  validates :meses_fijos_sin_cambio_tasa, :numericality => {:only_integer=> true,
    :message => "#{I18n.t('Sistema.Body.Modelos.Producto.Columnas.meses_fijos_sin_cambio_tasa')} #{I18n.t('Sistema.errors.messages_not_an_integer')}", :allow_nil => true}

  validates :base_calculo_intereses, :numericality => {:only_integer=> true,
    :message => "#{I18n.t('Sistema.Body.Modelos.Prestamo.Columnas.base_calculo_intereses')} #{I18n.t('Sistema.errors.messages_not_an_integer')}"}

  validates :cantidad_cuotas_vencidas, :numericality => {:only_integer=> true,
    :message => "#{I18n.t('Sistema.Body.Modelos.Prestamo.Columnas.cantidad_cuotas_vencidas')} #{I18n.t('Sistema.errors.messages_not_an_integer')}"}


  attr_accessor :actualizando_plan

  attr_accessible :monto_pago

  attr_accessor :codigo_contable_1, :codigo_contable_2

  after_initialize :after_initialize, :on => :create

  def self.search_pv(conditions, page, sort, joins)
   # Paginación de prestamos vencidos

    unless conditions.nil?

      paginate  :per_page => @records_by_page,
                :page => page,
                :conditions => conditions,
                :order => sort,
                :include => :moneda,
                :joins => joins
    else

      paginate  :per_page => @records_by_page,
                :page => page,
                :order => sort,
                :include => :moneda,
                :joins => joins

   end

  end

  def self.search(search, page, sort, sql, seleccion)

    unless search.nil?
      paginate  :per_page => @records_by_page,
                :page => page,
                :conditions => search,
                :order => sort,
                :joins => sql
                #:select => seleccion
    else
      paginate  :per_page => @records_by_page,
                :page => page,
                :order => sort,
                :joins => sql
                #:select => seleccion

    end

  end

  def self.search_pagos(search, page, sort, sql, select, incluir)

    unless search.nil?
      paginate  :per_page => @records_by_page,
                :page => page,
                :conditions => search,
                :order => sort,
                :include => incluir,
                :joins => sql,
                :select => select
    else
      paginate  :per_page => @records_by_page,
                :page => page,
                :order => sort,
                :include => incluir,
                :joins => sql,
                :select => select

    end

  end


  def self.search_excedente_arrime(search, page, sort)
    paginate :per_page => @records_by_page,
      :page => page,
      :conditions => search,
      :order => sort,
      :include => :solicitud,
      :select=>'prestamo.id, prestamo.rubro_id, solicitud.numero, prestamo.numero, prestamo.cliente_id, prestamo.remanente_por_aplicar, solicitud.sector_id, prestamo.solicitud_id'
  end

  def fecha_ultima_cuota_pagada

   plan_pago_cuota =  PlanPagoCuota.find(:first, :conditions => "estatus_pago = 'T' AND plan_pago_id IN (select id from plan_pago WHERE prestamo_id = #{self.id})", :order => 'numero desc')

   return plan_pago_cuota.fecha_f

  end


  def monto_para_desembolso
    monto = Desembolso.sum('monto', :conditions=>'realizado = false and prestamo_id = '+ self.id.to_s)
  end

  def monto_para_desembolso_fm

    format_fm(self.monto_para_desembolso)
  end

  def monto_pago_fm

    format_fm(@monto_pago)

  end

  def monto_pago_fm=(valor)
    @monto_pago = format_valor(valor)
  end

  def periodo_actual
    fecha_actual = Time.now
    fecha_sql = fecha_actual.year.to_s + "/" + fecha_actual.month.to_s + "/" +fecha_actual.day.to_s
    cuota = PlanPagoCuota.find_by_sql("select * from plan_pago_cuota where plan_pago_id in (select id from plan_pago where prestamo_id = #{self.id} and activo = true and proyeccion = false) and fecha >= '#{fecha_sql}'").first
    if cuota
      return cuota.tipo_cuota
    else
      return 'N'
    end

  end

  def proyeccion_saldo_insoluto_fm

    format_fm(self.proyeccion_saldo_insoluto)

  end

  def proyeccion_interes_diferido_vencido_fm

    format_fm(self.proyeccion_interes_diferido_vencido)

  end

  def proyeccion_interes_desembolso_vencido_fm

    format_fm(self.proyeccion_interes_desembolso_vencido)

  end

  def proyeccion_monto_mora_fm

    format_fm(self.proyeccion_monto_mora)

  end

  def proyeccion_interes_vencido_fm

    format_fm(self.proyeccion_interes_vencido)

  end

  def proyeccion_causado_no_devengado_fm

    format_fm(self.proyeccion_causado_no_devengado)

  end

  def proyeccion_remanente_por_aplicar_fm

    format_fm(self.proyeccion_remanente_por_aplicar)

  end


  def proyeccion_deuda_fm

    format_fm(self.proyeccion_deuda)

  end

  def proyeccion_capital_vencido_fm

    format_fm(self.proyeccion_capital_vencido)

  end

  def proyeccion_exigible_fm

    format_fm(self.proyeccion_exigible)

  end

  def traslado_origen_fm

    format_fm(self.traslado_origen)

  end

  def traslado_destino_fm

    format_fm(self.traslado_destino)

  end

  def partida_and_numero
    return self.producto.partida.nombre + " - " + self.numero.to_s
  end

  def destinatario_w
    case self.destinatario
      when 'E'
        I18n.t('Sistema.Body.Genral.empresa')
      when 'C'
        I18n.t('Sistema.Body.Genral.cooperativa')
    end
  end

  def tasa_vigente_fm

    format_fm(self.tasa_vigente)

  end

  def tasa_inicial_fm

    format_fm(self.tasa_inicial)

  end

  def tasa_mora_fm

    format_fm(self.tasa_inicial)

  end

  def interes_vencido_mas_causado_no_devengado
    return self.interes_vencido +  self.causado_no_devengado
  end

  def interes_vencido_mas_causado_no_devengado_fm

    format_fm(self.interes_vencido_mas_causado_no_devengado)

  end

  def saldo_insoluto_menos_capital_vencido
    return self.saldo_insoluto - self.capital_vencido
  end

  def saldo_insoluto_menos_capital_vencido_fm

    format_fm(self.saldo_insoluto_menos_capital_vencido)

  end

  def diferencia_plan_inversion

   diferencia = 0
   rubros = PrestamoRubro.sum("aporte_foncrei", :conditions=>"prestamo_id = "+self.id.to_s)
   if rubros.nil?
    rubros = 0
   end
   diferencia = self.monto_solicitado - rubros
   return diferencia

  end

  def diferencia_plan_inversion_fm

    format_fm(self.diferencia_plan_inversion)

  end

  def cantidad_desembolsos

   return self.desembolsos.count()

  end

  def porcentaje_diferimiento_f=(valor)


    self.porcentaje_diferimiento = format_valor(valor)

  end

  def porcentaje_diferimiento_f

    format_f(self.porcentaje_diferimiento)

  end

  def frecuencia_pago_intermediario_w

    case self.frecuencia_pago_intermediario
      when 1
        'Mensual'
      when 3
        'Trimestral'
      when 6
        'Semestral'
      when 12
        'Anual'
    end
  end

  def tasa_fija_w

    case self.tasa_fija
      when true
        'Tasa Fija'
      when false
        'Tasa Variable'
    end

  end

  def aumento_capital_f

    format_f(self.aumento_capital)

  end

  def aumento_capital_fm

    format_fm(self.aumento_capital)

  end

  def fecha_revision_tasa_f=(fecha)
    self.fecha_revision_tasa = fecha
  end

  def fecha_revision_tasa_f
    format_fecha(self.fecha_revision_tasa)
  end

  def fecha_liquidacion_f=(fecha)
    self.fecha_liquidacion = fecha
  end

  def fecha_inicio_f=(fecha)
    self.fecha_inicio = fecha
  end

  def fecha_inicio_f
    format_fecha(self.fecha_inicio)
  end

  def fecha_liquidacion_f
    format_fecha(self.fecha_liquidacion)
  end

  def tasa_vigente_f=(valor)
    self.tasa_vigente = format_valor(valor)
  end

  def tasa_vigente_f

    format_f(self.tasa_vigente)

  end

  def porcentaje_riesgo_foncrei_f=(valor)
    self.porcentaje_riesgo_foncrei = format_valor(valor)
  end

  def porcentaje_riesgo_foncrei_f

    format_f(self.porcentaje_riesgo_foncrei)

  end

  def porcentaje_riesgo_foncrei_fm

    format_fm(self.porcentaje_riesgo_foncrei)

  end

  def porcentaje_riesgo_intermediario_f=(valor)

    self.porcentaje_riesgo_intermediario = format_valor(valor)
  end

  def porcentaje_riesgo_intermediario_f

    format_f(self.porcentaje_riesgo_intermediario)

  end

  def porcentaje_riesgo_intermediario_fm

    format_fm(self.porcentaje_riesgo_intermediario)

  end

  def porcentaje_tasa_foncrei_f=(valor)

    self.porcentaje_tasa_foncrei = format_valor(valor)
  end

  def porcentaje_tasa_foncrei_f

    format_f(self.porcentaje_tasa_foncrei)

  end

  def porcentaje_tasa_foncrei_fm

    format_fm(self.porcentaje_tasa_foncrei)

  end

  def porcentaje_tasa_intermediario_f=(valor)
    self.porcentaje_tasa_intermediario = format_valor(valor)
  end

  def porcentaje_tasa_intermediario_f

    format_f(self.porcentaje_tasa_intermediario)

  end

  def porcentaje_tasa_intermediario_fm

    format_fm(self.porcentaje_tasa_intermediario)

  end

  def total_rubros

    monto = PrestamoRubro.sum('aporte_foncrei', :conditions=>"prestamo_id=#{self.id}")
    if monto.nil?
      0
    else
      monto
    end
  end

  def rubros_total_aporte_propio

    monto = PrestamoRubro.sum('aporte_propio', :conditions=>"prestamo_id=#{self.id}")
    if monto.nil?
      0
    else
      monto
    end
  end

  def rubros_total_aporte_propio_fm

    format_fm(self.rubros_total_aporte_propio)

  end

  def rubros_total_aporte_propio_ejecutado
    monto = PrestamoRubro.sum('aporte_propio_ejecutado', :conditions=>"prestamo_id=#{self.id}")
    if monto.nil?
      0
    else
      monto
    end
  end

  def rubros_total_aporte_propio_ejecutado_fm

    format_fm(self.rubros_total_aporte_propio_ejecutado)

  end

  def rubros_total_aporte_propio_por_ejecutar
    monto = PrestamoRubro.sum('aporte_propio_por_ejecutar', :conditions=>"prestamo_id=#{self.id}")
    if monto.nil?
      0
    else
      monto
    end
  end

  def rubros_total_aporte_propio_por_ejecutar_fm

    format_fm(self.rubros_total_aporte_propio_por_ejecutar)

  end

  def rubros_total_aporte_foncrei
    monto = PrestamoRubro.sum('aporte_foncrei', :conditions=>"prestamo_id=#{self.id}")
    if monto.nil?
      0
    else
      monto
    end
  end

  def rubros_total_aporte_foncrei_fm

    format_fm(self.rubros_total_aporte_foncrei)

  end

  def rubros_total_otras_fuentes
    monto = PrestamoRubro.sum('otras_fuentes', :conditions=>"prestamo_id=#{self.id}")
    if monto.nil?
      0
    else
      monto
    end
  end

  def rubros_total_empresa_otras_fuentes
    monto = PrestamoRubro.sum('otras_fuentes', :conditions=>"prestamo_id=#{self.id} ")
    if monto.nil?
      0
    else
      monto
    end
  end

  def rubros_total_otras_fuentes_fm

    format_fm(self.rubros_total_otras_fuentes)

  end

  def rubros_total_valor_total

    monto = PrestamoRubro.sum('valor_total', :conditions=>"prestamo_id=#{self.id}")
    if monto.nil?
      0
    else
      monto
    end
  end

  def rubros_total_valor_total_fm

    format_fm(self.rubros_total_valor_total)

  end

  def calcular_mora(fecha)

    begin
      transaction do
        params = {
          :prestamo_id=>self.id,
          :fecha_evento=>fecha}
        execute_sp('calcular_mora', params.values_at(
          :prestamo_id,
          :fecha_evento))
        return true
      end
    rescue => detail
      self.errors.add(:prestamo, detail.message + detail.backtrace.to_s )
      return false
    end
  end

  def calcular_prestamo(fecha, inicial)

    begin
      transaction do
        params = {
          :prestamo_id=>self.id,
          :fecha_evento=>fecha,
          :inicial=>inicial}
        execute_sp('calcular_prestamo', params.values_at(
          :prestamo_id,
          :fecha_evento,
          :inicial))
        return true
      end
    rescue => detail
      errors.add(:prestamo, detail.message + detail.backtrace.to_s )
      return false
    end
  end

  def self.calcular_cartera(fecha, oficina_id)

    begin
      transaction do
        params = {
          :fecha=>fecha,
          :oficina_id=>oficina_id}
        execute_sp('calcular_cartera', params.values_at(
          :fecha,
          :oficina_id))
        return true
      end
    rescue => detail
      self.errors.add(:prestamo, detail.message + detail.backtrace.to_s )
      return false
    end
  end

#  metodo nuevo incluido por Diego Bertaso
#
    def self.calcular_cartera_programa(fecha, oficina_id, programa_id)

      begin
        #transaction do
          params = {
            :fecha=>fecha,
            :oficina_id=>oficina_id,
            :programa_id=>programa_id}
          execute_sp('calcular_cartera_programa', params.values_at(
            :fecha,
            :oficina_id,
            :programa_id))
          return true
        #end

      #rescue => detail
        #self.errors.add(nil, detail.message + detail.backtrace.to_s )
        #return false
      end
      #

  end

  def ejecutar_cierre_diario(fecha,id)

    logger.info "Fecha cierre: =====> " << fecha.to_s
    params = {
              :prestamo_id=>id,
              :fecha=> fecha,
              :proyeccion=>false
              }

    if self.estatus != 'L' &&
       self.estatus != 'C'

      begin

        transaction do
          execute_sp('calcular_prestamo',  params.values_at(
              :prestamo_id,
              :fecha,
              :proyeccion))
          return true
        end

      rescue => detail
        self.errors.add(:prestamo, detail.message + detail.backtrace.to_s )
        return false

      end

    end

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
    end
  end

  after_update :after_update

  def after_update
    if !self.actualizando_plan

    end
  end

  before_update :before_update

  def before_update

    if (!self.codigo_contable_1.nil? && !self.codigo_contable_2.nil?)
      self.codigo_contable = self.codigo_contable_1 + self.codigo_contable_2
    end
    if !self.actualizando_plan && !self.actualizando_plan.nil?
      if self.intermediado
        if self.frecuencia_pago_intermediario < self.frecuencia_pago
          errors.add(:prestamo, I18n.t('Sistema.Body.Modelos.Prestamo.Errores.frecuencia_mayor_que_banco_intermedia'))
          return false
        end
      end
      if self.producto.base_calculo_intereses == 365 && self.formula.id == 2
        errors.add(:prestamo, I18n.t('Sistema.Body.Modelos.Prestamo.Errores.no_puede_combinarse_metodo_con_base'))
        return false
      end
      if self.monto_solicitado > self.producto.monto_maximo
        errors.add(:prestamo, I18n.t('Sistema.Body.Modelos.Prestamo.Errores.monto_solicitado_mayor_que_permitido'))
        return false
      end
      if self.monto_solicitado < self.producto.monto_minimo
        errors.add(:prestamo, I18n.t('Sistema.Body.Modelos.Prestamo.Errores.monto_solicitado_menor_que_permitido'))
        return false
      end
      if self.plazo < self.producto.plazo_minimo
        errors.add(:prestamo, I18n.t('Sistema.Body.Modelos.Prestamo.Errores.plazo_menor_que_permitido'))
        return false
      end
      if self.plazo>self.producto.plazo_maximo
        errors.add(:prestamo, I18n.t('Sistema.Body.Modelos.Prestamo.Errores.plazo_mayor_que_permitido'))
        return false
      end
      if self.meses_muertos > self.producto.meses_muertos
        errors.add(:prestamo, I18n.t('Sistema.Body.Modelos.Prestamo.Errores.meses_muertos_mayor_que_permitido'))
        return false
      end
      if self.meses_gracia > self.producto.meses_gracia
        errors.add(:prestamo, I18n.t('Sistema.Body.Modelos.Prestamo.Errores.meses_gracia_mayor_que_permitido'))
        return false
      end
      if !self.tasa_cero

        if self.meses_fijos_sin_cambio_tasa > self.producto.meses_fijos_sin_cambio_tasa
          errors.add(:prestamo, I18n.t('Sistema.Body.Modelos.Prestamo.Errores.plazo_garantia_tasa_mayor_que_permitido'))
          return false
        end

       #if self.estatus == 'T'
          diferencial = self.tasa_referencia_inicial - self.tasa_inicial
          if diferencial > 0
            if diferencial > self.solicitud.programa.diferencial_minimo_tasa.abs
              errors.add(:prestamo, I18n.t('Sistema.Body.Modelos.Prestamo.Errores.tasa_introducida_menor_que_minimo'))
            return false
            end
          else
            if diferencial.abs > self.solicitud.programa.diferencial_maximo_tasa.abs
              errors.add(:prestamo, I18n.t('Sistema.Body.Modelos.Prestamo.Errores.tasa_introducida_menor_que_maximo'))
            return false
            end
          end
        #end

      else
        self.tasa_inicial = 0
      end
    else
      return true
    end
  end

  def valor_cuota_siguiente_no_exigible()
    cuota = self.planes_pago.find(:first,:conditions=>'activo= true and proyeccion = false').cuotas.find(:first, :conditions=>"estatus_pago = 'X'", :order=>'numero asc')
    if cuota
      return cuota.valor_cuota
    else
      return 0
    end

  end
  def saldo_insoluto_f=(valor)
    self.saldo_insoluto = format_valor(valor)
  end

  def saldo_insoluto_f
    format_f(self.saldo_insoluto)
  end

  def saldo_insoluto_total
    self.saldo_insoluto - self.capital_pago_parcial
  end

  def saldo_insoluto_total_fm

    format_fm(self.saldo_insoluto_total)

  end

  def saldo_insoluto_fm

    format_fm(self.saldo_insoluto)

  end

  def monto_sras_primer_ano_fm

    format_fm(self.monto_sras_primer_ano)

  end

  def monto_sras_anos_subsiguientes_fm

    format_fm(self.monto_sras_anos_subsiguientes)

  end

  def monto_sras_total_fm

    format_fm(self.monto_sras_total)

  end

  def monto_gasto_total_fm

    format_fm(self.monto_gasto_total)

  end

  def total_plan_inversion_fm

    unless self.monto_solicitado.nil? || self.monto_sras_total.nil?
      format_fm(self.monto_sras_total + self.monto_solicitado)
    end

  end

  def monto_banco_fm

    format_fm(self.monto_banco)

  end

  def interes_desembolso_vencido_f=(valor)
    self.interes_desembolso_vencido = format_valor(valor)
  end

  def interes_desembolso_vencido_f

    format_f(self.interes_desembolso_vencido)

  end

  def interes_desembolso_vencido_fm

    format_fm(self.interes_desembolso_vencido)

  end

  def interes_diferido_vencido_f=(valor)
    self.interes_diferido_vencido = format_valor(valor)
  end

  def interes_diferido_vencido_f

    format_f(self.interes_diferido_vencido)

  end

  def interes_diferido_vencido_fm

    format_fm(self.interes_diferido_vencido)

  end

 #M�todos incluidos por Diego Bertaso

  def interes_diferido_por_vencer_fm

    unless self.interes_diferido_por_vencer.nil? and self.interes_diferido_vencido.nil?
      format_fm((self.interes_diferido_por_vencer + self.interes_diferido_vencido))
    end

  end

  def capital_pago_parcial_fm

    format_fm(self.capital_pago_parcial)

  end

  #Fin de M�todos incluidos por Diego Bertaso

  def interes_vencido_f=(valor)
    self.interes_vencido = format_valor(valor)
  end

  def interes_vencido_f

    format_f(self.interes_vencido)

  end

  def interes_vencido_fm

    format_fm(self.interes_vencido)

  end

  def monto_mora_f=(valor)
    self.monto_mora = format_valor(valor)
  end

  def monto_mora_f

    format_f(self.monto_mora)

  end

  def monto_mora_fm

    format_fm(self.monto_mora)

  end

  def causado_no_devengado_f=(valor)
    self.causado_no_devengado = format_valor(valor)
  end

  def causado_no_devengado_f

    format_f(self.causado_no_devengado)

  end

  def causado_no_devengado_fm

    format_fm(self.causado_no_devengado)

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

  def monto_cuotas_vencidas_f=(valor)
    self.monto_cuotas_vencidas = format_valor(valor)
  end

  def monto_cuotas_vencidas_f

    format_f(self.monto_cuotas_vencidas)

  end

  def monto_cuotas_vencidas_fm

    format_fm(self.monto_cuotas_vencidas)

  end

  def monto_solicitado_f=(valor)
    self.monto_solicitado = format_valor(valor)
  end

  def monto_solicitado_f

    format_f(self.monto_solicitado)

  end

  def monto_solicitado_fm

    format_fm(self.monto_solicitado)

  end

  def monto_aprobado_f=(valor)
    self.monto_aprobado = format_valor(valor)
  end

  def monto_aprobado_f

    format_f(self.monto_aprobado)

  end

  def monto_aprobado_fm

    format_fm(self.monto_aprobado)

  end

  def monto_liquidado_f=(valor)
    self.monto_liquidado = format_valor(valor)
  end

  def monto_liquidado_f

    format_f(self.monto_liquidado)

  end

  def monto_liquidado_fm

    format_fm(self.monto_liquidado)

  end

  def monto_por_liquidar_fm

    format_fm(self.monto_por_liquidar)

  end

  def monto_por_liquidar
   # (self.monto_solicitado + self.aumento_capital) - self.monto_liquidado

   #(self.monto_solicitado + self.aumento_capital + self.traslado_destino) - (self.monto_liquidado+ self.traslado_origen)

    if self.solicitud.por_inventario
      self.monto_inventario - self.monto_liquidado
    else
      unless self.monto_banco.nil? || self.monto_liquidado.nil?
        if self.monto_banco == 0
          0
        else
          self.monto_banco - self.monto_liquidado
        end
      end
    end
  end


  def capital_vencido_fm

    format_fm(self.capital_vencido)

  end

  def abono_porcentaje_f=(valor)
    self.abono_porcentaje = format_valor(valor)
  end

  def abono_porcentaje_f

    format_f(self.abono_porcentaje)

  end

  def abono_monto_minimo_f=(valor)
    self.abono_monto_minimo = format_valor(valor)
  end

  def abono_monto_minimo_f

    format_f(self.abono_monto_minimo)

  end

  def abono_monto_minimo_fm

    format_fm(self.abono_monto_minimo)

  end

  def tasa_inicial_f=(valor)
    self.tasa_inicial = format_valor(valor)
  end

  def tasa_inicial_f

    format_f(self.tasa_inicial)
    sprintf('%01.2f', self.tasa_inicial).sub(I18n.t('Sistema.Body.ExpresionesRegulares.punto'), I18n.t('Sistema.Body.ExpresionesRegulares.comma')) unless self.tasa_inicial.nil?
  end

  def liquidado
    #monto_aprobado!=0 && (monto_aprobado+aumento_capital+traslado_destino)==monto_liquidado
    monto_aprobado!=0 && (monto_aprobado+aumento_capital+traslado_destino)==(monto_liquidado + monto_despachado)
  end



  def after_initialize

    if new_record?
      @monto_pago = 0

      self.aumento_capital = 0 unless self.aumento_capital
      self.traslado_destino = 0 unless self.traslado_destino
      self.traslado_origen = 0 unless self.traslado_origen

      # Se determina si la tasa se toma del regimen de propiedad o del tipo de negocio

      #parametro = ParametroGeneral.find(1)

      condiciones = CondicionesFinanciamiento.find_by_programa_id_and_actividad_id(self.solicitud.programa_id, self.solicitud.actividad_id)

      self.tasa_mora_id = 1

      self.tipo_credito = self.producto.programa.tipo_credito unless self.tipo_credito
      self.cliente = self.solicitud.cliente unless self.cliente

      unless self.tasa

        # ----------------------------------------------------------------------
        # Ajuste para ubicar la tasa segun el subrubro y no por el tipo cliente
        # Efectuado por Alexander Cioffi 18-04-2012
        # ----------------------------------------------------------------------
        tasa = Tasa.find_by_sub_rubro_id(self.solicitud.sub_rubro_id)
        @tasa_valor = TasaValor.find_by_sql("Select * from tasa_valor where tasa_id = #{tasa.id} order by id desc LIMIT 1")
        @tasa_valor = @tasa_valor[0]

        self.tasa_inicial = @tasa_valor.valor
        self.tasa_vigente = @tasa_valor.valor
        self.tasa_valor = @tasa_valor.valor
        self.tasa_referencia_inicial = @tasa_valor.valor
        self.tasa_id = tasa.id

      end

      # self.meses_fijos_sin_cambio_tasa = self.producto.meses_fijos_sin_cambio_tasa unless self.meses_fijos_sin_cambio_tasa
      self.tasa_fija = self.producto.tasa_fija unless self.tasa_fija
      self.forma_calculo_intereses = self.producto.forma_calculo_intereses unless self.forma_calculo_intereses
      self.base_calculo_intereses = self.producto.base_calculo_intereses unless self.base_calculo_intereses
      self.permitir_abonos = self.producto.permitir_abonos unless self.permitir_abonos
      self.abono_forma = self.producto.abono_forma unless self.abono_forma
      self.abono_porcentaje = self.producto.abono_porcentaje unless self.abono_porcentaje
      self.abono_cantidad_cuotas = self.producto.abono_cantidad_cuotas unless self.abono_cantidad_cuotas
      self.abono_dias_vencimiento = self.producto.abono_dias_vencimiento unless self.abono_dias_vencimiento
      self.abono_monto_minimo = self.producto.abono_monto_minimo unless self.abono_monto_minimo
      self.abono_lapso_minimo = self.producto.abono_lapso_minimo unless self.abono_lapso_minimo
      self.base_cobro_mora = self.producto.base_cobro_mora unless self.base_cobro_mora
      self.meses_gracia_si = self.producto.meses_gracia_si unless self.meses_gracia_si
      #self.diferir_intereses = self.producto.diferir_intereses unless self.diferir_intereses
      #self.exonerar_intereses_diferidos = self.producto.exonerar_intereses_diferidos unless self.exonerar_intereses_diferidos
      #self.meses_muertos_si = self.producto.meses_muertos_si unless self.meses_muertos_si

      self.meses_fijos_sin_cambio_tasa = self.producto.meses_fijos_sin_cambio_tasa unless self.meses_fijos_sin_cambio_tasa
      self.meses_muertos = self.producto.meses_muertos unless self.meses_muertos
     # self.monto_solicitado = self.producto.monto_minimo unless self.monto_solicitado
      self.monto_solicitado = 0 unless self.monto_solicitado
      self.monto_aprobado = 0 unless self.monto_aprobado
      self.monto_liquidado = 0 unless self.monto_liquidado

      self.plazo = condiciones.plazo unless condiciones.nil?
      self.meses_gracia = condiciones.periodo_gracia unless condiciones.nil?
      self.formula_id = condiciones.formula_id unless condiciones.nil?
      self.frecuencia_pago = condiciones.frecuencia_pago unless condiciones.nil?

      unless condiciones.nil?
        if condiciones.diferir_intereses
          self.meses_diferidos = self.meses_gracia
          self.porcentaje_diferimiento = 100.00
        end
      end

      self.diferir_intereses = condiciones.diferir_intereses unless condiciones.nil?

      self.meses_muertos = 0 unless self.meses_muertos
      self.tasa_vigente = 0 unless self.tasa_vigente
      self.dia_facturacion = 0 unless self.dia_facturacion
      self.estatus_desembolso = 'E' unless self.estatus_desembolso
      self.moneda_id = self.solicitud.moneda_id

      self.intermediado = self.solicitud.programa.intermediado unless self.intermediado
      self.ultimo_desembolso = self.solicitud.programa.ultimo_desembolso if self.ultimo_desembolso == 9

      self.frecuencia_pago_intermediario = self.solicitud.programa.frecuencia_pago_intermediario unless self.frecuencia_pago_intermediario
      self.porcentaje_riesgo_foncrei = self.solicitud.programa.porcentaje_riesgo_foncrei unless self.porcentaje_riesgo_foncrei
      self.porcentaje_riesgo_intermediario = self.solicitud.programa.porcentaje_riesgo_intermediario unless self.porcentaje_riesgo_intermediario
      self.porcentaje_tasa_intermediario = self.solicitud.programa.porcentaje_tasa_intermediario unless self.porcentaje_tasa_intermediario
      self.porcentaje_tasa_foncrei = self.solicitud.programa.porcentaje_tasa_foncrei unless self.porcentaje_tasa_foncrei

      self.banco_origen = self.banco_origen

  #    unless self.tasa_inicial && tasa_referencia_inicial
       unless self.tasa_inicial
        tasa_historico_list = TasaHistorico.find(:all, :order=>'id',
         :conditions=>"programa_id = #{self.solicitud.programa.id} and tasa_valor_id in (select id from tasa_valor where tasa_id = #{self.tasa.id}) ")

         #logger.info "TASA_HISTORICO_LIST ==========> " << tasa_historico_list.inspect
         unless tasa_historico_list.nil? || tasa_historico_list.empty?
          #self.tasa_inicial = tasa_historico_list.last.tasa_cliente
          self.tasa_referencia_inicial = tasa_historico_list.last.tasa_cliente
         end
       else
         #self.tasa_inicial = self.tasa_referencia_inicial
       end
    end
  end

  def estatus_desembolso_w
    case self.estatus_desembolso
      when 'C'
        I18n.t('Sistema.Body.Modelos.Desembolso.Estatus.condicionamiento_desembolso')
      when 'D'
        I18n.t('Sistema.Body.Modelos.Desembolso.Estatus.desembolso_condicionado')
      when 'S'
        I18n.t('Sistema.Body.Modelos.Desembolso.Estatus.desembolso_completado')
      when 'O'
        I18n.t('Sistema.Body.Modelos.Desembolso.Estatus.desembolso_solicitado')
    end
  end

  #se usa para mostrar el estatus del prestamo en las vistas sin necesidad de buscar el prestamo
  def self.estatus_prestamo(estatus)
    case estatus
      when 'S'
        return I18n.t('Sistema.Body.Modelos.Prestamo.Estatus.en_solicitud')
      when 'D'
        return I18n.t('Sistema.Body.Modelos.Prestamo.Estatus.en_espera_por_desembolsos')
      when 'V'
        return I18n.t('Sistema.Body.Modelos.Prestamo.Estatus.vigente')
      when 'E'
        return I18n.t('Sistema.Body.Modelos.Prestamo.Estatus.vencido')
      when 'F'
        return I18n.t('Sistema.Body.Modelos.Prestamo.Estatus.cancelado_reestructuracion')
      when 'A'
        return I18n.t('Sistema.Body.Modelos.Prestamo.Estatus.cancelado_ampliacion') #Reestructuración Financiera
      when 'L'
        return I18n.t('Sistema.Body.Modelos.Prestamo.Estatus.litigio')
      when 'C'
        return I18n.t('Sistema.Body.Modelos.Prestamo.Estatus.cancelado')
      when 'P'
        return I18n.t('Sistema.Body.Modelos.Prestamo.Estatus.vigente') # En el periodo de gracia de la mora
      when 'J'
        return I18n.t('Sistema.Body.Modelos.Prestamo.Estatus.consultoria_juridica')
      when 'H'
        return I18n.t('Sistema.Body.Modelos.Prestamo.Estatus.vigente_demorado')
      when 'K'
        return I18n.t('Sistema.Body.Modelos.Prestamo.Estatus.castigado')
    end
  end

  #se usa para mostrar el estatus del prestamo en las vistas buscando el prestamo
  def estatus_w
    case self.estatus
      when 'S'
        I18n.t('Sistema.Body.Modelos.Prestamo.Estatus.en_solicitud')
      when 'D'
        I18n.t('Sistema.Body.Modelos.Prestamo.Estatus.en_espera_por_desembolsos')
      when 'V'
        I18n.t('Sistema.Body.Modelos.Prestamo.Estatus.vigente')
      when 'E'
        I18n.t('Sistema.Body.Modelos.Prestamo.Estatus.vencido')
      when 'F'
        I18n.t('Sistema.Body.Modelos.Prestamo.Estatus.cancelado_reestructuracion') #Reestructuración Financiera
      when 'A'
        I18n.t('Sistema.Body.Modelos.Prestamo.Estatus.cancelado_ampliacion') #Reestructuración Financiera
      when 'L'
        I18n.t('Sistema.Body.Modelos.Prestamo.Estatus.litigio')
      when 'C'
        I18n.t('Sistema.Body.Modelos.Prestamo.Estatus.cancelado')
      when 'P'
        I18n.t('Sistema.Body.Modelos.Prestamo.Estatus.vigente') # En el periodo de gracia de la mora
      when 'J'
        I18n.t('Sistema.Body.Modelos.Prestamo.Estatus.consultoria_juridica') # Condición especial incluida para reestructuracion
      when 'H'
        I18n.t('Sistema.Body.Modelos.Prestamo.Estatus.vigente_demorado')
      when 'K'
        I18n.t('Sistema.Body.Modelos.Prestamo.Estatus.castigado')
     end
  end

  def proyeccion_estatus_w
    case self.proyeccion_estatus
      when 'S'
        I18n.t('Sistema.Body.Modelos.Prestamo.Estatus.en_solicitud')
      when 'D'
        I18n.t('Sistema.Body.Modelos.Prestamo.Estatus.en_espera_por_desembolsos')
      when 'V'
        I18n.t('Sistema.Body.Modelos.Prestamo.Estatus.vigente')
      when 'E'
        I18n.t('Sistema.Body.Modelos.Prestamo.Estatus.vencido')
      when 'F'
        I18n.t('Sistema.Body.Modelos.Prestamo.Estatus.cancelado_reestructuracion') #Reestructuración Financiera
      when 'A'
        I18n.t('Sistema.Body.Modelos.Prestamo.Estatus.cancelado_ampliacion') #Reestructuración Financiera
      when 'L'
        I18n.t('Sistema.Body.Modelos.Prestamo.Estatus.litigio')
      when 'C'
        I18n.t('Sistema.Body.Modelos.Prestamo.Estatus.cancelado')
      when 'P'
        I18n.t('Sistema.Body.Modelos.Prestamo.Estatus.vigente') # En el periodo de gracia de la mora
      when 'J'
        I18n.t('Sistema.Body.Modelos.Prestamo.Estatus.consultoria_juridica') # Condición especial incluida para reestructuracion
      when 'H'
        I18n.t('Sistema.Body.Modelos.Prestamo.Estatus.vigente_demorado')
      when 'K'
        I18n.t('Sistema.Body.Modelos.Prestamo.Estatus.castigado')
    end
  end

  before_validation :before_validation

  def before_validation
    if self.plazo && self.frecuencia_pago && self.plazo!=0 && self.frecuencia_pago!=0
      valor = self.plazo%self.frecuencia_pago
      if valor != 0
        errors.add(:prestamo, I18n.t('Sistema.Body.Modelos.Prestamo.Errores.plazo_no_divisible_con_frecuencia_pago'))
        return false
      end
  end
    if self.meses_gracia && self.frecuencia_pago && self.meses_gracia!=0 && self.frecuencia_pago!=0
     valor = self.meses_gracia%self.frecuencia_pago
      if valor != 0
        errors.add(:prestamo, I18n.t('Sistema.Body.Modelos.Prestamo.Errores.plazo_gracia_no_divisible_con_frecuencia_pago'))
        return false
      end
    end
    if self.intermediado
      if self.plazo && self.frecuencia_pago_intermediario && self.plazo!=0 && self.frecuencia_pago_intermediario!=0
        valor = self.plazo%self.frecuencia_pago_intermediario
        if valor != 0
          errors.add(:prestamo, I18n.t('Sistema.Body.Modelos.Prestamo.Errores.plazo_no_divisible_con_frecuencia_pago_banco_intermedia'))
          return false
        end
      end
      if self.meses_gracia && self.frecuencia_pago_intermediario && self.meses_gracia!=0 && self.frecuencia_pago_intermediario!=0
       valor = self.meses_gracia%self.frecuencia_pago_intermediario
        if valor != 0
          errors.add(:prestamo, I18n.t('Sistema.Body.Modelos.Prestamo.Errores.plazo_gracia_no_divisible_con_frecuencia_pago_banco_intermedia'))
          return false
        end
      end
    end
    if self.solicitud.programa.vinculo_tasa == 'R'
      cliente = self.solicitud.cliente
      regimen_cliente = RegimenTipoCliente.find_by_tipo_cliente_id(cliente.tipo_cliente.id)
      if regimen_cliente.nil?
          errors.add(:prestamo, "#{I18n.t('Sistema.Body.Modelos.Prestamo.Errores.regimen_propiedad_cliente_no_existe')} #{cliente.tipo_cliente.nombre}")
          return false
      end
    end
  end

  before_create :before_create

  def before_create

    sras_primer_ano = 0.00
    sras_anos_siguen = 0.00
    sras_total = 0.00
    plazo_total = 0
    sras_primer_ano = sras_primer_ano.to_d
    sras_anos_siguen = sras_anos_siguen.to_d
    sras_total = sras_anos_siguen.to_d

    ParametroGeneral.connection.execute("LOCK parametro_general in ACCESS EXCLUSIVE MODE;")
    parametro = ParametroGeneral.find(1)
    numero = parametro.numero_prestamo_inicial + 1

    parametro.numero_prestamo_inicial = numero
    parametro.save

    self.rubro_id = solicitud.rubro_id
    self.sub_rubro_id = solicitud.sub_rubro_id
    self.actividad_id = self.solicitud.actividad_id
    self.fecha_cambio_estatus = Time.now

    numero = modulo11(numero)

    self.numero = numero

    # -----------------------------------------
    # Calculo del sras
    # ---------------------rubro---------------

    factor_mensual_primer_ano = parametro.porcentaje_sras_primer_ano / 1200
    factor_mensual_anos_siguen = parametro.porcentaje_sras_anos_subsiguientes / 1200

    plazo_total = self.plazo + self.meses_gracia
    if plazo_total <= 12
      sras_primer_ano = (self.monto_solicitado * factor_mensual_primer_ano) * 12
      sras_anos_siguen = 0.00
    end

    if plazo_total > 12
      sras_primer_ano = (self.monto_solicitado * factor_mensual_primer_ano) * 12
      sras_anos_siguen = (self.monto_solicitado * factor_mensual_anos_siguen) * (plazo_total - 12)
    end

    sras_total = sras_primer_ano + sras_anos_siguen

    self.monto_sras_primer_ano = sras_primer_ano
    self.monto_sras_anos_subsiguientes = sras_anos_siguen
    self.monto_sras_total = sras_total

    logger.info "Monto sras primer ======> #{sras_primer_ano.to_s}"
    logger.info "Monto sras siguen ======> #{sras_anos_siguen.to_s}"
    logger.info "Monto sras total ======> #{sras_total.to_s}"
    
  end

  def forzar_desembolso(usuario, prestamo_coment)

    if !self.liquidado

      begin

        transaction do

          iniciar_transaccion(self.id, 'p_forzar_desembolso_aplicado', 'L', "#{I18n.t('Sistema.Body.Modelos.Prestamo.Transacciones.desembolso')} #{self.numero}", usuario.id, self.monto_liquidado)

          prestamo_comentario = PrestamoComentario.new(prestamo_coment)
          prestamo_comentario.prestamo_id = self.id
          prestamo_comentario.fecha_aplicacion = Time.now.strftime("%Y-%m-%d")
          prestamo_comentario.usuario_id = usuario.id

          prestamo_comentario.save

          self.ultimo_desembolso = 0
          solicitud = self.solicitud

          solicitud.estatus = 'Q'
          solicitud.estatus_id = 10110    # liquidado Total
          solicitud.save

          a = self.save

          self.errors.add_errors_with_raise(self.errors) unless a

          #Se forza una transaccion dummy para resolver problemas del reverso
          #
          iniciar_transaccion(self.id, 'p_dummy', 'L', "Transaccion Dummy #{self.numero}", usuario.id, 0)

          return a

        end
          rescue => detail
          self.errors.add(:prestamo, detail.message)
          return false
      end

    end

  end

  def actualizar_datos_cobranza (tipo_cartera)
    success = true
    begin
       transaction do

        self.tipo_cartera_id = tipo_cartera

        desembolso = self.desembolsos.find_by_realizado(false)

        if self.tipo_cartera_id.nil?
          errors.add(:prestamo, I18n.t('Sistema.Body.Modelos.Prestamo.Errores.debe_seleccionar_tipo_cartera'))
          success = false
        end

        raise Exception, I18n.t('Sistema.Body.General.Excepciones.datos_invalidos') unless success
        success &&= self.save!
        raise Exception, I18n.t('Sistema.Body.General.Excepciones.error_guardando_solicitud') unless success
        success &&= desembolso.save!
        raise Exception, I18n.t('Sistema.Body.General.Excepciones.error_guardando_desembolso') unless success
        return success
      end
    rescue Exception => e
      #logger.error e.messages
      #logger.error e.backtrace.join("\n")
      return false
    end
  end

  def liquidar(desembolso, params_desembolso_pago, usuario_id, orden_despacho)

    if orden_despacho.nil?
      monto_insumos = 0.00
    else
      monto_insumos = orden_despacho.monto
      fecha_aplicacion = Time.now.strftime("%Y-%m-%d")
      logger.info "Monto Orden =====> #{orden_despacho.monto.to_s}, #{monto_insumos.to_s}"
    end

    if desembolso.nil?
      monto_desembolso = 0.00
      desembolso_id = 0
    else
      monto_desembolso = desembolso.monto
      fecha_aplicacion = desembolso.fecha_valor
      desembolso_id = desembolso.id

    end

    if self.liquidado
      self.errors.add(:prestamo, I18n.t('Sistema.Body.Modelos.Prestamo.Errores.prestamo_liquidado'))
      return false

    else

      begin

        self.solicitud.usuario = @usuario
        self.solicitud.ip_address = @ip_address

        unless params_desembolso_pago.nil? || params_desembolso_pago.length < 1

          self.errors.add_errors_with_raise(desembolso.errors) unless desembolso.save_all(params_desembolso_pago)

        else


        end

        a = false

        inicial = self.estatus=='S'
        self.estatus='V'

        #Se determina si es el desembolso inicial
        plan_pago = PlanPago.find_by_prestamo_id_and_activo(self.id, true)

        if plan_pago.nil?

          # Primer Desembolso

          #fecha_aplicacion = desembolso.fecha_valor
          logger.info "Fecha Aplicacion -------------> % " << fecha_aplicacion.to_s
          self.fecha_liquidacion = fecha_aplicacion
          self.monto_liquidado = self.monto_liquidado + monto_desembolso
          self.monto_liquidado_insumos = self.monto_liquidado_insumos + monto_insumos

        else

          # Siguientes Desembolsos

          #fecha_aplicacion = desembolso.fecha_valor
          self.fecha_liquidacion = fecha_aplicacion
          self.monto_liquidado = self.monto_liquidado + monto_desembolso
          self.monto_liquidado_insumos = self.monto_liquidado_insumos + monto_insumos

        end

        unless desembolso.nil?
          desembolso.prestamo = self
          desembolso.realizado = true
          desembolso.save
        end

        if !orden_despacho.nil?
          orden_despacho.realizado = true
          orden_despacho.save
        end

        self.estatus_desembolso = 'E'

        begin
          a = self.save
        rescue Exception => e
          logger.error e.message
          logger.error e.backtrace.join("\n")
          return false
        end

        self.errors.add_errors_with_raise(self.errors) unless a

        if plan_pago.nil?

          logger.info "--------------------------- PASO NUMERO 6"

          logger.info "Prestamo monto liquidado antes  ----> " << self.monto_liquidado.to_s
          #logger.info "Fecha Aplicacion =====> " << desembolso.fecha_aplicacion_f
          monto_liquidacion = monto_desembolso + self.monto_sras_total + monto_insumos + self.monto_gasto_total
          generar_plan_pago_inicial(monto_liquidacion, fecha_aplicacion, desembolso_id, monto_desembolso, self.monto_sras_total, monto_insumos)
          self.saldo_insoluto += monto_liquidacion
          a = self.save

          #registrar_acumulados(self.monto_liquidado)


        else

          logger.info "--------------------------- PASO NUMERO 7"
          monto_liquidacion = monto_desembolso + monto_insumos
          generar_plan_pago_desembolso(monto_liquidacion, fecha_aplicacion, desembolso_id, monto_desembolso, 0.00, monto_insumos)
          self.saldo_insoluto += monto_liquidacion
          a = self.save

          #registrar_acumulados(desembolso.monto)

        end

        up = UnidadProduccion.find(self.solicitud.unidad_produccion_id)

        begin
          unless up.nil?
            ciudad = Ciudad.find(up.ciudad_id)

            unless ciudad.nil?
              estado = Estado.find(ciudad.estado_id)

              unless estado.nil?
                if monto_desembolso > 0

                  pidan = PresupuestoPidan.find_by_programa_id_and_estado_id_and_rubro_id_and_sub_rubro_id(self.solicitud.programa_id,
                                                                                                         estado.id,
                                                                                                         self.solicitud.rubro_id,
                                                                                                         self.solicitud.sub_rubro_id)
                  unless pidan.nil?

                    pidan.monto_liquidado += monto_desembolso
                    pidan.monto_por_liquidar = self.monto_banco - pidan.monto_liquidado
                    pidan.save
                  end
                end
              end
            end
          end
        rescue => e
          logger.info "Error lectura de unidad produccion"
          raise ActiveRecord::Rollback
        end
        logger.info "--------------------------- PASO NUMERO 8"


        #Se forza una transaccion dummy para resolver problemas del reverso
        #

        if self.tipo_diferimiento
          self.porcentaje_diferimiento = 100
        end

        logger.debug "Monto banco ======> " << self.monto_banco_fm
        logger.debug "Monto liquidado ======> " << self.monto_liquidado_fm
        if self.monto_banco_fm == self.monto_liquidado_fm and
           self.monto_insumos_fm == self.monto_liquidado_insumos_fm
          #Liquidado total
          solicitud = self.solicitud
          solicitud.estatus_id = 10110   # Liquidación total
          solicitud.save
        else
          self.estatus_desembolso = 'T'
          solicitud = self.solicitud
          solicitud.estatus_id = 10100  # Liquidación Parcial
          solicitud.save
          self.save
        end

        logger.info 'termino'
        logger.info a.inspect
        logger.info desembolso.inspect

        return a

        #
        #====================================================
        # AQUI VA LA LLAMADA DEL CAUSADO Y PAGADO PARA SIGA
        #====================================================
        #

      rescue => detail

        logger.info "PASA POR EL RESCUE " << detail.message
        self.errors.add(nil, detail.message)
        logger.info detail.backtrace.join("\n")
				raise ActiveRecord::Rollback
        return false

      end
    end
  end

  def validar(prestamo_id, fecha_liquidacion, numero_cheque)
    msj = ""

    #------------------------------------------
    # Se valida que el número del cheque no
    # este vacio y que no este registrado
    # para la misma entidad financiera
    #------------------------------------------

    desembolso = Desembolso.find_by_prestamo_id_and_realizado(prestamo_id.id,false)
    prestamo = Prestamo.find(prestamo_id.id)
    solicitud = Solicitud.find(prestamo.solicitud_id)

    if numero_cheque.empty?

      msj << "<li>#{I18n.t('Sistema.Body.Modelos.Prestamo.Errores.numero_cheque_obligatorio')}: #{solicitud.numero.to_s}.</li>"
    else

      if desembolso.nil?
        msj << "<li>#{I18n.t('Sistema.Body.Modelos.Prestamo.Errores.desembolso_no_existe')}: #{solicitud.numero.to_s}.</li>"
      else

        desembolso_referencia = Desembolso.find_by_prestamo_id_and_entidad_financiera_id_and_referencia(prestamo_id.id,desembolso.entidad_financiera_id,numero_cheque)

        if !desembolso_referencia.nil?

           msj << "<li>#{I18n.t('Sistema.Body.Modelos.Prestamo.Errores.numero_cheque_registrado')}: #{solicitud.numero.to_s}.</li>"
        end
      end

    end

    #------------------------------------------
    # Se valida que la fecha de liquidación no
    # este vacia y que esta sea válida
    #------------------------------------------

    if fecha_liquidacion.nil?
      msj << "<li>#{I18n.t('Sistema.Body.Modelos.Prestamo.Errores.fecha_liquidacion_invalida')}: #{solicitud.numero.to_s}.</li>"
    else

      begin

      rescue Exception => e
        msj << "<li>#{I18n.t('Sistema.Body.Modelos.Prestamo.Errores.fecha_liquidacion_invalida')}: #{solicitud.numero.to_s}.</li>"
      end
    end

    if msj.length > 0
      return msj
    else
      return ''
    end
  end

  def registrar_cheque(params,usuario_id)

    #--------------------------------------------------------
    # Método para registrar el número del cheque
    # en el desembolso y generar la tabla de amortización
    # de 1 o varios prestamos según selección del usuario
    #---------------------------------------------------------

    id = params[:prestamos_id]
    id = id[0,(id.length-1)]
    ids = id.split(',')
    numeros = ''
    monto_desembolso = 0.00
    monto_insumos = 0.00
    ids.each do |prestamo_id|

      prestamo = Prestamo.find(prestamo_id)
      numeros << prestamo.numero.to_s << ','
    end

    numeros = numeros.slice(0,(numeros.length - 1))

    monto_desembolso = Desembolso.sum('monto', :conditions=>"prestamo_id in (#{id}) and realizado = false")
    monto_insumos = OrdenDespacho.sum('monto', :conditions=>"prestamo_id in (#{id}) and realizado = false and estatus_id = 20000")
    prestamos = Prestamo.find(:all, :conditions=>"id in (#{id})")

    if monto_insumos.nil?
      monto_insumos = 0.00
    end

    monto_sras = 0.00

    if !prestamos.empty?

      prestamos.each do |p|

        plan = PlanPago.find_by_prestamo_id_and_activo(p.id,true)

        if plan.nil?
          monto_sras += p.monto_sras_total
        end
      end

    end

    monto_lote = monto_desembolso + monto_insumos + monto_sras

    #id = []

    begin

      transaction do

        #Inicio transacción en la base de datos
        logger.debug "los ids " <<ids.to_s

        ids.each do |prestamo_id|

          iniciar_transaccion(prestamo_id, 'p_registro_cheque', 'L', I18n.t('Sistema.Body.Modelos.Prestamo.Transacciones.registro_cheques'), usuario_id, monto_lote)

          prestamo = Prestamo.find(prestamo_id.to_i)
          solicitud = Solicitud.find(prestamo.solicitud_id)
          fecha_evento = Time.now

          desembolso = Desembolso.find_by_prestamo_id_and_realizado(prestamo_id.to_i,false)

          desembolso_detalle= DesembolsoDetalle.find(:all, :conditions=>"desembolso_id = #{desembolso.id}")

          if !desembolso_detalle.nil?

            desembolso_detalle.each do |detalle|

              plan_inversion= PlanInversion.find(detalle.plan_inversion_id)

              plan_inversion.monto_desembolsado = plan_inversion.monto_desembolsado + detalle.monto

              plan_inversion.save

            end     # fin de desembolso_detalle.each do |detalle|

          else      # fin de if !desembolso_detalle.nil?

            id = ""
            @msg << I18n.t('Sistema.Body.Modelos.Prestamo.Errores.desembolso_detalle_no_puede_ser_vacio')
            return id

          end       # fin de if !desembolso_detalle.nil?

              if I18n.locale.to_s=="es" || I18n.locale.to_s=="fr" || I18n.locale.to_s=="ar" || I18n.locale.to_s=="cs" || I18n.locale.to_s=="da" || I18n.locale.to_s=="de" || I18n.locale.to_s=="fi" || I18n.locale.to_s=="hu" || I18n.locale.to_s=="it" || I18n.locale.to_s=="ru" ||  I18n.locale.to_s=="nl" || I18n.locale.to_s=="pl" || I18n.locale.to_s=="pt" || I18n.locale.to_s=="sl" || I18n.locale.to_s=="sv"
                fecha = Date.new(params["fecha_liquidacion_#{prestamo_id}"][6,4].to_i,params["fecha_liquidacion_#{prestamo_id}"][3,2].to_i,params["fecha_liquidacion_#{prestamo_id}"][0,2].to_i)
              elsif I18n.locale.to_s=="ja"
                fecha = Date.new(params["fecha_liquidacion_#{prestamo_id}"][0,4].to_i,params["fecha_liquidacion_#{prestamo_id}"][5,2].to_i,params["fecha_liquidacion_#{prestamo_id}"][8,2].to_i)
              else
                fecha = Date.new(params["fecha_liquidacion_#{prestamo_id}"][6,4].to_i,params["fecha_liquidacion_#{prestamo_id}"][0,2].to_i,params["fecha_liquidacion_#{prestamo_id}"][3,2].to_i)
              end

          desembolso.fecha_valor = fecha

          desembolso.referencia = params["numero_cheque_#{prestamo_id}"]
          orden_despacho = OrdenDespacho.find_by_prestamo_id_and_solicitud_id_and_estatus_id_and_realizado(prestamo.id,solicitud.id,20000,false)

          retorno = prestamo.liquidar(desembolso, nil, usuario_id, orden_despacho)

          if retorno
            estatus_id_inicial = solicitud.estatus_id
            if prestamo.monto_banco == prestamo.monto_liquidado
              condicionado = false
            else
              condicionado = true
            end

            # busco la ruta donde debe avanzar el credito

            @configuracion_avance = ConfiguracionAvance.find(:first, :conditions=>['estatus_origen_id = ? and condicionado = ?', estatus_id_inicial, condicionado])
            estatus_id_final = @configuracion_avance.estatus_destino_id
            solicitud.estatus_id =  estatus_id_final
            solicitud.save

            desembolso.realizado = true
            desembolso.save


            # Crea un nuevo registro en la tabla control_solicitud
            unless estatus_id_final.nil?
              ControlSolicitud.create(
               :solicitud_id=>solicitud.id,
               :estatus_id=>estatus_id_final,
               :usuario_id=>usuario_id,
               :fecha => fecha_evento,
               :estatus_origen_id => estatus_id_inicial
              )
            end

            #id << prestamo_id.to_s
            #id << numeros.to_s
            logger.debug "aqui esta el id " << id.to_s
            iniciar_transaccion(prestamo_id, 'p_dummy', 'L', "#{I18n.t('Sistema.Body.Modelos.Prestamo.Transacciones.transaccion_dummy')} #{numeros}", usuario_id, 0)

          end         # Fin if Retorno

        end           # Fin do ids.each


      end             # Fin transaction do

    rescue
      id = ""
      return id

    end  # Fin del begin

    return id

  end

 def validar_fecha_maquinaria(prestamo_id, fecha_liquidacion)

    msj = ""

    #------------------------------------------
    # Se valida que la fecha de liquidación no
    # este vacia y que esta sea válida
    #------------------------------------------

    if fecha_liquidacion==''
      msj << "<li>#{I18n.t('Sistema.Body.Modelos.Prestamo.Errores.fecha_entrega_invalida')}: #{solicitud.numero.to_s}.</li>".html_safe
    else

      begin

        fecha_actual = Time.now.strftime("%Y%m%d")
        #fecha = fecha_liquidacion.split('/')
        fecha = fecha_liquidacion
        logger.info "Fecha #{fecha.inspect}"
        if fecha.to_s!=''

              if I18n.locale.to_s=="es" || I18n.locale.to_s=="fr" || I18n.locale.to_s=="ar" || I18n.locale.to_s=="cs" || I18n.locale.to_s=="da" || I18n.locale.to_s=="de" || I18n.locale.to_s=="fi" || I18n.locale.to_s=="hu" || I18n.locale.to_s=="it" || I18n.locale.to_s=="ru" ||  I18n.locale.to_s=="nl" || I18n.locale.to_s=="pl" || I18n.locale.to_s=="pt" || I18n.locale.to_s=="sl" || I18n.locale.to_s=="sv"
                fecha_liq = Date.new(fecha[6,4].to_i,fecha[3,2].to_i,fecha[0,2].to_i)
              elsif I18n.locale.to_s=="ja"
                fecha_liq = Date.new(fecha[0,4].to_i,fecha[5,2].to_i,fecha[8,2].to_i)
              else
                fecha_liq = Date.new(fecha[6,4].to_i,fecha[0,2].to_i,fecha[3,2].to_i)
              end

          #fecha_liq = Date.new(fecha[2].to_i,fecha[1].to_i, fecha[0].to_i)
          fecha_liquidacion = fecha_liq.strftime("%Y%m%d")
        end
        logger.info "Fecha Actual #{fecha_actual}"
        logger.info "Fecha Liquidacion #{fecha_liquidacion}"

        if fecha_liquidacion > fecha_actual
          msj << "<li>#{I18n.t('Sistema.Body.Modelos.Prestamo.Errores.fecha_entrega_invalida')}: #{solicitud.numero.to_s}.</li>".html_safe

        end

      rescue Exception => e
        logger.info e.message
        logger.info e.backtrace.join("\n")
        msj << "<li>#{I18n.t('Sistema.Body.Modelos.Prestamo.Errores.fecha_entrega_invalida')}: #{solicitud.numero.to_s}.</li>".html_safe
      end
    end

    if msj.length > 0
      return msj.html_safe
    else
      return ''
    end
  end

  def generar_tabla_maquinaria(params,usuario_id)

    #--------------------------------------------------------
    # Método para registrar el número del cheque
    # en el desembolso y generar la tabla de amortización
    # de 1 o varios prestamos según selección del usuario
    #---------------------------------------------------------

    id = params[:prestamos_id]
    id = id[0,(id.length-1)]
    ids = id.split(',')

    numeros = ''
    monto_desembolso = 0.00
    monto_insumos = 0.00
    ids.each do |prestamo_id|

      prestamo = Prestamo.find(prestamo_id)
      numeros << prestamo.numero.to_s << ','
    end

    numeros = numeros.slice(0,(numeros.length - 1))


    id = []

    begin

      transaction do

        ids.each do |prestamo_id|

          prestamo = Prestamo.find(prestamo_id.to_i)
          solicitud = Solicitud.find(prestamo.solicitud_id)

          monto_lote = prestamo.monto_solicitado + prestamo.monto_sras_total + prestamo.monto_gasto_total

          iniciar_transaccion(prestamo.id, 'p_entrega_maquinaria', 'L', I18n.t('Sistema.Body.Modelos.Prestamo.Transacciones.entrega_maquinaria'), usuario_id, monto_lote)

          fecha_evento = Time.now



          fecha_arr = params["fecha_liquidacion_#{prestamo_id}"].to_s

              if I18n.locale.to_s=="es" || I18n.locale.to_s=="fr" || I18n.locale.to_s=="ar" || I18n.locale.to_s=="cs" || I18n.locale.to_s=="da" || I18n.locale.to_s=="de" || I18n.locale.to_s=="fi" || I18n.locale.to_s=="hu" || I18n.locale.to_s=="it" || I18n.locale.to_s=="ru" ||  I18n.locale.to_s=="nl" || I18n.locale.to_s=="pl" || I18n.locale.to_s=="pt" || I18n.locale.to_s=="sl" || I18n.locale.to_s=="sv"
                fecha_liquidacion = Date.new(fecha_arr[6,4].to_i,fecha_arr[3,2].to_i,fecha_arr[0,2].to_i)
              elsif I18n.locale.to_s=="ja"
                fecha_liquidacion = Date.new(fecha_arr[0,4].to_i,fecha_arr[5,2].to_i,fecha_arr[8,2].to_i)
              else
                fecha_liquidacion = Date.new(fecha_arr[6,4].to_i,fecha_arr[0,2].to_i,fecha_arr[3,2].to_i)
              end


          #fecha_liquidacion = Date.new(fecha_arr[2].to_i,fecha_arr[1].to_i,fecha_arr[0].to_i)

          retorno = liquidar_maquinaria(prestamo,usuario_id,fecha_liquidacion)

            logger.debug "retorno " << retorno.to_s
          if retorno

            estatus_id_inicial = solicitud.estatus_id
            condicionado = false

            # busco la ruta donde debe avanzar el credito

            @configuracion_avance = ConfiguracionAvance.find(:first, :conditions=>['estatus_origen_id = ? and condicionado = ?', estatus_id_inicial, condicionado])
            estatus_id_final = @configuracion_avance.estatus_destino_id
            solicitud.estatus_id =  estatus_id_final
            solicitud.save

            #sacar del inventario las maquinarias asiciadas al trámite
            Catalogo.find_by_sql("UPDATE catalogo SET estatus = 'E' where solicitud_id = #{solicitud.id}")

            # Crea un nuevo registro en la tabla control_solicitud
            unless estatus_id_final.nil?
              ControlSolicitud.create(
               :solicitud_id=>solicitud.id,
               :estatus_id=>estatus_id_final,
               :usuario_id=>usuario_id,
               :fecha => fecha_evento,
               :estatus_origen_id => estatus_id_inicial
              )
            end

            id << prestamo_id.to_s
            logger.debug "listo me fui " << id.to_s
            iniciar_transaccion(prestamo.id, 'p_dummy', 'L', I18n.t('Sistema.Body.Modelos.Prestamo.Transacciones.transaccion_dummy'), usuario_id, 0)

          end         # Fin if Retorno

        end           # Fin do ids.each


      end             # Fin transaction do

    rescue
      id = ""
      return id

    end  # Fin del begin

    return id

  end

  def liquidar_maquinaria(prestamo,usuario_id,fecha_liquidacion)



    if prestamo.liquidado
      prestamo.errors.add(:prestamo, I18n.t('Sistema.Body.Modelos.Prestamo.Errores.prestamo_liquidado'))
      return false

    else

      begin


        #ojo con estas variables @usuario  @ip_address

        #prestamo.solicitud.usuario = @usuario
        #prestamo.solicitud.ip_address = @ip_address

        prestamo.solicitud.usuario = usuario_id
        #prestamo.solicitud.ip_address = request.remote_ip


        a = false

        inicial = prestamo.estatus=='S'
        prestamo.estatus='V'

        #Se determina si es el desembolso inicial
        plan_pago = PlanPago.find_by_prestamo_id_and_activo(prestamo.id, true)

        if plan_pago.nil?

          # Generación tabla amortización

          prestamo.fecha_liquidacion = fecha_liquidacion
          prestamo.monto_liquidado = prestamo.monto_liquidado + prestamo.monto_inventario
          prestamo.monto_liquidado_insumos = 0.00
          prestamo.monto_insumos = 0.00
          prestamo.monto_banco = 0.00
        else

          # Siguientes Desembolsos

          prestamo.errors.add(:prestamo, I18n.t('Sistema.Body.Modelos.Prestamo.Errores.prestamo_tiene_tabla'))

        end

        prestamo.estatus_desembolso = 'E'
        #self.tasa_vigente = self.tasa_inicial


        begin
          a = prestamo.save

        rescue Exception => e
          prestamo.errors.add(:prestamo, "#{I18n.t('Sistema.Body.Modelos.Prestamo.Errores.error_actualizando_prestamo')}: #{e.message}")
          logger.debug "al guardar prestamo dio " << e.message.to_s
          return false
        end

        unless a
        #prestamo.errors.add_errors_with_raise(prestamo.errors) unless a
        logger.debug "aqui " << a.to_s << prestamo.errors.full_messages.to_s
        prestamo.errors.add(:prestamo,prestamo.errors.full_messages)
        raise ActiveRecord::Rollback
        end

        if plan_pago.nil?


          monto_liquidacion = prestamo.monto_solicitado + prestamo.monto_sras_total + prestamo.monto_gasto_total
          prestamo.monto_liquidado = prestamo.monto_inventario
          generar_plan_pago_maquinaria(monto_liquidacion, fecha_liquidacion,0,0,prestamo)
          prestamo.saldo_insoluto += monto_liquidacion
          a = prestamo.save

          #registrar_acumulados(self.monto_liquidado)


        else

          #registrar_acumulados(desembolso.monto)

        end         #=======> Fin if plan_pago.nil?


        if prestamo.tipo_diferimiento
          prestamo.porcentaje_diferimiento = 100
        end

        return a

      rescue => detail
        logger.debug "me fui aqui " << detail.message.to_s #<< " - " << detail.full_messages.to_s
        self.errors.add(:prestamo, detail.message)
        return false

      end
    end
  end

  def generar_lote(id,usuario_id)


    ids = id.split(',')

    numeros = ''
    ids.each do |prestamo_id|

      prestamo = Prestamo.find(prestamo_id)
      numeros << prestamo.numero.to_s << ','
    end

    numeros = numeros.slice(0,(numeros.length - 1))

    monto_desembolso = Desembolso.sum('monto', :conditions=>"prestamo_id in (#{id}) and realizado = false and estatus_id = 20010")
    monto_insumos = Prestamo.sum('monto_insumos', :conditions=>"id in (#{id}) and realizado = false")
    prestamos = Prestamo.find(:all, :conditions=>"id in (#{id})")

    monto_sras = 0.00

    if !prestamos.empty?

      prestamo.each do |p|

        plan = PlanPago.find_by_prestamo_id_and_activo(p.id,true)

        if plan.nil?
          monto_sras += p.monto_sras_total
        end
      end

    end

    monto_lote = monto_desembolso + monto_insumos + monto_sras

    id = []

    begin

      transaction do

        #Inicio transacción en la base de datos

        iniciar_transaccion(self.id, 'p_generar_lote', 'L', I18n.t('Sistema.Body.Modelos.Prestamo.Transacciones.desembolso_por_lotes'), usuario_id, monto_lote)

        #logger.info "Salio de iniciar transacción"

        ids.each do |prestamo_id|


          prestamo = Prestamo.find(prestamo_id.to_i)
          solicitud = Solicitud.find(prestamo.solicitud_id)
          fecha_evento = Time.now

          desembolso = Desembolso.find_by_prestamo_id_and_realizado(prestamo_id.to_i,false)
          orden_despacho = OrdenDespacho.find_by_prestamo_id_and_solicitud_id_and_estatus_id_and_realizado(prestamo.id,solicitud_id,20010,false)

          retorno = prestamo.liquidar(desembolso, nil, usuario_id, orden_despacho)

          if retorno
            estatus_id_inicial = solicitud.estatus_id
            if solicitud.monto_solicitado == prestamo.monto_liquidado
              condicionado = false
            else
              condicionado = true
            end

            # busco la ruta donde debe avanzar el credito

            @configuracion_avance = ConfiguracionAvance.find(:first, :conditions=>['estatus_origen_id = ? and condicionado = ?', estatus_id_inicial, condicionado])
            estatus_id_final = @configuracion_avance.estatus_destino_id
            solicitud.estatus_id =  estatus_id_final
            solicitud.save

            desembolso.realizado = true
            desembolso.save


            # Crea un nuevo registro en la tabla control_solicitud
            unless estatus_id_final.nil?
              ControlSolicitud.create(
               :solicitud_id=>solicitud.id,
               :estatus_id=>estatus_id_final,
               :usuario_id=>usuario_id,
               :fecha => fecha_evento,
               :estatus_origen_id => estatus_id_inicial
              )
            end

              id << i

          end         # Fin if Retorno

        end           # Fin do ids.each

      end             # Fin transaction do

      iniciar_transaccion(self.id, 'p_dummy', 'L', "I18n.t('Sistema.Body.Modelos.Prestamo.Transacciones.transaccion_dummy') #{numeros}", usuario_id, 0)

    rescue
      id = ""
      return id

    end  # Fin del begin

    return id

  end

  def calculo_interes_gracia(desembolso_id)

    params = {
                :prestamo_id=>self.id.to_i,
                :desembolso_id=>desembolso_id.to_i

                         }
    execute_sp('calcular_interes_gracia_desembolso', params.values_at(
      :prestamo_id,
      :desembolso_id))

    return true
  end



  def desliberar
    prestamos = PrestamoModificacion.find_by_sql("select * from prestamo_modificacion where estatus = 'E' and solicitud_id = #{self.solicitud.id}")


    if prestamos && prestamos.length == 0
      self.solicitud.liberada = false
      self.solicitud.estatus_modificacion = self.solicitud.estatus
      self.solicitud.save
    end

  end

  def aplicar_forzar_tasa(prestamo_modificar)

    transaction do
      prestamo_modificar.fecha = Time.now
      prestamo_modificar.estatus = 'R'
      prestamo_modificar.save
      desliberar
      self.tasa_forzada = true
      self.tasa_fija = prestamo_modificar.forzar_tasa_fija
      self.tasa_forzada_fecha_vigencia = prestamo_modificar.forzar_tasa_fecha_vigencia
      self.tasa_forzada_monto = prestamo_modificar.forzar_tasa_monto
      self.save

      self.save

    end

  end

  def aplicar_traslado_partida(prestamo_modificar)

    transaction do

      prestamo_modificar.fecha = Time.now
      prestamo_modificar.estatus = 'R'
      prestamo_modificar.save
      desliberar
      prestamo_origen = prestamo_modificar.traslado_prestamo_origen
      prestamo_origen.traslado_origen += prestamo_modificar.traslado_monto
      prestamo_origen.save

      self.traslado_destino += prestamo_modificar.traslado_monto
      self.save

     end
  end

  def aplicar_aumento_capital(prestamo_modificar)

    transaction do

      prestamo_modificar.fecha = Time.now
      prestamo_modificar.estatus = 'R'
      prestamo_modificar.save
      desliberar

      self.aumento_capital += prestamo_modificar.aumento_capital
      self.save

      self.solicitud.aumento_capital += prestamo_modificar.aumento_capital
      self.solicitud.save

    end

  end

  def aplicar_litigio(prestamo_modificar)

    transaction do

      prestamo_modificar.fecha = Time.now
      prestamo_modificar.estatus = 'R'
      prestamo_modificar.save
      desliberar
      self.estatus = 'L'
      self.save

    end

  end

  def aplicar_extension_muerto(prestamo_modificar)

    transaction do
      prestamo_modificar.fecha = Time.now
      prestamo_modificar.estatus = 'R'
      prestamo_modificar.save
      desliberar
      self.meses_muertos =  self.meses_muertos + prestamo_modificar.meses_muertos
      self.save


      fecha = Time.now
      fecha = Time.now.strftime(I18n.t('time.formats.gebos_corto'))

      params = {
      :proyectado=>false,
      :prestamo_id=>self.id,
      :fecha_evento=>fecha,
      :tiene_desembolso=>false,
      :monto_desembolso=>0,
      :tiene_tasa=>false,
      :valor_tasa=>0,
      :tiene_abono=>false,
      :monto_abono=>0,
      :desembolso_id=>0,
      :extension_muerto=>prestamo_modificar.meses_muertos}

    execute_sp('generar_plan_pago_evento', params.values_at(
      :proyectado,
      :prestamo_id,
      :fecha_evento,
      :tiene_desembolso,
      :monto_desembolso,
      :tiene_tasa,
      :valor_tasa,
      :tiene_abono,
      :monto_abono,
      :desembolso_id,
      :extension_muerto))

    end

  end

  def calcular_prestamo_proyeccion(fecha, monto_abono)

    params = {
      :prestamo_id=>self.id,
      :fecha_evento=>fecha,
      :monto_abono=>monto_abono}
    execute_sp('calcular_prestamo_proyeccion', params.values_at(
      :prestamo_id,
      :fecha_evento,
      :monto_abono))

  end

  def aplicar_reestructuracion(prestamo_modificar)

    transaction do

      success = true
      formula = Formula.find(3);
      prestamo_new = Prestamo.new(:producto=>prestamo_modificar.prestamo.producto,
        :solicitud=>prestamo_modificar.prestamo.solicitud,
        :oficina=>prestamo_modificar.prestamo.oficina,
        :destinatario=>prestamo_modificar.prestamo.destinatario,
        :monto_solicitado=>prestamo_modificar.monto,
        :monto_aprobado=>prestamo_modificar.monto,
        :monto_liquidado=>prestamo_modificar.monto,
        :base_calculo_intereses=>prestamo_modificar.prestamo.base_calculo_intereses,
        :forma_calculo_intereses=>prestamo_modificar.prestamo.forma_calculo_intereses,
        :tasa_inicial=>prestamo_modificar.tasa_inicial,
        :fecha_aprobacion=>prestamo_modificar.prestamo.solicitud.fecha_acta_directorio,
        :fecha_liquidacion=>Time.now,
        :cliente=>prestamo_modificar.prestamo.cliente,
        :formula=>formula,
        :tasa=>prestamo_modificar.tasa,
        :tasa_mora=>prestamo_modificar.prestamo.tasa_mora,
        :diferencial_tasa=>prestamo_modificar.prestamo.diferencial_tasa,
        :plazo=>prestamo_modificar.plazo,
        :meses_fijos_sin_cambio_tasa=>prestamo_modificar.meses_fijos_sin_cambio_tasa,
        :frecuencia_pago=>prestamo_modificar.frecuencia_pago,
        :tipo_credito=>prestamo_modificar.prestamo.tipo_credito,
        :partida=>prestamo_modificar.prestamo.partida,
        :reestructurado=>'F',
        :prestamo_origen_id=>self.id)

     prestamo_new.save


     self.estatus = 'F'
     self.prestamo_destino = prestamo_new
     self.save

     parametro_general = ParametroGeneral.find(1);
     factura_origen = Factura.new(:numero=>parametro_general.ultima_factura+1,
        :fecha=>Time.now.strftime(I18n.t('time.formats.gebos_corto')),
        :fecha_realizacion=>Time.now.strftime(I18n.t('time.formats.gebos_corto')),
        :tipo=>'W',
        :monto=>prestamo_modificar.monto,
        :prestamo_id=>self.id,
        :prestamo_modificacion_id=>prestamo_modificar.id)
     factura_origen.save

     parametro_general.ultima_factura += 1;
     parametro_general.save

     factura_destino = Factura.new(:numero=>parametro_general.ultima_factura+1,
        :fecha=>Time.now.strftime(I18n.t('time.formats.gebos_corto')),
        :fecha_realizacion=>Time.now.strftime(I18n.t('time.formats.gebos_corto')),
        :tipo=>'X',
        :monto=>prestamo_modificar.monto,
        :prestamo_id=>prestamo_new.id,
        :prestamo_modificacion_id=>prestamo_modificar.id)

     factura_destino.save
     parametro_general.ultima_factura += 1;
     parametro_general.save

     prestamo_modificar.fecha = Time.now.strftime(I18n.t('time.formats.gebos_corto'))
     prestamo_modificar.estatus = 'R'
     prestamo_modificar.save
     desliberar


     params = {
        :prestamo_id=>prestamo_new.id,
        :fecha=>Time.now.strftime(I18n.t('time.formats.gebos_corto')),
        :formula_id=>prestamo_new.formula_id,
        :frecuencia_pago=>prestamo_new.frecuencia_pago,
        :monto=>prestamo_new.monto_liquidado,
        :plazo=>prestamo_new.plazo,
        :tasa_valor=>prestamo_new.tasa_inicial
     }
       execute_sp('generar_plan_pago_reestructuracion', params.values_at(
        :prestamo_id,
        :fecha,
        :formula_id,
        :frecuencia_pago,
        :monto,
        :plazo,
        :tasa_valor))
    end
  end

  # Metodo incluido por Diego Bertaso para aplicar la reestructuracion administrativa el 15/01/2008
  #

   def aplicar_reestructuracion_administrativa(prestamo_modificar)

    rubro = Rubro.find_by_id(prestamo_modificar.rubro_id)
    partida = Partida.find_by_id(rubro.partida_id)
    formula = Formula.find_by_id(prestamo_modificar.formula_id)
    producto = Producto.find_by_partida_id_and_programa_id(rubro.partida_id,prestamo_modificar.prestamo.solicitud.programa_id)

    transaction do


      success = true

      prestamo_new = Prestamo.new(:producto=>prestamo_modificar.prestamo.producto,
        :solicitud=>prestamo_modificar.prestamo.solicitud,
        :oficina=>prestamo_modificar.prestamo.oficina,
        :destinatario=>prestamo_modificar.prestamo.destinatario,
        :monto_solicitado=>prestamo_modificar.monto,
        :monto_aprobado=>prestamo_modificar.monto,
        :monto_liquidado=>prestamo_modificar.monto,
        :base_calculo_intereses=>prestamo_modificar.prestamo.base_calculo_intereses,
        :forma_calculo_intereses=>prestamo_modificar.prestamo.forma_calculo_intereses,
        :tasa_inicial=>prestamo_modificar.tasa_inicial,
        :fecha_aprobacion=>prestamo_modificar.prestamo.solicitud.fecha_acta_directorio,
        :fecha_liquidacion=>Time.now,
        :cliente=>prestamo_modificar.prestamo.cliente,
        :formula=>formula,
        :tasa=>prestamo_modificar.tasa,
        :tasa_mora=>prestamo_modificar.prestamo.tasa_mora,
        :diferencial_tasa=>prestamo_modificar.prestamo.diferencial_tasa,
        :plazo=>prestamo_modificar.plazo,
        :meses_fijos_sin_cambio_tasa=>prestamo_modificar.meses_fijos_sin_cambio_tasa,
        :frecuencia_pago=>prestamo_modificar.frecuencia_pago,
        :tipo_credito=>prestamo_modificar.prestamo.tipo_credito,
        :partida=>partida,
        :reestructurado=>'A',
        :prestamo_origen_id=>self.id)

     prestamo_new.save


     self.estatus = 'A'
     self.prestamo_destino = prestamo_new
     self.save

     parametro_general = ParametroGeneral.find(1);
     factura_origen = Factura.new(:numero=>parametro_general.ultima_factura+1,
        :fecha=>Time.now,
        :fecha_realizacion=>Time.now,
        :tipo=>'W',
        :monto=>prestamo_modificar.monto,
        :prestamo_id=>self.id,
        :prestamo_modificacion_id=>prestamo_modificar.id)

     factura_origen.save

     parametro_general.ultima_factura += 1;
     parametro_general.save

     factura_destino = Factura.new(:numero=>parametro_general.ultima_factura+1,
        :fecha=>Time.now,
        :fecha_realizacion=>Time.now,
        :tipo=>'X',
        :monto=>prestamo_modificar.monto,
        :prestamo_id=>prestamo_new.id,
        :prestamo_modificacion_id=>prestamo_modificar.id)

     factura_destino.save
     parametro_general.ultima_factura += 1;
     parametro_general.save

     prestamo_modificar.fecha = Time.now
     prestamo_modificar.estatus = 'R'
     prestamo_modificar.save

     desliberar

     params = {
        :prestamo_id=>prestamo_new.id,
        :fecha=>Time.now.strftime(I18n.t('time.formats.gebos_corto')),
        :formula_id=>prestamo_new.formula_id,
        :frecuencia_pago=>prestamo_new.frecuencia_pago,
        :monto=>prestamo_new.monto_liquidado,
        :plazo=>prestamo_new.plazo,
        :tasa_valor=>prestamo_new.tasa_inicial
     }
       execute_sp('generar_plan_pago_reestructuracion', params.values_at(
        :prestamo_id,
        :fecha,
        :formula_id,
        :frecuencia_pago,
        :monto,
        :plazo,
        :tasa_valor))
    end
  end

  def generar_plan_pago_inicial(monto_liquidado, fecha_aplicacion, desembolso_id, monto_banco, monto_sras, monto_insumos)


    p_frecuencia_pago = self.frecuencia_pago
    if p_frecuencia_pago == 0
      p_frecuencia_pago = self.plazo
    end

    params = {
      :proyectado=>false,
      :formula_id=>self.formula_id,
      :prestamo_id=>self.id,
      :plan_pago_id=>0,
      :numero_cuota_inicial=>0,
      :tipo_cuota_inicial=>'Z',
      :interes_acumulado_inicial=>0,
      :amortizado_acumulado_inicial=>0,
      :fecha_liquidacion=>fecha_aplicacion,
      :monto=>monto_liquidado,
      :plazo=>self.plazo,
      :frecuencia_pago=>p_frecuencia_pago,
      :tasa_valor=>self.tasa_inicial,
      :meses_muertos=>self.meses_muertos,
      :meses_gracia=>self.meses_gracia,
      :meses_diferidos=>0,
      :exonerar_intereses_diferidos=>false,
      :tasa_valor_gracia=>self.tasa_inicial,
      :frecuencia_pago_gracia=>p_frecuencia_pago,
      :desembolso_id=>desembolso_id,
      :inicial=>true,
      :fecha_evento=>self.fecha_liquidacion,
      :monto_desembolso=>monto_liquidado,
      :monto_banco=>monto_banco,
      :monto_sras=>monto_sras,
      :monto_insumos=>monto_insumos,
      :monto_gasto_total=>self.monto_gasto_total
      }
     execute_sp('generar_plan_pago', params.values_at(
      :proyectado,
      :formula_id,
      :prestamo_id,
      :plan_pago_id,
      :numero_cuota_inicial,
      :tipo_cuota_inicial,
      :interes_acumulado_inicial,
      :amortizado_acumulado_inicial,
      :fecha_liquidacion,
      :monto,
      :plazo,
      :frecuencia_pago,
      :tasa_valor,
      :meses_muertos,
      :meses_gracia,
      :meses_diferidos,
      :exonerar_intereses_diferidos,
      :tasa_valor_gracia,
      :frecuencia_pago_gracia,
      :desembolso_id,
      :inicial,
      :fecha_evento,
      :monto_desembolso,
      :monto_banco,
      :monto_sras,
      :monto_insumos,
      :monto_gasto_total))

  end

  def generar_plan_pago_migracion(monto_liquidado, fecha_aplicacion, interes_diferido, cuotas_pagadas)

    transaction do

      meses_pagados = 0
      #meses_pagados = self.cuotas_pagadas * self.frecuencia_pago

      logger.debug "SELF ============>  #{self.inspect}"
      #--------------------------------------------------
      # Se determina si todavia tiene cuotas de gracia
      # por pagar y el plazo restante
      #--------------------------------------------------

      #self.plazo = self.plazo + self.meses_gracia - meses_pagados

#      if self.meses_gracia > 0

#        if meses_pagados > 0
#          if meses_pagados > self.meses_gracia

#            self.meses_gracia = self.meses_gracia - meses_pagados
#          end
#        end

#      end

      params = {
        :proyectado=>false,
        :formula_id=>self.formula_id,
        :prestamo_id=>self.id,
        :plan_pago_id=>0,
        :numero_cuota_inicial=>0,
        :tipo_cuota_inicial=>'Z',
        :interes_acumulado_inicial=>0,
        :amortizado_acumulado_inicial=>0,
        :fecha_liquidacion=>fecha_aplicacion,
        :monto=>monto_liquidado,
        :plazo=>self.plazo,
        :frecuencia_pago=>self.frecuencia_pago,
        :tasa_valor=>self.tasa_vigente,
        :meses_muertos=>self.meses_muertos,
        :meses_gracia=>self.meses_gracia,
        :meses_diferidos=>self.meses_diferidos,
        :exonerar_intereses_diferidos=>false,
        :tasa_valor_gracia=>self.tasa_vigente,
        :frecuencia_pago_gracia=>self.frecuencia_pago,
        :desembolso_id=>0,
        :inicial=>true,
        :fecha_evento=>fecha_aplicacion,
        :monto_desembolso=>monto_liquidado,
        :interes_diferido=>interes_diferido,
        :p_cuotas_pagadas=>cuotas_pagadas
      }
       execute_sp('generar_plan_pago_migracion', params.values_at(
        :proyectado,
        :formula_id,
        :prestamo_id,
        :plan_pago_id,
        :numero_cuota_inicial,
        :tipo_cuota_inicial,
        :interes_acumulado_inicial,
        :amortizado_acumulado_inicial,
        :fecha_liquidacion,
        :monto,
        :plazo,
        :frecuencia_pago,
        :tasa_valor,
        :meses_muertos,
        :meses_gracia,
        :meses_diferidos,
        :exonerar_intereses_diferidos,
        :tasa_valor_gracia,
        :frecuencia_pago_gracia,
        :desembolso_id,
        :inicial,
        :fecha_evento,
        :monto_desembolso,
        :interes_diferido,
        :p_cuotas_pagadas))

    end

  end

  def generar_plan_pago_maquinaria(monto_liquidado, fecha_aplicacion, interes_diferido, cuotas_pagadas,prestamo)

    transaction do

      meses_pagados = 0
      #meses_pagados = self.cuotas_pagadas * self.frecuencia_pago

      logger.debug "SELF ============>  #{prestamo.inspect}"
      #--------------------------------------------------
      # Se determina si todavia tiene cuotas de gracia
      # por pagar y el plazo restante
      #--------------------------------------------------

      #self.plazo = self.plazo + self.meses_gracia - meses_pagados

#      if self.meses_gracia > 0

#        if meses_pagados > 0
#          if meses_pagados > self.meses_gracia

#            self.meses_gracia = self.meses_gracia - meses_pagados
#          end
#        end

#      end

      params = {
        :proyectado=>false,
        :formula_id=>prestamo.formula_id,
        :prestamo_id=>prestamo.id,
        :plan_pago_id=>0,
        :numero_cuota_inicial=>0,
        :tipo_cuota_inicial=>'Z',
        :interes_acumulado_inicial=>0,
        :amortizado_acumulado_inicial=>0,
        :fecha_liquidacion=>fecha_aplicacion,
        :monto=>monto_liquidado,
        :plazo=>prestamo.plazo,
        :frecuencia_pago=>prestamo.frecuencia_pago,
        :tasa_valor=>prestamo.tasa_vigente,
        :meses_muertos=>prestamo.meses_muertos,
        :meses_gracia=>prestamo.meses_gracia,
        :meses_diferidos=>prestamo.meses_diferidos,
        :exonerar_intereses_diferidos=>false,
        :tasa_valor_gracia=>prestamo.tasa_vigente,
        :frecuencia_pago_gracia=>prestamo.frecuencia_pago,
        :desembolso_id=>0,
        :inicial=>true,
        :fecha_evento=>fecha_aplicacion,
        :monto_desembolso=>monto_liquidado,
        :interes_diferido=>interes_diferido,
        :p_cuotas_pagadas=>cuotas_pagadas
      }
       execute_sp('generar_plan_pago_maquinaria', params.values_at(
        :proyectado,
        :formula_id,
        :prestamo_id,
        :plan_pago_id,
        :numero_cuota_inicial,
        :tipo_cuota_inicial,
        :interes_acumulado_inicial,
        :amortizado_acumulado_inicial,
        :fecha_liquidacion,
        :monto,
        :plazo,
        :frecuencia_pago,
        :tasa_valor,
        :meses_muertos,
        :meses_gracia,
        :meses_diferidos,
        :exonerar_intereses_diferidos,
        :tasa_valor_gracia,
        :frecuencia_pago_gracia,
        :desembolso_id,
        :inicial,
        :fecha_evento,
        :monto_desembolso,
        :interes_diferido,
        :p_cuotas_pagadas))

    end

  end

  def generar_plan_pago_desembolso(monto, fecha, desembolso_id, monto_banco, monto_sras, monto_insumos)
    generar_plan_pago_evento('d', monto, fecha, desembolso_id, monto_banco, monto_sras, monto_insumos)
  end

  def generar_plan_pago_abono_extraordinario(monto, fecha)

    generar_plan_pago_evento('a', monto, fecha)
    return true
  end

  def generar_plan_pago_evento(evento, monto, fecha, desembolso_id, monto_banco, monto_sras, monto_insumos)

    tiene_desembolso = false
    monto_desembolso = 0
    tiene_tasa = false
    valor_tasa = 0
    tiene_abono = false
    monto_abono = 0
    case evento
    when 'd'
      tiene_desembolso = true
      monto_desembolso = monto
    when 't'
      tiene_tasa = true
      valor_tasa = monto
      monto_banco = 0.00
      monto_sras = 0.00
      monto_insumos = 0.00
    when 'a'
      tiene_abono = true
      monto_abono = monto
      monto_banco = 0.00
      monto_sras = 0.00
      monto_insumos = 0.00
    end

    params = {
      :proyectado=>false,
      :prestamo_id=>self.id,
      :fecha_evento=>fecha,
      :tiene_desembolso=>tiene_desembolso,
      :monto_desembolso=>monto_desembolso,
      :tiene_tasa=>tiene_tasa,
      :valor_tasa=>valor_tasa,
      :tiene_abono=>tiene_abono,
      :monto_abono=>monto_abono,
      :desembolso_id=>desembolso_id,
      :extension_muerto=>0,
      :monto_banco=>monto_banco,
      :monto_sras=>monto_sras,
      :monto_insumos=>monto_insumos,
      :p_monto_gasto_total=>0}

    execute_sp('generar_plan_pago_evento', params.values_at(
      :proyectado,
      :prestamo_id,
      :fecha_evento,
      :tiene_desembolso,
      :monto_desembolso,
      :tiene_tasa,
      :valor_tasa,
      :tiene_abono,
      :monto_abono,
      :desembolso_id,
      :extension_muerto,
      :monto_banco,
      :monto_sras,
      :monto_insumos,
      :p_monto_gasto_total))

  end
 # se descomento empezando aqui
 #
#  def proyectar_reestablecer
#    PlanPago.transaction do
#      PlanPago.destroy_all(["proyeccion=true and prestamo_id=?", self.id])
#      self.proyectar
#    end
#  end
#
#  def proyectar
#    if plan_pago_proyectado = PlanPago.find_by_prestamo_id_and_proyeccion(self.id, true)
#      plan_pago_proyectado
#    else
#      plan_pago = PlanPago.find_by_prestamo_id_and_activo(self.id, true)
#      PlanPago.transaction do
#        plan_pago_proyectado = plan_pago.clone
#        plan_pago_proyectado.activo=false
#        plan_pago_proyectado.proyeccion=true
#        plan_pago_proyectado.save
#
#        PlanPagoCuota.transaction do
#          for cuota in plan_pago.cuotas
#            cuota_proyectada = cuota.clone
#            cuota_proyectada.plan_pago = plan_pago_proyectado
#            cuota_proyectada.save
#          end
#        end
#      end
#      plan_pago_proyectado
#    end
#
#  end
#
#
#
#  def proyectar_evento(tiene_desembolso, monto_desembolso, tiene_tasa, valor_tasa, tiene_abono, monto_abono, fecha)
#    evento(tiene_desembolso, monto_desembolso, tiene_tasa, valor_tasa, tiene_abono, monto_abono, fecha, true)
#  end
#
#  def evento(tiene_desembolso, monto_desembolso, tiene_tasa, valor_tasa, tiene_abono, monto_abono, fecha, proyeccion)
#    if proyeccion
#      plan_pago = PlanPago.find_by_prestamo_id_and_proyeccion(self.id, true)
#    else
#      plan_pago = PlanPago.find_by_prestamo_id_and_activo(self.id, true)
#    end
#    cuota = plan_pago.cuotas.find(:first, :conditions=>["fecha >= ?", fecha], :order=>'id asc')
#    if tiene_abono
#      cuota.saldo_insoluto -= monto_abono
#      cuota.abono_extraordinario = true
#      cuota.amortizado_acumulado += monto_abono
#      cuota.amortizado += monto_abono
#    end
#    calculadora = Calculadora.new
#    calculadora.metodo = self.formula_id
#    calculadora.fecha = fecha
#    calculadora.plazo = plan_pago.plazo
#    calculadora.periodo = plan_pago.frecuencia_pago
#    calculadora.monto = cuota.saldo_insoluto + monto_desembolso
#    calculadora.muerto_plazo = plan_pago.meses_muertos
#    calculadora.gracia_periodo = plan_pago.frecuencia_pago_gracia
#    calculadora.gracia_plazo = plan_pago.meses_gracia
#    calculadora.gracia_tasa = tiene_tasa ? valor_tasa : plan_pago.tasa
#    calculadora.tasa = tiene_tasa ? valor_tasa : plan_pago.tasa
#    calculadora.evento = true
#    calculadora.numero_cuota_inicial = cuota.numero
#    calculadora.tipo_cuota_inicial = cuota.tipo_cuota
#    calculadora.amortizado_inicial = cuota.amortizado_acumulado
#    calculadora.interes_inicial = cuota.interes_corriente_acumulado
#    calculadora.dia_facturacion = plan_pago.dia_facturacion
#
#    calculadora.calcular
#
#    cuotas_nuevas = calculadora.todas_cuotas
#
#
#    PlanPago.transaction do
#      if !proyeccion
#        plan_pago_viejo = plan_pago
#        plan_pago_viejo.activo = false
#        plan_pago_viejo.save
#
#        plan_pago = plan_pago.clone
#        plan_pago.activo=true
#        plan_pago.save
#
#        PlanPagoCuota.transaction do
#          for cuota in plan_pago_viejo.cuotas
#            cuota = cuota.clone
#            cuota.plan_pago = plan_pago
#            cuota.save
#          end
#        end
#      end
#
#      cuotas = plan_pago.cuotas.find(:all, :conditions=>["fecha >= ? ", calculadora.fecha_inicio], :order=>'id asc')
#
#      plan_pago.tasa = valor_tasa if tiene_tasa
#      plan_pago.tasa_gracia = valor_tasa if tiene_tasa
#      plan_pago.fecha_evento = fecha
#      plan_pago.motivo_evento = 'D' if tiene_desembolso && !proyeccion
#      plan_pago.motivo_evento = 'T' if tiene_tasa && !proyeccion
#      plan_pago.motivo_evento = 'A' if tiene_abono && !proyeccion
#      PlanPagoCuota.transaction do
#        cuota.save if tiene_abono
#        primera = true
#        for cuota in cuotas
#          cuota_nueva = cuotas_nuevas.shift
#          cuota.abono_extraordinario = false
#          cuota.desembolso = primera && tiene_desembolso
#          cuota.cambio_tasa = primera && tiene_tasa
#          cuota.update_attributes(
#            :valor_cuota=>cuota_nueva.monto,
#            :amortizado=>cuota_nueva.amortizado,
#            :amortizado_acumulado=>cuota_nueva.amortizado_acumulado,
#            :interes_corriente=>cuota_nueva.interes,
#            :interes_corriente_acumulado=>cuota_nueva.interes_acumulado,
#            :saldo_insoluto=>cuota_nueva.saldo,
#            :tasa_periodo=>cuota_nueva.tasa)
#          primera = false
#        end
#      end
#      plan_pago.monto = cuota.amortizado_acumulado
#      plan_pago.save
#    end
#
#    plan_pago
#
#  end
#
#  def exigible
#    plan_pago = PlanPago.find_by_prestamo_id_and_activo_and_proyeccion(
#      self.id, true, false)
#
#    total_cuotas = 0
#    total_mora = 0
#
#    _total_cuotas = 0 unless PlanPagoCuota.sum(:valor_cuota, :conditions=>["plan_pago_id = ? AND vencida = true", plan_pago.id])
#    _total_mora = 0 unless PlanPagoCuota.sum(:interes_mora, :conditions=>["plan_pago_id = ? AND vencida = true", plan_pago.id])
#
#    if !_total_cuotas.nil?
#
#      total_cuotas = _total_cuotas
#    end
#
#    if !_total_mora.nil? && _total_mora && _total_mora > 0
#
#      total_mora = _total_mora
#    end
#
#    if total_cuotas
#      total_cuotas + total_mora
#   end
#
#  end

  #hasta aqui se quitaron los comentarios

  def exigible_f=(valor)
    self.exigible = format_valor(valor)
  end

  def exigible_f

    format_f(self.exigible)

  end

  def exigible_fm
    format_fm(self.exigible)
  end


 def total_deuda_fm

  format_fm(self.deuda)

 end

 def capital_por_pagar_fm

    format_fm(self.capital_por_pagar)

 end

 def total_capital_pagado_fm


  unless (self.capital_pagado.nil? || self.capital_pago_parcial.nil?)
    format_fm(self.capital_pagado + self.capital_pago_parcial)
  end

 end


 def capital_pagado_fm

  format_fm(self.capital_pagado)

 end

 def interes_mora_pagado_fm
    monto = 0.0
    unless self.intereses_pagados.nil?
      monto = (self.intereses_pagados)
    end
    unless self.mora_pagada.nil?
      monto = monto + self.mora_pagada
    end

    format_fm(monto)

 end

 def intereses_pagados_fm

    format_fm(self.intereses_pagados)

 end

  def mora_pagada_fm

    format_fm(self.mora_pagada)

 end


  def deuda_f=(valor)
    self.deuda = valor
  end

  def deuda_f

    format_f(self.deuda)

  end

  def deuda_fm

    format_fm(self.deuda)

  end


  #private

  def modulo11(numero)
    peso = 3
    numero_a = numero.to_s.split(//)

    numero_f = Array.new
    contador = 0
    total = 0;
    numero_a = numero_a.reverse
    for a in numero_a
      total += (a.to_i * peso)
      peso+=2
    end

    residuo = total % 11
    digito = (11 - residuo.to_i).abs

    if digito==11
      digito = 1
    end
    if digito==10
      digito =0
    end

    numero_s = numero.to_s + digito.to_s
    numero = numero_s.to_i

    return numero
  end

#  def generar_plan_pago_inicial(monto, fecha)
#    calculadora = Calculadora.new
#    calculadora.metodo = self.formula_id
#    calculadora.fecha = fecha
#    calculadora.plazo = self.plazo
#    calculadora.periodo = self.frecuencia_pago
#    calculadora.monto = monto
#    calculadora.muerto_plazo = self.meses_muertos
#    calculadora.gracia_periodo = self.frecuencia_pago_gracia
#    calculadora.gracia_plazo = self.meses_gracia
#    calculadora.gracia_tasa = self.tasa_inicial
#    calculadora.tasa = self.tasa_inicial
#
#    self.errors.add_errors_with_raise(
#      calculadora.errors) unless calculadora.valid?
#    calculadora.calcular
#
#    self.dia_facturacion = calculadora.dia_facturacion
#
#    plan_pago = PlanPago.new(
#      :fecha_inicio=>calculadora.fecha_inicio,
#      :fecha_fin=>calculadora.fecha_fin,
#      :fecha_evento=>fecha,
#      :motivo_evento=>'D',
#      :prestamo=>self,
#      :dia_facturacion=>calculadora.dia_facturacion,
#      :activo=>true,
#      :proyeccion=>false,
#      :tasa_gracia=>self.tasa_inicial,
#      :tasa=>self.tasa_inicial,
#      :monto=>self.monto_liquidado,
#      :plazo=>self.plazo,
#      :meses_gracia=>self.meses_gracia,
#      :meses_muertos=>self.meses_muertos,
#      :diferir_intereses=>self.diferir_intereses,
#      :exonerar_intereses_diferidos=>self.exonerar_intereses_diferidos,
#      :frecuencia_pago=>self.frecuencia_pago,
#      :frecuencia_pago_gracia=>self.frecuencia_pago_gracia)
#
#
#    self.errors.add_errors_with_raise(
#      plan_pago.errors) unless plan_pago.save
#
#    for cuota in calculadora.muerto_cuotas
#      plan_pago_cuota = PlanPagoCuota.new(
#        :numero=>cuota.numero_real,
#        :tipo_cuota=>'M',
#        :plan_pago=>plan_pago,
#        :fecha=>cuota.fecha,
#        :saldo_insoluto=>cuota.saldo)
#      self.errors.add_errors_with_raise(
#        plan_pago_cuota.errors) unless plan_pago_cuota.save
#    end
#
#    for cuota in calculadora.gracia_cuotas
#      plan_pago_cuota = PlanPagoCuota.new(
#        :numero=>cuota.numero_real,
#        :tipo_cuota=>'G',
#        :plan_pago=>plan_pago,
#        :fecha=>cuota.fecha,
#        :valor_cuota=>cuota.monto,
#        :amortizado=>cuota.amortizado,
#        :amortizado_acumulado=>cuota.amortizado_acumulado,
#        :interes_corriente=>cuota.interes,
#        :interes_corriente_acumulado=>cuota.interes_acumulado,
#        :saldo_insoluto=>cuota.saldo,
#        :tasa_periodo=>cuota.tasa)
#      self.errors.add_errors_with_raise(
#        plan_pago_cuota.errors) unless plan_pago_cuota.save
#    end
#
#    for cuota in calculadora.cuotas
#      plan_pago_cuota = PlanPagoCuota.new(
#        :numero=>cuota.numero_real,
#        :tipo_cuota=>'C',
#        :plan_pago=>plan_pago,
#        :fecha=>cuota.fecha,
#        :valor_cuota=>cuota.monto,
#        :amortizado=>cuota.amortizado,
#        :amortizado_acumulado=>cuota.amortizado_acumulado,
#        :interes_corriente=>cuota.interes,
#        :interes_corriente_acumulado=>cuota.interes_acumulado,
#        :saldo_insoluto=>cuota.saldo,
#        :tasa_periodo=>cuota.tasa)
#      self.errors.add_errors_with_raise(
#        plan_pago_cuota.errors) unless plan_pago_cuota.save
#    end
#
#
#  end

#  p_proyectado bool,
#  p_formula_id integer,
#  p_prestamo_id integer,
#  p_fecha_liquidacion date,
#  p_monto float,
#  p_plazo integer,
#  p_frecuencia_pago integer,
#  p_tasa_valor float,
#  p_meses_muertos integer,
#  p_meses_gracia integer,
#  p_meses_diferidos integer,
#  p_tasa_valor_gracia float,
#  p_frecuencia_pago_gracia integer


#  def self.generar_plan_pago_inicial(monto_liquidado, fecha_aplicacion, prestamo_id)
#    prestamo = Prestamo.find(prestamo_id);
#    params = {
#      :proyectado=>false,
#      :formula_id=>prestamo.formula_id,
#      :prestamo_id=>prestamo.id,
#      :plan_pago_id=>0,
#      :numero_cuota_inicial=>0,
#      :tipo_cuota_inicial=>'Z',
#      :interes_acumulado_inicial=>0,
#      :amortizado_acumulado_inicial=>0,
#      :fecha_liquidacion=>prestamo.fecha_liquidacion,
#      :monto=>monto_liquidado,
#      :plazo=>prestamo.plazo,
#      :frecuencia_pago=>prestamo.frecuencia_pago,
#      :tasa_valor=>prestamo.tasa_inicial,
#      :meses_muertos=>prestamo.meses_muertos,
#      :meses_gracia=>prestamo.meses_gracia,
#      :meses_diferidos=>prestamo.meses_diferidos,
#      :exonerar_intereses_diferidos=>prestamo.exonerar_intereses_diferidos,
#      :tasa_valor_gracia=>3.0,
#      :frecuencia_pago_gracia=>1,
#    }
#    execute_sp('generar_plan_pago', params.values_at(
#      :proyectado,
#      :formula_id,
#      :prestamo_id,
#      :plan_pago_id,
#      :numero_cuota_inicial,
#      :tipo_cuota_inicial,
#      :interes_acumulado_inicial,
#      :amortizado_acumulado_inicial,
#      :fecha_liquidacion,
#      :monto,
#      :plazo,
#      :frecuencia_pago,
#      :tasa_valor,
#      :meses_muertos,
#      :meses_gracia,
#      :meses_diferidos,
#      :exonerar_intereses_diferidos,
#      :tasa_valor_gracia,
#      :frecuencia_pago_gracia))
#
#  end

  def ejecutar_pago(cliente_id, cheques, prestamos, prestamo_id, modalidad, monto, oficina, fecha_realizacion, fecha_sistema, numero_voucher, entidad_financiera_id, monto_efectivo, exonerar_mora, usuario_id, consultoria_juridica, observaciones_analista, analista_id, recuperaciones, cuenta_bcv_id)

    logger.info "Entro a ejecutar pago"

    ejecutar = false

    begin

      if exonerar_mora == true

        opcion = Opcion.find_by_ruta("prestamos/pago")

        opcion_accion = OpcionAccion.find_by_opcion_id_and_autorizacion_and_autorizacion_extendida(opcion.id, true, true)

        autorizacion = Autorizacion.find_by_usuario_id_and_opcion_accion_id_and_monto_and_estatus_and_prestamo_numero(usuario_id, opcion_accion.id, monto,'A', self.numero)

        if !autorizacion
          return I18n.t('Sistema.Body.Modelos.Prestamo.Errores.no_hay_autorizacion')
        end

      end     # Fin if exonerar_mora == true


      if !cheques.nil?
          cheques_s = '{'
          primero = true
          hay_cheques = false
          #if cheques[:monto].nil? || cheques[:monto].empty?

            #cheques = nil
          #end
          #hay_cheques = false
          logger.info "CHEQUES =====> #{cheques.inspect}"
          if !cheques.nil?
            cheques.each_value { |x|
              if x[:monto] != "0.00" and x[:monto] != ""
                cheques_s += ( primero ? '' : ',' ) + '{"' + x[:forma] +
                '","' + x[:entidad_financiera_id] +
                '","' + x[:referencia] +
                '","' + x[:monto] + '"}'
                primero = false
                hay_cheques = true
              else
                cheques = nil
                cheques_s = '{'
                cheques_s += "}"
                hay_cheques = false
                return 'sin monto cheque'
              end }
          end
          cheques_s += "}"
      else
        cheques_s = '{'
        cheques_s += "}"
        hay_cheques = false
      end # Fin if !cheques.nil?

      if modalidad == 'A'
        tipo_pago = 'R'
      else
        tipo_pago = 'P'
      end

      logger.info "Modalidad =======> #{modalidad}"
      @obj_usuario = Usuario.find(usuario_id)
      analista_nombre_completo = @obj_usuario.primer_nombre + " / " + @obj_usuario.primer_apellido

      logger.info "Analista ========> #{analista_nombre_completo}"

      params = {
        :cliente_id=>cliente_id,
        :cheques=>cheques_s,
        :prestamo_id=>prestamo_id,
        :modalidad=>modalidad,
        :monto=>monto,
        :oficina_id=>oficina.id,
        :fecha_realizacion=>fecha_realizacion,
        :fecha_sistema=>fecha_sistema,
        :numero_voucher=>numero_voucher,
        :monto_efectivo=>monto_efectivo,
        :entidad_financiera_id=>entidad_financiera_id,
        :proceso_nocturno=>false,
        :p_cancelacion=>false,
        :hay_cheques=>hay_cheques,
        :exonerar_mora=>exonerar_mora,
        :consultoria_juridica => consultoria_juridica,
        :observaciones_analista => observaciones_analista,
        :analista_nombre_completo => analista_nombre_completo,
        :p_recuperaciones=>recuperaciones,
        :p_cuenta_bcv_id=>cuenta_bcv_id,
        :p_tipo_pago=>tipo_pago
      }

      transaction do              # Transaction número 1

        #transaction do            # Transaccion número 2

          iniciar_transaccion(self.id, 'p_pago_ordinario', 'L', "#{I18n.t('Sistema.Body.Modelos.Prestamo.Transacciones.pago_ordinario')}: #{self.numero}", usuario_id, monto.to_f)

          logger.info "Entro a ejecutar pago <========> #{params.inspect}"
          ejecutar = execute_sp('ejecutar_pago', params.values_at(
            :cliente_id,
            :cheques,
            :prestamo_id,
            :modalidad,
            :monto,
            :oficina_id,
            :fecha_realizacion,
            :fecha_sistema,
            :numero_voucher,
            :monto_efectivo,
            :entidad_financiera_id,
            :proceso_nocturno,
            :p_cancelacion,
            :hay_cheques,
            :exonerar_mora,
            :consultoria_juridica,
            :observaciones_analista,
            :analista_nombre_completo,
            :p_recuperaciones,
            :p_cuenta_bcv_id,
            :p_tipo_pago
            ))

        #end                   # Fin Transaccion número 2

        iniciar_transaccion(self.id, 'p_dummy', 'L', "#{I18n.t('Sistema.Body.Modelos.Prestamo.Transacciones.transaccion_dummy')}:  #{self.numero}", usuario_id,0)

        # self.reload

        # transaction do        #Transaccion número 3

        #   prestamo = Prestamo.find(self.id)

        #   logger.info "id prestamo =======> #{self.id.to_s}"
        #   if !prestamo.nil?
          
        #     logger.info "Abono a Capital =======> #{prestamo.abono_capital.to_s}"

        #     if ejecutar == true &&
        #       prestamo.abono_capital.to_f > 0 &&
        #       prestamo.estatus != 'C'

        #       logger.info "Entro a ejecutar abono =======> #{prestamo.abono_capital.to_s}"

        #       iniciar_transaccion(prestamo.id, 'p_abono_extraordinario', 'L', "#{I18n.t('Sistema.Body.Modelos.Prestamo.Transacciones.abono_extraordinario')}: #{prestamo.numero}", usuario_id, prestamo.abono_capital.to_f)

        #       params = {
        #                 :p_prestamo_id=>prestamo.id,
        #                 :p_fecha=>fecha_sistema
        #               }

        #       valor = execute_sp('actualizar_abono_capital', params.values_at(
        #                           :p_prestamo_id,
        #                           :p_fecha))

        #       logger.info "Ejecuto abono =======> #{prestamo.abono_capital.to_s}"

        #       iniciar_transaccion(self.id, 'p_dummy', 'L', "#{I18n.t('Sistema.Body.Modelos.Prestamo.Transacciones.transaccion_dummy')}:  #{self.numero}", usuario_id,0)

        #     end     # Fin if ejecutar == true && prestamo.abono_capital.to_f > 0 && prestamo.estatus != 'C'

        #   end       # Fin if !prestamo.nil?

        # end         # Fin #Transaccion número 3

      end           # Fin Transaction número 1


      return I18n.t('Sistema.Body.General.correcto')

    rescue Exception => detail

      logger.info "Errorres en Ejecutar pago #{detail.message.to_s} - #{detail.backtrace.inspect}"
      return I18n.t('Sistema.Body.General.incorrecto')

    end

  end


  def ejecutar_pago_arrime(usuario_id, boleta_id)

    params = { :p_usuario_id=>usuario_id,
               :p_boleta_id=>boleta_id}

    valor = execute_sp('ejecutar_pago_arrime', params.values_at(:p_usuario_id, :p_boleta_id))

    iniciar_transaccion(self.id, 'p_dummy', 'L', "#{I18n.t('Sistema.Body.Modelos.Prestamo.Transacciones.transaccion_dummy')}: #{self.numero}", usuario_id,0)

    logger.info "Valor =====> valor.to_s"

    transaction do            # Transacción número 1

      logger.info "Self ========> #{self.id.to_s}"
      prestamo = Prestamo.find(self.id)

      logger.info "Abono a Capital =======> #{prestamo.abono_capital.to_s}"
      fecha_sistema = Time.now.strftime("%Y-%m-%d")

      if !prestamo.nil?

        if prestamo.abono_capital.to_f > 0 &&
           prestamo.estatus != 'C'

          iniciar_transaccion(prestamo.id, 'p_abono_extraordinario', 'L', "#{I18n.t('Sistema.Body.Modelos.Prestamo.Transacciones.abono_extraordinario')}: #{prestamo.numero}", usuario_id, prestamo.abono_capital.to_f)


          params = {
                    :p_prestamo_id=>prestamo.id,
                    :p_fecha=>fecha_sistema
                  }

          valor = execute_sp('actualizar_abono_capital', params.values_at(
                              :p_prestamo_id,
                              :p_fecha))

        end     # Fin if valor == true && prestamo.abono_capital.to_f > 0 && prestamo.estatus != 'C'

      end       # Fin if !prestamo.nil?

    end         # Fin # Transacción número 1

  end

  def cancelar_prestamo(cliente_id, prestamo_id, cheques, modalidad, monto, oficina, fecha_contabilizacion, fecha_realizacion, usuario_id, entidad_financiera_id, numero_voucher,observacion_precancelacion, monto_efectivo)

    cheques_s = '{'

      primero = true
      hay_cheques = false

      if !cheques.nil?
        cheques.each_value { |x|  cheques_s += ( primero ? '' : ',' ) + '{"' + x[:forma] +
        '","' + x[:entidad_financiera_id] +
        '","' + x[:referencia] +
        '","' + x[:monto] + '"}'; primero = false }
        hay_cheques = true
      end

    cheques_s += "}"

    @obj_usuario = Usuario.find(usuario_id)
    analista_nombre_completo = @obj_usuario.primer_nombre + " / " + @obj_usuario.primer_apellido

    params = {
      :cliente_id=>cliente_id,
      :prestamo_id=>prestamo_id,
      :cheques=>cheques_s,
      :modalidad=>modalidad,
      :monto=>monto,
      :p_monto_efectivo=>monto_efectivo,
      :oficina_id=>oficina.id,
      :fecha_contabilizacion=>fecha_contabilizacion,
      :fecha_realizacion=>fecha_realizacion,
      :p_nombre_analista=>analista_nombre_completo,
      :p_consultoria_juridica=>false,
      :p_observaciones_analista=>I18n.t('Sistema.Body.Modelos.Prestamo.ObservacionAnalista.cancelacion_anticipada'),
      :p_entidad_financiera_id=>entidad_financiera_id,
      :p_numero_voucher=>numero_voucher,
      :p_observacion_precancelacion=>observacion_precancelacion,
      :p_hay_cheques=>hay_cheques
    }

    transaction do             #Transacción número 1

      iniciar_transaccion(self.id, 'p_pre-cancelar', 'L', "#{I18n.t('Sistema.Body.Modelos.Prestamo.Transacciones.pre_cancelacion')} #{self.numero}", usuario_id,monto)

      valor = execute_sp('cancelar_prestamo', params.values_at(
        :cliente_id,
        :prestamo_id,
        :cheques,
        :modalidad,
        :monto,
        :p_monto_efectivo,
        :oficina_id,
        :fecha_contabilizacion,
        :fecha_realizacion,
        :p_nombre_analista,
        :p_consultoria_juridica,
        :p_observaciones_analista,
        :p_entidad_financiera_id,
        :p_numero_voucher,
        :p_observacion_precancelacion,
        :p_hay_cheques))

    end           # Fin Transacción número 1

      iniciar_transaccion(self.id, 'p_dummy', 'L', "#{I18n.t('Sistema.Body.Modelos.Prestamo.Transacciones.transaccion_dummy')} #{self.numero}", usuario_id,0)

  end

  codigo_transaccion = 0
  def ejecutar_contabilizacion(estatus, estatus_anterior, prestamo)

    case estatus

      when 'L'
        codigo_transaccion == 29       # Consultoría a Litigio
        iniciales = 'PLI '
      when 'Q'
        case estatus_anterior
          when 'J'
            codigo_transaccion == 31   # Consultoria a Condonado
            iniciales = 'PCO '
          when 'E'
            codigo_transaccion == 28   # Vencido a Condonado
            iniciales = 'PCO '
          when 'L'
            codigo_transaccion == 27   # Litigio a Condonado
            iniciales = 'PCO '
          when 'V'
            codigo_transaccion == 32   # Vigente a Condonado
            iniciales = 'PCO '
        end
      when 'K'
        case estatus_anterior
          when 'V'
            codigo_transaccion == 25   # Vigente a Castigado
            iniciales = 'PCA '
          when 'J'
            codigo_transaccion == 30   # Consultoria a Castigado
            iniciales = 'PCA '
          when 'L'
            codigo_transaccion == 33   # Litigio a Castigado
            iniciales = 'PCA '
          when 'E'
            codigo_transaccion == 26   # Vencido a Castigado
            iniciales = 'PCA '
        end
      when 'J'
        codigo_transaccion == 34       # Cancelación por Revocatoria
        iniciales = 'PCR '
    end

    solicitud = Solicitud.find(self.solicitud_id)
    transaccion = TransaccionContable.find(codigo_transaccion)
    fuente_recursos_id = 0
    case self.banco_origen
      when 'FONDAS'
        fuente_recursos_id = 1
      when 'AGROVENEZUELA'
        fuente_recursos_id = 2
      when 'FONDAFA'
        fuente_recursos_id = 3
    end

      params = {
        :p_transaccion_contable_id=>codigo_transaccion.to_i,
        :p_modalidad=>'X'.to_s,
        :p_fuente_recursos_id=>fuente_recursos_id.to_i,
        :p_programa_id=>prestamo.solicitud.programa_id.to_i,
        :p_estatus=>'P'.to_s,
        :p_entidad_financiera_id=>0.to_i,
        :p_monto_pago=>0.00,
        :p_monto_ingreso_intereses=>prestamo.interes_vencido.to_f + prestamo.causado_no_devengado.to_f,
        :p_monto_por_cobrar_intereses=>0.00,
        :p_remanente_por_aplicar=>0.00,
        :p_monto_capital_cuota=>prestamo.saldo_insoluto.to_f,
        :p_ingreso_mora=>prestamo.monto_mora.to_f,
        :p_remanente_por_aplicar_inicial=>0.00,
        :p_monto_comision_intereses=>0.00,
        :p_interes_diferido=>prestamo.interes_diferido_por_vencer.to_f,
        :p_monto_gasto=>0.00,
        :p_monto_sras=>prestamo.monto_sras_total.to_f,
        :p_monto_excedente=>prestamo.remanente_por_aplicar.to_f,
        :p_monto_desembolso=>0.00,
        :p_monto_boleta=>0.00,
        :p_fecha_registro=>Time.new.strftime("%Y-%m-%d").to_s,
        :p_fecha_comprobante=>Time.new.strftime("%Y-%m-%d").to_s,
        :p_prestamo_id=>prestamo.id.to_i,
        :p_factura_id=>0.to_i,
        :p_anio=>Time.new.strftime("%Y").to_i,
        :p_voucher=>iniciales.to_s << Time.new.strftime("%Y-%m-%d").to_s << " " << prestamo.id.to_s,
        :p_banco=>' ',
        :p_nombre=>prestamo.solicitud.cliente.nombre,
        :p_tipo_transaccion=>transaccion.nombre,
        :p_prestamo=>prestamo.numero.to_s,
        :p_reestructurado=>prestamo.reestructurado,
        :p_transaccion_id=>0
      }

    transaction do         #Transacción número 1

      valor = execute_sp('registro_contable', params.values_at(
        :p_transaccion_contable_id,
        :p_modalidad,
        :p_fuente_recursos_id,
        :p_programa_id,
        :p_estatus,
        :p_entidad_financiera_id,
        :p_monto_pago,
        :p_monto_ingreso_intereses,
        :p_monto_por_cobrar_intereses,
        :p_remanente_por_aplicar,
        :p_monto_capital_cuota,
        :p_ingreso_mora,
        :p_remanente_por_aplicar_inicial,
        :p_monto_comision_intereses,
        :p_interes_diferido,
        :p_monto_gasto,
        :p_monto_sras,
        :p_monto_excedente,
        :p_monto_desembolso,
        :p_monto_boleta,
        :p_fecha_registro,
        :p_fecha_comprobante,
        :p_prestamo_id,
        :p_factura_id,
        :p_anio,
        :p_voucher,
        :p_banco,
        :p_nombre,
        :p_tipo_transaccion,
        :p_prestamo,
        :p_reestructurado,
        :p_transaccion_id))

    end     # Fin Transacción número 1

  end

  def ejecutar_abono_extraordinario(cliente_id, cheques, modalidad, monto, oficina, fecha_sistema, efectivo, numero_voucher, entidad_financiera_id, usuario_id)

    cheques_s = '{'
    primero = true

    cheques.each_value { |x|  cheques_s += ( primero ? '' : ',' ) + '{"' + x[:forma] +
      '","' + x[:entidad_financiera_id] +
      '","' + x[:referencia] +
      '","' + x[:monto] + '"}'; primero = false }

    cheques_s += "}"

      params = {
        :cliente_id=>cliente_id,
        :prestamo_id=>self.id,
        :cheques=>cheques_s,
        :modalidad=>modalidad,
        :monto=>monto,
        :oficina_id=>oficina.id,
        :fecha_sistema=>fecha_sistema,
        :efectivo=>efectivo,
        :numero_voucher=>numero_voucher,
        :entidad_financiera_id=>entidad_financiera_id
      }

      transaction do
      iniciar_transaccion(self.id, 'p_abono_extraordinario_online', 'L', "Abono Extraordinario Online préstamo Número #{self.numero}", usuario_id)
      valor = execute_sp('ejecutar_abono_extraordinario', params.values_at(
        :cliente_id,
        :prestamo_id,
        :cheques,
        :modalidad,
        :monto,
        :oficina_id,
        :fecha_sistema,
        :efectivo,
        :numero_voucher,
        :entidad_financiera_id))
    end

      iniciar_transaccion(self.id, 'p_dummy', 'L', "#{I18n.t('Sistema.Body.Modelos.Prestamo.Transacciones.transaccion_dummy')} #{self.numero}", usuario_id)

  end

  #Metodo incluido por Diego Bertaso
  #

  def registrar_acumulados(monto_liquidado)

    fecha = self.fecha_liquidacion

    anio = fecha.year
    mes = fecha.month

    case mes
      when 1
        trimestre = 1
        semestre = 1
      when 2
        trimestre = 1
        semestre = 1
      when 3
        trimestre = 1
        semestre = 1
      when  4
        trimestre = 2
        semestre = 1
      when  5
        trimestre = 2
        semestre = 1
      when  6
        trimestre = 2
        semestre = 1
      when 7
        trimestre = 3
        semestre = 2
      when 8
        trimestre = 3
        semestre = 2
      when 9
        trimestre = 3
        semestre = 2
      when 10
        trimestre = 4
        semestre = 2
      when 11
        trimestre = 4
        semestre = 2
      when 12
        trimestre = 4
        semestre = 2

    end

    # ACUMULADO


    acumulado = Acumulado.find_by_anio_and_mes(anio, mes)

    if !acumulado

      acumulado = Acumulado.new
      acumulado.anio = anio
      acumulado.mes = mes
      acumulado.trimestre = trimestre
      acumulado.semestre = semestre
    end

    acumulado = acumulado_auxiliar(acumulado, monto_liquidado)

    acumulado.save

    # ACUMULADO_PROGRAMA

    acumulado_programa = AcumuladoPrograma.find_by_anio_and_mes_and_programa_id(anio, mes, self.solicitud.programa.id)

    if !acumulado_programa
      acumulado_programa = AcumuladoPrograma.new
      acumulado_programa.programa = self.solicitud.programa
      acumulado_programa.anio = anio
      acumulado_programa.mes = mes
      acumulado_programa.trimestre = trimestre
      acumulado_programa.semestre = semestre
    end
    acumulado_programa = acumulado_auxiliar(acumulado_programa, monto_liquidado)
    acumulado_programa.save

    # ACUMULADO_TIPO_CREDITO

    acumulado_tipo_credito = AcumuladoTipoCredito.find_by_anio_and_mes_and_tipo_credito_id(anio, mes, self.solicitud.programa.tipo_credito_id)
    if !acumulado_tipo_credito
      acumulado_tipo_credito = AcumuladoTipoCredito.new
      acumulado_tipo_credito.tipo_credito = self.solicitud.programa.tipo_credito
      acumulado_tipo_credito.anio = anio
      acumulado_tipo_credito.mes = mes
      acumulado_tipo_credito.trimestre = trimestre
      acumulado_tipo_credito.semestre = semestre
    end
    acumulado_tipo_credito = acumulado_auxiliar(acumulado_tipo_credito, monto_liquidado)
    acumulado_tipo_credito.save

    # ACUMULADO_ENTIDAD_FINANCIERA

    if self.solicitud.programa.intermediado

      acumulado_entidad_financiera = AcumuladoEntidadFinanciera.find_by_anio_and_mes_and_entidad_financiera_id(anio, mes, self.entidad_financiera.id)

      if !acumulado_entidad_financiera

        acumulado_entidad_financiera = AcumuladoEntidadFinanciera.new
        acumulado_entidad_financiera.entidad_financiera = self.entidad_financiera
        acumulado_entidad_financiera.anio = anio
        acumulado_entidad_financiera.mes = mes
        acumulado_entidad_financiera.trimestre = trimestre
        acumulado_entidad_financiera.semestre = semestre
      end

      acumulado_entidad_financiera = acumulado_auxiliar(acumulado_entidad_financiera, monto_liquidado)
      acumulado_entidad_financiera.save


    end


    if self.cliente.class.to_s=='ClienteEmpresa'
      # ACUMULADO_TAMANO_EMPRESA
      acumulado_tamano_empresa = AcumuladoTamanoEmpresa.find_by_anio_and_mes_and_tamano(anio, mes, self.solicitud.cliente.empresa.tamano)
      if !acumulado_tamano_empresa
        acumulado_tamano_empresa = AcumuladoTamanoEmpresa.new
        acumulado_tamano_empresa.tamano = self.solicitud.cliente.empresa.tamano
        acumulado_tamano_empresa.anio = anio
        acumulado_tamano_empresa.mes = mes
        acumulado_tamano_empresa.trimestre = trimestre
        acumulado_tamano_empresa.semestre = semestre
      end
      acumulado_tamano_empresa = acumulado_auxiliar(acumulado_tamano_empresa, monto_liquidado)
      acumulado_tamano_empresa.save

      # ACUMULADO_AGRUPACION_INDUSTRIAL
      #acumulado_agrupacion_industrial = AcumuladoAgrupacionIndustrial.find_by_anio_and_mes_and_agrupacion_industrial_id(anio, mes, self.solicitud.cliente.empresa.sector_industrial.agrupacion_industrial.id)
      #if !acumulado_agrupacion_industrial
        #acumulado_agrupacion_industrial = AcumuladoAgrupacionIndustrial.new
        #acumulado_agrupacion_industrial.agrupacion_industrial = self.solicitud.cliente.empresa.sector_industrial.agrupacion_industrial
        #acumulado_agrupacion_industrial.anio = anio
        #acumulado_agrupacion_industrial.mes = mes
        #acumulado_agrupacion_industrial.trimestre = trimestre
        #acumulado_agrupacion_industrial.semestre = semestre
      #end
      #acumulado_agrupacion_industrial = acumulado_auxiliar(acumulado_agrupacion_industrial, monto_liquidado)
      #acumulado_agrupacion_industrial.save

    end

  #ACUMULADO_REGION
    acumulado_region = AcumuladoRegion.find_by_anio_and_mes_and_region_id(anio, mes, self.solicitud.ciudad.estado.region.id)
    if !acumulado_region
      acumulado_region = AcumuladoRegion.new
      acumulado_region.region = self.solicitud.ciudad.estado.region
      acumulado_region.anio = anio
      acumulado_region.mes = mes
      acumulado_region.trimestre = trimestre
      acumulado_region.semestre = semestre
    end
    acumulado_region = acumulado_auxiliar(acumulado_region, monto_liquidado)
    acumulado_region.save

  #ACUMULADO_TIPO_CLIENTE
    acumulado_tipo_cliente = AcumuladoTipoCliente.find_by_anio_and_mes_and_tipo_cliente_id(anio, mes, self.solicitud.cliente.tipo_cliente_id)
    if !acumulado_tipo_cliente
      acumulado_tipo_cliente = AcumuladoTipoCliente.new
      acumulado_tipo_cliente.tipo_cliente = self.solicitud.cliente.tipo_cliente
      acumulado_tipo_cliente.anio = anio
      acumulado_tipo_cliente.mes = mes
      acumulado_tipo_cliente.trimestre = trimestre
      acumulado_tipo_cliente.semestre = semestre
    end
    acumulado_tipo_cliente = acumulado_auxiliar(acumulado_tipo_cliente, monto_liquidado)
    acumulado_tipo_cliente.save

    return true

  end

  def acumulado_auxiliar(acumulado, monto_liquidado)

    acumulado.monto_liquidado += monto_liquidado
    return acumulado

  end

  #Métodos para calcular el interes foncrei y el interes intermediario

def porcentaje_foncrei

  if self.intermediado

    solicitud = Solicitud.find(self.solicitud_id)

    if !solicitud
        return 0
    end

    programa = Programa.find(solicitud.programa_id)

    if !programa
        return 0
   end

   return programa.porcentaje_tasa_foncrei

  end
 end

def porcentaje_intermediario

  if self.intermediado

    solicitud = Solicitud.find(self.solicitud_id)

    if !solicitud
        return 0
    end

    programa = Programa.find(solicitud.programa_id)

    if !programa
        return 0
   end

   return  programa.porcentaje_tasa_intermediario


  end

 end

  def porcentaje_intermediario_fm

    format_fm(self.porcentaje_intermediario)

  end

  def monto_insumos_fm

    format_fm(self.monto_insumos)

  end

  def monto_liquidado_insumos_fm
    format_fm(self.monto_liquidado_insumos)
  end

  def monto_inventario_fm

    format_fm(self.monto_inventario)

  end

  def monto_facturado_fm
    format_fm(self.monto_facturado)
  end

  def monto_despachado_fm

    format_fm(self.monto_despachado)

  end

  def monto_por_despachar_fm

    unless self.monto_despachado.nil? || self.monto_insumos.nil?
      valor = self.monto_insumos - self.monto_despachado
    end

  end

  def total_plan_inversion_fm

    unless self.monto_insumos.nil? || self.monto_banco.nil?
      valor = self.monto_insumos + self.monto_banco
    end

  end

  def total_financiamiento_fm

    valor =  0.00
    if self.solicitud.sub_sector.nemonico == 'MA'
      unless self.monto_inventario.nil? || self.monto_sras_total.nil? || self.monto_gasto_total.nil?
        valor = self.monto_insumos + self.monto_inventario  + self.monto_sras_total  + self.monto_gasto_total
        #logger.info "Valor ======> #{valor.to_s}"
        #valor = sprintf('%01.2f', valor).sub('.', ',')
        #valor.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
      end
    else
     unless self.monto_insumos.nil? || self.monto_banco.nil? || self.monto_sras_total.nil? || self.monto_gasto_total.nil?
        #logger.info " Valores #{self.monto_insumos.to_s} - #{self.monto_banco} - #{self.monto_sras_total.to_s} - #{self.monto_gasto_total.to_s}"
        valor = self.monto_insumos + self.monto_banco + self.monto_sras_total  + self.monto_gasto_total
        #valor = sprintf('%01.2f', valor).sub('.', ',')
        #valor.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
        #logger.info "Valor1 ======> #{valor.to_s}"
      end
    end

    return format_fm(valor)
    
  end

 def interes_foncrei

    return self.interes_vencido * self.porcentaje_foncrei / 100
  end

  def interes_intermediario

    return self.interes_vencido - self.interes_foncrei
  end

  def deuda_foncrei

    if self.deuda.nil?
       self.deuda = 0
    end

    if self.interes_intermediario.nil?
       self.interes_intermediario = 0
    end

    if self.intermediado
      return self.deuda - self.interes_intermediario
    end

  end

  def exigible_foncrei

    if self.intermediado
      return self.exigible - self.interes_intermediario
    end
  end

 def deuda_foncrei_fm

    if self.intermediado
      format_fm(self.deuda_foncrei)
    end

end

 def exigible_foncrei_fm

    if self.intermediado

      format_fm(self.exigible_foncrei)
    end

  end

  def interes_foncrei_fm

    format_fm(self.interes_foncrei)

  end

  def interes_diferido_no_pagado_fm

    format_fm(self.interes_diferido_vencido + self.interes_diferido_por_vencer)

  end


  def interes_intermediario_fm


    unless self.interes_intermediario.nil?

      format_fm(self.interes_intermediario)

    end

  end

 def descripcion_ultimo_desembolso_w

    case self.ultimo_desembolso

      when 0
        I18n.t('Sistema.Body.Modelos.Prestamo.UltimoDesembolso.inmediata')
      when 1
        I18n.t('Sistema.Body.Modelos.Prestamo.UltimoDesembolso.primer')
      when 2
        I18n.t('Sistema.Body.Modelos.Prestamo.UltimoDesembolso.ultimo')
      when 3
        I18n.t('Sistema.Body.Modelos.Prestamo.UltimoDesembolso.fin')

    end

  end

  #Método para suspensión de préstamo incluido por Diego Bertaso

  def suspension

    if self.estatus != 'X'
      self.estatus = 'X'
      self.save
    else
      self.estatus = 'V'
      self.save
    end

  end

  def update_estatus

    if self.estatus != 'X'

      self.estatus = 'X'
      self.save

    else

      if self.dias_mora > 0
        self.estatus = 'E'
      else
        self.estatus = 'V'
      end

      self.save
    end

  end

  def fecha_base_f

    format_fecha(self.fecha_base)
  end

  def asignar_tasa_regimen
    logger.debug "AsignarTasaRegimen"
    transaction do
      cliente = self.solicitud.cliente
      regimen_propiedad = RegimenTipoCliente.find_by_tipo_cliente_id(cliente.tipo_cliente.id).regimen_propiedad
      programa = self.solicitud.programa
      tasa = regimen_propiedad.tasa
      tasa_valor = TasaValor.find(:first, :conditions=>"tasa_id=#{tasa.id.to_s}", :order => 'id desc')
      self.tasa = tasa
      self.tasa_referencia_inicial = tasa_valor.valor
      self.tasa_vigente = tasa_valor.valor
      self.tasa_inicial = tasa_valor.valor
      #Si no existe un histórico de tasa, se procede a crear
      tasa_historico = TasaHistorico.find(:all, :conditions=>['programa_id=? and tasa_valor_id=?', programa.id, tasa_valor.id])

      if tasa_historico.length == 0

        tasa_intermediario = 0
        porcentaje_tapp = 0
        porcentaje_tapp = round_2_decimal(tasa_valor.valor*(programa.porcentaje_tasa_tapp/100)) if tasa_valor.valor > 0

        if programa.tipo_credito.id == 2
          tasa_foncrei = 0
          tasa_foncrei = round_2_decimal(porcentaje_tapp*(programa.porcentaje_tasa_foncrei/100)) if tasa_valor.valor > 0
          tasa_intermediario = porcentaje_tapp-tasa_foncrei
        else
          tasa_foncrei = porcentaje_tapp
          tasa_intermediario = 0
        end
        tasa_cliente = tasa_foncrei+tasa_intermediario

        tasa_historico = TasaHistorico.new
        tasa_historico.programa_id=programa.id
        tasa_historico.tasa_valor_id=tasa_valor.id
        tasa_historico.tasa_intermediario=tasa_intermediario
        tasa_historico.tasa_foncrei=tasa_foncrei
        tasa_historico.tasa_cliente=tasa_cliente
        #tasa_historico.regimen_propiedad_id = regimen_propiedad.id
        tasa_historico.save

      end
    end
  end

  def round_2_decimal(valor)
    valor = valor * 100
    valor = valor.to_i
    valor = valor/100.0
    valor
  end

  #
  # Calcula el monto total desembolsado para un rubro hasta el momento
  #
  def monto_desembolsado_rubro rubro_id
    total = 0.00
    desembolsos = self.desembolsos.find(:all, :conditions => 'realizado=true')
    desembolsos.each do |desembolso|
      unless desembolso.detalles.nil? || desembolso.detalles.find_by_rubro_id(rubro_id).nil?
        total += desembolso.detalles.sum(:monto, :conditions => "rubro_id=#{rubro_id}")
      end
    end unless desembolsos.nil?
    return total
  end

  def asignar_seguimiento user, session
    begin
      success = true
      transaction do
        desembolso = self.desembolsos.find_by_realizado(false)
        if desembolso.nil?
          #Se inicializa el desembolso, si no existe
          desembolso = Desembolso.new(:prestamo=>self)
          unless self.solicitud.causa_liberacion.nil?
            desembolso.monto = self.monto_solicitado - self.monto_liquidado
          else
            desembolso.monto = self.monto_liquidado
          end
          desembolso.modalidad = 'P'
          desembolso.tipo_desembolso = 'D'
          desembolso.usuario = user
          desembolso.ip_address = session
          desembolso.validar_pago = false
          desembolso.save!
          success &&= desembolso.save!
          raise Exception, I18n.t('Sistema.Body.Modelos.Prestamo.Errores.guardando_datos_desembolso') unless success

          desembolso = self.desembolsos.find_by_realizado(false)
        end
        self.estatus_desembolso = 'V'

        success &&= self.save!
        raise Exception, I18n.t('Sistema.Body.Modelos.Prestamo.Errores.guardando_datos_prestamo') unless success

        txt_comentario = "#{I18n.t('Sistema.Body.Vistas.General.prestamo')} #{self.numero} / #{self.estatus_desembolso_w}"
        # Crea un nuevo registro en la tabla control_solicitud
        success &&= ControlSolicitud.create_new(solicitud.id, 10015, user.id, I18n.t('Sistema.Body.General.avanzar'), 10015, txt_comentario)
        raise Exception, I18n.t('Sistema.Body.Modelos.Prestamo.Errores.registro_traza_seguimiento') unless success

        return desembolso
      end
    rescue Exception => e
      return false
    end
  end

  def avanzar_estatus_desembolso user, session
    solicitud = self.solicitud
    begin
      success = true
      transaction do
        if !self.solicitud.causa_liberacion.nil? && self.estatus_desembolso == 'V' && self.monto_por_liquidar == 0 && self.estatus_desembolso
          #Desembolso pasa directamente a finanzas (reestructuración simple)
          self.estatus_desembolso = 'F'
          success &&= self.save!
        else
          estatus_desembolso = ['E','V','I','L','T','F', 'A']
          estatus_origen = self.estatus_desembolso
          estatus_destino = estatus_desembolso[ (estatus_desembolso.index self.estatus_desembolso) + 1 ]
          self.estatus_desembolso = estatus_destino
          success &&= self.save!
        end

        txt_comentario = "#{I18n.t('Sistema.Body.Vistas.General.prestamo')} #{self.numero} / #{self.estatus_desembolso_w}"
        # Crea un nuevo registro en la tabla control_solicitud
        success &&= ControlSolicitud.create_new(solicitud.id, 10015, user.id, 'Avanzar', 10015, txt_comentario)
        raise Exception, I18n.t('Sistema.Body.Modelos.Prestamo.Errores.registro_traza_seguimiento') unless success
        return success
      end
    rescue Exception => e
      return false
    end
  end

  def validate
    #validate_codigo_contable
    if self.meses_gracia < 0
      errors.add(:prestamo, I18n.t('Sistema.Body.Modelos.Prestamo.Errores.meses_gracia_no_puede_ser_menor_cero'))
    end
  end

  def validate_codigo_contable


    origen_fondo = self.solicitud.origen_fondo_id
    codigo_contable = self.codigo_contable

    if origen_fondo == 2
      #Bandes Directo
      if codigo_contable == COD_GENERIC
        return true
      else
        pre = Prestamo.find(:first, :conditions=>['codigo_contable=? AND id <> ? and codigo_d3 is null', self.codigo_contable, self.id])
        unless pre
          #Código contable no cargado previamente. Procede actualización
          return true
        else
          errors.add(:prestamo, I18n.t('Sistema.Body.Modelos.Prestamo.Errores.codigo_contable_ya_actualizado'))
          return false
        end
      end
    elsif origen_fondo == 3 || origen_fondo == 4
      #Fondo Autónomo Social

      if codigo_contable == COD_FONDOS_AUTONOMOS || !codigo_d3.nil?
        return true
      else
        errors.add(:prestamo, "#{I18n.t('Sistema.Body.Modelos.Prestamo.Errores.codigo_contable_no_corresponde_autonomos')} (#{COD_FONDOS_AUTONOMOS})")
        return false
      end
#    elsif origen_fondo == 5
#      #Líneas de Crédito
#      logger.debug "Origen de fondo LINEA DE CREDITO"
#      codigo_contable = CodigoContable.find(:first, :conditions=>["codigo=?", self.codigo_contable])
#      unless codigo_contable.nil?
#        return true
#      else
#        self.errors.add('Código Contable', "no se encuentra registrado para líneas de crédito")
#        return false
#      end
    elsif origen_fondo == 6
      #Líneas de Crédito
      logger.debug "Origen de fondo MICROCRÉDITO"
      if codigo_contable == COD_MICROCREDITO || !codigo_d3.nil?
        return true
      else
        errors.add('Código Contable', "#{I18n.t('Sistema.Body.Modelos.Prestamo.Errores.codigo_contable_no_corresponde_microcreditos')} (#{COD_MICROCREDITO})")
        return false
      end
    end
  end

  def eliminar_desembolso_pendiente
    begin
      success = true
      transaction do
        desembolso = Desembolso.find(:first, :conditions=>"realizado=false and prestamo_id=#{self.id}")
        unless desembolso.nil?
          desembolso.informe.destroy unless desembolso.informe.nil?
          desembolso.desembolso_seguimiento.destroy unless desembolso.desembolso_seguimiento.nil?
          desembolso.detalles.each do |detalle|
            detalle.destroy
          end
          desembolso.destroy
        end
        return true
      end
    rescue Exception => e
      return false
    end
  end

  def get_codigo_contable
    origen_fondo = self.solicitud.OrigenFondo.id
    if origen_fondo == 2
     return COD_MICROCREDITO
    elsif origen_fondo == 3
      return COD_FONDOS_AUTONOMOS
    else
      return COD_GENERIC
    end
  end



    def pagar_excedente_arrime(user,prestamos)
      begin
        success = true
        transaction do
          prestamos.each do |prestamo|

            orden_despacho = OrdenAbonoExcedenteArrime.new(
               :solicitud_id => prestamo.solicitud_id,
               :prestamo_id => prestamo.id,
               :cliente_id => prestamo.cliente_id,
               :fecha_envio => Time.now,
               :usuario_id => user.id,
               :monto_abono => prestamo.remanente_por_aplicar,
               :estatus_id => 30000
              )
              successOrden = orden_despacho.save

              if successOrden == false
                errors.add(:prestamo, "#{I18n.t('Sistema.Body.Modelos.Prestamo.Errores.no_puede_crearse_orden_pago')} #{prestamo.numero}")
                raise Exception, I18n.t('Sistema.Body.Modelos.Prestamo.Errores.guardar_registro_control')
                #return false
              end

              prestamo.remanente_por_aplicar = 0
              successPrestamo = prestamo.save

              if successPrestamo == false
                errors.add(:prestamo, "#{I18n.t('Sistema.Body.Modelos.Prestamo.Errores.error_actualizando_prestamo')} #{prestamo.numero}")
                raise Exception, I18n.t('Sistema.Body.Modelos.Prestamo.Errores.guardar_registro_control')
                #return false
              end

           end

          return true
        end
      rescue Exception => e
        return false
      end
    end

end


# == Schema Information
#
# Table name: prestamo
#
#  id                                         :integer         not null, primary key
#  numero                                     :integer(8)      not null
#  monto_solicitado                           :decimal(16, 2)  default(0.0)
#  monto_aprobado                             :decimal(16, 2)  default(0.0)
#  fecha_aprobacion                           :date
#  formula_id                                 :integer
#  tasa_fija                                  :boolean
#  tasa_id                                    :integer
#  diferencial_tasa                           :float
#  tasa_referencia_inicial                    :float
#  plazo                                      :integer(2)      default(0)
#  meses_fijos_sin_cambio_tasa                :integer(2)      default(0)
#  meses_gracia_si                            :boolean         default(FALSE)
#  meses_gracia                               :integer(2)      default(0)
#  meses_muertos_si                           :boolean         default(FALSE)
#  meses_muertos                              :integer(2)      default(0)
#  cliente_id                                 :integer         not null
#  tipo_credito_id                            :integer
#  oficina_id                                 :integer         not null
#  solicitud_id                               :integer         not null
#  estatus                                    :string(1)       default("S")
#  tasa_mora_id                               :integer
#  forma_calculo_intereses                    :string(1)
#  base_calculo_intereses                     :integer         default(360)
#  permitir_abonos                            :boolean         default(TRUE)
#  abono_forma                                :string(1)       default("P")
#  abono_porcentaje                           :float           default(0.0)
#  abono_cantidad_cuotas                      :integer(2)      default(0)
#  abono_monto_minimo                         :float           default(0.0)
#  abono_lapso_minimo                         :integer(2)      default(0)
#  abono_dias_vencimiento                     :float           default(0.0)
#  exonerar_intereses_mora                    :boolean         default(FALSE)
#  base_cobro_mora                            :string(1)
#  diferir_intereses                          :boolean         default(FALSE)
#  exonerar_intereses_diferidos               :boolean         default(FALSE)
#  frecuencia_pago                            :integer(2)      default(0)
#  tasa_valor                                 :float           default(0.0)
#  exonerar_intereses                         :boolean         default(FALSE)
#  numero_veces_mora                          :integer(2)      default(0)
#  fecha_cambio_estatus                       :date            not null
#  tasa_inicial                               :float           default(0.0)
#  tasa_vigente                               :float           default(0.0)
#  dia_facturacion                            :integer(2)      default(0)
#  estatus_desembolso                         :string(1)       default("E")
#  saldo_insoluto                             :decimal(16, 2)  default(0.0)
#  interes_vencido                            :decimal(16, 2)  default(0.0)
#  dias_mora                                  :integer(2)      default(0)
#  monto_mora                                 :decimal(16, 2)  default(0.0)
#  causado_no_devengado                       :decimal(16, 2)  default(0.0)
#  interes_diferido_vencido                   :decimal(16, 2)  default(0.0)
#  remanente_por_aplicar                      :decimal(16, 2)  default(0.0)
#  cantidad_cuotas_vencidas                   :integer(2)      default(0)
#  monto_cuotas_vencidas                      :decimal(16, 2)  default(0.0)
#  deuda                                      :decimal(16, 2)  default(0.0)
#  exigible                                   :decimal(16, 2)  default(0.0)
#  capital_vencido                            :decimal(16, 2)  default(0.0)
#  fecha_revision_tasa                        :date
#  porcentaje_riesgo_foncrei                  :float
#  porcentaje_riesgo_intermediario            :float
#  porcentaje_tasa_foncrei                    :float
#  porcentaje_tasa_intermediario              :float
#  frecuencia_pago_intermediario              :integer(2)
#  intermediado                               :boolean         default(FALSE)
#  entidad_financiera_id                      :integer
#  interes_desembolso_vencido                 :decimal(16, 2)  default(0.0)
#  destinatario                               :string(1)       default("E")
#  fecha_cobranza_intermediario               :date
#  tasa_cero                                  :boolean         default(FALSE)
#  monto_liquidado                            :decimal(16, 2)
#  fecha_liquidacion                          :date
#  liberada                                   :boolean         default(FALSE)
#  causa_liberacion                           :string(1)       default("R")
#  aumento_capital                            :decimal(16, 2)  default(0.0)
#  reestructurado                             :string(1)       default("N")
#  prestamo_origen_id                         :integer
#  prestamo_destino_id                        :integer
#  traslado_origen                            :float
#  traslado_destino                           :float
#  tasa_forzada                               :boolean         default(FALSE)
#  tasa_forzada_fecha_vigencia                :date
#  tasa_forzada_monto                         :float
#  fecha_inicio                               :date
#  fecha_ultimo_cierre                        :date
#  migrado_d3                                 :boolean         default(FALSE)
#  codigo_d3                                  :string(20)
#  interes_diferido_por_vencer                :decimal(16, 2)  default(0.0)
#  capital_pago_parcial                       :decimal(16, 2)  default(0.0)
#  saldo_capital                              :float           default(0.0)
#  meses_diferidos                            :integer         default(0)
#  senal_visita                               :boolean         default(FALSE)
#  numero_d3                                  :integer(8)      default(0)
#  porcentaje_riesgo_sudeban                  :decimal(16, 6)  default(0.0)
#  clasificacion_riesgo_sudeban               :string(4)
#  conversion_cuotas_mensuales_sudeban        :decimal(16, 2)  default(0.0)
#  provision_individual_sudeban               :decimal(16, 2)  default(0.0)
#  porcentaje_riesgo_bandes                   :decimal(16, 6)  default(0.0)
#  clasificacion_riesgo_bandes                :string(4)
#  conversion_cuotas_mensuales_bandes         :decimal(16, 2)  default(0.0)
#  provision_individual_bandes                :decimal(16, 2)  default(0.0)
#  fecha_base                                 :date
#  ultimo_desembolso                          :integer         default(9)
#  codigo_contable                            :string(6)       default("000000")
#  banco_origen                               :string(25)      default("FONDAS")
#  tipo_cartera_id                            :integer         default(1)
#  abono_capital                              :decimal(16, 2)  default(0.0)
#  dias_demorado                              :integer         default(0)
#  dias_vencido                               :integer         default(0)
#  dias_vigente                               :integer         default(0)
#  cuotas_pagadas                             :integer         default(0)
#  cuotas_pendientes                          :integer         default(0)
#  cuotas_especiales_pagadas                  :integer         default(0)
#  cuotas_especiales_vencidas                 :integer         default(0)
#  cuotas_especiales_pendientes               :integer         default(0)
#  capital_pagado                             :decimal(14, 2)  default(0.0)
#  capital_por_pagar                          :decimal(14, 2)  default(0.0)
#  intereses_pagados                          :decimal(16, 2)  default(0.0)
#  mora_pagada                                :decimal(16, 2)  default(0.0)
#  tipo_diferimiento                          :boolean         default(TRUE)
#  porcentaje_diferimiento                    :decimal(5, 2)   default(0.0)
#  consolidar_deuda                           :boolean
#  pago_mora_migracion                        :decimal(16, 2)  default(0.0)
#  cuotas_pagadas_migracion                   :integer         default(0)
#  monto_banco                                :decimal(16, 2)
#  monto_insumos                              :decimal(16, 2)
#  fecha_vencimiento                          :date
#  monto_cuota                                :decimal(16, 2)  default(0.0), not null
#  monto_cuota_gracia                         :decimal(16, 2)  default(0.0), not null
#  rubro_id                                   :integer         not null
#  producto_id                                :integer         default(12), not null
#  monto_sras_primer_ano                      :decimal(16, 2)  default(0.0)
#  monto_sras_anos_subsiguientes              :decimal(16, 2)  default(0.0)
#  monto_sras_total                           :decimal(16, 2)  default(0.0)
#  monto_facturado                            :decimal(16, 2)  default(0.0)
#  monto_despachado                           :decimal(16, 2)  default(0.0)
#  fecha_instruccion_pago                     :date
#  instruccion_pago                           :boolean         default(FALSE)
#  monto_inventario                           :decimal(16, 2)
#  monto_liquidado_insumos                    :decimal(16, 2)  default(0.0)
#  sub_rubro_id                               :integer
#  actividad_id                               :integer
#  monto_gasto_total                          :decimal(16, 2)  default(0.0), not null
#  moneda_id                                  :integer         default(1), not null
#  cantidad_veces_mora                        :integer         default(0), not null
#  cantidad_veces_vigente                     :integer         default(0), not null
#  cantidad_dias_mora_acumulados              :integer         default(0), not null
#  cantidad_compromisos_incumplidos           :integer         default(0), not null
#  empresa_cobranza_id                        :integer
#  tasa_conversion                            :decimal(16, 2)  default(1.0), not null
#  fecha_tasa_conversion                      :date            default(Tue, 15 Oct 2013), not null
#  valor_moneda_nacional                      :decimal(16, 2)
#  porcentaje_veces_mora                      :decimal(5, 2)
#  porcentaje_dias_mora                       :decimal(5, 2)
#  indice_morosidad                           :decimal(5, 2)
#  porcentaje_recuperacion_real_capital       :decimal(5, 2)
#  porcentaje_recuperacion_esperada_capital   :decimal(5, 2)
#  capital_cuotas_fecha                       :decimal(16, 2)
#  desviacion_recuperacion_capital            :decimal(5, 2)
#  dias_atraso_promedio                       :integer
#  porcentaje_recuperacion_real_intereses     :decimal(5, 2)
#  total_interes                              :decimal(16, 2)
#  porcentaje_recuperacion_esperado_intereses :decimal(5, 2)
#  interes_cuota_fecha                        :decimal(16, 2)
#  desviacion_recuperacion_intereses          :decimal(5, 2)
#  porcentaje_pagos_incumplidos               :decimal(5, 2)
#  analista_cobranzas_id                      :integer
#

