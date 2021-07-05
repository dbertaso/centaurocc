# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Sistema::OlvidoClaveController

class Sistema::OlvidoClaveController < FormClassicController

  before_filter :session_expiry, :except => [:index, :save_edit]
  before_filter :update_activity_time, :except => [:index, :save_edit]
  before_filter :validate_session, :except => [:index, :save_edit]
    
  # Clave
  def index
  end
  
  def save_edit
  
    #puts params[:usuario].inspect

    if params[:nombre_usuario].nil? || params[:nombre_usuario] == ''
      render :update do |page|
        page.alert I18n.t('Sistema.Body.Controladores.OlvidoClave.Mensajes.nombre_usuario_requerido')
      end
      return
    end

    if params[:cedula].nil? || params[:cedula] == ''
      render :update do |page|
        page.alert I18n.t('Sistema.Body.Controladores.OlvidoClave.Mensajes.cedula_requerida')
      end
      return
    end

    if params[:tipo].nil? || params[:tipo] == ''
      render :update do |page|
        page.alert I18n.t('Sistema.Body.Controladores.OlvidoClave.Mensajes.letra_requerida')
      end
      return
    end


    @usuario = Usuario.find(:first, :conditions=>["nombre_usuario = ? and cedula = ? and cedula_nacionalidad = ?", params[:nombre_usuario], params[:cedula], params[:tipo]])
    
    if @usuario.nil?
      render :update do |page|
        page.alert I18n.t('Sistema.Body.Controladores.OlvidoClave.Mensajes.nombre_cedula_incorrecto')
      end
      return
    end

    if params[:clave_confirmation] != params[:clave]
      @usuario.errors.add(:usuario, I18n.t('Sistema.Body.Controladores.UsuarioClave.Mensajes.clave_confirmacion_diferente'))
		  render :update do |page|
		    page.hide 'message'
        page.replace_html 'error', :partial => 'error'
		    page.show 'error'
	    end
	    return
    end
    
    logger.info "Usuario ============> #{@usuario.inspect}"
    @usuario.password = params[:clave]
    @usuario.fecha_cambio_clave = Date.today
    
    if @usuario.save
		  render :update do |page|
		    page.hide 'error'
		    page.hide 'buttons_edit'
		    page.show 'button_close'
        page.replace_html 'message', I18n.t('Sistema.Body.Controladores.UsuarioClave.Mensajes.cambio_contrasena_exitosa')
		    page.show 'message'
        page.<< 'window.close()'
	    end
	  else
		  render :update do |page|
		    page.hide 'message'
        page.replace_html 'error', :partial => 'error'
		    page.show 'error'
	    end
	  end
  end
  
  protected  
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.OlvidoClave.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.OlvidoClave.FormTitles.form_title_record') 
    @form_title_records = I18n.t('Sistema.Body.Controladores.OlvidoClave.FormTitles.form_title_records')
    @form_entity = 'usuario'
    @form_identity_field = 'nombre_usuario'
  end

end
