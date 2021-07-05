# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Cobranzas::GestionCobranzasController
# descripción:Desarrollado Rails 3
#

class Cobranzas::GestionCobranzasController < FormTabsController

  skip_before_filter :set_charset, :only=>[:exigible_change, :fecha_limite, :verifica_compromiso, :email_change, :sms_change, :mostrar_llamada]

  def index

    @prestamo = Prestamo.find(params[:id])
    @analista = AnalistaCobranzas.find_by_usuario_id(session[:id])

    unless @analista.nil?

      unless @prestamo.analista_cobranzas_id.nil?
        if @prestamo.analista_cobranzas_id != @analista.id

            analista_asignada = AnalistaCobranzas.find(@prestamo.analista_cobranzas_id)

            unless analista_asignada.nil?
              nombre_analista = analista_asignada.analista
            else
              nombre_analista = ''
            end
            @error = I18n.t('Sistema.Body.Controladores.GestionCobranzas.Errores.financiamiento_atendido', :analista=>nombre_analista)
            render 'cobranzas/agregar_cobranzas/error'
            return
        end
      end

      unless !@prestamo.analista_cobranzas_id.nil?
        logger.info "Paso por la asignación del analista"
        @prestamo.analista_cobranzas_id  = @analista.id
        @prestamo.save
      end

    end    
    @mensajes_correo_select = MensajesCorreo.find(:all, :conditions=>"activo = true")
    @mensajes_sms_select = MensajesSms.find(:all, :conditions=>"activo = true")
    @tipo_gestion = 0
    @fecha_registro = Time.now.strftime("%Y-%m-%d")
    @hora_registro = Time.now.strftime("%H:%M:%S")
    @gestion = GestionCobranzas.find_by_prestamo_id(params[:id])
    @tipo_cobranza_select = TipoGestionCobranzas.all(:order=>'descripcion', :conditions=>'activo = true')
    @gestion_cobranzas = GestionCobranzas.all(:conditions=>["prestamo_id =?", @prestamo.id], :order=>'fecha_confirmacion desc, hora_confirmacion desc')
    @llamada = LlamadaInfructuosa.all(:order=>'descripcion desc', :conditions=>'activo = true')
    @persona_atendio = PersonaAtendio.all(:order=>'descripcion desc', :conditions=>'activo = true')
    @motivo_atraso = MotivosAtraso.all(:order=>'descripcion desc', :conditions=>'activo = true')

    if @tipo_cobranza_select.nil?
      @tipo_cobranza_select = []
    end

    if @gestion_cobranzas.nil?
      @gestion_cobranzas = []
    end

    if !@prestamo.nil?

      @cliente = Cliente.find(@prestamo.cliente_id)

      if @cliente.class.to_s == 'ClienteEmpresa'

        @telefonos = EmpresaTelefono.find_by_empresa_id(@cliente.empresa_id)
        @correos = EmpresaEmail.find_by_empresa_id(@cliente.empresa_id)
      else
        @telefonos = PersonaTelefono.all(:conditions=>"persona_id = #{@cliente.persona_id.to_s}")
        @correos = PersonaEmail.all(:conditions=>"persona_id = #{@cliente.persona_id.to_s}")

        logger.info "Telefonos Modelo =======>  #{@telefonos.inspect}"
      end

    end

    if !@gestion.nil?


    end
  end

  def verifica_compromiso


    #if params[:id] == '3'

      logger.info "params =====> #{params.inspect}"
      gestion = GestionCobranzas.where("prestamo_id = ? and tipo_gestion_cobranza_id = ?",params[:prestamo_id].to_i,3).order("fecha_registro desc")

      logger.info "gestion =====> #{gestion.inspect}"
      logger.info "gestion_clase ===> #{gestion.class.to_s}"

      if gestion.empty?
        render :nothing => true
        return
      end

      gestion.each do |g|

        logger.info "gestion_id =====> #{g.id.to_s}"
        teleco = Telecobranzas.find_by_gestion_cobranzas_id(g.id)

        unless teleco.nil?
          compromiso = CompromisoPago.find_by_prestamo_id_and_telecobranzas_id_and_estatus(params[:prestamo_id], teleco.id, 'E')

          logger.info "Compromiso clase =======> #{compromiso.class.to_s}"
          unless compromiso.nil?
            logger.info "Entro por compromiso not nil"
            render :update do |page|
              page.alert I18n.t('Sistema.Body.Controladores.GestionCobranzas.Errores.no_puede_agregar_nueva_gestion')
              page.hide 'telecobranzas'
              page.hide 'correo'
              page.hide 'sms'
            end
            return
          end # =====> Fin compromiso.nil?
        end   # =====> Fin unless teleco.nil?
      end
    #end

    render :nothing => true
    return
    
  end

  def exigible_change

    @prestamo = Prestamo.find(params[:prestamo_id])

    logger.info "params #{params.inspect}"
    if params[:valor] == 'true'
      #puts "pasa por aqui parte 1"
      @monto_pago = @prestamo.exigible
    else
    #puts "pasa por aqui parte 2"
      @monto_pago = 0
    end

    render :update do |page|
      page.replace_html "monto", :partial => "monto_compromiso"
    end


  end

  def mensaje_correo_change

    @mensajes_correo = MensajesCorreo.find(params[:id])

    render :update do |page|
      page.replace_html "mensajes_correo", :partial => "mensaje_correo"
    end


  end

  def fecha_limite

    @prestamo = Prestamo.find(params[:prestamo_id])
    parametro = ParametroGeneral.find(1)
    fecha_aux = params[:fecha_limite]

    fecha = fecha_aux.split("/")

    logger.info "Fecha #{fecha.inspect}"

    if parametro.rango_dias_compromiso_pago > 0
      fecha_new = Date.new(fecha[2].to_i, fecha[1].to_i, fecha[0].to_i)
      dias = parametro.rango_dias_compromiso_pago
      fecha_new = fecha_new + dias.days

      logger.info "Fecha #{format_fecha(fecha_new)}"

      @fecha_limite_pago = format_fecha(fecha_new)
    else
      fecha_new = Date.new(fecha[2].to_i, fecha[1].to_i, fecha[0].to_i)
      @fecha_limite_pago = format_fecha(fecha_new)
    end

    logger.info "Fecha ========> #{@fecha_limite_pago.to_s}"
    logger.info "Fecha desglosada #{fecha[2]}, #{fecha[1]}, #{fecha[0]}"
    logger.info "Fecha #{format_fecha(fecha_new)}"
    render :update do |page|
      page.replace_html "fecha_limite", :partial => "fecha_limite"
    end
  end

  def telecobranzas_save

  end

  def email_change

    mensajes_correo = MensajesCorreo.find(params[:id])


    logger.info "PARAMETROS EMAIL =========> #{params.inspect}"
    unless mensajes_correo.nil?

      @texto_mensaje = mensajes_correo.descripcion
    else
      @texto_mensaje = 'Mensaje no encontrado'

    end
    render :update do |page|
      logger.info page.inspect
      #page.call 'actualizar_texto'
      page.replace_html 'mensajes_correo', :partial => 'mensaje_correo', :locals => {:texto_mensaje => @texto_mensaje, :analista_id=>params[:analista_id], :prestamo_id=>params[:prestamo_id]}
      #page.mensaje_correo.value = @texto_mensaje
      page.show 'mensajes_correo'

    end
  end

  def sms_change

    mensajes_sms = MensajesSms.find(params[:id])


    unless mensajes_sms.nil?

      @texto_mensaje = mensajes_sms.descripcion
    else
      @texto_mensaje = 'Mensaje no encontrado'

    end
    render :update do |page|
      page.replace_html 'mensajes_sms', :partial => 'mensaje_sms', :locals => {:texto_mensaje => @texto_mensaje, :analista_id=>params[:analista_id], :prestamo_id=>params[:prestamo_id]}
      page.show 'mensajes_sms'

    end
  end

  def save_new

    logger.info "Tipo Cobranza ======> #{params[:tipo_gestion_cobranza_id].to_s}"
    logger.info "Telefono ======> #{params[:telecobranzas][:telefono_id].to_s}"

    logger.info "PARAMETROS =========> #{params.inspect}"

    result = ''
    usuario = Usuario.find(session[:id])
    prestamo = Prestamo.find(params[:id])

    unless usuario.nil? && prestamo.nil?

      @analista = AnalistaCobranzas.find_by_usuario_id(usuario.id)

      if @analista.nil?
        render :update do |page|
          page.replace_html 'error', "Usuario no esta registrado como analista de cobranzas".html_safe
          page.show 'error'
          page.hide 'mensaje'
          page.<< "window.scrollTo(0,0);"
          page.<< "this.disabled=false;"
          #page.form_error
        end
        return
      end

      if params[:tipo_gestion_cobranza_id] == "1"


        prestamo = Prestamo.find(params[:id])
        cliente = Cliente.find(prestamo.cliente_id)

        if params[:email].nil? or params[:email] == ""

          result = I18n.t('Sistema.Body.Controladores.GestionCobranzas.Errores.seleccione_correo')
          render :update do |page|
            page.replace_html 'error', result.html_safe
            page.show 'error'
            page.hide 'mensaje'
            page.<< "window.scrollTo(0,0);"
            page.<< "this.disabled=false;"
            #page.form_error
          end
          return
        end
      end


      if params[:tipo_gestion_cobranza_id] == "2"


        prestamo = Prestamo.find(params[:id])
        cliente = Cliente.find(prestamo.cliente_id)

        if params[:telefono].nil? or params[:telefono] == ""

          result = I18n.t('Sistema.Body.Controladores.GestionCobranzas.Errores.seleccione_telefono')
          render :update do |page|
            page.replace_html 'error', result.html_safe
            page.show 'error'
            page.hide 'mensaje'
            page.<< "window.scrollTo(0,0);"
            page.<< "this.disabled=false;"
            #page.form_error
          end
          return
        end
      end

      if params[:tipo_gestion_cobranza_id] == "3"

        prestamo = Prestamo.find(params[:id])
        cliente = Cliente.find(prestamo.cliente_id)

        if params[:telecobranzas][:telefono_id] == "" or 
           params[:telecobranzas][:telefono_id].nil?

          result = I18n.t('Sistema.Body.Controladores.GestionCobranzas.Errores.cliente_sin_telefono', :cliente=>cliente.nombre)
          render :update do |page|
            page.replace_html 'error', result.html_safe
            page.show 'error'
            page.hide 'mensaje'
            page.<< "window.scrollTo(0,0);"
            page.<< "this.disabled=false;"
            #page.form_error
          end
          return

        end

      end

      unless @analista.nil?

        result = GestionCobranzas.agregar_gestion(params, @analista, usuario, prestamo)

        logger.info "Result ========> #{result.inspect}"
        html = ""

        if result.class.to_s != 'String'
            logger.info "Entro al If ========> #{result.inspect}"
            texto_mensaje = "#{I18n.t('Sistema.Body.Controladores.GestionCobranzas.FormTitles.form_title')} #{I18n.t('Sistema.Body.Controladores.Mensaje.registro')}"
            @mensaje = "\t\t<ul>\n"
            @mensaje << "\t\t\t<li><b>#{texto_mensaje}</b></li>\n"
            @mensaje << "\t\t<ul>\n"

            if params[:tipo_gestion_cobranza_id] == "1"

              gestion = GestionCobranzas.find(result)
              prestamo = Prestamo.find(gestion.prestamo_id)
              cliente = Cliente.find(prestamo.cliente_id)
              correo = ''
              correo = params[:email]

              EnviarCorreo.enviar_correo(correo, gestion.mensaje, 'Aviso de vencimiento de pago de crédito').deliver
            end            
            message = @mensaje
            @gestion_cobranzas = GestionCobranzas.all(:conditions=>["prestamo_id =?", prestamo.id], :order=>'fecha_confirmacion desc, hora_confirmacion desc')
            GestionCobranzas.quitar_asignacion_analista(params[:id], @analista.id)
            render :update do |page|
              page.hide 'error'
              page.replace_html 'message', message
              page.replace_html 'gestion_cobranzas', :partial=>'gestion_cobranzas'
              page.show 'message'
              page.<< "window.scrollTo(0,0);"
              page.<< "limpiar_campos();"
            end
            return
        else
          render :update do |page|
            page.replace_html 'error', result.html_safe
            page.show 'error'
            page.hide 'mensaje'
            page.<< "window.scrollTo(0,0);"
            page.<< "this.disabled=false;"
            #page.form_error
          end
          return
        end
      end

    end

    logger.info "Usuario =====> #{usuario.inspect}"

  end

  def save_otro

    logger.info "PARAMETROS =========> #{params.inspect}"

    @telefonos_select = PersonaTelefono.all(:order=>"persona_id, tipo")
    render 'telecobranzas'
    return
  end

  def mostrar_llamada

    if !params[:id].nil? and params[:id] != ""
      render :update do |page|
        page.show 'resultado_llamada'
        page.hide 'persona_atendio'
        page.hide 'opcion_compromiso'
        page.hide 'compromiso_pago'
        page.<< 'limpiar_campos_telefono();'   
      end

    else
      render :update do |page|
        page.hide 'resultado_llamada'
        page.hide 'persona_atendio'
        page.hide 'opcion_compromiso'
        page.hide 'compromiso_pago'
        page.<< 'limpiar_campos_telefono();'
      end
    end
    
  end

  protected
  def common
   super
    @form_title = I18n.t('Sistema.Body.Controladores.GestionCobranzas.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.GestionCobranzas.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.GestionCobranzas.FormTitles.form_title_records')
    @form_entity = 'gestion_cobranzas'
    @form_identity_field = 'prestamo_id'
  end
end
