# encoding: utf-8
class Basico::TipoPastoForrajeController < FormAjaxController

	def index
		list
	end
	
  def list

    params['sort'] = "descripcion" unless params['sort']
    conditions = 'id > 0'
    
    @list = TipoPastoForraje.search(conditions, params[:page], params[:sort])
    @total=@list.count
    form_list
  end
	
  def new
    @tipo_pasto_forraje = TipoPastoForraje.new
		form_new @tipo_pasto_forraje
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def save_new
    @tipo_pasto_forraje = TipoPastoForraje.new(params[:tipo_pasto_forraje])
		form_save_new @tipo_pasto_forraje
  end
  
  def delete
    @tipo_pasto_forraje = TipoPastoForraje.find(params[:id])
		form_delete @tipo_pasto_forraje
  end
  
  def edit
    @tipo_pasto_forraje = TipoPastoForraje.find(params[:id])
		form_edit @tipo_pasto_forraje
  end
  def save_edit
    @tipo_pasto_forraje = TipoPastoForraje.find(params[:id])
		form_save_edit @tipo_pasto_forraje
  end
  def cancel_edit
    @tipo_pasto_forraje = TipoPastoForraje.find(params[:id])
		form_cancel_edit @tipo_pasto_forraje
  end
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.TipoPastoForraje.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.TipoPastoForraje.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.TipoPastoForraje.FormTitles.form_title_records')
    @form_entity = 'tipo_pasto_forraje'
    @form_identity_field = 'descripcion'
  end
  
end
