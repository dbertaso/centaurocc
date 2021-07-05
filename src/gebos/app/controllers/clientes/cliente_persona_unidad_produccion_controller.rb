# encoding: UTF-8

#
# autor: Luis Rojas
# clase: Clientes::ClientePersonaUnidadProduccionController
# descripción: Migración a Rails 3
#
class Clientes::ClientePersonaUnidadProduccionController < FormTabsController

  skip_before_filter :set_charset, :only=>[:region_change, :estado_change, :municipio_change, :save_new_utm, :delete_utm]

  layout 'form_basic'

  def index
    list
    identidad()
  end

  def list
    _list

    form_list
  end

  def new
    @unidad_produccion = UnidadProduccion.new
    @persona = Persona.find(params[:persona_id])
    @region_list = Region.find(:all, :order=>'nombre')
    @estado_list = []
    @municipio_list = []
    @ciudad_list = []
    @parroquia_list = []
    identidad()
  end

  def save_new
    @unidad_produccion = UnidadProduccion.new(params[:unidad_produccion])
    @persona = Persona.find(params[:id])
    @unidad_produccion.cliente_id = @persona.cliente_persona.id
    @unidad_produccion.codigo = 0
    if @persona.cliente_persona.es_pescador == true
      @unidad_produccion.total_hectareas = 0.0
    end
    identidad()
    form_save_new @unidad_produccion
  end

  def edit
    @unidad_produccion = UnidadProduccion.find(params[:id])
    @utm_unidad_produccion_list = UtmUnidadProduccion.find(:all, :conditions=>["unidad_produccion_id = ?", @unidad_produccion.id])
    @persona = Persona.find(@unidad_produccion.cliente.persona_id)
    @region_list = Region.find(:all, :order=> 'nombre')
    fill
    identidad()
  end

  def save_edit
    @unidad_produccion = UnidadProduccion.find(params[:id])
    @persona = Persona.find(@unidad_produccion.cliente.persona_id)
    identidad()
    form_save_edit @unidad_produccion
  end

  def save_new_utm
    errores = UtmUnidadProduccion.create_new(params[:utm_unidad_produccion], params[:unidad_produccion_id])
    if errores == true
      @unidad_produccion = UnidadProduccion.find(params[:unidad_produccion_id])
      @utm_unidad_produccion_list = UtmUnidadProduccion.find(:all, :conditions=>["unidad_produccion_id = ?", params[:unidad_produccion_id]])
      render :update do |page|
        page.hide 'errorExplanation'
        page.replace_html 'cliente_persona_unidad_produccion', :partial => 'utm'
        page.replace_html 'message', I18n.t('Sistema.Body.General.guardar')
        page.show 'cliente_persona_unidad_produccion'
        page.show 'message'
        #page.<< "window.scrollTo(0,200);"
      end
    else
      render :update do |page|
        page.hide 'message'
        page.replace_html 'errorExplanation',"<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL>#{errores}</UL></p>"
        page.show 'errorExplanation'
        page.<< "document.getElementById('agregar_utm').style.display= '';"

      end

    end
  end

  def delete_utm
    UtmUnidadProduccion.delete(params[:id])
    @unidad_produccion = UnidadProduccion.find(params[:unidad_produccion_id])
    @utm_unidad_produccion_list = UtmUnidadProduccion.find(:all, :conditions=>["unidad_produccion_id = ?", params[:unidad_produccion_id]])
    render :update do |page|
      page.hide 'errorExplanation'
      page.replace_html 'cliente_persona_unidad_produccion', :partial => 'utm'
      page.replace_html 'message', "#{I18n.t('Sistema.Body.Vistas.General.utm')} #{I18n.t('Sistema.Body.Controladores.Mensaje.eliminacion')}"
      page.show 'cliente_persona_unidad_produccion'
      page.show 'message'
    end
  end
  #===========================================================

  def delete
    @persona = Persona.find(params[:persona_id])
    @unidad_produccion = UnidadProduccion.find(params[:id])
    identidad()
    msj = @unidad_produccion.validate_destroy
    unless msj.length > 0
      form_delete @unidad_produccion
    else
      render :update do |page|
        page.alert(msj)
      end
      return
    end
  end

  def view
    _list
    identidad()
    form_list
  end

  def view_detail
    @unidad_produccion = UnidadProduccion.find(params[:id])
    @persona = Persona.find(@unidad_produccion.cliente.persona_id)
    @utm_unidad_produccion_list = UtmUnidadProduccion.find(:all, :conditions=>["unidad_produccion_id = ?", @unidad_produccion.id])
    identidad()
  end

  def region_change
    if params[:region_id].nil? || params[:region_id].to_s.empty?
      @estado_list = []
      @municipio_list = []
      @ciudad_list = []
      @parroquia_list = []
    else
      estado_fill(params[:region_id])
    end
    render :update do |page|
      page.replace_html 'estado-select', :partial => 'estado_select'.html_safe
      page.replace_html 'municipio-select', :partial => 'municipio_select'.html_safe
      page.replace_html 'ciudad-select', :partial => 'ciudad_select'.html_safe
      page.replace_html 'parroquia-select', :partial => 'parroquia_select'.html_safe
    end
  end

  def estado_change
    ciudad_fill(params[:estado_id])
    municipio_fill(params[:estado_id])
    render :update do |page|
      page.replace_html 'ciudad-select', :partial => 'ciudad_select'.html_safe
      page.replace_html 'municipio-select', :partial => 'municipio_select'.html_safe
      page.replace_html 'parroquia-select', :partial => 'parroquia_select'.html_safe
    end
  end

  def municipio_change
    parroquia_fill(params[:municipio_id])
    render :update do |page|
      page.replace_html 'parroquia-select', :partial => 'parroquia_select'.html_safe
    end
  end

  protected
  def common
    super
    @form_title = "#{I18n.t('Sistema.Body.General.beneficiario')} #{I18n.t('Sistema.Body.General.natural')}"
    @form_title_record = I18n.t('Sistema.Body.Vistas.General.unidad_produccion')
    @form_title_records = I18n.t('Sistema.Body.Vistas.General.unidad_produccion')
    @form_entity = 'unidad_produccion'
    @form_identity_field = 'nombre'
    @width_layout = '900'
  end

  private
  def _list
    @persona = Persona.find(params[:persona_id])
    conditions = ["cliente_id = ?", @persona.cliente_persona.id]
    params['sort'] = "nombre" unless params['sort']
    
    @list = UnidadProduccion.search(conditions, params[:page], params['sort'])
    @total=@list.count
    @pages = @list.clone
  end

  def fill
    @region_list = Region.find(:all, :order=>'nombre')
    unless @unidad_produccion.nil?
      if @unidad_produccion.ciudad
        region_id = @unidad_produccion.region_id
      else
        region_id = @region_list[0].id
      end
    else
      region_id = @region_list[0].id
    end
    estado_fill(region_id)
  end

  def estado_fill(region_id)
    @estado_list = Estado.find(:all, :conditions=>['region_id = ?', region_id], :order=>'nombre')

    if @unidad_produccion && @unidad_produccion.estado_id
      estado_id = @unidad_produccion.estado_id
    else
      estado_id = @estado_list.first.id
    end
    ciudad_fill(estado_id)
    municipio_fill(estado_id)
  end

  def municipio_fill(estado_id)
    @municipio_list = Municipio.find_all_by_estado_id(estado_id, :order=>'nombre')
    if @unidad_produccion && @unidad_produccion.municipio_id
      municipio_id = @unidad_produccion.municipio_id
    else
      municipio_id = @municipio_list.first.id if @municipio_list.first
    end
    parroquia_fill(municipio_id)
  end

  def ciudad_fill(estado_id)
    @ciudad_list = Ciudad.find_all_by_estado_id(estado_id, :order=>'nombre')
  end

  def parroquia_fill(municipio_id)
    @parroquia_list = Parroquia.find_all_by_municipio_id(municipio_id, :order=>'nombre')
  end

  def identidad
    if @persona.cliente_persona.es_pescador == true
      @form_title = I18n.t('Sistema.Body.Vistas.General.puerto_base')
      @form_title_record = I18n.t('Sistema.Body.Vistas.General.puerto_base')
      @form_title_records = I18n.t('Sistema.Body.Vistas.General.puerto_base')
    end
  end

end
