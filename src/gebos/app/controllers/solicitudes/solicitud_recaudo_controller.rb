# encoding: UTF-8

#
# autor: Luis Rojas
# clase: Solicitudes::SolicitudRecaudoController
# descripción: Migración a Rails 3
#

class Solicitudes::SolicitudRecaudoController < FormAjaxTabsController
  
  skip_before_filter :set_charset, :only=>[:actualizar, :save, :save_revisado, :save_observaciones]

  def index
    list
  end

  def list
    _list
  end	
  
  def view
    list_view
  end
  
  def list_view
    _list
  end

  def save_observaciones
    @solicitud = Solicitud.find(params[:solicitud_id])
    if SolicitudRecaudo.update_observaciones(@solicitud, params[:solicitud]) == true
      render :update do |page|
        message = I18n.t('Sistema.Body.Modelos.Solicitud.Mensajes.actualizo_solicitud')
    		page.hide 'error'
        page.replace_html 'message', message.html_safe
        page.show 'message'
  		end
    else
      render :update do |page|
        page.replace_html 'error', :partial => 'error'.html_safe
        page.show 'error'
      end
    end
  end
  
  def save
    @solicitud_recaudo = SolicitudRecaudo.find(params[:id])
    if @solicitud_recaudo.update_attributes(:entregado=>params[:entregado])
      valor = true
      unless @solicitud_recaudo.entregado
        @solicitud_recaudo.no_revisado_consultoria = false
        valor = false
      end
      render :update do |page|
        message = "#{@form_title_record} '#{@solicitud_recaudo.recaudo.nombre}' #{I18n.t('Sistema.Body.Vistas.Helpers.Mensajes.modificacion')}"
    		page.hide 'error'
    		page.visual_effect :highlight, "row_#{@solicitud_recaudo.id}", :duration => 0.6
        page.replace_html 'message', message
        page << "desmarcar_revisado(#{params['id']}, #{valor})"
        page.show 'message'
  		end
    else
      render :update do |page|
        page.replace_html 'error', :partial => 'error'
        page.show 'error'
      end
    end
  end

  def save_revisado
    @solicitud_recaudo = SolicitudRecaudo.find(params[:id])
    @solicitud_recaudo.entregado = true
    if @solicitud_recaudo.update_attributes(:revisado_consultoria=>params[:revisado_consultoria])
      @solicitud_recaudo.save
      render :update do |page|
        message = "#{@form_title_record} '#{@solicitud_recaudo.recaudo.nombre}' #{I18n.t('Sistema.Body.Vistas.Helpers.Mensajes.modificacion')}"
    		page.hide 'error'
    		page.visual_effect :highlight, "row_#{@solicitud_recaudo.id}", :duration => 0.6
        page.replace_html 'message', message
        page << "marcar_entregado(#{params['id']})"
        page.show 'message'
  		end
    else
      render :update do |page|
        page.replace_html 'error', :partial => 'error'
        page.show 'error'
      end
    end
  end
  
  def actualizar
    @solicitud = Solicitud.find(params[:solicitud_id])
    @solicitud.crear_recaudos()
    @solicitud_recaudo_list = SolicitudRecaudo.find_all_by_solicitud_id(
      @solicitud.id, :include=>'recaudo', :conditions=>['recaudo.tipo_cliente_id = 1000 or recaudo.tipo_cliente_id = ?',@solicitud.cliente.tipo_cliente_id] , :order=>'recaudo.nombre')
    render :update do |page|
      page.replace_html 'list', :partial => 'list'.html_safe
      page.show 'list'
    end
  end
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Vistas.General.solicitudes')
    @form_title_record = I18n.t('Sistema.Body.Controladores.Recaudo.FormTitles.form_title')
    @form_title_records = I18n.t('Sistema.Body.Controladores.Recaudo.FormTitles.form_title_records')
    @form_entity = 'solicitud_recaudo'
    @form_identity_field = 'recaudo.nombre'
    @width_layout = '920'
  end
  
  private
  def _list
    @solicitud = Solicitud.find(params[:solicitud_id])
    @solicitud_recaudo_list = SolicitudRecaudo.find_all_by_solicitud_id(
      @solicitud.id, :include=>'recaudo', :conditions=>['recaudo.tipo_cliente_id = 1000 or recaudo.tipo_cliente_id = ?',@solicitud.cliente.tipo_cliente_id] , :order=>'recaudo.nombre')
  end
end