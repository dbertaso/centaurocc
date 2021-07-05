# encoding: utf-8
#
# autor: Luis Rojas
# clase: ViewCreditosLiquidados
# descripción: Migración a Rails 3
#
require 'rubygems'
require 'spreadsheet'

class ViewCreditosLiquidados < ActiveRecord::Base

  self.table_name = 'view_creditos_liquidados'

    public
  
    def ViewCreditosLiquidados.exportar_excel(conditions,file_name,fecha_inicio, fecha_fin)

      total_financiamientos = 0
      total_beneficiarios = 0
      total_monto_aprobado = 0.00
      meses = ['NA','Enero','Febrero','Marzo','Abril', 'Mayo', 'Junio', 'Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre']
                
      sql = "SELECT count(prestamo_id) as cantidad_beneficiarios, "
      sql += "sub_rubro_nombre, "
      sql += "sum(cantidad_integrantes) as cantidad_integrantes, "
      sql += "sum(monto_aprobado) as monto_aprobado"
      sql += " from view_creditos_liquidados"
      sql += " where #{conditions}"
      sql += "group by "
      sql += "sub_rubro_nombre "
      sql += "order by sub_rubro_nombre "

      nombre_archivo = ''

      logger.info "SQL ===============> #{sql}"
      vista = ViewCreditosLiquidados.find_by_sql(sql)
      cantidad_beneficiarios_total = 0
      
      if vista.count > 0

        Spreadsheet.client_encoding = 'UTF-8'
        fecha = Time.now.strftime('%d_%m_%Y')
        nombre_archivo = "#{Rails.root}/public/documentos/xls/#{file_name}"

        workbook = Spreadsheet::Workbook.new
        logger.info "Workbook ===> workbook.inspect"
        sheet1 = workbook.create_worksheet :name => "Rendimientos Por Trimestre"
        
        format = Spreadsheet::Format.new(:number_format => "#,##0.00_);[red](-0)",:horizontal_align=>'right')
        format_int = Spreadsheet::Format.new(:number_format => "#,##0_);[red](-0)",:horizontal_align=>'right')
        format_text = Spreadsheet::Format.new(:horizontal_align=>'center')
        #puts sheet1.name
        
        sheet1.format_column(0,format_text).width=50
        sheet1.format_column(1,format_int).width=25
        sheet1.format_column(2,format_int).width=25
        sheet1.format_column(3,format).width=25
        sheet1.format_column(4,format).width=60
        sheet1.format_column(5,format).width=20
        sheet1.format_column(6,format).width=30
        sheet1.format_column(7,format_text).width=30
        sheet1.format_column(8,format_text).width=30
        sheet1.format_column(9,format_text).width=30
        sheet1.format_column(10,format_text).width=30

                     
        format_text = Spreadsheet::Format.new(:horizontal_align=>'center')
        sheet1.row(4).set_format(0,format_text)
        sheet1.row(4).set_format(1,format_text)
        sheet1.row(4).set_format(2,format_text)
        sheet1.row(4).set_format(3,format_text)
        sheet1.row(4).set_format(4,format_text)
        sheet1.row(4).set_format(5,format_text)

        format_bold = Spreadsheet::Format.new :weight => :bold,
                                              :size => 18
                             
        sheet1.row(0).height = 18
        sheet1.row(0).default_format = format_bold    
                     
        sheet1[0,0] = 'PROTOKOL' 
        sheet1.format_column(0,format_text).width=100
        sheet1.format_column(1,format_text).width=25
        sheet1.format_column(2,format_text).width=25
        sheet1.format_column(3,format_int).width=25
        sheet1.format_column(4,format_int).width=60
        sheet1.format_column(5,format).width=60
        sheet1.format_column(6,format).width=30
        sheet1.format_column(7,format_text).width=30
        sheet1.format_column(8,format_text).width=30
        sheet1.format_column(9,format_text).width=30
        sheet1.format_column(10,format_text).width=30

                     
        format_text = Spreadsheet::Format.new(:horizontal_align=>'center')
        sheet1.row(4).set_format(0,format_text)
        sheet1.row(4).set_format(1,format_text)
        sheet1.row(4).set_format(2,format_text)
        sheet1.row(4).set_format(3,format_text)
        sheet1.row(4).set_format(4,format_text)
        sheet1.row(4).set_format(5,format_text)
                
        sheet1[1,0] = "Fecha de Elaboración: #{Time.now.strftime("%d-%m-%Y")}"
        sheet1[2,2] = "Rendiciones del Trimestre en el Período desde: #{fecha_inicio} hasta: #{fecha_fin}"
        sheet1.row(4).push 'Programa a Financiar', 'Fecha De Liquidación Financiamientos Otorgados', 
                           'Fecha Retornabilidad Financiamientos Otorgados', 'Cantidad de Financiamientos',
                           'Cantidad de Beneficiarios', 'Monto en Bs.'
        fila = 6
        logger.info "Vista  ======> #{vista.inspect}"
        vista.each do |v|

          fecha_ini = fecha_inicio.split('/')
          fecha_fini = fecha_fin.split('/')
          logger.info "Fecha INI =========>  #{fecha_ini.inspect}"
          logger.info "Fecha FIN =========>  #{fecha_fini.inspect}"
          fecha_1 = fecha_ini[2] + '/' + fecha_ini[1] + '/' + fecha_ini[0]
          fecha_2 = fecha_fini[2] + '/' + fecha_fini[1] + '/' + fecha_fini[0]
          order_field = 'fecha_fin_retorno'
          fecha_liquidacion = meses[fecha_ini[1].to_i] + ' - ' + meses[fecha_fini[1].to_i] + ' ' + fecha_fini[2]
          fecha = ViewFechasRetorno.find(:first, :select=>'fecha_fin_retorno', :conditions=>["fecha_liquidacion >= ? and fecha_liquidacion <= ? and UPPER(sub_rubro_nombre) = ?",fecha_1,fecha_2,v.sub_rubro_nombre], :order=>"#{order_field}")
          
          unless fecha.nil?
            fecha_inicio_retorno = fecha.fecha_fin_retorno.strftime("%d/%m/%Y")
          else
            fecha_inicio_retorno = '00/00/0000'
          end
          
          order_field = 'fecha_fin_retorno desc'
          fecha = ViewFechasRetorno.find(:first, :select=>'fecha_fin_retorno', :conditions=>["fecha_liquidacion >= ? and fecha_liquidacion <= ? and UPPER(sub_rubro_nombre) = ?",fecha_1,fecha_2,v.sub_rubro_nombre], :order=>"#{order_field}")
          
          unless fecha.nil?
            fecha_fin_retorno = fecha.fecha_fin_retorno.strftime("%d/%m/%Y")
          else
            fecha_fin_retorno = '00/00/0000'
          end
          
          fecha_impresion = fecha_inicio_retorno + ' AL ' + fecha_fin_retorno
          cantidad_beneficiarios_total = v.cantidad_beneficiarios.to_i + v.cantidad_integrantes.to_i
          
          sheet1.row(fila).push v.sub_rubro_nombre, fecha_liquidacion, fecha_impresion, v.cantidad_beneficiarios, cantidad_beneficiarios_total, v.monto_aprobado
                                
          fila += 1
          total_financiamientos += v.cantidad_beneficiarios.to_i
          total_beneficiarios += cantidad_beneficiarios_total
          total_monto_aprobado += v.monto_aprobado.to_f
                  
          #logger.info "linea =====> #{v.inspect}"
        end
        
        fila += 1
        logger.info 
        sheet1[fila,2] = 'Totales'
        sheet1[fila,3] = total_financiamientos
        sheet1[fila,4] = total_beneficiarios
        sheet1[fila,5] = total_monto_aprobado
        
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
                                           
        sheet1.row(fila).set_format(3,format_bold_int)
        sheet1.row(fila).set_format(4,format_bold_int)
        sheet1.row(fila).set_format(5,format_bold_dec)
              
        workbook.write nombre_archivo
        logger.info "archivo =====> #{nombre_archivo}"

      end

      return nombre_archivo  
    end
  end

# == Schema Information
#
# Table name: view_creditos_liquidados
#
#  prestamo_id          :integer
#  fecha_liquidacion    :date
#  sector_id            :integer
#  sub_sector_id        :integer
#  rubro_id             :integer
#  sub_rubro_id         :integer
#  sub_rubro_nombre     :string(100)
#  cantidad_integrantes :integer(8)
#  monto_aprobado       :decimal(16, 2)
#

