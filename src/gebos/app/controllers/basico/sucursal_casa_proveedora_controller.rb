# encoding: UTF-8

#
# autor: Marvin Alfonzo
# clase: Basico::SucursalCasaProveedoraController
# descripción: Migración a Rails 3
#

class Basico::SucursalCasaProveedoraController < FormAjaxTabsController

  skip_before_filter :set_charset, :only=>[:ciudad_search, :municipio_search, :parroquia_search, :region_search, :tabs]

  def list    
    
    @visita = params[:id]
    params['sort'] = "nombre" unless params['sort']        
    conditions = ["casa_proveedora_id = ?", params[:casa_proveedora_id]]   
	@list = SucursalCasaProveedora.search(conditions, 
                            params[:page], 
                            params['sort'])
    @total=@list.count    

    form_list
  end

  def index     
     list
  end

  def region_search
    
    if params[:id].to_s ==''		
		@municipio_list=[]
		@parroquia_list =[]
		@ciudad_list = []
    else      
		@ciudad_list = Ciudad.find_by_sql("select nombre, id, estado_id from ciudad where estado_id in (select id from estado where region_id = #{params[:id].to_s} order by nombre) order by estado_id")
        @municipio_list=[]
		@parroquia_list =[]		
	end
    
    render :update do |page|
      page.replace_html 'ciudad-search', :partial => 'ciudad_search'
      page.replace_html 'municipio-search', :partial => 'municipio_search'
      page.replace_html 'parroquia-search', :partial => 'parroquia_search'
    end
  end


  def ciudad_search
    if params[:id].to_s ==''		
		@ciudad_list=[]
		@parroquia_list =[]
		@municipio_list=[]
    else      
		@ciudad_list=[]
		@parroquia_list =[]
        @municipio_list = Municipio.find_by_sql("select nombre, id from municipio where estado_id in (select estado_id from ciudad where id = #{params[:id].to_s} order by nombre) order by nombre")
    end
    
    render :update do |page|
      page.replace_html 'municipio-search', :partial => 'municipio_search'
      page.replace_html 'parroquia-search', :partial => 'parroquia_search'
    end
  end


  def municipio_search
    if params[:id].to_s ==''		
		@parroquia_list =[]
		@municipio_list=[]		
    else      
		@parroquia_list = Parroquia.find_by_sql("SELECT id, nombre FROM parroquia where municipio_id = #{params[:id].to_s} order by nombre")
    end
    render :update do |page|      
		@municipio_list=[]		
      page.replace_html 'parroquia-search', :partial => 'parroquia_search'
    end
  end

  def new
    fill_region
    @sucursal_casa_proveedora = SucursalCasaProveedora.new
    form_new @sucursal_casa_proveedora  
  end

  def save_new
   
    @id_casa_proveedora=params[:id]
   
    @sucursal_casa_proveedora = SucursalCasaProveedora.new(params[:sucursal_casa_proveedora])
    @sucursal_casa_proveedora.casa_proveedora_id=@id_casa_proveedora
    
    form_save_new @sucursal_casa_proveedora
  end

  def delete
    @sucursal_casa_proveedora = SucursalCasaProveedora.find(params[:id])
    form_delete @sucursal_casa_proveedora
  end

  def edit
    fill_region
    @sucursal_casa_proveedora = SucursalCasaProveedora.find(params[:id])
    @ciudad_list = Ciudad.find_by_sql("select nombre, id, estado_id from ciudad where id in (select id from ciudad where estado_id in (select id from estado where region_id=#{@sucursal_casa_proveedora.region_id})) order by estado_id")
    @municipio_list = Municipio.find_by_sql("select nombre, id from municipio where estado_id in (select id from estado where region_id=#{@sucursal_casa_proveedora.region_id}) order by nombre")
    @parroquia_list = Parroquia.find_by_sql("SELECT id, nombre FROM parroquia where municipio_id = #{@sucursal_casa_proveedora.municipio_id} order by nombre")    
    
    form_edit @sucursal_casa_proveedora  
  end

  def save_edit
    @sucursal_casa_proveedora = SucursalCasaProveedora.find(params[:id])
    form_save_edit @sucursal_casa_proveedora
  end

  def cancel_new
    form_cancel_new
  end

  def cancel_edit
    @sucursal_casa_proveedora = SucursalCasaProveedora.find(params[:id])
    form_cancel_edit @sucursal_casa_proveedora
  end

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.SucursalCasaProveedora.FormTitles.form_title_records')
    @form_title_record = I18n.t('Sistema.Body.Controladores.SucursalCasaProveedora.FormTitles.form_title')
    @form_title_records = I18n.t('Sistema.Body.Controladores.SucursalCasaProveedora.FormTitles.form_title_records')
    @form_entity = 'sucursal_casa_proveedora'
    @form_identity_field = 'nombre'
    @width_layout = '955'
  end

  
  def fill_region
   @region_list = Region.find(:all, :order=>'nombre')
   @municipio_list  = []
   @ciudad_list  = []
   @parroquia_list  = []
  end

end

