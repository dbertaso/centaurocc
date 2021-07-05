# encoding: UTF-8

#
# autor: Marvin Alfonzo
# clase: Basico::EspecieVariedadPastoController
# descripción: Migración a Rails 3
#

class Basico::EspecieVariedadPastoController < FormAjaxController

	def index
		list
	end
	
  def list

    params['sort'] = "descripcion" unless params['sort']

    
    conditions=''
    @list = EspecieVariedadPasto.search(conditions, 
                            params[:page], 
                            params['sort'])
    @total=@list.count
    form_list

  end
	
  def new
    @tipo_pasto_forraje = TipoPastoForraje.find(:all)
    @especie_variedad_pasto = EspecieVariedadPasto.new
		form_new @especie_variedad_pasto
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def save_new
    @especie_variedad_pasto = EspecieVariedadPasto.new(params[:especie_variedad_pasto])
		form_save_new @especie_variedad_pasto
  end
  
  def delete
    @especie_variedad_pasto = EspecieVariedadPasto.find(params[:id])
		form_delete @especie_variedad_pasto
  end
  
  def edit
    @tipo_pasto_forraje = TipoPastoForraje.find(:all)
    @especie_variedad_pasto = EspecieVariedadPasto.find(params[:id])
		form_edit @especie_variedad_pasto
  end
  def save_edit
    @especie_variedad_pasto = EspecieVariedadPasto.find(params[:id])
		form_save_edit @especie_variedad_pasto
  end
  def cancel_edit
    @especie_variedad_pasto = EspecieVariedadPasto.find(params[:id])
		form_cancel_edit @especie_variedad_pasto
  end
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.EspecieVariedadPasto.FormTitles.form_title')#'Especie Variedad Pastos'
    @form_title_record = I18n.t('Sistema.Body.Controladores.EspecieVariedadPasto.FormTitles.form_title_record')#'Especie Variedad Pastos'
    @form_title_records = I18n.t('Sistema.Body.Controladores.EspecieVariedadPasto.FormTitles.form_title_records')#'Especie Variedad Pastos'
    @form_entity = 'especie_variedad_pasto'
    @form_identity_field = 'descripcion'
  end
  
end
