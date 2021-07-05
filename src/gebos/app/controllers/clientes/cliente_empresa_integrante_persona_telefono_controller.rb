# encoding: utf-8
#
# autor: Luis Rojas
# clase: Clientes::ClienteEmpresaIntegrantePersonaTelefonoController
# descripción: Migración a Rails 3
#
class Clientes::ClienteEmpresaIntegrantePersonaTelefonoController < FormAjaxTabsController

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
		form_new @persona_telefono
  end
  
  def save_new
    @persona_telefono = PersonaTelefono.new(params[:persona_telefono])
    @persona_telefono.persona = @persona
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
    @form_title = "#{I18n.t('Sistema.Body.General.beneficiario')} #{I18n.t('Sistema.Body.Vistas.General.juridico')}"
    @form_title_record = I18n.t('Sistema.Body.Vistas.General.telefono')
    @form_title_records = I18n.t('Sistema.Body.Vistas.General.telefonos')
    @form_entity = 'persona_telefono'
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
    conditions = ["persona_telefono.persona_id = ?", @persona.id]
    params['sort'] = "tipo" unless params['sort']
    
    @list = PersonaTelefono.search(conditions, params[:page], params[:sort])
    @total=@list.count

  end
end
