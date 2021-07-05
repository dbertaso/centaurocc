# encoding: utf-8

#
# autor: Luis Rojas
# clase: Basico::ProveedorMarinoController
# descripción: Migración a Rails 3

class Basico::ProveedorMarinoController < FormAjaxController

	def index
		list
	end

  def list

    params['sort'] = "nombre" unless params['sort']
    condition = "id > 0"
    
    @list = ProveedorMarino.search(condition, params[:page], params[:sort])
    @total=@list.count

    form_list

  end

  def new
    @proveedor_marino = ProveedorMarino.new
		form_new @proveedor_marino
  end

  def cancel_new
		form_cancel_new
  end

  def save_new
    @proveedor_marino = ProveedorMarino.new(params[:proveedor_marino])
		form_save_new @proveedor_marino
  end

  def delete
    @proveedor_marino = ProveedorMarino.find(params[:id])
		form_delete @proveedor_marino
  end

  def edit
    @proveedor_marino = ProveedorMarino.find(params[:id])
		form_edit @proveedor_marino
  end

  def save_edit
    @proveedor_marino = ProveedorMarino.find(params[:id])
		form_save_edit @proveedor_marino
  end

  def cancel_edit
    @proveedor_marino = ProveedorMarino.find(params[:id])
		form_cancel_edit @proveedor_marino
  end

  protected
  def common
    super
    @form_title = "#{I18n.t('Sistema.Body.Vistas.General.proveedor')} #{I18n.t('Sistema.Body.Vistas.General.marino')}"
    @form_title_record = "#{I18n.t('Sistema.Body.Vistas.General.proveedor')} #{I18n.t('Sistema.Body.Vistas.General.marino')}"
    @form_title_records = "#{I18n.t('Sistema.Body.Vistas.General.proveedor')} #{I18n.t('Sistema.Body.Vistas.General.marino')}"
    @form_entity = 'proveedor_marino'
    @form_identity_field = 'nombre'
  end

end
