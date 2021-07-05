# encoding: UTF-8

#
# autor: Marvin Alfonzo
# clase: Basico::VocacionTierraController
# descripción: Migración a Rails 3
#



class Basico::VocacionTierraController < FormAjaxController

  def index
    list
  end

  def list
    
    params['sort'] = "nombre" unless params['sort']

    
    conditions=''
	@list = VocacionTierra.search(conditions, 
                            params[:page], 
                            params['sort'])
    @total=@list.count    

    form_list
  end

  def new
    @vocacion_tierra = VocacionTierra.new
    form_new @vocacion_tierra
  end

  def save_new
    @vocacion_tierra = VocacionTierra.new(params[:vocacion_tierra])
    form_save_new @vocacion_tierra
  end

  def cancel_new
		form_cancel_new
  end
  
  def delete
    @vocacion_tierra = VocacionTierra.find(params[:id])
    form_delete @vocacion_tierra
  end
  
  def edit
    @vocacion_tierra = VocacionTierra.find(params[:id])
    form_edit @vocacion_tierra
  end

  def save_edit
    @vocacion_tierra = VocacionTierra.find(params[:id])
    form_save_edit @vocacion_tierra
  end

  def cancel_edit
    @vocacion_tierra = VocacionTierra.find(params[:id])
    form_cancel_edit @vocacion_tierra
  end
  
  protected
  def common
   super
    @form_title = I18n.t('Sistema.Body.Controladores.VocacionTierra.FormTitles.form_title')#'Vocación de la Tierra'
    @form_title_record = I18n.t('Sistema.Body.Controladores.VocacionTierra.FormTitles.form_title_record')#'Vocación de la Tierra'
    @form_title_records = I18n.t('Sistema.Body.Controladores.VocacionTierra.FormTitles.form_title_records')#'Vocación de la Tierra'
    @form_entity = 'vocacion_tierra'
    @form_identity_field = 'nombre'
  end
  
end
