# encoding: utf-8
class Visitas::VisitaSeguimientoCultivoController < FormTabTabsController

    skip_before_filter :set_charset, :only=>[ :tabs, :superficie_efectiva_onchange, :change_fecha_siembra]

  
  def index
  end
  
  def edit
    # @solicitud = Solicitud.find(params[:solicitud_id])
    @visitas = SeguimientoVisita.find(params[:id])
    @seguimiento_cultivo = SeguimientoCultivo.find_by_seguimiento_visita_id(params[:id])
    if @seguimiento_cultivo.nil?
      @seguimiento_cultivo = SeguimientoCultivo.new
      @edad_cultivo = nil
    else
      @edad_cultivo = @seguimiento_cultivo.edad_cultivo
    end
    @total_superficie_efectiva = @seguimiento_cultivo.superficie_efectiva_f

    @total_hectareas_recomendadas = SeguimientoCultivo.find_by_sql("SELECT case when sum(superficie_recomendada) isnull then 0 else sum(superficie_recomendada) end AS superficie_recomendada FROM seguimiento_cultivo as sc inner join seguimiento_visita as sv on sv.id = sc.seguimiento_visita_id and sv.solicitud_id=#{@visitas.solicitud.id} WHERE (sc.seguimiento_visita_id < #{@visitas.id})")
    @total_hectareas_recomendadas = @total_hectareas_recomendadas[0].superficie_recomendada
    
  end
  
  def save_edit
    @seguimiento_cultivo = SeguimientoCultivo.find_by_seguimiento_visita_id(params[:id])
    logger.debug @seguimiento_cultivo.inspect
    logger.debug "*************************"
    if @seguimiento_cultivo.nil?
        @seguimiento_cultivo = SeguimientoCultivo.new(:seguimiento_visita_id=>params[:id])
        fecha_estimada = params[:seguimiento_cultivo][:fecha_estimada_cosecha_f]
        logger.debug params.inspect
        logger.debug @seguimiento_cultivo.inspect
        logger.debug "*************************"
    else
      visita = SeguimientoCultivo.find_by_sql("SELECT fecha_estimada_cosecha FROM seguimiento_cultivo where (seguimiento_visita_id = (select id from seguimiento_visita where solicitud_id=#{@seguimiento_cultivo.seguimiento_visita.solicitud_id} and motivo_visita_id > 1 and activo = 't' order by id limit 1))")

      fecha_estimada = visita[0].fecha_estimada_cosecha
    end   
    seguimiento_cultivo = params[:seguimiento_cultivo]
    @seguimiento_cultivo.superficie_efectiva_f = params[:superficie_efectiva]
    
    # cálculo de las hectareas recomendadas en las visitas, luego enviamos el valor de esta variable como parametro en la validación
    total_hectareas_recomendadas = SeguimientoCultivo.find_by_sql("SELECT case when sum(superficie_recomendada) isnull then 0 else sum(superficie_recomendada) end AS superficie_recomendada FROM seguimiento_cultivo as sc inner join seguimiento_visita as sv on sv.id = sc.seguimiento_visita_id and sv.solicitud_id=#{@seguimiento_cultivo.seguimiento_visita.solicitud_id} WHERE (sc.seguimiento_visita_id < #{@seguimiento_cultivo.seguimiento_visita.id})")
    total_hectareas_recomendadas = total_hectareas_recomendadas[0].superficie_recomendada
    logger.info"XXXXXXXXtotal-controllers-=======>>>>"<<total_hectareas_recomendadas.inspect
    success = true
    success &&= @seguimiento_cultivo.validar_superficie(seguimiento_cultivo, fecha_estimada, total_hectareas_recomendadas,params)
    if success
        logger.debug "IF SUCCESS =======> "<< params[:seguimiento_cultivo].inspect

      @seguimiento_cultivo.update_attributes(params[:seguimiento_cultivo])
      if @seguimiento_cultivo.save
        render :update do |page|
          page.hide 'error'
          page.replace_html 'messages', I18n.t('Sistema.Body.Controladores.VisitaSeguimientoCultivo.Menssages.se_actualizo_con_exito')
          page.show 'messages'
          page.redirect_to :action=>'edit', :id=>@seguimiento_cultivo.seguimiento_visita_id, :popup=>params[:popup]
        end
      else
        render :update do |page|
          page.hide 'messages'
          page.form_error
        end
        return false
      end
    else
      render :update do |page|
        page.form_error
      end
      return false
    end
  end

  def cancel_edit
    @visitas = SeguimientoVisita.find(params[:id])
    form_cancel_edit @visitas
  end

  def superficie_efectiva_onchange
    logger.info"XXXXXXXXXX=========================>>>"<<params.inspect
    superficie_sembrada = (params[:superficie_sembrada])
    @total_superficie_efectiva = superficie_sembrada
    logger.debug "==============>>> " << @total_superficie_efectiva.to_s
    unless @total_superficie_efectiva.empty?
      @total_superficie_efectiva = @total_superficie_efectiva.sub('.', ',')
    else
      @total_superficie_efectiva = "0,000"
    end
    logger.debug "==============>>> " << @total_superficie_efectiva.to_s
    render :update do |page|
      page.replace_html 'superficie_efectiva-text', :partial => 'superficie_efectiva_text'
    end

  end

  def change_fecha_siembra
    visitas = SeguimientoVisita.find(params[:id])
    fecha_siembra = params[:fecha_siembra_f]
    fecha_siembra = (fecha_siembra.to_s).split("/")
    fecha_siembra = (fecha_siembra[2]+"/"+fecha_siembra[1]+"/"+fecha_siembra[0])
    fecha_siembra = fecha_siembra.to_date
    fecha_registro = visitas.fecha_registro.strftime("%Y/%m/%d")
    fecha_registro = fecha_registro.to_date

    if (fecha_registro < fecha_siembra)
      logger.info"XXXXXXXXXX=============&&&&&&&&&&&&&&&&&&==========>>>>"
        msg_error = I18n.t('Sistema.Body.Controladores.VisitaSeguimientoCultivo.Errores.fecha_no_puede_ser_posterior')
        render :update do |page|
          page.alert msg_error
        end
        return false
    else
      logger.info"XXXXXXXXXX=============&&&&&&&&&&&&&&&&&&==========>>>>"
        edad = (fecha_registro - fecha_siembra).to_s.split("/")
        logger.info"XXXXXXXXXX=============&&&&&&&&&&&&&&&&&&==========>>>>"<<edad.inspect
      @edad_cultivo = edad[0]
        logger.debug "EDAD CULTIVO " << @edad_cultivo.to_s
        render :update do |page|
            page.replace_html 'edad_cultivo-div', :partial => 'edad_cultivo'
            page.aler('listo');
        end
    end
  end

  protected  
  def common
    super
    @visitas = SeguimientoVisita.find(params[:id])
    @form_title = I18n.t('Sistema.Body.Controladores.VisitaSeguimientoCultivo.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.VisitaSeguimientoCultivo.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.VisitaSeguimientoCultivo.FormTitles.form_title_records')
    @form_entity = 'codigo_visita'
    @form_identity_field = 'tipo_nombre'
    @width_layout = '955'
    @full_info = "#{@visitas.codigo_visita} #{I18n.t('Sistema.Body.Vistas.General.del')} #{I18n.t('Sistema.Body.General.solicitud')} #{@visitas.solicitud.numero} (#{@visitas.solicitud.nombre})"
  end

  private


end
