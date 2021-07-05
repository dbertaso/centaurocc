# encoding: UTF-8

#
# autor: Marvin Alfonzo
# clase: Basico::CasaProveedoraController
# descripción: Migración a Rails 3
#
class Basico::CasaProveedoraController < FormTabsController
   
   skip_before_filter :set_charset, :only=>[:ciudad_search, :municipio_search, :parroquia_search, :tabs]
   
   
  def index     
     @estado = Estado.find(:all, :order=>'nombre')
  end

  def list
    
    params['sort'] = "casa_proveedora.nombre" unless params['sort']
    conditions =""
    unless params[:nombre].nil? || params[:nombre].blank?
      conditions = ["LOWER(casa_proveedora.nombre) LIKE ?", "%"<<params[:nombre].strip.downcase<<"%"]
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.nombre')} '#{params[:nombre]}'"
    end
        
    unless params[:estado_id].nil? || params[:estado_id].blank?
      if params[:estado_id][0].to_s.to_i!=0
        conditions = ["estado_id = ?", params[:estado_id][0].to_s.to_i]
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.estado_igual')} '#{Estado.find(params[:estado_id][0]).nombre}'"
      end      
    end
    
    unless params[:rif].nil? || params[:rif].blank?
      conditions = ["LOWER(casa_proveedora.rif) LIKE ?", "%"<<params[:rif].strip.downcase<<"%"]
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.rif_igual')} '#{params[:rif]}'"
    end    
    
    
	@list = CasaProveedora.search(conditions, 
                            params[:page], 
                            params['sort'])
    @total=@list.count
    form_list

  end

  def view
    @casa_proveedora = CasaProveedora.find(params[:id])
    @estado= Estado.find(:all)
  end
 
  def new
    fill_casa_proveedora
    @casa_proveedora = CasaProveedora.new
  end

  def save_new
    @casa_proveedora = CasaProveedora.new(params[:casa_proveedora])    
    form_save_new @casa_proveedora
  end
  
  def delete
    @casa_proveedora = CasaProveedora.find(params[:id])
    form_delete @casa_proveedora
  end
  
  def edit
    fill_casa_proveedora
    @casa_proveedora    = CasaProveedora.find(params[:id])    
    @ciudad             = Ciudad.find(:all,:conditions=>"estado_id = #{@casa_proveedora.estado_id}", :order=>'nombre')
    @municipio          = Municipio.find(:all, :conditions=>"estado_id = #{@casa_proveedora.estado_id}", :order=>"nombre")
    @parroquia          = Parroquia.find(:all,:conditions=>"municipio_id=#{@casa_proveedora.municipio_id}", :order=>'nombre')    
  end
  
  def save_edit
    @casa_proveedora = CasaProveedora.find(params[:id])
    
    if params[:casa_proveedora][:tipo_pago].to_i==2      
      @casa_proveedora.tipo_cuenta=""
      @casa_proveedora.numero_cuenta=""
      @casa_proveedora.entidad_financiera_id=""
    end
    form_save_edit @casa_proveedora
  end
  
  def ciudad_search
    
    if params[:id].to_s ==''
      @estado = []
      @ciudad = [] 
      @municipio = [] 
      @parroquia = []
    else
      @ciudad = Ciudad.find_by_sql("select id,nombre from ciudad where estado_id = #{params[:id].to_s} order by nombre")    
      @municipio = [] 
      @parroquia = []
    end    
    render :update do |page|
      page.replace_html 'ciudad-search', :partial => 'ciudad_search'
      page.replace_html 'municipio-search', :partial => 'municipio_search'
      page.replace_html 'parroquia-search', :partial => 'parroquia_search'
      
    end
  end

  def municipio_search
    
    if params[:id].to_s ==''      
      @ciudad = [] 
      @municipio = []
      @parroquia = []      
    else
      @municipio = Municipio.find_by_sql("select id,nombre from municipio where estado_id =(select estado_id from ciudad where id = #{params[:id].to_s}) order by nombre")    
      @parroquia = []      
    end       
    render :update do |page|
      page.replace_html 'municipio-search', :partial => 'municipio_search'
      page.replace_html 'parroquia-search', :partial => 'parroquia_search'
    end
  end

  def parroquia_search
    
    if params[:id].to_s ==''      
      @municipio = []
      @parroquia = []
    else
      @parroquia = Parroquia.find_by_sql("select id,nombre from parroquia where municipio_id = #{params[:id].to_s} order by nombre")
    end           
    render :update do |page|
      page.replace_html 'parroquia-search', :partial => 'parroquia_search'
    end
  end

  protected
  def common
    super
    @form_title_search   = I18n.t('Sistema.Body.Controladores.CasaProveedora.FormTitles.form_title')
    @form_title          = I18n.t('Sistema.Body.Controladores.CasaProveedora.FormTitles.form_title')
    @form_title_record   = I18n.t('Sistema.Body.Controladores.CasaProveedora.FormTitles.form_title')
    @form_title_records  = I18n.t('Sistema.Body.Controladores.CasaProveedora.FormTitles.form_title_records')
    @form_entity         = 'casa_proveedora'
    @form_identity_field = 'nombre'
    @width_layout        = '800'
  end
  
  private
  def fill_casa_proveedora    
    @estado = Estado.find(:all, :order=>'nombre')
    @entidad_financiera = EntidadFinanciera.find(:all, :order=>'nombre')
    @ciudad             = []
    @municipio          = []
    @parroquia          = []    
  end

end
