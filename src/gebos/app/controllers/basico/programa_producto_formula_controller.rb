# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Basico::ProgramaProductoFormulaController
# descripción: Migración a Rails 3
#
class Basico::ProgramaProductoFormulaController < FormAjaxTabsController

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
    @producto = Producto.find(params[:producto_id])
    @producto_formula = Formula.new
    fill_producto_formula
    form_new @producto_formula
  end

  def save_new
    @programa = Programa.find(params[:programa_id])
    @producto = Producto.find(params[:producto_id])
    @formula = Formula.find(params[:formula][:id])
    form_save_new @formula, :value=>@producto.add_formula(@formula)
  end

  def cancel_new
    form_cancel_new
  end

  def delete
    @programa = Programa.find(params[:programa_id])
    @producto = Producto.find(params[:producto_id])
    @formula = Formula.find(params[:id])
    producto_formula = ProductoFormula.delete_registro(@producto.id, @formula.id)
    if producto_formula == true
    render :update do |page|
        page.form_delete @formula, I18n.t('Sistema.Body.Controladores.ProgramaProductoFormula.FormTitles.form_title_record')
      end
    else
      @programa.errors.add(:programa, I18n.t('Sistema.Body.Modelos.Errores.item_utilizado'))
      flash[:notice]=nil
      flash[:error]=@programa
    end
  end

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.ProgramaProductoFormula.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.ProgramaProductoFormula.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.ProgramaProductoFormula.FormTitles.form_title_records')
    @form_entity = 'formula'
    @form_identity_field = 'nombre'
    @width_layout = 850
  end

  private
  def fill_producto_formula
    @formula_select = Formula.find(:all, :order=>'nombre',
      :conditions=>" formula.id not in (select formula_id from producto_formula where producto_id = #{@producto.id} )  ")
  end

  def _list
    @programa = Programa.find(params[:programa_id])
    @producto = Producto.find(params[:producto_id])
    conditions = ["producto_formula.producto_id = ?", @producto.id]
    joins = 'INNER JOIN producto_formula ON producto_formula.formula_id = formula.id'
    params['sort'] = "formula.nombre" unless params['sort']
    
    @list = Formula.search(conditions, params[:page], params[:sort])
    @total=@list.count

  end
end
