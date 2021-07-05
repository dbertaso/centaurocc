#Este es el controlador que usa el formulario principal de login
class InicioController < ApplicationController

  require 'net/ldap'

  def index

  end

  # Método llamado cuando el usuario intente iniciar una sesión
  # con su nombre de usuario y password
  def login
    @usuario = Usuario.new
    ldap_config = YAML.load_file("#{Rails.root}/config/ldap.yml")[Rails.env]
    #@url_sag         = ldap_config['sag_url']

    if session[:id]
      redirect_to sesion_path
      return
    end

    if request.post?
      @usuario = Usuario.new(params[:usuario])
      logged_in_user = @usuario.try_to_login
      if logged_in_user
        update_activity_time
        is_authorized = true
        #unless @usuario.nombre_usuario == 'admin' || !@usuario.super_usuario # Eliminar ADMIN

#         #--------------#           #Carga de configuración ldap.yml
#           ldap_config = YAML.load_file("#{RAILS_ROOT}/config/ldap.yml")[RAILS_ENV]
#           base               = ldap_config['base']
#           subtree         = ldap_config['subtree']
#           admin_user   = ldap_config['admin_username']
#           admin_pwd     = ldap_config['admin_password']
#           nombre_sag   = ldap_config['sag_name']
#           host               = ldap_config['host']
#           port               = ldap_config['port']
#           #Parámetros adicionales
#           filter           = "(&(objectClass=inetOrgPerson)(uid=#{@usuario.nombre_usuario}))"
#           attrs             = ['sn', 'cn', 'uid',  'dueDate', 'statusPassword']
# #          begin
# #            ldap = Net::LDAP.new
# #            ldap.host = host
# #            ldap.port = port
# #            #Auth fase 1
# #            #Paso 1: Conectarse como Admin
# #            ldap.auth "cn=#{admin_user},#{base}", "#{admin_pwd}"
# #            is_authorized = ldap.bind
# #            logger.debug "InicioController.login: Autorizando ADMIN " << is_authorized.to_s
# #            #Paso 2: Búsqueda del usuario solicitado
# #            if is_authorized
# #              is_authorized = nil
# #              ldap.search(:base => subtree, :filter => filter, :attributes => attrs) do |entry|
# #                status_pw = entry[:statuspassword][0]
# #                user = entry[:uid][0]
# #                domain = entry[:dn][0]
# #                #Unicamente permite entrada en caso de statusPassword = 1
# #                if status_pw == '0'
# #                  #estatus 0 corresponde a reiniciar clave
# #                  logger.debug "InicioController.login: Reiniciar clave #{(@usuario.nombre_usuario)}"
# #                  @usuario.errors.add(nil, "Debe reiniciar su clave. Ir a <a href=#{@url_sag} target='_blank'>#{nombre_sag}</a>")
# #                  is_authorized = false
# #                  break
# #                elsif status_pw == '2'
# #                  #estatus 2 corresponde a usuario bloqueado
# #                  logger.debug "InicioController.login: Cuenta bloqueada #{(@usuario.nombre_usuario)}"
# #                  @usuario.errors.add(nil, "Su cuenta de usuario se encuentra bloqueada. Ir a Ir a <a href=#{@url_sag} target='_blank'>#{nombre_sag}</a>")
# #                  is_authorized = false
# #                  break
# #                elsif status_pw == '1'
# #                  #Usuario válido encontrado en LDAP
# #                  #Validando fecha de Expiración de la clave
# #                  fecha_exp = Date.strptime(entry[:duedate][0], '%d/%m/%Y')
# #                  if fecha_exp < Date.today
# #                    @usuario.errors.add(nil, "Su contraseña ha caducado. Ir a <a href=#{@url_sag} target='_blank'>#{nombre_sag}</a>")
# #                    is_authorized = false
# #                  else
# #                    ldap.auth "#{domain}", "#{@usuario.clave}"
# #                    is_authorized = ldap.bind
# #                    @usuario.errors.add(nil, "Usuario Inactivo en Sistema. Comuníquese con el Administrador del Sistema ") unless is_authorized
# #                  end
# #                end
# #              end
# #              @usuario.errors.add(nil, "El usuario no se encuentra registrado") if is_authorized.nil?
# #            else
# #              #Datos de conexión ó Datos de cuenta ADMIN erróneos
# #              @usuario.errors.add(nil, "Error de comunicación con LDAP. Comuníquese con el Administrador del Sistema")
# #            end
# #          rescue Exception => e
# #            is_authorized = false
# #            @usuario.errors.add(nil, "Error de comunicación con LDAP. Comuníquese con el Administrador del Sistema")
# #            logger.error e.message
# #            logger.error e.backtrace.join("\n")
# #          end
# #                                  # ELMNAR LDAP----------------------------------------------------
#          else
#           #logger.debug "LDAP - Autorizado (Admin)"
           #is_authorized = true
        #end
       #-------------------------------------------------------------------
        if is_authorized == true
          session[:id] = logged_in_user.id
          #render 'sesion' if validate_session
          session[:menu_string] = nil
          result = validate_session
          render :action => 'sesion' if result
          if result == false
            @usuario.save
          end      
        else
          reset_session
          #@usuario.errors.add(nil, "La combinación usuario/contraseña es invalida")
          render login_path
        end
      else
        reset_session

        #flash[:msg_error] = "La combinación usuario/contraseña es invalida"
        @usuario.errors.add(:usuario, t('Sistema.Body.Modelos.Usuario.Errores.password_invalido'))        
        render :action=> 'login'
      end
    end
  end

  #Este método cierra la sesión del usuario
  def logout
      reset_session
      @usuario = Usuario.new(params[:usuario])
      ldap_config = YAML.load_file("#{Rails.root}/config/ldap.yml")[Rails.env]
      @url_sag         = ldap_config['sag_url']
      render 'login'
  end

  def sesion

  end

end

