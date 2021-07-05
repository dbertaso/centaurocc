# encoding: UTF-8

#
# autor: Marvin Alfonzo
# clase: Basico::VacunaController
# descripción: Migración a Rails 3
#


class Basico::VacunaController < FormAjaxController

  def index
		list
  end
	
  def list

    params['sort'] = "descripcion" unless params['sort']

    
    conditions=''
	@list = Vacuna.search(conditions, 
                            params[:page], 
                            params['sort'])
    @total=@list.count    

    form_list

  end
	
  def new
    @vacuna = Vacuna.new
	  form_new @vacuna
  end
  
  def cancel_new
	form_cancel_new
  end
  
  def save_new
    @vacuna = Vacuna.new(params[:vacuna])
	form_save_new @vacuna
  end
  
  def delete
    @vacuna = Vacuna.find(params[:id])
	form_delete @vacuna
  end
  
  def edit    
    @vacuna = Vacuna.find(params[:id])
	form_edit @vacuna
  end
  def save_edit
    @vacuna = Vacuna.find(params[:id])	
  form_save_edit @vacuna
  end
  def cancel_edit
    @vacuna = Vacuna.find(params[:id])
	form_cancel_edit @vacuna
  end
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.Vacuna.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.Vacuna.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.Vacuna.FormTitles.form_title_records')
    @form_entity = 'vacuna'
    @form_identity_field = 'descripcion'
  end
  
end
