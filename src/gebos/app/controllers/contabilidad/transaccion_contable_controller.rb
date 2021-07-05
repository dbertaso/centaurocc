# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Contabilidad::TransaccionContableController
# descripción: Migración a Rails 3

class Contabilidad::TransaccionContableController < FormTabsController

  def list

    params['sort'] = "nombre" unless params['sort']
    unless params[:nombre].nil?
      conditions = ["LOWER(nombre) LIKE ?", "%#{params[:nombre].strip.downcase}%"]
      @form_search_expression << "Nombre contenga '#{params[:nombre]}'"
    end

    @list = TransaccionContable.search(conditions, params[:page], params[:sort])
    @total=@list.count

    form_list

  end
	
  def new
    @transaccion_contable = TransaccionContable.new
  end
  
  def cancel_new
    form_cancel_new
  end
  
  def save_new
    @transaccion_contable = TransaccionContable.new(params[:transaccion_contable])
    form_save_new @transaccion_contable
  end

  def cancel_edit
    @cuenta_contable = TransaccionContable.find(params[:id])
    form_cancel_edit @cuenta_contable
  end

  def delete
    @cuenta_contable = TransaccionContable.find(params[:id])
    form_delete @cuenta_contable
  end

  def edit
    @transaccion_contable = TransaccionContable.find(params[:id])
  end

  def view
    @transaccion_contable = TransaccionContable.find(params[:id])
  end

  def save_edit
    @transaccion_contable = TransaccionContable.find(params[:id])
    form_save_edit @transaccion_contable
  end

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.Contabilidad.TransaccionContable.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.Contabilidad.TransaccionContable.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.Contabilidad.TransaccionContable.FormTitles.form_title_records')
    @form_entity = 'transaccion_contable'
    @form_identity_field = 'nombre'
  end

end
