# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Basico::FormacionController
# descripción: Migración a Rails 3
#
class Basico::FormacionController < FormAjaxController

  def index
    list
  end

  def list
    
    params['sort'] = "nombre" unless params['sort']
    conditions = "id > 0"
    
    @list = Formacion.search(conditions, params[:page], params[:sort])
    @total=@list.count

    form_list
  end

  def new
    @formacion = Formacion.new
    form_new @formacion
  end

  def save_new
    @formacion = Formacion.new(params[:formacion])
    form_save_new @formacion
  end
  
  def cancel_new
    form_cancel_new
  end
  
  def delete
    @formacion = Formacion.find(params[:id])
    form_delete @formacion
  end
  
  def edit
    @formacion = Formacion.find(params[:id])
    form_edit @formacion
  end
  
  def save_edit
    @formacion = Formacion.find(params[:id])
    form_save_edit @formacion
  end

  def cancel_edit
    @formacion = Formacion.find(params[:id])
    form_cancel_edit @formacion
  end
  
  protected
  def common
   super
    @form_title = I18n.t('Sistema.Body.Controladores.Formacion.FormTitles.form_title')
    @form_title_records = I18n.t('Sistema.Body.Controladores.Formacion.FormTitles.form_title_records')
    @form_entity = 'formacion'
    @form_identity_field = 'nombre'
  end
  
end
