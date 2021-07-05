# encoding: UTF-8

#
# autor: Marvin Alfonzo
# clase: Basico::EjeController
# descripción: Migración a Rails 3
#

class Basico::EjeController < FormAjaxController

  def index
    list
  end

  def list
    
    params['sort'] = "nombre" unless params['sort']
    conditions=''
	@list = Eje.search(conditions, 
                            params[:page], 
                            params['sort'])
    @total=@list.count    
    form_list
  end

  def new
    @eje = Eje.new
    form_new @eje
  end

  def save_new
    @eje = Eje.new(params[:eje])
    form_save_new @eje
  end
  

  def cancel_new
		form_cancel_new
  end
  

  def delete
    @eje = Eje.find(params[:id])
    form_delete @eje
  end
  
  def edit
    @eje = Eje.find(params[:id])
    form_edit @eje
  end
  def save_edit
    @eje = Eje.find(params[:id])
    form_save_edit @eje
  end
  def cancel_edit
    @eje = Eje.find(params[:id])
    form_cancel_edit @eje
  end
  


  protected
  def common
 

   super
    @form_title = I18n.t('Sistema.Body.Controladores.Eje.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.Eje.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.Eje.FormTitles.form_title_records')
    @form_entity = 'eje'
    @form_identity_field = 'nombre'
  
  end
  
end
