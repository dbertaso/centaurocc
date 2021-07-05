# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Basico::MarcaMaquinariaController
# descripción: Migración a Rails 3
#

class Basico::MarcaMaquinariaController < FormAjaxController

  def index
    list
  end
  
  def list
    params['sort'] = "nombre" unless params['sort']
    
    @list = MarcaMaquinaria.search(@condition, params[:page], params[:sort])
    @total=@list.count
    form_list
  end
  
  def new
    @marca_maquinaria = MarcaMaquinaria.new
    form_new @marca_maquinaria
  end
  
  def cancel_new
    form_cancel_new
  end
  
  def save_new
    @marca_maquinaria = MarcaMaquinaria.new(params[:marca_maquinaria])
    form_save_new @marca_maquinaria
  end

  def delete
    @marca_maquinaria = MarcaMaquinaria.find(params[:id])
    result = @marca_maquinaria.eliminar(params[:id])
    if result == false
      render :update do |page|
        page.form_error
      end
      return
    else
      render :update do |page|
        page.form_delete @marca_maquinaria, 'marca_maquinaria'
      end
    end
  end
  
  
  def edit
    @marca_maquinaria = MarcaMaquinaria.find(params[:id])
    form_edit @marca_maquinaria
  end
  def save_edit
    @marca_maquinaria = MarcaMaquinaria.find(params[:id])
    form_save_edit @marca_maquinaria
  end
  def cancel_edit
    @marca_maquinaria = MarcaMaquinaria.find(params[:id])
    form_cancel_edit @marca_maquinaria
  end
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.MarcaMaquinaria.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.MarcaMaquinaria.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.MarcaMaquinaria.FormTitles.form_title_records')
    @form_entity = 'marca_maquinaria'
    @form_identity_field = 'nombre'
    @width_layout = 850
  end
  
end
