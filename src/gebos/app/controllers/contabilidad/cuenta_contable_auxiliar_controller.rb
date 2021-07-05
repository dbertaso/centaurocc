# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Contabilidad::CuentaContableAuxiliarController
# descripción: Migración a Rails 3

class Contabilidad::CuentaContableAuxiliarController < FormAjaxTabsController

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
    @cuenta_contable = CuentaContable.find(params[:cuenta_contable_id])
    @cuenta_contable_auxiliar = CuentaContable.new
		form_new @cuenta_contable_auxiliar
  end
  
  def cancel_edit
    @cuenta_contable_auxiliar = CuentaContable.find(params[:id])
    form_cancel_edit @cuenta_contable_auxiliar
  end
  
  def save_new
    @cuenta_contable = CuentaContable.find(params[:cuenta_contable_id])
    @cuenta_contable_auxiliar = CuentaContable.new(params[:cuenta_contable_auxiliar])
    @cuenta_contable_auxiliar.parent = @cuenta_contable
    form_save_new @cuenta_contable_auxiliar
  end
  
  def edit
    @cuenta_contable = CuentaContable.find(params[:cuenta_contable_id])
    @cuenta_contable_auxiliar = CuentaContable.find(params[:id])
    form_edit @cuenta_contable_auxiliar  
  end
  
  def save_edit
    @cuenta_contable = CuentaContable.find(params[:cuenta_contable_id])
    @cuenta_contable_auxiliar = CuentaContable.find(params[:id])
    form_save_edit @cuenta_contable_auxiliar
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def delete
    @cuenta_contable = CuentaContable.find(params[:cuenta_contable_id])
    @cuenta_contable_auxiliar = CuentaContable.find(params[:id])
    form_delete @cuenta_contable_auxiliar
  end

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.Contabilidad.CuentaContableAuxiliar.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.Contabilidad.CuentaContableAuxiliar.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.Contabilidad.CuentaContableAuxiliar.form_title_records')
    @form_entity = 'cuenta_contable_auxiliar'
    @form_identity_field = 'nombre'
  end

  private
  def _list

    @cuenta_contable = CuentaContable.find(params[:cuenta_contable_id])
    conditions = ["parent_id = ?", @cuenta_contable.id]
    @params['sort'] = "codigo" unless @params['sort']

    @pages, @list = paginate(:cuenta_contable, :class_name => 'CuentaContable',
     :conditions => conditions,
     :per_page => @records_by_page,
     :select=>'cuenta_contable.*',
     :order_by => @params['sort'])
    @total=@pages.item_count

  end
end
