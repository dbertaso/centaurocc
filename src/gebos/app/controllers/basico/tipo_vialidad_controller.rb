#encoding: utf-8
class Basico::TipoVialidadController < FormAjaxController

	def index
		list
	end
	
  def list
    params['sort'] = "nombre" unless params['sort']
    conditions = 'id > 0'
    
    @list = TipoVialidad.search(conditions, params[:page], params[:sort])
    @total=@list.count
    form_list
  end
	
  def new
    @tipo_vialidad = TipoVialidad.new
		form_new @tipo_vialidad
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def save_new
    @tipo_vialidad = TipoVialidad.new(params[:tipo_vialidad])
		form_save_new @tipo_vialidad
  end
  
  def delete
    @tipo_vialidad = TipoVialidad.find(params[:id])
		form_delete @tipo_vialidad
  end
  
  def edit
    @tipo_vialidad = TipoVialidad.find(params[:id])
		form_edit @tipo_vialidad
  end

  def save_edit
    @tipo_vialidad = TipoVialidad.find(params[:id])
		form_save_edit @tipo_vialidad
  end

  def cancel_edit
    @tipo_vialidad = TipoVialidad.find(params[:id])
		form_cancel_edit @tipo_vialidad
  end
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.TipoVialidad.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.TipoVialidad.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.TipoVialidad.FormTitles.form_title_records')
    @form_entity = 'tipo_vialidad'
    @form_identity_field = 'nombre'
  end
  
end
