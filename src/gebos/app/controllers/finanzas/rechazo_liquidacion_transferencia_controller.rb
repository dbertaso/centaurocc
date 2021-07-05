# encoding: utf-8
# 
# autor: Luis Rojas
# clase: Finanzas::RechazoLiquidacionTransferenciaController
# descripción: Migración a Rails 3

class Finanzas::RechazoLiquidacionTransferenciaController < FormClassicController
  
  def index
    @entidad_financiera_list = EntidadFinanciera.find(:all, :conditions=>'activo=true and activo_banmujer=true', :order =>'nombre')
    sentencia="SELECT mon.id AS id, mon.abreviatura,mon.nombre,        
    CASE
      WHEN mon.id = par.moneda_id THEN 
            '1'::text
            ELSE '0'::text
        END AS no_va
   FROM moneda mon,parametro_general par 
   where mon.activo=true order by no_va desc, nombre;"
    @moneda_list=Moneda.find_by_sql(sentencia) 
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

    logger.info "Moneda =======> #{params[:moneda_id].inspect}"
    unless params[:moneda_id].nil? 
      unless params[:moneda_id][0].to_s==''      
        conditions = [" moneda_id = ?", params[:moneda_id][0].to_i]
        moneda = Moneda.find(params[:moneda_id][0])
        unless moneda.nil?
          moneda_nombre = moneda.nombre
        else
          moneda_nombre = ' '
        end
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.moneda_igual')} '#{moneda_nombre}'"
      end
    end

    entidad_financiera_id = params[:entidad_financiera][:id]
    unless entidad_financiera_id.nil? || entidad_financiera_id.empty?
      conditions << " AND entidad_financiera_id = #{entidad_financiera_id}"
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.entidad_financiera')} #{I18n.t('Sistema.Body.Vistas.General.igual')} '#{EntidadFinanciera.find(entidad_financiera_id).nombre}'"
    end
    
    @list = ViewRechazoLiquidacion.search(conditions, params[:page], params['sort'])    
    @total=@list.count

    form_list

  end

  def avanzar
    @solicitud = Solicitud.find_by_numero(params[:solicitud_numero])
    estatus_id_inicial = @solicitud.estatus_id
    fecha_evento = Time.now
    @solicitud.estatus_id = "10050"
    @solicitud.fecha_actual_estatus = fecha_evento.strftime("%Y/%m/%d")
    @solicitud.save

    @rechazo = RechazoLiquidacion.find(params[:id])
    @rechazo.procesado = true
    @rechazo.save      
      
    # Crea un nuevo registro en la tabla control_solicitud
    ControlSolicitud.create_new(@solicitud.id, "10050", @usuario.id, 'Avanzar', estatus_id_inicial, '')
    estatus = Estatus.find("10050")

    render :update do |page|
      page.remove "rlt_#{@rechazo.id}"
      page.hide 'error'
      page.replace_html 'message', "#{I18n.t('Sistema.Body.Vistas.General.el')} #{I18n.t('Sistema.Body.Vistas.General.solicitud')} #{I18n.t('Sistema.Body.Vistas.General.numero')} #{@solicitud.numero} #{I18n.t('Sistema.Body.Vistas.General.fue_enviado')} #{estatus.nombre} #{I18n.t('Sistema.Body.Vistas.General.con_exito')}."
      page.show 'message'
    end
  end
   
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Vistas.General.rechazo_liquidacion_transferencia')
    @form_title_record = I18n.t('Sistema.Body.Vistas.General.solicitud')
    @form_title_records = I18n.t('Sistema.Body.Vistas.General.solicitud')
    @form_entity = 'solicitud'
    @form_identity_field = 'numero'
    @width_layout = '1160'
  end 

end