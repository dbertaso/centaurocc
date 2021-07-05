#encoding: utf-8
class Basico::TipoSueloController < FormAjaxController

	def index
		list
	end
	
  def list
    params['sort'] = "nombre" unless params['sort']
    conditions = 'id > 0'
    
    @list = TipoSuelo.search(conditions, params[:page], params[:sort])
    @total=@list.count
    form_list
  end
	
  def new
    @tipo_suelo = TipoSuelo.new
		form_new @tipo_suelo
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def save_new
    @tipo_suelo = TipoSuelo.new(params[:tipo_suelo])
		form_save_new @tipo_suelo
  end
  
  def delete
    @tipo_suelo = TipoSuelo.find(params[:id])
		form_delete @tipo_suelo
  end
  
  def edit
    @tipo_suelo = TipoSuelo.find(params[:id])
		form_edit @tipo_suelo
  end

  def save_edit
    @tipo_suelo = TipoSuelo.find(params[:id])
		form_save_edit @tipo_suelo
  end

  def cancel_edit
    @tipo_suelo = TipoSuelo.find(params[:id])
		form_cancel_edit @tipo_suelo
  end
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.TipoSuelo.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.TipoSuelo.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.TipoSuelo.FormTitles.form_title_records')
    @form_entity = 'tipo_suelo'
    @form_identity_field = 'nombre'
  end
  
end
