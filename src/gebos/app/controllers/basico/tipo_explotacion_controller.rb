# encoding: utf-8
class Basico::TipoExplotacionController < FormAjaxController

  def index
    list
  end

  def list
    params['sort'] = "nombre" unless params['sort']
    conditions = 'id >0'
    
    @list = TipoExplotacion.search(conditions, params[:page], params[:sort])
    @total=@list.count
    form_list
  end

  def new
    @tipo_explotacion = TipoExplotacion.new
    form_new @tipo_explotacion
  end

  def save_new
    @tipo_explotacion = TipoExplotacion.new(params[:tipo_explotacion])
    form_save_new @tipo_explotacion
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def delete
    @tipo_explotacion = TipoExplotacion.find(params[:id])
    form_delete @tipo_explotacion
  end
  
  def edit
    @tipo_explotacion = TipoExplotacion.find(params[:id])
    form_edit @tipo_explotacion
  end
  
  def save_edit
    @tipo_explotacion = TipoExplotacion.find(params[:id])
    form_save_edit @tipo_explotacion
  end

  def cancel_edit
    @tipo_explotacion = TipoExplotacion.find(params[:id])
    form_cancel_edit @tipo_explotacion
  end
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.TipoExplotacion.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.TipoExplotacion.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.TipoExplotacion.FormTitles.form_title_records')
    @form_entity = 'tipo_explotacion'
    @form_identity_field = 'nombre'
  end
  
end
