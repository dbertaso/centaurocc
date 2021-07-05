# encoding: UTF-8

#
# autor: Marvin Alfonzo
# clase: Basico::CausaRenunciaController
# descripción: Migración a Rails 3
#
class Basico::CausaRenunciaController < FormAjaxController

	def index
		list
	end
	
  def list

    params['sort'] = "nombre" unless params['sort']

	conditions=''
	@list = CausaRenuncia.search(conditions, 
                            params[:page], 
                            params['sort'])
    @total=@list.count    
    form_list

  end
	
  def new
    @causa_renuncia = CausaRenuncia.new
		form_new @causa_renuncia
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def save_new
    @causa_renuncia = CausaRenuncia.new(params[:causa_renuncia])
		form_save_new @causa_renuncia
  end
  
  def delete
    @causa_renuncia = CausaRenuncia.find(params[:id])
		form_delete @causa_renuncia
  end
  
  def edit
    @causa_renuncia = CausaRenuncia.find(params[:id])
		form_edit @causa_renuncia
  end
  def save_edit
    @causa_renuncia = CausaRenuncia.find(params[:id])
		form_save_edit @causa_renuncia
  end
  def cancel_edit
    @causa_renuncia = CausaRenuncia.find(params[:id])
		form_cancel_edit @causa_renuncia
  end
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.CausaRenuncia.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.CausaRenuncia.FormTitles.form_title')
    @form_title_records = I18n.t('Sistema.Body.Controladores.CausaRenuncia.FormTitles.form_title_records')
    @form_entity = 'causa_renuncia'
    @form_identity_field = 'nombre'
  end
  
end
