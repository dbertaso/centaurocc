# encoding: utf-8
class Basico::MotivoVisitaController < FormAjaxController

  def index
    list
  end

  def list
    params['sort'] = "nombre" unless params['sort']
    conditions = 'id > 0'
    
    @list = MotivoVisita.search(conditions, params[:page], params[:sort])
    @total=@list.count
    form_list
  end

  def new
    @motivo_visita = MotivoVisita.new
    form_new @motivo_visita
  end

  def save_new
    @motivo_visita = MotivoVisita.new(params[:motivo_visita])
    form_save_new @motivo_visita
  end
  
  def cancel_new
		form_cancel_new
  end
  
#  def delete
#    @motivo_visita = MotivoVisita.find(params[:id])
#    form_delete @motivo_visita
#  end

  def delete
    @motivo_visita = MotivoVisita.find(params[:id])
       # @rubro = Rubro.find(params[:id])
    result = @motivo_visita.eliminar(params[:id])
    if result == false
      render :update do |page|
        page.form_error
      end
      return
    else
      render :update do |page|
        page.form_delete @motivo_visita, 'motivo_visita'
      end
    end
  end
  
  def edit
    @motivo_visita = MotivoVisita.find(params[:id])
    form_edit @motivo_visita
  end

  def save_edit
    @motivo_visita = MotivoVisita.find(params[:id])
    form_save_edit @motivo_visita
  end

  def cancel_edit
    @motivo_visita = MotivoVisita.find(params[:id])
    form_cancel_edit @motivo_visita
  end

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.MotivoVisita.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.MotivoVisita.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.MotivoVisita.FormTitles.form_title_records')
    @form_entity = 'motivo_visita'
    @form_identity_field = 'nombre'
  end
  
end
