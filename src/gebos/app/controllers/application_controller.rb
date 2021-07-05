# encoding: utf-8
class ApplicationController < ActionController::Base

  require 'prawn'
  
  protect_from_forgery

skip_before_filter :set_charset, :only=>[:form_error, :errors_for, :error, :calendar, :solicitar_autorizacion]

  before_filter :session_expiry, :except => [:login, :logout, 'sistema/olvido_clave/index', 'sistema/olvido_clave/save_edit']
  before_filter :update_activity_time, :except => [:login, :logout, 'sistema/olvido_clave/index', 'sistema/olvido_clave/save_edit']
  before_filter :validate_session, :except => [:login, :logout, 'sistema/olvido_clave/index', 'sistema/olvido_clave/save_edit']
  before_filter :set_charset
  before_filter :gebos_auditoria

  def session_expiry

    @time_left = session[:expires_at].nil? ? 0 : (session[:expires_at] - Time.now).to_i
    unless @time_left > 0
      reset_session
      flash[:notice] = I18n.t('Sistema.Body.General.Excepciones.termino_tiempo_sesion')
      redirect_to root
    end
  end

  def set_charset
    headers["Content-Type"] = "text/html; charset=utf-8"
  end


  # Esta se llama al momento que se solicita una autorización,
  # por ejemplo Un Reverso
  def solicitar_autorizacion


    opcion_accion = OpcionAccion.find(params[:opcion_accion_id])

    if !(Autorizacion.find(:first, :conditions=>["opcion_accion_id = ? and referencia_id = ? and usuario_id = ? and vencimiento > ? and estatus<>'R'",
      params[:opcion_accion_id], params[:referencia_id], @usuario.id, Time.now]))

      autorizacion= Autorizacion.new(:opcion_accion_id=>opcion_accion.id, :referencia_id=>params[:referencia_id], :descripcion=>params[:descripcion], :usuario_id=>@usuario.id)
      autorizacion.save
    end

    render :update do |page|
      page.replace_html opcion_accion.accion.nombre_sistema + '_' + params[:referencia_id],
        "Solicitud para #{opcion_accion.accion.nombre} en espera por aprobación"
      page.show opcion_accion.accion.nombre_sistema + '_' + params[:referencia_id]
    end

  end

  def update_activity_time
    session[:expires_at] = 15.minutes.from_now
  end

  def gebos_auditoria
    if session[:id]
       GebosAuditoria.create(
       :usuario_id     =>session[:id],
       :usuario_nombre =>Usuario.find(session[:id]).nombre_usuario,
       :usuario_ip     =>request.remote_ip ,
       :controlador    =>request.path_parameters['controller'],
       :accion         =>request.path_parameters['action'] ,
       :url            =>request.path.to_s,
       :cantidad_parametros         =>request.query_parameters.size,
       :parametros    =>request.query_parameters.inspect
       )
    else
       GebosAuditoria.create(
       :usuario_id     =>0,
       :usuario_nombre =>"Desconocido",
       :usuario_ip     =>request.remote_ip ,
       :controlador    =>request.path_parameters['controller'],
       :accion         =>request.path_parameters['action'] ,
       :url            =>request.path.to_s,
       :cantidad_parametros         =>request.query_parameters.size,
       :parametros    =>request.query_parameters.inspect
       )
    end
  end
  # Esta valida la sesión del usuario sea válida
  def validate_session
    validate = false
    if session[:id]
      @idiomas=Idioma.find(:all,:conditions=>"activo=true",:order=>"nombre")
      @usuario = Usuario.find(session[:id])
      I18n.locale = @usuario.lenguaje
      @bandera_actual=Idioma.find_by_nemonico(I18n.locale).bandera
      if @usuario.lenguaje=="es" || @usuario.lenguaje=="fr" || @usuario.lenguaje=="ar" || @usuario.lenguaje=="cs" || @usuario.lenguaje=="da" || @usuario.lenguaje=="de" || @usuario.lenguaje=="fi" || @usuario.lenguaje=="hu" || @usuario.lenguaje=="it" || @usuario.lenguaje=="ru" ||  @usuario.lenguaje=="nl" || @usuario.lenguaje=="pl" || @usuario.lenguaje=="pt" || @usuario.lenguaje=="sl" || @usuario.lenguaje=="sv"
        CalendarDateSelect.format = :finnish       
      elsif @usuario.lenguaje=="ja"        
        CalendarDateSelect.format = :iso_date      
      else
        CalendarDateSelect.format = :american      
      end
      if @usuario.super_usuario
        validate = true
        session[:oficina] = Oficina.find(@usuario.oficina_id).id
        @valid_menu = Menu.find(:all, :conditions=>['parent_id isnull'], :order=>'orden')

      else
        validate = @usuario.activo if validate
        #validate = validate_ip if validate
        validate = validate_oficina if validate
        validate, opcion = validate_opciones if validate
        validate = validate_accion(opcion) if validate
      end
    end
    if !validate
      destroy_session
      redirect_to login_path
    end
    validate

    #logger.info "Validate =====> " << validate.to_s
  end

  private
  # Esta valida que el usuario pueda trabajar con una oficina particular

  def validate_oficina
    session[:oficina] = Oficina.find(@usuario.oficina_id)
    return true
  end

  # Esta valida que el usuario tenga permiso para trabajar desde una computadora en particular
  def validate_ip
    session[:ip_address] = request.remote_ip
    for rol in @usuario.roles
      if rol.estaciones.length==0
        return true
      end
    end
    for rol in @usuario.roles
      for estacion in rol.estaciones
        if estacion.ip_address==session[:ip_address]
          return true unless !estaction.activo
          return false
        end
      end
    end
    false
  end

  def eliminar_acentos(nombre)

    nombre = nombre.to_s
    #logger.debug "Nombre en eliminar acentos ======> " << nombre.class.to_s
    nombre.downcase!
    nombre.gsub!(/[á|Á]/,'a')
    nombre.gsub!(/[é|É]/,'e')
    nombre.gsub!(/[í|Í]/,'i')
    nombre.gsub!(/[ó|Ó]/,'o')
    nombre.gsub!(/[ú|Ú]/,'u')
    return nombre


  end

  # Esta valida las opciones a las que el usuario tiene acceso
  def validate_opciones
    opciones = []
    for rol in @usuario.roles
      opciones = opciones | rol.opciones
    end
    ruta = self.class.controller_path
    opcion = nil
    if ruta == 'prestamos/consulta_prestamo' && (self.action_name == 'view' || self.action_name == 'tasa_historico_list_view' || self.action_name == 'tasa_historico_list')
      ruta = ruta + "/#{self.action_name}"
    end
    if session[:menu_string].nil?
      if ruta == 'basico/ayuda' || ruta=='inicio' || opciones.find {|opcion| opcion.ruta == ruta }
        @valid_menu, valid = fill_menu(Menu.find(:all, :conditions=>['parent_id isnull'], :order=>'orden'), opciones)
        logger.debug "Valid Menu ========> #{@valid_menu.inspect}"
        logger.debug "Opcion ========> #{opcion.inspect}"
        return [true, opcion]
        logger.debug "(no quitar este logger debug) deja de funcionar el validate_opciones en basico/instancia_comite_nacional" 
      else
        return [false, nil]
        logger.debug "(no quitar este logger debug) deja de funcionar el validate_opciones en basico/instancia_comite_nacional" 
      end
    else
      logger.debug "Paso por el else"
      @valid_menu = session[:menu_string]
      if ruta == 'basico/ayuda' || ruta=='inicio' || opciones.find {|opcion| opcion.ruta == ruta }
        return [true, opcion]
        logger.debug "(no quitar este logger debug) deja de funcionar el validate_opciones en basico/instancia_comite_nacional" 
      end      
    end
  end

  #Esta valida que un usuario tenga acceso a una opción en particular
  def validate_accion(opcion)
    ruta = controller_name
    accion = protect
    if ruta!='inicio' && !accion.nil?
      acciones = []
      for rol in @usuario.roles
        acciones = acciones | rol.acciones
      end
      opcion = nil
      accion = Accion.find_by_nombre_sistema(accion)
      acciones.find {|rol_opcion_accion| rol_opcion_accion.accion_id == accion.id }
    else
      true
    end
  end




  #Esta función llena un arreglo con los menus a los cuales un usuario puede acceder
  def fill_menu(menus, opciones)
    valid_menus = []
    menus.each do |menu|
      valid_menu = nil
      if (menu.tiene_opcion)
        if opciones.find {|opcion| opcion.id == menu.opcion.id }
          valid_menu = menu.dup
          valid_menu.children.clear if valid_menu.children
        end
      end
      if menu.children
        children, valid = fill_menu(menu.children, opciones)
        if valid
          if !valid_menu
            valid_menu = menu.dup
            valid_menu.children.clear if valid_menu.children
          end
          valid_menu.children = children
        end
      end
      valid_menus<<valid_menu if valid_menu
      logger.info "valid menus #{valid_menus.inspect}" 
    end
    [valid_menus, valid_menus.length>0]

  end

  def validate_opcion
    opciones = []
    for rol in @usuario.roles
      opciones = opciones | rol.opciones
    end
  end

  # Destruye la sessión del usuario
  def destroy_session
    session[:id] = nil
    session[:ip_address] = nil
  end

  protected
  #Esta función es llamada desde validate_accion para determinar como se llama
  #la accion en la base de datos que se va a validar
  def protect
    case action_name
    when 'new','save_new','cancel_new', 'edit', 'save_edit','cancel_edit'
      'edit'
    when 'delete'
      'delete'
    end
  end




end
