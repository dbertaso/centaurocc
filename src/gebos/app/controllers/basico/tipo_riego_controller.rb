# encoding: utf-8
class Basico::TipoRiegoController < FormAjaxController

	def index
		list
	end
	
  def list
    params['sort'] = "nombre" unless params['sort']
    conditions = 'id > 0'
    
    @list = TipoRiego.search(conditions, params[:page], params[:sort])
    @total=@list.count
    form_list
  end
	
  def new
    @tipo_riego = TipoRiego.new
		form_new @tipo_riego
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def save_new
    @tipo_riego = TipoRiego.new(params[:tipo_riego])
		form_save_new @tipo_riego
  end
  
  def delete
    @tipo_riego = TipoRiego.find(params[:id])
		form_delete @tipo_riego
  end
  
  def edit
    @tipo_riego = TipoRiego.find(params[:id])
		form_edit @tipo_riego
  end

  def save_edit
    @tipo_riego = TipoRiego.find(params[:id])
		form_save_edit @tipo_riego
  end

  def cancel_edit
    @tipo_riego = TipoRiego.find(params[:id])
		form_cancel_edit @tipo_riego
  end
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.TipoRiego.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.TipoRiego.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.TipoRiego.FormTitles.form_title_records')
    @form_entity = 'tipo_riego'
    @form_identity_field = 'nombre'
  end
end
