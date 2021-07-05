# enconding: utf-8
class Basico::TipoEmbarcacionController < FormAjaxController

  def index
    list
  end

  def list
    params['sort'] = "tipo" unless params['sort']
    conditions = 'id > 0'
    
    @list = TipoEmbarcacion.search(conditions, params[:page], params[:sort])
    @total=@list.count
    form_list
  end

  def new
    @tipo_embarcacion = TipoEmbarcacion.new
    form_new @tipo_embarcacion
  end

  def save_new
    @tipo_embarcacion = TipoEmbarcacion.new(params[:tipo_embarcacion])
    form_save_new @tipo_embarcacion
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def delete
    @tipo_embarcacion = TipoEmbarcacion.find(params[:id])
    form_delete @tipo_embarcacion
  end
  
  def edit
    @tipo_embarcacion = TipoEmbarcacion.find(params[:id])
    form_edit @tipo_embarcacion
  end

  def save_edit
    @tipo_embarcacion = TipoEmbarcacion.find(params[:id])
    form_save_edit @tipo_embarcacion
  end

  def cancel_edit
    @tipo_embarcacion = TipoEmbarcacion.find(params[:id])
    form_cancel_edit @tipo_embarcacion
  end

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.TipoEmbarcacion.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.TipoEmbarcacion.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.TipoEmbarcacion.FormTitles.form_title_records')
    @form_entity = 'tipo_embarcacion'
    @form_identity_field = 'tipo'
  end
  
end
