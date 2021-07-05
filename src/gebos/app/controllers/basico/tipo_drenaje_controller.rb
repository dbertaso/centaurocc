# encoding: utf-8
class Basico::TipoDrenajeController < FormAjaxController

	def index
		list
	end
	
  def list
    params['sort'] = "nombre" unless params['sort']
    conditions = 'id > 0'
    
    @list = TipoDrenaje.search(conditions, params[:page], params[:sort])
    @total=@list.count
    form_list
  end
	
  def new
    @tipo_drenaje = TipoDrenaje.new
		form_new @tipo_drenaje
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def save_new
    @tipo_drenaje = TipoDrenaje.new(params[:tipo_drenaje])
		form_save_new @tipo_drenaje
  end
  
  def delete
    @tipo_drenaje = TipoDrenaje.find(params[:id])
		form_delete @tipo_drenaje
  end
  
  def edit
    @tipo_drenaje = TipoDrenaje.find(params[:id])
		form_edit @tipo_drenaje
  end

  def save_edit
    @tipo_drenaje = TipoDrenaje.find(params[:id])
		form_save_edit @tipo_drenaje
  end

  def cancel_edit
    @tipo_drenaje = TipoDrenaje.find(params[:id])
		form_cancel_edit @tipo_drenaje
  end
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.TipoDrenaje.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.TipoDrenaje.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.TipoDrenaje.FormTitles.form_title_records')
    @form_entity = 'tipo_drenaje'
    @form_identity_field = 'nombre'
  end
  
end
