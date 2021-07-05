# encoding: utf-8

# autor: Luis Rojas
# clase: Basico::AlmacenMaquinariaController
# descripción: Migración a Rails 3

class Basico::AlmacenMaquinariaController < FormAjaxController

   skip_before_filter :set_charset, :only=>[:estado_change]

	def index		
		list
	end
	
  def list
    params['sort'] = "nombre" unless params['sort']
    
    conditions = 'id > 0'
    
    
    @list = AlmacenMaquinaria.search(conditions, params[:page], params[:sort])
    @total=@list.count
    @pages = @list.clone
    form_list
  end
	
  def new
    fill
    @almacen_maquinaria = AlmacenMaquinaria.new
    @almacen_maquinaria.activo = true
		form_new @almacen_maquinaria
  end
  
  def cancel_new
		form_cancel_new
  end

  def save_new
    @almacen_maquinaria = AlmacenMaquinaria.new(params[:almacen_maquinaria])
    @almacen_maquinaria.rif = params[:almacen_maquinaria][:rif_1] + '-' + params[:almacen_maquinaria][:rif_2] + '-' + params[:almacen_maquinaria][:rif_3]
		form_save_new @almacen_maquinaria
  end
  
  def delete
    @almacen_maquinaria = AlmacenMaquinaria.find(params[:id])
    result = @almacen_maquinaria.eliminar(params[:id])
    if result == false
      render :update do |page|
        page.form_error
      end
      return
    else
      render :update do |page|
        page.form_delete @almacen_maquinaria, 'almacen_maquinaria'
      end
    end
  end
  
  def edit
    fill
    @almacen_maquinaria = AlmacenMaquinaria.find(params[:id])
    @ciudad_select = Ciudad.find(:all,:conditions=>"id = #{@almacen_maquinaria.ciudad_id}", :order=>'nombre')    
    @municipio_select = Municipio.find(:all,:conditions=>"id = #{@almacen_maquinaria.municipio_id}", :order=>'nombre')
    render  :layout => 'form_basic'
  end
  
  def save_edit
    @almacen_maquinaria = AlmacenMaquinaria.find(params[:id])
		form_save_edit @almacen_maquinaria
  end
  
  def cancel_edit
    @almacen_maquinaria = AlmacenMaquinaria.find(params[:id])
		form_cancel_edit @almacen_maquinaria
  end
  
  def estado_change    
    @ciudad_select = Ciudad.find(:all, :conditions=>"estado_id = #{params[:id]}", :order=> "nombre")
    @municipio_select = Municipio.find(:all, :conditions=>"estado_id = #{params[:id]}", :order=> "nombre")   
    render :update do |page|
      page.replace_html 'ciudad-select', :partial => 'ciudad_select'
      page.replace_html 'municipio-select', :partial => 'municipio_select'
    end
  end
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.AlmacenMaquinaria.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.AlmacenMaquinaria.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.AlmacenMaquinaria.FormTitles.form_title_records')
    @form_entity = 'almacen_maquinaria'
    @form_identity_field = 'nombre'
    @width_layout = '1000'
  end
  
  def fill
    @estado_select = Estado.find(:all, :order=>'nombre')   
	@ciudad_select = []    	
	@municipio_select = []  
  end
  
end
