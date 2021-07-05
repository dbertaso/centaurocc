# encoding: utf-8
class Basico::TipoInfraestructuraController < FormAjaxController

	def index
		list
	end
	
  def list
    params['sort'] = "nombre" unless params['sort']
    conditions = 'id > 0'
    
    @list = TipoInfraestructura.search(conditions, params[:page], params[:sort])
    @total=@list.count
    form_list
  end
	
  def new
    @tipo_infraestructura = TipoInfraestructura.new
		form_new @tipo_infraestructura
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def save_new
    @tipo_infraestructura = TipoInfraestructura.new(params[:tipo_infraestructura])
		form_save_new @tipo_infraestructura
  end
  
  def delete
    @tipo_infraestructura = TipoInfraestructura.find(params[:id])
		form_delete @tipo_infraestructura
  end
  
  def edit
    @tipo_infraestructura = TipoInfraestructura.find(params[:id])
		form_edit @tipo_infraestructura
  end

  def save_edit
    @tipo_infraestructura = TipoInfraestructura.find(params[:id])
		form_save_edit @tipo_infraestructura
  end

  def cancel_edit
    @tipo_infraestructura = TipoInfraestructura.find(params[:id])
		form_cancel_edit @tipo_infraestructura
  end
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.TipoInfraestructura.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.TipoInfraestructura.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.TipoInfraestructura.FormTitles.form_title_records')
    @form_entity = 'tipo_infraestructura'
    @form_identity_field = 'nombre'
  end
  
end
