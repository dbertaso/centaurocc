# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Cobranzas::HistoricoCobranzasController
# descripción:Desarrollado Rails 3
#


class Cobranzas::HistoricoCobranzasController < FormTabsController
  skip_before_filter :set_charset, :only=>[:expand, :colapsar]
  
  layout 'form_basic'
  
  def index
    list
  end

  def list

    conditions = ''
    params[:sort] = "prestamo.numero" unless params['sort']
    condition = 'prestamo.id in (select prestamo_id from gestion_cobranzas group by prestamo_id having count(prestamo_id) > 0)'

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

    unless params[:numero].nil? || params[:numero].to_i <= 0

      conditions += [" numero_prestamo = ?", params[:numero]]
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.numero_tramite')} '#{params[:numero]}'"

    end

    sql = "(SELECT prestamo.solicitud_id, prestamo.id, prestamo.numero as numero_prestamo, "
    sql += "       CASE WHEN empresa.rif IS NULL "
    sql += "            THEN cedula_nacionalidad || ' ' || cedula::character varying "
    sql += "            ELSE empresa.rif "
    sql += "       END::character varying as identificacion, "
    sql += "       CASE WHEN empresa.nombre IS NULL "
    sql += "            THEN (CASE WHEN primer_nombre IS NULL THEN '' ELSE primer_nombre END) || ' ' || (CASE WHEN primer_apellido IS NULL THEN '' ELSE primer_apellido END) "
    sql += "            ELSE empresa.nombre "
    sql += "       END as nombre_cliente, "
    sql += "prestamo.fecha_liquidacion as fecha "
    sql += " FROM prestamo "
    sql += "INNER JOIN cliente ON prestamo.cliente_id = cliente.id "
    sql += "LEFT JOIN persona ON cliente.persona_id = persona.id "
    sql += "LEFT JOIN empresa ON cliente.empresa_id = empresa.id "
    sql += "  #{condition}) as prestamo_helper"

    join = "INNER JOIN #{sql} ON prestamo.id = prestamo_helper.id "
    join += "INNER JOIN moneda ON (prestamo.moneda_id = moneda.id)"

    inc_tablas = [:prestamo, :moneda, :tipo_gestion_cobranza, :analista_cobranza, :usuario]

    seleccion = 'prestamo.deuda, prestamo_helper.id, prestamo_helper.numero_prestamo, '
    seleccion += 'prestamo_helper.identificacion, prestamo_helper.nombre_cliente, '
    seleccion += 'moneda.nombre as moneda_nombre, moneda.abreviatura as moneda_abreviatura '

    @list = Prestamo.search(conditions, params[:page], params[:sort], join, seleccion)
    logger.info "List =======> #{@list.inspect}"
    @total = @list.count

    form_list

  end

  def consultar
  
    @prestamo = Prestamo.find(params[:id])
    @origen = params[:origen]

    unless @prestamo.nil?
      @gestion_cobranzas = GestionCobranzas.where("prestamo_id = ? ", params[:id]).order("fecha_confirmacion desc, hora_confirmacion desc")
      @gestion_telecobranzas = GestionCobranzas.find_by_sql("select * from gestion_cobranzas where prestamo_id = #{params[:id].to_s} and tipo_gestion_cobranza_id = 3")
      @gestion_sms = GestionCobranzas.find_by_sql("select * from gestion_cobranzas where prestamo_id = #{params[:id].to_s} and tipo_gestion_cobranza_id = 2")
      @gestion_email = GestionCobranzas.find_by_sql("select * from gestion_cobranzas where prestamo_id = #{params[:id].to_s} and tipo_gestion_cobranza_id = 1")
    end
    
  end
  
  def expand
  
    @gestion = GestionCobranzas.find(params[:gestion_id])

    unless @gestion.nil?

      @prestamo = Prestamo.find(@gestion.prestamo_id)
    
      @cliente = Cliente.find(@prestamo.cliente_id)

      @performance = PerformanceCobranzas.find_by_prestamo_id_and_cliente_id(@prestamo.id, @cliente.id)

      if @cliente.class.to_s == 'ClienteEmpresa'

        @telefonos = EmpresaTelefono.find_by_empresa_id(@cliente.empresa_id)
        @correos = EmpresaEmail.find_by_empresa_id(@cliente.empresa_id)
      else
        @telefonos = PersonaTelefono.all(:conditions=>"persona_id = #{@cliente.persona_id.to_s}")
        @correos = PersonaEmail.all(:conditions=>"persona_id = #{@cliente.persona_id.to_s}")

        logger.info "Telefonos Modelo =======>  #{@telefonos.inspect}"
      end

      if @gestion.tipo_gestion_cobranza_id == 3
        @telecobranzas = Telecobranzas.find_by_gestion_cobranzas_id(@gestion.id)

        if @cliente.class.to_s == 'ClienteEmpresa'
          @telefono = EmpresaTelefono.find(@telecobranzas.telefono_id)
          @direccion = EmpresaDireccion.find(@telecobranzas.direccion_id)
        else
          @telefono = PersonaTelefono.find(@telecobranzas.telefono_id)
          @direccion = PersonaDireccion.find(@telecobranzas.direccion_id)
        end

        if @telecobranzas.senal_compromiso
          @compromiso = CompromisoPago.find_by_telecobranzas_id_and_prestamo_id(@telecobranzas.id, @prestamo.id)
        end
      end
    
      render :update do |page|
        page.form_reset
        page.hide "row_#{@gestion.id}"
        page.insert_html :after, "row_#{@gestion.id}", :partial => 'detalle_gestion'
        page.visual_effect :highlight, "row_#{@gestion.id}_view", :duration => 0.6
      end
    end
    
  end
  
  #Funcionalidad para el método collapse de los controladores
  #Este método contrae una fila de una tabla con AJAX
  def colapsar
    
    render :update do |page|
      page.form_reset
      page.remove "row_#{params[:gestion_id]}_view"
      page.show "row_#{params[:gestion_id]}"
      page.visual_effect :highlight, "row_#{params[:gestion_id]}", :duration => 0.6
    end
  end 
   
  def telecobranzas
  end
  
  def sms
  end
  
  def email
  end
  
  protected
  def common
   super
    @form_title = I18n.t('Sistema.Body.Controladores.HistoricoCobranzas.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.HistoricoCobranzas.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.HistoricoCobranzas.FormTitles.form_title_records')
    @form_title_search = I18n.t('Sistema.Body.Controladores.HistoricoCobranzas.FormTitles.form_title')
    @form_entity = 'gestion_cobranzas'
    @form_identity_field = 'prestamo_id'
    @width_layout=1100;
  end 
end
