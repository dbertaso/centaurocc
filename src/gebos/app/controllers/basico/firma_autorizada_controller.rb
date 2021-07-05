class Basico::FirmaAutorizadaController < FormTabsController
  
  def list
    
    params['sort'] = "firma_autorizada.nombre" unless params['sort']

    puts "PARAMETROS ==========> " << params.inspect
    unless params[:nombre].nil?
      conditions = ["LOWER(firma_autorizada.nombre) LIKE ?", "%#{params[:nombre].strip.downcase}%"]
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.nombre')} '#{params[:nombre]}'"
    end
    
    unless params[:cedula].nil?
      conditions = ["LOWER(firma_autorizada.cedula) LIKE ?", "%#{params[:cedula].strip.downcase}%"]
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.codigo')} '#{params[:cedula]}'"
    end
    
    unless params[:cargo].nil?
      conditions = ["cargo_id = ?", params[:cargo][0].to_i]
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.cargo')} '#{params[:cargo][0].to_s}'"
    end
    
    
 
    @list = FirmaAutorizada.search(conditions, params[:page], params[:sort])
    @total=@list.count


    form_list

  end

  def index
    fill_cargo
  end
 
  def new
    fill_cargo
    @firma_autorizada = FirmaAutorizada.new
  end

  def save_new
    @firma_autorizada = FirmaAutorizada.new(params[:firma_autorizada])
    form_save_new @firma_autorizada
  end
  
  def delete
    @firma_autorizada = FirmaAutorizada.find(params[:id])
    form_delete @firma_autorizada
  end
  
  def edit
    fill_cargo
   @firma_autorizada = FirmaAutorizada.find(params[:id])
  end
  
  def save_edit
    @firma_autorizada = FirmaAutorizada.find(params[:id])
    form_save_edit @firma_autorizada
  end

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.FirmaAutorizada.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.FirmaAutorizada.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.FirmaAutorizada.FormTitles.form_title_records')
    @form_entity = 'firma_autorizada'
    @form_identity_field = 'nombre'
    @width_layout = '800'
  end
  
  private
  def fill_cargo
   @cargo_list = Cargo.find(:all, :order=>'descripcion')
  end

end
