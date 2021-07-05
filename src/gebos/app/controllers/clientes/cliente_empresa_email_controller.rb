# encoding: utf-8
#
# autor: Luis Rojas
# clase: Clientes::ClienteEmpresaTelefonoController
# descripción: Migración a Rails 3
#
class Clientes::ClienteEmpresaEmailController < FormAjaxTabsController

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
    @empresa = Empresa.find(params[:empresa_id])    
    @empresa_email = EmpresaEmail.new
		form_new @empresa_email
  end
  
  def save_new
    @empresa = Empresa.find(params[:empresa_id])
    @empresa_email = EmpresaEmail.new(params[:empresa_email])
    @empresa_email.empresa = @empresa
    form_save_new @empresa_email
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def delete
    @empresa = Empresa.find(params[:empresa_id])
    @empresa_email = EmpresaEmail.find(params[:id])
    form_delete @empresa_email
  end
  
  def edit
    @empresa = Empresa.find(params[:empresa_id])    
    @empresa_email = EmpresaEmail.find(params[:id])
		form_edit @empresa_email
  end

  def cancel_edit
    @empresa_email = EmpresaEmail.find(params[:id])
    form_cancel_edit @empresa_email
  end
  
  def save_edit
    @empresa = Empresa.find(params[:empresa_id])
    @empresa_email = EmpresaEmail.find(params[:id])
    form_save_edit @empresa_email
  end
  
  protected
  def common
    super
    @form_title = "#{I18n.t('Sistema.Body.General.beneficiario')} #{I18n.t('Sistema.Body.Vistas.General.juridico')}"
    @form_title_record = I18n.t('Sistema.Body.Vistas.General.correo_electronico')
    @form_title_records = I18n.t('Sistema.Body.Vistas.General.correo_electronico')
    @form_entity = 'empresa_email'
    @form_identity_field = 'tipo_nombre'
    @width_layout = '800'
  end
  private
  def _list
    @empresa = Empresa.find(params[:empresa_id])
    conditions = ["empresa_email.empresa_id = ?", @empresa.id]
    params['sort'] = "tipo" unless params['sort']
    
    @list = EmpresaEmail.search(conditions, params[:page], params[:sort])    
    @total=@list.count
  end
  
end
