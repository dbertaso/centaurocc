# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Basico::InstrumentoFinancieroController
# descripción: Migración a Rails 3
#

class Basico::InstrumentoFinancieroController < FormAjaxController

	def index
		list
	end
	
  def list

    params['sort'] = "descripcion" unless params['sort']
    
    @list = InstrumentoFinanciero.search("", params[:page], params[:sort])
    @total=@list.count

    form_list

  end
	
  def new
    @instrumento_financiero = InstrumentoFinanciero.new
		form_new @instrumento_financiero
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def save_new
    @instrumento_financiero = InstrumentoFinanciero.new(params[:instrumento_financiero])
    form_save_new @instrumento_financiero
  end
  
  def delete
    @instrumento_financiero = InstrumentoFinanciero.find(params[:id])
    form_delete @instrumento_financiero
  end
  
  def edit
    @instrumento_financiero = InstrumentoFinanciero.find(params[:id])
     form_edit @instrumento_financiero
  end
  def save_edit
    @instrumento_financiero = InstrumentoFinanciero.find(params[:id])
    form_save_edit @instrumento_financiero
  end
  def cancel_edit
    @instrumento_financiero = InstrumentoFinanciero.find(params[:id])
    form_cancel_edit @instrumento_financiero
  end
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.InstrumentoFinanciero.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.InstrumentoFinanciero.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.InstrumentoFinanciero.FormTitles.form_title_records')
    @form_entity = 'instrumento_financiero'
    @form_identity_field = 'descripcion'
  end
  
end
