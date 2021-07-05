# encoding: UTF-8

#
# autor: Marvin Alfonzo
# clase: Basico::CausaDiferimientoController
# descripción: Migración a Rails 3
#

class Basico::CausaDiferimientoController < FormAjaxController

	def index
		list
	end
	
  def list

    params['sort'] = "nombre" unless params['sort']

    
	conditions=''
	@list = CausaDiferimiento.search(conditions, 
                            params[:page], 
                            params['sort'])
    @total=@list.count    

    form_list

  end
	
  def new
    @causa_diferimiento = CausaDiferimiento.new
		form_new @causa_diferimiento
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def save_new
    @causa_diferimiento = CausaDiferimiento.new(params[:causa_diferimiento])
		form_save_new @causa_diferimiento
  end
  
  def delete
    @causa_diferimiento = CausaDiferimiento.find(params[:id])
		form_delete @causa_diferimiento
  end
  
  def edit
    @causa_diferimiento = CausaDiferimiento.find(params[:id])
		form_edit @causa_diferimiento
  end
  def save_edit
    @causa_diferimiento = CausaDiferimiento.find(params[:id])
		form_save_edit @causa_diferimiento
  end
  def cancel_edit
    @causa_diferimiento = CausaDiferimiento.find(params[:id])
		form_cancel_edit @causa_diferimiento
  end
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.CausaDiferimiento.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.CausaDiferimiento.FormTitles.form_title_records')
    @form_title_records = I18n.t('Sistema.Body.Controladores.CausaDiferimiento.FormTitles.form_title_records')
    @form_entity = 'causa_diferimiento'
    @form_identity_field = 'nombre'
  end
  
end
