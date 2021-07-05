# encoding: utf-8

#
# autor: Luis Rojas
# clase: Solicitudes::SolicitudPreEvaluacionInfraestructuraController
# descripción: Migración a Rails 3
#
class Solicitudes::SolicitudPreEvaluacionInfraestructuraController  < FormAjaxTabsController

  def index
    @solicitud = Solicitud.find(params[:solicitud_id])
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
    @seguimiento_visita = SeguimientoVisita.find(params[:seguimiento_visita_id])    
    @unidad_produccion_infraestructura = UnidadProduccionInfraestructura.new

		form_new @unidad_produccion_infraestructura
  end
  
  def save_new
    @seguimiento_visita = SeguimientoVisita.find(params[:seguimiento_visita_id])
    @unidad_produccion_infraestructura = UnidadProduccionInfraestructura.new(params[:unidad_produccion_infraestructura])
    @unidad_produccion_infraestructura.solicitud_id = @seguimiento_visita.solicitud_id
    @unidad_produccion_infraestructura.unidad_produccion_id = @seguimiento_visita.solicitud.unidad_produccion_id
    @unidad_produccion_infraestructura.seguimiento_visita = @seguimiento_visita
    form_save_new @unidad_produccion_infraestructura
  end
  
  def edit
    @unidad_produccion_infraestructura = UnidadProduccionInfraestructura.find(params[:id])    
    form_edit @unidad_produccion_infraestructura
  end

  def cancel_edit
    @unidad_produccion_infraestructura = UnidadProduccionInfraestructura.find(params[:id])
    form_cancel_edit @unidad_produccion_infraestructura
  end
  
  def save_edit
    @seguimiento_visita = SeguimientoVisita.find(params[:seguimiento_visita_id])
    @unidad_produccion_infraestructura = UnidadProduccionInfraestructura.find(params[:id])
    form_save_edit @unidad_produccion_infraestructura
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def delete
    @seguimiento_visita = SeguimientoVisita.find(params[:seguimiento_visita_id])
    @unidad_produccion_infraestructura = UnidadProduccionInfraestructura.find(params[:id])
    form_delete @unidad_produccion_infraestructura
  end
  
  protected
  def common
    super
    @form_title = "#{I18n.t('Sistema.Body.Vistas.General.registro')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.informe_recomendacion')}"
    @form_title_record = I18n.t('Sistema.Body.Vistas.General.infraestructura')
    @form_title_records = I18n.t('Sistema.Body.Vistas.General.infraestructura')
    @form_entity = 'unidad_produccion_infraestructura'
    @form_identity_field = 'tipo_infraestructura.nombre'
    @width_layout = '955'

    @tipo_infraestructura_list = TipoInfraestructura.find(:all, :conditions=>["activo = true"], :order=>'nombre')
    @unidad_medida_list = UnidadMedida.find(:all, :order=>'nombre')  
  end
  
  private
  def _list
    @solicitud = Solicitud.find(params[:solicitud_id])
    @seguimiento_visita = SeguimientoVisita.find(params[:seguimiento_visita_id])
    conditions = ["unidad_produccion_infraestructura.seguimiento_visita_id = ?", @seguimiento_visita.id]
    params['sort'] = "tipo_infraestructura_id" unless params['sort']
    
    @list = UnidadProduccionInfraestructura.search(conditions, params[:page], params['sort'])
    @total=@list.count
      
  end  
end
