# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Basico::CasoMedidaController
# descripción: Migración a Rails 3
#
class Basico::CasoMedidaController < FormAjaxController

  def index
    list
  end
  
  def list

    params['sort'] = "nombre" unless params['sort']

    
    @list = CasoMedida.search(@condition, params[:page], params[:sort])
    @total=@list.count

    form_list

  end
  
  def new
    @caso_medida = CasoMedida.new
    form_new @caso_medida
  end
  
  def cancel_new
    form_cancel_new
  end
  
  def save_new
    @caso_medida = CasoMedida.new(params[:caso_medida])
    form_save_new @caso_medida
  end
  
  def delete
    @caso_medida = CasoMedida.find(params[:id])
    form_delete @caso_medida
  end
  
  def edit
    @caso_medida = CasoMedida.find(params[:id])
    form_edit @caso_medida
  end
  def save_edit
    @caso_medida = CasoMedida.find(params[:id])
    form_save_edit @caso_medida
  end
  def cancel_edit
    @caso_medida = CasoMedida.find(params[:id])
    form_cancel_edit @caso_medida
  end
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.CasoMedida.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.CasoMedida.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.CasoMedida.FormTitles.form_title_records')
    @form_entity = 'caso_medida'
    @form_identity_field = 'nombre'
  end
  
end
