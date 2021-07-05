# encoding: utf-8

#
# autor: Marvin Alfonzo
# clase: Solicitudes::ConsultaFideicomisoHistoricoController
# descripción: Migración a Rails 3
#


class Solicitudes::ConsultaFideicomisoHistoricoController < FormTabsController
  require 'spreadsheet'
  include Spreadsheet
 layout 'form_basic'

  def index
   @total=0   
   @list=[]
   
   #@list=scope :transaccion_fideicomiso, where('1 = 0')
   
   #TransaccionFideicomiso.search("",params[:page], "")
    #logger.debug "return >>>>> " << @list.class.to_s
  
  end

  def list

    params['sort'] = "fecha" unless params['sort']
    
    #if params['sort'] == "monto_insumo" : params['sort'] = "(select monto_insumos from prestamo p where p.solicitud_id = solicitud.id)" end
    #if params['sort'] == "monto_banco" : params['sort'] = "(select monto_banco from prestamo p where p.solicitud_id = solicitud.id)"  end
        

      unless params[:transaccion_fideicomiso][:fecha_desde].to_s.nil? || params[:transaccion_fideicomiso][:fecha_desde].to_s.empty?   
        fecha = params[:transaccion_fideicomiso][:fecha_desde]
        #fecha=fecha.split("/")        
        
          if I18n.locale.to_s=="es" || I18n.locale.to_s=="fr" || I18n.locale.to_s=="ar" || I18n.locale.to_s=="cs" || I18n.locale.to_s=="da" || I18n.locale.to_s=="de" || I18n.locale.to_s=="fi" || I18n.locale.to_s=="hu" || I18n.locale.to_s=="it" || I18n.locale.to_s=="ru" ||  I18n.locale.to_s=="nl" || I18n.locale.to_s=="pl" || I18n.locale.to_s=="pt" || I18n.locale.to_s=="sl" || I18n.locale.to_s=="sv"            
            fecha = Time.gm(fecha[6,4].to_i, fecha[3,2].to_i, fecha[0,2].to_i, 0, 0, 0)            
          elsif I18n.locale.to_s=="ja"                    
            fecha = Time.gm(fecha[0,4].to_i, fecha[5,2].to_i, fecha[8,2].to_i, 0, 0, 0)            
          else            
            fecha = Time.gm(fecha[6,4].to_i, fecha[0,2].to_i, fecha[3,2].to_i, 0, 0, 0)            
          end
        
        conditions = "#{conditions} fecha >=  '#{fecha}'"        
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.registro_desde')} '#{params[:transaccion_fideicomiso][:fecha_desde].to_s}'"
      end
 
      unless params[:transaccion_fideicomiso][:fecha_hasta].to_s.nil? || params[:transaccion_fideicomiso][:fecha_hasta].to_s.empty?
        fecha_hasta = params[:transaccion_fideicomiso][:fecha_hasta]
        #fecha_hasta=fecha_hasta.split("/")
        
          if I18n.locale.to_s=="es" || I18n.locale.to_s=="fr" || I18n.locale.to_s=="ar" || I18n.locale.to_s=="cs" || I18n.locale.to_s=="da" || I18n.locale.to_s=="de" || I18n.locale.to_s=="fi" || I18n.locale.to_s=="hu" || I18n.locale.to_s=="it" || I18n.locale.to_s=="ru" ||  I18n.locale.to_s=="nl" || I18n.locale.to_s=="pl" || I18n.locale.to_s=="pt" || I18n.locale.to_s=="sl" || I18n.locale.to_s=="sv"
            fecha_hasta = Time.gm(fecha_hasta[6,4].to_i, fecha_hasta[3,2].to_i, fecha_hasta[0,2].to_i, 23, 59, 0)            
          elsif I18n.locale.to_s=="ja"        
            fecha_hasta = Time.gm(fecha_hasta[0,4].to_i, fecha_hasta[5,2].to_i, fecha_hasta[8,2].to_i, 23, 59, 0)            
          else
            fecha_hasta = Time.gm(fecha_hasta[6,4].to_i, fecha_hasta[0,2].to_i, fecha_hasta[3,2].to_i, 23, 59, 0)            
          end        
        
        conditions = "#{conditions} and fecha <=  '#{fecha_hasta}'"        
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.registro_hasta')} '#{params[:transaccion_fideicomiso][:fecha_hasta].to_s}'"
      end
                 
            
      @list = TransaccionFideicomiso.search(conditions, params[:page], params['sort'])
      @total=@list.count   

      
      @filtro = params
    form_list

  end


  def export
      @transaccion_fideicomiso = TransaccionFideicomiso.find(params[:id])
      fecha = @transaccion_fideicomiso.fecha.strftime('%d_%m_%Y')
      nombre_archivo = "#{@transaccion_fideicomiso.id}_movimiento_fideicomiso_#{fecha}"
      # Creamos un nuevo archivo Excel en disco
      workbook = Excel.new("#{Rails.root}/public/documentos/xls/#{nombre_archivo}.xls")
      # Añadimos hoja Transacciones
      hoja = workbook.add_worksheet(I18n.t('Sistema.Body.Controladores.ConsultarTransaccion.FormTitles.form_title_records'))
      # header de la hoja
      hoja.write(0,0,I18n.t('Sistema.Body.Vistas.General.registro'))
      hoja.write(0,1,"#{I18n.t('Sistema.Body.Vistas.General.monto')} #{I18n.t('Sistema.Body.Vistas.General.banco')}")
      hoja.write(0,2,I18n.t('Sistema.Body.Vistas.ConsultaPrestamo.Etiquetas.monto_insumos'))
      hoja.write(0,3,I18n.t('Sistema.Body.Vistas.ConsultaPrestamoFactura.Etiquetas.monto_sras'))
      hoja.write(0,4,I18n.t('Sistema.Body.Vistas.ConsultaPrestamo.Etiquetas.monto_gastos_administrativos'))
      hoja.write(0,5,"# #{I18n.t('Sistema.Body.Modelos.Errores.tramites')}")
      hoja.write(0,6, I18n.t('Sistema.Body.Vistas.ConsultaCuentaProyectado.Etiquetas.monto_total'))

      fila = 2
 
        # Añado la fila con los datos en sus respectivas columnas
        hoja.write(fila,0,format_fecha(@transaccion_fideicomiso.fecha))
        hoja.write(fila,1,format_fm(@transaccion_fideicomiso.monto_banco))
        hoja.write(fila,2,format_fm(@transaccion_fideicomiso.monto_insumo))
        hoja.write(fila,3,format_fm(@transaccion_fideicomiso.monto_sras))
        hoja.write(fila,4,format_fm(@transaccion_fideicomiso.monto_gastos_admin))
        hoja.write(fila,5,@transaccion_fideicomiso.cantidad_solicitudes)
        hoja.write(fila,6,format_fm(@transaccion_fideicomiso.monto_total))

      # Cerramos el libro
      workbook.close
      # Enviamos el fichero al navegador
      send_file "#{Rails.root}/public/documentos/xls/#{nombre_archivo}.xls"

  end
   
  def view
    index
  end
        
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Modelos.Errores.historico_transacciones_fideicomiso')
    @form_title_record = I18n.t('Sistema.Body.Controladores.ConsultarTransaccion.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.ConsultarTransaccion.FormTitles.form_title_records')
    @form_entity = 'transaccion_fideicomiso'
    @form_identity_field = 'fecha'
    @records_by_page = 1000
    @width_layout = '1000'
  end
      
end

