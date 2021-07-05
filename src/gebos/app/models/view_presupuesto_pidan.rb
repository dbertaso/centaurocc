# encoding: utf-8
#
# autor: Luis Rojas
# clase: ViewPresupuestoPidan
# descripción: Migración a Rails 3
#
require 'rubygems'
require 'spreadsheet'

class ViewPresupuestoPidan < ActiveRecord::Base

  self.table_name = 'view_presupuesto_pidan'

  public
  
  
  def ViewPresupuestoPidan.exportar_excel(conditions,file_name)
  
  
    sql = "SELECT programa_nombre, estado_nombre, sector_id, sector_nombre, sub_sector_id, "
    sql += "sub_sector_nombre, rubro_id, rubro_nombre, sub_rubro_nombre, monto_presupuesto, "
    sql += "monto_compromiso, monto_liquidado, monto_disponibilidad"
    sql += " from view_presupuesto_pidan"
    sql += " where #{conditions}"
    sql += " order by programa_nombre, estado_nombre, sector_nombre, sub_sector_nombre, rubro_nombre, sub_rubro_nombre"
    
    nombre_archivo = ''

    logger.info "SQL ===============> #{sql}"
    vista = ViewPresupuestoPidan.find_by_sql(sql)
    
    if vista.count > 0
    
      Spreadsheet.client_encoding = 'UTF-8'
      fecha = Time.now.strftime('%d_%m_%Y')
      nombre_archivo = "#{Rails.root}/public/documentos/xls/#{file_name}"

      workbook = Spreadsheet::Workbook.new
      logger.info "Workbook ===> workbook.inspect"
      sheet1 = workbook.create_worksheet :name => "Presuesto"
      
      format = Spreadsheet::Format.new(:number_format => "#,##0.00_);[red](-0)",:horizontal_align=>'right')
      format_text = Spreadsheet::Format.new(:horizontal_align=>'center', :shrink=>true)
      #puts sheet1.name
      
      sheet1.format_column(0,format_text).width=60
      sheet1.format_column(1,format_text).width=35
      sheet1.format_column(2,format_text).width=50
      sheet1.format_column(3,format_text).width=50
      sheet1.format_column(4,format_text).width=50
      sheet1.format_column(5,format_text).width=50
      sheet1.format_column(6,format_text).width=50
      sheet1.format_column(7,format_text).width=50
      sheet1.format_column(8,format_text).width=50
      sheet1.format_column(9,format_text).width=50

                   
      format_text_center = Spreadsheet::Format.new(:horizontal_align=>'center')
      format_text_rigth = Spreadsheet::Format.new(:number_format => "#,##0.00_);[red](-0)", :horizontal_align=>'right')
      #sheet1.row(4).set_format(0,format_text)
      #sheet1.row(4).set_format(1,format_text)
      #sheet1.row(4).set_format(2,format_text)
      #sheet1.row(4).set_format(3,format_text)
      #sheet1.row(4).set_format(4,format_text)

      format_bold_blue = Spreadsheet::Format.new :color => :blue,
                                                  :weight => :bold,
                                                  :horizontal_align=>'merge',
                                                  :size => 18
                                                  
      sheet1[0,5] = 'PROTOKOL'
      sheet1.row(0).set_format(5,format_bold_blue)
      format_bold_black = Spreadsheet::Format.new :weight => :bold,
                                         :horizontal_align=>'center'
      sheet1.row(1).set_format(0, format_bold_black)
      sheet1[1,0] = "Fecha de Elaboración: "
      sheet1[1,1] = Time.now.strftime("%d-%m-%Y %H:%M")

      sheet1.row(1).set_format(1, format_bold_black)
      sheet1[2,5] = "Presupuesto"
      sheet1.row(2).set_format(5, format_bold_blue)
      sheet1.row(4).push 'Programa', 'Estado', 'Sector', 'Sub Sector', 'Rubro', 'Sub Rubro',
                         'Monto Presupuesto', 'Monto Compromiso', 'Monto Liquidado', 'Disponibilidad'
      fila = 6
      vista.each do |v|

        sheet1.row(fila).push v.programa_nombre, v.estado_nombre, v.sector_nombre, v.sub_sector_nombre,
                              v.rubro_nombre, v.sub_rubro_nombre, v.monto_presupuesto, v.monto_compromiso, 
                              v.monto_liquidado, v.monto_disponibilidad
                              
                            
        sheet1.row(fila).set_format(6,format)
        sheet1.row(fila).set_format(7,format)
        sheet1.row(fila).set_format(8,format)
        sheet1.row(fila).set_format(9,format)
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
# Table name: view_presupuesto_pidan
#
#  programa_id          :integer
#  programa_nombre      :string(255)
#  estado_id            :integer
#  estado_nombre        :string(40)
#  sector_id            :integer
#  sector_nombre        :string(100)
#  sub_sector_id        :integer
#  sub_sector_nombre    :string(100)
#  rubro_id             :integer
#  rubro_nombre         :string(100)
#  sub_rubro_id         :integer
#  sub_rubro_nombre     :string(100)
#  monto_presupuesto    :decimal(16, 2)
#  monto_compromiso     :decimal(16, 2)
#  monto_liquidado      :decimal(16, 2)
#  monto_disponibilidad :decimal(16, 2)
#

