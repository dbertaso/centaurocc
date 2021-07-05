# encoding: UTF-8

#
# autor: Luis Rojas
# clase: Solicitudes::ReversarController
# descripción: Migración a Rails 3
#
class Solicitudes::ReversarController < FormTabsController
  
  skip_before_filter :set_charset, :only=>[:new_reversar, :reversar, :hide_reversar]

 layout 'form_basic'

  def new_reversar
    @solicitud = Solicitud.find(params[:id])
    @codigo = ''
    @codigo_Exitoso = ''
    unless params[:codigo].nil? || params[:codigo].empty?
      @codigo = params[:codigo]
    end
    unless params[:codigo_exitoso].nil? || params[:codigo_exitoso].empty?
        @codigo_exitoso = params[:codigo_exitoso]
       end
    render :update do |page|
      page.replace_html "diferir_#{@solicitud.id}", :partial=>'new_reversar'
      page.show "diferir_#{@solicitud.id}"
    end
  end

   def new_observar
    @solicitud = Solicitud.find(params[:id])
    @control_solicitud = ControlSolicitud.find_all_by_solicitud_id(@solicitud.id, :order =>'id DESC')
   
    render :update do |page|
      page.replace_html "diferir_#{@solicitud.id}", :partial=>'new_observar'
      page.show "diferir_#{@solicitud.id}"
    end
  end

  def hide_reversar
    @solicitud = Solicitud.find(params[:id])
    render :update do |page|    
      page.hide "diferir_#{@solicitud.id}"
    end
  end

  def reversar

     if params[:control_solicitud][:comentario] != ""
       @solicitud = Solicitud.find(params[:id])
       unless params[:codigo].nil? || params[:codigo].empty?
         eval(params[:codigo])
       end
      
      estatus_id_inicial = @solicitud.estatus_id
      fecha_evento = Time.now
      @configuracion_avance = ConfiguracionReverso.find_by_estatus_origen_id(estatus_id_inicial)
      estatus_id_final = @configuracion_avance.estatus_destino_id 
      @solicitud.estatus_id = estatus_id_final
      @solicitud.fecha_actual_estatus = fecha_evento.strftime("%Y/%m/%d")
      
      # Crea un nuevo registro en la tabla control_solicitud
      if (params[:control_solicitud][:comentario].length < 400)
      @solicitud.save
      ControlSolicitud.create(
              :solicitud_id=>@solicitud.id,
              :estatus_id=>estatus_id_final,
              :usuario_id=>@usuario.id,
              :fecha => fecha_evento,
              :estatus_origen_id => estatus_id_inicial,
              :comentario => params[:control_solicitud][:comentario],
              :accion => 'Reversar'
      )
      unless params[:codigo_exitoso].nil? || params[:codigo_exitoso].empty?
         eval(params[:codigo_exitoso])
       end
      
      render :update do |page|
        page.remove "row_#{@solicitud.id}" 
        page.hide 'error'
        page.replace_html 'message', params[:mensaje_exito]         
        page.hide "diferir_#{@solicitud.id}"
        page.show 'message'
      end 

      else
        render :update do |page|
         page.replace_html "errorCustomizado_#{@solicitud.id}","<div id='errorExplanation' class='errorExplanation' style='text-align: left'><h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL><LI>#{I18n.t('Sistema.Body.Vistas.General.observacion')} #{I18n.t('Sistema.Body.Vistas.General.es_demasiado_largo')}</LI></div>"
         page.<< "varEnviado=false;document.getElementById('button_save').disabled=false; "
         page.show "errorCustomizado_#{@solicitud.id}"
         page.show "errorCustomizado_#{@solicitud.id}"
       end 
      end

      else
       @solicitud = Solicitud.find(params[:id])
       render :update do |page|
         page.replace_html "errorCustomizado_#{@solicitud.id}","<div id='errorExplanation' class='errorExplanation' style='text-align: left'><h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL><LI>#{I18n.t('Sistema.Body.Vistas.General.observacion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}</LI></div>"
         page.<< "varEnviado=false;document.getElementById('button_save').disabled=false; "
         page.show "errorCustomizado_#{@solicitud.id}"
         page.show "errorCustomizado_#{@solicitud.id}"
       end 
      end
  end

  protected
  def common
    super
    @form_title = 'Consultoría Jurídica (Visado)'
    @form_title_record = 'Solicitudes' 
    @form_title_records = 'Solicitudes'
    @form_entity = 'consulta_solicitud'
    @form_identity_field = 'numero'
    @width_layout = '1000'
  end 
  
end
