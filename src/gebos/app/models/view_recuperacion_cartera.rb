# encoding: utf-8

require 'rubygems'
require 'spreadsheet'

class ViewRecuperacionCartera < ActiveRecord::Base

  self.table_name = 'view_recuperacion_cartera'

  public
  
  
  def ViewRecuperacionCartera.exportar_excel(conditions,file_name,fecha_inicio, fecha_fin)
  
  
    sql = "SELECT numero_tramite, numero_financiamiento, nombre_beneficiario, "
    sql += "documento_beneficiario, programa_nombre, estado_nombre, sector_nombre, sub_sector_nombre, "
    sql += "rubro_nombre, sub_rubro_nombre, actividad_nombre, fecha_liquidacion, "
    sql += "fecha_vencimiento, monto_aprobado, monto_banco, monto_insumos, "
    sql += "monto_liquidado_banco, monto_por_liquidar_banco, monto_despachado_insumos, "
    sql += "monto_por_despachar_insumos, estatus_financiamiento, cantidad_cuotas_vencidas, "
    sql += "capital_vencido, interes_vencido, monto_mora, saldo_deudor, monto_exigible, "
    sql += "deuda_total, capital_recuperado, interes_recuperado, interes_mora_pagada, excedente_por_pagar, excedente_pagado, "
    sql += "sum(capital_recuperar) as capital_recuperar, sum(interes_recuperar) as interes_recuperar,"
    sql += " monto_inventario, por_inventario, monto_sras_total, monto_gastos_total"
    sql += " from view_recuperacion_cartera"
    sql += " where #{conditions}"
    
    sql += "group by "
    sql += "numero_tramite, numero_financiamiento, nombre_beneficiario, documento_beneficiario, " 
    sql += "programa_nombre, estado_nombre, sector_nombre, sub_sector_nombre, rubro_nombre, "
    sql += "sub_rubro_nombre, actividad_nombre, fecha_liquidacion, fecha_vencimiento, "
    sql += "monto_aprobado, monto_banco, monto_insumos, monto_liquidado_banco, "
    sql += "monto_por_liquidar_banco, monto_despachado_insumos, monto_por_despachar_insumos, "
    sql += "estatus_financiamiento, cantidad_cuotas_vencidas, capital_vencido, " 
    sql += "interes_vencido, monto_mora, saldo_deudor, monto_exigible, deuda_total, "
    sql += "capital_recuperado, interes_recuperado, interes_mora_pagada, excedente_por_pagar, excedente_pagado, "
    sql += " monto_inventario, por_inventario, monto_sras_total, monto_gastos_total"
    sql += " order by programa_nombre, estado_nombre, sector_nombre, sub_sector_nombre, rubro_nombre, sub_rubro_nombre, actividad_nombre"
    
    nombre_archivo = ''
    monto_por_liquidar = 0.00

    logger.info "SQL ===============> #{sql}"
    vista = ViewRecuperacionCartera.find_by_sql(sql)
    
    if vista.count > 0
    
      Spreadsheet.client_encoding = 'UTF-8'
      fecha = Time.now.strftime('%d_%m_%Y')
      nombre_archivo = "#{Rails.root}/public/documentos/xls/#{file_name}"

      workbook = Spreadsheet::Workbook.new
      logger.info "Workbook ===> workbook.inspect"
      sheet1 = workbook.create_worksheet :name => "Proyección Recuperación Cartera"
      
      format = Spreadsheet::Format.new(:number_format => "#,##0.00_);[red](-0)",:horizontal_align=>'right')
      format_text = Spreadsheet::Format.new(:horizontal_align=>'center')
      #puts sheet1.name
      
      sheet1.format_column(0,format_text).width=15
      sheet1.format_column(1,format_text).width=20
      sheet1.format_column(2,format_text).width=50
      sheet1.format_column(3,format_text).width=15
      sheet1.format_column(4,format_text).width=60
      sheet1.format_column(5,format_text).width=20
      sheet1.format_column(6,format_text).width=30
      sheet1.format_column(7,format_text).width=30
      sheet1.format_column(8,format_text).width=30
      sheet1.format_column(9,format_text).width=30
      sheet1.format_column(10,format_text).width=30
      sheet1.format_column(11,format_text).width=20
      sheet1.format_column(12,format_text).width=20
      sheet1.format_column(13,format).width=50
      sheet1.format_column(14,format).width=50
      sheet1.format_column(15,format).width=50
      sheet1.format_column(16,format).width=50
      sheet1.format_column(17,format).width=50
      sheet1.format_column(18,format).width=50
      sheet1.format_column(19,format).width=50
      sheet1.format_column(20,format_text).width=20
      sheet1.format_column(21,format_text).width=25
      sheet1.format_column(22,format).width=50
      sheet1.format_column(23,format).width=50
      sheet1.format_column(24,format).width=50
      sheet1.format_column(25,format).width=50
      sheet1.format_column(26,format).width=50
      sheet1.format_column(27,format).width=50
      sheet1.format_column(28,format).width=50
      sheet1.format_column(29,format).width=50
      sheet1.format_column(30,format).width=50
      sheet1.format_column(31,format).width=50
      sheet1.format_column(32,format).width=50
      sheet1.format_column(33,format).width=50
      sheet1.format_column(34,format).width=50
                   
      format_text = Spreadsheet::Format.new(:horizontal_align=>'center')
      sheet1.row(4).set_format(6,format_text)
      sheet1.row(4).set_format(7,format_text)
      sheet1.row(4).set_format(8,format_text)
      sheet1.row(4).set_format(9,format_text)
      sheet1.row(4).set_format(10,format_text)
      sheet1.row(4).set_format(11,format_text)
      sheet1.row(4).set_format(12,format_text)
      sheet1.row(4).set_format(13,format_text)
      sheet1.row(4).set_format(14,format_text)
      sheet1.row(4).set_format(15,format_text)
      sheet1.row(4).set_format(16,format_text)
      sheet1.row(4).set_format(17,format_text)
      sheet1.row(4).set_format(18,format_text)
      sheet1.row(4).set_format(19,format_text)
      sheet1.row(4).set_format(22,format_text)
      sheet1.row(4).set_format(23,format_text)
      sheet1.row(4).set_format(24,format_text)
      sheet1.row(4).set_format(25,format_text)
      sheet1.row(4).set_format(26,format_text)
      sheet1.row(4).set_format(27,format_text)
      sheet1.row(4).set_format(28,format_text)
      sheet1.row(4).set_format(29,format_text)
      sheet1.row(4).set_format(30,format_text)
      sheet1.row(4).set_format(31,format_text)
      sheet1.row(4).set_format(32,format_text)
      sheet1.row(4).set_format(33,format_text)
      sheet1.row(4).set_format(34,format_text) 
               
      sheet1[0,5] = 'PROTOKOL' 
      sheet1[1,0] = "Fecha de Elaboración: "
      sheet1[1,1] = Time.now.strftime("%d-%m-%Y")
      sheet1[2,5] = "Proyección Recuperación Cartera en el Período desde: #{fecha_inicio} hasta: #{fecha_fin}"
      sheet1.row(4).push 'Número Trámite', 'Número Financiamiento', 'Nombres Beneficiario', 'Cédula / RIF', 'Programa', 'Estado del País', 'Sector', 'Sub Sector', 'Rubro',
                         'Sub Rubro', 'Actividad', 'Fecha Liquidación', 'Fecha Vencimiento', 'Monto Aprobado', 'Monto Banco',
                         'Monto Liquidado Banco', 'Monto por Liquidar Banco', 'Monto Insumos', 'Monto Despachado Insumos',
                         'Monto por Despachar Insumos', 'Estatus Financiamiento', 'Cantidad Cuotas Vencidas', 'Capital Vencido',
                         'Interés Vencido', 'Interés de Mora', 'Saldo Deudor de Capital', 'Saldo Exigible a la Fecha',
                         'Deuda Total', 'Capital Recuperado a la Fecha', 'Interés Recuperado a la Fecha', 'Interés de Mora Recuperado a la fecha', 'Excedente a Pagar a la Fecha',
                         'Excedente Pagado a la Fecha',
                         'Capital a Recuperar en el Período Seleccionado',
                         'Interés a Recuperar en el Período Seleccionado'
      fila = 6
      vista.each do |v|

        
        estatus = 'Vigente'
        case v.estatus_financiamiento
        
          when 'V'
            estatus = 'Vigente'
          when 'E'
            estatus = 'Vencido'
          when 'P'
            estatus = 'Vigente'
          when 'L'
            estatus = 'Litigio'
          when 'C'
            estatus = 'Consultoría Jurídica'
        end
        
        if v.por_inventario
          monto_por_liquidar = (v.monto_inventario + v.monto_gastos_total + v.monto_sras_total) - v.monto_liquidado_banco
        else
          unless v.monto_banco.nil? || v.monto_liquidado_banco.nil?
            if v.monto_banco == 0
              monto_por_liquidar = 0
            else
              monto_por_liquidar = v.monto_banco - v.monto_liquidado_banco
            end
          end
        end
            
        sheet1.row(fila).push v.numero_tramite, v.numero_financiamiento, v.nombre_beneficiario, v.documento_beneficiario, v.programa_nombre,
                              v.estado_nombre, v.sector_nombre, v.sub_sector_nombre, v.rubro_nombre, 
                              v.sub_rubro_nombre, v.actividad_nombre, v.fecha_liquidacion.strftime("%d-%m-%Y"), 
                              v.fecha_vencimiento.strftime("%d-%m-%Y"), v.monto_aprobado, v.monto_banco, v.monto_liquidado_banco, monto_por_liquidar,
                              v.monto_insumos, v.monto_despachado_insumos, v.monto_por_despachar_insumos,
                              estatus, v.cantidad_cuotas_vencidas, v.capital_vencido,
                              v.interes_vencido, v.monto_mora, v.saldo_deudor, v.monto_exigible,
                              v.deuda_total, v.capital_recuperado, v.interes_recuperado, v.interes_mora_pagada,
                              v.excedente_por_pagar, v.excedente_pagado, v.capital_recuperar, 
                              v.interes_recuperar
                              
                            
                     
        fila += 1
        #logger.info "linea =====> #{v.inspect}"
      end
      
      workbook.write nombre_archivo
      logger.info "archivo =====> #{nombre_archivo}"

    end
    
    return nombre_archivo  
  end
end

# == Schema Information
#
# Table name: view_recuperacion_cartera
#
#  numero_tramite              :integer
#  numero_financiamiento       :integer(8)
#  nombre_beneficiario         :string
#  documento_beneficiario      :string
#  estado_nombre               :string(40)
#  estado_id                   :integer
#  sector_id                   :integer
#  sector_nombre               :string(100)
#  sub_sector_id               :integer
#  sub_sector_nombre           :string(100)
#  rubro_id                    :integer
#  rubro_nombre                :string(100)
#  sub_rubro_id                :integer
#  sub_rubro_nombre            :string(100)
#  actividad_id                :integer
#  actividad_nombre            :string(150)
#  programa_id                 :integer
#  programa_nombre             :string(255)
#  fecha_liquidacion           :date
#  fecha_vencimiento           :date
#  monto_aprobado              :float
#  monto_banco                 :decimal(16, 2)
#  monto_insumos               :decimal(16, 2)
#  monto_liquidado_banco       :decimal(16, 2)
#  monto_por_liquidar_banco    :decimal(, )
#  por_inventario              :boolean
#  monto_inventario            :decimal(16, 2)
#  monto_despachado_insumos    :decimal(16, 2)
#  monto_por_despachar_insumos :decimal(, )
#  estatus_financiamiento      :string(1)
#  cantidad_cuotas_vencidas    :integer(2)
#  capital_vencido             :decimal(16, 2)
#  interes_vencido             :decimal(16, 2)
#  monto_mora                  :decimal(16, 2)
#  saldo_deudor                :decimal(16, 2)
#  monto_exigible              :decimal(16, 2)
#  deuda_total                 :decimal(16, 2)
#  capital_recuperado          :decimal(14, 2)
#  interes_recuperado          :decimal(16, 2)
#  interes_mora_pagada         :decimal(16, 2)
#  excedente_por_pagar         :decimal(16, 2)
#  fecha_cuota                 :date
#  capital_recuperar           :decimal(16, 2)
#  interes_recuperar           :decimal(, )
#  excedente_pagado            :decimal(, )
#  monto_sras_total            :decimal(16, 2)
#  monto_gastos_total          :decimal(16, 2)
#

