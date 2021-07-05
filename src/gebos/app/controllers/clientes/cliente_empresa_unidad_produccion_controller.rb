# encoding: UTF-8

#
# autor: Luis Rojas
# clase: Clientes::ClienteEmpresaUnidadProduccionController
# descripción: Migración a Rails 3
#
class Clientes::ClienteEmpresaUnidadProduccionController < FormTabsController

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
    @empresa = Empresa.find(params[:empresa_id])
    @region_list = Region.find(:all, :order=>'nombre')
    @estado_list = []
    @municipio_list = []
    @ciudad_list = []
    @parroquia_list = []
    identidad()
  end

  def save_new
    @unidad_produccion = UnidadProduccion.new(params[:unidad_produccion])
    @empresa = Empresa.find(params[:id])
    @unidad_produccion.cliente_id = @empresa.cliente_empresa.id
    @unidad_produccion.codigo = 0
    identidad()
    form_save_new @unidad_produccion
  end

  def edit
    @unidad_produccion = UnidadProduccion.find(params[:id])
    @utm_unidad_produccion_list = UtmUnidadProduccion.find(:all, :conditions=>["unidad_produccion_id = ?", @unidad_produccion.id])
    @puerto_base_list = PuertoBase.find(:all, :conditions => ["unidad_produccion_id = ?", @unidad_produccion.id])
    @empresa = Empresa.find(@unidad_produccion.cliente.empresa_id)
    @region_list = Region.find(:all, :order=> 'nombre')
    estado_fill(@unidad_produccion.ciudad.estado.region_id)
    identidad()
  end

  def save_edit
    @unidad_produccion = UnidadProduccion.find(params[:id])
    @empresa = Empresa.find(@unidad_produccion.cliente.empresa_id)
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
        page.replace_html 'cliente_empresa_unidad_produccion', :partial => 'utm'
        page.replace_html 'message', I18n.t('Sistema.Body.General.guardar')
        page.show 'cliente_empresa_unidad_produccion'
        page.show 'message'
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
      page.replace_html 'cliente_empresa_unidad_produccion', :partial => 'utm'
      page.replace_html 'message', "#{I18n.t('Sistema.Body.Vistas.General.utm')} #{I18n.t('Sistema.Body.Controladores.Mensaje.eliminacion')}"
      page.show 'cliente_empresa_unidad_produccion'
      page.show 'message'
    end
  end

  def save_new_puertos
    errores = PuertoBase.create_new(params[:puerto_base], params[:unidad_produccion_id])
    if errores == true
      @unidad_produccion = UnidadProduccion.find(params[:unidad_produccion_id])
      @puerto_base_list = PuertoBase.find(:all, :conditions => ["unidad_produccion_id = ?", @unidad_produccion.id])
      render :update do |page|
        page.hide 'errorExplanation'
        page.replace_html 'cliente_empresa_unidad_produccion', :partial => 'puertos'
        page.replace_html 'message', I18n.t('Sistema.Body.General.guardar')
        page.show 'cliente_empresa_unidad_produccion'
        page.show 'message'
        page.<< "window.scrollTo(0,238);"
      end
    else
      render :update do |page|
        page.hide 'message'
        page.replace_html 'errorExplanation',"<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL>#{errores}</UL></p>"
        page.show 'errorExplanation'
        page.<< "document.getElementById('agregar_puerto').style.display= '';"
      end
    end
  end

  def delete
    @empresa = Empresa.find(params[:empresa_id])
    @unidad_produccion = UnidadProduccion.find(params[:id])
    total = 0
    total += Solicitud.count(:conditions=>"unidad_produccion_id = #{@unidad_produccion.id}")
    total += RegistroMercantil.count(:conditions=>"unidad_produccion_id = #{@unidad_produccion.id}")
    total += UtmUnidadProduccion.count(:conditions=>"unidad_produccion_id = #{@unidad_produccion.id}")
    total += PuertoBase.count(:conditions=>"unidad_produccion_id = #{@unidad_produccion.id}")
    if total > 0
      render :update do |page|
        page.alert(I18n.t('Sistema.Body.Modelos.UnidadProduccion.Errores.no_se_puede_eliminar'))
      end
    else
      identidad()
      form_delete @unidad_produccion
    end
  end

  def view
    _list

    form_list
    identidad()
  end

  def view_detail
    @unidad_produccion = UnidadProduccion.find(params[:id])
    @empresa = Empresa.find(@unidad_produccion.cliente.empresa_id)
    @puerto_base_list = PuertoBase.find(:all, :conditions => ["unidad_produccion_id = ?", @unidad_produccion.id])
    @utm_unidad_produccion_list = UtmUnidadProduccion.find(:all, :conditions=>["unidad_produccion_id = ?", @unidad_produccion.id])
    identidad()
  end

  def region_change
    estado_fill(params[:region_id])
    render :update do |page|
      page.replace_html 'estado-select', :partial => 'estado_select'
      page.replace_html 'municipio-select', :partial => 'municipio_select'
      page.replace_html 'ciudad-select', :partial => 'ciudad_select'
      page.replace_html 'parroquia-select', :partial => 'parroquia_select'
    end
  end

  def estado_change
    ciudad_fill(params[:estado_id])
    municipio_fill(params[:estado_id])
    render :update do |page|
      page.replace_html 'ciudad-select', :partial => 'ciudad_select'
      page.replace_html 'municipio-select', :partial => 'municipio_select'
      page.replace_html 'parroquia-select', :partial => 'parroquia_select'
    end
  end

  def municipio_change
    parroquia_fill(params[:municipio_id])
    render :update do |page|
      page.replace_html 'parroquia-select', :partial => 'parroquia_select'
    end
  end

  protected
  def common
    super
    @form_title = "#{I18n.t('Sistema.Body.General.beneficiario')} #{I18n.t('Sistema.Body.Vistas.General.juridico')}"
    @form_title_record = I18n.t('Sistema.Body.Vistas.General.unidad_produccion')
    @form_title_records = I18n.t('Sistema.Body.Vistas.General.unidad_produccion')
    @form_entity = 'unidad_produccion'
    @form_identity_field = 'nombre'
    @width_layout = '900'
  end

  private
  def _list
    @empresa = Empresa.find(params[:empresa_id])
    conditions = ["cliente_id = ?", @empresa.cliente_empresa.id]
    params['sort'] = "nombre" unless params['sort']
    
    @list = UnidadProduccion.search(conditions, params[:page], params['sort'])
    @total=@list.count
    @pages = @list.clone
  end

  def fill(region_id)
    if @unidad_produccion.nil?
      if @unidad_produccion.ciudad_id.blank?
        region_id = @unidad_produccion.ciudad.estado.region_id
      else
        region_id = 0
      end
    else
      region_id = 0
    end
    estado_fill(region_id)
  end

  def estado_fill(region_id)
    @estado_list = Estado.find(:all, :conditions=>['region_id = ?', region_id], :order=>'nombre')
    if @unidad_produccion && @unidad_produccion.estado_id
      estado_id = @unidad_produccion.ciudad.estado_id
    else
      estado_id = 0
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
    if @empresa.cliente_empresa.es_pescador == true
      @form_title = 'Comunidad Pesquera'
      @form_title_record = 'Comunidad Pesquera'
      @form_title_records = 'Comunidad Pesquera'
    end
  end

end
