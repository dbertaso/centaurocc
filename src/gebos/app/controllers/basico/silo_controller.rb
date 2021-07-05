# encoding: utf-8
class Basico::SiloController < FormTabsController
  
  skip_before_filter :set_charset, :only=>[:estado_change, :tabs ]

  def index
    fill() 
    list()
  end
	
  def list
    params['sort'] = "silo.nombre" unless params['sort']
    conditions = 'id > 0'
    
    @list = Silo.search(conditions, params[:page], params[:sort])
    @total=@list.count
    form_list
  end
	
  def new
    fill()
    @silo = Silo.new
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def save_new
    nombre = eliminar_acentos(params[:silo][:nombre])
    params[:silo][:nombre] = nombre.upcase
    persona_contacto = eliminar_acentos(params[:silo][:persona_contacto])
    params[:silo][:persona_contacto] = persona_contacto.upcase
    fecha = Time.now.strftime("%Y-%m-%d")
    params[:silo][:fecha_registro] = fecha
    @silo = Silo.new(params[:silo])
    @silo.rif = params[:silo][:rif_1] + '-' + params[:silo][:rif_2] + '-' + params[:silo][:rif_3]
		form_save_new @silo
  end
  
  def delete
    @silo = Silo.find(params[:id])
    result = @silo.eliminar(params[:id])
    if result == false
      render :update do |page|
        page.form_error
      end
      return
    else
      render :update do |page|
        page.form_delete @silo, 'silo'
      end
    end
  end
  
  def edit
    fill()
    @silo = Silo.find(params[:id])
  end

  def save_edit
    @silo = Silo.find(params[:id])
		form_save_edit @silo

  end

  def cancel_edit
    @silo = Silo.find(params[:id])
		form_cancel_edit @silo
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
  
  def fill
    @estado_select = Estado.find(:all, :order=>'nombre')
    if @estado_select.length == 0
      @estado_select = []
    end 

    @ciudad_select = Ciudad.find(:all, :order=>'nombre')
    
    if @ciudad_select.length == 0
      @ciudad_select = []
    end

    @municipio_select = Municipio.find(:all, :order=>'nombre')
    
    if @municipio_select.length == 0
      @municipio_select = []
    end 
  end
  
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.Silo.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.Silo.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.Silo.FormTitles.form_title_records')
    @form_entity = 'silo'
    @form_identity_field = 'nombre'
    @width_layout = '850'
  end
  
end
