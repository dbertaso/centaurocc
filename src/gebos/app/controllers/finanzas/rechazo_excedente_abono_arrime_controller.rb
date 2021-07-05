# encoding: utf-8
# 
# autor: Luis Rojas
# clase: Finanzas::RechazoExcedenteAbonoArrimeController
# descripción: Migración a Rails 3

class Finanzas::RechazoExcedenteAbonoArrimeController < FormClassicController
  
  def index
    @entidad_financiera_list = EntidadFinanciera.find(:all, :conditions=>'activo=true and activo_banmujer=true', :order =>'nombre')
  end

  def list
 
    params['sort'] = "solicitud_numero" unless params['sort']
    @oficina_id = session[:oficina]
    conditions = "not procesado"

    unless params[:identificacion].nil? ||  params[:identificacion].empty?
      conditions << "  AND identificacion LIKE  '%#{params[:tipo]+params[:identificacion].strip.downcase}%' "
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.cedula')} / #{I18n.t('Sistema.Body.Vistas.General.rif')} #{I18n.t('Sistema.Body.Vistas.General.igual')} '#{params[:tipo]+params[:identificacion]}'"
    end
    unless params[:numero].nil? || params[:numero].empty?
      conditions << " AND solicitud_numero =  #{params[:numero].to_i}"
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.nro')} #{I18n.t('Sistema.Body.Vistas.General.solicitud')} #{I18n.t('Sistema.Body.Vistas.General.igual')} '#{params[:numero]}'"
    end
    unless params[:nombre].nil? || params[:nombre].empty?
      conditions << " AND LOWER(nombre) LIKE  '%#{params[:nombre].strip.downcase}%'"
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Vistas.General.del')} #{I18n.t('Sistema.Body.General.beneficiario')} #{I18n.t('Sistema.Body.Vistas.General.contenga')} '#{params[:nombre]}'"
    end
    unless params[:fecha_lq].nil? || params[:fecha_lq].empty?
      conditions << " AND fecha = '#{params[:fecha_lq]}'"
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.fecha_liquidacion')} #{I18n.t('Sistema.Body.Vistas.General.igual')} '#{params[:fecha_lq]}'"
    end
    entidad_financiera_id = params[:entidad_financiera][:id]
    unless entidad_financiera_id.nil? || entidad_financiera_id.empty?
      conditions << " AND entidad_financiera_id = #{entidad_financiera_id}"
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.entidad_financiera')} #{I18n.t('Sistema.Body.Vistas.General.igual')} '#{EntidadFinanciera.find(entidad_financiera_id).nombre}'"
    end
    
    @list = ViewRechazoExcedenteAbonoArrime.search(conditions, params[:page], params['sort'])    
    @total=@list.count

    form_list

  end

  def avanzar
    @solicitud = Solicitud.find_by_numero(params[:solicitud_numero])
    #      estatus_id_inicial = @solicitud.estatus_id
    #      fecha_evento = Time.now
    #      @solicitud.estatus_id = "30000"
    #      @solicitud.fecha_actual_estatus = fecha_evento.strftime("%Y/%m/%d")
    #      @solicitud.save

    @rechazo = RechazoExcedenteAbonoArrime.find(params[:id])
    @rechazo.procesado = true
    @rechazo.save      
      
    # Crea un nuevo registro en la tabla control_solicitud
    #      ControlSolicitud.create_new(@solicitud.id, "30000", @usuario.id, 'Avanzar', estatus_id_inicial, '')
    #      estatus = Estatus.find("30000")

    @orden = OrdenAbonoExcedenteArrime.find(:all, :conditions => "estatus_id = '30150' and solicitud_id = #{@solicitud.id}")
    unless @orden.size == 0
      @orden[0].estatus_id = 30000
      @orden[0].save
    end

    render :update do |page|
      page.remove "rlt_#{@rechazo.id}"
      page.hide 'error'
      page.replace_html 'message', "El Trámite Número #{@solicitud.numero} fue Enviada con Exito."
      page.show 'message'
    end
  end
   
  protected
  def common
    super
    @form_title = "Rechazo Excedente Abono Arrime"
    @form_title_record = 'Trámite'
    @form_title_records = 'Trámites'
    @form_entity = 'solicitud'
    @form_identity_field = 'numero'
    @width_layout = '1160'
  end 

end

