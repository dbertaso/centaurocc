# encoding: utf-8

#
# autor: Luis Rojas
# clase: Basico::TipoClienteNaturalController
# descripción: Migración a Rails 3

class Basico::TipoClienteNaturalController < FormAjaxTabsController

  layout 'form_basic'
  
	def index
		list
	end
	
  def list

    params['sort'] = "nombre" unless params['sort']
    condition = "clasificacion = 'N'"
    
    @list =TipoCliente.search(condition, params[:page], params[:sort])
    @total=@list.count

    form_list

  end
	
  def new
    @tipo_cliente = TipoCliente.new
		form_new @tipo_cliente
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def save_new 
    @tipo_cliente = TipoCliente.new(params[:tipo_cliente])
    @tipo_cliente.clasificacion = 'N'
    form_save_new @tipo_cliente
  end
  
  def delete
    @tipo_cliente = TipoCliente.find(params[:id])
    form_delete @tipo_cliente
  end
  
  def edit
    @tipo_cliente = TipoCliente.find(params[:id])
    form_edit @tipo_cliente
  end
  def save_edit
    @tipo_cliente = TipoCliente.find(params[:id])
    form_save_edit @tipo_cliente
  end
  def cancel_edit
    @tipo_cliente = TipoCliente.find(params[:id])
    form_cancel_edit @tipo_cliente
  end
  
  protected
  def common
    super
    @form_title = "#{I18n.t('Sistema.Body.Vistas.General.tipo')} #{I18n.t('Sistema.Body.General.beneficiario')}"
    @form_title_record = "#{I18n.t('Sistema.Body.Vistas.General.tipo')} #{I18n.t('Sistema.Body.General.beneficiario')}"
    @form_title_records = "#{I18n.t('Sistema.Body.Vistas.General.tipo')} #{I18n.t('Sistema.Body.General.beneficiario')}"
    @form_entity = 'tipo_cliente'
    @form_identity_field = 'nombre'
  end
  
end
