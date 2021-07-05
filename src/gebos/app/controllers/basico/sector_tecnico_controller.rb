# encoding: utf-8
class Basico::SectorTecnicoController < FormAjaxTabsController
  
  skip_before_filter :set_charset, :only=>[:tabs ]

  def index
    fill_sector_tecnico
    @tecnico_campo = TecnicoCampo.find(params[:tecnico_campo_id])
    list
  end
  
  def view
    fill_sector_tecnico
    @tecnico_campo = TecnicoCampo.find(params[:tecnico_campo_id])
    list
  end
   
  

  def new
    fill_sector_tecnico
    @tecnico_campo =  TecnicoCampo.find(params[:tecnico_campo_id])    
    @sector_tecnico = SectorTecnico.new
		form_new @sector_tecnico
  end
  
  def save_new
    @tecnico_campo = TecnicoCampo.find(params[:tecnico_campo_id])
    @sector_tecnico = SectorTecnico.new(params[:sector_tecnico])
    @sector_tecnico.tecnico_campo_id = @tecnico_campo.id
    form_save_new @sector_tecnico
  end
  
  def edit
    fill_sector_tecnico
    @tecnico_campo = TecnicoCampo.find(params[:tecnico_campo_id])
    @sector_tecnico = SectorTecnico.find(params[:id])
		form_edit @sector_tecnico
	
  end

  def cancel_edit
    @sector_tecnico = SectorTecnico.find(params[:id])
    form_cancel_edit @sector_tecnico
  end
  
  def save_edit
    @tecnico_campo =TecnicoCampo.find(params[:tecnico_campo_id])
    @sector_tecnico = SectorTecnico.find(params[:id])
    form_save_edit @sector_tecnico
  end
  
  def cancel_new
		form_cancel_new
  end
  
 
  def delete
    @tecnico_campo = TecnicoCampo.find(params[:tecnico_campo_id])
    @sector_tecnico = SectorTecnico.find(params[:id])
    form_delete @sector_tecnico
  end
  
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.SectorTecnico.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.SectorTecnico.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.SectorTecnico.FormTitles.form_title_records')
    @form_entity = 'sector_tecnico'
    @form_identity_field = 'sector.nombre'
    @width_layout = '890'
  end
  
  private
     
  def fill_sector_tecnico
    @sector = Sector.find(:all, :order=>'nombre')
  end

  def list
    fill_sector_tecnico
    @tecnico_campo = TecnicoCampo.find(params[:tecnico_campo_id])
    conditions = ["sector_tecnico.tecnico_campo_id = ?", @tecnico_campo.id]
    params['sort'] = "sector_id" unless params['sort']
    
    @list = SectorTecnico.search(conditions, params[:page], params[:sort])
    @total=@list.count
#    @pages, @list = paginate(:sector_tecnico, :class_name => 'SectorTecnico',
#      :conditions => conditions,
#      :per_page => @records_by_page,
#      :select=>'*',
#      :order_by => @params['sort'])
    form_list
  end
 
end
