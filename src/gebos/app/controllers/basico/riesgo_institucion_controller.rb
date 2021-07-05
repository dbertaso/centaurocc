# encoding: UTF-8

#
# autor: Diego Bertaso
# clase: Basico::RiesgoInstitucionController
# descripción: Migración a Rails 3
#

class Basico::RiesgoInstitucionController < FormAjaxController

  def index
   list

  end

  def list
     params['sort'] = "categoria" unless params['sort']


    @list = RiesgoInstitucion.search('', 
                                        params[:page], 
                                        params['sort'])
    @total=@list.count
    form_list

  end


  def new
    @riesgo_institucion = RiesgoInstitucion.new
    form_new @riesgo_institucion
  end

  def save_new
    @riesgo_institucion = RiesgoInstitucion.new(params[:riesgo_institucion])
    form_save_new @riesgo_institucion
  end


  def cancel_new
    form_cancel_new
  end


  def delete
    @riesgo_institucion = RiesgoInstitucion.find(params[:id])
    form_delete @riesgo_institucion
  end

  def edit
    @riesgo_institucion = RiesgoInstitucion.find(params[:id])
    form_edit @riesgo_institucion
  end
  def save_edit
    @riesgo_institucion = RiesgoInstitucion.find(params[:id])
    form_save_edit @riesgo_institucion
  end
  def cancel_edit
    @riesgo_institucion = RiesgoInstitucion.find(params[:id])
    form_cancel_edit @riesgo_institucion
  end



  protected
  def common


   super
    @form_title =  I18n.t('Sistema.Body.Controladores.RiesgoInstitucion.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.RiesgoInstitucion.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.RiesgoInstitucion.FormTitles.form_title_records')
    @form_entity = 'riesgo_institucion'
    @form_identity_field = 'categoria'

  end

end
