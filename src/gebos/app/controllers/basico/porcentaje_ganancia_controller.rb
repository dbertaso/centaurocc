# encoding: utf-8
class Basico::PorcentajeGananciaController < FormAjaxController

  def index
    list
  end

  def list
    
    params['sort'] = "nombre" unless params['sort']
    conditions = "id > 0"
    
    @list = PorcentajeGanancia.search(conditions, params[:page], params[:sort])
    @total=@list.count

    form_list
  end

  def new
    @porcentaje_ganancia = PorcentajeGanancia.new
    form_new @porcentaje_ganancia
  end

  def save_new
    @porcentaje_ganancia = PorcentajeGanancia.new(params[:porcentaje_ganancia])
    form_save_new @porcentaje_ganancia
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def delete
    @porcentaje_ganancia = PorcentajeGanancia.find(params[:id])
    form_delete @porcentaje_ganancia
  end
  
  def edit
    @porcentaje_ganancia = PorcentajeGanancia.find(params[:id])
    form_edit @porcentaje_ganancia
  end
  
  def save_edit
    @porcentaje_ganancia = PorcentajeGanancia.find(params[:id])
    form_save_edit @porcentaje_ganancia
  end

  def cancel_edit
    @porcentaje_ganancia = PorcentajeGanancia.find(params[:id])
    form_cancel_edit @porcentaje_ganancia
  end
  
  protected
  def common
   super
    @form_title = I18n.t('Sistema.Body.Controladores.PorcentajeGarantia.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.PorcentajeGarantia.FormTitles.form_title')
    @form_title_records = I18n.t('Sistema.Body.Controladores.PorcentajeGarantia.FormTitles.form_title_records')
    @form_entity = 'porcentaje_ganancia'
    @form_identity_field = 'nombre'
  end
  
end
