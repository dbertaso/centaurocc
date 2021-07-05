# encoding: utf-8
#
# autor: Luis Rojas
# clase: Clientes::ClienteEmpresaIntegrantePersonaDireccionTelefonoController
# descripción: Migración a Rails 3
#
class Clientes::ClienteEmpresaIntegrantePersonaDireccionTelefonoController < FormAjaxTabsController

  before_filter :common_local

  def index
    list
  end
  def list
    _list

    form_list

  end	
  
  def view
    list_view
  end
  
  def list_view
    _list
    form_list_view
  end

  def new
    @persona_telefono = PersonaTelefono.new
    @persona_telefono.tipo = @persona_direccion.tipo
		form_new @persona_telefono
  end
  
  def save_new
    @persona_telefono = PersonaTelefono.new(params[:persona_telefono])
    @persona_telefono.persona_direccion = @persona_direccion
    @persona_telefono.persona = @persona
    @persona_telefono.tipo = @persona_direccion.tipo
    form_save_new @persona_telefono
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def delete
    @persona_telefono = PersonaTelefono.find(params[:id])
    form_delete @persona_telefono
  end
  
  def edit
    @persona_telefono = PersonaTelefono.find(params[:id])
		form_edit @persona_telefono
  end

  def cancel_edit
    @persona_telefono = PersonaTelefono.find(params[:id])
    form_cancel_edit @persona_telefono
  end
  
  def save_edit
    @persona_telefono = PersonaTelefono.find(params[:id])
    form_save_edit @persona_telefono
  end
  
  protected
  def common
    super
    @form_title = Etiquetas.etiqueta(9) + ' Jurídicos'
    @form_title_record = 'Teléfono' 
    @form_title_records = 'Teléfonos'
    @form_entity = 'persona_telefono'
    @form_identity_field = 'tipo_nombre'
    @width_layout = '800'
  end
  
  def common_local
    if action_name!='edit' && action_name!='delete' && action_name!='save_edit' && action_name!='cancel_edit' 
      @empresa_integrante_tipo = EmpresaIntegranteTipo.find(params[:empresa_integrante_tipo_id])
      @persona_direccion = PersonaDireccion.find(params[:persona_direccion_id])
      @empresa = @empresa_integrante_tipo.empresa_integrante.empresa
      @persona = @empresa_integrante_tipo.empresa_integrante.persona
    end
  end
  private
  def _list
    conditions = ["persona_telefono.persona_direccion_id = ?", @persona_direccion.id]
    params['sort'] = "tipo" unless params['sort']
    
    @list = PersonaTelefono.search(conditions, params[:page], params['sort'])
    @total=@list.count
    @pages = @list.clone
  end
end
