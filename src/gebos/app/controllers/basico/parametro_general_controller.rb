# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Basico::ParametroGeneralController
# descripción: Migración a Rails 3
#

class Basico::ParametroGeneralController < FormClassicController

  def index
    @parametro_general = ParametroGeneral.find(:all).first
  end

  def edit
    @parametro_general = ParametroGeneral.find(params[:id])
    @moneda_list=Moneda.find(:all,:conditions=>"activo=true",:order=>"nombre")
  end
  def save_edit
    @parametro_general = ParametroGeneral.find(:all).first
    form_save_edit @parametro_general
  end

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.ParametroGeneral.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.ParametroGeneral.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.ParametroGeneral.FormTitles.form_title_records')
    @form_entity = 'parametro_general'
  end

end
