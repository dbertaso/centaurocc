# encoding: UTF-8

#
# autor: Luis Rojas
# clase: Solicitudes::DeshacerController
# descripción: Migración a Rails 3
#
class Solicitudes::DeshacerController < FormTabsController
  
  skip_before_filter :set_charset, :only=>[:new_deshacer, :deshacer]

 layout 'form_basic'

  def new_deshacer
    @solicitud = Solicitud.find(params[:id])
    render :update do |page|
      page.replace_html "diferir_#{@solicitud.id}", :partial=>'new_deshacer'.html_safe
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
    @solicitud = Solicitud.find(@params[:id])
    render :update do |page|    
      page.hide "diferir_#{@solicitud.id}"
    end
  end

  def deshacer

     if params[:control_solicitud][:comentario] != ""
       @solicitud = Solicitud.find(params[:id])
     
      if (params[:control_solicitud][:comentario].length < 400)
        @solicitud.confirmacion = false
        @solicitud.decision_final = nil
        @solicitud.comentario_directorio = params[:control_solicitud][:comentario]
        @solicitud.save
        render :update do |page|
          page.remove "row_#{@solicitud.id}"
          page.hide 'error'
          page.replace_html 'message', "La solicitud número #{@solicitud.numero} fue enviada al técnico de campo con exito."
          page.hide "diferir_#{@solicitud.id}"
          page.show 'message'
        end

      else
        render :update do |page|
         page.replace_html "errorCustomizado_#{@solicitud.id}","<div id='errorExplanation' class='errorExplanation' style='text-align: left'><h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL><LI>#{I18n.t('Sistema.Body.Vistas.General.es_demasiado_largo')}</LI></div>"
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
    #@form_title = Etiquetas.etiqueta(10)
    @form_title = 'Consultoría Jurídica (Visado)'
    @form_title_record = 'Solicitudes' 
    @form_title_records = 'Solicitudes'
    @form_entity = 'consulta_solicitud'
    @form_identity_field = 'numero'
    @width_layout = '1000'
  end 
  
end
