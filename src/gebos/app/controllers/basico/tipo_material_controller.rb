# encoding: utf-8
class Basico::TipoMaterialController < FormAjaxController

  def index
    list
  end

  def list    
    params['sort'] = "tipo" unless params['sort']
    conditions = 'id > 0'
    
    @list = TipoMaterial.search(conditions, params[:page], params[:sort])
    @total=@list.count
    form_list
  end

  def new
    @tipo_material = TipoMaterial.new
    form_new @tipo_material
  end

  def save_new
    @tipo_material = TipoMaterial.new(params[:tipo_material])
    form_save_new @tipo_material
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def delete
    @tipo_material = TipoMaterial.find(params[:id])
    form_delete @tipo_material
  end
  
  def edit
    @tipo_material = TipoMaterial.find(params[:id])
    form_edit @tipo_material
  end

  def save_edit
    @tipo_material = TipoMaterial.find(params[:id])
    form_save_edit @tipo_material
  end

  def cancel_edit
    
    @tipo_material = TipoMaterial.find(params[:id])
    form_cancel_edit @tipo_material
  end

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.TipoMaterial.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.TipoMaterial.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.TipoMaterial.FormTitles.form_title_records')
    @form_entity = 'tipo_material'
    @form_identity_field = 'tipo'
  end
  
end
