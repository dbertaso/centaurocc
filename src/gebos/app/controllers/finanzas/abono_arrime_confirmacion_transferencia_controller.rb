# encoding: utf-8

#
# autor: Marvin Alfonzo
# clase: Finanzas::AbonoArrimeConfirmacionTransferenciaController
# descripción: Migración a Rails 3
#



require 'rubygems'
require 'fastercsv'
#ojo quitada en rails 3 require 'jcode'
#$KCODE = 'u'

class Finanzas::AbonoArrimeConfirmacionTransferenciaController < FormTabsController

  def index
  
  end

  skip_before_filter :set_charset, :only=>[:reversar, :avanzar_solicitud]
  
  def reversar
    if params[:cuenta_id1].nil? || params[:cuenta_id1].empty?
      render :update do |page|
        page.alert(I18n.t('Sistema.Body.Vistas.ComiteNacional.Errores.error_solicitudes'))
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
        page.alert(I18n.t('Sistema.Body.Vistas.ComiteNacional.Errores.error_solicitudes'))
      end
      return
    end

    logger.info "usuario======>" << session[:id].to_s

    Desembolso.actualizar_desembolso(params, session[:id])


    render :update do |page|
      page.hide 'mensaje'
      page.hide 'errores'
      ids = params[:cuenta_id].split(',')
      ids.each {|id|
        page.remove "row_#{id}"
      }
      page.<< 'document.getElementById("cuenta_id").value = "";document.getElementById("cuenta_id1").value = "";'
      page.replace_html 'mensaje', "<div class=\"msg-notice\" id=\"message\" style=\"text-align: center\">#{I18n.t('Sistema.Body.General.se_ha_avanzado_solcitud_con_exito')}</div>".html_safe
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

        logger.info "UPLOAD ==========> " << params[:upload].inspect

        if !params[:upload][:datafile].nil?
          unless params[:fecha][0]==''
            @total, @ids, @msg = save(params[:upload],params[:fecha][0])
          else
            @msg << "#{I18n.t('Sistema.Body.Vistas.Simulador.Etiquetas.fecha_liquidacion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerida')}"
          end
        else
          @msg << I18n.t('Sistema.Body.Modelos.Solicitud.Errores.debe_seleccionar_archivo_para_actualizar_abonos_por_transferencia')
        end

        if @total > 0
          @total == 1 ? texto_cantidad = " #{I18n.t('Sistema.Body.Modelos.Errores.tramite_sin_b')} " : texto_cantidad = " #{I18n.t('Sistema.Body.Modelos.Errores.tramites')} "
          @mensaje = "<div class=\"msg-notice\" id=\"message\" style=\"text-align: center\">#{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.se_actualizo_abono_excedente',:total=>@total)} #{texto_cantidad}</div>".html_safe
        end

        if @msg.length > 0
          @feedback = "<div id=\"errorExplanation\" class=\"errorExplanation\" style=\"text-align: left\"><h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><LI>".html_safe
          @msg.each {|msn|
            @feedback << "<UL>#{msn}</UL>".html_safe
          }
          @feedback << "<LI></div>".html_safe
        end

        @conditions = ''
        #if @ids.length > 0
        #   @conditions = "solicitud_id in (#{@ids})"
        #else
        #  @conditions = "estatus_id in(10070,99) and control = true"
        #end
    #else
    #    @conditions = "estatus_id in(10070,99) and control = true"
    end

    
    @list = ViewExcedenteArrime.search(@conditions, params[:page], params['sort'])
    @total=@list.count

  end

  def consulta_transferencias
    if params[:accion].to_i == 0
          @msg = []
          @clase =""
          @total = 0
          @feedback=""
          @ids = ''

        if !params[:upload][:datafile].nil?
          unless params[:fecha][0]==''
            @total, @ids, @msg = save(params[:upload],params[:fecha][0])
          else
            @msg << "#{I18n.t('Sistema.Body.Vistas.Simulador.Etiquetas.fecha_liquidacion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerida')}"
          end
        else
          @msg << "#{I18n.t('Sistema.Body.Modelos.Errores.archivo_seleccionar')}"
        end

        if @total > 0
           @total == 1 ? texto_cantidad = " #{I18n.t('Sistema.Body.Modelos.Errores.tramite_sin_b')} " : texto_cantidad = " #{I18n.t('Sistema.Body.Modelos.Errores.tramites')} " 
          @mensaje = "<div class=\"msg-notice\" id=\"message\" style=\"text-align: center\">#{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.se_actualizo_fecha_liquidacion',:total=>@total)} #{texto_cantidad}</div>".html_safe
        end

        if @msg.length > 0
          @feedback = "<div id=\"errorExplanation\" class=\"errorExplanation\" style=\"text-align: left\"><h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><LI>".html_safe
          @msg.each {|msn|
            @feedback << "<UL>#{msn}</UL>".html_safe
          }
          @feedback << "<LI></div>".html_safe
        end

        @conditions = ''
        #if @ids.length > 0
        #   @conditions = "solicitud_id in (#{@ids})"
        #else
        #  @conditions = "estatus_id in(10070,99) and control = true"
        #end
    #else
    #    @conditions = "estatus_id in(10070,99) and control = true"
    end

    #se quito esta condicion if !params[:upload][:datafile].empty?
    @mostrar_archivo = ControlEnvioAbonoExcedenteCosecha.find(:all, :conditions=>" estatus = 2",:order=>"id desc" )
    #se quito esta expresion end

  end

  protected

  def common
    super
    @form_title = I18n.t('Sistema.Body.Modelos.ViewExcedenteArrime.Mensajes.actualizacion_fecha_abono_excedente_arrime')
    @form_title_record = I18n.t('Sistema.Body.Vistas.General.archivo')
    @form_title_records = I18n.t('Sistema.Body.Vistas.ParametroGeneral.Separadores.desembolsos')
    @form_entity = 'financiamiento'
    @form_identity_field = 'numero'
    @records_by_page = 1000
    @width_layout = '1100'
  end

  def save(archivo,fecha)
    total, ids, msg = ViewExcedenteArrime.save_montos(archivo, fecha, session[:id])
    return total, ids, msg
  end

  def buscarCliente(cedula_rif,linea)
      unless cedula_rif.length > 10
        usuario = Persona.find(:first,:conditions=>['cedula = ?',cedula_rif.to_i])
        unless usuario.nil?
          usuario.cliente_persona
        else
          I18n.t('Sistema.Body.Modelos.Solicitud.Errores.no_se_encontro_en_archivo_cedula',:cedula=>cedula_rif,:linea=>linea)          
        end
      else
        usuario = Empresa.find(:first,:conditions=>['rif = ?',cedula_rif.strip.upcase])
        unless usuario.nil?
          usuario.cliente_empresa
        else
          I18n.t('Sistema.Body.Modelos.Solicitud.Errores.no_se_encontro_en_archivo_rif',:rif=>cedula_rif,:linea=>linea)          
        end
      end
  end

end
