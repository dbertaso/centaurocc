# encoding: utf-8
class Visitas::VisitaSeguimientoController < FormVisitasAjaxController
  
  skip_before_filter :set_charset, :only=>[:beneficiario_atendio_tecnico_click,:confirmar,:new,:form_new]

  def index
    @solicitud = params[:id]
    list
  end

  def list
    @controlador =  '/visitas/visita_solicitud'
    @solicitud = params[:id]
    params['sort'] = "id desc" unless params['sort']
    conditions = "solicitud_id = #{params[:id]} and activo = TRUE"
    
    @list = SeguimientoVisita.search(conditions, params[:page], params[:sort])
    @total=@list.count
    form_list
  end

  def new
    @accion = params[:action]   
    @solicitud = params[:id]
    msg_error=""
    seguimiento = SeguimientoVisita.count(:all, :conditions=>"solicitud_id = #{@solicitud} and motivo_visita_id != 1 and confirmada=false and activo=true")
    if seguimiento > 0
      msg_error << I18n.t('Sistema.Body.Controladores.VisitaSeguimiento.Errores.error_new')
      render :update do |page|
        page.alert msg_error
      end
      return false
    end
    fill
    @seguimiento_visita = SeguimientoVisita.new(:solicitud_id => @solicitud)
    @unidad_produccion = @seguimiento_visita.solicitud.unidad_produccion
    form_new @seguimiento_visita
  end

  def cancel_new
    #form_cancel_new
    @solicitud = params[:id]
    render :update do |page|
      page.redirect_to :action=>'index', :id=>@solicitud = params[:id], :popup=>params[:popup]
    end
  end

  def save_new
    @solicitud = params[:id]
    @seguimiento_visita = SeguimientoVisita.new(params[:seguimiento_visita])
    @seguimiento_visita.solicitud_id = params[:id]
    #creando el codigo de visita (ICV - <inicial_sector>-<anio_curso>-<codigo_tenico>-<cantidad_visitas>)
    inicial_sector = @seguimiento_visita.solicitud.sub_sector.nemonico
    anio_curso = Time.now.strftime("%Y")
    @tecnico = TecnicoCampo.find_by_cedula(@usuario.cedula)
    tecnico_id = @tecnico.id
    codigo_tecnico = @tecnico.codigo.to_s
    cantidad_visitas = @tecnico.cantidad_visitas
    logger.debug "*****"<< cantidad_visitas.to_s
    cantidad_visitas = cantidad_visitas + 1
    cantidad_visitas = cantidad_visitas.to_s
    logger.debug "*****"<< cantidad_visitas
    codigo_visita = "ICV"
    codigo_visita += "-"
    codigo_visita += inicial_sector
    codigo_visita += "-"
    codigo_visita += anio_curso
    codigo_visita += "-"
    codigo_visita += codigo_tecnico
    codigo_visita += "-"
    codigo_visita += cantidad_visitas
    logger.debug "******"
    logger.debug codigo_visita
    @seguimiento_visita.codigo_visita = codigo_visita
    @seguimiento_visita.usuario_visita = @usuario.nombre_usuario
    @seguimiento_visita.fecha_registro = Time.now

    fecha_registro = Time.now

    @referencia = params[:unidad_produccion][:referencia]
    solicitud = Solicitud.find(@solicitud)
    direccion = params[:seguimiento_visita][:direccion_correcta].to_s
    success = true
    success &&= @seguimiento_visita.validar_referencia(@referencia, solicitud, direccion)
    if success
      success &&= @seguimiento_visita.semana_antes_visita(params[:seguimiento_visita][:fecha_visita_f], fecha_registro.to_date)
      if success
        success &&= @seguimiento_visita.validar_fecha_visita(params, solicitud)
        if success
          @tecnico.cantidad_visitas += 1
          @tecnico.save

          form_save_ajaxnew @seguimiento_visita
        else
          render :update do |page|
            page.hide 'messages'
            page.form_error('form_new')
            page.<< "varEnviado=false;$('button_save').disabled=false"
          end
          return false
        end
      else
        render :update do |page|
          page.hide 'messages'
          page.form_error('form_new')
          page.<< "varEnviado=false;$('button_save').disabled=false"
        end
        return false
      end
    else
      render :update do |page|
        page.hide 'messages'
        page.form_error('form_new')
        page.<< "varEnviado=false;$('button_save').disabled=false"
      end
      return false
    end
  end

  def delete
    @seguimiento_visita = SeguimientoVisita.find(params[:id])
    @seguimiento_visita.activo=false
    @seguimiento_visita.save
    logger.info @seguimiento_visita.inspect
    logger.debug "======== delete " << @seguimiento_visita.activo.to_s
    #form_ajaxdelete @seguimiento_visita
    render :update do |page|
      page.redirect_to :action=>'index', :id=>@seguimiento_visita.solicitud_id
    end
  end

  def edit
    @accion = params[:action]
    @seguimiento_visita = SeguimientoVisita.find(params[:id])
    fill
    @unidad_produccion = @seguimiento_visita.solicitud.unidad_produccion
    form_edit @seguimiento_visita
  end

  def save_edit
    @seguimiento_visita = SeguimientoVisita.find(params[:id])
    @referencia = params[:unidad_produccion][:referencia]
    @seguimiento_visita.usuario_visita = @usuario.nombre_usuario
    solicitud = Solicitud.find(@seguimiento_visita.solicitud_id)
    direccion = params[:seguimiento_visita][:direccion_correcta].to_s
    success = true
    success &&= @seguimiento_visita.validar_referencia(@referencia,solicitud,direccion)
    if success
      @seguimiento_visita.update_attributes(params[:seguimiento_visita])
      if success
        render :update do |page|
          page.hide "error_row_#{@seguimiento_visita.id}"
          page.replace_html 'messages',"#{I18n.t('Sistema.Body.Controladores.VisitaSeguimiento.Messages.se_actualizo_con_exito')} <span style=\"color: #FF0000\">'#{@seguimiento_visita.codigo_visita}'</span>"
          page.show 'messages'


          if @seguimiento_visita.solicitud.sub_sector.nemonico=="AN" 

            page.redirect_to :action=>'index', :controller=> '/visitas/visita_pastizales_potreros' ,:id=>@seguimiento_visita.id, :popup=>params[:popup] unless @seguimiento_visita.confirmada
       
          elsif @seguimiento_visita.solicitud.sub_sector.nemonico=="VE" 

            page.redirect_to :action=>:edit, :controller=> '/visitas/visita_seguimiento_cultivo' ,:id=>@seguimiento_visita.id, :popup=>params[:popup] unless @seguimiento_visita.confirmada

          elsif @seguimiento_visita.solicitud.sub_sector.nemonico=="AC" 

            page.redirect_to :action=>:index, :controller=> '/visitas/condiciones_acuicultura' ,:id=>@seguimiento_visita.id, :popup=>params[:popup] unless @seguimiento_visita.confirmada



          elsif @seguimiento_visita.solicitud.sub_sector.nemonico=="PE" 

            page.redirect_to :action=>:replicar, :controller=> '/visitas/control_visitas_pesca/embarcacion' ,:id=>@seguimiento_visita.id, :popup=>params[:popup] unless @seguimiento_visita.confirmada


          end 


          #anteriormente esta esto page.redirect_to :action=>'index', :id=>@seguimiento_visita.solicitud_id, :popup=>params[:popup]
        end
      else
        render :update do |page|
          page.hide 'messages'
          page.form_error("row_#{@seguimiento_visita.id}")
        end
        return false

      end
      #form_save_edit @seguimiento_visita
    else
      render :update do |page|
        page.hide 'messages'
        page.form_error("row_#{@seguimiento_visita.id}")
      end
      return false
    end
  end

  def cancel_edit
    @seguimiento_visita = SeguimientoVisita.find(params[:id])
    render :update do |page|
      page.form_cancel_edit @seguimiento_visita
      page.<<"window.scroll(0,0);"
    end
  end


  def confirmar
    logger.debug "PARAMS =========> " << params[:id].to_s
    @seguimiento_visita = SeguimientoVisita.find(params[:id])
    logger.debug "Seguimiento Visita =========> " << @seguimiento_visita.inspect
    msg_error=""
    msg = ""
    sucede = true
    if @seguimiento_visita.solicitud.sub_sector.nemonico=="VE"
      total_seguimiento_cultivo = SeguimientoCultivo.count(:all, :conditions=>"seguimiento_visita_id = #{@seguimiento_visita.id}")
      unless total_seguimiento_cultivo > 0
        @seguimiento_visita.errors.add(:seguimiento_visita, I18n.t('Sistema.Body.Controladores.VisitaSeguimiento.Errores.imposible_confirmar_registrar_seguimiento'))
#        msg_error = msg_error << "<LI>#{I18n.t('Sistema.Body.Controladores.VisitaSeguimiento.Errores.imposible_confirmar_registrar_seguimiento')}</LI>"
        sucede = false
      end
      total_descripciones_especificas = DescripcionesEspecificas.count(:all, :conditions=>"seguimiento_visita_id = #{@seguimiento_visita.id}")
      unless total_descripciones_especificas > 0
        @seguimiento_visita.errors.add(:seguimiento_visita, I18n.t('Sistema.Body.Controladores.VisitaSeguimiento.Errores.imposible_confirmar_registrar_descripcion'))
#        msg_error = msg_error << "<LI>#{I18n.t('Sistema.Body.Controladores.VisitaSeguimiento.Errores.imposible_confirmar_registrar_descripcion')}</LI>"
        sucede = false
      end
    elsif @seguimiento_visita.solicitud.sub_sector.nemonico=="AN"
      total_pastizales_potreros = PastizalesPotreros.count(:all, :conditions=>"seguimiento_visita_id = #{@seguimiento_visita.id}")
      unless total_pastizales_potreros > 0
        @seguimiento_visita.errors.add(:seguimiento_visita, I18n.t('Sistema.Body.Controladores.VisitaSeguimiento.Errores.imposible_confirmar_registrar_pastizales'))
        #msg_error = msg_error << "<LI>#{I18n.t('Sistema.Body.Controladores.VisitaSeguimiento.Errores.imposible_confirmar_registrar_pastizales')}</LI>"
        sucede = false
      end
      total_manejo_instalaciones = ManejoInstalaciones.count(:all, :conditions=>"seguimiento_visita_id = #{@seguimiento_visita.id}")
      total_sanidad_animal = SanidadAnimal.count(:all, :conditions=>"seguimiento_visita_id = #{@seguimiento_visita.id}")
      unless (total_manejo_instalaciones > 0 || total_sanidad_animal > 0)
        @seguimiento_visita.errors.add(:seguimiento_visita, I18n.t('Sistema.Body.Controladores.VisitaSeguimiento.Errores.imposible_confirmar_registrar_instalaciones'))
        #msg_error = msg_error << "<LI>#{I18n.t('Sistema.Body.Controladores.VisitaSeguimiento.Errores.imposible_confirmar_registrar_instalaciones')}</LI>"
        sucede = false
      end
      total_semovientes = Semovientes.count(:all, :conditions=>"seguimiento_visita_id = #{@seguimiento_visita.id}")
      unless total_semovientes > 0
        @seguimiento_visita.errors.add(:seguimiento_visita, I18n.t('Sistema.Body.Controladores.VisitaSeguimiento.Errores.imposible_confirmar_registrar_semovientes'))
        #msg_error = msg_error << "<LI>#{I18n.t('Sistema.Body.Controladores.VisitaSeguimiento.Errores.imposible_confirmar_registrar_semovientes')}</LI>"
        sucede = false
      end
      total_produccion_leche_carne = ProduccionLecheCarne.count(:all, :conditions=>"seguimiento_visita_id = #{@seguimiento_visita.id}")
      unless total_produccion_leche_carne > 0
        @seguimiento_visita.errors.add(:seguimiento_visita, I18n.t('Sistema.Body.Controladores.VisitaSeguimiento.Errores.imposible_confirmar_registrar_produccion_leche'))
        #msg_error = msg_error << "<LI>#{I18n.t('Sistema.Body.Controladores.VisitaSeguimiento.Errores.imposible_confirmar_registrar_produccion_leche')}</LI>"
        sucede = false
      end
    elsif @seguimiento_visita.solicitud.sub_sector.nemonico=="AC"
      total_calidad_agua = CalidadAguaAlimento.count(:all, :conditions=>"seguimiento_visita_id = #{@seguimiento_visita.id}")
      unless total_calidad_agua > 0
        @seguimiento_visita.errors.add(:seguimiento_visita, I18n.t('Sistema.Body.Controladores.VisitaSeguimiento.Errores.imposible_confirmar_registrar_calidad_agua'))
        #msg_error = msg_error << "<LI>#{I18n.t('Sistema.Body.Controladores.VisitaSeguimiento.Errores.imposible_confirmar_registrar_calidad_agua')}</LI>"
        sucede = false
      end
      total_condiciones_acuicultura = CondicionesAcuicultura.count(:all, :conditions=>"seguimiento_visita_id = #{@seguimiento_visita.id}")
      unless total_condiciones_acuicultura > 0
        @seguimiento_visita.errors.add(:seguimiento_visita, I18n.t('Sistema.Body.Controladores.VisitaSeguimiento.Errores.imposible_confirmar_registrar_condicion_acuicultura'))
        #msg_error = msg_error << "<LI>#{I18n.t('Sistema.Body.Controladores.VisitaSeguimiento.Errores.imposible_confirmar_registrar_condicion_acuicultura')}</LI>"
        sucede = false
      end
      total_cultivo_laguna = CultivoLaguna.count(:all, :conditions=>"seguimiento_visita_id = #{@seguimiento_visita.id}")
      unless total_cultivo_laguna > 0
        @seguimiento_visita.errors.add(:seguimiento_visita, I18n.t('Sistema.Body.Controladores.VisitaSeguimiento.Errores.imposible_confirmar_registrar_cultivo_laguna'))
        #msg_error = msg_error << "<LI>#{I18n.t('Sistema.Body.Controladores.VisitaSeguimiento.Errores.imposible_confirmar_registrar_cultivo_laguna')}</LI>"
        sucede = false
      end

    end
    logger.info"XXXXXXXXXXXX============VALORES-MSG-ERROR-Y-SUCEDE-==========>>>>>"
    logger.info"XXXXXXXXXXXX============MSG-ERROR==========>>>>>"<<msg_error.inspect
    logger.info"XXXXXXXXXXXX============SUCEDE-==========>>>>>"<<sucede.inspect

    total_decision_visita = DecisionVisita.count(:all, :conditions=>"seguimiento_visita_id = #{@seguimiento_visita.id}")
    decision_visita = DecisionVisita.find_by_seguimiento_visita_id(@seguimiento_visita.id)
    logger.info "Desicion Visita =============> " << decision_visita.inspect
    unless total_decision_visita > 0
      @seguimiento_visita.errors.add(:seguimiento_visita, I18n.t('Sistema.Body.Controladores.VisitaSeguimiento.Errores.imposible_confirmar_registrar_decision'))
      #msg_error = msg_error << "<LI>#{I18n.t('Sistema.Body.Controladores.VisitaSeguimiento.Errores.imposible_confirmar_registrar_decision')}</LI>"
      sucede = false
    else
      if decision_visita.recomienda_generar_desembolso
        total_desembolso = Desembolso.count(:all, :conditions=>"seguimiento_visita_id = #{@seguimiento_visita.id} and realizado = false")
        total_orden_despacho = OrdenDespacho.count(:all, :conditions=>"seguimiento_visita_id = #{@seguimiento_visita.id}")
        unless (total_desembolso > 0 || total_orden_despacho > 0)
          @seguimiento_visita.errors.add(:seguimiento_visita, I18n.t('Sistema.Body.Controladores.VisitaSeguimiento.Errores.imposible_confirmar_registrar_recomendacion'))
          #msg_error = msg_error << "<LI>#{I18n.t('Sistema.Body.Controladores.VisitaSeguimiento.Errores.imposible_confirmar_registrar_recomendacion')}</LI>"
          sucede = false
        end
      end
    end

    logger.info "SUCEDE =====-SEGUNDO-BLOQUE====>****** " << sucede.to_s
    if sucede
      if (decision_visita.recomienda_generar_desembolso && total_desembolso > 0)
        @desembolso = Desembolso.find_by_seguimiento_visita_id(@seguimiento_visita.id)

        success = true
        success &&=@desembolso.confirmar_desembolso(@usuario, @seguimiento_visita)
        if !success
          logger.info"XXXXXXXXX===================ENTRO-SUCCESS================>>>>>"
          render :update do |page|
            page.hide 'mensaje'
            page.replace_html 'errorExplanation',"<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL>" << @desembolso.errors.full_messages.to_s
            page.show 'errorExplanation'
          end
          return false
        else
          msg = " #{I18n.t('Sistema.Body.Controladores.VisitaSeguimiento.Messages.y_el_tramite')}<span style=\"color: #FF0000\">'#{@seguimiento_visita.solicitud.numero}'</span> #{I18n.t('Sistema.Body.Controladores.VisitaSeguimiento.Messages.fue_enviado')}"
        end
      end

      logger.info "PASO POR DECISION VISITA ============> "
      if (decision_visita.recomienda_generar_desembolso && total_orden_despacho > 0)
        @orden_despacho = OrdenDespacho.find_by_seguimiento_visita_id(@seguimiento_visita.id)
#        @orden_despacho.realizado = false
#        @orden_despacho.save
#        msg = msg << ""
        if total_desembolso == 0
          success = true
          success =@orden_despacho.confirmar_solo_insumo(@usuario)
          if !success

            render :update do |page|
              page.hide 'mensaje'
              page.replace_html 'errorExplanation','<h2>Ha ocurrido un error</h2><p><UL>' << @ordenDespacho.errors.full_messages.to_s
              page.show 'errorExplanation'
            end
            return false
          else
            msg = " y el Trámite <span style=\"color: #FF0000\">'#{@seguimiento_visita.solicitud.numero}'</span> fue enviado para la Emisión de la Orden de Despacho"
          end
          
        else
          @orden_despacho = OrdenDespacho.find_by_seguimiento_visita_id(@seguimiento_visita.id)
          @orden_despacho.realizado = false
          @orden_despacho.save
          msg = msg << ""
        end
      end
      success_final = true
      @seguimiento_visita.confirmada = true
      success_final &&=@seguimiento_visita.save
      logger.info "INSPECT SEGUIMIENTO VISITA "<< @seguimiento_visita.inspect
      logger.info "============================"
      logger.info "Errores en Seguimiento " << @seguimiento_visita.errors.to_s

      if !success_final
        render :update do |page|
          page.hide 'mensaje'
          page.replace_html 'errorExplanation',"<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL>" << @seguimiento_visita.errors.full_messages.to_s
          page.show 'errorExplanation'
        end
        return false
      else
        flash[:notice] ="#{I18n.t('Sistema.Body.Controladores.VisitaSeguimiento.Messages.se_confirmo_con_exito')}<span style=\"color: #FF0000\">'#{@seguimiento_visita.codigo_visita}'</span> #{msg}"
        #logger.info "SOLICITUD DEL SEGUIMIENTO VISITA ==========> " << @seguimiento_visita.solicitud_id.to_s
        render :update do |page|
          page.redirect_to :action=>'index', :id=>@seguimiento_visita.solicitud_id, :popup=>params[:popup]
        end
      end
    else
      logger.info "SOLICITUD DEL SEGUIMIENTO VISITA ==========> " << @seguimiento_visita.solicitud_id.to_s
      render :update do |page|
        page.form_error
      end
#      render :update do |page|
#        #page.hide 'mensaje'
#        page.hide 'message'
#        page.replace_html 'errorExplanation',"<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL>" << msg_error
#        page.show 'errorExplanation'
#      end
      return false
    end



  end


  def beneficiario_atendio_tecnico_click
    logger.info "beneficiario_atendio_tecnico 22" << params[:val].to_s << " id " << params[:id].to_s
    if params[:val]=="false"
      # Si el check de beneficiario que atendio al tecnico este marcado como un 'no'
      @es=0
      @info_beneficiario=[]
    else
      # Si el check de beneficiario que atendio al tecnico este marcado como un 'Si'
      cliente = Solicitud.find(params[:id]).cliente_id
      logger.info "CLIENTE =========> " << cliente.to_s
      logger.info "VAL =========> " << params[:val].to_s
      if Cliente.find(cliente).empresa_id.nil?
        # Cliente es una persona natural
        @es=1
        @tipo_cliente="1"
        @info_beneficiario=Persona.find(Cliente.find(cliente).persona_id)
        @telefonos_beneficiario=PersonaTelefono.find(:all,:conditions=>"persona_id=#{@info_beneficiario.id} and fax=false", :limit=>3)
      else
        #Cliente es una empresa
        @tipo_cliente="2"
        empresa_integrante = Solicitud.find(params[:id]).empresa_integrante_id
        logger.info "EMPRESA INTEGRANTE =========> " << empresa_integrante.inspect
        unless empresa_integrante.nil?
          @es=1
          datos_integrante = EmpresaIntegrante.find(empresa_integrante)
          @info_beneficiario=Persona.find(datos_integrante.persona_id)
          logger.info "INFO BENEFICIARIO =========> " << @info_beneficiario.inspect
          @telefonos_beneficiario=PersonaTelefono.find(:all,:conditions=>"persona_id=#{@info_beneficiario.id} and fax=false", :limit=>3)   
        else
          @es=0
          @info_beneficiario=[]
        end
      end
    end
    render :update do |page|
      page.replace_html 'form_beneficiario', :partial => 'beneficiario'
    end
  end





  protected
  def common
    super
    seguimiento = SeguimientoVisita.find_by_solicitud_id(params[:id])
    @solicitudes = Solicitud.find(seguimiento.solicitud_id) unless seguimiento.nil?
    @form_title = I18n.t('Sistema.Body.Controladores.VisitaSeguimiento.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.VisitaSeguimiento.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.VisitaSeguimiento.FormTitles.form_title_records')
    @form_entity = 'seguimiento_visita'
    @form_identity_field = 'codigo_visita'
    @width_layout = '955'
    @full_info = "#{@solicitudes.numero} (#{@solicitudes.nombre})" unless @solicitudes.nil?

  end

  def fill
    @motivo_visita_list = MotivoVisita.find(:all, :conditions=>'id > 1', :order=>'id')
  end
end
