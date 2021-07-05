# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Prestamos::CierreFinancieroController
# descripción: Migración a Rails 3
#
class Prestamos::CierreFinancieroController < FormClassicController

  layout 'form_basic'
  require 'spreadsheet'
  include Spreadsheet

  def index
    meses_cierre_fill
    @list = TablaCuadre.find(:all, :conditions => "banco_origen = 'FONDAS'", :order => 'id DESC');
    #@list = TablaCuadre.all().order('id DESC');
    form_list
  end




  def list
    mes_ano_cierre = params[:mes_cierre_id]

    #-----EJECUTA EL CIERRE
    @nuevo_cierre = TablaCuadre.new

    estatus = @nuevo_cierre.ejecutar_cierre(mes_ano_cierre, 'FONDAS')

    if estatus
      @list = TablaCuadre.find(:all, :conditions => "banco_origen = 'FONDAS'", :order => 'mes DESC, ano DESC');
      form_list
    else
      render :update do |page|
        page.form_error
      end
    end

  end

  def xls_cartera
    #-----GENERA EL EXCEL DE CARTERA Y LO GUARDA EN DISCO
    mes_cierre = params[:xls_mes]
    ano_cierre = params[:xls_ano]
    nombre_archivo = "#{ano_cierre}_#{mes_cierre}_CARTERA_DIRECTO"
    nombre_xls     = "#{ano_cierre}_#{mes_cierre}_CARTERA_DIRECTO.xls"
    ruta_archivo_xls = "#{Rails.root}/public/documentos/xls/#{nombre_xls}"
    workbook1 = Spreadsheet::Workbook.new
    worksheet1 = workbook1.create_worksheet
    worksheet1.name = 'Resumen'
    bold = Spreadsheet::Format.new :weight => :bold
    #converter = String.encode
    #converter = Iconv.new('latin1//IGNORE//TRANSLIT', 'utf-8')
    title1 = ["#{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.gerencia_ejecutiva')} #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cooperacion_financiamiento')}"]
    title2 = ["#{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.gerencia')} #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.administracion_cartera')} - #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.coordinacion')} #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cobranzas')}"]
    title3 = [I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.consolidado', mes_cierre: mes_cierre, ano_cierre: ano_cierre)]
    title4 = [I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cierre_al', mes_cierre: mes_cierre, ano_cierre: ano_cierre, cartera: I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cartera_bandes', institucion: I18n.t('Sistema.Body.General.banco_origen')))]
    worksheet1.row(0).concat title1
    worksheet1.row(1).concat title2
    worksheet1.row(2).concat title3
    worksheet1.row(3).concat title4
    worksheet1.row(0).default_format = bold
    worksheet1.row(1).default_format = bold
    worksheet1.row(2).default_format = bold
    worksheet1.row(3).default_format = bold
    etiquetas = [I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.programa_convenio_linea')   ,
              I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.propuesta_productos')          ,
              I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.tipo_organizacion')            ,
              I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.nombre_organizacion')          ,
              I18n.t('Sistema.Body.Vistas.General.rif')                                                         ,
              I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.beneficiario_representante')   ,
              I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cedula_identidad')             ,
              I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.capital_suscrito')             ,
              I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.fecha_aprobacion')             ,
              I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.monto_credito')                ,
              I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.monto_liquidado')              ,
              I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.fecha_liquidacion_pd')         ,
              I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.fecha_vencimiento')            ,
              I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.modalidad_pago')               ,
              I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.plazo_amortizacion')           ,
              I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.periodo_gracia')               ,
              I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.meses_diferimiento')           ,
              I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.tasa')                         ,
              I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.sector_economico')             ,
              I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.actividad_economica')          ,
              I18n.t('Sistema.Body.Vistas.General.estado').upcase                                               ,
              I18n.t('Sistema.Body.Vistas.General.municipio').upcase                                            ,
              I18n.t('Sistema.Body.Vistas.General.parroquia').upcase                                            ,
              I18n.t('Sistema.Body.Vistas.General.region').upcase                                               ,
              I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.avenida_calle')                ,
              I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.edificio_casa')                ,
              I18n.t('Sistema.Body.Vistas.General.telefonos').upcase                                            ,
              I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.banco_recaudador')             ,
              I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cuenta_recuperacion')          ,
              I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.codigo_contable')              ,
              I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.status')                       ,
              I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cuotas_diferidas')             ,
              I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cuotas_vencidas')              ,
              I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.total_capital_vencido')        ,
              I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.total_intereses')              ,
              I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.total_mora')                   ,
              I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.total_recuperado_capital')     ,
              I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.total_intereses_recuperados')  ,
              I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.total_mora_pagado')            ,
              I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.indice_mora')                  ,
              I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.provision_bandes')             ,
              I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cuotas_conversion_mensual')    ,
              I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.categoria_riesgo_sudeban')     ,
              I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.porcentaje_provision_sudeban') ,
              I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.monto_aprobado')               ,
              I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.van')                          ,
              I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.tir')                          ,
              I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.tabla_amortizacion')           ,
              I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cantidad_cuotas_pendientes')   ,
              I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cantidad_cuotas_pagadas')      ,
              I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.capital_por_vencer')           ,
              I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.saldo_insoluto')               ,
              I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.saldo_exigible')               ,
              I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.deuda')                        ,
              I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.interes_diferido_vencido')     ,
              I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.interes_diferido_vencer')      ,
              I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.dias_vencido')                 ,
              I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.dias_vigente')                 ,
              I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.dias_demorado')                ,
              I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.origen_fondos')                ,
              I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.atributo_proyecto')            ,
              I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.segmentacion')                 ,
              I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.programa_convenios')
              ]
    worksheet1.row(5).concat etiquetas
    worksheet1.row(5).default_format = bold
    filas = []
    ViewMegaSabana.find_all_by_mes_and_ano(mes_cierre,ano_cierre).each do |dat|
      aux = []
      aux << dat.alias
      aux << dat.propuesta
      aux << dat.tipo_organizacion
      aux << dat.nombre_organizacion
      aux << dat.rif
      aux << dat.beneficiario_nombre
      aux << dat.cedula
      aux << dat.capital_suscrito
      aux << dat.fecha_aprobacion
      aux << dat.monto_credito
      aux << dat.monto_liquidado
      aux << dat.fecha_liquidacion
      aux << dat.fecha_vencimiento
      aux << dat.modalidad_pago
      aux << dat.plazo
      aux << dat.periodo_gracia
      aux << dat.periodo_diferimiento_intereses
      aux << dat.tasa.to_f
      aux << dat.sector_economico
      aux << dat.actividad_economica_unidad_negocio
      aux << dat.solicitud_estado
      aux << dat.solicitud_municipio
      aux << dat.solicitud_parroquia
      aux << dat.solicitud_region
      aux << dat.avenida
      aux << dat.edificio_casa
      aux << dat.telefonos
      aux << dat.banco_recaudador
      aux << dat.numero_cuenta
      aux << dat.codigo_contable
      aux << dat.estatus
      aux << dat.cuotas_diferidas_capital
      aux << dat.cuotas_vencidas
      aux << dat.prestamo_capital_vencido
      aux << dat.intereses_ordinarios_vencidos
      aux << dat.prestamo_interes_mora
      aux << dat.total_recuperado_capital
      aux << dat.total_recuperado_intereses_ordinarios
      aux << dat.total_intereses_mora_pagados
      aux << dat.indice_mora
      aux << dat.provision_contrato_bandes
      aux << dat.conversion_cuotas_mensuales_bandes
      aux << dat.clasificacion_riesgo_sudeban
      aux << dat.porcentaje_individual_provision_sudeban
      aux << dat.monto_aprobado
      aux << dat.solicitud_van
      aux << dat.solicitud_tir
      aux << dat.prestamo_tabla
      aux << dat.prestamo_cuotas_pendientes
      aux << dat.prestamo_cuotas_pagadas
      aux << dat.prestamo_capital_por_pagar
      aux << dat.prestamo_saldo_insoluto
      aux << dat.prestamo_exigible
      aux << dat.prestamo_deuda
      aux << dat.prestamo_interes_diferido_vencido
      aux << dat.prestamo_interes_diferido_por_vencer
      aux << dat.dias_vencido
      aux << dat.prestamo_dias_vigente
      aux << dat.prestamo_dias_demorado
      aux << dat.solicitud_origen_fondo
      aux << dat.solicitud_modalidad_financiamiento
      aux << dat.prestamo_banco_origen # banco origen
      aux << dat.solicitud_programa
      filas << aux
    end
    filas.each_with_index do |row,row_index|
      worksheet1.row(row_index+6).concat row
    end
    workbook1.write ruta_archivo_xls
    send_file "#{Rails.root}/public/documentos/xls/#{nombre_archivo}.xls"

  end



  def xls_desembolsos
    mes_cierre = params[:xls_mes]
    ano_cierre = params[:xls_ano]
   #-----GENERA EL EXCEL DE DESEMBOLSOS Y LO GUARDA EN DISCO
    nombre_archivo = "#{ano_cierre}_#{mes_cierre}_DESEMBOLSOS"
    workbook = Excel.new("#{Rails.root}/public/documentos/xls/#{nombre_archivo}.xls")
    hoja = workbook.add_worksheet("Resumen")


    hoja.write(0, 0, "#{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.gerencia_ejecutiva')} #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cooperacion_financiamiento')}")
    hoja.write(1, 0, "#{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.gerencia')} #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.administracion_cartera')} - #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.coordinacion')} #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cobranzas')}")
    hoja.write(2, 0, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.consolidado', mes_cierre: mes_cierre, ano_cierre: ano_cierre))
    hoja.write(3, 0, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cierre_al', mes_cierre: mes_cierre,  ano_cierre: ano_cierre, cartera: I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.desembolsos_institucion', institucion: I18n.t('Sistema.Body.General.banco_origen'))))



    sql  = "SELECT * FROM view_resumen_desembolsos_cierre "
    sql += "WHERE "
    sql += "EXTRACT(MONTH from fecha) = #{mes_cierre} AND EXTRACT(YEAR from fecha) = #{ano_cierre} AND banco_origen = 'FONDAS'"
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
    send_file "#{Rails.root}/public/documentos/xls/#{nombre_archivo}.xls"
    #-------------------------------------------------------------------------------


  end


  def xls_cobranza
    mes_cierre = params[:xls_mes]
    ano_cierre = params[:xls_ano]


    #-----GENERA EL EXCEL DE COBRANZA Y LO GUARDA EN DISCO
    nombre_archivo = "#{ano_cierre}_#{mes_cierre}_COBRANZA_BANDES_DIRECTO"
    workbook = Excel.new("#{Rails.root}/public/documentos/xls/#{nombre_archivo}.xls")
    hoja = workbook.add_worksheet("Resumen")

    hoja.write(0, 0, "#{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.gerencia_ejecutiva')} #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cooperacion_financiamiento')}")
    hoja.write(1, 0, "#{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.gerencia')} #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.administracion_cartera')} - #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.coordinacion')} #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cobranzas')}")
    hoja.write(2, 0, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.consolidado', mes_cierre: mes_cierre, ano_cierre: ano_cierre))
    hoja.write(3, 0, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cierre_al', mes_cierre: mes_cierre, ano_cierre: ano_cierre, cartera: I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cobranza_institucion', institucion: I18n.t('Sistema.Body.General.banco_origen'))))


    sql  = "SELECT * FROM view_resumen_pagos_cierre "
    sql += "WHERE "
    sql += "EXTRACT(MONTH from fecha_contable) = #{mes_cierre} AND EXTRACT(YEAR from fecha_contable) = #{ano_cierre}  AND banco_origen = 'FONDAS' "
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
    hoja.write(fila, 10, registro.capital.to_f + registro.abono_capital.to_f)
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
    send_file "#{Rails.root}/public/documentos/xls/#{nombre_archivo}.xls"

  end


def xls_sector_estatus
    mes_cierre = params[:xls_mes]
    ano_cierre = params[:xls_ano]


    #-----GENERA EL EXCEL DE COBRANZA Y LO GUARDA EN DISCO
    nombre_archivo = "#{ano_cierre}_#{mes_cierre}_ESTADISTICA_CARTERA_ESTATUS"
    workbook = Excel.new("#{Rails.root}/public/documentos/xls/#{nombre_archivo}.xls")
    hoja = workbook.add_worksheet("Resumen")


    hoja.write(0, 0, "#{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.gerencia_ejecutiva')} #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cooperacion_financiamiento')}")
    hoja.write(1, 0, "#{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.gerencia')} #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.administracion_cartera')} - #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.coordinacion')} #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cobranzas')}")
    hoja.write(2, 0, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.estadistica_cartera', mes_cierre: mes_cierre, ano_cierre: ano_cierre))
    hoja.write(3, 0, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cierre_al', mes_cierre: mes_cierre, ano_cierre: ano_cierre, cartera: I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cobranza_institucion', institucion: I18n.t('Sistema.Body.General.banco_origen'))))

    sql = "select "
    sql += "sector.nombre as sector_economico_nombre, "
    sql += "totalizador_pagos_estadistica(#{mes_cierre}, #{ano_cierre}, sector.id, 'VIGENTE', 0, 'FONDAS') as nro_cartera_vigente, totalizador_pagos_estadistica(#{mes_cierre}, #{ano_cierre}, sector.id, 'VIGENTE', 1, 'FONDAS') as monto_cartera_vigente, "
    sql += "totalizador_pagos_estadistica(#{mes_cierre}, #{ano_cierre}, sector.id, 'CANCELADO', 0, 'FONDAS') as nro_cartera_vencida, totalizador_pagos_estadistica(#{mes_cierre}, #{ano_cierre}, sector.id, 'CANCELADO', 1, 'FONDAS') as monto_cartera_vencida, "
    sql += "totalizador_pagos_estadistica(#{mes_cierre}, #{ano_cierre}, sector.id, 'LITIGIO', 0, 'FONDAS') as nro_cartera_litigio, totalizador_pagos_estadistica(#{mes_cierre}, #{ano_cierre}, sector.id, 'LITIGIO', 1, 'FONDAS') as monto_cartera_litigio "
    sql += "from "
    sql += "sector "
    sql += "where "
    sql += "sector.activo = true "
    sql += "Order by nombre ASC "



 #   sql  = "SELECT * FROM view_resumen_pagos_cierre "
 #   sql += "WHERE "
 #   sql += "EXTRACT(MONTH from fecha_contable) = #{mes_cierre} AND EXTRACT(YEAR from fecha_contable) = #{ano_cierre} AND banco_origen = 'BANDES' "
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


    hoja.write(fila, 0, "--#{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.totales')}--")
    hoja.write(fila, 1, acumulador_nro_cartera_vigente.to_i)
    hoja.write(fila, 2, acumulador_monto_cartera_vigente.to_f)
    hoja.write(fila, 3, acumulador_nro_cartera_vencida.to_i)
    hoja.write(fila, 4, acumulador_monto_cartera_vencida.to_f)
    hoja.write(fila, 5, acumulador_nro_cartera_litigio.to_i)
    hoja.write(fila, 6, acumulador_monto_cartera_litigio.to_f)
    hoja.write(fila, 7, acumulador_nro_cartera_total.to_i)
    hoja.write(fila, 8, acumulador_monto_cartera_total.to_f)




    workbook.close
    send_file "#{Rails.root}/public/documentos/xls/#{nombre_archivo}.xls"

  end


  def xls_region_estatus
    mes_cierre = params[:xls_mes]
    ano_cierre = params[:xls_ano]


    #-----GENERA EL EXCEL DE COBRANZA Y LO GUARDA EN DISCO
    nombre_archivo = "#{ano_cierre}_#{mes_cierre}_ESTADISTICA_CARTERA_ESTATUS_REGION"
    workbook = Excel.new("#{Rails.root}/public/documentos/xls/#{nombre_archivo}.xls")
    hoja = workbook.add_worksheet("Resumen")


    hoja.write(0, 0, "#{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.gerencia_ejecutiva')} #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cooperacion_financiamiento')}")
    hoja.write(1, 0, "#{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.gerencia')} #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.administracion_cartera')} - #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.coordinacion')} #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cobranzas')}")
    hoja.write(2, 0, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.estadistica_region', mes_cierre: mes_cierre, ano_cierre: ano_cierre))
    hoja.write(3, 0, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cierre_al', mes_cierre: mes_cierre, ano_cierre: ano_cierre, cartera: I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cobranza_institucion', institucion: I18n.t('Sistema.Body.General.banco_origen'))))

    sql = "select "
    sql += "sector.nombre as sector_economico_nombre, "
    sql += "totalizador_pagos_estadistica(#{mes_cierre}, #{ano_cierre}, sector.id, 'VIGENTE', 0, 'FONDAS') as nro_cartera_vigente, totalizador_pagos_estadistica(#{mes_cierre}, #{ano_cierre}, sector.id, 'VIGENTE', 1, 'FONDAS') as monto_cartera_vigente, "
    sql += "totalizador_pagos_estadistica(#{mes_cierre}, #{ano_cierre}, sector.id, 'CANCELADO', 0, 'FONDAS') as nro_cartera_vencida, totalizador_pagos_estadistica(#{mes_cierre}, #{ano_cierre}, sector.id, 'CANCELADO', 1, 'FONDAS') as monto_cartera_vencida, "
    sql += "totalizador_pagos_estadistica(#{mes_cierre}, #{ano_cierre}, sector.id, 'LITGIO', 0, 'FONDAS') as nro_cartera_litigio, totalizador_pagos_estadistica(#{mes_cierre}, #{ano_cierre}, sector.id, 'LITIGIO', 1, 'FONDAS') as monto_cartera_litigio "
    sql += "from "
    sql += "sector "
    sql += "where "
    sql += "sector.activo = true "
    sql += "Order by nombre ASC "





    sql = "select estado.nombre as region, "
    sql += "totalizador_pagos_estadistica_estado_geografico(#{mes_cierre}, #{ano_cierre}, estado.id, 'VIGENTE', 0, 'FONDAS') as nro_cartera_vigente, totalizador_pagos_estadistica_estado_geografico(#{mes_cierre}, #{ano_cierre}, estado.id, 'VIGENTE', 1, 'FONDAS') as monto_cartera_vigente, "
    sql += "totalizador_pagos_estadistica_estado_geografico(#{mes_cierre}, #{ano_cierre}, estado.id, 'CANCELADO', 0, 'FONDAS') as nro_cartera_vencida, totalizador_pagos_estadistica_estado_geografico(#{mes_cierre}, #{ano_cierre}, estado.id, 'CANCELADO', 1, 'FONDAS') as monto_cartera_vencida, "
    sql += "totalizador_pagos_estadistica_estado_geografico(#{mes_cierre}, #{ano_cierre}, estado.id, 'LITIGIO', 0, 'FONDAS') as nro_cartera_litigio, totalizador_pagos_estadistica_estado_geografico(#{mes_cierre}, #{ano_cierre}, estado.id, 'LITIGIO', 1, 'FONDAS') as monto_cartera_litigio "
    sql += "from estado "
    sql += "Where pais_id = 1 "



 #   sql  = "SELECT * FROM view_resumen_pagos_cierre "
 #   sql += "WHERE "
 #   sql += "EXTRACT(MONTH from fecha_contable) = #{mes_cierre} AND EXTRACT(YEAR from fecha_contable) = #{ano_cierre} AND banco_origen = 'BANDES' "
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

    send_file "#{Rails.root}/public/documentos/xls/#{nombre_archivo}.xls"

  end





  def xls_cartera_analista
    mes_cierre = params[:xls_mes]
    ano_cierre = params[:xls_ano]

    #-----GENERA EL EXCEL DE COBRANZA Y LO GUARDA EN DISCO
    nombre_archivo = "#{ano_cierre}_#{mes_cierre}_ESTADISTICA_CARTERA_ANALISTA"
    workbook = Excel.new("#{Rails.root}/public/documentos/xls/#{nombre_archivo}.xls")
    hoja = workbook.add_worksheet("Resumen")

    hoja.write(0, 0, "#{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.gerencia_ejecutiva')} #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cooperacion_financiamiento')}")
    hoja.write(1, 0, "#{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.gerencia')} #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.administracion_cartera')} - #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.coordinacion')} #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cobranzas')}")
    hoja.write(2, 0, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.estadistica_region', mes_cierre: mes_cierre, ano_cierre: ano_cierre))
    hoja.write(3, 0, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cierre_al', mes_cierre: mes_cierre, ano_cierre: ano_cierre, cartera: I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cobranza_institucion', institucion: I18n.t('Sistema.Body.General.banco_origen'))))

    @usuarios_analistas = Usuario.find(:all, :conditions => "activo = true OR usuario.nombre_usuario = 'admin'")

    fila = 6
    hoja.write(fila, 0, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.carteras'))
    hoja.write(fila + 1, 0, "-- #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.regiones')} --")
    hoja.write(fila, 1, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.analistas'))
    fila = 8
    fila += 1
    sql_auto_generado = ""
    columna = 1

    #logger.info "Usuarios Analistas =========> #{@usuarios_analistas.inspect}"
    for registro in @usuarios_analistas

      factura = Factura.first(:conditions=>"analista = \'#{registro.primer_nombre + ' / ' + registro.primer_apellido}\'")
      unless factura.nil?
        sql_auto_generado += "get_ventas_analista_cartera('#{mes_cierre}', '#{ano_cierre}',  tipo_cartera.id, '#{registro.primer_nombre + " / " + registro.primer_apellido}', 'FONDAS') as analista_#{columna}, get_ventas_analista_cartera_consultoria_juridica('#{mes_cierre}', '#{ano_cierre}',  tipo_cartera.id, '#{registro.primer_nombre + " / " + registro.primer_apellido}', 'FONDAS') as cjuridica_#{columna}, "
        eval("_acumulador_analista_#{columna} = 0")
        eval("_acumulador_cjuridica_#{columna} = 0")


        hoja.write(7, columna, registro.primer_nombre + ' ' + registro.primer_apellido)
        fila += 1
        columna += 1
      end
   end
   hoja.write(7, columna, "-- #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.total')} --")




   sql_auto_generado += "*"
   sql_auto_generado = sql_auto_generado.gsub(", *", " ")
   logger.info "Sql auto generado =======> #{sql_auto_generado}"
   sql_ultimate  = "SELECT sector.id, sector.nombre, #{sql_auto_generado} "
   sql_ultimate += "FROM tipo_cartera "
   sql_ultimate += ""
   logger.info "Sql ultimate ========> #{sql_ultimate}"
   #@resultado_pagos_2 = ViewResumenPagosCierre.find_by_sql("#{sql_ultimate}")
   @resultado_pagos_2 = TipoCartera.find_by_sql("#{sql_ultimate}")
   fila = 8
   _monto_celda = 0
   logger.info "Resultado Pagos =======> #{@resultado_pagos_2.inspect}"
   for registro in @resultado_pagos_2
     contador_auxiliar = 1
     hoja.write(fila, 0, registro.nombre)

     _acumulador_fila = 0
     #logger.info "REGISTRO =========> #{registro.inspect}"
     while(contador_auxiliar < columna)

      unless "registro.analista_#{contador_auxiliar}".nil?
        eval("_acumulador_analista_#{contador_auxiliar} += registro.analista_#{contador_auxiliar}.to_f") 
      end
      unless "registro.cjuridica__#{contador_auxiliar}".nil?
        eval("_acumulador_cjuridica_#{contador_auxiliar} += registro.cjuridica_#{contador_auxiliar}.to_f")
      end
      unless "registro.cjuridica__#{contador_auxiliar}".nil?
        eval("_acumulador_fila += registro.analista_#{contador_auxiliar}.to_f")
        _monto_celda = eval("registro.analista_#{contador_auxiliar}.to_f")
        hoja.write(fila, contador_auxiliar, _monto_celda)
      end
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
    send_file "#{Rails.root}/public/documentos/xls/#{nombre_archivo}.xls"

  end





  def xls_cartera_codigo_cliente
    mes_cierre = params[:xls_mes]
    ano_cierre = params[:xls_ano]

    #-----GENERA EL EXCEL DE COBRANZA Y LO GUARDA EN DISCO
    nombre_archivo = "#{ano_cierre}_#{mes_cierre}_ESTADISTICA_CARTERA_CODIGO_CLIENTE"
    workbook = Excel.new("#{Rails.root}/public/documentos/xls/#{nombre_archivo}.xls")
    hoja = workbook.add_worksheet("Resumen")

    hoja.write(0, 0, "#{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.gerencia_ejecutiva')} #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cooperacion_financiamiento')}")
    hoja.write(1, 0, "#{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.gerencia')} #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.administracion_cartera')} - #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.coordinacion')} #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cobranzas')}")
    hoja.write(2, 0, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.estadistica_cobranza_cartera', mes_cierre: mes_cierre, ano_cierre: ano_cierre))
    hoja.write(3, 0, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cierre_al', mes_cierre: mes_cierre, ano_cierre: ano_cierre, cartera: I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cobranza_institucion', institucion: I18n.t('Sistema.Body.General.banco_origen'))))


    sql = "SELECT fecha as fecha_realizacion, tipo_cartera_id as tipo_cartera_id, beneficiario, codigo_contable, monto, capital, intereses_ordinarios, intereses_diferidos, intereses_mora, saldo_a_favor, interes_causado, banco_origen as banco_origen, tipo_cartera_nombre as tipo_cartera_nombre, abono_capital as abono_capital "
    sql += "FROM view_resumen_pagos_cierre_extendido "
    sql += "WHERE "
    sql += "EXTRACT(YEAR from fecha) = #{ano_cierre}"
    sql += "AND "
    sql += "EXTRACT(MONTH from fecha) = #{mes_cierre}"
    sql += "AND "
    sql += "banco_origen = 'FONDAS'"
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
    hoja.write(fila, 0, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.cartera'))
    hoja.write(fila, 1, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.beneficiario'))
    hoja.write(fila, 2, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.codigo_contabilidad'))
    hoja.write(fila, 3, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.codigo_contabilidad'))
    hoja.write(fila, 4, "#{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.codigo_contabilidad')} #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.bs')}")
    hoja.write(fila, 5, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.interes_ordinario'))
    hoja.write(fila, 6, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.interes_diferido'))
    hoja.write(fila, 7, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.interes_mora'))
    hoja.write(fila, 8, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.saldo_favor'))
    hoja.write(fila, 9, I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.interes_causado'))



   fila += 1
   nro_ciclo = 0
   for registro in @resultado_pagos

   logger.info memoria_cartera.to_s + "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" + registro.tipo_cartera_id.to_s
   if ((memoria_cartera.to_i != registro.tipo_cartera_id.to_i) and nro_ciclo.to_i != 0)    then


     hoja.write(fila, 0, "--#{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.totales')} #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.bs')} --")
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
    hoja.write(fila, 4, registro.capital.to_f + registro.abono_capital.to_f)
    hoja.write(fila, 5, registro.intereses_ordinarios.to_f)
    hoja.write(fila, 6, registro.intereses_diferidos.to_f)
    hoja.write(fila, 7, registro.intereses_mora.to_f)
    hoja.write(fila, 8, registro.saldo_a_favor.to_f)
    hoja.write(fila, 9, registro.interes_causado.to_f)

    acumulador_monto += registro.monto.to_f
    acumulador_capital += registro.capital.to_f + registro.abono_capital.to_f
    acumulador_intereses_ordinarios += registro.intereses_ordinarios.to_f
    acumulador_intereses_diferidos += registro.intereses_diferidos.to_f
    acumulador_intereses_mora += registro.intereses_mora.to_f
    acumulador_interes_causado += registro.interes_causado.to_f
    acumulador_saldo_a_favor  += registro.saldo_a_favor.to_f

    memoria_cartera = registro.tipo_cartera_id.to_i
    nro_ciclo += 1
    fila += 1
   end

   hoja.write(fila, 0, "-- #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.totales')} #{I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.bs')} --")
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
    send_file "#{Rails.root}/public/documentos/xls/#{nombre_archivo}.xls"

  end

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.CierreFinanciero.EtiquetasExcel.totales', institucion: ' - Institución - ')
    @form_title_record = 'Cierre'
    @form_title_records = 'Cierre'
    @form_entity = 'Cierre'
    @form_identity_field = 'numero'
    @width_layout = '1000'
  end

  def meses_cierre_fill
    @tabla_cuadre_obj = TablaCuadre.new()
    @meses_cierre_select = @tabla_cuadre_obj.get_select_mes_ano('FONDAS')
  end



end

