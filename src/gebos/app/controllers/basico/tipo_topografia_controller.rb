#encoding: utf-8
class Basico::TipoTopografiaController < FormAjaxController

	def index
		list
	end
	
  def list
    params['sort'] = "nombre" unless params['sort']
    conditions = 'id > 0'
    
    @list = TipoTopografia.search(conditions, params[:page], params[:sort])
    @total=@list.count
    form_list
  end
	
  def new
    @tipo_topografia = TipoTopografia.new
		form_new @tipo_topografia
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def save_new
    @tipo_topografia = TipoTopografia.new(params[:tipo_topografia])
		form_save_new @tipo_topografia
  end
  
  def delete
    @tipo_topografia = TipoTopografia.find(params[:id])
		form_delete @tipo_topografia
  end
  
  def edit
    @tipo_topografia = TipoTopografia.find(params[:id])
		form_edit @tipo_topografia
  end

  def save_edit
    @tipo_topografia = TipoTopografia.find(params[:id])
		form_save_edit @tipo_topografia
  end

  def cancel_edit
    @tipo_topografia = TipoTopografia.find(params[:id])
		form_cancel_edit @tipo_topografia
  end
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.TipoTopografia.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.TipoTopografia.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.TipoTopografia.FormTitles.form_title_records')
    @form_entity = 'tipo_topografia'
    @form_identity_field = 'nombre'
  end
  
end
