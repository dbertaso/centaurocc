# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Basico::ProgramaTipoClienteController
# descripción: Migración a Rails 3
#
class Basico::ProgramaTipoClienteController < FormAjaxTabsController

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
    @programa = Programa.find(params[:programa_id])
    @tipo_cliente = TipoCliente.new
    fill_tipo_cliente
    form_new @tipo_cliente
  end

  def save_new
    @programa = Programa.find(params[:programa_id])
    @tipo_cliente = TipoCliente.find(params[:tipo_cliente][:id])
    form_save_new @tipo_cliente, :value=>@programa.add_tipo_cliente(@tipo_cliente)
  end

  def cancel_new
    form_cancel_new
  end

  def delete
    @programa = Programa.find(params[:programa_id])
    @tipo_cliente = TipoCliente.find(params[:id])
    form_delete @tipo_cliente, @programa.tipos_cliente.delete(@tipo_cliente)
  end

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.ProgramaTipoCliente.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.ProgramaTipoCliente.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.ProgramaTipoCliente.FormTitles.form_title_records')
    @form_entity = 'tipo_cliente'
    @form_identity_field = 'nombre'
    @width_layout = 850
  end

  private
  def fill_tipo_cliente
    @tipo_cliente_select = TipoCliente.find(:all, :order=>'nombre', :conditions=>" ( tipo_cliente.id not in (select tipo_cliente_id from programa_tipo_cliente where programa_id = #{@programa.id} )) ")
  end

  def _list
    @programa = Programa.find(params[:programa_id])
    conditions = ["programa_tipo_cliente.programa_id = ?", @programa.id]
    params['sort'] = "tipo_cliente.nombre" unless params['sort']
    
    @list = TipoCliente.search(conditions, params[:page], params[:sort])
    @total=@list.count

  end

end
