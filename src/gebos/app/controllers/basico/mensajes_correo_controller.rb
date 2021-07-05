# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Basico::MensajesCorreoController
# descripción: Nuevo en Rails 3
#

class Basico::MensajesCorreoController < FormAjaxController

  def index
    list
  end
  
  def list

    params['sort'] = "nombre" unless params['sort']

    
    @list = MensajesCorreo.search(@condition, params[:page], params[:sort])
    @total=@list.count

    form_list

  end
  
  def new
    @mensajes_correo = MensajesCorreo.new
    form_new @mensajes_correo
  end
  
  def cancel_new
    form_cancel_new
  end
  
  def save_new 
    @mensajes_correo = MensajesCorreo.new(params[:mensajes_correo])
    form_save_new @mensajes_correo
  end
  
  def delete
    @mensajes_correo = MensajesCorreo.find(params[:id])
    form_delete @mensajes_correo
  end
  
  def edit
    @mensajes_correo = MensajesCorreo.find(params[:id])
    form_edit @mensajes_correo
  end
  def save_edit
    @mensajes_correo = MensajesCorreo.find(params[:id])
    form_save_edit @mensajes_correo
  end
  def cancel_edit
    @mensajes_correo = MensajesCorreo.find(params[:id])
    form_cancel_edit @mensajes_correo
  end
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.MensajesCorreo.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.MensajesCorreo.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.MensajesCorreo.FormTitles.form_title_records')
    @form_entity = 'mensajes_correo'
    @form_identity_field = 'nombre'
  end
  
end
