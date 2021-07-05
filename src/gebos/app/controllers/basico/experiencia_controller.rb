# encoding: UTF-8

#
# autor: Marvin Alfonzo
# clase: Basico::ExperienciaController
# descripción: Migración a Rails 3
#

class Basico::ExperienciaController < FormAjaxController

  def index
    list
  end

  def list
    
    params['sort'] = "nombre" unless params['sort']

    conditions=''
    @list = Experiencia.search(conditions, 
                            params[:page], 
                            params['sort'])
    @total=@list.count
    form_list
  end

  def new
    @experiencia = Experiencia.new
    form_new @experiencia
  end

  def save_new
    @experiencia = Experiencia.new(params[:experiencia])
    form_save_new @experiencia
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def delete
    @experiencia = Experiencia.find(params[:id])
    form_delete @experiencia
  end
  
  def edit
    @experiencia = Experiencia.find(params[:id])
    form_edit @experiencia
  end
  
  def save_edit
    @experiencia = Experiencia.find(params[:id])
    #@experiencia.update_attributes(params[:experiencia])
    form_save_edit @experiencia
  end

  def cancel_edit
    @experiencia = Experiencia.find(params[:id])
    form_cancel_edit @experiencia
  end
  
  protected
  def common
   super
    @form_title = I18n.t('Sistema.Body.Controladores.Experiencia.FormTitles.form_title')#'Experiencias'
    @form_title_record = I18n.t('Sistema.Body.Controladores.Experiencia.FormTitles.form_title_record')#'Experiencia'
    @form_title_records = I18n.t('Sistema.Body.Controladores.Experiencia.FormTitles.form_title_records')#'Experiencia'
    @form_entity = 'experiencia'
    @form_identity_field = 'nombre'
  end
  
end
