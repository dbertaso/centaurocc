# encoding: UTF-8

#
# autor: Luis Rojas
# clase: Solicitudes::SolicitudEvaluacionAsignacionController
# descripción: Migración a Rails 3
#
class Solicitudes::SolicitudEvaluacionAsignacionController < FormTabsController
  
  skip_before_filter :set_charset, :only=>[:municipio_change, :save_reasignar, :save_asignar, :save_re_asignar_maxivo]

 layout 'form_basic'

  def index
    oficina = Oficina.find(session[:oficina])
    @municipio_list = Municipio.find(:all, :conditions=>['estado_id = ?', oficina.municipio.estado_id], :order => 'nombre')
    @usuario_list = Usuario.find(:all, :conditions=>['activo = true and cedula in (select cedula from tecnico_campo where activo = true) and oficina_id = ?', oficina.id], :order=>'primer_nombre, primer_apellido')
  end

  def list
    @condition ="const_id in ('ST0002', 'ST0003') and oficina_id = #{session[:oficina]}"
    params['sort'] = "numero" unless params['sort']

    unless params[:usuario_id][0].blank?
      usuario_id = params[:usuario_id][0].to_s
      usuario = Usuario.find(usuario_id)
      @condition << " and usuario_pre_evaluacion = '#{usuario.nombre_usuario}'"
      @form_search_expression << "Usuario es igual '#{usuario.primer_nombre << " " << usuario.primer_apellido}'"
    end
    
    unless params[:municipio_id][0].blank?
      municipio_id =params[:municipio_id][0].to_s
      municipio = Municipio.find(municipio_id)
      @condition << " and municipio_id = " + municipio_id
      @form_search_expression << "Municipio es igual '#{municipio.nombre}'"
    end

    unless params[:parroquia_id][0].blank?
      parroquia = Parroquia.find(params[:parroquia_id][0].to_s)
      @condition << " and parroquia_id = " + params[:parroquia_id][0].to_s
      @form_search_expression << "Parroquia es igual '#{parroquia.nombre}'"
    end

    unless params[:numero].nil? || params[:numero].empty?
      @condition << " AND numero =  #{params[:numero].to_i}"
      @form_search_expression << "Número igual '#{params[:numero]}'"
    end

    unless params[:unidad_produccion].nil? ||  params[:unidad_produccion].empty?
      @condition << " AND lower(unidad_produccion) LIKE lower('%#{params[:unidad_produccion].strip}%') "
      @form_search_expression << "Unidad de Producción contenga '#{params[:unidad_produccion]}'"
    end
    
    unless params[:identificacion].nil? ||  params[:identificacion].empty?
      @condition << " AND lower(cedula_rif) LIKE lower('%#{params[:tipo]+params[:identificacion].strip}%') "
      @form_search_expression << "Rif o Cédula contenga '#{params[:tipo]+params[:identificacion]}'"
    end
    
    unless params[:nombre].nil? || params[:nombre].empty?
      @condition << " AND UPPER(nombre) LIKE UPPER('%#{params[:nombre].strip}%')"
      @form_search_expression << "Nombre o Apellido contenga '#{params[:nombre]}'"
    end
    unless params[:viable].nil? || params[:viable].empty?
      @condition << " and decision_final = #{params[:viable]}"
      @form_search_expression << "Viable igual 'No Viable'"
    end

    
    @list = ViewSolicitudPreEvaluacion.search(@condition, params[:page], params['sort'])
    @total=@list.count

    form_list
  end

  def municipio_change
    @parroquia_list = Parroquia.find_all_by_municipio_id(params[:municipio_id], :order=>'nombre')
    render :update do |page|
      page.replace_html 'parroquia-select', :partial => 'parroquia_select'
    end
  end
	
  def asignar
    @solicitud = Solicitud.find(params[:id])
    @usuario_select = Usuario.find(:all, :conditions=>['activo = true and cedula in (select cedula from tecnico_campo where activo = true) and oficina_id = ?', session[:oficina]], :order=>'primer_nombre, primer_apellido')
    @control_asignacion = ControlAsignacion.new
  end

  def save_asignar
    @solicitud = Solicitud.find(params[:id])
    if @solicitud.estatus_id == 10002
      form_save_new @solicitud, :value=>@solicitud.update_asignar(params[:control_asignacion])
      unless @solicitud.errors.count > 0
        estatus_id_inicial = @solicitud.estatus_id
        fecha_evento = Time.now
        configuracion_avance = ConfiguracionAvance.find_by_estatus_origen_id(@solicitud.estatus_id)
        @solicitud.estatus_id = configuracion_avance.estatus_destino_id
        @solicitud.fecha_actual_estatus = fecha_evento.strftime("%Y/%m/%d")
        @solicitud.save
        # Crea un nuevo registro en la tabla control_solicitud
        ControlSolicitud.create_new(@solicitud.id, configuracion_avance.estatus_destino_id, @usuario.id, 'Avanzar', estatus_id_inicial, '')
      end
    else
      render :update do |page|
         page.alert "El tramite número #{@solicitud.numero} ya fue asignado"
      end
      return
    end
  end

  def asignar_maxiva
    estatus = Estatus.find(:first, :conditions=>"const_id = 'ST0002'")
    @solicitud = Solicitud.find(:all, :conditions=>["estatus_id = ? and oficina_id = #{session[:oficina]}", estatus.id])
    @usuario_select = Usuario.find(:all, :conditions=>['activo = true and cedula in (select cedula from tecnico_campo where activo = true) and oficina_id = ?', session[:oficina].id], :order=>'primer_nombre, primer_apellido')
    @control_asignacion = ControlAsignacion.new
  end

  def re_asignar_maxiva
    estatus = Estatus.find(:first, :conditions=>"const_id = 'ST0003'")
    @solicitud = Solicitud.find(:all, :conditions=>["estatus_id = ? and oficina_id = #{session[:oficina]}", estatus.id])
    @usuario_select = Usuario.find(:all, :conditions=>['activo = true and cedula in (select cedula from tecnico_campo where activo = true) and oficina_id = ?', session[:oficina]], :order=>'primer_nombre, primer_apellido')
    @control_asignacion = ControlAsignacion.new
  end

  def save_asignar_maxivo
    solicitud_id = params[:solicitudes]
    msj = ""
#    return
    unless solicitud_id.length > 0
       msj << I18n.t('Sistema.Body.Modelos.Errores.debe_seleccionar_tramite')
    end
    if params[:control_asignacion][:usuario_id].nil? || params[:control_asignacion][:usuario_id].empty?
      if msj.length > 0
        msj << ', '
      end
       msj << " #{I18n.t('Sistema.Body.Vistas.General.tecnico')} #{I18n.t('Sistema.Body.Vistas.General.a')} #{I18n.t('Sistema.Body.Vistas.General.asignar')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"
    end
    if params[:control_asignacion][:observacion].nil? || params[:control_asignacion][:observacion].empty?
      if msj.length > 0
        msj << ', '
      end
      msj << " #{I18n.t('Sistema.Body.Vistas.General.observaciones')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"
    end
    if msj.length > 0
      render :update do |page|
         page.alert msj
      end
      return
    end
    solicitud_id = solicitud_id.split(',')
    solicitud_id.each { |s|
    unless s==''
      @solicitud = Solicitud.find(s)
      if @solicitud.estatus_id == 10002
        @solicitud.update_asignar(params[:control_asignacion])
        unless @solicitud.errors.length > 0
          estatus_id_inicial = @solicitud.estatus_id
          fecha_evento = Time.now
          configuracion_avance = ConfiguracionAvance.find_by_estatus_origen_id(@solicitud.estatus_id)
          @solicitud.estatus_id = configuracion_avance.estatus_destino_id
          @solicitud.fecha_actual_estatus = fecha_evento.strftime("%Y/%m/%d")
          @solicitud.save
          # Crea un nuevo registro en la tabla control_solicitud
          ControlSolicitud.create_new(@solicitud.id, configuracion_avance.estatus_destino_id, @usuario.id, 'Avanzar', estatus_id_inicial, '')
        else
          render :update do |page|
             page.alert "#{I18n.t('Sistema.Body.Vistas.General.tecnico')} #{I18n.t('Sistema.Body.Vistas.General.a')} #{I18n.t('Sistema.Body.Vistas.General.asignar')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"
          end
          return
        end
      end
    end
    }
    render :update do |page|
      page.alert I18n.t('Sistema.Body.Vistas.General.los_tramites_se_han_asignado_correctamente')
      page.redirect_to :action=>'asignar_maxiva', :popup=>params[:popup]
    end
   
  end

  def save_re_asignar_maxivo
    solicitud_id = params[:solicitudes]
    msj = ""
#    return
    unless solicitud_id.length > 0
       msj << I18n.t('Sistema.Body.Modelos.Errores.debe_seleccionar_tramite')
    end
    if params[:control_asignacion][:usuario_id].nil? || params[:control_asignacion][:usuario_id].empty?
      if msj.length > 0
        msj << ', '
      end
       msj << " #{I18n.t('Sistema.Body.Vistas.General.tecnico')} #{I18n.t('Sistema.Body.Vistas.General.a')} #{I18n.t('Sistema.Body.Vistas.General.asignar')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"
    end
    if params[:control_asignacion][:observacion].nil? || params[:control_asignacion][:observacion].empty?
      if msj.length > 0
        msj << ', '
      end
      msj << " #{I18n.t('Sistema.Body.Vistas.General.observaciones')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"
    end
    if msj.length > 0
      render :update do |page|
         page.alert msj
      end
      return
    end
    solicitud_id = solicitud_id.split(',')
    solicitud_id.each { |s|
     unless s==''     
      @solicitud = Solicitud.find(s)
      usuario = Usuario.find(params[:control_asignacion][:usuario_id])
      unless (@solicitud.usuario_pre_evaluacion == usuario.nombre_usuario)
        @solicitud.update_asignar(params[:control_asignacion])
      end
     end
    }
    render :update do |page|
      page.alert I18n.t('Sistema.Body.Vistas.General.los_tramites_se_han_asignado_correctamente')
      page.redirect_to :action=>'re_asignar_maxiva', :popup=>params[:popup]
    end
  end

  def save_reasignar
    @solicitud = Solicitud.find(params[:id])
    form_save_new @solicitud, :value=>@solicitud.update_asignar(params[:control_asignacion])
  end

  def edit
    @solicitud = Solicitud.find(params[:id])
    @control_asignacion = ControlAsignacion.find(:first, :conditions=>['solicitud_id = ?', @solicitud.id], :order=>'id desc')
  end

  def reasignar
    @solicitud = Solicitud.find(params[:id])
    @control_asignacion = ControlAsignacion.new
    @usuario = Usuario.find(:first, :conditions=>['nombre_usuario = ?',@solicitud.usuario_pre_evaluacion])
    @usuario_select = Usuario.find(:all, :conditions=>['activo = true and cedula in (select cedula from tecnico_campo where activo = true) and nombre_usuario <> ? and oficina_id = ?', @solicitud.usuario_pre_evaluacion, session[:oficina]], :order=>'primer_nombre, primer_apellido')
    @control = ControlAsignacion.find(:all,:conditions=>['solicitud_id = ?',@solicitud.id],:order=>'id desc')
  end

  def rechazar
    @solicitud = Solicitud.find(params[:id])
    #estatus = Estatus.find(:first, :conditions=>["const_id = 'ST0024'"])
    estatus_id_inicial = @solicitud.estatus_id
    @solicitud.estatus_id = 10024
    fecha_evento = Time.now
    @solicitud.fecha_actual_estatus = fecha_evento.strftime("%Y/%mm/%d")
    @solicitud.save
    # Crea un nuevo registro en la tabla control_solicitud
    ControlSolicitud.create_new(@solicitud.id, 10024, @usuario.id, 'Rechazar', estatus_id_inicial, '')
    render :update do |page|
      page.remove "row_#{@solicitud.id}"
      page.hide 'error'
      page.replace_html 'message', "El Trámite Número #{@solicitud.numero} fue rechazado con Exito."
      page.show 'message'
    end
    return false
  end

  # avanzar la solicitud a la siguiente instancia
  def avanzar
    solicitud = Solicitud.find(params[:id])
    solicitud.avanzar_evaluacion(@usuario.id)
    if solicitud.errors.length > 0
      message = '<h2>Ha ocurrido un error</h2><p><UL>'
      solicitud.errors.each { |e|
        message << "<LI>#{e[1]}</LI>"
      }
      message << '</UL><p>'
      render :update do |page|
        page.replace_html 'errorExplanation',message
        page.show 'errorExplanation'
      end
    else
      render :update do |page|
        page.remove "row_#{solicitud.id}"
        page.hide 'errorExplanation'
        page.replace_html 'message', "La Solicitud Número #{solicitud.numero} fue avanzada con éxito."
        page.show 'message'
      end
    end
  end
  
  protected
  def common
    super
    
    @form_title = "#{I18n.t('Sistema.Body.Vistas.General.asignacion')}/#{I18n.t('Sistema.Body.Vistas.General.re_asignacion')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.solicitud')} #{I18n.t('Sistema.Body.Vistas.General.al')} #{I18n.t('Sistema.Body.Controladores.TecnicoCampo.FormTitles.form_title_record')}"
    @form_title_record = 'Trámites'
    @form_title_records = 'Trámites'
    @form_entity = 'solicitud'
    @form_identity_field = 'numero'
    @width_layout = '1000'
  end 
  
end
