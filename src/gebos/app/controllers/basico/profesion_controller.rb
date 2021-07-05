# encoding: utf-8
class Basico::ProfesionController < FormAjaxController

	def index
		list
	end
	
  def list

    params['sort'] = "nombre" unless params['sort']
    conditions = "id > 0"
    
    @list = Profesion.search(conditions, params[:page], params[:sort])
    @total=@list.count

    form_list

  end
	
  def new
    @profesion = Profesion.new
		form_new @profesion
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def save_new
    @profesion = Profesion.new(params[:profesion])
    form_save_new @profesion
  end
  
  def delete
    @profesion = Profesion.find(params[:id])
    form_delete @profesion
  end
  
  def edit
    @profesion = Profesion.find(params[:id])
    form_edit @profesion
  end
  def save_edit
    @profesion = Profesion.find(params[:id])
    form_save_edit @profesion
  end
  def cancel_edit
    @profesion = Profesion.find(params[:id])
    form_cancel_edit @profesion
  end
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.Profesion.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.Profesion.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.Profesion.FormTitles.form_title')
    @form_entity = 'profesion'
    @form_identity_field = 'nombre'
  end
  
end
