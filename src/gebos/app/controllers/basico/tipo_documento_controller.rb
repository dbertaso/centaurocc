# encoding: utf-8

#
# autor: Luis Rojas
# clase: Basico::TipoDocumentoController
# descripción: Migración a Rails 3

class Basico::TipoDocumentoController < FormAjaxController

	def index
		list
	end
	
  def list
    params['sort'] = "tipo" unless params['sort']
    condition = "id > 0"
    
    @list = TipoDocumento.search(condition, params[:page], params[:sort])
    @total=@list.count
    form_list
  end
	
  def new
    @tipo_documento = TipoDocumento.new
		form_new @tipo_documento
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def save_new
    @tipo_documento = TipoDocumento.new(params[:tipo_documento])
		form_save_new @tipo_documento
  end
  
  def delete
    @tipo_documento = TipoDocumento.find(params[:id])
		form_delete @tipo_documento
  end
  
  def edit
    @tipo_documento = TipoDocumento.find(params[:id])
		form_edit @tipo_documento
  end
  def save_edit
    @tipo_documento = TipoDocumento.find(params[:id])
		form_save_edit @tipo_documento
  end
  def cancel_edit
    @tipo_documento = TipoDocumento.find(params[:id])
		form_cancel_edit @tipo_documento
  end
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.TipoDocumento.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.TipoDocumento.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.TipoDocumento.FormTitles.form_title')
    @form_entity = 'tipo_documento'
    @form_identity_field = 'tipo'
  end
  
end
