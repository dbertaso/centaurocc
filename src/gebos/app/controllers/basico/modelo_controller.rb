# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Basico::ModeloController
# descripción: Migración a Rails 3
#

class Basico::ModeloController < FormAjaxController

  def index
    list
  end
  
  def list
    params['sort'] = "nombre" unless params['sort']
    
    @list = Modelo.search(@condition, params[:page], params[:sort])
    @total=@list.count
    form_list
  end
  
  def new
    @modelo = Modelo.new
    form_new @modelo
  end
  
  def cancel_new
    form_cancel_new
  end
  
  def save_new
    @modelo = Modelo.new(params[:modelo])
    form_save_new @modelo
  end
  
  def delete
    @modelo = Modelo.find(params[:id])
    result = @modelo.eliminar(params[:id])
    if result == false
      render :update do |page|
        page.form_error
      end
      return
    else
      render :update do |page|
        page.form_delete @modelo, 'modelo'
      end
    end
  end
  
  
  def edit
    @modelo = Modelo.find(params[:id])
    form_edit @modelo
  end
  def save_edit
    @modelo = Modelo.find(params[:id])
    form_save_edit @modelo
  end
  def cancel_edit
    @modelo = Modelo.find(params[:id])
    form_cancel_edit @modelo
  end
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.Modelo.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.Modelo.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.Modelo.FormTitles.form_title_records')
    @form_entity = 'modelo'
    @form_identity_field = 'nombre'
  end
  
end
