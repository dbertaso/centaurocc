# encoding: utf-8
#
# autor: Luis Rojas
# clase: ViewFinanciadoRecuperado
# descripción: Migración a Rails 3
#
require 'rubygems'
require 'spreadsheet'

class ViewFinanciadoRecuperado < ActiveRecord::Base

  self.table_name = 'view_financiado_recuperado'

  public
  
  
  def ViewFinanciadoRecuperado.exportar_excel(conditions,file_name,fecha_inicio, fecha_fin)
  
  

    sql = "SELECT numero_tramite, numero_financiamiento, nombre_beneficiario, "
    sql += "documento_beneficiario, programa_nombre, estado_nombre, sector_nombre, sub_sector_nombre, "
    sql += "rubro_nombre, sub_rubro_nombre, actividad_nombre, fecha_liquidacion, "
    sql += "fecha_vencimiento, monto_aprobado, monto_banco, monto_insumos, "
    sql += "monto_liquidado_banco, monto_por_liquidar_banco, monto_despachado_insumos, "
    sql += "monto_por_despachar_insumos, estatus_financiamiento, cantidad_cuotas_vencidas, "
    sql += "capital_vencido, interes_vencido, monto_mora, saldo_deudor, monto_exigible, "
    sql += "deuda_total, capital_recuperado, porcentaje_capital_recuperado, interes_recuperado, interes_mora_recuperado, "
    sql += "excedente_por_pagar, excedente_pagado, monto_sras_total, "
    sql += "monto_gasto_total, total_financiamiento, monto_facturado, "
    sql += "por_inventario, monto_inventario"
    sql += " from view_financiado_recuperado"
    sql += " where #{conditions}"
    sql += "order by programa_nombre, estado_nombre, sector_nombre, sub_sector_nombre, rubro_nombre, sub_rubro_nombre, actividad_nombre"
    
    nombre_archivo = ''
    
    logger.info "SQL ===============> #{sql}"
    vista = ViewFinanciadoRecuperado.find_by_sql(sql)
  
    programa_anterior = ''
    sector_anterior = ''
    estado_anterior = ''
    rubro_anterior = ''
    actividad_anterior = ''
    
    tp_monto_banco = 0.00
    tp_monto_insumos = 0.00
    tp_monto_sras = 0.00
    tp_monto_gasto = 0.00
    tp_total_financiamiento = 0.00
    tp_monto_liquidado_banco = 0.00
    tp_monto_por_liquidar_banco = 0.00
    tp_monto_insumos_despachados = 0.00
    tp_monto_insumos_por_despachar = 0.00
    tp_monto_facturado = 0.00
    tp_monto_capital_recuperado = 0.00
    tp_monto_interes_recuperado = 0.00
    tp_monto_interes_mora_recuperado = 0.00
    
    te_monto_banco = 0.00
    te_monto_insumos = 0.00
    te_monto_sras = 0.00
    te_monto_gasto = 0.00
    te_total_financiamiento = 0.00
    te_monto_liquidado_banco = 0.00
    te_monto_por_liquidar_banco = 0.00
    te_monto_insumos_despachados = 0.00
    te_monto_insumos_por_despachar = 0.00
    te_monto_facturado = 0.00
    te_monto_capital_recuperado = 0.00
    te_monto_interes_recuperado = 0.00
    te_monto_interes_mora_recuperado = 0.00
    
    ts_monto_banco = 0.00
    ts_monto_insumos = 0.00
    ts_monto_sras = 0.00
    ts_monto_gasto = 0.00
    ts_total_financiamiento = 0.00
    ts_monto_liquidado_banco = 0.00
    ts_monto_por_liquidar_banco = 0.00
    ts_monto_insumos_despachados = 0.00
    ts_monto_insumos_por_despachar = 0.00
    ts_monto_facturado = 0.00
    ts_monto_capital_recuperado = 0.00
    ts_monto_interes_recuperado = 0.00
    ts_monto_interes_mora_recuperado = 0.00
 
    ta_monto_banco = 0.00
    ta_monto_insumos = 0.00
    ta_monto_sras = 0.00
    ta_monto_gasto = 0.00
    ta_total_financiamiento = 0.00
    ta_monto_liquidado_banco = 0.00
    ta_monto_por_liquidar_banco = 0.00
    ta_monto_insumos_despachados = 0.00
    ta_monto_insumos_por_despachar = 0.00
    ta_monto_facturado = 0.00
    ta_monto_capital_recuperado = 0.00
    ta_monto_interes_recuperado = 0.00
    ta_monto_interes_mora_recuperado = 0.00
 
    tr_monto_banco = 0.00
    tr_monto_insumos = 0.00
    tr_monto_sras = 0.00
    tr_monto_gasto = 0.00
    tr_total_financiamiento = 0.00
    tr_monto_liquidado_banco = 0.00
    tr_monto_por_liquidar_banco = 0.00
    tr_monto_insumos_despachados = 0.00
    tr_monto_insumos_por_despachar = 0.00
    tr_monto_facturado = 0.00
    tr_monto_capital_recuperado = 0.00
    tr_monto_interes_recuperado = 0.00
    tr_monto_interes_mora_recuperado = 0.00      
    
    porcentaje_recuperacion = 0.00
    monto_por_liquidar = 0.00
    
    if vista.count > 0
    
      Spreadsheet.client_encoding = 'UTF-8'
      fecha = Time.now.strftime('%d_%m_%Y')
      nombre_archivo = "#{Rails.root}/public/documentos/xls/#{file_name}"

      workbook = Spreadsheet::Workbook.new
      logger.info "Workbook ===> workbook.inspect"
      sheet1 = workbook.create_worksheet :name => "Análisis de Ejecución"
      
      format = Spreadsheet::Format.new(:number_format => "#,##0.00_);[red](-0)",:horizontal_align=>'right')
      format_text = Spreadsheet::Format.new(:horizontal_align=>'center')
      #puts sheet1.name
      
      sheet1.format_column(0,format_text).width=50
      sheet1.format_column(1,format_text).width=20
      sheet1.format_column(2,format_text).width=20
      sheet1.format_column(3,format_text).width=20
      sheet1.format_column(4,format_text).width=60
      sheet1.format_column(5,format_text).width=20
      sheet1.format_column(6,format_text).width=30
      sheet1.format_column(7,format).width=30
      sheet1.format_column(8,format).width=30
      sheet1.format_column(9,format).width=30
      sheet1.format_column(10,format).width=30
      sheet1.format_column(11,format).width=30
      sheet1.format_column(12,format).width=30
      sheet1.format_column(13,format).width=30
      sheet1.format_column(14,format).width=30
      sheet1.format_column(15,format).width=30
      sheet1.format_column(16,format).width=30
      sheet1.format_column(17,format).width=30
      sheet1.format_column(18,format).width=30
      sheet1.format_column(19,format).width=30
      sheet1.format_column(20,format).width=30
      sheet1.format_column(21,format).width=30
      sheet1.format_column(22,format).width=30
      sheet1.format_column(23,format).width=30
      sheet1.format_column(24,format).width=300
      
      format_text = Spreadsheet::Format.new(:horizontal_align=>'center')
      sheet1.row(5).set_format(7,format_text)
      sheet1.row(5).set_format(8,format_text)
      sheet1.row(5).set_format(9,format_text)
      sheet1.row(5).set_format(10,format_text)
      format_text_right = Spreadsheet::Format.new(:horizontal_align=>'right')
      sheet1.row(5).set_format(11,format_text_right)
      sheet1.row(5).set_format(12,format_text_right)
      sheet1.row(5).set_format(13,format_text_right)
      sheet1.row(5).set_format(14,format_text_right)
      sheet1.row(5).set_format(15,format_text_right)
      sheet1.row(5).set_format(16,format_text_right)
      sheet1.row(5).set_format(17,format_text_right)
      sheet1.row(5).set_format(18,format_text_right)
      sheet1.row(5).set_format(19,format_text_right)
      sheet1.row(5).set_format(20,format_text_right)
      sheet1.row(5).set_format(21,format_text_right)
      sheet1.row(5).set_format(22,format_text_right)
      sheet1.row(5).set_format(23,format_text_right)
      sheet1.row(5).set_format(24,format_text_right)
                 
      sheet1[0,5] = 'PROTOKOL' 
      sheet1[1,0] = "Fecha de Elaboración: #{Time.now.strftime("%d-%m-%Y")}"
      sheet1[2,5] = "Análisis de Ejecución de la cartera en el Período desde: #{fecha_inicio} hasta: #{fecha_fin}"
      
      sheet1[4,11] = '                     A   P   R   O   B   A   D   O'
      sheet1[4,16] = 'LIQUIDADO '
      sheet1[4,21] = 'RECUPERADO'

      format_bold = Spreadsheet::Format.new :color => :yellow,
                                         :weight => :bold,
                                         :size => 18

      sheet1.row(4).set_format(11,format_bold)
      
      format_bold = Spreadsheet::Format.new :color => :green,
                                         :weight => :bold,
                                         :size => 18
                                         
      sheet1.row(4).set_format(16,format_bold)
 
      format_bold = Spreadsheet::Format.new :color => :aqua,
                                         :weight => :bold,
                                         :size => 18
                                         
      sheet1.row(4).set_format(21,format_bold)
           
      sheet1.row(4).height = 18
                                                 
      sheet1.row(5).push 'Nombre Beneficiario', 'Cédula/RIF', 'Número Trámite', 'Número Financiamiento', 'Programa', 
                         'Estado del País', 'Sector', 'Sub Sector', 'Rubro','Sub Rubro', 'Actividad', 'Monto Banco',
                         'Monto Insumos', 'Monto SRAS', 'Monto Gastos', 'Total Financiamiento',
                         'Monto Liquidado Banco', 'Monto por Liquidar Banco', 'Monto Insumos Despachados', 
                         'Monto por Despachar Insumos', 'Monto Insumos Facturados', 
                         'Capital Recuperado', '% Recuperación', 'Interés Recuperado', 'Interés de Mora Recuperado'
                         
      format_bold = Spreadsheet::Format.new :color => :black,
                                   :weight => :bold
                                   
      sheet1.row(5).set_format(0,format_bold)
      sheet1.row(5).set_format(1,format_bold)
      sheet1.row(5).set_format(2,format_bold)
      sheet1.row(5).set_format(3,format_bold)
      sheet1.row(5).set_format(4,format_bold)
      sheet1.row(5).set_format(5,format_bold)
      sheet1.row(5).set_format(6,format_bold)
      sheet1.row(5).set_format(7,format_bold)
      sheet1.row(5).set_format(8,format_bold)
      sheet1.row(5).set_format(9,format_bold)
      sheet1.row(5).set_format(10,format_bold)
      sheet1.row(5).set_format(11,format_bold)
      sheet1.row(5).set_format(12,format_bold)
      sheet1.row(5).set_format(13,format_bold)
      sheet1.row(5).set_format(14,format_bold)
      sheet1.row(5).set_format(15,format_bold)
      sheet1.row(5).set_format(16,format_bold)
      sheet1.row(5).set_format(17,format_bold)
      sheet1.row(5).set_format(18,format_bold)
      sheet1.row(5).set_format(19,format_bold)
      sheet1.row(5).set_format(20,format_bold)
      sheet1.row(5).set_format(21,format_bold)
      sheet1.row(5).set_format(22,format_bold)
      sheet1.row(5).set_format(23,format_bold)
      sheet1.row(5).set_format(24,format_bold)
                 
      fila = 7
      vista.each do |v|

        if programa_anterior != v.programa_nombre
          if programa_anterior != ''
          
            fila += 1
              
            #Totales por Actividad
            
            sheet1[fila,10] = "Total #{actividad_anterior}"
            sheet1[fila,11] = ta_monto_banco
            sheet1[fila,12] = ta_monto_insumos
            sheet1[fila,13] = ta_monto_sras
            sheet1[fila,14] = ta_monto_gasto
            sheet1[fila,15] = ta_total_financiamiento
            sheet1[fila,16] = ta_monto_liquidado_banco
            sheet1[fila,17] = ta_monto_por_liquidar_banco
            sheet1[fila,18] = ta_monto_insumos_despachados
            sheet1[fila,19] = ta_monto_insumos_por_despachar
            sheet1[fila,20] = ta_monto_facturado
            sheet1[fila,21] = ta_monto_capital_recuperado
            sheet1[fila,23] = ta_monto_interes_recuperado
            sheet1[fila,24] = ta_monto_interes_mora_recuperado            
            format_bold = Spreadsheet::Format.new :color => :blue,
                                                  :weight => :bold,
                                                  :number_format => "#,##0.00_);[red](-0)",
                                                  :horizontal_align=>'right'
                                             
            sheet1.row(fila).default_format = format_bold
            actividad_anterior = v.actividad_nombre

            ta_monto_banco = 0.00
            ta_monto_insumos = 0.00
            ta_monto_sras = 0.00
            ta_monto_gasto = 0.00
            ta_total_financiamiento = 0.00
            ta_monto_liquidado_banco = 0.00
            ta_monto_por_liquidar_banco = 0.00
            ta_monto_insumos_despachados = 0.00
            ta_monto_insumos_por_despachar = 0.00
            ta_monto_facturado = 0.00
            ta_monto_capital_recuperado = 0.00
            ta_monto_interes_recuperado = 0.00
            ta_monto_interes_mora_recuperado = 0.00
            
            fila += 1

            #Totales por Rubro
            
            sheet1[fila,10] = "Total #{rubro_anterior}"
            sheet1[fila,11] = tr_monto_banco
            sheet1[fila,12] = tr_monto_insumos
            sheet1[fila,13] = tr_monto_sras
            sheet1[fila,14] = tr_monto_gasto
            sheet1[fila,15] = tr_total_financiamiento
            sheet1[fila,16] = tr_monto_liquidado_banco
            sheet1[fila,17] = tr_monto_por_liquidar_banco
            sheet1[fila,18] = tr_monto_insumos_despachados
            sheet1[fila,19] = tr_monto_insumos_por_despachar
            sheet1[fila,20] = tr_monto_facturado
            sheet1[fila,21] = tr_monto_capital_recuperado
            sheet1[fila,23] = tr_monto_interes_recuperado
            sheet1[fila,24] = tr_monto_interes_mora_recuperado 
            format_bold = Spreadsheet::Format.new :color => :blue,
                                                  :weight => :bold,
                                                  :number_format => "#,##0.00_);[red](-0)",
                                                  :horizontal_align=>'right'
                                             
            sheet1.row(fila).default_format = format_bold
            rubro_anterior = v.rubro_nombre

            tr_monto_banco = 0.00
            tr_monto_insumos = 0.00
            tr_monto_sras = 0.00
            tr_monto_gasto = 0.00
            tr_total_financiamiento = 0.00
            tr_monto_liquidado_banco = 0.00
            tr_monto_por_liquidar_banco = 0.00
            tr_monto_insumos_despachados = 0.00
            tr_monto_insumos_por_despachar = 0.00
            tr_monto_facturado = 0.00
            tr_monto_capital_recuperado = 0.00
            tr_monto_interes_recuperado = 0.00
            tr_monto_interes_mora_recuperado = 0.00   
                    
            fila += 1
              
            #Totales por Sector
            
            sheet1[fila,10] = "Total #{sector_anterior}"
            sheet1[fila,11] = ts_monto_banco
            sheet1[fila,12] = ts_monto_insumos
            sheet1[fila,13] = ts_monto_sras
            sheet1[fila,14] = ts_monto_gasto
            sheet1[fila,15] = ts_total_financiamiento
            sheet1[fila,16] = ts_monto_liquidado_banco
            sheet1[fila,17] = ts_monto_por_liquidar_banco
            sheet1[fila,18] = ts_monto_insumos_despachados
            sheet1[fila,19] = ts_monto_insumos_por_despachar
            sheet1[fila,20] = ts_monto_facturado
            sheet1[fila,21] = ts_monto_capital_recuperado
            sheet1[fila,23] = ts_monto_interes_recuperado
            sheet1[fila,24] = ts_monto_interes_mora_recuperado
            format_bold = Spreadsheet::Format.new :color => :blue,
                                                  :weight => :bold,
                                                  :number_format => "#,##0.00_);[red](-0)",
                                                  :horizontal_align=>'right'
                                             
            sheet1.row(fila).default_format = format_bold
            sector_anterior = v.sector_nombre

            ts_monto_banco = 0.00
            ts_monto_insumos = 0.00
            ts_monto_sras = 0.00
            ts_monto_gasto = 0.00
            ts_total_financiamiento = 0.00
            ts_monto_liquidado_banco = 0.00
            ts_monto_por_liquidar_banco = 0.00
            ts_monto_insumos_despachados = 0.00
            ts_monto_insumos_por_despachar = 0.00
            ts_monto_facturado = 0.00
            ts_monto_capital_recuperado = 0.00
            ts_monto_interes_recuperado = 0.00
            ts_monto_interes_mora_recuperado = 0.00                     
            fila += 1
              
            #Totales por estado
            
            sheet1[fila,10] = "Total #{estado_anterior}"
            sheet1[fila,11] = te_monto_banco
            sheet1[fila,12] = te_monto_insumos
            sheet1[fila,13] = te_monto_sras
            sheet1[fila,14] = te_monto_gasto
            sheet1[fila,15] = te_total_financiamiento
            sheet1[fila,16] = te_monto_liquidado_banco
            sheet1[fila,17] = te_monto_por_liquidar_banco
            sheet1[fila,18] = te_monto_insumos_despachados
            sheet1[fila,19] = te_monto_insumos_por_despachar
            sheet1[fila,20] = te_monto_facturado
            sheet1[fila,21] = te_monto_capital_recuperado
            sheet1[fila,23] = te_monto_interes_recuperado
            sheet1[fila,24] = te_monto_interes_mora_recuperado            
            format_bold = Spreadsheet::Format.new :color => :blue,
                                                  :weight => :bold,
                                                  :number_format => "#,##0.00_);[red](-0)",
                                                  :horizontal_align=>'right'
                                             
            sheet1.row(fila).default_format = format_bold
            estado_anterior = v.estado_nombre
                        
            te_monto_banco = 0.00
            te_monto_insumos = 0.00
            te_monto_sras = 0.00
            te_monto_gasto = 0.00
            te_total_financiamiento = 0.00
            te_monto_liquidado_banco = 0.00
            te_monto_por_liquidar_banco = 0.00
            te_monto_insumos_despachados = 0.00
            te_monto_insumos_por_despachar = 0.00
            te_monto_facturado = 0.00
            te_monto_capital_recuperado = 0.00
            te_monto_interes_recuperado = 0.00
            te_monto_interes_mora_recuperado = 0.00          
                                                       
            #Totales por Programa
            
            fila += 1
              
            sheet1[fila,10] = "Total #{programa_anterior}"
            sheet1[fila,11] = tp_monto_banco
            sheet1[fila,12] = tp_monto_insumos
            sheet1[fila,13] = tp_monto_sras
            sheet1[fila,14] = tp_monto_gasto
            sheet1[fila,15] = tp_total_financiamiento
            sheet1[fila,16] = tp_monto_liquidado_banco
            sheet1[fila,17] = tp_monto_por_liquidar_banco
            sheet1[fila,18] = tp_monto_insumos_despachados
            sheet1[fila,19] = tp_monto_insumos_por_despachar
            sheet1[fila,20] = tp_monto_facturado
            sheet1[fila,21] = tp_monto_capital_recuperado
            sheet1[fila,23] = tp_monto_interes_recuperado
            sheet1[fila,24] = tp_monto_interes_mora_recuperado            
               
            sheet1.row(fila).default_format = format_bold
            
            fila += 2
            
            tp_monto_banco = 0.00
            tp_monto_insumos = 0.00
            tp_monto_sras = 0.00
            tp_monto_gasto = 0.00
            tp_total_financiamiento = 0.00
            tp_monto_liquidado_banco = 0.00
            tp_monto_por_liquidar_banco = 0.00
            tp_monto_insumos_despachados = 0.00
            tp_monto_insumos_por_despachar = 0.00
            tp_monto_facturado = 0.00
            tp_monto_capital_recuperado = 0.00
            
            programa_anterior = v.programa_nombre
          else
            programa_anterior = v.programa_nombre          
          end   # ---------> FIN if programa_anterior != ''
          
        end    # ----------> fin if programa_anterior != v.programa_nombre
        
        if estado_anterior != v.estado_nombre
          if estado_anterior != ''
          
            fila += 1
            
            #Totales por Actividad
            
            sheet1[fila,10] = "Total #{actividad_anterior}"
            sheet1[fila,11] = ta_monto_banco
            sheet1[fila,12] = ta_monto_insumos
            sheet1[fila,13] = ta_monto_sras
            sheet1[fila,14] = ta_monto_gasto
            sheet1[fila,15] = ta_total_financiamiento
            sheet1[fila,16] = ta_monto_liquidado_banco
            sheet1[fila,17] = ta_monto_por_liquidar_banco
            sheet1[fila,18] = ta_monto_insumos_despachados
            sheet1[fila,19] = ta_monto_insumos_por_despachar
            sheet1[fila,20] = ta_monto_facturado
            sheet1[fila,21] = ta_monto_capital_recuperado
            sheet1[fila,23] = ta_monto_interes_recuperado
            sheet1[fila,24] = ta_monto_interes_mora_recuperado 
            format_bold = Spreadsheet::Format.new :color => :blue,
                                                  :weight => :bold,
                                                  :number_format => "#,##0.00_);[red](-0)",
                                                  :horizontal_align=>'right'
                                             
            sheet1.row(fila).default_format = format_bold
            actividad_anterior = v.actividad_nombre

            ta_monto_banco = 0.00
            ta_monto_insumos = 0.00
            ta_monto_sras = 0.00
            ta_monto_gasto = 0.00
            ta_total_financiamiento = 0.00
            ta_monto_liquidado_banco = 0.00
            ta_monto_por_liquidar_banco = 0.00
            ta_monto_insumos_despachados = 0.00
            ta_monto_insumos_por_despachar = 0.00
            ta_monto_facturado = 0.00
            ta_monto_capital_recuperado = 0.00
            ta_monto_interes_recuperado = 0.00
            ta_monto_interes_mora_recuperado = 0.00
                        
            fila += 1

            #Totales por Rubro
            
            sheet1[fila,10] = "Total #{rubro_anterior}"
            sheet1[fila,11] = tr_monto_banco
            sheet1[fila,12] = tr_monto_insumos
            sheet1[fila,13] = tr_monto_sras
            sheet1[fila,14] = tr_monto_gasto
            sheet1[fila,15] = tr_total_financiamiento
            sheet1[fila,16] = tr_monto_liquidado_banco
            sheet1[fila,17] = tr_monto_por_liquidar_banco
            sheet1[fila,18] = tr_monto_insumos_despachados
            sheet1[fila,19] = tr_monto_insumos_por_despachar
            sheet1[fila,20] = tr_monto_facturado
            sheet1[fila,21] = tr_monto_capital_recuperado
            sheet1[fila,23] = tr_monto_interes_recuperado
            sheet1[fila,24] = tr_monto_interes_mora_recuperado 
            format_bold = Spreadsheet::Format.new :color => :blue,
                                                  :weight => :bold,
                                                  :number_format => "#,##0.00_);[red](-0)",
                                                  :horizontal_align=>'right'
                                             
            sheet1.row(fila).default_format = format_bold
            rubro_anterior = v.rubro_nombre

            tr_monto_banco = 0.00
            tr_monto_insumos = 0.00
            tr_monto_sras = 0.00
            tr_monto_gasto = 0.00
            tr_total_financiamiento = 0.00
            tr_monto_liquidado_banco = 0.00
            tr_monto_por_liquidar_banco = 0.00
            tr_monto_insumos_despachados = 0.00
            tr_monto_insumos_por_despachar = 0.00
            tr_monto_facturado = 0.00
            tr_monto_capital_recuperado = 0.00
            tr_monto_interes_recuperado = 0.00
            tr_monto_interes_mora_recuperado = 0.00
            fila += 1
            
            #Totales por sector
            
            sheet1[fila,10] = "Total #{sector_anterior}"
            sheet1[fila,11] = ts_monto_banco
            sheet1[fila,12] = ts_monto_insumos
            sheet1[fila,13] = ts_monto_sras
            sheet1[fila,14] = ts_monto_gasto
            sheet1[fila,15] = ts_total_financiamiento
            sheet1[fila,16] = ts_monto_liquidado_banco
            sheet1[fila,17] = ts_monto_por_liquidar_banco
            sheet1[fila,18] = ts_monto_insumos_despachados
            sheet1[fila,19] = ts_monto_insumos_por_despachar
            sheet1[fila,20] = ts_monto_facturado
            sheet1[fila,21] = ts_monto_capital_recuperado
            sheet1[fila,23] = ts_monto_interes_recuperado
            sheet1[fila,24] = ts_monto_interes_mora_recuperado             
            format_bold = Spreadsheet::Format.new :color => :blue,
                                                  :weight => :bold,
                                                  :number_format => "#,##0.00_);[red](-0)",
                                                  :horizontal_align=>'right'
                                             
            sheet1.row(fila).default_format = format_bold 
            sector_anterior = v.sector_nombre
                                   
            ts_monto_banco = 0.00
            ts_monto_insumos = 0.00
            ts_monto_sras = 0.00
            ts_monto_gasto = 0.00
            ts_total_financiamiento = 0.00
            ts_monto_liquidado_banco = 0.00
            ts_monto_por_liquidar_banco = 0.00
            ts_monto_insumos_despachados = 0.00
            ts_monto_insumos_por_despachar = 0.00
            ts_monto_facturado = 0.00
            ts_monto_capital_recuperado = 0.00
            ts_monto_interes_recuperado = 0.00
            ts_monto_interes_mora_recuperado = 0.00
                       
            fila += 1
            
            #Totales por estado
            
            sheet1[fila,10] = "Total #{estado_anterior}"
            sheet1[fila,11] = te_monto_banco
            sheet1[fila,12] = te_monto_insumos
            sheet1[fila,13] = te_monto_sras
            sheet1[fila,14] = te_monto_gasto
            sheet1[fila,15] = te_total_financiamiento
            sheet1[fila,16] = te_monto_liquidado_banco
            sheet1[fila,17] = te_monto_por_liquidar_banco
            sheet1[fila,18] = te_monto_insumos_despachados
            sheet1[fila,19] = te_monto_insumos_por_despachar
            sheet1[fila,20] = te_monto_facturado
            sheet1[fila,21] = te_monto_capital_recuperado
            sheet1[fila,23] = te_monto_interes_recuperado
            sheet1[fila,24] = te_monto_interes_mora_recuperado
                        
            format_bold = Spreadsheet::Format.new :color => :blue,
                                                  :weight => :bold,
                                                  :number_format => "#,##0.00_);[red](-0)",
                                                  :horizontal_align=>'right'
                                             
            sheet1.row(fila).default_format = format_bold 
                       
            te_monto_banco = 0.00
            te_monto_insumos = 0.00
            te_monto_sras = 0.00
            te_monto_gasto = 0.00
            te_total_financiamiento = 0.00
            te_monto_liquidado_banco = 0.00
            te_monto_por_liquidar_banco = 0.00
            te_monto_insumos_despachados = 0.00
            te_monto_insumos_por_despachar = 0.00
            te_monto_facturado = 0.00
            te_monto_capital_recuperado = 0.00
            te_monto_interes_recuperado = 0.00
            te_monto_interes_mora_recuperado = 0.00
                     
            fila += 2
            estado_anterior = v.estado_nombre
          else
            estado_anterior = v.estado_nombre          
          end     # -----------> Fin if estado_anterior != ''
          
        end       # -----------> Fin if estado_anterior != v.estado_nombre

        if sector_anterior != v.sector_nombre
          if sector_anterior != ''

            fila += 1
            
            #Totales por Actividad
            
            sheet1[fila,10] = "Total #{actividad_anterior}"
            sheet1[fila,11] = ta_monto_banco
            sheet1[fila,12] = ta_monto_insumos
            sheet1[fila,13] = ta_monto_sras
            sheet1[fila,14] = ta_monto_gasto
            sheet1[fila,15] = ta_total_financiamiento
            sheet1[fila,16] = ta_monto_liquidado_banco
            sheet1[fila,17] = ta_monto_por_liquidar_banco
            sheet1[fila,18] = ta_monto_insumos_despachados
            sheet1[fila,19] = ta_monto_insumos_por_despachar
            sheet1[fila,20] = ta_monto_facturado
            sheet1[fila,21] = ta_monto_capital_recuperado
            sheet1[fila,23] = ta_monto_interes_recuperado
            sheet1[fila,24] = ta_monto_interes_mora_recuperado
            
            format_bold = Spreadsheet::Format.new :color => :blue,
                                                  :weight => :bold,
                                                  :number_format => "#,##0.00_);[red](-0)",
                                                  :horizontal_align=>'right'
                                             
            sheet1.row(fila).default_format = format_bold
            actividad_anterior = v.actividad_nombre

            ta_monto_banco = 0.00
            ta_monto_insumos = 0.00
            ta_monto_sras = 0.00
            ta_monto_gasto = 0.00
            ta_total_financiamiento = 0.00
            ta_monto_liquidado_banco = 0.00
            ta_monto_por_liquidar_banco = 0.00
            ta_monto_insumos_despachados = 0.00
            ta_monto_insumos_por_despachar = 0.00
            ta_monto_facturado = 0.00
            ta_monto_capital_recuperado = 0.00
            ta_monto_interes_recuperado = 0.00
            ta_monto_interes_mora_recuperado = 0.00
            
            fila += 1

            #Totales por Rubro
            
            sheet1[fila,10] = "Total #{rubro_anterior}"
            sheet1[fila,11] = tr_monto_banco
            sheet1[fila,12] = tr_monto_insumos
            sheet1[fila,13] = tr_monto_sras
            sheet1[fila,14] = tr_monto_gasto
            sheet1[fila,15] = tr_total_financiamiento
            sheet1[fila,16] = tr_monto_liquidado_banco
            sheet1[fila,17] = tr_monto_por_liquidar_banco
            sheet1[fila,18] = tr_monto_insumos_despachados
            sheet1[fila,19] = tr_monto_insumos_por_despachar
            sheet1[fila,20] = tr_monto_facturado
            sheet1[fila,21] = tr_monto_capital_recuperado
            sheet1[fila,23] = tr_monto_interes_recuperado
            sheet1[fila,24] = tr_monto_interes_mora_recuperado
            
            format_bold = Spreadsheet::Format.new :color => :blue,
                                                  :weight => :bold,
                                                  :number_format => "#,##0.00_);[red](-0)",
                                                  :horizontal_align=>'right'
                                             
            sheet1.row(fila).default_format = format_bold
            rubro_anterior = v.rubro_nombre

            tr_monto_banco = 0.00
            tr_monto_insumos = 0.00
            tr_monto_sras = 0.00
            tr_monto_gasto = 0.00
            tr_total_financiamiento = 0.00
            tr_monto_liquidado_banco = 0.00
            tr_monto_por_liquidar_banco = 0.00
            tr_monto_insumos_despachados = 0.00
            tr_monto_insumos_por_despachar = 0.00
            tr_monto_facturado = 0.00
            tr_monto_capital_recuperado = 0.00
            tr_monto_interes_recuperado = 0.00
            tr_monto_interes_mora_recuperado = 0.00
          
            fila += 1
            
            #Totales por Sector
            
            sheet1[fila,10] = "Total #{sector_anterior}"
            sheet1[fila,11] = ts_monto_banco
            sheet1[fila,12] = ts_monto_insumos
            sheet1[fila,13] = ts_monto_sras
            sheet1[fila,14] = ts_monto_gasto
            sheet1[fila,15] = ts_total_financiamiento
            sheet1[fila,16] = ts_monto_liquidado_banco
            sheet1[fila,17] = ts_monto_por_liquidar_banco
            sheet1[fila,18] = ts_monto_insumos_despachados
            sheet1[fila,19] = ts_monto_insumos_por_despachar
            sheet1[fila,20] = ts_monto_facturado
            sheet1[fila,21] = ts_monto_capital_recuperado
            sheet1[fila,23] = ts_monto_interes_recuperado
            sheet1[fila,24] = ts_monto_interes_mora_recuperado
            
            format_bold = Spreadsheet::Format.new :color => :blue,
                                                  :weight => :bold,
                                                  :number_format => "#,##0.00_);[red](-0)",
                                                  :horizontal_align=>'right'
                                             
            sheet1.row(fila).default_format = format_bold 
                       
            ts_monto_banco = 0.00
            ts_monto_insumos = 0.00
            ts_monto_sras = 0.00
            ts_monto_gasto = 0.00
            ts_total_financiamiento = 0.00
            ts_monto_liquidado_banco = 0.00
            ts_monto_por_liquidar_banco = 0.00
            ts_monto_insumos_despachados = 0.00
            ts_monto_insumos_por_despachar = 0.00
            ts_monto_facturado = 0.00
            ts_monto_capital_recuperado = 0.00
            ts_monto_interes_recuperado = 0.00
            ts_monto_interes_mora_recuperado = 0.00
                     
            fila += 2
            sector_anterior = v.sector_nombre
          else
            sector_anterior = v.sector_nombre          
          end     # -----------> Fin if sector_anterior != ''
          
        end       # -----------> Fin if sector_anterior != v.sector_nombre
        
        if rubro_anterior != v.rubro_nombre
          if rubro_anterior != ''
          
            fila += 1
            
            #Totales por Actividad
            
            sheet1[fila,10] = "Total #{actividad_anterior}"
            sheet1[fila,11] = ta_monto_banco
            sheet1[fila,12] = ta_monto_insumos
            sheet1[fila,13] = ta_monto_sras
            sheet1[fila,14] = ta_monto_gasto
            sheet1[fila,15] = ta_total_financiamiento
            sheet1[fila,16] = ta_monto_liquidado_banco
            sheet1[fila,17] = ta_monto_por_liquidar_banco
            sheet1[fila,18] = ta_monto_insumos_despachados
            sheet1[fila,19] = ta_monto_insumos_por_despachar
            sheet1[fila,20] = ta_monto_facturado
            sheet1[fila,21] = ta_monto_capital_recuperado
            sheet1[fila,23] = ta_monto_interes_recuperado
            sheet1[fila,24] = ta_monto_interes_mora_recuperado
            
            format_bold = Spreadsheet::Format.new :color => :blue,
                                                  :weight => :bold,
                                                  :number_format => "#,##0.00_);[red](-0)",
                                                  :horizontal_align=>'right'
                                             
            sheet1.row(fila).default_format = format_bold
            actividad_anterior = v.actividad_nombre

            ta_monto_banco = 0.00
            ta_monto_insumos = 0.00
            ta_monto_sras = 0.00
            ta_monto_gasto = 0.00
            ta_total_financiamiento = 0.00
            ta_monto_liquidado_banco = 0.00
            ta_monto_por_liquidar_banco = 0.00
            ta_monto_insumos_despachados = 0.00
            ta_monto_insumos_por_despachar = 0.00
            ta_monto_facturado = 0.00
            ta_monto_capital_recuperado = 0.00
            ta_monto_interes_recuperado = 0.00
            ta_monto_interes_mora_recuperado = 0.00
            
            fila += 1

            #Totales por Rubro
            
            sheet1[fila,10] = "Total #{rubro_anterior}"
            sheet1[fila,11] = tr_monto_banco
            sheet1[fila,12] = tr_monto_insumos
            sheet1[fila,13] = tr_monto_sras
            sheet1[fila,14] = tr_monto_gasto
            sheet1[fila,15] = tr_total_financiamiento
            sheet1[fila,16] = tr_monto_liquidado_banco
            sheet1[fila,17] = tr_monto_por_liquidar_banco
            sheet1[fila,18] = tr_monto_insumos_despachados
            sheet1[fila,19] = tr_monto_insumos_por_despachar
            sheet1[fila,20] = tr_monto_facturado
            sheet1[fila,21] = tr_monto_capital_recuperado
            sheet1[fila,23] = tr_monto_interes_recuperado
            sheet1[fila,24] = tr_monto_interes_mora_recuperado
            
            format_bold = Spreadsheet::Format.new :color => :blue,
                                                  :weight => :bold,
                                                  :number_format => "#,##0.00_);[red](-0)",
                                                  :horizontal_align=>'right'
                                             
            sheet1.row(fila).default_format = format_bold
            rubro_anterior = v.rubro_nombre

            tr_monto_banco = 0.00
            tr_monto_insumos = 0.00
            tr_monto_sras = 0.00
            tr_monto_gasto = 0.00
            tr_total_financiamiento = 0.00
            tr_monto_liquidado_banco = 0.00
            tr_monto_por_liquidar_banco = 0.00
            tr_monto_insumos_despachados = 0.00
            tr_monto_insumos_por_despachar = 0.00
            tr_monto_facturado = 0.00
            tr_monto_capital_recuperado = 0.00
            tr_monto_interes_recuperado
            tr_monto_interes_mora_recuperado
          
            fila += 2
            
         else
            rubro_anterior = v.rubro_nombre          
         end     # -----------> Fin if rubro_anterior != ''
          
        end       # -----------> Fin if rubro_anterior != v.rubro_nombre

        if actividad_anterior != v.actividad_nombre
          if actividad_anterior != ''
          
            fila += 1
            
            #Totales por Actividad
            
            sheet1[fila,10] = "Total #{actividad_anterior}"
            sheet1[fila,11] = ta_monto_banco
            sheet1[fila,12] = ta_monto_insumos
            sheet1[fila,13] = ta_monto_sras
            sheet1[fila,14] = ta_monto_gasto
            sheet1[fila,15] = ta_total_financiamiento
            sheet1[fila,16] = ta_monto_liquidado_banco
            sheet1[fila,17] = ta_monto_por_liquidar_banco
            sheet1[fila,18] = ta_monto_insumos_despachados
            sheet1[fila,19] = ta_monto_insumos_por_despachar
            sheet1[fila,20] = ta_monto_facturado
            sheet1[fila,21] = ta_monto_capital_recuperado
            sheet1[fila,23] = ta_monto_interes_recuperado
            sheet1[fila,24] = ta_monto_interes_mora_recuperado
            
            format_bold = Spreadsheet::Format.new :color => :blue,
                                                  :weight => :bold,
                                                  :number_format => "#,##0.00_);[red](-0)",
                                                  :horizontal_align=>'right'
                                             
            sheet1.row(fila).default_format = format_bold
            actividad_anterior = v.actividad_nombre

            ta_monto_banco = 0.00
            ta_monto_insumos = 0.00
            ta_monto_sras = 0.00
            ta_monto_gasto = 0.00
            ta_total_financiamiento = 0.00
            ta_monto_liquidado_banco = 0.00
            ta_monto_por_liquidar_banco = 0.00
            ta_monto_insumos_despachados = 0.00
            ta_monto_insumos_por_despachar = 0.00
            ta_monto_facturado = 0.00
            ta_monto_capital_recuperado = 0.00
            ta_monto_interes_recuperado = 0.00
            ta_monto_interes_mora_recuperado = 0.00
            
            fila += 2
           
         else
            actividad_anterior = v.actividad_nombre          
         end     # -----------> Fin if actividad_anterior != ''
          
        end       # -----------> Fin if actividad_anterior != v.actividad_nombre

        if v.por_inventario
          monto_por_liquidar = (v.monto_inventario + v.monto_gasto_total + v.monto_sras_total) - v.monto_liquidado_banco
        else
          unless v.monto_banco.nil? || v.monto_liquidado_banco.nil?
            if v.monto_banco == 0
              monto_por_liquidar = 0
            else
              monto_por_liquidar = v.monto_banco - v.monto_liquidado_banco
            end
          end
        end
              
        #porcentaje_recuperacion = (v.capital_recuperado / v.total_financiamiento) * 100
        sheet1.row(fila).push v.nombre_beneficiario, v.documento_beneficiario, v.numero_tramite, v.numero_financiamiento,
                              v.programa_nombre, v.estado_nombre, v.sector_nombre, v.sub_sector_nombre, v.rubro_nombre, 
                              v.sub_rubro_nombre, v.actividad_nombre, v.monto_banco, v.monto_insumos, v.monto_sras_total,
                              v.monto_gasto_total, v.total_financiamiento, v.monto_liquidado_banco, monto_por_liquidar,
                              v.monto_despachado_insumos, v.monto_por_despachar_insumos,
                              v.monto_facturado, v.capital_recuperado, v.porcentaje_capital_recuperado, v.interes_recuperado,
                              v.interes_mora_recuperado
                                
                            
        tp_monto_banco += v.monto_banco
        tp_monto_insumos += v.monto_insumos
        tp_monto_sras += v.monto_sras_total
        tp_monto_gasto += v.monto_gasto_total
        tp_total_financiamiento += v.total_financiamiento
        tp_monto_liquidado_banco += v.monto_liquidado_banco
        tp_monto_por_liquidar_banco += monto_por_liquidar
        tp_monto_insumos_despachados += v.monto_despachado_insumos
        tp_monto_insumos_por_despachar += v.monto_por_despachar_insumos
        tp_monto_facturado +=  v.monto_facturado
        tp_monto_capital_recuperado += v.capital_recuperado
        tp_monto_interes_recuperado += v.interes_recuperado
        tp_monto_interes_mora_recuperado += v.interes_mora_recuperado
        
        te_monto_banco += v.monto_banco
        te_monto_insumos += v.monto_insumos
        te_monto_sras += v.monto_sras_total
        te_monto_gasto += v.monto_gasto_total
        te_total_financiamiento += v.total_financiamiento
        te_monto_liquidado_banco += v.monto_liquidado_banco
        te_monto_por_liquidar_banco += monto_por_liquidar
        te_monto_insumos_despachados += v.monto_despachado_insumos
        te_monto_insumos_por_despachar += v.monto_por_despachar_insumos
        te_monto_facturado +=  v.monto_facturado
        te_monto_capital_recuperado += v.capital_recuperado
        te_monto_interes_recuperado += v.interes_recuperado
        te_monto_interes_mora_recuperado += v.interes_mora_recuperado
         
        ts_monto_banco += v.monto_banco
        ts_monto_insumos += v.monto_insumos
        ts_monto_sras += v.monto_sras_total
        ts_monto_gasto += v.monto_gasto_total
        ts_total_financiamiento += v.total_financiamiento
        ts_monto_liquidado_banco += v.monto_liquidado_banco
        ts_monto_por_liquidar_banco += monto_por_liquidar
        ts_monto_insumos_despachados += v.monto_despachado_insumos
        ts_monto_insumos_por_despachar += v.monto_por_despachar_insumos
        ts_monto_facturado +=  v.monto_facturado
        ts_monto_capital_recuperado += v.capital_recuperado
        ts_monto_interes_recuperado += v.interes_recuperado
        ts_monto_interes_mora_recuperado += v.interes_mora_recuperado

        ta_monto_banco += v.monto_banco
        ta_monto_insumos += v.monto_insumos
        ta_monto_sras += v.monto_sras_total
        ta_monto_gasto += v.monto_gasto_total
        ta_total_financiamiento += v.total_financiamiento
        ta_monto_liquidado_banco += v.monto_liquidado_banco
        ta_monto_por_liquidar_banco += monto_por_liquidar
        ta_monto_insumos_despachados += v.monto_despachado_insumos
        ta_monto_insumos_por_despachar += v.monto_por_despachar_insumos
        ta_monto_facturado +=  v.monto_facturado
        ta_monto_capital_recuperado += v.capital_recuperado
        ta_monto_interes_recuperado += v.interes_recuperado
        ta_monto_interes_mora_recuperado += v.interes_mora_recuperado

        tr_monto_banco += v.monto_banco
        tr_monto_insumos += v.monto_insumos
        tr_monto_sras += v.monto_sras_total
        tr_monto_gasto += v.monto_gasto_total
        tr_total_financiamiento += v.total_financiamiento
        tr_monto_liquidado_banco += v.monto_liquidado_banco
        tr_monto_por_liquidar_banco += monto_por_liquidar
        tr_monto_insumos_despachados += v.monto_despachado_insumos
        tr_monto_insumos_por_despachar += v.monto_por_despachar_insumos
        tr_monto_facturado +=  v.monto_facturado
        tr_monto_capital_recuperado += v.capital_recuperado
        tr_monto_interes_recuperado += v.interes_recuperado
        tr_monto_interes_mora_recuperado += v.interes_mora_recuperado
          
        fila += 1
        #logger.info "linea =====> #{v.inspect}"
      end

      # Grabación totales finales
      
      fila += 1
        
      #Totales por Actividad
      
      sheet1[fila,10] = "Total #{actividad_anterior}"
      sheet1[fila,11] = ta_monto_banco
      sheet1[fila,12] = ta_monto_insumos
      sheet1[fila,13] = ta_monto_sras
      sheet1[fila,14] = ta_monto_gasto
      sheet1[fila,15] = ta_total_financiamiento
      sheet1[fila,16] = ta_monto_liquidado_banco
      sheet1[fila,17] = ta_monto_por_liquidar_banco
      sheet1[fila,18] = ta_monto_insumos_despachados
      sheet1[fila,19] = ta_monto_insumos_por_despachar
      sheet1[fila,20] = ta_monto_facturado
      sheet1[fila,21] = ta_monto_capital_recuperado
      sheet1[fila,23] = ta_monto_interes_recuperado
      sheet1[fila,24] = ta_monto_interes_mora_recuperado
      
      format_bold = Spreadsheet::Format.new :color => :blue,
                                            :weight => :bold,
                                            :number_format => "#,##0.00_);[red](-0)",
                                            :horizontal_align=>'right'
                                       
      sheet1.row(fila).default_format = format_bold

      ta_monto_banco = 0.00
      ta_monto_insumos = 0.00
      ta_monto_sras = 0.00
      ta_monto_gasto = 0.00
      ta_total_financiamiento = 0.00
      ta_monto_liquidado_banco = 0.00
      ta_monto_por_liquidar_banco = 0.00
      ta_monto_insumos_despachados = 0.00
      ta_monto_insumos_por_despachar = 0.00
      ta_monto_facturado = 0.00
      ta_monto_capital_recuperado = 0.00
      ta_monto_interes_recuperado = 0.00
      ta_monto_interes_mora_recuperado = 0.00
      
      fila += 1

      #Totales por Rubro
      
      sheet1[fila,10] = "Total #{rubro_anterior}"
      sheet1[fila,11] = tr_monto_banco
      sheet1[fila,12] = tr_monto_insumos
      sheet1[fila,13] = tr_monto_sras
      sheet1[fila,14] = tr_monto_gasto
      sheet1[fila,15] = tr_total_financiamiento
      sheet1[fila,16] = tr_monto_liquidado_banco
      sheet1[fila,17] = tr_monto_por_liquidar_banco
      sheet1[fila,18] = tr_monto_insumos_despachados
      sheet1[fila,19] = tr_monto_insumos_por_despachar
      sheet1[fila,20] = tr_monto_facturado
      sheet1[fila,21] = tr_monto_capital_recuperado
      sheet1[fila,23] = tr_monto_interes_recuperado
      sheet1[fila,24] = tr_monto_interes_mora_recuperado

      format_bold = Spreadsheet::Format.new :color => :blue,
                                            :weight => :bold,
                                            :number_format => "#,##0.00_);[red](-0)",
                                            :horizontal_align=>'right'
                                       
      sheet1.row(fila).default_format = format_bold

      tr_monto_banco = 0.00
      tr_monto_insumos = 0.00
      tr_monto_sras = 0.00
      tr_monto_gasto = 0.00
      tr_total_financiamiento = 0.00
      tr_monto_liquidado_banco = 0.00
      tr_monto_por_liquidar_banco = 0.00
      tr_monto_insumos_despachados = 0.00
      tr_monto_insumos_por_despachar = 0.00
      tr_monto_facturado = 0.00
      tr_monto_capital_recuperado = 0.00
      tr_monto_interes_recuperado = 0.00
      tr_monto_interes_mora_recuperado = 0.00
      
      fila += 1
        
      #Totales por Sector
      
      sheet1[fila,10] = "Total #{sector_anterior}"
      sheet1[fila,11] = ts_monto_banco
      sheet1[fila,12] = ts_monto_insumos
      sheet1[fila,13] = ts_monto_sras
      sheet1[fila,14] = ts_monto_gasto
      sheet1[fila,15] = ts_total_financiamiento
      sheet1[fila,16] = ts_monto_liquidado_banco
      sheet1[fila,17] = ts_monto_por_liquidar_banco
      sheet1[fila,18] = ts_monto_insumos_despachados
      sheet1[fila,19] = ts_monto_insumos_por_despachar
      sheet1[fila,20] = ts_monto_facturado
      sheet1[fila,21] = ts_monto_capital_recuperado
      sheet1[fila,23] = ts_monto_interes_recuperado
      sheet1[fila,24] = ts_monto_interes_mora_recuperado

      format_bold = Spreadsheet::Format.new :color => :blue,
                                            :weight => :bold,
                                            :number_format => "#,##0.00_);[red](-0)",
                                            :horizontal_align=>'right'
                                       
      sheet1.row(fila).default_format = format_bold

      ts_monto_banco = 0.00
      ts_monto_insumos = 0.00
      ts_monto_sras = 0.00
      ts_monto_gasto = 0.00
      ts_total_financiamiento = 0.00
      ts_monto_liquidado_banco = 0.00
      ts_monto_por_liquidar_banco = 0.00
      ts_monto_insumos_despachados = 0.00
      ts_monto_insumos_por_despachar = 0.00
      ts_monto_facturado = 0.00
      ts_monto_capital_recuperado = 0.00
      ts_monto_interes_recuperado = 0.00
      ts_monto_interes_mora_recuperado = 0.00
                  
      fila += 1
        
      #Totales por estado
      
      sheet1[fila,10] = "Total #{estado_anterior}"
      sheet1[fila,11] = te_monto_banco
      sheet1[fila,12] = te_monto_insumos
      sheet1[fila,13] = te_monto_sras
      sheet1[fila,14] = te_monto_gasto
      sheet1[fila,15] = te_total_financiamiento
      sheet1[fila,16] = te_monto_liquidado_banco
      sheet1[fila,17] = te_monto_por_liquidar_banco
      sheet1[fila,18] = te_monto_insumos_despachados
      sheet1[fila,19] = te_monto_insumos_por_despachar
      sheet1[fila,20] = te_monto_facturado
      sheet1[fila,21] = te_monto_capital_recuperado
      sheet1[fila,23] = te_monto_interes_recuperado
      sheet1[fila,24] = te_monto_interes_mora_recuperado
      
      format_bold = Spreadsheet::Format.new :color => :blue,
                                            :weight => :bold,
                                            :number_format => "#,##0.00_);[red](-0)",
                                            :horizontal_align=>'right'
                                       
      sheet1.row(fila).default_format = format_bold
                  
      te_monto_banco = 0.00
      te_monto_insumos = 0.00
      te_monto_sras = 0.00
      te_monto_gasto = 0.00
      te_total_financiamiento = 0.00
      te_monto_liquidado_banco = 0.00
      te_monto_por_liquidar_banco = 0.00
      te_monto_insumos_despachados = 0.00
      te_monto_insumos_por_despachar = 0.00
      te_monto_facturado = 0.00
      te_monto_capital_recuperado = 0.00
      te_monto_interes_recuperado = 0.00
      te_monto_interes_mora_recuperado = 0.00
                                                 
      #Totales por Programa
      
      fila += 1
        
      sheet1[fila,10] = "Total #{programa_anterior}"
      sheet1[fila,11] = tp_monto_banco
      sheet1[fila,12] = tp_monto_insumos
      sheet1[fila,13] = tp_monto_sras
      sheet1[fila,14] = tp_monto_gasto
      sheet1[fila,15] = tp_total_financiamiento
      sheet1[fila,16] = tp_monto_liquidado_banco
      sheet1[fila,17] = tp_monto_por_liquidar_banco
      sheet1[fila,18] = tp_monto_insumos_despachados
      sheet1[fila,19] = tp_monto_insumos_por_despachar
      sheet1[fila,20] = tp_monto_facturado
      sheet1[fila,21] = tp_monto_capital_recuperado
      sheet1[fila,23] = tp_monto_interes_recuperado
      sheet1[fila,24] = tp_monto_interes_mora_recuperado
         
      sheet1.row(fila).default_format = format_bold
      
      fila += 2
      
      tp_monto_banco = 0.00
      tp_monto_insumos = 0.00
      tp_monto_sras = 0.00
      tp_monto_gasto = 0.00
      tp_total_financiamiento = 0.00
      tp_monto_liquidado_banco = 0.00
      tp_monto_por_liquidar_banco = 0.00
      tp_monto_insumos_despachados = 0.00
      tp_monto_insumos_por_despachar = 0.00
      tp_monto_facturado = 0.00
      tp_monto_capital_recuperado = 0.00
      tp_monto_interes_recuperado = 0.00
      tp_monto_interes_mora_recuperado = 0.00

      workbook.write nombre_archivo
      logger.info "archivo =====> #{nombre_archivo}"

    end     # ---------------> Fin vista.each do |v|
    
    return nombre_archivo  
  end
end

# == Schema Information
#
# Table name: view_financiado_recuperado
#
#  numero_tramite                :integer
#  numero_financiamiento         :integer(8)
#  nombre_beneficiario           :string
#  documento_beneficiario        :string
#  estado_nombre                 :string(40)
#  estado_id                     :integer
#  sector_id                     :integer
#  sector_nombre                 :string(100)
#  sub_sector_id                 :integer
#  sub_sector_nombre             :string(100)
#  rubro_id                      :integer
#  rubro_nombre                  :string(100)
#  sub_rubro_id                  :integer
#  sub_rubro_nombre              :string(100)
#  actividad_id                  :integer
#  actividad_nombre              :string(150)
#  programa_id                   :integer
#  programa_nombre               :string(255)
#  fecha_liquidacion             :date
#  fecha_vencimiento             :date
#  fecha_aprobacion              :date
#  monto_aprobado                :float
#  monto_banco                   :decimal(16, 2)
#  monto_insumos                 :decimal(16, 2)
#  monto_liquidado_banco         :decimal(16, 2)
#  monto_por_liquidar_banco      :decimal(, )
#  monto_despachado_insumos      :decimal(16, 2)
#  monto_por_despachar_insumos   :decimal(, )
#  monto_facturado               :decimal(16, 2)
#  monto_inventario              :decimal(16, 2)
#  estatus_financiamiento        :string(1)
#  monto_sras_total              :decimal(16, 2)
#  monto_gasto_total             :decimal(16, 2)
#  total_financiamiento          :decimal(, )
#  cantidad_cuotas_vencidas      :integer(2)
#  capital_vencido               :decimal(16, 2)
#  interes_vencido               :decimal(16, 2)
#  monto_mora                    :decimal(, )
#  saldo_deudor                  :decimal(16, 2)
#  monto_exigible                :decimal(, )
#  deuda_total                   :decimal(, )
#  capital_recuperado            :decimal(14, 2)
#  porcentaje_capital_recuperado :decimal(, )
#  interes_recuperado            :decimal(16, 2)
#  interes_mora_recuperado       :decimal(16, 2)
#  excedente_por_pagar           :decimal(16, 2)
#  excedente_pagado              :decimal(, )
#  por_inventario                :boolean
#

