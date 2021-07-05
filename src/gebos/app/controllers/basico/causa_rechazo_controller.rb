# encoding: UTF-8

#
# autor: Marvin Alfonzo
# clase: Basico::CausaRechazoController
# descripción: Migración a Rails 3
#

class Basico::CausaRechazoController < FormAjaxController

skip_before_filter :set_charset, :only=>[:ciudad_search, :municipio_search, :parroquia_search, :tabs]

	def index
		list
	end
	
  def list

    params['sort'] = "nombre" unless params['sort']

    
    conditions=''
    @list = CausaRechazo.search(conditions, params[:page], params['sort'])
    @total=@list.count
    
    form_list

  end
	
  def new
    @causa_rechazo = CausaRechazo.new
		form_new @causa_rechazo
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def save_new
    @causa_rechazo = CausaRechazo.new(params[:causa_rechazo])
		form_save_new @causa_rechazo
  end
  
  def delete
    @causa_rechazo = CausaRechazo.find(params[:id])
		form_delete @causa_rechazo
  end
  
  def edit
    @causa_rechazo = CausaRechazo.find(params[:id])
		form_edit @causa_rechazo
  end
  def save_edit
    @causa_rechazo = CausaRechazo.find(params[:id])
		form_save_edit @causa_rechazo
  end
  def cancel_edit
    @causa_rechazo = CausaRechazo.find(params[:id])
		form_cancel_edit @causa_rechazo
  end
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.CausaRechazo.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.CausaRechazo.FormTitles.form_title')
    @form_title_records = I18n.t('Sistema.Body.Controladores.CausaRechazo.FormTitles.form_title_records')
    @form_entity = 'causa_rechazo'
    @form_identity_field = 'nombre'
  end
  
end
