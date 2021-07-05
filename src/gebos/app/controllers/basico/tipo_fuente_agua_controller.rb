# encoding: utf-8
class Basico::TipoFuenteAguaController < FormAjaxController

	def index
		list
	end
	
  def list
    params['sort'] = "nombre" unless params['sort']
    conditions = 'id > 0'
    
    @list = TipoFuenteAgua.search(conditions, params[:page], params[:sort])
    @total=@list.count
    form_list
  end
	
  def new
    @tipo_fuente_agua = TipoFuenteAgua.new
		form_new @tipo_fuente_agua
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def save_new
    @tipo_fuente_agua = TipoFuenteAgua.new(params[:tipo_fuente_agua])
		form_save_new @tipo_fuente_agua
  end
  
  def delete
    @tipo_fuente_agua = TipoFuenteAgua.find(params[:id])
		form_delete @tipo_fuente_agua
  end
  
  def edit
    @tipo_fuente_agua = TipoFuenteAgua.find(params[:id])
		form_edit @tipo_fuente_agua
  end

  def save_edit
    @tipo_fuente_agua = TipoFuenteAgua.find(params[:id])
		form_save_edit @tipo_fuente_agua
  end

  def cancel_edit
    @tipo_fuente_agua = TipoFuenteAgua.find(params[:id])
		form_cancel_edit @tipo_fuente_agua
  end
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.TipoFuenteAgua.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.TipoFuenteAgua.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.TipoFuenteAgua.FormTitles.form_title_records')
    @form_entity = 'tipo_fuente_agua'
    @form_identity_field = 'nombre'
  end
  
end
