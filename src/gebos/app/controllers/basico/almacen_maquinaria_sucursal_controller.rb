# encoding: utf-8

# autor: Luis Rojas
# clase: Basico::AlmacenMaquinariaSucursalController
# descripción: Migración a Rails 3

class Basico::AlmacenMaquinariaSucursalController < FormAjaxTabsController
  
  skip_before_filter :set_charset, :only=>[:estado_change]

  def index
    @almacen_maquinaria = AlmacenMaquinaria.find(params[:almacen_maquinaria_id])
    list
  end

  def list
    params['sort'] = "almacen_maquinaria_sucursal.nombre" unless params['sort']
    
    conditions = "almacen_maquinaria_id = #{params[:almacen_maquinaria_id]}"
    
    @list = AlmacenMaquinariaSucursal.search(conditions, params[:page], params[:sort])
    @total=@list.count
    @pages = @list.clone
    
    form_list
  end

  def new
    fill(nil)
    @almacen_maquinaria = AlmacenMaquinaria.find(params[:almacen_maquinaria_id])    
    @almacen_maquinaria_sucursal = AlmacenMaquinariaSucursal.new
		form_new @almacen_maquinaria_sucursal
  end
  
  def save_new
    @almacen_maquinaria = AlmacenMaquinaria.find(params[:almacen_maquinaria_id])
    @almacen_maquinaria_sucursal = AlmacenMaquinariaSucursal.new(params[:almacen_maquinaria_sucursal])
    @almacen_maquinaria_sucursal.almacen_maquinaria_id = @almacen_maquinaria.id
    form_save_new @almacen_maquinaria_sucursal
  end
  
  def edit
    @almacen_maquinaria = AlmacenMaquinaria.find(params[:almacen_maquinaria_id])    
    @almacen_maquinaria_sucursal = AlmacenMaquinariaSucursal.find(params[:id])
    fill(@almacen_maquinaria_sucursal.estado_id)
		form_edit @almacen_maquinaria_sucursal
  end
  
  def estado_change
    @ciudad_select = Ciudad.find(:all, :conditions=>"estado_id = #{params[:id]}", :order=> "nombre")
    @municipio_select = Municipio.find(:all, :conditions=>"estado_id = #{params[:id]}", :order=> "nombre")   
    render :update do |page|
      page.replace_html 'ciudad-select', :partial => 'ciudad_select'
      page.replace_html 'municipio-select', :partial => 'municipio_select'
    end
  end

  def cancel_edit
    @almacen_maquinaria_sucursal = AlmacenMaquinariaSucursal.find(params[:id])
    form_cancel_edit @almacen_maquinaria_sucursal
  end
  
  def save_edit
    @almacen_maquinaria = AlmacenMaquinaria.find(params[:almacen_maquinaria_id])    
    @almacen_maquinaria_sucursal = AlmacenMaquinariaSucursal.find(params[:id])
    form_save_edit @almacen_maquinaria_sucursal
  end
  
  def cancel_new
		form_cancel_new
  end
  
   def delete
    @almacen_maquinaria_sucursal = AlmacenMaquinariaSucursal.find(params[:id])
    form_delete @almacen_maquinaria_sucursal
  end
  
  protected
  def common
    super
    @form_title = "#{I18n.t('Sistema.Body.Controladores.AlmacenMaquinaria.FormTitles.form_title')} - #{I18n.t('Sistema.Body.Vistas.General.sucursales')}"
    @form_title_record = I18n.t('Sistema.Body.Vistas.General.sucursal')
    @form_title_records = I18n.t('Sistema.Body.Vistas.General.sucursales')
    @form_entity = 'almacen_maquinaria_sucursal'
    @form_identity_field = 'nombre'
    @width_layout = '890'
  end
  
  private
  def fill(estado_id)
    @estado_select = Estado.find(:all, :order=>'nombre')
    
    if @estado_select.length == 0
       @estado_select = []
    end 
    
    if estado_id.nil?
      @ciudad_select = []
      @municipio_select = []
    else
      @ciudad_select = Ciudad.find(:all, :conditions => "estado_id = #{estado_id}", :order => "nombre")
      @municipio_select = Municipio.find(:all, :conditions => "estado_id = #{estado_id}", :order => "nombre")
    end
  end
end