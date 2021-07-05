# encoding: UTF-8

#
# autor: Diego Bertaso
# clase: Basico::MonedaController

#
class Basico::MonedaController < FormAjaxController

	def index
		list
	end
	
  def list

    params['sort'] = "nombre" unless params['sort']

  	conditions=''
  	@list = Moneda.search(conditions, 
                              params[:page], 
                              params['sort'])
    @total=@list.count    
    form_list

  end
	
  def new
    @Moneda = Moneda.new
		form_new @moneda
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def save_new
    @moneda = Moneda.new(params[:moneda])
		form_save_new @moneda
  end
  
  def delete
    @moneda = Moneda.find(params[:id])
		form_delete @moneda
  end
  
  def edit
    @moneda = Moneda.find(params[:id])
		form_edit @moneda
  end
  def save_edit
    @moneda = Moneda.find(params[:id])
		form_save_edit @moneda
  end
  def cancel_edit
    @moneda = Moneda.find(params[:id])
		form_cancel_edit @moneda
  end
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.Moneda.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.Moneda.FormTitles.form_title')
    @form_title_records = I18n.t('Sistema.Body.Controladores.Moneda.FormTitles.form_title_records')
    @form_entity = 'moneda'
    @form_identity_field = 'nombre'
  end
  
end
