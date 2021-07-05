# encoding: utf-8

class Sistema::AutorizacionAprobacionController < FormClassicController
  
  skip_before_filter :set_charset, :only=>[:aprobar ]

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
        conditions = ["creacion >= ? and creacion <= ? and estatus = ?", fecha_desde, fecha_hasta, params[:estatus]]
      else
        conditions = ["creacion >= ? and creacion <= ? and estatus = ? and vencimiento < ?", fecha_desde, fecha_hasta, 'E', Time.now]
      end
    else
      conditions = [ "autorizacion.estatus = 'E' and vencimiento > ?", Time.now ]
    end
    
    @list = Autorizacion.search(conditions, params[:page], params[:sort])
    @total=@list.count
    form_list
  end

  def aprobar
    autorizacion = Autorizacion.find(params[:id])
    autorizacion.estatus = 'A'
    autorizacion.usuario_aprobo = @usuario
    if autorizacion.save
      render :update do |page|
        page.remove "row_#{params[:id]}"
      end
    else
      render :update do |page|
        page.replace 'error' "#{I18n.t('Sistema.Body.Controladores.AutorizacionAprobacion.FormTitles.error_aprobacion')}"
        page.show 'error'
      end
    end
  end

  def rechazar
    autorizacion = Autorizacion.find(params[:id])
    autorizacion.estatus = 'R'
    autorizacion.usuario_aprobo = @usuario
    if autorizacion.update
      render :update do |page|
        page.remove "row_#{params[:id]}"
      end
    else
      render :update do |page|
        page.replace 'error' "#{I18n.t('Sistema.Body.Controladores.AutorizacionAprobacion.FormTitles.error_rechazo')}"
        page.show 'error'
      end
    end
  end

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.AutorizacionAprobacion.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.AutorizacionAprobacion.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.AutorizacionAprobacion.FormTitles.form_title_records')
    @form_entity = 'autorizacion'
    @form_identity_field = 'autorizacion.opcion_accion.autorizacion_nombre'
  end

end

