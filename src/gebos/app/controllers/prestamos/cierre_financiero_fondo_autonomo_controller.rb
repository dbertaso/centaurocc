# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Prestamos::CierreFinancieroFondoAutonomoController
# descripción: Migración a Rails 3
#

class Sistema::CierreFinancieroFondoAutonomoController < FormClassicController

  layout 'form_basic'
  require 'spreadsheet'
  include Spreadsheet
  
  def index
    meses_cierre_fill
    @list = TablaCuadre.find(:all, :conditions => "banco_origen = 'FONDOS AUTONOMOS'", :order => 'id DESC');
    form_list
  end




  def list
    mes_ano_cierre = params[:mes_cierre_id]

    #-----EJECUTA EL CIERRE
    @nuevo_cierre = TablaCuadre.new
    estatus = @nuevo_cierre.ejecutar_cierre(mes_ano_cierre, 'FONDOS AUTONOMOS')
   
   
    if estatus
      @list = TablaCuadre.find(:all, :conditions => "banco_origen = 'FONDOS AUTONOMOS'", :order => 'mes DESC, ano DESC');
      form_list
    else
      render :update do |page|
	page.form_error
      end
    end
    #------------------------------------------------------------------------------
 
  
  end







  def xls_cartera
    #-----GENERA EL EXCEL DE CARTERA Y LO GUARDA EN DISCO
    mes_cierre = params[:xls_mes]
    ano_cierre = params[:xls_ano]
    nombre_archivo = "#{ano_cierre}_#{mes_cierre}_CARTERA_FONDOS_AUTONOMOS"
    workbook = Excel.new("#{RAILS_ROOT}/public/documentos/xls/#{nombre_archivo}.xls")
    hoja = workbook.add_worksheet("Resumen")

 hoja.write(0, 0, "Gerencia Ejecutiva de Cooperación y Financiamiento Nacional")
    hoja.write(1, 0, "Gerencia de Administración de Cartera - Coordinación de Cobranzas")
    hoja.write(2, 0, "CONSOLIDADO DEL MES: " + mes_cierre + "/" + ano_cierre)
    hoja.write(3, 0, "CIERRE AL " + mes_cierre + "/" + ano_cierre + "  (CARTERA - FONDOS AUTONOMOS)")

    sql  = "SELECT * FROM view_mega_sabana "
    sql += "WHERE "
    sql += "mes = #{mes_cierre} "
    sql += "AND "
    sql += "ano  = #{ano_cierre} "
    sql += "AND "
    sql += "banco_origen  = 'FONDOS AUTONOMOS'"
    @resultado = PrestamoHistorico.find_by_sql("#{sql}")
   fila = 5
    hoja.write(fila, 0, "1. No. SOLICITUD SEGÚN CAI")
    hoja.write(fila, 1, "2. #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.programa_convenio_linea')}")
    hoja.write(fila, 2, "3. #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.propuesta_productos')}")
    hoja.write(fila, 3, "4. #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.tipo_organizacion')}")
    hoja.write(fila, 4, "5. #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.tamano_organizacion')}")
    hoja.write(fila, 5, "4. #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.nombre_organizacion')}")
    hoja.write(fila, 6, "5. #{I18n.t('Sistema.Body.Vistas.General.rif')}")
    hoja.write(fila, 7, "6. #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.beneficiario_representante')}")
    hoja.write(fila, 8, "7. #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cedula_identidad')}")
    hoja.write(fila, 9, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.capital_suscrito'))
    hoja.write(fila, 10, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.fecha_aprobacion'))
    hoja.write(fila, 11, "8. #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.monto_credito')} (#{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.bs')})")
    hoja.write(fila, 12, "8.1 #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.liquidado')} (#{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.bs')})")
    hoja.write(fila, 13, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.fecha_liquidacion_pd'))
    hoja.write(fila, 14, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.fecha_liquidacion_preliminar'))
    hoja.write(fila, 15, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.fecha_vencimiento'))
    hoja.write(fila, 16, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.modalidad_pago'))
    hoja.write(fila, 17, "9. #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.plazo')}")
    hoja.write(fila, 18, "9. #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.periodo_gracia_a')}")
    hoja.write(fila, 19, "9. #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.periodo_diferimiento')}")
    hoja.write(fila, 20, "9. #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cuotas_especiales')}")
    hoja.write(fila, 21, "10.  #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.tasa')}")
    hoja.write(fila, 22, "11. #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.sector_economico')}")
    hoja.write(fila, 23, "12. #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.empleos_directos')}")
    hoja.write(fila, 24, "13. #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.empleos_indirectos')}")
    hoja.write(fila, 25, "14.1  #{I18n.t('Sistema.Body.Vistas.General.estado').upcase}")
    hoja.write(fila, 26, "14.2  #{I18n.t('Sistema.Body.Vistas.General.municipio').upcase}")
    hoja.write(fila, 27, "14.3  #{I18n.t('Sistema.Body.Vistas.General.parroquia').upcase}")
    hoja.write(fila, 28, "14.4 #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.sector_localidad')}")
    hoja.write(fila, 29, "14.5 #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.avenida_calle')}")
    hoja.write(fila, 30, "14.6 #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.edificio_casa')}")
    hoja.write(fila, 31, "14.7 #{I18n.t('Sistema.Body.Vistas.General.telefonos').upcase}")
    hoja.write(fila, 32, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.banco_recaudador'))
    hoja.write(fila, 33, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cuenta_recuperacion'))
    hoja.write(fila, 34, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.codigo_contable'))
    hoja.write(fila, 35, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.status'))
    hoja.write(fila, 36, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.fecha_ultima_gestion'))
    hoja.write(fila, 37, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.proxima_fecha'))
    hoja.write(fila, 38, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.comunicaciones_enviadas'))
    hoja.write(fila, 39, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.reuniones_efectuadas'))
    hoja.write(fila, 40, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cuotas_pagadas'))
    hoja.write(fila, 41, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cuotas_diferidas'))
    hoja.write(fila, 42, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cuotas_vencidas'))
    hoja.write(fila, 43, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cuotas_especiales_pagadas'))
    hoja.write(fila, 45, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cuotas_especiales_vencidas'))
    hoja.write(fila, 46, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cuotas_especiales_no_vencidas'))
    hoja.write(fila, 47, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.total_capital_vencido'))
    hoja.write(fila, 48, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.total_intereses'))
    hoja.write(fila, 49, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.total_mora'))
    hoja.write(fila, 50, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.total_recuperado_capital'))
    hoja.write(fila, 51, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.total_intereses_recuperados'))
    hoja.write(fila, 52, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.total_intereses_recuperados'))
    hoja.write(fila, 53, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.saldo_insoluto'))
    hoja.write(fila, 54, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.fecha_ultimo_no_pagado'))
    hoja.write(fila, 55, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.dias_atraso_ultimo_venc'))
    hoja.write(fila, 56, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.indice_mora'))
    hoja.write(fila, 57, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.provision_bandes'))
    hoja.write(fila, 58, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cuotas_conversion_mensual'))
    hoja.write(fila, 59, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.categoria_riesgo_sudeban'))
    hoja.write(fila, 60, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.porcentaje_provision_sudeban'))
    hoja.write(fila, 61, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.observaciones'))
   
  
   fila += 1
   for registro in @resultado
    hoja.write(fila, 0, registro.solicitud_cai)
    hoja.write(fila, 1, registro.alias)
    hoja.write(fila, 2, registro.propuesta)
    hoja.write(fila, 3, registro.tipo_organizacion)
    hoja.write(fila, 4, registro.tamano_organizacion)
    hoja.write(fila, 5, registro.nombre_organizacion)
    hoja.write(fila, 6, registro.rif)
    hoja.write(fila, 7, registro.beneficiario_nombre)
    hoja.write(fila, 8, registro.cedula)
    hoja.write(fila, 9, registro.capital_suscrito)
    hoja.write(fila, 10, registro.fecha_aprobacion)
    hoja.write(fila, 11, registro.monto_credito)
    hoja.write(fila, 12, registro.monto_liquidado)
    hoja.write(fila, 13, registro.fecha_liquidacion)
    hoja.write(fila, 14, registro.fecha_ultimo_desembolso)
    hoja.write(fila, 15, registro.fecha_vencimiento)
    hoja.write(fila, 16, registro.modalidad_pago)
    hoja.write(fila, 17, registro.plazo)
    hoja.write(fila, 18, registro.periodo_gracia)
    hoja.write(fila, 19, registro.periodo_diferimiento_intereses)
    hoja.write(fila, 20, registro.cuotas_especiales_capital)
    hoja.write(fila, 21, registro.tasa)
    hoja.write(fila, 22, registro.sector_economico)
    hoja.write(fila, 23, registro.empleos_directos)
    hoja.write(fila, 24, registro.empleos_indirectos)
    hoja.write(fila, 25, registro.estado)
    hoja.write(fila, 26, registro.municipio)
    hoja.write(fila, 27, registro.parroquia)
    hoja.write(fila, 28, registro.localidad)
    hoja.write(fila, 29, registro.avenida)
    hoja.write(fila, 30, registro.edificio_casa)
    hoja.write(fila, 31, registro.telefonos)
    hoja.write(fila, 32, registro.banco_recaudador)
    hoja.write(fila, 33, registro.numero_cuenta)
    hoja.write(fila, 34, registro.codigo_contable)
    hoja.write(fila, 35, registro.estatus)
    hoja.write(fila, 36, registro.fecha_ultima_gestion)
    hoja.write(fila, 37, registro.proxima_fecha)
    hoja.write(fila, 38, registro.comunicaciones_enviadas)
    hoja.write(fila, 39, registro.reuniones_efectuadas)
    hoja.write(fila, 40, registro.cuotas_pagadas_o_en_gracia)
    hoja.write(fila, 41, registro.cuotas_diferidas_capital)
    hoja.write(fila, 42, registro.cuotas_vencidas)
    hoja.write(fila, 43, registro.cuotas_no_vencidas)
    hoja.write(fila, 44, registro.cuotas_especiales_de_capital_pagadas)
    hoja.write(fila, 45, registro.cuotas_especiales_de_capital_vencidas)
    hoja.write(fila, 46, registro.cuotas_especiales_de_capital_no_vencidas)
    hoja.write(fila, 47, registro.capital_vencido)
    hoja.write(fila, 48, registro.intereses_ordinarios_vencidos)
    hoja.write(fila, 49, registro.intereses_mora)
    hoja.write(fila, 50, registro.total_recuperado_capital)
    hoja.write(fila, 51, registro.total_recuperado_intereses_ordinarios)
    hoja.write(fila, 52, registro.total_intereses_mora_pagados)
    hoja.write(fila, 53, registro.saldo_capital)
    hoja.write(fila, 54, registro.fecha_ultimo_vencimiento_no_pagado)
    hoja.write(fila, 55, registro.dias_atraso_desde_ultimo_vencimiento)
    hoja.write(fila, 56, registro.indice_mora)
    hoja.write(fila, 57, registro.provision_contrato_bandes)
    hoja.write(fila, 58, registro.conversion_cuotas_mensuales_bandes)
    hoja.write(fila, 59, registro.clasificacion_riesgo_sudeban)
    hoja.write(fila, 60, registro.porcentaje_individual_provision_sudeban)
    hoja.write(fila, 61, registro.observaciones)
    fila += 1
   end
    workbook.close
    send_file "#{RAILS_ROOT}/public/documentos/xls/#{nombre_archivo}.xls"

  end



  def xls_desembolsos
    mes_cierre = params[:xls_mes]
    ano_cierre = params[:xls_ano]
   #-----GENERA EL EXCEL DE DESEMBOLSOS Y LO GUARDA EN DISCO
    nombre_archivo = "#{ano_cierre}_#{mes_cierre}_DESEMBOLSOS_FONDO_AUTONOMO"
    workbook = Excel.new("#{RAILS_ROOT}/public/documentos/xls/#{nombre_archivo}.xls")
    hoja = workbook.add_worksheet("Resumen")

    hoja.write(0, 0, "#{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.gerencia_ejecutiva')} #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cooperacion_financiamiento')}")
    hoja.write(1, 0, "#{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.gerencia')} #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.administracion_cartera')} - #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.coordinacion')} #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cobranzas')}")
    hoja.write(2, 0, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.consolidado'), :mes_cierre=>mes_cierre, :ano_cierre=>ano_cierre)
    hoja.write(3, 0, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cierre_al'), :mes_cierre=>mes_cierre, :ano_cierre=>ano_cierre, :cartera => I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cobranzas_fondos'))


    sql  = "SELECT * FROM view_resumen_desembolsos_cierre "
    sql += "WHERE "
    sql += "EXTRACT(MONTH from fecha) = #{mes_cierre} AND EXTRACT(YEAR from fecha) = #{ano_cierre} AND banco_origen = 'FONDOS AUTONOMOS' "
    @resultado = ViewResumenDesembolsosCierre.find_by_sql("#{sql}")

   fila = 5
    hoja.write(fila, 0, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.fecha'))
    hoja.write(fila, 1, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.beneficiario'))
    hoja.write(fila, 2, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cedula_rif'))
    hoja.write(fila, 3, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.monto'))
    hoja.write(fila, 4, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.numero_referencia'))
    hoja.write(fila, 5, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.entidad_financiera'))
  
   fila += 1
   for registro in @resultado
    hoja.write(fila, 0, registro.fecha)
    hoja.write(fila, 1, registro.beneficiario)
    hoja.write(fila, 2, registro.cedula_rif)
    hoja.write(fila, 3, registro.monto)
    hoja.write(fila, 4, registro.numero_referencia)
    hoja.write(fila, 5, registro.entidad_financiera)
    fila += 1
   end
    workbook.close
    send_file "#{RAILS_ROOT}/public/documentos/xls/#{nombre_archivo}.xls"
    #-------------------------------------------------------------------------------


  end
 

  def xls_cobranza
    mes_cierre = params[:xls_mes]
    ano_cierre = params[:xls_ano]


    #-----GENERA EL EXCEL DE COBRANZA Y LO GUARDA EN DISCO
    nombre_archivo = "#{ano_cierre}_#{mes_cierre}_COBRANZA_FONDO_AUTONOMO"
    workbook = Excel.new("#{RAILS_ROOT}/public/documentos/xls/#{nombre_archivo}.xls")
    hoja = workbook.add_worksheet("Resumen")

    hoja.write(0, 0, "#{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.gerencia_ejecutiva')} #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cooperacion_financiamiento')}")
    hoja.write(1, 0, "#{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.gerencia')} #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.administracion_cartera')} - #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.coordinacion')} #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cobranzas')}")
    hoja.write(2, 0, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.consolidado'), :mes_cierre=>mes_cierre, :ano_cierre=>ano_cierre)
    hoja.write(3, 0, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cierre_al'), :mes_cierre=>mes_cierre, :ano_cierre=>ano_cierre, :cartera => I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cobranza_fondos'))


    sql  = "SELECT * FROM view_resumen_pagos_cierre "
    sql += "WHERE "
    sql += "EXTRACT(MONTH from fecha_contable) = #{mes_cierre} AND EXTRACT(YEAR from fecha_contable) = #{ano_cierre} AND banco_origen = 'FONDOS AUTONOMOS' "
    @resultado_pagos = ViewResumenPagosCierre.find_by_sql("#{sql}")
   fila = 5
    hoja.write(fila, 0, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.fecha_aplicacion'))
    hoja.write(fila, 1, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.tipo_aplicacion'))
    hoja.write(fila, 2, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.analista'))
    hoja.write(fila, 3, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.beneficiario'))
    hoja.write(fila, 4, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cedula_rif'))
    hoja.write(fila, 5, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.fecha'))
    hoja.write(fila, 6, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.banco'))
    hoja.write(fila, 7, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.numero_documento'))
    hoja.write(fila, 8, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.codigo_contabilidad'))
    hoja.write(fila, 9, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.monto_bs'))
    hoja.write(fila, 10, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.capital'))
    hoja.write(fila, 11, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.interes_ordinario'))
    hoja.write(fila, 12, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.interes_diferido'))
    hoja.write(fila, 13, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.interes_mora'))
    hoja.write(fila, 14, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.saldo_favor'))
    hoja.write(fila, 15, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.interes_causado'))
    hoja.write(fila, 16, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.sector_economico'))
    hoja.write(fila, 17, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.estatus_contabilidad'))
    hoja.write(fila, 18, I18n.t('Sistema.Body.Vistas.General.estado').upcase)
   fila += 1
   for registro in @resultado_pagos
    hoja.write(fila, 0, registro.fecha_contable)
    hoja.write(fila, 1, registro.tipo_aplicacion)
    hoja.write(fila, 2, registro.analista)
    hoja.write(fila, 3, registro.beneficiario)
    hoja.write(fila, 4, registro.cedula_rif)
    hoja.write(fila, 5, registro.fecha)
    hoja.write(fila, 6, registro.banco)
    hoja.write(fila, 7, registro.numero_documento)
    hoja.write(fila, 8, registro.codigo_contable)
    hoja.write(fila, 9, registro.monto)
    hoja.write(fila, 10, registro.capital)
    hoja.write(fila, 11, registro.intereses_ordinarios)
    hoja.write(fila, 12, registro.intereses_diferidos)
    hoja.write(fila, 13, registro.intereses_mora)
    hoja.write(fila, 14, registro.saldo_a_favor)
    hoja.write(fila, 15, registro.interes_causado)
    hoja.write(fila, 16, registro.sector_economico)
    hoja.write(fila, 17, registro.estatus_contabilidad)
    hoja.write(fila, 18, registro.estado)
    fila += 1
   end
    workbook.close
    send_file "#{RAILS_ROOT}/public/documentos/xls/#{nombre_archivo}.xls"

  end

def xls_sector_estatus
    mes_cierre = params[:xls_mes]
    ano_cierre = params[:xls_ano]


    #-----GENERA EL EXCEL DE COBRANZA Y LO GUARDA EN DISCO
    nombre_archivo = "#{ano_cierre}_#{mes_cierre}_ESTADISTICA_CARTERA_ESTATUS"
    workbook = Excel.new("#{RAILS_ROOT}/public/documentos/xls/#{nombre_archivo}.xls")
    hoja = workbook.add_worksheet("Resumen")


    hoja.write(0, 0, "#{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.gerencia_ejecutiva')} #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cooperacion_financiamiento')}")
    hoja.write(1, 0, "#{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.gerencia')} #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.administracion_cartera')} - #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.coordinacion')} #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cobranzas')}")
    hoja.write(2, 0, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.estadistica_cartera'), :mes_cierre=>mes_cierre, :ano_cierre=>ano_cierre)
    hoja.write(3, 0, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cierre_al'), :mes_cierre=>mes_cierre, :ano_cierre=>ano_cierre, :cartera => I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cobranza_fondos'))


    sql = "select " 
    sql += "sector_economico.descripcion as sector_economico_nombre, "  
    sql += "totalizador_pagos_estadistica(#{mes_cierre}, #{ano_cierre}, sector_economico.id, 'V', 0, 'FONDOS AUTONOMOS') as nro_cartera_vigente, totalizador_pagos_estadistica(#{mes_cierre}, #{ano_cierre}, sector_economico.id, 'V', 1, 'FONDOS AUTONOMOS') as monto_cartera_vigente, "
    sql += "totalizador_pagos_estadistica(#{mes_cierre}, #{ano_cierre}, sector_economico.id, 'E', 0, 'FONDOS AUTONOMOS') as nro_cartera_vencida, totalizador_pagos_estadistica(#{mes_cierre}, #{ano_cierre}, sector_economico.id, 'E', 1, 'FONDOS AUTONOMOS') as monto_cartera_vencida, "
    sql += "totalizador_pagos_estadistica(#{mes_cierre}, #{ano_cierre}, sector_economico.id, 'L', 0, 'FONDOS AUTONOMOS') as nro_cartera_litigio, totalizador_pagos_estadistica(#{mes_cierre}, #{ano_cierre}, sector_economico.id, 'L', 1, 'FONDOS AUTONOMOS') as monto_cartera_litigio "
    sql += "from " 
    sql += "sector_economico " 
    sql += "where " 
    sql += "sector_economico.activo = true "
    sql += "Order by descripcion ASC "



 #   sql  = "SELECT * FROM view_resumen_pagos_cierre "
 #   sql += "WHERE "
 #   sql += "EXTRACT(MONTH from fecha_contable) = #{mes_cierre} AND EXTRACT(YEAR from fecha_contable) = #{ano_cierre} AND banco_origen = 'FONDOS AUTONOMOS' "
    @resultado_pagos = ViewResumenPagosCierre.find_by_sql("#{sql}")
   acumulador_nro_cartera_vigente = 0
   acumulador_monto_cartera_vigente = 0.00
   acumulador_nro_cartera_vencida = 0
   acumulador_monto_cartera_vencida = 0.00
   acumulador_nro_cartera_litigio = 0
   acumulador_monto_cartera_litigio = 0.00
   acumulador_nro_cartera_total = 0
   acumulador_monto_cartera_total = 0.00

   fila = 7
    hoja.write(fila, 0, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.carteras'))
    hoja.write(fila, 1, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cartera_vigente'))
    hoja.write(fila, 3, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cartera_vencida'))
    hoja.write(fila, 5, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cartera_litigio'))
    hoja.write(fila, 7, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.totales'))
   fila = 8
    hoja.write(fila, 0, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.sectores_economicos'))
    hoja.write(fila, 1, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.nro'))
    hoja.write(fila, 2, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.monto'))
    hoja.write(fila, 3, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.nro'))
    hoja.write(fila, 4, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.monto'))
    hoja.write(fila, 5, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.nro'))
    hoja.write(fila, 6, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.monto'))
    hoja.write(fila, 7, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.nro'))
    hoja.write(fila, 8, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.monto'))
   fila += 1
   for registro in @resultado_pagos
    hoja.write(fila, 0, registro.sector_economico_nombre)
    hoja.write(fila, 1, registro.nro_cartera_vigente.to_i)
    hoja.write(fila, 2, registro.monto_cartera_vigente.to_f)
    hoja.write(fila, 3, registro.nro_cartera_vencida.to_i)
    hoja.write(fila, 4, registro.monto_cartera_vencida.to_f)
    hoja.write(fila, 5, registro.nro_cartera_litigio.to_i)
    hoja.write(fila, 6, registro.monto_cartera_litigio.to_f)
    hoja.write(fila, 7, registro.nro_cartera_vigente.to_i + registro.nro_cartera_vencida.to_i + registro.nro_cartera_litigio.to_i)
    hoja.write(fila, 8, registro.monto_cartera_vigente.to_f + registro.monto_cartera_vencida.to_f + registro.monto_cartera_litigio.to_f)

    acumulador_nro_cartera_vigente += registro.nro_cartera_vigente.to_i
    acumulador_monto_cartera_vigente += registro.monto_cartera_vigente.to_f
    acumulador_nro_cartera_vencida += registro.nro_cartera_vencida.to_i
    acumulador_monto_cartera_vencida += registro.monto_cartera_vencida.to_f
    acumulador_nro_cartera_litigio += registro.nro_cartera_litigio.to_i
    acumulador_monto_cartera_litigio += registro.monto_cartera_litigio.to_f
    acumulador_nro_cartera_total += registro.nro_cartera_vigente.to_i + registro.nro_cartera_vencida.to_i + registro.nro_cartera_litigio.to_i
    acumulador_monto_cartera_total += registro.monto_cartera_vigente.to_f + registro.monto_cartera_vencida.to_f + registro.monto_cartera_litigio.to_f


    fila += 1
   end


    hoja.write(fila, 0, "--TOTALES--")
    hoja.write(fila, 1, acumulador_nro_cartera_vigente.to_i)
    hoja.write(fila, 2, acumulador_monto_cartera_vigente.to_f)
    hoja.write(fila, 3, acumulador_nro_cartera_vencida.to_i)
    hoja.write(fila, 4, acumulador_monto_cartera_vencida.to_f)
    hoja.write(fila, 5, acumulador_nro_cartera_litigio.to_i)
    hoja.write(fila, 6, acumulador_monto_cartera_litigio.to_f)
    hoja.write(fila, 7, acumulador_nro_cartera_total.to_i)
    hoja.write(fila, 8, acumulador_monto_cartera_total.to_f)




    workbook.close
    send_file "#{RAILS_ROOT}/public/documentos/xls/#{nombre_archivo}.xls"

  end
  

  def xls_region_estatus
    mes_cierre = params[:xls_mes]
    ano_cierre = params[:xls_ano]


    #-----GENERA EL EXCEL DE COBRANZA Y LO GUARDA EN DISCO
    nombre_archivo = "#{ano_cierre}_#{mes_cierre}_ESTADISTICA_CARTERA_ESTATUS_REGION"
    workbook = Excel.new("#{RAILS_ROOT}/public/documentos/xls/#{nombre_archivo}.xls")
    hoja = workbook.add_worksheet("Resumen")

   
    hoja.write(0, 0, "#{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.gerencia_ejecutiva')} #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cooperacion_financiamiento')}")
    hoja.write(1, 0, "#{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.gerencia')} #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.administracion_cartera')} - #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.coordinacion')} #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cobranzas')}")
    hoja.write(2, 0, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.estadistica_region'), :mes_cierre=>mes_cierre, :ano_cierre=>ano_cierre)
    hoja.write(3, 0, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cierre_al'), :mes_cierre=>mes_cierre, :ano_cierre=>ano_cierre, :cartera => I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cobranza_fondos'))
    

    sql = "select " 
    sql += "sector_economico.descripcion as sector_economico_nombre, "  
    sql += "totalizador_pagos_estadistica(#{mes_cierre}, #{ano_cierre}, sector_economico.id, 'V', 0, 'FONDOS AUTONOMOS') as nro_cartera_vigente, totalizador_pagos_estadistica(#{mes_cierre}, #{ano_cierre}, sector_economico.id, 'V', 1, 'FONDOS AUTONOMOS') as monto_cartera_vigente, "
    sql += "totalizador_pagos_estadistica(#{mes_cierre}, #{ano_cierre}, sector_economico.id, 'E', 0, 'FONDOS AUTONOMOS') as nro_cartera_vencida, totalizador_pagos_estadistica(#{mes_cierre}, #{ano_cierre}, sector_economico.id, 'E', 1, 'FONDOS AUTONOMOS') as monto_cartera_vencida, "
    sql += "totalizador_pagos_estadistica(#{mes_cierre}, #{ano_cierre}, sector_economico.id, 'L', 0, 'FONDOS AUTONOMOS') as nro_cartera_litigio, totalizador_pagos_estadistica(#{mes_cierre}, #{ano_cierre}, sector_economico.id, 'L', 1, 'FONDOS AUTONOMOS') as monto_cartera_litigio "
    sql += "from " 
    sql += "sector_economico " 
    sql += "where " 
    sql += "sector_economico.activo = true "
    sql += "Order by descripcion ASC "


    sql = "select estado.nombre as region, "
    sql += "totalizador_pagos_estadistica_estado_geografico(#{mes_cierre}, #{ano_cierre}, estado.id, 'V', 0, 'FONDOS AUTONOMOS') as nro_cartera_vigente, totalizador_pagos_estadistica_estado_geografico(#{mes_cierre}, #{ano_cierre}, estado.id, 'V', 1, 'FONDOS AUTONOMOS') as monto_cartera_vigente, "
    sql += "totalizador_pagos_estadistica_estado_geografico(#{mes_cierre}, #{ano_cierre}, estado.id, 'E', 0, 'FONDOS AUTONOMOS') as nro_cartera_vencida, totalizador_pagos_estadistica_estado_geografico(#{mes_cierre}, #{ano_cierre}, estado.id, 'E', 1, 'FONDOS AUTONOMOS') as monto_cartera_vencida, "
    sql += "totalizador_pagos_estadistica_estado_geografico(#{mes_cierre}, #{ano_cierre}, estado.id, 'L', 0, 'FONDOS AUTONOMOS') as nro_cartera_litigio, totalizador_pagos_estadistica_estado_geografico(#{mes_cierre}, #{ano_cierre}, estado.id, 'L', 1, 'FONDOS AUTONOMOS') as monto_cartera_litigio "
    sql += "from estado "
    sql += "Where pais_id = 1 "



 #   sql  = "SELECT * FROM view_resumen_pagos_cierre "
 #   sql += "WHERE "
 #   sql += "EXTRACT(MONTH from fecha_contable) = #{mes_cierre} AND EXTRACT(YEAR from fecha_contable) = #{ano_cierre} AND banco_origen = 'FONDOS AUTONOMOS' "
    @resultado_pagos = ViewResumenPagosCierre.find_by_sql("#{sql}")
   acumulador_nro_cartera_vigente = 0
   acumulador_monto_cartera_vigente = 0.00
   acumulador_nro_cartera_vencida = 0
   acumulador_monto_cartera_vencida = 0.00
   acumulador_nro_cartera_litigio = 0
   acumulador_monto_cartera_litigio = 0.00
   acumulador_nro_cartera_total = 0
   acumulador_monto_cartera_total = 0.00

   fila = 7
    hoja.write(fila, 0, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.carteras'))
    hoja.write(fila, 1, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cartera_vigente'))
    hoja.write(fila, 3, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cartera_vencida'))
    hoja.write(fila, 5, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cartera_litigio'))
    hoja.write(fila, 7, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.totales'))
   fila = 8
    hoja.write(fila, 0, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.regiones'))
    hoja.write(fila, 1, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.nro'))
    hoja.write(fila, 2, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.monto'))
    hoja.write(fila, 3, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.nro'))
    hoja.write(fila, 4, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.monto'))
    hoja.write(fila, 5, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.nro'))
    hoja.write(fila, 6, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.monto'))
    hoja.write(fila, 7, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.nro'))
    hoja.write(fila, 8, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.monto'))
   fila += 1
   for registro in @resultado_pagos
    hoja.write(fila, 0, registro.region)
    hoja.write(fila, 1, registro.nro_cartera_vigente.to_i)
    hoja.write(fila, 2, registro.monto_cartera_vigente.to_f)
    hoja.write(fila, 3, registro.nro_cartera_vencida.to_i)
    hoja.write(fila, 4, registro.monto_cartera_vencida.to_f)
    hoja.write(fila, 5, registro.nro_cartera_litigio.to_i)
    hoja.write(fila, 6, registro.monto_cartera_litigio.to_f)
    hoja.write(fila, 7, registro.nro_cartera_vigente.to_i + registro.nro_cartera_vencida.to_i + registro.nro_cartera_litigio.to_i)
    hoja.write(fila, 8, registro.monto_cartera_vigente.to_f + registro.monto_cartera_vencida.to_f + registro.monto_cartera_litigio.to_f)

    acumulador_nro_cartera_vigente += registro.nro_cartera_vigente.to_i
    acumulador_monto_cartera_vigente += registro.monto_cartera_vigente.to_f
    acumulador_nro_cartera_vencida += registro.nro_cartera_vencida.to_i
    acumulador_monto_cartera_vencida += registro.monto_cartera_vencida.to_f
    acumulador_nro_cartera_litigio += registro.nro_cartera_litigio.to_i
    acumulador_monto_cartera_litigio += registro.monto_cartera_litigio.to_f
    acumulador_nro_cartera_total += registro.nro_cartera_vigente.to_i + registro.nro_cartera_vencida.to_i + registro.nro_cartera_litigio.to_i
    acumulador_monto_cartera_total += registro.monto_cartera_vigente.to_f + registro.monto_cartera_vencida.to_f + registro.monto_cartera_litigio.to_f


    fila += 1
   end


    hoja.write(fila, 0, "--#{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.totales')}--")
    hoja.write(fila, 1, acumulador_nro_cartera_vigente.to_i)
    hoja.write(fila, 2, acumulador_monto_cartera_vigente.to_f)
    hoja.write(fila, 3, acumulador_nro_cartera_vencida.to_i)
    hoja.write(fila, 4, acumulador_monto_cartera_vencida.to_f)
    hoja.write(fila, 5, acumulador_nro_cartera_litigio.to_i)
    hoja.write(fila, 6, acumulador_monto_cartera_litigio.to_f)
    hoja.write(fila, 7, acumulador_nro_cartera_total.to_i)
    hoja.write(fila, 8, acumulador_monto_cartera_total.to_f)

    blacked_out_format = Spreadsheet::Format.new :color => :blue, :weight => :bold, :size => 18


    #hoja[0,5].format(blacked_out_format)
    #hoja.row(5).set_format(0,blacked_out_format)
    #hoja[5,0] = "EEEEEEEEEEEEEEEEEEEEEEEEEEEE"
    workbook.close
    
    send_file "#{RAILS_ROOT}/public/documentos/xls/#{nombre_archivo}.xls"

  end

  
  def xls_cartera_analista
    mes_cierre = params[:xls_mes]
    ano_cierre = params[:xls_ano]

    #-----GENERA EL EXCEL DE COBRANZA Y LO GUARDA EN DISCO
    nombre_archivo = "#{ano_cierre}_#{mes_cierre}_ESTADISTICA_CARTERA_ANALISTA"
    workbook = Excel.new("#{RAILS_ROOT}/public/documentos/xls/#{nombre_archivo}.xls")
    hoja = workbook.add_worksheet("Resumen")

    hoja.write(0, 0, "#{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.gerencia_ejecutiva')} #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cooperacion_financiamiento')}")
    hoja.write(1, 0, "#{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.gerencia')} #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.administracion_cartera')} - #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.coordinacion')} #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cobranzas')}")
    hoja.write(2, 0, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.estadistica_region'), :mes_cierre=>mes_cierre, :ano_cierre=>ano_cierre)
    hoja.write(3, 0, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cierre_al'), :mes_cierre=>mes_cierre, :ano_cierre=>ano_cierre, :cartera => I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cobranza_fondos'))


    @usuarios_analistas = Usuario.find(:all, :conditions => "usuario.departamento_id IN (select departamento.id from departamento where nombre = 'Analisis')")

    fila = 6
    hoja.write(fila, 0, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.carteras'))
    hoja.write(fila + 1, 0, "-- #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.regiones')} --")
    hoja.write(fila, 1, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.analistas'))
    fila = 8
    fila += 1
    sql_auto_generado = ""
    columna = 1

    for registro in @usuarios_analistas

      sql_auto_generado += "get_ventas_analista_cartera('#{mes_cierre}', '#{ano_cierre}',  tipo_cartera.id, '#{registro.nombre_usuario}', 'FONDOS AUTONOMOS') as analista_#{columna}, get_ventas_analista_cartera_consultoria_juridica('#{mes_cierre}', '#{ano_cierre}',  tipo_cartera.id, '#{registro.nombre_usuario}', 'FONDOS AUTONOMOS') as cjuridica_#{columna}, "
      eval("_acumulador_analista_#{columna} = 0")      
      eval("_acumulador_cjuridica_#{columna} = 0")    


      hoja.write(7, columna, registro.primer_nombre + ' ' + registro.primer_apellido)
     fila += 1
     columna += 1
   end
   hoja.write(7, columna, "-- #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.total')} --")

   
   sql_auto_generado += "*"
   sql_auto_generado = sql_auto_generado.gsub(", *", " ")
   sql_ultimate  = "SELECT tipo_cartera.id, tipo_cartera.nombre, #{sql_auto_generado} "
   sql_ultimate += "FROM tipo_cartera "
   sql_ultimate += "" 
   @resultado_pagos_2 = ViewResumenPagosCierre.find_by_sql("#{sql_ultimate}")
   fila = 8
   _monto_celda = 0
   for registro in @resultado_pagos_2
     contador_auxiliar = 1
     hoja.write(fila, 0, registro.nombre)

     _acumulador_fila = 0  
     while(contador_auxiliar < columna) 
        
       eval("_acumulador_analista_#{contador_auxiliar} += registro.analista_#{contador_auxiliar}.to_f")
       eval("_acumulador_cjuridica_#{contador_auxiliar} += registro.cjuridica_#{contador_auxiliar}.to_f")
       eval("_acumulador_fila += registro.analista_#{contador_auxiliar}.to_f")
       _monto_celda = eval("registro.analista_#{contador_auxiliar}.to_f")
       hoja.write(fila, contador_auxiliar, _monto_celda)
       contador_auxiliar += 1

     end
     hoja.write(fila, contador_auxiliar, _acumulador_fila)
   fila += 1
   end
   hoja.write(fila, 0, "-- #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.total')} --")
   hoja.write(fila + 1, 0, "-- #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.gestion_consultoria')} --")
   hoja.write(fila + 2, 0, "-- #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.gestion_cobranzas')} --")
   

   contador_auxiliar = 1
  _acumulador_final  = 0
  _acumulador_final_cjuridica = 0


   while(contador_auxiliar < columna) 
     _acumulador_final += eval("_acumulador_analista_#{contador_auxiliar}")
     _acumulador_final_cjuridica += eval("_acumulador_cjuridica_#{contador_auxiliar}")

     hoja.write(fila, contador_auxiliar, eval("_acumulador_analista_#{contador_auxiliar}"))
     hoja.write(fila + 1, contador_auxiliar, eval("_acumulador_cjuridica_#{contador_auxiliar}"))
     hoja.write(fila + 2, contador_auxiliar, eval("_acumulador_analista_#{contador_auxiliar} - _acumulador_cjuridica_#{contador_auxiliar}"))
     contador_auxiliar += 1
   end
   hoja.write(fila, contador_auxiliar, _acumulador_final)
   hoja.write(fila + 1, contador_auxiliar, _acumulador_final_cjuridica)
   hoja.write(fila + 2, contador_auxiliar, _acumulador_final - _acumulador_final_cjuridica)
   



    workbook.close 
    send_file "#{RAILS_ROOT}/public/documentos/xls/#{nombre_archivo}.xls"

  end

  
  def xls_cartera_codigo_cliente
    mes_cierre = params[:xls_mes]
    ano_cierre = params[:xls_ano]

    #-----GENERA EL EXCEL DE COBRANZA Y LO GUARDA EN DISCO
    nombre_archivo = "#{ano_cierre}_#{mes_cierre}_ESTADISTICA_CARTERA_CODIGO_CLIENTE"
    workbook = Excel.new("#{RAILS_ROOT}/public/documentos/xls/#{nombre_archivo}.xls")
    hoja = workbook.add_worksheet("Resumen")

    hoja.write(0, 0, "#{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.gerencia_ejecutiva')} #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cooperacion_financiamiento')}")
    hoja.write(1, 0, "#{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.gerencia')} #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.administracion_cartera')} - #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.coordinacion')} #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cobranzas')}")
    hoja.write(2, 0, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.estadistica_cobranza_cartera'), :mes_cierre=>mes_cierre, :ano_cierre=>ano_cierre)
    hoja.write(3, 0, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cierre_al'), :mes_cierre=>mes_cierre, :ano_cierre=>ano_cierre, :cartera => I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cobranza_fondos'))

   
    sql = "SELECT fecha as fecha_realizacion, tipo_cartera_id as tipo_cartera_id, beneficiario, codigo_contable, monto, capital, intereses_ordinarios, intereses_diferidos, intereses_mora, saldo_a_favor, interes_causado, banco_origen as banco_origen, tipo_cartera_nombre as tipo_cartera_nombre "
    sql += "FROM view_resumen_pagos_cierre_extendido "
    sql += "WHERE " 
    sql += "EXTRACT(YEAR from fecha) = #{ano_cierre}"
    sql += "AND " 
    sql += "EXTRACT(MONTH from fecha) = #{mes_cierre}"
    sql += "AND " 
    sql += "banco_origen = 'FONDOS AUTONOMOS'"
   sql += "ORDER BY tipo_cartera_id ASC"


    @resultado_pagos = ViewResumenPagosCierre.find_by_sql("#{sql}")
    acumulador_monto = 0
    acumulador_capital = 0
    acumulador_intereses_ordinarios = 0
    acumulador_intereses_diferidos = 0
    acumulador_intereses_mora = 0
    acumulador_interes_causado = 0
    acumulador_saldo_a_favor = 0
    memoria_cartera = 0
    
   fila = 8
    hoja.write(fila, 0, "CARTERA")
    hoja.write(fila, 1, "BENEFICIARIO")
    hoja.write(fila, 2, "CODIGO CONTABLE")
    hoja.write(fila, 3, "MONTO BsF.")
    hoja.write(fila, 4, "CAPITAL BsF.")
    hoja.write(fila, 5, "INTERESES ORDINARIOS BsF.")
    hoja.write(fila, 6, "INTERESES DIFERIDOS BsF.")
    hoja.write(fila, 7, "INTERESES DE MORA BsF.")
    hoja.write(fila, 8, "SALDO A FAVOR BsF.")
    hoja.write(fila, 9, "INTERES CAUSADO BsF.")
    

 
   fila += 1
   nro_ciclo = 0
   for registro in @resultado_pagos
   
   logger.info memoria_cartera.to_s + "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" + registro.tipo_cartera_id.to_s
   if ((memoria_cartera.to_i != registro.tipo_cartera_id.to_i) and nro_ciclo.to_i != 0)    then
     

     hoja.write(fila, 0, "--TOTALES BsF. --")
     hoja.write(fila, 1, "---------")
     hoja.write(fila, 2, "---------")
     hoja.write(fila, 3, acumulador_monto.to_f)
     hoja.write(fila, 4, acumulador_capital.to_f)
     hoja.write(fila, 5, acumulador_intereses_ordinarios.to_f)
     hoja.write(fila, 6, acumulador_intereses_diferidos.to_f)
     hoja.write(fila, 7, acumulador_intereses_mora.to_f)
     hoja.write(fila, 8, acumulador_saldo_a_favor.to_f)
     hoja.write(fila, 9, acumulador_interes_causado.to_f)
   
     acumulador_monto = 0
     acumulador_capital = 0
     acumulador_intereses_ordinarios = 0
     acumulador_intereses_diferidos = 0
     acumulador_intereses_mora = 0
     acumulador_interes_causado = 0
     acumulador_saldo_a_favor = 0


     
     fila += 1

   end 



    hoja.write(fila, 0, registro.tipo_cartera_nombre)
    hoja.write(fila, 1, registro.beneficiario)
    hoja.write(fila, 2, registro.codigo_contable)
    hoja.write(fila, 3, registro.monto.to_f)
    hoja.write(fila, 4, registro.capital.to_f)
    hoja.write(fila, 5, registro.intereses_ordinarios.to_f)
    hoja.write(fila, 6, registro.intereses_diferidos.to_f)
    hoja.write(fila, 7, registro.intereses_mora.to_f)
    hoja.write(fila, 8, registro.saldo_a_favor.to_f)
    hoja.write(fila, 9, registro.interes_causado.to_f)
  
    acumulador_monto += registro.monto.to_f 
    acumulador_capital += registro.capital.to_f
    acumulador_intereses_ordinarios += registro.intereses_ordinarios.to_f
    acumulador_intereses_diferidos += registro.intereses_diferidos.to_f
    acumulador_intereses_mora += registro.intereses_mora.to_f
    acumulador_interes_causado += registro.interes_causado.to_f
    acumulador_saldo_a_favor  += registro.saldo_a_favor.to_f

    memoria_cartera = registro.tipo_cartera_id.to_i
    nro_ciclo += 1
    fila += 1
   end

   hoja.write(fila, 0, "--TOTALES BsF. --")
     hoja.write(fila, 1, "---------")
     hoja.write(fila, 2, "---------")
     hoja.write(fila, 3, acumulador_monto.to_f)
     hoja.write(fila, 4, acumulador_capital.to_f)
     hoja.write(fila, 5, acumulador_intereses_ordinarios.to_f)
     hoja.write(fila, 6, acumulador_intereses_diferidos.to_f)
     hoja.write(fila, 7, acumulador_intereses_mora.to_f)
     hoja.write(fila, 8, acumulador_saldo_a_favor.to_f)
     hoja.write(fila, 9, acumulador_interes_causado.to_f)
   
     acumulador_monto = 0
     acumulador_capital = 0
     acumulador_intereses_ordinarios = 0
     acumulador_intereses_diferidos = 0
     acumulador_intereses_mora = 0
     acumulador_interes_causado = 0
     acumulador_saldo_a_favor = 0


   
    workbook.close 
    send_file "#{RAILS_ROOT}/public/documentos/xls/#{nombre_archivo}.xls"

  end




  protected
  def common
    super
    @form_title = 'Cierre Financiero de Cartera -Fondos Autonomos- '
    @form_title_record = 'Cierre' 
    @form_title_records = 'Cierre'
    @form_entity = 'Cierre'
    @form_identity_field = 'numero'
    @width_layout = '1000'
  end 

  def meses_cierre_fill
    @tabla_cuadre_obj = TablaCuadre.new()
    @meses_cierre_select = @tabla_cuadre_obj.get_select_mes_ano("FONDOS AUTONOMOS")
  end



end

