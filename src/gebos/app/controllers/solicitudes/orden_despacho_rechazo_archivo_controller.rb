# encoding: UTF-8

#
# autor: Marvin Alfonzo
# clase: Solicitudes::OrdenDespachoRechazoArchivoController
# descripción: Migración a Rails 3
#

require 'rubygems'
require 'fastercsv'
# require 'jcode'
String#encode = 'u'

class Solicitudes::OrdenDespachoRechazoArchivoController < FormTabsController

skip_before_filter :set_charset, :only=>[:reversar, :avanzar_solicitud]


  def index  
  @form_title = I18n.t('Sistema.Body.Modelos.OrdenDespacho.Mensajes.recepcion_archivo_pago_casa_proveedora')
  @total=0
  end

  def rectificar
    OrdenDespacho.rectifico(params)  
    flash[:notice]=I18n.t('Sistema.Body.General.se_realizaron_los_cambios_satisfactoriamente')
    session[:buenos]=nil
    session[:malos]=nil
    render :update do |page|
  	 page.redirect_to :action => "index"
    end
  end

  def reversar
    if params[:cuenta_id1].nil? || params[:cuenta_id1].empty?
      render :update do |page|
        page.alert("#{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.seleccionar_al_menos')} #{I18n.t('Sistema.Body.Vistas.General.una')} #{I18n.t('Sistema.Body.Vistas.Form.solicitud')}")
      end
      return
    end

    Desembolso.reversar(params)

    render :update do |page|
      page.hide 'mensaje'
      page.hide 'errores'
      ids.each {|id|
        page.remove "row_#{id}"
      }
      page.<< 'document.getElementById("cuenta_id").value = "";document.getElementById("cuenta_id1").value = "";'
      page.replace_html 'mensaje', "<div class=\"msg-notice\" id=\"message\" style=\"text-align: center\">#{I18n.t('Sistema.Body.General.se_ha_reversado_solicitud_con_exito')}</div>".html_safe
      page.show 'mensaje'
    end
  end

  def avanzar_solicitud

    if params[:cuenta_id].nil? || params[:cuenta_id].empty?
      render :update do |page|
        page.alert("#{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.seleccionar_al_menos')} #{I18n.t('Sistema.Body.Vistas.General.una')} #{I18n.t('Sistema.Body.Vistas.Form.solicitud')}")
      end
      return
    end

    logger.info "Params======>" << params[:cuenta_id].inspect
    logger.info "usuario======>" << session[:id].to_s

    items = params[:cuenta_id]
    logger.info "items======>" << items.inspect
    logger.info "items 0======>" << items[0]
    logger.info "items I======>" << items[0].to_i
    if items.class.to_s == 'Array'
      prestamos = items.split(",")
      prestamo_id = prestamos[0].to_i
    else
      prestamo_id = items.to_i

    end

    orden_despacho = OrdenDespacho.find_by_prestamo_id_and_realizado(prestamo_id,false)

    logger.info "Orden Despacho ======================> " << orden_despacho.inspect

=begin
antes esta esto, hay que verificar
    if !orden_despacho.nil?
      orden_despacho.actualizar_desembolso(params, session[:id])
    end
=end

    render :update do |page|
      page.hide 'mensaje'
      page.hide 'errores'
      ids = params[:cuenta_id].split(',')
      ids.each {|id|
        page.remove "row_#{id}"
      }
      page.<< 'document.getElementById("cuenta_id").value = "";document.getElementById("cuenta_id1").value = "";'
      page.replace_html 'mensaje', "<div class=\"msg-notice\" id=\"message\" style=\"text-align: center\">#{I18n.t('Sistema.Body.General.se_han_avanzado_los_tramites_generado_tabla_amortizacion')}</div>".html_safe
      page.show 'mensaje'
    end
  end

  def avanzar
      @msg = []
      @clase =""
      @total = 0
      @feedback=""
      @ids=[]
      @total_io=[]

      mensaje=""
 if params[:accion].to_i == 0


      #logger.info "archivo " << params[:upload][:datafile].to_s


        logger.info "antes del save"


        if !params[:upload][:datafile].nil?
          @total, @ids, @msg = save(params[:upload],params[:fecha])
          @total_io=@total
        else
          @msg = "#{I18n.t('Sistema.Body.Modelos.Errores.archivo_seleccionar')}"
        end

#        logger.info "total 1===========###########> " << @total.to_s
        logger.info "longitud ids 1 ===========###########> " << @ids.length.to_s

        logger.debug "parametros de total " << @total.to_s << " ids "<< @ids.to_s << " mensaje " << @msg.class.to_s

        if @msg.length == 0
          @mensaje = "<div class=\"msg-notice\" id=\"message\" style=\"text-align: center\">#{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.se_actualizo_liquidacion_archivo_banco',:total=>@total)}</div>".html_safe
        end
        logger.info "total 2 ===========###########> " << @total.to_s
        logger.info "longitud ids2  ===========###########> " << @ids.length.to_s

        if @msg.length > 0
          @feedback = "<div id=\"errorExplanation\" class=\"errorExplanation\" style=\"text-align: left\"><h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><LI>".html_safe
          @msg.each {|msn|
            @feedback << "<UL>#{msn}</UL>".html_safe
          }
          @feedback << "<LI></div>".html_safe
        end
        logger.info "IDSS ===========###########> " << @ids.inspect
        @conditions = ''
        fin_malos=""

 else
          # anterior @conditions = "estatus_id in(10070,99) and control = true"
          #@conditions = "estatus_factura_id in(10070,10080)"
		@conditions =""

 end

logger.info " COnditionss====>>>>>" << @conditions.to_s

    if params[:accion].to_i == 0

        if !params[:upload][:datafile].nil?
          
          @list = ViewListOrdenDespachoRechazoArchivo.search("", params[:page], "fecha_liquidacion desc")                     
          @total=@list.count
          logger.info "total 1===========###########> " << @total.to_s
        end

    else
		#esto hay q acomodar, esta vista hay que cambiarla para que muestre los rechazados y liquidados
        
        @list = ViewListOrdenDespachoRechazoArchivo.search("", params[:page], "fecha_liquidacion desc")          
        @total=@list.count
          logger.info "total 2===========###########> " << @total.to_s


    end

		unless @ids.empty? && @total_io.empty?
		  #render :update do |page|
            logger.debug "Me meti "<< @ids.inspect.to_s << " " << @total_io.inspect.to_s            
            
            unless @ids.empty?
				if @ids[0].length > 0
					fin_buenos=""
					@ids.each{|idd| idd.each{|intr| fin_buenos << ("'"+intr+"',")}}					
					fin_buenos=fin_buenos[0,fin_buenos.length-1]
				end
            end
            
            unless @total_io.empty?
				if @total_io[0].length > 0
					fin_malos=""
					@total_io.each{|idd| idd.each{|intr| fin_malos << ("'"+intr+"',")}}					
					fin_malos=fin_malos[0,fin_malos.length-1]
				end
            end
            session[:buenos]=fin_buenos
            session[:malos]=fin_malos 
            redirect_to :action => "index"
          
          #end
		end

  end

  protected

  def common
    super
    @form_title = I18n.t('Sistema.Body.Modelos.OrdenDespacho.Mensajes.recepcion_archivo_pago_casa_proveedora')#'Recepción del Archivo del Banco'
    @form_title_record = I18n.t('Sistema.Body.Vistas.General.archivo')
    @form_title_records = I18n.t('Sistema.Body.Vistas.ParametroGeneral.Separadores.desembolsos')
    @form_entity = 'orden_despacho'
    @form_identity_field = 'numero'
    @records_by_page = 1000
    @width_layout = '960'
  end

  def save(archivo,fecha)

    logger.debug "INGRESO AQUIIII ======>>>"

    total, ids, msg = OrdenDespacho.save_montos(archivo, fecha, session[:id])


#    total= @total
    return total, ids, msg

  end

  def buscarCliente(cedula_rif,linea)
      unless cedula_rif.length > 10
        usuario = Persona.find(:first,:conditions=>['cedula = ?',cedula_rif.to_i])
        unless usuario.nil?
          usuario.cliente_persona
        else
          I18n.t('Sistema.Body.Modelos.Solicitud.Errores.no_se_encontro_en_archivo_cedula',:cedula=>cedula_rif,:linea=>linea)
          #"Cédula '#{cedula_rif.to_i}'en la línea #{linea} no se encuentra registrada en la base de datos"
        end
      else
        usuario = Empresa.find(:first,:conditions=>['rif = ?',cedula_rif.strip.upcase])
        unless usuario.nil?
          usuario.cliente_empresa
        else
          I18n.t('Sistema.Body.Modelos.Solicitud.Errores.no_se_encontro_en_archivo_rif',:rif=>cedula_rif,:linea=>linea)
          #"Rif '#{cedula_rif}'en la línea #{linea} no se encuentra registrada en la base de datos"
        end
      end
  end

end
