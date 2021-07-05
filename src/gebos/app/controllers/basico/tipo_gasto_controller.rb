# encoding: utf-8

#
# autor: Luis Rojas
# clase: Basico::TipoGastoController
# descripción: Migración a Rails 3
#
class Basico::TipoGastoController < FormAjaxController

	def index
		list
	end
	
  def list

    params['sort'] = "nombre" unless params['sort']
    condition = "id > 0"
    
    @list = TipoGasto.search(condition, params[:page], params[:sort])
    @total=@list.count
    form_list
  end
	
  def new
    @tipo_gasto = TipoGasto.new
		form_new @tipo_gasto
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def save_new
    @tipo_gasto = TipoGasto.new(params[:tipo_gasto])
    form_save_new @tipo_gasto
  end
  
  def delete
    @tipo_gasto = TipoGasto.find(params[:id])
    form_delete @tipo_gasto
  end
  
  def edit
    @tipo_gasto = TipoGasto.find(params[:id])
     form_edit @tipo_gasto
  end
  
  def save_edit
    @tipo_gasto = TipoGasto.find(params[:id])
    form_save_edit @tipo_gasto
  end
  
  def cancel_edit
    @tipo_gasto = TipoGasto.find(params[:id])
    form_cancel_edit @tipo_gasto
  end
  
  protected
  def common
    super
    @form_title = "#{I18n.t('Sistema.Body.Vistas.General.tipo')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.gasto')}"
    @form_title_record = "#{I18n.t('Sistema.Body.Vistas.General.tipo')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.gasto')}"
    @form_title_records = "#{I18n.t('Sistema.Body.Vistas.General.tipo')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.gasto')}"
    @form_entity = 'tipo_gasto'
    @form_identity_field = 'nombre'
  end
  
end
