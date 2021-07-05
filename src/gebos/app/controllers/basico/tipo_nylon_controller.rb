# encoding: utf-8
class Basico::TipoNylonController < FormAjaxController

  def index
    list
  end

  def list
    params['sort'] = "tipo" unless params['sort']
    conditions = 'id > 0'
    
    @list = TipoNylon.search(conditions, params[:page], params[:sort])
    @total=@list.count
    form_list
  end

  def new
    @tipo_nylon = TipoNylon.new
    form_new @tipo_nylon
  end

  def save_new
    @tipo_nylon = TipoNylon.new(params[:tipo_nylon])
    form_save_new @tipo_nylon
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def delete
    @tipo_nylon = TipoNylon.find(params[:id])
    form_delete @tipo_nylon
  end
  
  def edit
    @tipo_nylon = TipoNylon.find(params[:id])
    form_edit @tipo_nylon
  end

  def save_edit
    @tipo_nylon = TipoNylon.find(params[:id])
    form_save_edit @tipo_nylon
  end

  def cancel_edit
    @tipo_nylon = TipoNylon.find(params[:id])
    form_cancel_edit @tipo_nylon
  end

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.TipoNylon.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.TipoNylon.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.TipoNylon.FormTitles.form_title_records')
    @form_entity = 'tipo_nylon'
    @form_identity_field = 'tipo'
  end
  
end
