# encoding: utf-8
class Sistema::CambiarClaveController < FormTabsController
  
  skip_before_filter :set_charset, :only=>[:tabs ]

  def index
    @usuario = Usuario.find(params[:usuario_id])
  end

  def save_edit   
    @usuario = Usuario.find(params[:id])
    if params[:usuario][:clave].nil? || params[:usuario][:clave].empty?
      @usuario.errors.add(:usuario, I18n.t('Sistema.Body.Controladores.CambiarClave.FormTitles.clave_nueva_requerida'))
    elsif params[:usuario][:clave].length < 6
      @usuario.errors.add(:usuario, I18n.t('Sistema.Body.Controladores.CambiarClave.FormTitles.clave_nueva_mayor'))
    elsif params[:usuario][:clave_confirmation]!=params[:usuario][:clave]
      @usuario.errors.add(:usuario, I18n.t('Sistema.Body.Controladores.CambiarClave.FormTitles.clave_diferente'))
    end
    
    if @usuario.errors.size > 0
      render :update do |page|
		    page.hide 'message'
        page.replace_html 'error', :partial => 'error'
		    page.show 'error'
	    end
	    return
    end
    
    @usuario.password = params[:usuario][:clave]
    @usuario.fecha_cambio_clave = Date.today
    
    if @usuario.save
		  render :update do |page|
		    page.hide 'error'
		    page.hide 'buttons_edit'
		    page.show 'button_close'
        page.replace_html 'message', I18n.t('Sistema.Body.Controladores.CambiarClave.FormTitles.confirmacion_cambio_clave')
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
    @form_title = I18n.t('Sistema.Body.Controladores.CambiarClave.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.CambiarClave.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.CambiarClave.FormTitles.form_title_records')
    @form_entity = 'usuario'
    @form_identity_field = 'nombre_usuario'
    @width_layout = '960'
  end


end

