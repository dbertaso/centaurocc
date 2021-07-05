# encoding: utf-8
class Basico::SitioColocacionController < FormAjaxController

	def index
		list
	end
	
  def list
    params['sort'] = "sitio" unless params['sort']
    conditions = 'id > 0'
    
    @list = SitioColocacion.search(conditions, params[:page], params[:sort])
    @total=@list.count
    form_list
  end
	
  def new
    @sitio_colocacion = SitioColocacion.new
		form_new @sitio_colocacion
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def save_new
    @sitio_colocacion = SitioColocacion.new(params[:sitio_colocacion])
		form_save_new @sitio_colocacion
  end
  
  def delete
    @sitio_colocacion = SitioColocacion.find(params[:id])
		form_delete @sitio_colocacion
  end
  
  def edit
    @sitio_colocacion = SitioColocacion.find(params[:id])
		form_edit @sitio_colocacion
  end

  def save_edit
    @sitio_colocacion = SitioColocacion.find(params[:id])
		form_save_edit @sitio_colocacion
  end

  def cancel_edit
    @sitio_colocacion = SitioColocacion.find(params[:id])
		form_cancel_edit @sitio_colocacion
  end
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.SitioColocacion.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.SitioColocacion.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.SitioColocacion.FormTitles.form_title_records')
    @form_entity = 'sitio_colocacion'
    @form_identity_field = 'sitio'
  end
  
end
