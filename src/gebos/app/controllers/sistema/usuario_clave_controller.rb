# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Sistema::UsuarioClaveController
# descripción: Migración a Rails 3

class Sistema::UsuarioClaveController < FormClassicController
    
  # Clave
  def index
    @usuario.clave = ''
  end
  
  def save_edit
  
    #puts params[:usuario].inspect

    @usuario.clave

    #logger.info "PARAMS ========> #{params.inspect}"
    
    clave = ''
    clave_anterior = ''
    clave_confirmacion = ''

    clave = Digest::MD5.new.hexdigest(params[:usuario][:clave])
    clave_anterior = Digest::MD5.new.hexdigest(params[:usuario][:clave_anterior])
    clave_confirmacion = Digest::MD5.new.hexdigest(params[:usuario][:clave_confirmation])
    clave_ant = Usuario.first(:conditions=>"password = '#{clave_anterior}' and id = #{@usuario.id}")
    #logger.info "clave_ant ========> #{clave_ant.inspect}"
    #if @usuario.password != params[:usuario][:clave_anterior]
    if clave_ant.nil?
      @usuario.errors.add(:usuario, I18n.t('Sistema.Body.Controladores.UsuarioClave.Mensajes.clave_invalida'))
		  render :update do |page|
		    page.hide 'message'
        page.replace_html 'error', :partial => 'error'
        page.show 'error'
	    end
	    return
    end
    
    if clave_anterior != clave
      @usuario.errors.add(:usuario, I18n.t('Sistema.Body.Controladores.UsuarioClave.Mensajes.clave_confirmacion_diferente'))
		  render :update do |page|
		    page.hide 'message'
        page.replace_html 'error', :partial => 'error'
		    page.show 'error'
	    end
	    return
    end
    
    @usuario.password = clave
    @usuario.fecha_cambio_clave = Date.today
    
    if @usuario.save
		  render :update do |page|
		    page.hide 'error'
		    page.hide 'buttons_edit'
		    page.show 'button_close'
        page.replace_html 'message', I18n.t('Sistema.Body.Controladores.UsuarioClave.Mensajes.cambio_contrasena_exitosa')
		    page.show 'message'
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
    @form_title = I18n.t('Sistema.Body.Controladores.UsuarioClave.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.UsuarioClave.FormTitles.form_title_record') 
    @form_title_records = I18n.t('Sistema.Body.Controladores.UsuarioClave.FormTitles.form_title_records')
    @form_entity = 'usuario'
    @form_identity_field = 'nombre_usuario'
  end

end

