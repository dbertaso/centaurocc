# encoding: utf-8

#
# autor: Marvin Alfonzo
# clase: Finanzas::FechaLiquidacionController
# descripción: Migración a Rails 3
#

require 'rubygems'
require 'fastercsv'
#ojo quitada en rails 3 require 'jcode'
#$KCODE = 'u'

class Finanzas::FechaLiquidacionController < FormTabsController

skip_before_filter :set_charset, :only=>[:avanzar_solicitud, :reversar]

  def index
  # @feedback=""
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
      page.replace_html 'mensaje', "<div class=\"msg-notice\" id=\"message\" style=\"text-align: center\">#{I18n.t('Sistema.Body.General.se_ha_reversado_solicitud_con_exito')}</div>"
      page.show 'mensaje'
    end
  end

  def avanzar_solicitud

    if params[:cuenta_id].nil? || params[:cuenta_id].empty?
      render :update do |page|
        page.alert("#{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.seleccionar_al_menos')} #{I18n.t('Sistema.Body.Vistas.General.una')} #{I18n.t('Sistema.Body.Vistas.Form.solicitud')}")
        page.<< "varEnviado=false;$('button_save').disabled=false"
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

    desembolso = Desembolso.find_by_prestamo_id_and_realizado(prestamo_id,false)

    logger.info "Desembolso ======================> " << desembolso.inspect

    if !desembolso.nil?
      desembolso.actualizar_desembolso(params, session[:id])
    end

    render :update do |page|
      page.hide 'mensaje'
      page.hide 'errores'
      ids = params[:cuenta_id].split(',')
      ids.each {|id|
        page.remove "row_#{id}"
      }
      page.<< 'document.getElementById("cuenta_id").value = "";document.getElementById("cuenta_id1").value = "";'
      page.replace_html 'mensaje', "<div class=\"msg-notice\" id=\"message\" style=\"text-align: center\">#{I18n.t('Sistema.Body.General.se_han_avanzado_los_tramites_generado_tabla_amortizacion')}</div>"
      page.show 'mensaje'
    end
  end



  def avanzar
    if params[:accion].to_i == 0
          @msg = []
          @clase =""
          @total = 0
          @feedback=""
          @ids = ''
        logger.info "antes del save"

        if !params[:upload][:datafile].nil?
          unless params[:fecha][0]==''
            logger.debug "tipo " << params[:upload].class.to_s << " contenido " << params[:upload].to_s << " otro " << params[:upload][:datafile].original_filename.to_s
            @total, @ids, @msg = save(params[:upload],params[:fecha])
          logger.debug "gtgt " << @msg.to_s << " sss " << @ids.class.to_s
          else
            @msg << "#{I18n.t('Sistema.Body.Vistas.Simulador.Etiquetas.fecha_liquidacion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerida')}"
          end
        else
          @msg << "#{I18n.t('Sistema.Body.Modelos.Errores.archivo_seleccionar')}"
        end


#       logger.info "total 1===========###########> " << @total.to_s
        logger.info "longitud ids 1 ===========###########> " << @ids.length.to_s

        if @total > 0
          @mensaje = "<div class=\"msg-notice\" id=\"message\" style=\"text-align: center\">#{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.se_actualizo_fecha_liquidacion',:total=>@total)}</div>".html_safe
        end
        logger.info "total 2 ===========###########> " << @total.to_s
        logger.info "longitud ids2  ===========###########> " << @ids.length.to_s

        if @msg.length > 0
          logger.debug "Errrorrr >>>>>>> " << @msg.class.to_s << " - " << @msg.inspect.to_s
          @feedback = "<div id=\"errorExplanation\" class=\"errorExplanation\" style=\"text-align: left\"><h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><LI>".html_safe
          @msg.each {|msn|
            @feedback << "<UL>#{msn}</UL>".html_safe
          }
          @feedback << "<LI></div>".html_safe
        end
        
        logger.info "IDSS ===========###########> " << @ids.inspect
        
        @conditions = ''
        if @ids.to_s.length > 0
           @conditions = "solicitud_id in (#{@ids})"

               logger.info " CONDITIONS IDSS====>>>>>" << @conditions.to_s << " - " << @msg.to_s

        else
#          @conditions = "solicitud_id = 0"
          @conditions = "estatus_id in(10070,99) and control = true"
        end
    else
        @conditions = "estatus_id in(10070,99) and control = true"
    end

    logger.info " COnditionss====>>>>>" << @conditions.to_s

#    if !params[:upload][:datafile].empty?
    #if !params[:upload].nil?
      
      @list = ViewFechaLiquidacion.search(@conditions, params[:page], params['sort'])          
      @total=@list.count

      logger.info "total 1===========###########> " << @total.to_s
    #end

  end

  protected

  def common
    super
    @form_title = I18n.t('Sistema.Body.Vistas.Simulador.Etiquetas.fecha_liquidacion')
    @form_title_record = I18n.t('Sistema.Body.Vistas.General.financiamiento')
    @form_title_records = I18n.t('Sistema.Body.Vistas.ParametroGeneral.Separadores.desembolsos')
    @form_entity = 'desembolso'
    @form_identity_field = 'numero'
    @records_by_page = 1000
    @width_layout = '960'
  end

  def save(archivo,fecha)

    logger.debug "INGRESO AQUIIII ======>>>"

    total, ids, msg = Desembolso.save_montos(archivo, fecha, session[:id])


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
