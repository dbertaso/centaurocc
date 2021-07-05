# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Basico::PrecioGacetaController
# descripción: Migración a Rails 3
#
class Basico::PrecioGacetaController < FormTabsController

  skip_before_filter :set_charset, :only=>[:edit, :tabs, :calendar]
  def index
    list
  end

  def list
    params['sort'] = "status" unless params['sort']
    @condition = "id > 0"
    
    @list = PrecioGaceta.search(@condition, params[:page], params[:sort])
    @total=@list.count
    form_list
  end

  def new
    @precio_gaceta = PrecioGaceta.new
  end

  def cancel_new
    form_cancel_new
  end

  def save_new
     params[:precio_gaceta][:status] = true
    @precio_gaceta = PrecioGaceta.new(params[:precio_gaceta])
    form_save_new @precio_gaceta
  end

  def delete
    @precio_gaceta = PrecioGaceta.find(params[:id])
     result = @precio_gaceta.eliminar(params[:id])
    if result == false
      render :update do |page|
        page.form_error
      end
      return
    else
      render :update do |page|
        page.form_delete @precio_gaceta, 'precio_gaceta'
      end
    end
  end

  def edit
    @precio_gaceta = PrecioGaceta.find(params[:id])
  end

  def save_edit
    @precio_gaceta = PrecioGaceta.find(params[:id])
    form_save_edit @precio_gaceta
  end

  def cancel_edit
    @precio_gaceta = PrecioGaceta.find(params[:id])
    form_cancel_edit @precio_gaceta
  end

  def view
    @precio_gaceta = PrecioGaceta.find(params[:id])
  end

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.PrecioGaceta.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.PrecioGaceta.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.PrecioGaceta.FormTitles.form_title_records')
    @form_entity = 'precio_gaceta'
    @form_identity_field = 'gaceta_oficial'
  end

end
