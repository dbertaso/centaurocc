# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Contabilidad::CargaDataLoadController
# descripción: Migración a Rails 3

class Contabilidad::CargaDataLoadController < FormClassicController

  layout 'form'
    require 'spreadsheet'
    #require 'iconv'
    include Spreadsheet

  def index
  end

  def actualizar_tipo_transaccion
    @fecha_mala = nil if params[:fecha].size < 4
    @fecha_mala = 'valido' if params[:fecha].size > 4
   conditions =  "(to_char(fecha_comprobante,'yyyy-mm')='#{params[:fecha].to_s}')"
   @comprobante_contable = ViewGebosContabilidadDataload.find(:all,:conditions=>conditions, :select=>"DISTINCT codigo_transaccion")
   render :layout=>false
  end

  def descargar
    ruta_archivo   = "#{RAILS_ROOT}/public/dataload/"+params[:nombre].to_s
    send_file ruta_archivo, :disposition=>'attachment'
  end

  def procesar
    begin
    archivo                  = GebosContabilidadDataload.new
    tipo        = params[:tipo]
    fecha       = Time.now
    fecha_archivo  = fecha.year.to_s+fecha.month.to_s+fecha.day.to_s+fecha.hour.to_s+fecha.minute.to_s+fecha.second.to_s
    conditions = "enviado = false"
    conditions << " and (to_char(fecha_comprobante,'yyyy-mm')='#{tipo[:fecha].to_s}')"
    if tipo[:transaccion].nil?  || tipo[:transaccion].size < 4
       tipo[:transaccion] = 'Todas las transacciones'
    else
       conditions << " and codigo_transaccion = '#{tipo[:transaccion]}'"
    end
      data = ViewGebosContabilidadDataload.find(:all, :conditions=>conditions, :order=>'codigo_transaccion , fecha_comprobante')
      if data.size > 0
        nombre_archivo = tipo[:transaccion].gsub(' ','_').to_s+'_'+fecha_archivo.to_s+'.txt'
        nombre_archivo_xls = tipo[:transaccion].gsub(' ','_').to_s+'_'+fecha_archivo.to_s+'.xls'
        ruta_archivo   = "#{RAILS_ROOT}/public/dataload/"+nombre_archivo.to_s
        ruta_archivo_xls = "#{RAILS_ROOT}/public/dataload/"+nombre_archivo_xls.to_s
        workbook = Spreadsheet::Workbook.new
        worksheet = workbook.create_worksheet

        filas = []
        x  = 0
        ultimo = data.size
        data.each do |data|
          x = x + 1
          aux = []
          cuenta_contable = data.codigo_contable.split('-')
          if x == 1
            aux << x
            aux << "TAB"
          end
          aux << data.codigo_contable
          aux << "TAB"
          if  data.tipo == 'D'
            aux << data.total_debe
            aux << "TAB"
          else
            aux << "TAB"
            aux << data.total_haber
            aux << "TAB"
          end

            aux << data.referencia
            if x != ultimo
            aux << '*DN'
            else
              aux << '*SAVE'
            end
            archivo.usuario_id       = session[:id]
            archivo.tipo_movimiento  = tipo[:transaccion]
            archivo.nombre_archivo   = nombre_archivo_xls
            archivo.numero_filas     = x
            archivo.ruta_archivo     = ruta_archivo
            archivo.fecha_creacion   = fecha
            archivo.save
            comprobante                   = ComprobanteContable.find_by_sql("update comprobante_contable set
                                                                                        enviado           = true ,
                                                                                        fecha_envio = '#{Time.now.strftime('%Y-%m-%d')}',
                                                                                        numero_lote_envio = '#{archivo.id}'
                                                                                    where id =#{data.comprobante_contable_id}")
          filas << aux
        end
         filas.each_with_index do |row,row_index|
           worksheet.row(row_index+1).concat row
         end
         workbook.write ruta_archivo_xls
      render :update do |page|
        page.hide 'message'
        page.hide 'error'
        page.show 'lista_oculta'
        page.replace_html 'row_0',"<td>#{archivo.nombre_archivo}</td>
                                     <td>#{archivo.tipo_movimiento}</td>
                                     <td>#{archivo.fecha_creacion.strftime('%d-%m-%Y a las %H:%m:%S')}</td>
                                     <td>#{archivo.numero_filas}</td>
                                     <td><a href='/contabilidad/carga_data_load/descargar?nombre=#{archivo.nombre_archivo}'>
                                         <input type='image' src='/images/descargar.png'>
                                         </a>
                                     </td>
                                     "
        page.replace_html 'message', "El archivo se proceso con exito"
        page.show 'message'
      end
    else
      render :update do |page|
        page.hide 'message'
        page.hide 'error'
        page.show 'lista_oculta'
        page.replace_html 'message', "No se pudo procesar el archivo"
        page.show 'message'
      end
    end
    rescue StandardError => e
      logger.error "[:gebos] Erorres=> "+e
    end
  end

  def list
      conditions = ''
      fecha = params[:fecha] if !params[:fecha].nil?
      tipo  = params[:tipo]  if !params[:tipo].nil?
      conditions << "(to_char(fecha_creacion,'yyyy-mm')='#{fecha.to_s}') "
      conditions << " and tipo_movimiento ='#{tipo.to_s}'" if !tipo.nil?
      puts conditions.to_s
      params['sort'] = "gebos_contabilidad_dataload.id,gebos_contabilidad_dataload.tipo_movimiento desc" unless params['sort']

      @pages, @list = paginate(:gebos_contabilidad_dataload, :class_name => 'GebosContabilidadDataload',
      :conditions => conditions,
      :per_page=>@records_by_page,
      :select=>'gebos_contabilidad_dataload.*',
      :order_by => params['sort'])
      @total=@pages.item_count
      render :layout=>false
  end

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.Contabilidad.CargaDataload.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.Contabilidad.CargaDataload.form_title')
    @form_title_records = I18n.t('Sistema.Body.Controladores.Contabilidad.CargaDataload.form_title')
    @form_entity = 'carga_data_load'
    @form_identity_field = 'nombre'
    @width_layout = 700
  end

end

