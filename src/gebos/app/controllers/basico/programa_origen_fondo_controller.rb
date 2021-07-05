# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Basico::ProgramaOrigenFondoController
# descripción: Migración a Rails 3
#
class Basico::ProgramaOrigenFondoController < FormAjaxTabsController

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
    @origen_fondo = OrigenFondo.new
    fill_origen_fondo
    fill_cuenta_contable
    form_new @origen_fondo
  end

  def save_new
    @programa = Programa.find(params[:programa_id])
    @programa_origen_fondo = ProgramaOrigenFondo.new(params[:programa_origen_fondo])
    @programa_origen_fondo.programa = @programa
    form_save_new @programa_origen_fondo
  end

  def edit
    @programa = Programa.find(params[:programa_id])
    @programa_origen_fondo = ProgramaOrigenFondo.find(params[:id])
    fill_origen_fondo_edit
    fill_cuenta_contable
    form_edit @programa_origen_fondo
  end

  def save_edit
    @programa = Programa.find(params[:programa_id])
    @programa_origen_fondo = ProgramaOrigenFondo.find(params[:id])
    @programa_origen_fondo.attributes = params[:programa_origen_fondo]
    form_save_edit @programa_origen_fondo
  end
  def cancel_new
    form_cancel_new
  end

  def cancel_edit
    @programa_origen_fondo = ProgramaOrigenFondo.find(params[:id])
    form_cancel_edit @programa_origen_fondo
  end

  def delete
    @programa = Programa.find(params[:programa_id])
    @programa_origen_fondo = ProgramaOrigenFondo.find(params[:id])
    form_delete @programa_origen_fondo
  end

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.ProgramaOrigenFondo.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.ProgramaOrigenFondo.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.ProgramaOrigenFondo.FormTitles.form_title_records')
    @form_entity = 'origen_fondo'
    @form_identity_field = 'origen_fondo.nombre'
    @width_layout = 850
  end

  private

  def fill_origen_fondo
    @origen_fondo_select = OrigenFondo.find(:all, :order=>'nombre', :conditions=>"activo = true and ( origen_fondo.id not in (select origen_fondo_id from programa_origen_fondo where programa_id = #{@programa.id} ) ) ")
  end

  def fill_origen_fondo_edit
    @origen_fondo_select = OrigenFondo.find(:all, :order=>'nombre', :conditions=>"activo = true ")
  end

  def _list
    @programa = Programa.find(params[:programa_id])
    @condition = ["programa_origen_fondo.programa_id = ?", @programa.id]
    params['sort'] = "origen_fondo.nombre" unless params['sort']
    
    @list = ProgramaOrigenFondo.search(@condition, params[:page], params[:sort])
    @total=@list.count
  end

  def fill_cuenta_contable
    @cuenta_contable_ingreso_interes_select = CuentaContable.find(:all, :order=>'nombre')
    @cuenta_contable_capital_select = CuentaContable.find(:all, :order=>'nombre')
    @cuenta_contable_capital_vencido_select = CuentaContable.find(:all, :order=>'nombre')
  end

end
