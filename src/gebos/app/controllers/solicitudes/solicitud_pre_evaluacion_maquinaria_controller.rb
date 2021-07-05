# encoding: utf-8

#
# autor: Luis Rojas
# clase: Solicitudes::SolicitudPreEvaluacionMaquinariaController
# descripción: Migración a Rails 3
#
class Solicitudes::SolicitudPreEvaluacionMaquinariaController  < FormAjaxTabsController
  
  skip_before_filter :set_charset, :only=>[:clase_search]

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
    @tipo_maquinaria  = TipoMaquinaria.find(:all,:conditions=>"activo=true")
    @clase = []
    
    @unidad_produccion_maquinaria = UnidadProduccionMaquinaria.new

		form_new @unidad_produccion_maquinaria
  end
  
  def save_new
    @seguimiento_visita = SeguimientoVisita.find(params[:seguimiento_visita_id])
    @unidad_produccion_maquinaria = UnidadProduccionMaquinaria.new(params[:unidad_produccion_maquinaria])
    @unidad_produccion_maquinaria.solicitud_id = @seguimiento_visita.solicitud_id
    @unidad_produccion_maquinaria.unidad_produccion_id = @seguimiento_visita.solicitud.unidad_produccion_id
    @unidad_produccion_maquinaria.seguimiento_visita_id = @seguimiento_visita.id
    @unidad_produccion_maquinaria.descripcion_item = 'unidad produccion maquinaria'    
    form_save_new @unidad_produccion_maquinaria
  end
  
  def edit
    @unidad_produccion_maquinaria = UnidadProduccionMaquinaria.find(params[:id])  
    @tipo_maquinaria            = TipoMaquinaria.find(:all)
    #@clase                      = Clase.find(:all)
    @clase = Clase.find_by_sql("(select id,nombre,activo from clase) union (select 0,'[Otro]',true) order by nombre")

    form_edit @unidad_produccion_maquinaria
  end

  def cancel_edit
    @unidad_produccion_maquinaria = UnidadProduccionMaquinaria.find(params[:id])
    form_cancel_edit @unidad_produccion_maquinaria
  end
  
  def save_edit
    @seguimiento_visita = SeguimientoVisita.find(params[:seguimiento_visita_id])
    @unidad_produccion_maquinaria = UnidadProduccionMaquinaria.find(params[:id])
    form_save_edit @unidad_produccion_maquinaria
  end
  
  def cancel_new
		form_cancel_new
  end
  
 
  def delete
    @seguimiento_visita = SeguimientoVisita.find(params[:seguimiento_visita_id])
    @unidad_produccion_maquinaria = UnidadProduccionMaquinaria.find(params[:id])
    form_delete @unidad_produccion_maquinaria
  end

  def clase_search
    if !params[:id].nil? && !params[:id].empty?
      @clase = Clase.find_by_sql("(select id,nombre,activo from clase where tipo_maquinaria_id = (select id from tipo_maquinaria where trim(lower(nombre))='#{params[:id].to_s.strip.downcase}')) union (select 0,'[Otro]',true) order by nombre")
      render :update do |page|
        page.replace_html 'clase-search', :partial => 'clase_search'
        page.show 'clase-search'
      end
    else
      @clase = []
      render :update do |page|
        page.replace_html 'clase-search', :partial => 'clase_search'
        page.show 'clase-search'
      end
    end
  end
   
  protected
  def common
    super
    @form_title = "#{I18n.t('Sistema.Body.Vistas.General.registro')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.informe_recomendacion')}"
    @form_title_record = I18n.t('Sistema.Body.Vistas.General.maquinaria')
    @form_title_records = I18n.t('Sistema.Body.Vistas.General.maquinaria')
    @form_entity = 'unidad_produccion_maquinaria'
    @form_identity_field = 'descripcion_item'
    @width_layout = '955'
  end
  
  private
  def _list
    @solicitud = Solicitud.find(params[:solicitud_id])
    @seguimiento_visita = SeguimientoVisita.find(params[:seguimiento_visita_id])
    conditions = ["unidad_produccion_maquinaria.seguimiento_visita_id = ?", @seguimiento_visita.id]
    params['sort'] = "id" unless params['sort']
    
    @list = UnidadProduccionMaquinaria.search(conditions, params[:page], params['sort'])
    @total=@list.count
      
  end  
end
