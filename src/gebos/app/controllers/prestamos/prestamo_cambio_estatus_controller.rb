# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Prestamos::PrestamoCambioEstatusController
# descripción: Migración a Rails 3

class Prestamos::PrestamoCambioEstatusController < FormTabsController

  layout 'form_basic'

  def list

    params['sort'] = "numero desc" unless params['sort']

    logger.info "Params ====> #{params.inspect}"
    condition = "prestamo.estatus in('E','J','V') "
    conditions = ""

    unless params[:identificacion].nil?
      conditions = " identificacion LIKE '%#{params[:tipo]+params[:identificacion].strip}%'"
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.cedula_rif_contenga')} '#{params[:tipo]+params[:identificacion]}'"
    end

    unless params[:nro_prestamo].nil? || params[:nro_prestamo].to_i <= 0
      conditions = " numero = #{params[:nro_prestamo].to_s}"
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.numero_tramite')} '#{params[:numero]}'"
    end

    unless params[:nro_solicitud].nil? || params[:nro_solicitud].to_i <= 0
      #conditions = "#{conditions} AND (numero_helper =  #{@params[:numero].to_i} OR origen_helper = #{@params[:numero].to_i})"
      conditions = " (numero_solicitud = #{params[:nro_solicitud]} OR numero_origen = #{params[:nro_solicitud]}) "
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.numero_tramite')} '#{params[:numero_solicitud]}'"
    end

    unless params[:nombre] == "" or params[:nombre].nil?
      conditions = " LOWER(nombre_cliente) LIKE '%#{params[:nombre].strip.downcase}%'"
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.nombre_apellido')} '#{params[:nombre]}'"
    end
    
    if conditions == ""
        conditions = "estatus_p in ('E','J','V')"
    else
      conditions << " and estatus_p in ('E','J','V')"
    end
      
    logger.info "Conditions =====> #{conditions}"
    @list = ViewConsultaPrestamos.search(conditions, params[:page], params[:sort])
    @total=@list.count
    @pages = @list
    logger.info "List ========> #{@list.inspect}"
    form_list

  end

  def edit
    @prestamo = Prestamo.find(params[:id])
    @solicitud = Solicitud.find(@prestamo.solicitud_id)
    @cliente = @solicitud.cliente
  end

  def save_edit
    #Logica para persistencia del Cambio de Estatus

    success = true
    @prestamo = Prestamo.find(params[:id])
    @solicitud = Solicitud.find(@prestamo.solicitud_id)
    #@reestructuracion = ReestructuracionCambioEstatus.find(@prestamo.solicitud_id)

    logger.info "Reestructuración #{@reestructuracion.inspect}"
    
    if params['cambio']['estatus'].nil? 
    
      @prestamo.errors.add(:solicitud, t('Sistema.Body.Modelos.Prestamo.Mensajes.debe_seleccionar_estatus'))
      succes = false
    end
    
    if params['cambio']['estatus'].to_s == 'L' or
       params['cambio']['estatus'].to_s == 'Q' or 
       params['cambio']['estatus'].to_s == 'J' or
       params['cambio']['estatus'].to_s == 'R'

      if @solicitud.estatus_id != 10100 &&
         @solicitud.estatus_id != 10110
        @solicitud.errors.add(:solicitud, t('Sistema.Body.Modelos.Prestamo.Mensajes.tramite_debe_estar_liquidado'))
        success = false
      end

    end
    
    case  @prestamo.estatus
      
      when 'V'
      
        if  params['cambio']['estatus'].to_s == 'L' 
        
           @prestamo.errors.add(:prestamo, t('Sistema.Body.Modelos.Prestamo.Mensajes.solo_puede_pasar_al_estatus_desde_vigente'))
          success = false
        end
      
      when 'E'
        if  params['cambio']['estatus'].to_s == 'L' 
        
           @prestamo.errors.add(:prestamo, t('Sistema.Body.Modelos.Prestamo.Mensajes.solo_puede_pasar_al_estatus_desde_vencido'))
          success = false
        end
        
      when 'J'
        if  params['cambio']['estatus'].to_s == 'J' or
            params['cambio']['estatus'].to_s == 'R'
        
           @prestamo.errors.add(:prestamo, t('Sistema.Body.Modelos.Prestamo.Mensajes.solo_puede_pasar_al_estatus_desde_juridico'))
          success = false
        end    
    end

    if success
        
      result = ReestructuracionCambioEstatus.aplicar_liberar(params, @prestamo.id)
      
      if result
        flash[:notice] = "#{t('Sistema.Body.Vistas.General.el')} #{t('Sistema.Body.Vistas.General.financiamiento')} '#{@prestamo.numero}' #{t('Sistema.Body.Controladores.Mensaje.cambio_estatus')}"
        render :update do |page|
          page.redirect_to :action=>'index'
        end
      else
        logger.debug "Ocurrieron errores"

        render :update do |page|
          page.form_error
        end
      end
    else
      render :update do |page|
        page.form_error
      end
    end

  end

  def levantar_liberacion
    @reestructuracion = Reestructuracion.find(params[:id])
    @reestructuracion.deshacer_liberar
    render :update do |page|
      page.remove "row_#{@reestructuracion.id}"
    end
  end

  protected
  def common
    super
    @form_title = t('Sistema.Body.Controladores.PrestamoCambioEstatus.FormTitles.form_title')
    @form_title_record = t('Sistema.Body.Controladores.PrestamoCambioEstatus.FormTitles.form_title_record')
    @form_title_records = t('Sistema.Body.Controladores.PrestamoCambioEstatus.FormTitles.form_title_records')
    @form_entity = 'solicitud'
    @form_identity_field = 'numero'
  end

  private

end

