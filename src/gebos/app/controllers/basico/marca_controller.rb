#encoding: utf-8
class Basico::MarcaController < FormAjaxController

  def index
    list
  end

  def list
    
    params['sort'] = "nombre" unless params['sort']
    conditions = 'id > 0'
    
    @list = Marca.search(conditions, params[:page], params[:sort])
    @total=@list.count
    form_list
  end

  def new
    @marca = Marca.new
    form_new @marca
  end

  def save_new
    @marca = Marca.new(params[:marca])
    form_save_new @marca
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def delete
    @marca = Marca.find(params[:id])
    form_delete @marca
  end
  
  def edit
    @marca = Marca.find(params[:id])
    form_edit @marca
  end

  def save_edit
    @marca = Marca.find(params[:id])
    form_save_edit @marca
  end

  def cancel_edit
    @marca = Marca.find(params[:id])
    form_cancel_edit @marca
  end

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.Marca.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.Marca.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.Marca.FormTitles.form_title_records')
    @form_entity = 'marca'
    @form_identity_field = 'nombre'
  end
  
end
