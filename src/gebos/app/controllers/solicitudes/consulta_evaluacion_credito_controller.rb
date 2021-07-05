# encoding: utf-8

#
# autor: Luis Rojas
# clase: Solicitudes::ConsultaEvaluacionCreditoController
# descripción: Migración a Rails 3
#

class Solicitudes::ConsultaEvaluacionCreditoController < FormTabsController

  skip_before_filter :set_charset, :only=>[:printer, :blanco, :confirmar, :avanzar, :ver_observaciones, :cerrar_observaciones]
  
  layout 'form_basic'

  def index

    logger.info "Controller ======> #{@env.inspect}"
    logger.info "request =======> #{request[:ORIGINAL_FULLPATH].inspect}"

    @municipio_list = Municipio.find(:all, :conditions=>['estado_id = ?', @usuario.oficina.ciudad.estado.id], :order=>'nombre')
    @sector_list = Sector.find(:all, :order=>'nombre')
    sector_fill(@sector_list[0].id)
  end

  def printer
    @solicitud = Solicitud.find(params[:solicitud_id])
    @visita = SeguimientoVisita.find(:first, :conditions=>['solicitud_id = ?', @solicitud.id], :order=>'id')
    @tipo_maquinaria = TipoMaquinaria.find(:all, :order=>'nombre')
    render  :layout => 'form_reporte'
  end

  def blanco
    @solicitud = Solicitud.find(params[:solicitud_id])
    @visita = SeguimientoVisita.find(:first, :conditions=>['solicitud_id = ?', @solicitud.id], :order=>'id')
    render  :layout => 'form_reporte'
  end

  def confirmar
    ruta = request.protocol.to_s + request.host.to_s + ":" + request.port.to_s
    resultado = SeguimientoVisita.confirmar(params[:id], ruta)
    if resultado.length > 0
      render :update do |page|
          page.hide 'message'
          page.hide 'error'
          page.replace_html 'errorExplanation','<h2>Ha ocurrido un error</h2><p><UL>' << resultado << '</UL></p>'
          page.show 'errorExplanation'
          page.<< "window.scrollTo(0,0);"
       end
      return
    else
      solicitud = Solicitud.find(params[:id])
      solicitud.confirmacion = true
      #codigo nuevo se le baja la carga de trabajo al tecnico de campo
        @usuariio=Usuario.find_by_nombre_usuario(solicitud.usuario_pre_evaluacion.strip) unless solicitud.usuario_pre_evaluacion.nil?
		#le reducimos la cantidad de carga al tecnico antiguo   
		@el_tecnico=TecnicoCampo.find_by_letra_cedula_and_cedula(@usuariio.cedula_nacionalidad,@usuariio.cedula) unless @usuariio.nil?
    
      if solicitud.sub_sector.nemonico == "MA"
        solicitud_maquinaria = SolicitudMaquinaria.find(:all, :conditions => "estatus = 'I' and solicitud_id = #{solicitud.id}")
        if solicitud_maquinaria.length > 0
          solicitud.estatus_id = 10006
          estatus_id_inicial = 10003
          estatus_id_final = 10006
          ControlSolicitud.create(
            :solicitud_id=>solicitud.id,
            :estatus_id=>estatus_id_final,
            :usuario_id=>@usuario.id,
            :fecha => Time.now,
            :estatus_origen_id => estatus_id_inicial,
            :accion => 'Avanzar')
            solicitud.save
        else
          SolicitudMaquinaria.avanzar(solicitud.id, @usuario)
        end
#        solicitud.save
      end

      unless @el_tecnico.nil?
        if @el_tecnico.carga_trabajo > 0
          @el_tecnico.carga_trabajo=@el_tecnico.carga_trabajo - 1 
          @el_tecnico.save
        end
      end
        #fin codigo nuevo      
      unless solicitud.sub_sector.nemonico == "MA"
        solicitud.save    
      end     
      seguimiento_visita = SeguimientoVisita.find(:first, :conditions=>"solicitud_id = #{solicitud.id}")
      seguimiento_visita.confirmada = true      
      seguimiento_visita.save      
      @solicitud = ViewSolicitudPreEvaluacion.find(:first, :conditions=>['solicitud_id = ?', solicitud.id])
      render :update do |page|
        page.replace_html 'message', "Confirmando informe de recomendación del trámite Nro #{solicitud.numero}."
        page.replace_html "row_#{@solicitud.solicitud_id}", :partial=> 'row_view'
         page.show 'message'
      end
    end
  end

  def avanzar
    ruta = request.protocol.to_s + request.host.to_s + ":" + request.port.to_s
    resultado = SeguimientoVisita.confirmar(params[:id], ruta)
    if resultado.length > 0
      render :update do |page|
          page.hide 'message'
          page.hide 'error'
          page.replace_html 'errorExplanation','<h2>Ha ocurrido un error</h2><p><UL>' << resultado << '</UL></p>'
          page.show 'errorExplanation'
          page.<< "window.scrollTo(0,0);"
       end
      return
    else
      @solicitud = Solicitud.find(params[:id])
          #  Creación del prestamo después de confirmar la visita

      if @solicitud.sub_sector.nemonico != "MA"
        result = PlanInversion.crear_prestamo(@solicitud.id)

        if !result 
          errores = I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Errores.Confirmar.fallo_creacion_prestamo'), @solicitud.numero.to_s
          render :update do |page|
            page.hide 'message'
            page.hide 'error'
            page.replace_html 'errorExplanation','<h2>Ha ocurrido un error</h2><p><UL>' << errores << '</UL></p>'
            page.show 'errorExplanation'
            page.<< "window.scrollTo(0,0);"
          end
          return
        end
      end

      @solicitud = Solicitud.find(params[:id])
      
      if @solicitud.estatus_id == 10003
        resultado = SeguimientoVisita.pidan(@solicitud, @usuario)
        if resultado == true
          estatus = Estatus.find(@solicitud.estatus_id)
          render :update do |page|
            page.remove "row_#{@solicitud.id}"
            page.hide 'error'
            page.replace_html 'message', "La Solicitud Número #{@solicitud.numero} fue Enviada a #{estatus.nombre} con éxito."
            page.show 'message'
          end
        else
          render :update do |page|
            page.hide 'error'
            page.replace_html 'message', "Ocurrio un error interno."
            page.show 'message'
          end
        end
      else
        estatus = Estatus.find(@solicitud.estatus_id)
        render :update do |page|
          page.remove "row_#{@solicitud.id}"
          page.hide 'error'
          page.replace_html 'message', "La Solicitud Número #{@solicitud.numero} fue Enviada a #{estatus.nombre} con éxito."
          page.show 'message'
        end
      end
      return false
    end
  end

  def view_datos_basicos
    @solicitud = Solicitud.find(params[:id])
    @cliente = @solicitud.cliente
  end

  def ver_observaciones
    @solicitud = Solicitud.find(:first, :conditions=>['id = ?', params[:id]])
    render :update do |page|
      page.hide 'error'
      page.replace_html "error_#{params[:id]}", :partial => "observaciones"
      page.show "error_#{params[:id]}"
    end
  end

  def cerrar_observaciones
    render :update do |page|
      page.hide 'error'
      page.hide "error_#{params[:id]}"
    end
  end

  def list


    conditions = "estatus_id = 10003 and usuario_pre_evaluacion = '#{@usuario.nombre_usuario}'"
    params['sort'] = "numero" unless params['sort']

    unless params[:sector_id][0].blank?
      sector_id = params[:sector_id][0].to_s
      sector = Sector.find(sector_id)
      conditions = "#{conditions} and sector_id = #{sector_id} "
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.sector')} #{I18n.t('Sistema.Body.General.es')} #{I18n.t('Sistema.Body.Vistas.General.igual')} '#{sector.nombre}'"
    end
    
    unless params[:sub_sector_id][0].blank?
      sub_sector_id = params[:sub_sector_id][0].to_s
      sub_sector = SubSector.find(sub_sector_id)
      conditions = "#{conditions} and sub_sector_id = #{sub_sector_id} "
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.sub_sector')} #{I18n.t('Sistema.Body.General.es')} #{I18n.t('Sistema.Body.Vistas.General.igual')} '#{sub_sector.nombre}'"
    end

    unless params[:rubro_id][0].blank?
      rubro_id = params[:rubro_id][0].to_s
      rubro = Rubro.find(rubro_id)
      conditions = "#{conditions} and rubro_id = " + rubro_id
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.rubro')} #{I18n.t('Sistema.Body.General.es')} #{I18n.t('Sistema.Body.Vistas.General.igual')} '#{rubro.nombre}'"
    end
    
    unless params[:sub_rubro_id][0].blank?
      sub_rubro_id = params[:sub_rubro_id][0].to_s
      sub_rubro = SubRubro.find(sub_rubro_id)
      conditions << " and sub_rubro_id = " + sub_rubro_id
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.sub_rubro')} #{I18n.t('Sistema.Body.General.es')} #{I18n.t('Sistema.Body.Vistas.General.igual')} '#{sub_rubro.nombre}'"
    end
    
    unless params[:actividad_id][0].blank?
      actividad_id = params[:actividad_id][0].to_s
      actividad = Actividad.find(actividad_id)
      conditions << " and actividad_id = " + actividad_id
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.actividad')} #{I18n.t('Sistema.Body.General.es')} #{I18n.t('Sistema.Body.Vistas.General.igual')} '#{actividad.nombre}'"
    end
    
    unless params[:municipio_id][0].blank?
      conditions = "#{conditions} and municipio_id = #{params[:municipio_id][0]}"
      municipio = Municipio.find(params[:municipio_id][0])
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.municipio')} #{I18n.t('Sistema.Body.General.es')} #{I18n.t('Sistema.Body.Vistas.General.igual')} '#{municipio.nombre}'"
    end
    
    unless params[:identificacion].blank?
      conditions = "#{conditions} AND lower(cedula_rif) = lower('#{params[:tipo]+params[:identificacion]}')"
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.cedula')} / #{I18n.t('Sistema.Body.Vistas.General.rif')} #{I18n.t('Sistema.Body.Vistas.General.igual')} '#{params[:identificacion]}'"
    end
    
    unless params[:numero].blank?
      conditions = "#{conditions} AND (numero =  #{params[:numero].to_i})"
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.nro')} #{I18n.t('Sistema.Body.Vistas.General.solicitud')} #{I18n.t('Sistema.Body.Vistas.General.igual')} '#{params[:numero]}'"
    end
    
    unless params[:nombre].blank?
      conditions = "#{conditions} AND LOWER(nombre) LIKE  '%#{params[:nombre].strip.downcase}%'"
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Vistas.General.del')} #{I18n.t('Sistema.Body.General.beneficiario')} #{I18n.t('Sistema.Body.Vistas.General.contenga')} '#{params[:nombre]}'"
    end
    
    unless @usuario.super_usuario
      conditions << " and usuario_pre_evaluacion = '#{@usuario.nombre_usuario}'"
    end
    
    logger.debug "---------------------------------------------------------------"
    logger.debug conditions

    
    @list = ViewSolicitudPreEvaluacion.search(conditions, params[:page], params['sort'])
    @total=@list.count

#    condicion_rol = " usuario_rol.rol_id = 7 "
#    @aux_roles = @usuario.roles.find(:first, :conditions=>condicion_rol)
    
    form_list
  end
	
  protected
  def common
    super
    @form_title = "#{I18n.t('Sistema.Body.Vistas.General.solicitudes')} #{I18n.t('Sistema.Body.Vistas.General.a')} #{I18n.t('Sistema.Body.Vistas.General.inspeccionar')} #{I18n.t('Sistema.Body.Vistas.General.por')} #{I18n.t('Sistema.Body.General.el').downcase} #{I18n.t('Sistema.Body.Controladores.TecnicoCampo.FormTitles.form_title_record')}"
    @form_title_record = I18n.t('Sistema.Body.Vistas.General.solicitudes')
    @form_title_records = I18n.t('Sistema.Body.Vistas.General.solicitudes')
    @form_entity = 'consulta_solicitud'
    @form_identity_field = 'numero'
    @width_layout = '1200'
  end

  private
  def sector_fill(sector_id)
    @sector_list = Sector.find(:all, :order=>'nombre')
    if sector_id > 0
        sub_sector_fill(@sector_list[0].id)
    else
      sub_sector_fill(0)
    end
  end

  def sub_sector_fill(sector_id)
    if sector_id.to_s.length > 0
      @sub_sector_list = SubSector.find(:all, :conditions=>['sector_id = ?', sector_id], :order=>'nombre')
      rubro_fill(0)
    else
      @sub_sector_list = SubSector.find(:all, :conditions=>['sector_id = ?', 0], :order=>'nombre')
      rubro_fill(0)
    end
  end

  def rubro_fill(sub_sector_id)
    @rubro_list = Rubro.find(:all, :conditions=>['sub_sector_id = ? and activo = true', sub_sector_id], :order=>'nombre')
  end
  
end
