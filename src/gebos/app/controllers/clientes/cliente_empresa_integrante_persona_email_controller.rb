# encoding: utf-8
#
# autor: Luis Rojas
# clase: Clientes::ClienteEmpresaIntegrantePersonaEmailController
# descripción: Migración a Rails 3
#
class Clientes::ClienteEmpresaIntegrantePersonaEmailController < FormAjaxTabsController

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
    @persona_email = PersonaEmail.new
		form_new @persona_email
  end
  
  def save_new
    @persona_email = PersonaEmail.new(params[:persona_email])
    @persona_email.persona = @persona
    form_save_new @persona_email
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def delete
    @persona_email = PersonaEmail.find(params[:id])
    form_delete @persona_email
  end
  
  def edit
    @persona_email = PersonaEmail.find(params[:id])
		form_edit @persona_email
  end

  def cancel_edit
    @persona_email = PersonaEmail.find(params[:id])
    form_cancel_edit @persona_email
  end
  
  def save_edit
    @persona_email = PersonaEmail.find(params[:id])
    form_save_edit @persona_email
  end
  
  protected
  def common
    super
    @form_title = Etiquetas.etiqueta(9) + ' Jurídicos'
    @form_title_record = 'Correo-e' 
    @form_title_records = 'Correos-e'
    @form_entity = 'persona_email'
    @form_identity_field = 'tipo_nombre'
    @width_layout = '800'
  end
  
  def common_local
    if action_name!='edit' && action_name!='delete' && action_name!='save_edit' && action_name!='cancel_edit' 
      @empresa_integrante_tipo = EmpresaIntegranteTipo.find(params[:empresa_integrante_tipo_id])
      @empresa = @empresa_integrante_tipo.empresa_integrante.empresa
      @persona = @empresa_integrante_tipo.empresa_integrante.persona
    end
  end
  
  private
  def _list
    conditions = ["persona_email.persona_id = ?", @persona.id]
    params['sort'] = "tipo" unless params['sort']
    
    @list = PersonaEmail.search(conditions, params[:page], params[:sort])
    @total=@list.count
  end
  
end
