# encoding: utf-8

#
# autor: Luis Rojas
# clase: Basico::TipoCreditoController
# descripción: Migración a Rails 3

class Basico::TipoCreditoController < FormAjaxController

	def index
		list
	end
	
  def list

    params['sort'] = "nombre" unless params['sort']
    condition = "id > 0"
    
    @list = TipoCredito.search(condition, params[:page], params[:sort])
    @total=@list.count

    form_list

  end

  def edit
    @tipo_credito = TipoCredito.find(params[:id])
    form_edit @tipo_credito
  end
  
  def save_edit
    @tipo_credito = TipoCredito.find(params[:id])
    form_save_edit @tipo_credito
  end
  
  def cancel_edit
    @tipo_credito = TipoCredito.find(params[:id])
    form_cancel_edit @tipo_credito
  end
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.TipoCredito.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.TipoCredito.FormTitles.form_title')
    @form_title_records = I18n.t('Sistema.Body.Controladores.TipoCredito.FormTitles.form_title_records')
    @form_entity = 'tipo_credito'
    @form_identity_field = 'nombre'
  end
  
end
