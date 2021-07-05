# encoding: utf-8
class Sistema::AutorizacionSolicitudController < FormClassicController

  layout 'form'

	def index
    fecha_hoy = Time.now.strftime(I18n.t('time.formats.gebos_short'))
    fecha_manana = Time.now + (60 * 60 * 24)
    @fecha_desde = fecha_hoy
    @fecha_hasta = fecha_manana.strftime(I18n.t('time.formats.gebos_short'))
	end

  def list
    params['sort'] = "autorizacion.creacion" unless params['sort']
    if params[:estatus] != 'E'
      fecha_desde = params[:fecha_desde].split("/")
      fecha_desde = Time.gm(fecha_desde[2], fecha_desde[1], fecha_desde[0], 0, 0, 0)
  
      fecha_hasta = params[:fecha_hasta].split("/")
      fecha_hasta = Time.gm(fecha_hasta[2], fecha_hasta[1], fecha_hasta[0], 0, 0, 0)

      if params[:estatus] != 'V'
        conditions = ["usuario_id = ? and creacion >= ? and creacion <= ? and estatus = ?", @usuario.id, fecha_desde, fecha_hasta, params[:estatus]]
      else
        conditions = ["usuario_id = ? and creacion >= ? and creacion <= ? and estatus = ? and vencimiento < ?", @usuario.id, fecha_desde, fecha_hasta, 'E', Time.now]
      end
    else
      conditions = [ "usuario_id = ? and autorizacion.estatus = 'E' and vencimiento > ?", @usuario.id, Time.now ]
    end
      
    
    @list = Autorizacion.search(conditions, params[:page], params[:sort])
    @total=@list.count
    form_list

  end
  
  def new
    @autorizacion = Autorizacion.new
    @opcion_accion_list = OpcionAccion.find(:all, :conditions=>"autorizacion_extendida = true")
    render :update do |page|
      page.hide 'error'
      page.hide 'message'
      page.hide 'button-new'
      page.hide 'consulta'
      page.replace_html "form_new", :partial => "new"
      page.show 'form_new'
    end
  end
  
  def cancel_new
    render :update do |page|
      page.show 'consulta'
      page.hide 'error'
      page.show 'button-new'
      page.hide 'form_new'
      page.hide 'message'
    end
  end
  
  def save_new
    @autorizacion = Autorizacion.new(params[:autorizacion])
    opcion_accion = @autorizacion.opcion_accion
    @autorizacion.descripcion = "#{opcion_accion.autorizacion_nombre} #{I18n.t('Sistema.Body.Controladores.AutorizacionSolicitud.FormTitles.para_el_prestamo')} " + 
      @autorizacion.prestamo_numero.to_s + " #{I18n.t('Sistema.Body.Controladores.AutorizacionSolicitud.FormTitles.por_monto_de')} " + @autorizacion.monto_fm + " Bs."
    @autorizacion.usuario = @usuario
    if @autorizacion.save
	  render :update do |page|
		page.show 'consulta'
		page.hide 'error'
		page.hide 'form_new'
  	    page.replace_html 'message', "#{I18n.t('Sistema.Body.Controladores.AutorizacionSolicitud.FormTitles.se_agrego_con_exito')}"
    	page.show 'message'
		page.show 'button-new'
      end
    else
	  render :update do |page|
    	page.show 'error'
    	page.hide 'message'
      end
    end
  end
  
  def delete
    autorizacion = Autorizacion.find(@params[:id])
    if autorizacion.destroy
  		render :update do |page|
  		  page.remove "row_#{@params[:id]}"
      end
    else
  		render :update do |page|
  		  page.replace_html 'error', "#{I18n.t('Sistema.Body.Controladores.AutorizacionSolicitud.FormTitles.error_eliminando')}"
  		  page.show 'error'
      end
    end
  end

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.AutorizacionSolicitud.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.AutorizacionSolicitud.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.AutorizacionSolicitud.FormTitles.form_title_records')
    @form_entity = 'autorizacion'
    @form_identity_field = 'autorizacion.opcion_accion.autorizacion_nombre'
  end

end
