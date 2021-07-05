# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Basico::MensajesSmsController
# descripción: Migración a Rails 3
#

class Basico::MensajesSmsController < FormAjaxController

  def index
    list
  end
  
  def list

    params['sort'] = "nombre" unless params['sort']

    
    @list = MensajesSms.search(@condition, params[:page], params[:sort])
    @total=@list.count

    form_list

  end
  
  def new
    @mensajes_sms = MensajesSms.new
    form_new @mensajes_sms
  end
  
  def cancel_new
    form_cancel_new
  end
  
  def save_new 
    @mensajes_sms = MensajesSms.new(params[:mensajes_sms])
    form_save_new @mensajes_sms
  end
  
  def delete
    @mensajes_sms = MensajesSms.find(params[:id])
    form_delete @mensajes_sms
  end
  
  def edit
    @mensajes_sms = MensajesSms.find(params[:id])
    form_edit @mensajes_sms
  end
  def save_edit
    @mensajes_sms = MensajesSms.find(params[:id])
    form_save_edit @mensajes_sms
  end
  def cancel_edit
    @mensajes_sms = MensajesSms.find(params[:id])
    form_cancel_edit @mensajes_sms
  end
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.MensajesSms.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.MensajesSms.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.MensajesSms.FormTitles.form_title_records')
    @form_entity = 'mensajes_sms'
    @form_identity_field = 'nombre'
  end
  
end
