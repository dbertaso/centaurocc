# encoding: utf-8
class Basico::CondicionPastoController < FormAjaxController

	def index
		list
	end
	
  def list
    params['sort'] = "nombre" unless params['sort']
    conditions = "id > 0"
    
    @list = CondicionPasto.search(conditions, params[:page], params[:sort])
    @total=@list.count
    form_list
  end
	
  def new
    @condicion_pasto = CondicionPasto.new
		form_new @condicion_pasto
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def save_new
    @condicion_pasto = CondicionPasto.new(params[:condicion_pasto])
		form_save_new @condicion_pasto
  end
  
  def delete
    @condicion_pasto = CondicionPasto.find(params[:id])
		form_delete @condicion_pasto
  end
  
  def edit
    @condicion_pasto = CondicionPasto.find(params[:id])
		form_edit @condicion_pasto
  end
  
  def save_edit
    @condicion_pasto = CondicionPasto.find(params[:id])
		form_save_edit @condicion_pasto
  end
  
  def cancel_edit
    @condicion_pasto = CondicionPasto.find(params[:id])
		form_cancel_edit @condicion_pasto
  end
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Vistas.CondicionPasto.Header.form_title')
    @form_title_record = I18n.t('Sistema.Body.Vistas.CondicionPasto.Header.form_title')
    @form_title_records = I18n.t('Sistema.Body.Vistas.CondicionPasto.Header.form_title')
    @form_entity = 'condicion_pasto'
    @form_identity_field = 'nombre'
  end
  
end
