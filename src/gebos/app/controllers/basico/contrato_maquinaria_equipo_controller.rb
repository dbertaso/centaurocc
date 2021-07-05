# encoding: UTF-8

#
# autor: Marvin Alfonzo
# clase: Basico::ContratoMaquinariaEquipoController
# descripción: Migración a Rails 3
#


class Basico::ContratoMaquinariaEquipoController < FormAjaxController

  def index
    list
  end

  def list
    params['sort'] = "nombre" unless params['sort']
    
    conditions=''
	@list = ContratoMaquinariaEquipo.search(conditions, 
                            params[:page], 
                            params['sort'])
    @total=@list.count
    
    form_list
  end

  def new
    @contrato_maquinaria_equipo = ContratoMaquinariaEquipo.new
    form_new @contrato_maquinaria_equipo
  end

  def save_new
    @contrato_maquinaria_equipo = ContratoMaquinariaEquipo.new(params[:contrato_maquinaria_equipo])
    form_save_new @contrato_maquinaria_equipo
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def delete
    @contrato_maquinaria_equipo = ContratoMaquinariaEquipo.find(params[:id])
    form_delete @contrato_maquinaria_equipo
  end
  
  def edit
    @contrato_maquinaria_equipo = ContratoMaquinariaEquipo.find(params[:id])
    form_edit @contrato_maquinaria_equipo
  end
  
  def save_edit
    @contrato_maquinaria_equipo = ContratoMaquinariaEquipo.find(params[:id])    
    form_save_edit @contrato_maquinaria_equipo
  end

  def cancel_edit
    @contrato_maquinaria_equipo = ContratoMaquinariaEquipo.find(params[:id])
    form_cancel_edit @contrato_maquinaria_equipo
  end

  protected
  def common
   super
    @form_title = I18n.t('Sistema.Body.Controladores.ContratoMaquinariaEquipo.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.ContratoMaquinariaEquipo.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.ContratoMaquinariaEquipo.FormTitles.form_title_records')
    @form_entity = 'contrato_maquinaria_equipo'
    @form_identity_field = 'nombre'
    @width_layout = '800'
  end
  
end
