# encoding: utf-8
#
# autor: Luis Rojas
# clase: Clientes::ClientePersonaDireccionTelefonoController
# descripción: Migración a Rails 3
#
class Clientes::ClientePersonaDireccionTelefonoController < FormAjaxTabsController

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
    @persona = Persona.find(params[:persona_id])    
    @persona_direccion = PersonaDireccion.find(params[:persona_direccion_id])    
    @persona_telefono = PersonaTelefono.new
    @persona_telefono.tipo = 'L'
		form_new @persona_telefono
  end
  
  def save_new
    @persona = Persona.find(params[:persona_id])
    @persona_direccion = PersonaDireccion.find(params[:persona_direccion_id])
    @persona_telefono = PersonaTelefono.new(params[:persona_telefono])
    @persona_telefono.persona_direccion = @persona_direccion
    @persona_telefono.persona = @persona
    @persona_telefono.tipo = 'L'
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
    @form_title = "#{I18n.t('Sistema.Body.General.beneficiario')} #{I18n.t('Sistema.Body.General.natural')}"
    @form_title_record = I18n.t('Sistema.Body.Vistas.General.telefono')
    @form_title_records = I18n.t('Sistema.Body.Vistas.General.telefonos')
    @form_entity = 'persona_telefono'
    @form_identity_field = 'tipo_nombre'
    @width_layout = '890'
  end
  
  private
  def _list
    @persona = Persona.find(params[:persona_id])
    @persona_direccion = PersonaDireccion.find(params[:persona_direccion_id])
    conditions = ["persona_telefono.persona_direccion_id = ?", @persona_direccion.id]
    params['sort'] = "tipo" unless params['sort']
    
    @list = PersonaTelefono.search(conditions, params[:page], params[:sort])
    @total=@list.count
  end
  
end
