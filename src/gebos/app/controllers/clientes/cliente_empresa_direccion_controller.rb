# encoding: utf-8
#
# autor: Luis Rojas
# clase: Clientes::ClienteEmpresaDireccionController
# descripción: Migración a Rails 3
#

class Clientes::ClienteEmpresaDireccionController < FormTabTabsController
  
  skip_before_filter :set_charset, :only=>[:region_change, :estado_change, :municipio_change]

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
    @empresa = Empresa.find(params[:empresa_id])    
    @empresa_direccion = EmpresaDireccion.new 
    @comunidad_indigena_list = ComunidadIndigena.find(:all, :order=>'comunidad_indigena')
    @region_select = Region.find(:all, :order=>'nombre')
    @estado_select = []
    @municipio_select = []
    @parroquia_select = []
    @ciudad_select = []
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
    @empresa = Empresa.find(params[:empresa_id])
    @empresa_direccion = EmpresaDireccion.find(params[:id])
    fill
  end
  
  def save_edit
    @empresa = Empresa.find(params[:empresa_id])
    @empresa_direccion = EmpresaDireccion.find(params[:id])    
    EmpresaDireccion.validate
    form_save_edit @empresa_direccion, :params=> { :id=>@empresa_direccion.id, :empresa_id => @empresa.id }
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

  def region_change
    region_id = params[:region_id]
    estado_fill(region_id)
    render :update do |page|
      page.replace_html 'estado-select', :partial => 'estado_select'.html_safe
      page.replace_html 'municipio-select', :partial => 'municipio_select'.html_safe
      page.replace_html 'ciudad-select', :partial => 'ciudad_select'.html_safe
      page.replace_html 'parroquia-select', :partial => 'parroquia_select'.html_safe
    end
  end

  def estado_change
    estado_id = params[:estado_id]
    ciudad_fill(estado_id)
    municipio_fill(estado_id)
    render :update do |page|
      page.replace_html 'ciudad-select', :partial => 'ciudad_select'.html_safe
      page.replace_html 'municipio-select', :partial => 'municipio_select'.html_safe
      page.replace_html 'parroquia-select', :partial => 'parroquia_select'.html_safe
    end
  end
  
  def municipio_change
    municipio_id = params[:municipio_id]
    
    parroquia_fill(municipio_id)
    render :update do |page|    
      page.replace_html 'parroquia-select', :partial => 'parroquia_select'
    end
  end

  protected  
  def common
    super
    @form_title = "#{I18n.t('Sistema.Body.General.beneficiario')} #{I18n.t('Sistema.Body.Vistas.General.juridico')}"
    @form_title_record = I18n.t('Sistema.Body.Vistas.General.ubicacion')
    @form_title_records = I18n.t('Sistema.Body.Vistas.General.ubicaciones')
    @form_entity = 'empresa_direccion'
    @form_identity_field = 'tipo_nombre'
    @width_layout = '955'
  end

  private
  def _list
    @empresa = Empresa.find(params[:empresa_id])
    conditions = ["empresa_direccion.empresa_id = ?", @empresa.id]
    params['sort'] = "empresa_direccion.tipo" unless params['sort']
    
    @list = EmpresaDireccion.search(conditions, params[:page], params['sort'])
    @total=@list.count
  end
  
  def fill
    @region_select = Region.find(:all, :order=>'nombre')
    if @empresa_direccion.ciudad
      region_id = @empresa_direccion.region_id
    else
      region_id = @region_select[0].id
    end
    estado_fill(region_id)
  end

  def estado_fill(region_id)
    @estado_select = Estado.find(:all, :conditions=>['region_id = ?', region_id], :order=>'nombre')
    unless @empresa_direccion.nil?
      if @empresa_direccion.ciudad
        estado_id = @empresa_direccion.ciudad.estado.id
      else
        estado_id = 0
      end
    else
      estado_id = 0
    end
    ciudad_fill(estado_id)
    municipio_fill(estado_id)
  end

  def municipio_fill(estado_id)
    @municipio_select = Municipio.find(:all, :conditions=>['estado_id = ?', estado_id], :order=>'nombre')
    unless @empresa_direccion.nil?
      unless @empresa_direccion.ciudad.nil?
        municipio_id = @empresa_direccion.parroquia.municipio_id
      else
        municipio_id = 0
      end
    else
      municipio_id = 0
    end
    parroquia_fill(municipio_id)
  end
  
  def ciudad_fill(estado_id)
    @ciudad_select = Ciudad.find(:all, :conditions=>"estado_id = #{estado_id}", :order=>'nombre')
  end
  
  def parroquia_fill(municipio_id)
    @parroquia_select = Parroquia.find(:all, :conditions=>"municipio_id = #{municipio_id}", :order=>'nombre')
  end

end
