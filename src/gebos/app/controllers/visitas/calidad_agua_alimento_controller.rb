# encoding: utf-8
class Visitas::CalidadAguaAlimentoController < FormAjaxTabsController

  def index
    @visitas = SeguimientoVisita.find(params[:id])
    list
  end

  def list
    @visitas = SeguimientoVisita.find(params[:id])
    @calidad_agua = CalidadAguaAlimento.find(:all, :conditions => ['solicitud_id = ?', @visitas.solicitud_id])
    params['sort'] = "alimento_disponible" unless params['sort']
    
    conditions = "solicitud_id = #{@visitas.solicitud_id}"
    @list = CalidadAguaAlimento.search(conditions, params[:page], params[:sort])
    @total=@list.count
    form_list
  end

  def new
    @calidad_agua_alimento = CalidadAguaAlimento.new
    @visitas = SeguimientoVisita.find(params[:id])
    @calidad_agua_alimento.solicitud_id=@visitas.solicitud_id
    form_new @calidad_agua_alimento
  end

  def cancel_new
    form_cancel_new
  end

  def save_new
    @visitas = SeguimientoVisita.find(params[:id])
    @calidad_agua_alimento = CalidadAguaAlimento.new(params[:calidad_agua_alimento])
    @calidad_agua_alimento.seguimiento_visita_id = @visitas.id
    @calidad_agua_alimento.solicitud_id =@visitas.solicitud_id
    form_save_new @calidad_agua_alimento
  end

  def delete
    @calidad_agua_alimento = CalidadAguaAlimento.find(params[:id_calidad_agua_alimento])
    form_ajaxdelete @calidad_agua_alimento
  end

  def edit
    @calidad_agua_alimento = CalidadAguaAlimento.find(params[:id_calidad_agua_alimento])
    form_edit @calidad_agua_alimento
  end

  def save_edit
    @calidad_agua_alimento = CalidadAguaAlimento.find(params[:id_calidad_agua_alimento])
    @visitas = SeguimientoVisita.find(params[:id])
    if @calidad_agua_alimento.save!
      form_save_edit @calidad_agua_alimento
    else
      render :update do |page|
        page.form_error
      end
      return false
    end
  end

  
  def cancel_edit
    logger.info"XXX============>>>>>"<<params.inspect
    @calidad_agua_alimento = CalidadAguaAlimento.find(params[:id_calidad_agua_alimento])
    @visitas = SeguimientoVisita.find(params[:id])
    form_cancel_edit @calidad_agua_alimento
  end

  protected
  def common
    super
    @visitas = SeguimientoVisita.find(params[:id])
    @form_title = I18n.t('Sistema.Body.Controladores.VisitaDescripcionesEspesificas.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.CalidadAguaAlimento.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.CalidadAguaAlimento.FormTitles.form_title_records')
    @form_entity = 'calidad_agua_alimento'
    @form_identity_field = 'alimento_disponible'
    @width_layout = '1080'
    @full_info = "#{@visitas.codigo_visita} #{I18n.t('Sistema.Body.Vistas.General.del')} #{I18n.t('Sistema.Body.General.solicitud')} #{@visitas.solicitud.numero} (#{@visitas.solicitud.nombre})"
  end

   

end
