# encoding: UTF-8

#
# 
# clase: Clientes::ClientePersonaEmailController
# descripción: Migración a Rails 3
#
class Clientes::ClientePersonaEmailController < FormAjaxTabsController

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
  
  def _list
    @persona = Persona.find(params[:persona_id])
    conditions = ["persona_email.persona_id = ?", @persona.id]
    params['sort'] = "tipo" unless params['sort']
    
    @list = PersonaEmail.search(conditions, params[:page], params[:sort])
    @total=@list.count

  end
  
  def edit
    @persona = Persona.find(params[:persona_id])    
    @persona_email = PersonaEmail.find(params[:id])
		form_edit @persona_email
  end

  def cancel_edit
    @persona_email = PersonaEmail.find(params[:id])
    form_cancel_edit @persona_email
  end
  
  def save_edit
    @persona = Persona.find(params[:persona_id])
    @persona_email = PersonaEmail.find(params[:id])
    form_save_edit @persona_email
  end

  def new
    @persona = Persona.find(params[:persona_id])    
    @persona_email = PersonaEmail.new
		form_new @persona_email
  end
  
  def save_new
    @persona = Persona.find(params[:persona_id])
    @persona_email = PersonaEmail.new(params[:persona_email])
    @persona_email.persona = @persona
    form_save_new @persona_email
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def delete
    @persona = Persona.find(params[:persona_id])
    @persona_email = PersonaEmail.find(params[:id])
    form_delete @persona_email
  end
  
  protected
  def common
    super
    @form_title = "#{I18n.t('Sistema.Body.General.beneficiario')} #{I18n.t('Sistema.Body.General.natural')}"
    @form_title_record = I18n.t('Sistema.Body.Vistas.General.correo_electronico')
    @form_title_records = I18n.t('Sistema.Body.Vistas.General.correo_electronico')
    @form_entity = 'persona_email'
    @form_identity_field = 'tipo_nombre'
    @width_layout = '890'
  end
  
  private
  def _list
    @persona = Persona.find(params[:persona_id])
    conditions = ["persona_email.persona_id = ?", @persona.id]
    params['sort'] = "tipo" unless params['sort']
  
     @list = PersonaEmail.search(conditions, 
                            params[:page], 
                            params['sort'])
                            
    @total=@list.count
    @pages = @list.clone 

  end
end
