# encoding: UTF-8

#
# autor: Luis Rojas
# clase: Clientes::ClientePersonaTelefonoController
# descripción: Migración a Rails 3
#
class Clientes::ClientePersonaTelefonoController < FormAjaxTabsController

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
    @persona_telefono = PersonaTelefono.new
		form_new @persona_telefono
  end
  
  def save_new
    @persona = Persona.find(params[:persona_id])
    @persona_telefono = PersonaTelefono.new(params[:persona_telefono])
    @persona_telefono.persona = @persona
    form_save_new @persona_telefono
  end
  
  def edit
    @persona = Persona.find(params[:persona_id])    
    @persona_telefono = PersonaTelefono.find(params[:id])
		form_edit @persona_telefono
  end

  def cancel_edit
    @persona_telefono = PersonaTelefono.find(params[:id])
    form_cancel_edit @persona_telefono
  end
  
  def save_edit
    @persona = Persona.find(params[:persona_id])
    logger.debug "id del registro " + params[:id].to_s
    @persona_telefono = PersonaTelefono.find(params[:id])
    form_save_edit @persona_telefono
  end
  
  def cancel_new
		form_cancel_new
  end
  
 
  def delete
    @persona = Persona.find(params[:persona_id])
    @persona_telefono = PersonaTelefono.find(params[:id])
    form_delete @persona_telefono
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
    conditions = ["persona_telefono.persona_id = ?", @persona.id]
    params['sort'] = "tipo" unless params['sort']
    
    @list = PersonaTelefono.search(conditions, params[:page], params['sort'])
    @total=@list.count
    @pages = @list.clone
  end  
end
