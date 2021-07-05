# encoding: utf-8
class Sistema::OficinaController < FormClassicController
  
  skip_before_filter :set_charset, :only=>[:estado_change, :tabs ]

  def index

  end
  
  def list
    conditions = "oficina.empresa_sistema_id = #{@usuario.empresa_sistema_id}"
    params['sort'] = "oficina.nombre" unless params['sort']
    unless params[:nombre].blank?
      conditions << " AND LOWER(oficina.nombre) LIKE '%#{params[:nombre].strip.downcase}%'"
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.nombre')} '#{params[:nombre]}'"
    end
    
    joins = ["INNER JOIN ciudad ON oficina.ciudad_id = ciudad.id INNER JOIN municipio ON oficina.municipio_id = municipio.id"]
    
    @list = Oficina.search(conditions, params[:page], params[:sort], joins)
    @total=@list.count
    form_list
  end
	
  def new
    @oficina = Oficina.new
    fill
  end
  
  def save_new
    @oficina = Oficina.new(params[:oficina])
    @oficina.nuevos_departamentos = params[:departamentos]
    @oficina.empresa_sistema_id = @usuario.empresa_sistema_id
    form_save_new @oficina
  end
  
  def delete
    @oficina = Oficina.find(params[:id])
       # @rubro = Rubro.find(params[:id])
    result = @oficina.eliminar(params[:id])
    if result == false
      render :update do |page|
        page.form_error
      end
      return
    else
      render :update do |page|
        page.form_delete @oficina, 'oficina'
      end
    end
#    form_delete @oficina
  end
  
  def edit
    @oficina = Oficina.find(params[:id])
    fill
  end
  
  def view
    @oficina = Oficina.find(params[:id])
    departamento_fill
  end
  
  def save_edit
    @oficina = Oficina.find(params[:id])
    @oficina.nuevos_departamentos = params[:departamentos]
    form_save_edit @oficina
  end
    
  def estado_change
    estado_id = params[:estado_id]
    municipio_fill(estado_id)
    ciudad_fill(estado_id)
    render :update do |page|    
      page.replace_html 'municipio-select', :partial => 'municipio_select'
      page.replace_html 'ciudad-select', :partial => 'ciudad_select'
    end
  end
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.Oficina.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.Oficina.FormTitles.form_title_record') 
    @form_title_records = I18n.t('Sistema.Body.Controladores.Oficina.FormTitles.form_title_records')
    @form_entity = 'oficina'
    @form_identity_field = 'nombre'
  end
  
  private
  def fill
    @estado_list = Estado.find_all_by_pais_id(1, :order=>'nombre')
    departamento_fill
    if @oficina.ciudad
      estado_id = @oficina.ciudad.estado_id
    else
      estado_id = @estado_list.first.id if @estado_list.first
    end
    if action_name == 'new'
      ciudad_fill(nil)
      municipio_fill(nil)
    else
      ciudad_fill(estado_id)
      municipio_fill(estado_id)
    end
  end
  
  def departamento_fill
    @departamento_list = Departamento.find(:all, :order=>'nombre')
  end
  
  def municipio_fill(estado_id)
    unless estado_id.blank?
      @municipio_list = Municipio.find_all_by_estado_id(estado_id, :order=>'nombre')
    else
      @municipio_list = []
    end
  end
  
  def ciudad_fill(estado_id)
    unless estado_id.blank?
      @ciudad_list = Ciudad.find_all_by_estado_id(estado_id, :order=>'nombre')
    else
      @ciudad_list = []
    end
    
  end
  
end
