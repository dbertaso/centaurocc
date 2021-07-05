# encoding: utf-8

#
# autor: Diego Bertaso
# clase: ParametroGeneral
# descripción: Migración a Rails 3
#

class ParametroGeneral < ActiveRecord::Base

  self.table_name = 'parametro_general'
  

  attr_accessible   :id,
                    :tasa_maxima_mora,
                    :dias_gracia_mora,
                    :tipo_dia_gracia_mora,
                    :detener_mora_edad,
                    :detener_mora_cuotas,
                    :detener_mora_garantia,
                    :dia_mes_primer_ciclo,
                    :dia_mes_segundo_ciclo,
                    :porcentaje_maximo_tapp,
                    :porcentaje_minimo_tapp,
                    :dias_vigencia_clave,
                    :monto_maximo_aprueba_comite,
                    :monto_maximo_fianza_solidaria,
                    :exonerar_intereses_desembolso,
                    :numero_prestamo_inicial,
                    :ultima_factura,
                    :plazo_maximo_prestamo_reestructurado,
                    :fecha_ultimo_cierre,
                    :fecha_proximo_cierre,
                    :max_integrantes_grupo,
                    :min_integrantes_grupo,
                    :monto_max_credito_integrante_uea,
                    :monto_max_credito_coop,
                    :numero_grupo_inicial,
                    :anio_constitucion_comite_vigente,
                    :numero_empresa,
                    :cuotas_credito_vencido,
                    :cuotas_credito_solvente,
                    :numero_solicitud_inicial_uea,
                    :numero_solicitud_inicial_coop,
                    :numero_solicitud_inicial_indiv,
                    :numero_comite_vigente,
                    :numero_contrato_inicial,
                    :numero_acta_uea,
                    :numero_acta_coop,
                    :numero_acta_indiv,
                    :numero_acta_liq_uea,
                    :numero_acta_liq_indiv,
                    :numero_acta_liq_coop,
                    :cuotas_envio_cobro,
                    :numero_acta_reestructuracion,
                    :dia_facturacion,
                    :penalizacion_mora,
                    :cuotas_pase_vencido,
                    :firma_coordinacion_presupuestaria,
                    :numeracion_instancia_firma_delegada,
                    :numeracion_instancia_comite_credito,
                    :numeracion_instancia_directorio,
                    :numeracion_instancia_fondos_autonomos,
                    :banda_superior_fondos_autonomos,
                    :banda_inferior_fondos_autonomos,
                    :banda_superior_firma_delegada,
                    :banda_inferior_firma_delegada,
                    :banda_superior_comite_credito,
                    :banda_inferior_comite_credito,
                    :banda_superior_directorio,
                    :banda_inferior_directorio,
                    :numero_punto_inicial,
                    :numero_reunion_inicial,
                    :firma_presidente,
                    :firma_gerencia_cooperacion_financiamiento_nacional,
                    :numero_seguimiento_inicial,
                    :firma_coordinacion_seguimiento,
                    :firma_especialista_seguimiento,
                    :tasa_conversion_unidades_tributarias,
                    :firma_vicepresidente,
                    :porcentaje_interes_a_reestructurar,
                    :notif_liquidacion,
                    :notif_tesoreria,
                    :integracion_administrativo,
                    :wsdl_administrativo,
                    :numeracion_instancia_nacional,
                    :codigo_tecnico_campo,
                    :porcentaje_sras_primer_ano,
                    :porcentaje_sras_anos_subsiguientes,
                    :nro_lote,
                    :caducidad_orden_despacho,
                    :caducidad_casa_proveedora,
                    :tipo_fuente,
                    :margen_izquierdo,
                    :margen_derecho,
                    :margen_superior,
                    :margen_inferior,
                    :tamano_fuente,
                    :interlineado,
                    :codigo_seg,
                    :valor_dolar,
                    :porcentaje_arrime_reestructuracion,
                    :dias_max_vencimiento_ultima_cuota,
                    :porcentaje_sras_maquinaria,
                    :porcentaje_sras_maquinaria_primer_anno,
                    :porcentaje_sras_maquinaria_anno_subsiguientes,
                    :nro_lote_fideicomiso,
                    :monto_maximo_fianza_solidaria_f,
                    :monto_maximo_aprueba_comite_f,
                    :porcentaje_sras_primer_ano_f,  
                    :porcentaje_sras_maquinaria_primer_anno_f,  
                    :porcentaje_sras_anos_subsiguientes_f,  
                    :porcentaje_sras_maquinaria_anno_subsiguientes_f,  
                    :tasa_maxima_mora_f,
                    :detener_mora_garantia_f,
                    :porcentaje_maximo_tapp_f,
                    :porcentaje_minimo_tapp_f,
                    :porcentaje_arrime_reestructuracion_f,
                    :monto_max_credito_integrante_uea_f,
                    :monto_max_credito_coop_f,
                    :moneda_id,
                    :rango_dias_compromiso_pago

  belongs_to :moneda

  validates_presence_of :banda_inferior_comite_credito,
    :message => I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.comite_credito_bi_requerido')

  validates_presence_of :banda_superior_comite_credito,
    :message => I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.comite_credito_bs_requerido')

  validates_numericality_of :banda_inferior_comite_credito,
    :message => I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.comite_credito_bi_no_numerico')

  validates_numericality_of :banda_superior_comite_credito,
    :message => I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.comite_credito_bs_no_numerico')

  validates_presence_of :porcentaje_interes_a_reestructurar,
    :message => I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.porcentaje_interes_reestructurar_requerido')

  validates_presence_of :valor_dolar,
    :message => I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.valor_dolar_requerido')

  validates_numericality_of :valor_dolar,
    :message => I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.valor_dolar_no_numerico')

  validates_presence_of :banda_inferior_directorio,
    :message => I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.directorio_bi_requerido')

  validates_presence_of :banda_superior_directorio,
    :message => I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.directorio_bs_requerido')


  validates_presence_of :moneda_id,
    :message => I18n.t('Sistema.Body.Modelos.ParametrosGenerales.Errores.moneda_es_requerida')

  validates_numericality_of :banda_inferior_directorio,
    :message => I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.directorio_bi_no_numerico')

  validates_numericality_of :banda_superior_directorio,
    :message => I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.directorio_bs_no_numerico')

  validates_presence_of :tasa_conversion_unidades_tributarias,
    :message => I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.valor_ut_requerido')

  validates_numericality_of :tasa_conversion_unidades_tributarias,
    :message => I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.valor_ut_requerido')

  validates_numericality_of :max_integrantes_grupo,
    :message => I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.max_integrantes_no_numerico')

  validates_numericality_of :min_integrantes_grupo,
    :message => I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.min_integrantes_no_numerico')

  validates_numericality_of :cuotas_credito_vencido,
    :message => I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.cuotas_credito_vencido_no_numerico')

  validates_numericality_of :cuotas_credito_solvente,
    :message => I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.cuotas_credito_vigente_no_numerico')

  validates_numericality_of :tasa_maxima_mora,
    :message => I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.cuotas_credito_vigente_no_numerico')

  validates_numericality_of :dias_gracia_mora, :only_integer => true,
    :message => I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.dias_gracia_mora_no_numerico')

  validates_numericality_of :detener_mora_edad, :only_integer => true,
    :message => I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.detener_mora_edad_no_numerico')

  validates_numericality_of :detener_mora_garantia,
    :message => I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.detener_mora_garantia_no_numerico')

  validates_numericality_of :dia_mes_primer_ciclo,
    :message => I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.dia_primer_ciclo_no_numerico')

  validates_numericality_of :dia_mes_segundo_ciclo,
    :message => I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.dia_segundo_ciclo_numerico')

  validates_numericality_of :porcentaje_maximo_tapp,
    :message => I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.porcentaje_maximo_tapp_no_numerico')

  validates_numericality_of :porcentaje_minimo_tapp,
    :message => I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.porcentaje_minimo_tapp_no_numerico')

  validates_numericality_of :monto_maximo_aprueba_comite,
    :message => I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.monto_maximo_comite_no_numerico')

  validates_numericality_of :monto_maximo_fianza_solidaria,
    :message => I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.monto_fianza_no_numerico')

  validates_numericality_of :plazo_maximo_prestamo_reestructurado,
    :message => I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.plazo_maximo_reestruturado_no_numerico')

  validates_numericality_of :monto_max_credito_integrante_uea,
    :message => I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.monto_maximo_uea_no_numerico')

  validates_numericality_of :monto_max_credito_coop,
    :message => I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.monto_maximo_cooperativa_no_numerico')

  validates_numericality_of :numero_acta_uea,
    :message => I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.numero_acta_uea_no_numerico')

  validates_numericality_of :numero_acta_coop,
    :message => I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.numero_acta_cooperativa_no_numerico')

  validates_numericality_of :numero_acta_indiv,
    :message => I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.numero_acta_individual_no_numerico')

  validates_numericality_of :numero_contrato_inicial,
    :message => I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.numero_contrato_inicial_no_numerico')

  validates_numericality_of :anio_constitucion_comite_vigente,
    :message => I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.anio_constitucion_comite_no_numerico')

  validates_numericality_of :numero_comite_vigente,
    :message => I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.numero_comite_no_numerico')

  validates_numericality_of :cuotas_envio_cobro,
    :message => I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.cuotas_envio_cobro_no_numerico')

  validates_numericality_of :caducidad_orden_despacho,
    :message => I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.caducidad_orden_despacho_no_numerico')

  validates_numericality_of :caducidad_casa_proveedora,
    :message => I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.caduciad_casa_proveedora_no_numerico')

  validates_numericality_of :porcentaje_sras_primer_ano,
    :message => I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.sras_primer_ano_no_numerico')

  validates_numericality_of :porcentaje_sras_anos_subsiguientes,
    :message => I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.sras_anos_siguientes_no_numerico')

  
  validates_numericality_of :porcentaje_sras_maquinaria_primer_anno,
    :message => I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.sras_maquinaria_primer_ano_no_numerico')

  validates_numericality_of :porcentaje_sras_maquinaria_anno_subsiguientes,
    :message => I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.sras_maquinaria_anos_siguientes_no_numerico')
  
  
  
  validates :caducidad_orden_despacho, :inclusion => { :in => 0..1000,
    :message => I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.plazo_vencimiento_orden_despacho') }

  validates :caducidad_casa_proveedora, :inclusion => { :in => 0..1000,
    :message => I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.plazo_vencimiento_casa_proveedora') }

  validates_presence_of :dias_max_vencimiento_ultima_cuota,
    :message => I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.cantidad_dias_max_al_vencimiento_es_requerido')

  validates_numericality_of :dias_max_vencimiento_ultima_cuota,
    :message => I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.cantidad_dias_max_al_vencimiento_es_invalido')

  validates_inclusion_of :dias_max_vencimiento_ultima_cuota, :in => 1..999, :message => I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.cantidad_dias_max_al_vencimiento_rango')

validate :validate

  def validate

     if !self.banda_inferior_comite_credito.nil?
      if self.banda_inferior_comite_credito.to_i < 0
       errors.add(:parametro_general, I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.comite_credito_bi_mayor_cero'))
       return false
      end
     end

     if !self.banda_superior_comite_credito.nil?
     if self.banda_superior_comite_credito.to_i < 0
       errors.add(:parametro_general, I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.comite_credito_bs_mayor_cero'))
       return false
     end
     end

    if !self.banda_inferior_directorio.nil?
     if self.banda_inferior_directorio.to_i < 0
       errors.add(:parametro_general, I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.directorio_bi_mayor_cero'))
       return false
     end
    end
    if !self.banda_superior_directorio.nil?
     if self.banda_superior_directorio.to_i < 0
       errors.add(:parametro_general, I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.directorio_bs_mayor_cero'))
       return false
     end
    end

    if !self.tasa_conversion_unidades_tributarias.nil?
      if self.tasa_conversion_unidades_tributarias <= 0
       errors.add(:parametro_general, I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.valor_ut_mayor_cero'))
       return false
      end
    end

    
      if self.max_integrantes_grupo.to_i < 0
        errors.add(:parametro_general, I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.valor_ut_mayor_cero'))
        return false
      end
    

    if self.min_integrantes_grupo.to_i < 0
      errors.add(:parametro_general, I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.min_integrantes_mayor_cero'))
    end

    if self.cuotas_credito_vencido.to_i < 0
      errors.add(:parametro_general, I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.cuotas_credito_vencido_mayor_cero'))
    end

    if self.cuotas_credito_solvente.to_i < 0
      errors.add(:parametro_general, I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.cuotas_credito_vigente_mayor_cero'))
    end

    if self.detener_mora_edad.to_i < 0
      errors.add(:parametro_general, I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.detener_mora_edad_mayor_cero'))
    end

    if self.dias_gracia_mora.to_i  < 0
      errors.add(:parametro_general, I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.dias_gracia_mora_mayor_cero'))
    end

    if self.monto_maximo_aprueba_comite.to_i < 0
      errors.add(:parametro_general, I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.monto_maximo_comite_mayor_cero'))
    end

    if self.monto_maximo_fianza_solidaria.to_i < 0
      errors.add(:parametro_general, I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.monto_fianza_mayor_cero'))
    end

    if self.plazo_maximo_prestamo_reestructurado.to_i < 0
      errors.add(:parametro_general, I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.plazo_maximo_reestructurado_mayor_cero'))
    end

    if self.monto_max_credito_integrante_uea.to_i < 0
      errors.add(:parametro_general, I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.monto_maximo_uea_mayor_cero'))
    end

    if self.monto_max_credito_coop.to_i < 0
      errors.add(:parametro_general, I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.monto_maximo_cooperativa_mayor_cero'))
    end

    if self.numero_acta_uea.to_i < 0
      errors.add(:parametro_general, I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.numero_acta_uea_mayor_cero'))
    end

    if self.numero_acta_coop.to_i < 0
      errors.add(:parametro_general, I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.numero_acta_cooperativa_mayor_cero'))
    end

    if self.numero_acta_indiv.to_i < 0
      errors.add(:parametro_general, I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.numero_acta_individual_mayor_cero'))
    end

    if self.numero_acta_liq_indiv.to_i < 0
      errors.add(:parametro_general, I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.numero_acta_liq_individual_mayor_cero'))
    end

    if self.numero_acta_liq_coop.to_i < 0
      errors.add(:parametro_general, I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.numero_acta_liq_cooperativa_mayor_cero'))
    end

    if self.numero_acta_liq_uea.to_i < 0
      errors.add(:parametro_general, I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.numero_acta_liq_uea_mayor_cero'))
    end

    if self.numero_contrato_inicial.to_i < 0
      errors.add(:parametro_general, I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.numero_contrato_inicial_mayor_cero'))
    end

    if self.anio_constitucion_comite_vigente.to_i < 0
      errors.add(:parametro_general, I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.anio_constitucion_comite_mayor_cero'))
    end

    if self.numero_comite_vigente.to_i < 0
      errors.add(:parametro_general, I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.numero_comite_mayor_cero'))
    end

    if self.detener_mora_garantia.to_i < 0 || self.detener_mora_garantia.to_i > 100
      errors.add(:parametro_general, I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.detener_mora_garantia_rango'))
    end

    if self.tasa_maxima_mora.to_i < 0 || self.tasa_maxima_mora.to_i > 100
      errors.add(:parametro_general, I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.tasa_maxima_mora_rango'))
    end

    if self.dia_mes_primer_ciclo.to_i < 0 || self.dia_mes_primer_ciclo.to_i > 30
      errors.add(:parametro_general, I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.primer_ciclo_facturacion_rango'))
    end

    if self.dia_mes_segundo_ciclo.to_i < 0 || self.dia_mes_segundo_ciclo.to_i > 30
      errors.add(:parametro_general, I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.segundo_ciclo_facturacion_rango'))
    end

    if self.porcentaje_maximo_tapp.to_i < 0 || self.porcentaje_maximo_tapp.to_i > 100
      errors.add(:parametro_general, I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.porcentaje_maximo_tapp_rango'))
    end

    if self.porcentaje_minimo_tapp.to_i < 0 || self.porcentaje_minimo_tapp.to_i > 100
      errors.add(:parametro_general, I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.porcentaje_minimo_tapp_rango'))
    end

    if self.porcentaje_interes_a_reestructurar.to_i < 0 || self.porcentaje_interes_a_reestructurar.to_i > 100
      errors.add(:parametro_general, I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.porcentaje_interes_reestructurar_rango'))
    end

    if self.porcentaje_minimo_tapp.to_i > self.porcentaje_maximo_tapp.to_i
      errors.add(:parametro_general, I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.porcentaje_minimo_tapp_mayor_maximo'))
    end

    if self.min_integrantes_grupo.to_i > self.max_integrantes_grupo.to_i
      errors.add(:parametro_general, I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.min_integrantes_mayor_maximo'))
    end

    if self.cuotas_envio_cobro <= 0
      errors.add(:parametro_general, I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.cuotas_envio_cobro_mayor_cero'))
    end

    if self.porcentaje_sras_primer_ano > 100
      errors.add(:parametro_general, I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.cuotas_envio_cobro_mayor_cero'))
    end

    if self.porcentaje_sras_anos_subsiguientes > 100
      errors.add(:parametro_general, I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.sras_anos_siguiente_mayor_cien'))
    end

    
    unless self.porcentaje_sras_maquinaria_primer_anno.nil?
      if self.porcentaje_sras_maquinaria_primer_anno > 100
        errors.add(:parametro_general, I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.sras_maquinaria_primer_ano_mayor_cien'))
      end
    end
    
    unless self.porcentaje_sras_maquinaria_anno_subsiguientes.nil?
      if self.porcentaje_sras_maquinaria_anno_subsiguientes > 100
        errors.add(:parametro_general, I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.sras_maquinaria_anos_siguiente_mayor_cien'))
      end
    end
    
    if self.porcentaje_arrime_reestructuracion > 100
      errors.add(:parametro_general, I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.porcentaje_arrime_reestructuracion_mayor_cien'))
    end

    unless self.valor_dolar.nil?
      unless self.valor_dolar > 0
        errors.add(:parametro_general, I18n.t('Sistema.Body.Modelos.ParametroGeneral.Errores.valor_dolar_mayor_cero'))
      end
    end

  end

  def monto_maximo_fianza_solidaria_f=(valor)
    self.monto_maximo_fianza_solidaria = format_valor(valor)
  end

  def monto_maximo_fianza_solidaria_f
    format_f(self.monto_maximo_fianza_solidaria)
  end

  def monto_maximo_fianza_solidaria_fm    
      format_fm(self.monto_maximo_fianza_solidaria)
  end

  def monto_maximo_aprueba_comite_f=(valor)
    self.monto_maximo_aprueba_comite = format_valor(valor)
  end

  def monto_maximo_aprueba_comite_f
    format_f(self.monto_maximo_aprueba_comite)
  end

  def monto_maximo_aprueba_comite_fm    
      format_fm(self.monto_maximo_aprueba_comite)
  end

  def porcentaje_sras_primer_ano_f=(valor)
    self.porcentaje_sras_primer_ano = format_valor(valor)
  end

  def porcentaje_sras_primer_ano_f
    format_f(self.porcentaje_sras_primer_ano)
  end
  
  def porcentaje_sras_maquinaria_primer_anno_f=(valor)
    self.porcentaje_sras_maquinaria_primer_anno = format_valor(valor)
  end

  def porcentaje_sras_maquinaria_primer_anno_f
    format_f(self.porcentaje_sras_maquinaria_primer_anno)
  end
  
  def porcentaje_sras_maquinaria_primer_anno_fm    
      format_fm(self.porcentaje_sras_maquinaria_primer_anno)
  end
  
  def porcentaje_sras_primer_ano_fm    
      format_fm(self.porcentaje_sras_primer_ano)
  end

  def porcentaje_sras_anos_subsiguientes_f=(valor)
    self.porcentaje_sras_anos_subsiguientes = format_valor(valor)
  end

  def porcentaje_sras_anos_subsiguientes_f
    format_f(self.porcentaje_sras_anos_subsiguientes)
  end
  
  def porcentaje_sras_maquinaria_anno_subsiguientes_f=(valor)
    self.porcentaje_sras_maquinaria_anno_subsiguientes = format_valor(valor)
  end

  def porcentaje_sras_maquinaria_anno_subsiguientes_f
    format_f(self.porcentaje_sras_maquinaria_anno_subsiguientes)
  end
  
  def porcentaje_sras_maquinaria_anno_subsiguientes_fm    
      format_fm(self.porcentaje_sras_maquinaria_anno_subsiguientes)
  end
  
  def porcentaje_sras_anos_subsiguientes_fm    
      format_fm(self.porcentaje_sras_anos_subsiguientes)
  end

  def tasa_maxima_mora_f=(valor)
    self.tasa_maxima_mora = format_valor(valor)
  end

  def tasa_maxima_mora_f
    format_f(self.tasa_maxima_mora)
  end

  def detener_mora_garantia_f=(valor)
    self.detener_mora_garantia = format_valor(valor)
  end

  def detener_mora_garantia_f
    format_f(self.detener_mora_garantia)
  end

  def porcentaje_maximo_tapp_f=(valor)
    self.porcentaje_maximo_tapp = format_valor(valor)
  end

  def porcentaje_maximo_tapp_f
    format_f(self.porcentaje_maximo_tapp)
  end

  def porcentaje_minimo_tapp_f=(valor)
    self.porcentaje_minimo_tapp = format_valor(valor)
  end

  def porcentaje_minimo_tapp_f
    format_f(self.porcentaje_minimo_tapp)
  end

  def porcentaje_arrime_reestructuracion_f=(valor)
    self.porcentaje_arrime_reestructuracion = format_valor(valor)
  end

  def porcentaje_arrime_reestructuracion_f
    format_f(self.porcentaje_arrime_reestructuracion)
  end

  def tipo_dia_gracia_mora_w
    if self.tipo_dia_gracia_mora == "H"
      return I18n.t('Sistema.Body.Vistas.ParametroGeneral.Labels.habil')
    else
      return I18n.t('Sistema.Body.Vistas.ParametroGeneral.Labels.calendario')
    end
  end

  def dia_facturacion_w

    if self.dia_facturacion == "C"
      return I18n.t('Sistema.Body.Vistas.ParametroGeneral.Labels.ciclo_facturacion')
    end

    if self.dia_facturacion == 'V'
      return I18n.t('Sistema.Body.Vistas.ParametroGeneral.Labels.variable')
    end

    if self.dia_facturacion == 'F'
      return I18n.t('Sistema.Body.Vistas.ParametroGeneral.Labels.fijo')
    end

  end

  def monto_max_credito_integrante_uea_f=(valor)
    self.monto_max_credito_integrante_uea = format_valor(valor)
  end

  def monto_max_credito_integrante_uea_f
    format_f(self.monto_max_credito_integrante_uea)
  end

  def monto_max_credito_coop_f=(valor)
    self.monto_max_credito_coop = format_valor(valor)
  end

  def monto_max_credito_coop_f
    format_f(self.monto_max_credito_coop)
  end

  def banda_inferior_firma_delegada_fm
    format_fm(self.banda_inferior_firma_delegada)
  end

  def banda_superior_firma_delegada_fm    
      format_fm(self.banda_superior_firma_delegada)
  end

   def banda_inferior_comite_credito_fm    
      format_fm(self.banda_inferior_comite_credito)
  end

  def banda_superior_comite_credito_fm    
      format_fm(self.banda_superior_comite_credito)
  end

  def banda_inferior_directorio_fm    
      format_fm(self.banda_inferior_directorio)
  end

  def banda_superior_directorio_fm    
      format_fm(self.banda_superior_directorio)
  end

  def banda_inferior_fondos_autonomos_fm    
      format_fm(self.banda_inferior_fondos_autonomos)
  end

    def banda_superior_fondos_autonomos_fm    
      format_fm(self.banda_superior_fondos_autonomos)
  end

  def  tasa_conversion_unidades_tributarias_fm    
      format_fm(self.tasa_conversion_unidades_tributarias)
  end

  def  porcentaje_interes_a_reestructurar_fm    
      format_fm(self.porcentaje_interes_a_reestructurar)
  end


  def incrementar_numeracion_punto_cuenta
    self.numero_punto_inicial =  self.numero_punto_inicial + 1
    self.numero_reunion_inicial = self.numero_reunion_inicial + 1
    self.save

  end
  def incrementar_numeracion_firma_delegada
    self.numeracion_instancia_firma_delegada =  self.numeracion_instancia_firma_delegada + 1
    self.save
  end
  def incrementar_numeracion_comite_credito
    self.numeracion_instancia_comite_credito =  self.numeracion_instancia_comite_credito + 1
    self.save
  end
  def incrementar_numeracion_directorio
    self.numeracion_instancia_directorio =  self.numeracion_instancia_directorio + 1
    self.save
  end
  def incrementar_numeracion_fondos_autonomos
    self.numeracion_instancia_fondos_autonomos =  self.numeracion_instancia_fondos_autonomos + 1
    self.save
  end
end



# == Schema Information
#
# Table name: parametro_general
#
#  id                                                 :integer         not null, primary key
#  tasa_maxima_mora                                   :float
#  dias_gracia_mora                                   :integer(2)
#  tipo_dia_gracia_mora                               :string(1)       default("H")
#  detener_mora_edad                                  :integer(2)
#  detener_mora_cuotas                                :integer(2)
#  detener_mora_garantia                              :float
#  dia_mes_primer_ciclo                               :integer(2)      default(16)
#  dia_mes_segundo_ciclo                              :integer(2)      default(28)
#  porcentaje_maximo_tapp                             :float
#  porcentaje_minimo_tapp                             :float
#  dias_vigencia_clave                                :integer(2)      default(30)
#  monto_maximo_aprueba_comite                        :float
#  monto_maximo_fianza_solidaria                      :float
#  exonerar_intereses_desembolso                      :boolean         default(TRUE)
#  numero_prestamo_inicial                            :integer
#  ultima_factura                                     :integer         default(0)
#  plazo_maximo_prestamo_reestructurado               :integer         default(60)
#  fecha_ultimo_cierre                                :date
#  fecha_proximo_cierre                               :date
#  max_integrantes_grupo                              :integer(2)
#  min_integrantes_grupo                              :integer(2)
#  monto_max_credito_integrante_uea                   :float
#  monto_max_credito_coop                             :float
#  numero_grupo_inicial                               :integer
#  anio_constitucion_comite_vigente                   :integer(2)
#  numero_empresa                                     :integer
#  cuotas_credito_vencido                             :integer(2)
#  cuotas_credito_solvente                            :integer(2)
#  numero_solicitud_inicial_uea                       :integer(8)
#  numero_solicitud_inicial_coop                      :decimal(, )
#  numero_solicitud_inicial_indiv                     :decimal(, )
#  numero_comite_vigente                              :integer
#  numero_contrato_inicial                            :integer(8)
#  numero_acta_uea                                    :integer(8)
#  numero_acta_coop                                   :integer(8)
#  numero_acta_indiv                                  :integer(8)
#  numero_acta_liq_uea                                :integer(8)
#  numero_acta_liq_indiv                              :integer(8)
#  numero_acta_liq_coop                               :integer(8)
#  cuotas_envio_cobro                                 :integer
#  numero_acta_reestructuracion                       :integer         default(0)
#  dia_facturacion                                    :string(1)       default("F")
#  penalizacion_mora                                  :boolean         default(FALSE)
#  cuotas_pase_vencido                                :integer         default(0)
#  firma_coordinacion_presupuestaria                  :string(50)
#  numeracion_instancia_firma_delegada                :integer(8)      default(1)
#  numeracion_instancia_comite_credito                :integer(8)      default(1)
#  numeracion_instancia_directorio                    :integer(8)      default(1)
#  numeracion_instancia_fondos_autonomos              :integer(8)      default(1)
#  banda_superior_fondos_autonomos                    :float
#  banda_inferior_fondos_autonomos                    :float
#  banda_superior_firma_delegada                      :float
#  banda_inferior_firma_delegada                      :float
#  banda_superior_comite_credito                      :float
#  banda_inferior_comite_credito                      :float
#  banda_superior_directorio                          :float
#  banda_inferior_directorio                          :float
#  numero_punto_inicial                               :integer(8)      default(1)
#  numero_reunion_inicial                             :integer(8)      default(1)
#  firma_presidente                                   :string(50)
#  firma_gerencia_cooperacion_financiamiento_nacional :string(50)
#  numero_seguimiento_inicial                         :integer(8)      default(1)
#  firma_coordinacion_seguimiento                     :string(50)
#  firma_especialista_seguimiento                     :string(50)
#  tasa_conversion_unidades_tributarias               :float           default(0.0)
#  firma_vicepresidente                               :string(50)
#  porcentaje_interes_a_reestructurar                 :decimal(16, 2)
#  notif_liquidacion                                  :string(60)
#  notif_tesoreria                                    :string(60)
#  integracion_administrativo                         :boolean
#  wsdl_administrativo                                :string(100)
#  numeracion_instancia_nacional                      :integer
#  codigo_tecnico_campo                               :integer         default(0)
#  porcentaje_sras_primer_ano                         :decimal(5, 2)   default(2.0), not null
#  porcentaje_sras_anos_subsiguientes                 :decimal(5, 2)   default(0.5), not null
#  nro_lote                                           :string(8)
#  caducidad_orden_despacho                           :integer         default(20)
#  caducidad_casa_proveedora                          :integer         default(60)
#  tipo_fuente                                        :text
#  margen_izquierdo                                   :float
#  margen_derecho                                     :float
#  margen_superior                                    :float
#  margen_inferior                                    :float
#  tamano_fuente                                      :float
#  interlineado                                       :float
#  codigo_seg                                         :integer(8)
#  valor_dolar                                        :decimal(10, 2)  default(4.3)
#  porcentaje_arrime_reestructuracion                 :float
#  dias_max_vencimiento_ultima_cuota                  :integer         default(15)
#  porcentaje_sras_maquinaria                         :decimal(5, 2)
#  porcentaje_sras_maquinaria_primer_anno             :decimal(5, 2)   default(8.0)
#  porcentaje_sras_maquinaria_anno_subsiguientes      :decimal(5, 2)   default(0.5)
#  nro_lote_fideicomiso                               :integer
#  rango_dias_compromiso_pago                         :integer
#  moneda_id                                          :integer
#

