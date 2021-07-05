class Basico::TenenciaUnidadProduccionController < FormAjaxController

  def index
    list
  end

  def list
    
    params['sort'] = "nombre" unless params['sort']
    conditions = 'id > 0'
    
    @list = TenenciaUnidadProduccion.search(conditions, params[:page], params[:sort])
    @total=@list.count

    form_list
  end

  def new
    @tenencia_unidad_produccion = TenenciaUnidadProduccion.new
    form_new @tenencia_unidad_produccion
  end

  def save_new
    @tenencia_unidad_produccion = TenenciaUnidadProduccion.new(params[:tenencia_unidad_produccion])
    form_save_new @tenencia_unidad_produccion
  end
  
  def cancel_new
		form_cancel_new
  end

  def delete
    @tenencia_unidad_produccion = TenenciaUnidadProduccion.find(params[:id])
    result = @tenencia_unidad_produccion.eliminar(params[:id])
    if result == false
      render :update do |page|
        page.form_error
      end
      return
    else
      render :update do |page|
        page.form_delete @tenencia_unidad_produccion, 'tenencia_unidad_produccion'
      end
    end
  end
  
  def edit
    @tenencia_unidad_produccion = TenenciaUnidadProduccion.find(params[:id])
    form_edit @tenencia_unidad_produccion
  end
  
  def save_edit
    @tenencia_unidad_produccion = TenenciaUnidadProduccion.find(params[:id])
    form_save_edit @tenencia_unidad_produccion
  end

  def cancel_edit
    @tenencia_unidad_produccion = TenenciaUnidadProduccion.find(params[:id])
    form_cancel_edit @tenencia_unidad_produccion
  end
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.TenenciaUnidadProduccion.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.TenenciaUnidadProduccion.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.TenenciaUnidadProduccion.FormTitles.form_title_records')
    @form_entity = 'tenencia_unidad_produccion'
    @form_identity_field = 'nombre'
  end
  
end
