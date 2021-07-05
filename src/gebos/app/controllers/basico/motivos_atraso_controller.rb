# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Basico::MotivosAtrasoController
# descripción: Nuevo en Rails 3
#

class Basico::MotivosAtrasoController < FormAjaxController

  def index
    list
  end
  
  def list

    params['sort'] = "descripcion" unless params['sort']

    
    @list = MotivosAtraso.search(@condition, params[:page], params[:sort])
    @total=@list.count

    form_list

  end
  
  def new
    @mensajes_sms = MotivosAtraso.new
    form_new @motivos_atraso
  end
  
  def cancel_new
    form_cancel_new
  end
  
  def save_new 
    @motivos_atraso = MotivosAtraso.new(params[:motivos_atraso])
    form_save_new @motivos_atraso
  end
  
  def delete
    @motivos_atraso = MotivosAtraso.find(params[:id])
    form_delete @motivos_atraso
  end
  
  def edit
    @motivos_atraso = MotivosAtraso.find(params[:id])
    form_edit @motivos_atraso
  end
  def save_edit
    @motivos_atraso = MotivosAtraso.find(params[:id])
    form_save_edit @motivos_atraso
  end
  def cancel_edit
    @motivos_atraso = MotivosAtraso.find(params[:id])
    form_cancel_edit @motivos_atraso
  end
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.MotivosAtraso.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.MotivosAtraso.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.MotivosAtraso.FormTitles.form_title_records')
    @form_entity = 'motivos_atraso'
    @form_identity_field = 'descripcion'
  end
  
end
