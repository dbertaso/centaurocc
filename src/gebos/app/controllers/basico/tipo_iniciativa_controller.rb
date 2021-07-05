class Basico::TipoIniciativaController < FormAjaxController

  def index
    list
  end

  def list
    params['sort'] = "nombre" unless params['sort']
    conditions = 'id > 0'
    
    @list = TipoIniciativa.search(conditions, params[:page], params[:sort])
    @total=@list.count
    form_list
  end

  def new
    @tipo_iniciativa = TipoIniciativa.new
    form_new @tipo_iniciativa
  end

  def save_new
    @tipo_iniciativa = TipoIniciativa.new(params[:tipo_iniciativa])
    form_save_new @tipo_iniciativa
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def delete
    @tipo_iniciativa = TipoIniciativa.find(params[:id])
    form_delete @tipo_iniciativa
  end
  
  def edit
    @tipo_iniciativa = TipoIniciativa.find(params[:id])
    form_edit @tipo_iniciativa
  end
  
  def save_edit
    @tipo_iniciativa = TipoIniciativa.find(params[:id])
    form_save_edit @tipo_iniciativa
  end

  def cancel_edit
    @tipo_iniciativa = TipoIniciativa.find(params[:id])
    form_cancel_edit @tipo_iniciativa
  end
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.TipoIniciativa.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.TipoIniciativa.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.TipoIniciativa.FormTitles.form_title_records')
    @form_entity = 'tipo_iniciativa'
    @form_identity_field = 'nombre'
  end
  
end
