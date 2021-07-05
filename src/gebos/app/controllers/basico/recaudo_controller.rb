# encoding: utf-8
class Basico::RecaudoController < FormAjaxController
  
  skip_before_filter :set_charset, :only=>[:sector_change]

	def index
		list
	end
	
  def list

    params['sort'] = "recaudo.nombre" unless params['sort']
    conditions = "id > 0"
    
    @list = Recaudo.search(conditions, params[:page], params[:sort])
    @total=@list.count

    form_list

  end
	
  def new
    @recaudo = Recaudo.new
    @sector_list = Sector.find(:all, :order=>'nombre')
    @sub_sector_list = []
		form_new @recaudo
  end
  
  def sector_change
    @sub_sector_list = SubSector.find(:all, :conditions => "sector_id = #{params[:sector_id]}")
    render :update do |page|
      page.replace_html 'sub-sector-select', :partial => 'sub_sector_select'
      page.show 'sub-sector-select'
    end
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def save_new
    @recaudo = Recaudo.new(params[:recaudo])
    @recaudo.fecha_actualizacion = Time.now
    form_save_new @recaudo
  end
  
  def delete
    @recaudo = Recaudo.find(params[:id])
    form_delete @recaudo
  end
  
  def edit
    @recaudo = Recaudo.find(params[:id])
    @sector_list = Sector.find(:all, :order=>'nombre')
    @sub_sector_list = SubSector.find(:all, :conditions => "sector_id = #{@recaudo.sector_id}")
    form_edit @recaudo
  end
  
  def save_edit
    @recaudo = Recaudo.find(params[:id])
    @recaudo.fecha_actualizacion = Time.now
    form_save_edit @recaudo
  end
  
  def cancel_edit
    @recaudo = Recaudo.find(params[:id])
    form_cancel_edit @recaudo
  end
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.Recaudo.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.Recaudo.FormTitles.form_title')
    @form_title_records = I18n.t('Sistema.Body.Controladores.Recaudo.FormTitles.form_title_records')
    @form_entity = 'recaudo'
    @form_identity_field = 'nombre'
    @width_layout = '970'
  end
  
end
