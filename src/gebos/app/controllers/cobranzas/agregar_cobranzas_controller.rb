class Cobranzas::AgregarCobranzasController < FormClassicController

  #skip_before_filter :set_charset, :only=>[:index]
  def index

    unless params[:analista_id].nil? and params[:prestamo_id].nil?
      GestionCobranzas.quitar_asignacion_analista(params[:prestamo_id],params[:analista_id])
    end
    list
  end

  def list

    conditions = 'prestamo.cantidad_cuotas_vencidas > 0 and prestamo.estatus not in (\'F\', \'A\', \'C\', \'L\')'

    joins = ""
    usuario = Usuario.find(session[:id])
    logger.info "Usuario =============> #{session[:id].inspect}"

    unless usuario.nil?
      analista = AnalistaCobranzas.find_by_usuario_id(usuario.id)
      logger.info "Analista ======> #{analista.class.to_s}"

      unless analista.nil?
        if !analista.senal_supervisor 
          unless analista.sector_id.nil? and analista.sub_sector_id.nil?
            conditions += " and solicitud.sector_id = #{analista.sector_id.to_s} and solicitud.sub_sector_id = #{analista.sub_sector_id.to_s} "
          else
            logger.info "Analista ======> #{analista.analista}"
            @error =  I18n.t('Sistema.Body.Controladores.AgregarCobranzas.Errores.analista_sin_sector_asignado', analista: analista.analista)
            render :error
            return
          end
        end
      else
        logger.info "Analista ======> #{analista.class.to_s}"
        @error =  I18n.t('Sistema.Body.Controladores.AgregarCobranzas.Errores.usuario_no_analista', analista: usuario.nombre_usuario)
        render :error    
        return
      end
    end
    joins = "inner join solicitud on prestamo.solicitud_id = solicitud.id"

    logger.info "Joins ========> #{joins.to_s}"
    params[:sort] = "prestamo.dias_mora desc" unless params['sort']

    unless params[:numero].nil? || params[:numero].to_i <= 0
      conditions += " and prestamo.numero = #{params[:numero].to_s}"
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.numero_tramite')} '#{params[:numero]}'"
    end
    
    @list = Prestamo.search_pv(conditions, params[:page], params[:sort], joins)
    @total=@list.count

    form_list

  end

  def asignado

    prestamo = Prestamo.find(params[:id])

    unless prestamo.analista_cobranzas_id.nil?
      flash[:notice] = "El caso esta siendo gestionado por #{prestamo.analista_cobranzas.analista}"
      redirect_to :index
    end
    return
  end

  def view

  end

  protected
  def common
   super
    @form_title = I18n.t('Sistema.Body.Controladores.AgregarCobranzas.FormTitles.form_title')
    @form_title_records = I18n.t('Sistema.Body.Controladores.AgregarCobranzas.FormTitles.form_title_records')
    @form_title_search = I18n.t('Sistema.Body.Controladores.AgregarCobranzas.FormTitles.form_title')
    @form_entity = 'agregar_cobranzas'
    @form_identity_field = 'prestamo_id'
    @width_layout = '900'
  end

end
