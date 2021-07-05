# encoding: UTF-8

#
# autor: Marvin Alfonzo
# clase: Basico::AnalisisTopicoController
# descripción: Migración a Rails 3
#

class Basico::AnalisisTopicoController < FormAjaxController

  def index
    list
  end

  def list
    
    params['sort'] = "nombre" unless params['sort']

    conditions=''
    @list = AnalisisTopico.search(conditions, 
                            params[:page], 
                            params['sort'])    
    @total=@list.count   

    form_list
  end

  def new
    @analisis_topico = AnalisisTopico.new    
    form_new @analisis_topico
  end

  def save_new
    @analisis_topico = AnalisisTopico.new(params[:analisis_topico])
    form_save_new @analisis_topico
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def delete
    @analisis_topico = AnalisisTopico.find(params[:id])
    form_delete @analisis_topico
  end
  
  def edit
    @analisis_topico = AnalisisTopico.find(params[:id])
    form_edit @analisis_topico
  end
  
  def save_edit
    @analisis_topico = AnalisisTopico.find(params[:id])
    form_save_edit @analisis_topico
  end

  def cancel_edit
    @analisis_topico = AnalisisTopico.find(params[:id])
    form_cancel_edit @analisis_topico
  end

  protected
  def common
   super
    @form_title = I18n.t('Sistema.Body.Controladores.AnalisisTopico.FormTitles.form_title') 
    @form_title_record = I18n.t('Sistema.Body.Controladores.AnalisisTopico.FormTitles.form_title_record') 
    @form_title_records = I18n.t('Sistema.Body.Controladores.AnalisisTopico.FormTitles.form_title_records') 
    @form_entity = 'analisis_topico'
    @form_identity_field = 'nombre'
  end
  
end
