# encoding: utf-8
class Visitas::VisitaSolicitudController < FormTabsController

  layout 'form_basic'
  
  skip_before_filter :set_charset, :only=>[:tabs]

  def index
    @municipio_list = Municipio.find(:all, :conditions=>['estado_id = ?', @usuario.oficina.ciudad.estado.id])
  end

  def printer
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
        page.replace_html 'errorExplanation',"<h2> #{I18n.t('Sistema.Body.General.ocurrio_error')} </h2><p><UL>" << resultado << '</UL></p>'
        page.show 'errorExplanation'
        page.<< "window.scrollTo(0,0);"
      end
      return
    else
      solicitud = Solicitud.find(params[:id])
      solicitud.confirmacion = true
      solicitud.save
      flash[:notice] = "#{I18n.t('Sistema.Body.Controladores.VisitaSolicitud.Messages.la_solicitud_numero')} #{solicitud.numero} #{I18n.t('Sistema.Body.Controladores.VisitaSolicitud.Messages.se_confirmo_con_exito')}"
      render :update do |page|
        page.redirect_to :action => "index"
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
        page.replace_html 'errorExplanation',"<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL>" << resultado << '</UL></p>'
        page.show 'errorExplanation'
        page.<< "window.scrollTo(0,0);"
      end
      return
    else
      @solicitud = Solicitud.find(params[:id])
      resultado = SeguimientoVisita.pidan(@solicitud, @usuario)
      if resultado == true
        estatus = Estatus.find(@solicitud.estatus_id)
        render :update do |page|
          page.remove "row_#{@solicitud.id}"
          page.hide 'error'
          page.replace_html 'message', "#{I18n.t('Sistema.Body.Controladores.VisitaSolicitud.Messages.la_solicitud_numero')} #{@solicitud.numero} #{I18n.t('Sistema.Body.Controladores.VisitaSolicitud.Messages.fue_enviada')} #{estatus.nombre} #{I18n.t('Sistema.Body.Controladores.ConsultarTransaccion.Etiquetas.con_exito')}"
          page.show 'message'
        end
      else
        render :update do |page|
          page.hide 'error'
          page.replace_html 'message', I18n.t('Sistema.Body.General.ocurrio_error')
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

  def list
    @condition ="estatus_id in (10100, 10110)  "
    @condition << " and usuario_pre_evaluacion = '#{@usuario.nombre_usuario}'"

    conditions = @condition
    params['sort'] = "numero" unless params['sort']
    
    if params[:municipio_id][0].to_s.length > 0
      conditions = "#{conditions} and municipio_id = #{params[:municipio_id][0]}"
      municipio = Municipio.find(params[:municipio_id][0])
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.municipio')} #{I18n.t('Sistema.Body.Vistas.General.igual')} '#{municipio.nombre}'"
    end
    
    unless params[:identificacion].nil? ||  params[:identificacion].empty?
      conditions = "#{conditions} AND lower(cedula_rif) = lower('#{params[:tipo]+params[:identificacion]}')"
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.VisitaSolicitud.Etiquetas.cedula_rif')} #{I18n.t('Sistema.Body.Vistas.General.igual')} '#{params[:tipo]+params[:identificacion]}'"
    end
    
    unless params[:numero].nil? || params[:numero].empty?
      conditions = "#{conditions} AND (numero =  #{params[:numero].to_i})"
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.numero')} #{I18n.t('Sistema.Body.Vistas.General.igual')} '#{params[:numero]}'"
    end
    
    unless params[:nombre].nil? || params[:nombre].empty?
      conditions = "#{conditions} AND LOWER(nombre) LIKE  '%#{params[:nombre].strip.downcase}%'"
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.nombre_apellido')} '#{params[:nombre]}'"
    end
    
    unless @usuario.super_usuario
      conditions << " and usuario_pre_evaluacion = '#{@usuario.nombre_usuario}'"
    end

    
    @list = ViewSolicitudPreEvaluacion.search(conditions, params[:page], params[:sort])
    @total=@list.count

    condicion_rol = " usuario_rol.rol_id = 7 "
    @aux_roles = @usuario.roles.find(:first, :conditions=>condicion_rol)
    form_list
  end
	

  #impresion de las planillas

  def imprimir_sector
    #aqui guardo todos los datos que necesito para imprimirlos en las variable
    @form_title=''
    # @seguimientos = SeguimientoVisita.find(:all,:conditions => ['id = ?', params[:id]])
    @es_no=1
    @solicitudes = Solicitud.find(params[:id])

    @prestamos=Prestamo.find(:all,:conditions => ['solicitud_id = ? ', @solicitudes.id])
    @seguimientos = SeguimientoVisita.find(:all,:conditions => ['solicitud_id = ?', @solicitudes.id])  
    @unidad_produccion=UnidadProduccion.find(@solicitudes.unidad_produccion_id)    

    #ojo esto solo se usa para calcular montos en la seccion de financiamiento caso animal
    @desembolso_totales_segun_nro_tramite=Desembolso.find(:all,:conditions=>"solicitud_id = #{@solicitudes.id}",:order=>:id)

    @sumado_montos_desembolso=0.0
    unless @desembolso_totales_segun_nro_tramite.empty?      
      @desembolso_totales_segun_nro_tramite.each{ |des|

        @seguimientos.each { |segui|
          if des.seguimiento_visita_id == segui.id   
            @sumado_montos_desembolso+=des.monto

          end 
        }  
      }
    end  
    @orden_despacho_totales_segun_nro_tramite=OrdenDespacho.find(:all,:conditions=>"solicitud_id = #{@solicitudes.id}",:order=>:id)

    @sumado_montos_orden=0.0
    unless @orden_despacho_totales_segun_nro_tramite.empty?
      @orden_despacho_totales_segun_nro_tramite.each{ |ord|

        @seguimientos.each { |segui|
          if ord.seguimiento_visita_id == segui.id   
            @sumado_montos_orden+=ord.monto

          end 
        }  

      }
    end
    
    if !@solicitudes.cliente.persona_id.nil?
      @es_no=1    
      @datos_cliente=Persona.find(@solicitudes.cliente.persona_id)    

    else
      @es_no=2    
      @datos_cliente=Empresa.find(@solicitudes.cliente.empresa_id)
      @empresa_integrante = EmpresaIntegrante.find(:all, :conditions=> "empresa_id = #{@datos_cliente.id}")
      @empresa_unidad_produccion = Empresa.find(@unidad_produccion.cliente.empresa_id)    
      unless @empresa_integrante.empty?
        condi="("
        @empresa_integrante.each{ |empresa|

          condi+=empresa.id.to_s << "," 
        }
        condi=condi[0,condi.length-1]      
        condi+=")"    
        @empresa_integrante_tipo = EmpresaIntegranteTipo.find(:first, :conditions=> "empresa_integrante_id in #{condi} and tipo = 'R'")
        @datos_empresa=EmpresaIntegrante.find(@empresa_integrante_tipo.empresa_integrante_id).persona   
        @conppa=UnidadProduccion.find(:first,:conditions=>"cliente_id = #{@empresa_unidad_produccion.cliente_empresa.id}")
      else
        @empresa_integrante=[]
        @datos_empresa=[]
      end    
    end

    
    @sect=Sector.find(@solicitudes.sector_id)

    case params[:tipo]
    when "VE"
      @vista = 'view_planilla_vegetal_forestal'    
    when "AN"
      @vista = 'view_planilla_animal'    
    when "AC"
      @vista = 'view_planilla_acuicola'    
    when "PE"
      @vista = 'view_planilla_pesca'    
    else 
      @maquinarias=UnidadProduccionMaquinaria.find_all_by_seguimiento_visita_id(@seguimientos[0].id)
      @tipo_maquinaria = TipoMaquinaria.find(:all, :order=>'nombre')
      @vista = 'view_planilla_maquinaria'
    end    
 end

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.VisitaSolicitud.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Modelos.Errores.tramites')
    @form_title_records = I18n.t('Sistema.Body.Modelos.Errores.tramites')
    @form_entity = 'consulta_solicitud'
    @form_identity_field = 'numero'
    @width_layout = '1200'
  end 
  
end
