# encoding: utf-8
class Basico::PeritoController < FormAjaxController

	def index
		list
	end
	
  def list
    params['sort'] = "primer_nombre" unless params['sort']
    conditions = "id > 0"
    
    @list = Perito.search(conditions, params[:page], params[:sort])
    @total=@list.count

    form_list
  end
	
  def new
    @perito = Perito.new
		form_new @perito
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def save_new
    @perito = Perito.new(params[:perito])
    form_save_new @perito
  end
  
  def delete
    @perito = Perito.find(params[:id])
    form_delete @perito
  end
  
  def edit
    @perito = Perito.find(params[:id])
     form_edit @perito
  end
  def save_edit
    @perito = Perito.find(params[:id])
    form_save_edit @perito
  end
  def cancel_edit
    @perito = Perito.find(params[:id])
    form_cancel_edit @perito
  end
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.Perito.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.Perito.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.Perito.FormTitles.form_title')
    @form_entity = 'perito'
    @form_identity_field = 'nombre_corto'
  end
  
end
