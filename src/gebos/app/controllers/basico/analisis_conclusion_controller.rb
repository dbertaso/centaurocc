# encoding: utf-8
class Basico::AnalisisConclusionController < FormAjaxController

  def index
    list
  end

  def list
    params['sort'] = "nombre" unless params['sort']
    conditions = "id > 0"
    
    @list = AnalisisConclusion.search(conditions, params[:page], params[:sort])
    @total=@list.count
    form_list
  end

  def new
    @analisis_conclusion = AnalisisConclusion.new
    @analisis_conclusion.activo = true
    form_new @analisis_conclusion
  end

  def save_new
    @analisis_conclusion = AnalisisConclusion.new(params[:analisis_conclusion])
    form_save_new @analisis_conclusion
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def delete
    @analisis_conclusion = AnalisisConclusion.find(params[:id])
    form_delete @analisis_conclusion
  end
  
  def edit
    @analisis_conclusion = AnalisisConclusion.find(params[:id])
    form_edit @analisis_conclusion
  end
  
  def save_edit
    @analisis_conclusion = AnalisisConclusion.find(params[:id])
    form_save_edit @analisis_conclusion
  end

  def cancel_edit
    @analisis_conclusion = AnalisisConclusion.find(params[:id])
    form_cancel_edit @analisis_conclusion
  end

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.AnalisisConclusion.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.AnalisisConclusion.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.AnalisisConclusion.FormTitles.form_title_records')
    @form_entity = 'analisis_conclusion'
    @form_identity_field = 'nombre'
  end
  
end
