# encoding: utf-8

#
# autor: Luis Rojas
# clase: Solicitudes::SolicitudPreEvaluacionServiciosController
# descripción: Migración a Rails 3
#
class Solicitudes::SolicitudPreEvaluacionServiciosController < FormTabTabsController

  def index
    list
  end

  def list
    _list

    form_list

  end	
  
  def view
    list_view
  end
  
  def list_view
    _list
    form_list_view
  end
  
  def new

  end
  
  def save_new
    @empresa = Empresa.find(params[:empresa_id])
    @empresa_direccion = EmpresaDireccion.new(params[:empresa_direccion])
    EmpresaDireccion.validate
    form_save_new @empresa_direccion, 
      :value=>@empresa.add_direccion(@empresa_direccion),
      :params=> { :id=>@empresa_direccion.id, :empresa_id => @empresa.id }
  end
  
  def edit
    @solicitud = Solicitud.find(params[:id])
    @servicios_basicos = ServiciosBasicos.find_by_seguimiento_visita_id(params[:seguimiento_visita_id])
    if @servicios_basicos != nil and @servicios_basicos.telefono == false
      @bloquear = 0
    else
      @bloquear = 1
    end
  end
  
  def save_edit
    
    @solicitud = Solicitud.find(params[:id])
    @servicios_basicos = ServiciosBasicos.find_by_seguimiento_visita_id(params[:seguimiento_visita_id])  

    if @servicios_basicos == nil
      @servicios_basicos = ServiciosBasicos.new(params[:servicios_basicos])
      @servicios_basicos.solicitud_id = @solicitud.id
      @servicios_basicos.unidad_produccion_id = @solicitud.unidad_produccion_id
      @servicios_basicos.seguimiento_visita_id =  params[:seguimiento_visita_id]
      valor =@servicios_basicos.save
      if valor == true
        render :update do |page|
          message = "La informaci&oacute;n se actualiz&oacute; con éxito."
          page.hide 'error'
          page.replace_html 'message', message
          page.show 'message'
        end
      else
        render :update do |page|
          message = "Pelón"
          page.hide 'message'
          page.show 'error'
        end
      end

    else
      @servicios_basicos.solicitud_id = @solicitud.id
      @servicios_basicos.unidad_produccion_id = @solicitud.unidad_produccion_id
      @servicios_basicos.seguimiento_visita_id =  params[:seguimiento_visita_id]
      @servicios_basicos = @servicios_basicos.update_attributes(params[:servicios_basicos])
       
      if @servicios_basicos == false

        render :update do |page|
          page.hide 'message'
          page.form_error
        end
      else
        render :update do |page|
          message = "La informaci&oacute;n se actualiz&oacute; con éxito."
          page.hide 'error'
          page.replace_html 'message', message
          page.show 'message'
        end
      end  
    end
  end
  
  def delete
    @empresa = Empresa.find(params[:empresa_id])
    @empresa_direccion = EmpresaDireccion.find(params[:id])
    form_delete @empresa_direccion
  end

  def view_detail
    @empresa = Empresa.find(params[:empresa_id])
    @empresa_direccion = EmpresaDireccion.find(params[:id])
  end
 
  protected  
  def common
    super
    @form_title = "#{I18n.t('Sistema.Body.Vistas.General.registro')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.informe_recomendacion')}"
    @form_title_record = I18n.t('Sistema.Body.Vistas.General.informe_recomendacion')
    @form_title_records = I18n.t('Sistema.Body.Vistas.General.informe_recomendacion')
    @form_entity = 'servicios_basicos'
    @form_identity_field = 'id'
    @width_layout = '955'
  end

  private
  def _list
    @empresa = Empresa.find(params[:empresa_id])
    conditions = ["empresa_direccion.empresa_id = ?", @empresa.id]
    @params['sort'] = "empresa_direccion.tipo" unless @params['sort']
    #@total = EmpresaDireccion.count(:conditions=>conditions, :include=>:ciudad)
    #@pages, @list = paginate(:empresa_direccion, :class_name => 'EmpresaDireccion',
      #:conditions => conditions,
      #:per_page => @records_by_page,
      #:include=>:ciudad,
      #:select=>'empresa_direccion.*',
      #:order_by => @params['sort'])
    @list = EmpresaDireccion.search(conditions, params[:page], params[:sort])
    @total=@list.count
      
  end
end
