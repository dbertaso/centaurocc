# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Basico::ModalidadFinanciamientoController
# descripción: Migración a Rails 3
#

class Basico::ModalidadFinanciamientoController < FormAjaxController

  def index
    list
  end
  
  def list

    params['sort'] = "nombre" unless params['sort']
    
    @list = ModalidadFinanciamiento.search(@condition, params[:page], params[:sort])
    @total=@list.count
    form_list

  end
  
  def new
    @modalidad_financiamiento = ModalidadFinanciamiento.new
    form_new @modalidad_financiamiento
  end
  
  def cancel_new
    form_cancel_new
  end
  
  def save_new
    @modalidad_financiamiento = ModalidadFinanciamiento.new(params[:modalidad_financiamiento])
    form_save_new @modalidad_financiamiento
  end
  
  def delete
    @modalidad_financiamiento = ModalidadFinanciamiento.find(params[:id])
    form_delete @modalidad_financiamiento
  end
  
  def edit
    @modalidad_financiamiento = ModalidadFinanciamiento.find(params[:id])
    form_edit @modalidad_financiamiento
  end
  def save_edit
    @modalidad_financiamiento = ModalidadFinanciamiento.find(params[:id])
    form_save_edit @modalidad_financiamiento
  end
  def cancel_edit
    @modalidad_financiamiento = ModalidadFinanciamiento.find(params[:id])
    form_cancel_edit @modalidad_financiamiento
  end
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.ModalidadFinanciamiento.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.ModalidadFinanciamiento.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.ModalidadFinanciamiento.FormTitles.form_title_records')
    @form_entity = 'modalidad_financiamiento'
    @form_identity_field = 'nombre'
  end
  
end
