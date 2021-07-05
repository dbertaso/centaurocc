# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Basico::NacionalidadController
# descripción: Migración a Rails 3
#

class Basico::NacionalidadController < FormAjaxController

  def index
    list
  end
  
  def list

    params['sort'] = "masculino" unless params['sort']

    
    @list = Nacionalidad.search(@condition, params[:page], params[:sort])
    @total=@list.count

    form_list

  end
  
  def new
    @nacionalidad = Nacionalidad.new
    form_new @nacionalidad
  end
  
  def cancel_new
    form_cancel_new
  end
  
  def save_new 
    @nacionalidad = Nacionalidad.new(params[:nacionalidad])
    form_save_new @nacionalidad
  end
  
  def delete
    @nacionalidad = Nacionalidad.find(params[:id])
    form_delete @nacionalidad
  end
  
  def edit
    @nacionalidad = Nacionalidad.find(params[:id])
    form_edit @nacionalidad
  end
  def save_edit
    @nacionalidad = Nacionalidad.find(params[:id])
    form_save_edit @nacionalidad
  end
  def cancel_edit
    @nacionalidad = Nacionalidad.find(params[:id])
    form_cancel_edit @nacionalidad
  end
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.Nacionalidad.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.Nacionalidad.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.Nacionalidad.FormTitles.form_title_records')
    @form_entity = 'nacionalidad'
    @form_identity_field = 'registro_f'
  end
  
end
