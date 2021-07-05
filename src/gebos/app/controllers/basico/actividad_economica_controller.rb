class Basico::ActividadEconomicaController < FormAjaxController

  def index
    list

  end

  def list

    @params['sort'] = "actividad_economica.descripcion" unless @params['sort']

    conditions=''
    #@total = ActividadEconomica.count()
    #@pages, @list = paginate(:actividad_economica, :class_name => 'ActividadEconomica',
     #:include =>'sector_economico',
     #:per_page => @records_by_page,
     #:select=>'sector_economico.*',
     #:order_by => @params['sort'])
     
    @list = ActividadEconomica.search(conditions, params[:page], params[:sort])
    @total=@list.count
     
    form_list

  end

  def new
    fill_sector_economico
    @actividad_economica = ActividadEconomica.new
    form_new @actividad_economica
  end

  def cancel_new
    form_cancel_new
  end

  def save_new
    @actividad_economica = ActividadEconomica.new(params[:actividad_economica])
    form_save_new @actividad_economica
  end

  def delete
    @actividad_economica = ActividadEconomica.find(params[:id])
    form_delete @actividad_economica
  end

  def edit
    fill_sector_economico
    @actividad_economica = ActividadEconomica.find(params[:id])
    fill_sector_tipo(@actividad_economica.sector_economico_id)
     form_edit @actividad_economica
  end

  def save_edit
    @actividad_economica = ActividadEconomica.find(params[:id])
    form_save_edit @actividad_economica
  end

  def sector_economico_change
    fill_sector_tipo(params[:sector_economico_id])
    render :update do |page|
      page.replace_html 'sector-tipo-select', :partial => 'sector_tipo_select'
    end
  end

  def cancel_edit
    @actividad_economica = ActividadEconomica.find(params[:id])
    form_cancel_edit @actividad_economica
  end

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.ActividadEconomica.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.ActividadEconomica.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.ActividadEconomica.FormTitles.form_title_records')
    @form_entity = 'actividad_economica'
    @form_identity_field = 'descripcion'
    @width_layout = '960'
  end

   private
  def fill_sector_economico
   @sector_economico_list = SectorEconomico.find(:all, :conditions=>'activo = true and id <> 1000', :order=>'descripcion')
   fill_sector_tipo(@sector_economico_list.first.id)
  end

  def fill_sector_tipo(sector_economico_id)
    @sector_tipo_list = SectorTipo.find(:all, :conditions=>['id = 1 or sector_economico_id = ?',sector_economico_id], :order=>'nombre')
  end

end

