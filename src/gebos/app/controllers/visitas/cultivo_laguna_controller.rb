# encoding: utf-8
class Visitas::CultivoLagunaController < FormAjaxTabsController

  def index
    @visitas = SeguimientoVisita.find(params[:id])
    list
  end

  def list
    @visitas = SeguimientoVisita.find(params[:id])
    @cultivo_laguna = CultivoLaguna.find(:all, :conditions => ['solicitud_id = ?', @visitas.solicitud_id])
    params['sort'] = "numero_laguna" unless params['sort']
    
    conditions = "solicitud_id = #{@visitas.solicitud_id}"
    @list = CultivoLaguna.search(conditions, params[:page], params[:sort])
    @total=@list.count
    form_list
  end

  def new
    @cultivo_laguna = CultivoLaguna.new
    @visitas = SeguimientoVisita.find(params[:id])    
    @cultivo_laguna.solicitud_id=@visitas.solicitud_id    
    form_new @cultivo_laguna
  end

  def cancel_new
    form_cancel_new
  end

  def save_new
    @visitas = SeguimientoVisita.find(params[:id])
    @cultivo_laguna = CultivoLaguna.new(params[:cultivo_laguna])
    @cultivo_laguna.seguimiento_visita_id = @visitas.id
    @cultivo_laguna.solicitud_id =@visitas.solicitud_id
    form_save_new @cultivo_laguna
  end

  def delete
    @cultivo_laguna = CultivoLaguna.find(params[:id_cultivo_laguna])
    form_ajaxdelete @cultivo_laguna
  end

  def edit
    @cultivo_laguna = CultivoLaguna.find(params[:id_cultivo_laguna])
    form_edit @cultivo_laguna
  end

  def save_edit
    @cultivo_laguna = CultivoLaguna.find(params[:id_cultivo_laguna])
    if @cultivo_laguna.save!
      form_save_edit @cultivo_laguna
    else
      render :update do |page|
        page.form_error
      end
      return false
    end
  end

  
  def cancel_edit
    @cultivo_laguna = CultivoLaguna.find(params[:id_cultivo_laguna])
    form_cancel_edit @cultivo_laguna
  end

  protected
  def common
    super
    @visitas = SeguimientoVisita.find(params[:id])
    @form_title = I18n.t('Sistema.Body.Controladores.VisitaDescripcionesEspesificas.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.CultivoLaguna.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.CultivoLaguna.FormTitles.form_title_records')
    @form_entity = 'cultivo_laguna'
    @form_identity_field = 'numero_laguna'
    @width_layout = '955'
    @full_info = "#{@visitas.codigo_visita} #{I18n.t('Sistema.Body.Vistas.General.del')} #{I18n.t('Sistema.Body.General.solicitud')} #{@visitas.solicitud.numero} (#{@visitas.solicitud.nombre})"
  end

end
