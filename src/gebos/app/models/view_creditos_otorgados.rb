# encoding: utf-8
#
# autor: Luis Rojas
# clase: ViewPresupuestoPidan
# descripción: Migración a Rails 3
#
require 'rubygems'
require 'spreadsheet'

class ViewCreditosOtorgados < ActiveRecord::Base

    self.table_name = 'view_creditos_otorgados'

    public
  
    def ViewCreditosOtorgados.exportar_excel(conditions,file_name,fecha_inicio, fecha_fin)

      total_financiamientos = 0
      total_beneficiarios = 0
      total_monto_aprobado = 0.00
      
      sql = "SELECT count(solicitud_id) as cantidad_beneficiarios, "
      sql += "sub_rubro_nombre, "
      sql += "sum(cantidad_integrantes) as cantidad_integrantes, "
      sql += "sum(monto_aprobado) as monto_aprobado"
      sql += " from view_creditos_otorgados"
      sql += " where #{conditions}"
      sql += "group by "
      sql += "sub_rubro_nombre "
      sql += "order by sub_rubro_nombre "

      nombre_archivo = ''

      logger.info "SQL ===============> #{sql}"
      vista = ViewCreditosOtorgados.find_by_sql(sql)
      cantidad_beneficiarios_total = 0
      
      if vista.count > 0

        Spreadsheet.client_encoding = 'UTF-8'
        fecha = Time.now.strftime('%d_%m_%Y')
        nombre_archivo = "#{Rails.root}/public/documentos/xls/#{file_name}"

        workbook = Spreadsheet::Workbook.new
        logger.info "Workbook ===> workbook.inspect"
        sheet1 = workbook.create_worksheet :name => "Financiamientos Otorgados Por Trimestre"
        
        format = Spreadsheet::Format.new(:number_format => "#,##0.00_);[red](-0)",:horizontal_align=>'right')
        format_int = Spreadsheet::Format.new(:number_format => "#,##0_);[red](-0)",:horizontal_align=>'right')
        format_text = Spreadsheet::Format.new(:horizontal_align=>'center')
        #puts sheet1.name
        


        format_bold = Spreadsheet::Format.new :weight => :bold,
                                              :size => 18
                             
        sheet1.row(0).height = 18
        sheet1.row(0).default_format = format_bold
        
        sheet1[0,0] = 'PROTOKOL' 

        sheet1.format_column(0,format_int).width=50
        sheet1.format_column(1,format_int).width=50
        sheet1.format_column(2,format_int).width=25
        sheet1.format_column(3,format).width=25
        sheet1.format_column(4,format_text).width=60
        sheet1.format_column(5,format_text).width=20
        sheet1.format_column(6,format_text).width=30
        sheet1.format_column(7,format_text).width=30
        sheet1.format_column(8,format_text).width=30
        sheet1.format_column(9,format_text).width=30
        sheet1.format_column(10,format_text).width=30

                     
        format_text = Spreadsheet::Format.new(:horizontal_align=>'center')
        sheet1.row(4).set_format(6,format_text)
        sheet1.row(4).set_format(7,format_text)
        sheet1.row(4).set_format(8,format_text)
        sheet1.row(4).set_format(9,format_text)
        sheet1.row(4).set_format(10,format_text)
        sheet1.row(4).set_format(11,format_text)
            
        sheet1[1,0] = "Fecha de Elaboración: #{Time.now.strftime("%d-%m-%Y")}"
        sheet1[2,2] = "Financiamientos Otorgados en el Período desde: #{fecha_inicio} hasta: #{fecha_fin}"
        sheet1.row(4).push 'Sub Rubro a Financiar', 'Cantidad Financiamientos', 'Cantidad Beneficiarios', 'Monto Aprobado'
        fila = 6
        logger.info "Vista  ======> #{vista.inspect}"
        vista.each do |v|

          cantidad_beneficiarios_total = v.cantidad_beneficiarios.to_i + v.cantidad_integrantes.to_i
          
          sheet1.row(fila).push v.sub_rubro_nombre, v.cantidad_beneficiarios, cantidad_beneficiarios_total, v.monto_aprobado
                                
          fila += 1
          total_financiamientos += v.cantidad_beneficiarios.to_i
          total_beneficiarios += v.cantidad_integrantes.to_i
          total_monto_aprobado += v.monto_aprobado.to_f
          
          #logger.info "linea =====> #{v.inspect}"
        end
        
        fila += 1
        sheet1[fila,0] = 'Total Bs.'
        sheet1[fila,1] = total_financiamientos
        sheet1[fila,2] = total_beneficiarios
        sheet1[fila,3] = total_monto_aprobado
        
        format_bold = Spreadsheet::Format.new :color => :blue,
                                           :weight => :bold,
                                           :size => 18
                                           
        sheet1.row(fila).default_format = format_bold
        sheet1.row(fila).height = 18
        
        format_bold_int = Spreadsheet::Format.new :color => :blue,
                                           :weight => :bold,
                                           :size => 18,
                                           :number_format => "#,##0_);[red](-0)",
                                           :horizontal_align=>'right'

        format_bold_dec = Spreadsheet::Format.new :color => :blue,
                                           :weight => :bold,
                                           :size => 18,
                                           :number_format => "#,##0.00_);[red](-0)",
                                           :horizontal_align=>'right'
                                           
        sheet1.row(fila).set_format(1,format_bold_int)
        sheet1.row(fila).set_format(2,format_bold_int)
        sheet1.row(fila).set_format(3,format_bold_dec)
        
        workbook.write nombre_archivo
        logger.info "archivo =====> #{nombre_archivo}"

      end

      return nombre_archivo  
    end
  end

# == Schema Information
#
# Table name: view_creditos_otorgados
#
#  solicitud_id         :integer
#  fecha_aprobacion     :date
#  sector_id            :integer
#  sub_sector_id        :integer
#  rubro_id             :integer
#  sub_rubro_id         :integer
#  sub_rubro_nombre     :string(100)
#  cantidad_integrantes :integer(8)
#  monto_aprobado       :decimal(16, 2)
#

