# encoding: utf-8
#
# autor: Luis Rojas
# clase: Clientes::ClienteEmpresaDireccionController
# descripción: Migración a Rails 3
#

class Clientes::ClienteEmpresaDireccionTelefonoController < FormAjaxTabsController

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
    @empresa_direccion = EmpresaDireccion.find(params[:empresa_direccion_id])    
    @empresa_telefono = EmpresaTelefono.new
    @empresa_telefono.tipo = @empresa_direccion.tipo
		form_new @empresa_telefono
  end
  
  def save_new
    @empresa = Empresa.find(params[:empresa_id])
    @empresa_direccion = EmpresaDireccion.find(params[:empresa_direccion_id])
    @empresa_telefono = EmpresaTelefono.new(params[:empresa_telefono])
    @empresa_telefono.empresa_direccion = @empresa_direccion
    @empresa_telefono.empresa = @empresa
    @empresa_telefono.tipo = @empresa_direccion.tipo
    form_save_new @empresa_telefono
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def delete
    @empresa_telefono = EmpresaTelefono.find(params[:id])
    form_delete @empresa_telefono
  end
  
  def edit
    @empresa_telefono = EmpresaTelefono.find(params[:id])
		form_edit @empresa_telefono
  end

  def cancel_edit
    @empresa_telefono = EmpresaTelefono.find(params[:id])
    form_cancel_edit @empresa_telefono
  end
  
  def save_edit
    @empresa_telefono = EmpresaTelefono.find(params[:id])
    form_save_edit @empresa_telefono

  end
  
  protected
  def common
    super
    @form_title = "#{I18n.t('Sistema.Body.General.beneficiario')} #{I18n.t('Sistema.Body.Vistas.General.juridico')}"
    @form_title_record = I18n.t('Sistema.Body.Vistas.General.telefono')
    @form_title_records = I18n.t('Sistema.Body.Vistas.General.telefonos')
    @form_entity = 'empresa_telefono'
    @form_identity_field = 'tipo_nombre'
    @width_layout = '800'
  end
  private
  def _list
    @empresa = Empresa.find(params[:empresa_id])
    @empresa_direccion = EmpresaDireccion.find(params[:empresa_direccion_id])
    conditions = ["empresa_telefono.empresa_direccion_id = ?", @empresa_direccion.id]
    params['sort'] = "tipo" unless params['sort']
    
    @list = EmpresaTelefono.search(conditions, params[:page], params[:sort])
    @total=@list.count


  end
  
end
