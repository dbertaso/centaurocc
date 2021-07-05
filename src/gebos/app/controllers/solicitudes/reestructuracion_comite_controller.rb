# encoding: utf-8

class Solicitudes::ReestructuracionComiteController < FormTabsController
  
  skip_before_filter :set_charset, 
  :only=>[:tabs, :print_propuesta, :print_contrato, :imprimir_documento, :reestructurar_deuda, :generar_prestamo, 
  :show_hide_elementos, :sector_change, :sub_sector_change, :rubro_change, :sub_rubro_change, :programa_change, :entidad_change]


 layout 'form_basic'

  def index
    @estado = Estado.find(:all, :order => 'nombre')
    @sector = Sector.find(:all, :conditions => 'activo=true', :order => 'nombre')
    sector_fill(0)
    @estatus = Estatus.find(:all, :order => 'nombre')
  end
  
  def edit 
    capital =  0.00
    @interes_diferido = 0.00
    @interes_ordinarios = 0.00
    @interes_moratorio = 0.00
    @causado_no_devengado = 0.00
    @deuda = 0.00
    @saldo_insoluto = 0.00
    @formula_select = Formula.find(:all, :order=>'id')
    @reestructuracion_detalle = ReestructuracionDetalle.find(:all, :conditions=>"reestructuracion_id = #{params[:reestructuracion_id]}")    
    @cliente = Cliente.find(@reestructuracion_detalle[0].reestructuracion.cliente_id)
    
    solicitudes = ''
    @reestructuracion_detalle.each do |reestructuracion_detalle|
      solicitudes == '' ? solicitudes = reestructuracion_detalle.solicitud_origen_id.to_s : solicitudes = solicitudes << "," << reestructuracion_detalle.solicitud_origen_id.to_s
    end  
    @prestamos = Prestamo.find(:all, :conditions=>[" solicitud_id in (#{solicitudes})"])
    logger.info"XXXXXXXXXXXXXXXXXXX-PRESTAMOS-XXXXXXXXXXXXXX"<<@prestamos.inspect
    @ids = ''
    
    #creacion de la nueva solicitud
    @solicitud = Solicitud.new
    #@solicitud.por_inventario = true
    logger.info"XXXXXXX-SESSION-===========>>>>"<<session[:oficina].inspect
    @solicitud.oficina_id = session[:oficina].to_i
    @solicitud.cliente_id = @cliente.id
    @solicitud.sector_id = nil
    
    @tipo_iniciativa_select = TipoIniciativa.find(:all, :order=>'nombre')
    fill()
    programa_fill(nil)
    sector_fill(0)
    logger.info"XXXXXXXXX-PROGRAMA-======>>>>>"<<@programa[0].id.inspect
    modalidad_financiamiento_fill(@programa[0].id)
    @modalidad_select = ModalidadFinanciamiento.find(:all, :conditions=>['id in (select modalidad_financiamiento_id from programa_modalidad_financiamiento where programa_id = ?)', @programa[0].id])
    @sector = Sector.find(:all, :conditions => 'activo=true', :order => 'nombre')
    sector_fill(0)
    if @cliente.class.to_s=='ClienteEmpresa'
      @integrante_list = EmpresaIntegrante.find(:all, :conditions=>['empresa_id in (select empresa_id from cliente where id = ?)', @cliente.id])
    end
  end
  
  
  def view
      solicitudes = ""
      capital =  0.00
      @interes_diferido = 0.00
      @interes_ordinarios = 0.00
      @interes_moratorio = 0.00
      @causado_no_devengado = 0.00
      @deuda = 0.00
      @saldo_insoluto = 0.00

      
       @ids = ""
     @reestructuracion = Reestructuracion.find(params[:reestructuracion_id])
     @solicitud = Reestructuracion.find(params[:reestructuracion_id])
     @cliente = Cliente.find(@reestructuracion.cliente_id)
     @reestructuracion_detalle = ReestructuracionDetalle.find(:all, :conditions=>"reestructuracion_id = #{params[:reestructuracion_id]}")
     @reestructuracion_detalle.each do |reestructuracion_detalle|
        solicitudes == '' ? solicitudes = reestructuracion_detalle.solicitud_origen_id.to_s : solicitudes = solicitudes << "," << reestructuracion_detalle.solicitud_origen_id.to_s
     end  
     @prestamos = Prestamo.find(:all, :conditions=>[" solicitud_id in (#{solicitudes})"])
  end  
  
  
  def print_propuesta
    @listado_prestamos = ""
    @listado_prestamos2 = ""
    @listado_rubros = ""
    @monto_negociacion = 0.00
    @cantidad_prestamos = 0
    @anio_solicitudes = ""
    @bancos_solicitudes = ""
    @prestamos = []  
    
    @reestructuracion = Reestructuracion.find(params[:reestructuracion_id])
    @reestructuracion_detalle = ReestructuracionDetalle.find(:all, :conditions=>"reestructuracion_id = #{params[:reestructuracion_id]}")
    @cliente = Cliente.find(@reestructuracion.cliente_id)
    @reestructuracion_detalle.each do |detalle|
      prestamo = Prestamo.find(:first, :conditions=>"solicitud_id = #{detalle.solicitud_origen_id}")
      @prestamos << prestamo
    end
    
    if @reestructuracion.estatus == 3
      @reestructuracion.fecha_impresion_propuesta = Time.now
      @reestructuracion.estatus = 4
    end
    imprimir = @reestructuracion.save()
    
    if imprimir == true
      if @cliente.type.to_s == 'ClienteEmpresa'
        @registro_mercantil = RegistroMercantil.find(:first, :conditions=>"empresa_id = #{@cliente.empresa_id}" ,:order=>" id desc")
        mes = @registro_mercantil.fecha_registro.to_s.split('-')[1]
        if mes == "01" ; mes_letras = 'Enero' end
        if mes == "02" ; mes_letras = 'Febrero' end
        if mes == "03" ; mes_letras = 'Marzo' end
        if mes == "04" ; mes_letras = 'Abril' end
        if mes == "05" ; mes_letras = 'Mayo' end
        if mes == "06" ; mes_letras = 'Junio' end
        if mes == "07" ; mes_letras = 'Julio' end
        if mes == "08" ; mes_letras = 'Agosto' end
        if mes == "09" ; mes_letras = 'Septiembre' end
        if mes == "10" ; mes_letras = 'Octubre' end
        if mes == "11" ; mes_letras = 'Noviembre' end
        if mes == "12" ; mes_letras = 'Diciembre' end
        @fecha_registro = @registro_mercantil.fecha_registro.to_s.split('-')[2] << " #{I18n.t('Sistema.Body.Vistas.General.de')} " << mes_letras << " #{I18n.t('Sistema.Body.Vistas.Reestructuracion.Etiquetas.del_anio')} " <<  @registro_mercantil.fecha_registro.to_s.split('-')[0]
      end
    
     
      @prestamos.each do |prestamo|
         @listado_prestamos == "" ? @listado_prestamos = prestamo.numero.to_s : @listado_prestamos = @listado_prestamos << ",<br>" << prestamo.numero.to_s 
         @listado_prestamos2 == "" ? @listado_prestamos2 = prestamo.numero.to_s : @listado_prestamos2 = @listado_prestamos2 << ", " << prestamo.numero.to_s 
         @listado_rubros == "" ? @listado_rubros = prestamo.solicitud.rubro.nombre.to_s : @listado_rubros = @listado_rubros << ", " << prestamo.solicitud.rubro.nombre.to_s 
      
        anio = prestamo.solicitud.fecha_aprobacion.to_s.split('-')[0]
        if @anio_solicitudes.index(anio) == nil
          @anio_solicitudes == "" ? @anio_solicitudes << anio : @anio_solicitudes << ", " << anio
        end
        
        banco = prestamo.banco_origen
        if @bancos_solicitudes.index(banco) == nil
          @bancos_solicitudes == "" ? @bancos_solicitudes << banco : @bancos_solicitudes << ", " << banco 
        end
      
        if @bancos_solicitudes.rindex(',') != nil ; @bancos_solicitudes[@bancos_solicitudes.rindex(',')] = ' y' end
      
        @monto_negociacion = @monto_negociacion + prestamo.deuda
        @cantidad_prestamos =  @cantidad_prestamos + 1
      end
      render  :layout => 'form_reporte'
    end
  end
  
  def print_contrato
   #GENERACION DE CONTRATO

    solic = Reestructuracion.find(params[:reestructuracion_id]).solicitud_id
    numero_sol = Solicitud.find(solic).numero

    plantilla = Plantilla.find_by_id(50)    
    if plantilla.nil?
       render :update do |page|
         page.alert I18n.t('Sistema.Body.Vistas.SolicitudConsultoriaJuridica.Mensajes.no_existe_planilla')
       end
      return
    end

    @ruta = request.protocol + request.host.to_s + ":" + request.port.to_s

  
    @contrato = plantilla.complementar(solic,session[:oficina].id,@ruta)

    unless @contrato["ERROR:"].nil?
         render :update do |page|
           page.alert @contrato
         end
        return
    else
       contrato = imprimir_documento(@contrato, "contrato_reestructura_" + numero_sol.to_s + "_" + Time.now.strftime("#{I18n.t('time.formats.gebos_inverted3')}").to_s, "contratos") 
	#render :partial => 'print_contrato'
        #render :update do |page|
        #page.replace_html 'content', :partial => 'print_contrato'
        #page.show 'content'
        #end
    end
	render :layout => 'form_reporte'
  end
  
   def imprimir_documento(texto_plantilla,nombre_doc,carpeta)

      #GUARDAR EL TEXTO HTML EN UN DOCUMENTO .HTML PARA SER CONVERTIDO EN PDF
      generate_html(texto_plantilla,nombre_doc)

      @parametro_general = ParametroGeneral.find(1)

      cadena = "htmldoc -t pdf -f \"public/#{carpeta}/#{nombre_doc}.pdf\" --webpage --no-title --linkstyle underline --footer '...' --size Legal --left #{@parametro_general.margen_izquierdo.to_s + "cm"} --right #{@parametro_general.margen_derecho.to_s + "cm"} --top #{@parametro_general.margen_superior.to_s + "cm"} --bottom #{@parametro_general.margen_inferior.to_s + "cm"} --fontsize #{@parametro_general.tamano_fuente.to_s} --fontspacing #{@parametro_general.interlineado.to_s} --portrait --color --no-pscommands --no-xrxcomments --compression=1 --textfont Courier --charset utf-8 --links --embedfonts --pagemode document --pagelayout single --firstpage p1 --no-encryption --permissions all --no-strict --no-overflow  " << request.protocol << request.host.to_s << ":" << request.port.to_s << "/html_pdf/#{nombre_doc}.html"
      IO.popen(cadena)
      @ruta = request.protocol + request.host.to_s + ":" + request.port.to_s
      @archivo = @ruta << "/#{carpeta}/#{nombre_doc}.pdf"
      
   end

  def generate_html(texto,nombre_doc)

    path_to_file = Rails.root.join('public','html_pdf', '#{nombre_doc}.html')
    File.open("#{path_to_file}", 'w+') do |f1|
      f1.puts Iconv.iconv("ISO-8859-1", "utf-8", texto)
    end

  end

  def entidad_change
  
    logger.info "Parametros ==========> #{params.inspect}"
    @cuenta_bcv_select = CuentaBcv.all(:select=> 'id, case when tipo = \'A\' then \'Ahorro-\' else \'Corriente-\' end || numero as numero_cuenta', :order=>'numero_cuenta', :conditions=>"recaudador = true and activo = true and entidad_financiera_id = #{params[:entidad]}")
    logger.info "Cuentas ========> #{@cuenta_bcv_select[0].numero_cuenta}"
    render :update do |page|
      page.replace_html "cuentas_recaudadoras", :partial => "cuenta_recaudadora"
    end
  
  end

  def reestructurar_deuda

      reestructuracion = Reestructuracion.find(params[:reestructuracion_id])
      
      logger.info "Params =======> #{params.inspect}"
      
      @validacion = reestructuracion.validar_reestructuración(params) unless params.nil?
      #@validacion = false
      
      if  @validacion == true
        @interes_diferido = 0.00.to_d
        @interes_ordinarios = 0.00.to_d
        @interes_moratorio = 0.00.to_d
        @causado_no_devengado = 0.00.to_d
        @deuda = 0.00.to_d
        @saldo_insoluto = 0.00.to_d
        @monto_reestructurado = 0.00.to_d

      
        reestructuracion_detalle = ReestructuracionDetalle.find(:all, :conditions=>"reestructuracion_id = #{reestructuracion.id}")
        reestructuracion_detalle.each do |detalle|
          prestamo_origen = Prestamo.find_by_solicitud_id(detalle.solicitud_origen_id)

          @interes_diferido = @interes_diferido + prestamo_origen.interes_diferido_vencido + prestamo_origen.interes_diferido_por_vencer
    			@interes_ordinarios = @interes_ordinarios + prestamo_origen.interes_vencido
    			@interes_moratorio = @interes_moratorio + prestamo_origen.monto_mora
    			@causado_no_devengado = @causado_no_devengado + prestamo_origen.causado_no_devengado
    			@deuda = @deuda + prestamo_origen.deuda
    			@saldo_insoluto = @saldo_insoluto + prestamo_origen.saldo_insoluto

        end
        
        @monto_reestructurado = @deuda
        unless params[:intereses_moratorios_check].nil? ; @monto_reestructurado = @monto_reestructurado - @interes_moratorio end
        #unless params[:reestructuracion][:monto_abono].nil? : @monto_reestructurado = @monto_reestructurado - params[:reestructuracion][:monto_abono].to_f end
        
        if params[:check_abono] == "true"
          fecha_abono = params[:reestructuracion][:fecha_abono].to_s
          fecha_abono = fecha_abono.split("/")
          reestructuracion.fecha_abono = fecha_abono[2] << "-" << fecha_abono[1] << "-" << fecha_abono[0]
          monto_abono = params[:reestructuracion][:monto_abono]
          referencia = params[:reestructuracion][:referencia_abono]
        else
          monto_abono = 0.00
          referencia = nil
          fecha_abono = nil
        end

        reestructuracion.estatus = 3
        #reestructuracion.solicitud_id = @solicitud.id
        reestructuracion.fecha_aprobacion_comite = Time.now
        reestructuracion.referencia_abono = referencia
        reestructuracion.monto_abono = monto_abono
        reestructuracion.interes_diferido = @interes_diferido
        reestructuracion.interes_ordinarios = @interes_ordinarios
        reestructuracion.interes_moratorio = @interes_moratorio
        reestructuracion.interes_causado_no_devengado = @causado_no_devengado
        reestructuracion.exonerado_interes_diferido = params[:intereses_diferidos_check]
        reestructuracion.exonerado_interes_ordinarios = params[:intereses_ordinarios_check]
        reestructuracion.exonerado_interes_moratorio = params[:intereses_moratorios_check]
        reestructuracion.exonerado_interes_causado_no_devengado = params[:intereses_causados_check]
        reestructuracion.deuda =  @deuda
        reestructuracion.saldo_insoluto = @saldo_insoluto
        reestructuracion.monto_reestructurado = @monto_reestructurado
        reestructuracion.fecha_valor_f = params[:reestructuracion][:fecha_valor_f]
        reestructuracion.formula_id = params[:reestructuracion][:formula_id]
        reestructuracion.frecuencia = params[:reestructuracion][:frecuencia]
        reestructuracion.plazo = params[:reestructuracion][:plazo]
        reestructuracion.tasa = params[:reestructuracion][:tasa]
        reestructuracion.entidad_financiera_id = params[:reestructuracion][:entidad_financiera_id]
        reestructuracion.programa_id = params[:solicitud][:programa_id]
        reestructuracion.origen_fondo_id = params[:solicitud][:origen_fondo_id]
        reestructuracion.unidad_produccion_id = params[:solicitud][:unidad_produccion_id]
        reestructuracion.modalidad_financiamiento_id = params[:solicitud][:modalidad_financiamiento_id]
        reestructuracion.objetivo_proyecto = params[:solicitud][:objetivo_proyecto]
        reestructuracion.sector_id = params[:solicitud][:sector_id]
        reestructuracion.sub_sector_id = params[:sub_sector_id]
        reestructuracion.rubro_id = params[:rubro_id]
        reestructuracion.sub_rubro_id = params[:sub_rubro_id]
        reestructuracion.actividad_id = params[:solicitud][:actividad_id]
        reestructuracion.hectareas_solicitadas = params[:solicitud][:hectareas_solicitadas]
        reestructuracion.semovientes_solicitados = params[:solicitud][:semovientes_solicitados]
        
        logger.info "Reestructuracion tipo #{params[:tipo].to_s}"
        logger.info "Reestructuracion Numero Cuenta #{params[:numero_cuenta].to_s}"
        numero_cuenta = params[:reestructuracion][:numero_cuenta].split('-')
        reestructuracion.tipo = numero_cuenta[0][0,1]
        reestructuracion.numero_cuenta = numero_cuenta[1]
        fecha = params[:reestructuracion][:fecha_valor_f].split("/")
        logger.info "FECHA VALOR F =================> #{params[:reestructuracion][:fecha_valor_f]}"
        reestructuracion.fecha_valor = fecha[2] << "-" << fecha[1] << "-" << fecha[0]
        reestructuracion.por_inventario = params[:solicitud][:por_inventario]
        if reestructuracion.cliente.class.to_s =='ClienteEmpresa' 
          reestructuracion.empresa_integrante_id = params[:solicitud][:empresa_integrante_id]
        end

        if params[:cliente][:viable] == '1'
          reestructuracion.viable = false
        else
          reestructuracion.viable = true
        end
        
        @successReestructuracion = reestructuracion.save             
        #@successReestructuracion = false
        
        if  @successReestructuracion == true
          render :update do |page|
            page.redirect_to(:action=>"view",  :reestructuracion_id  => reestructuracion.id)
          end
        else

          render :update do |page|
            msg_error = I18n.t('Sistema.Body.Vistas.Reestructuracion.Errores.no_es_posible_guardar_los_datos')
            page.hide 'message'
            page.hide 'errorExplanation'
            page.replace_html 'errorExplanation',"<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><UL>" << msg_error << '</UL>'
            page.show 'errorExplanation'
            page.<< "window.scrollTo(0,0);"
          end
        end
      else
        msg_error = ""
        reestructuracion.errors.each do |errores|
          msg_error << "<LI>" << errores.to_s << "</LI>"
        end
        render :update do |page|          
          page.hide 'message'
          page.hide 'errorExplanation'
          page.replace_html 'errorExplanation',"<h2>#{I18n.t('Sistema.Body.Vistas.Reestructuracion.Errores.han_ocurrido')} "<< reestructuracion.errors.size.to_s << "#{I18n.t('Sistema.Body.Vistas.Reestructuracion.Errores.se_presentan_los_errores')}" << msg_error << '</UL>'
          page.show 'errorExplanation'
          page.<< "window.scrollTo(0,0);"  
          
        end        
      end

      return false
  end
  

  def generar_prestamo

       reestructuracion = Reestructuracion.find(params[:reestructuracion_id])
       @success = reestructuracion.generar_financiamiento(reestructuracion,session[:oficina],session[:id])

         logger.debug "RESULTADO DE LA RESPUESTA >>>>>>>>>>>>>>>>>>>>> " << @success.inspect
         logger.debug "RESULTADO DE LA RESPUESTA >>>>>>>>>>>>>>>>>>>>> " << reestructuracion.errors.size.to_s     

         if  @success == true

           render :update do |page| 
              page.replace_html 'message',"#{I18n.t('Sistema.Body.Vistas.Reestructuracion.Etiquetas.se_genero_el_nuevo_financiamiento')}" << Prestamo.find_by_solicitud_id(reestructuracion.solicitud_id).numero.to_s
              page.show 'message'
              page.hide 'errorExplanation'
              page.replace_html 'div-botones', :partial => 'botones', :locals => {:reestructuracion_id => reestructuracion.id}
              
            end
         else
            msg_error = ""
            reestructuracion.errors.each do |errores|
              msg_error << "<LI>" << errores.to_s << "</LI>"
            end
            render :update do |page|          
              page.hide 'message'
              page.hide 'errorExplanation'
              page.replace_html 'errorExplanation',"<h2>#{I18n.t('Sistema.Body.Vistas.Reestructuracion.Errores.han_ocurrido')} "<< reestructuracion.errors.size.to_s << "#{I18n.t('Sistema.Body.Vistas.Reestructuracion.Errores.se_presentan_los_errores')}" << msg_error << '</UL>'
              page.show 'errorExplanation'
              page.<< "window.scrollTo(0,0);"  

            end
         end

       return false
   end
    

  def list
    conditions = ' estatus_reestructuracion not in (0,1) '
    estatus_prestamo = 'E'
    #@form_search_expression << "Estatus igual 'Vencido'"

    logger.info "PARAMETROS ==========> #{params.inspect}"
    params['sort'] = "beneficiario" unless params['sort']
    
    if params['sort'] == "monto_insumo" ; params['sort'] = "(select monto_insumos from prestamo p where p.solicitud_id = solicitud.id)" end
    if params['sort'] == "monto_banco" ; params['sort'] = "(select monto_banco from prestamo p where p.solicitud_id = solicitud.id)"  end
    if params['sort'] == "monto_financiamiento" ; params['sort'] = "(select monto_solicitado from prestamo p where p.solicitud_id = solicitud.id)" end
    if params['sort'] == "monto_sras_total" ; params['sort'] = "(select monto_sras_total from prestamo p where p.solicitud_id = solicitud.id)" end
    if params['sort'] == "monto_total" ; params['sort'] = "(select monto_solicitado + monto_sras_total from prestamo p where p.solicitud_id = solicitud.id)" end
          
    logger.info"XXXXXXXX-estado=====>>>>"<<params[:estado_id].inspect
    unless params[:estado_id].nil?  || params[:estado_id].empty? 
      estado_id = params[:estado_id].to_s
      
      if estado_id.to_i != 0
        estado = Estado.find(estado_id)     
        conditions = "#{conditions} and cliente_id in (select up.cliente_id from unidad_produccion up, municipio m where m.id = up.municipio_id and m.estado_id = #{params[:estado_id]})"      
        @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.estado')} #{I18n.t('Sistema.Body.General.es')} #{I18n.t('Sistema.Body.Vistas.General.igual')} #{estado.nombre}"
      end
    end

    unless params[:estatus_id].nil? || params[:estatus_id].empty?
      estatus_id = params[:estatus_id].to_s
      estatus = Estatus.find(estatus_id.to_i)
      conditions = "#{conditions}  AND estatus_id =  #{params[:estatus_id]}"
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.Form.estatus')} #{I18n.t('Sistema.Body.General.es')} #{I18n.t('Sistema.Body.Vistas.General.igual')} #{estatus.nombre}"
    end
     
    unless params[:sector_id][0].nil? || params[:sector_id][0].empty?
        sector_id = params[:sector_id][0].to_s
        sector = Sector.find(sector_id.to_i)
        conditions = "#{conditions}  AND cliente_id in (select s.cliente_id from solicitud s, prestamo p where s.id = p.solicitud_id and p.estatus = 'E' and  sector_id =  #{params[:sector_id][0]})"
        @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.sector')} #{I18n.t('Sistema.Body.General.es')} #{I18n.t('Sistema.Body.Vistas.General.igual')} #{sector.nombre}"
    end
      
    unless params[:sub_sector_id][0].nil?  || params[:sub_sector_id][0].empty? 
      sub_sector_id = params[:sub_sector_id][0].to_s
      if sub_sector_id.to_i != 0
        sub_sector = SubSector.find(sub_sector_id.to_i)
        conditions = "#{conditions}  AND cliente_id in (select s.cliente_id from solicitud s, prestamo p where s.id = p.solicitud_id and p.estatus = 'E' and sub_sector_id =  #{params[:sub_sector_id][0]})"
        @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.sub_sector')} #{I18n.t('Sistema.Body.General.es')} #{I18n.t('Sistema.Body.Vistas.General.igual')} #{sub_sector.nombre}"
      end
    end

    unless params[:rubro_id][0].nil? || params[:rubro_id][0].empty? 
      rubro_id = params[:rubro_id][0].to_s
      if rubro_id.to_i != 0
        rubro = Rubro.find(rubro_id.to_i)
        conditions = "#{conditions}  AND cliente_id in (select p.cliente_id from prestamo p where p.estatus = 'E' and rubro_id =  #{params[:rubro_id][0]})"
        @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.rubro')} #{I18n.t('Sistema.Body.General.es')} #{I18n.t('Sistema.Body.Vistas.General.igual')} #{rubro.nombre}"
      end
    end
      
    unless params[:sub_rubro_id][0].nil? || params[:sub_rubro_id][0].empty?

    sub_rubro_id = params[:sub_rubro_id][0].to_s
    if sub_rubro_id.to_i != 0
      sub_rubro = SubRubro.find(sub_rubro_id.to_i)
      conditions = "#{conditions} and cliente_id in (select p.cliente_id from prestamo p where p.estatus = 'E' and sub_rubro_id = #{params[:sub_rubro_id][0]}) "
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.sub_rubro')} #{I18n.t('Sistema.Body.General.es')} #{I18n.t('Sistema.Body.Vistas.General.igual')} #{sub_rubro.nombre}"
    end

    end

    unless params[:actividad_id][0].nil?  || params[:actividad_id][0].empty? 
      actividad_id = params[:actividad_id][0].to_s
      
      if actividad_id.to_i != 0
        actividad = Actividad.find(actividad_id.to_i)
        conditions = "#{conditions} and cliente_id in (select p.cliente_id from prestamo p where p.estatus = 'E' and actividad_id = #{params[:actividad_id][0]}) "
        @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.actividad')} #{I18n.t('Sistema.Body.General.es')} #{I18n.t('Sistema.Body.Vistas.General.igual')} #{actividad.nombre}"
      end
    end
      
    unless params[:identificacion].nil?  || params[:identificacion].empty? 
      conditions += " AND lower(cedula_rif) LIKE lower('%#{params[:identificacion].strip}%') "
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.cedula')} / #{I18n.t('Sistema.Body.Vistas.General.rif')} #{I18n.t('Sistema.Body.Vistas.General.igual')} #{params[:identificacion]}"
    end

    unless params[:nombre].nil?  || params[:nombre].empty?
      conditions += " AND lower(beneficiario) LIKE lower('%#{params[:nombre]}%') "
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.beneficiario')} #{I18n.t('Sistema.Body.Vistas.General.igual')} #{params[:nombre]}"
    end
            
    logger.info "CONDITIONS =======> #{conditions}" 
         
    @filtro = conditions
    logger.debug "condiciones de busqueda de reestructuracion " <<  @filtro.inspect
    #@total = ViewPrestamosReestructurar.count(:conditions=>@filtro)   
    #@pages, @list = paginate(:view_prestamos_reestructurar, :class_name => 'ViewPrestamosReestructurar',
     #:per_page => @records_by_page,
     #:conditions => @filtro,
     #:select=>'*',
     #:order_by => @params['sort'])
     
     @list = ViewPrestamosReestructurar.search(@filtro, params[:page], params['sort'])
     @total=@list.count
         #condicion_rol = " usuario_rol.rol_id = 7 "
         #@aux_roles = @usuario.roles.find(:first, :conditions=>condicion_rol)
    form_list
  end
  
  def show_hide_elementos()
    @accion = params['accion']
    @prestamo_id = params['prestamo_id']

    @prestamo_auxiliar = Prestamo.find(@prestamo_id)
    @intereses_totales = @prestamo_auxiliar.interes_vencido +  @prestamo_auxiliar.interes_diferido_vencido +  @prestamo_auxiliar.interes_diferido_por_vencer

    interes_a_reestructurar = ParametroGeneral.find(:all)[0].porcentaje_interes_a_reestructurar
    @porcentaje_pago_del_cliente = 100 - interes_a_reestructurar
    @monto_pago_del_cliente = @intereses_totales*@porcentaje_pago_del_cliente/100
    @total_intereses_a_reestructurar = @intereses_totales - @monto_pago_del_cliente


    render :update do |page|
      page.replace_html 'detalle_prestamo', :partial => 'datos_prestamo'

    end
  end
  

  def sector_change
    sub_sector_fill(params[:sector_id])
    render :update do |page|
      page.replace_html 'sub-sector-select', :partial => 'sub_sector_select'
      page.replace_html 'sub_rubro-select', :partial => 'sub_rubro_select'
      page.replace_html 'actividad-select', :partial => 'actividad_select'
      page.replace_html 'rubro-select', :partial => 'rubro_select'
      page.show 'rubro-select'
      page.show 'sub-rubro-select'
      page.show 'actividad-select'
      page.show 'sub-sector-select'
      page.hide 'hectarea'
      page.hide 'semovientes'
      page.hide 'maquinaria'
    end
  end
  
  def sub_sector_change
    rubro_fill(params[:sub_sector_id])
    m = hectareas_unidades(params[:sub_sector_id])
    render :update do |page|
      page.hide 'hectarea'
      page.hide 'semovientes'
      if m.length > 0
        page.show m
      end
      page.replace_html 'rubro-select', :partial => 'rubro_select'
      page.replace_html 'sub_rubro-select', :partial => 'sub_rubro_select'
      page.replace_html 'actividad-select', :partial => 'actividad_select'
      page.show 'rubro-select'
      page.show 'sub-rubro-select'
      page.show 'actividad-select'
    end
  end
  
  def rubro_change
    sub_rubro_fill(params[:rubro_id])
    render :update do |page|
      page.replace_html 'sub_rubro-select', :partial => 'sub_rubro_select'
      page.replace_html 'actividad-select', :partial => 'actividad_select'
      page.show 'sub_rubro-select'
      page.show 'actividad-select'
    end
  end
  
  def sub_rubro_change
    actividad(params[:sub_rubro_id])
    render :update do |page|
      page.replace_html 'actividad-select', :partial => 'actividad_select'
      page.show 'actividad-select'
    end
  end

  def programa_change
    #@solicitud = Solicitud.new
    programa_id = params[:programa_id]
    programa = Programa.find(programa_id)
    #@solicitud.programa = programa
    modalidad_financiamiento_fill(programa_id)
    #@destino_credito_select = DestinoCredito.find(:all)
    origen_fondo_fill(programa_id)
    @modalidad_select = programa.modalidades_financiamiento unless programa.nil?
    #sector_fill(0)
    render :update do |page|
      #page.hide 'hectarea'
      #page.hide 'semovientes'
      #page.hide 'maquinaria'
      page.replace_html 'origen_fondo-select', :partial => 'origen_fondo_select'
      page.replace_html 'modalidad-select', :partial => 'modalidad_financiamiento_select'
      #page.replace_html 'sub-sector-select', :partial => 'sub_sector_blanco'
      #page.replace_html 'rubro-select', :partial => 'rubro_blanco'
      #page.replace_html 'sub_rubro-select', :partial => 'sub_rubro_blanco'
      #page.replace_html 'actividad-select', :partial => 'actividad_blanco'
     end
  end
  
        
  protected
  def common
    super
    #@form_title = Etiquetas.etiqueta(10)
    @form_title = 'Comité de Reestructuración'
    @form_title_record = 'Financiamientos'
    @form_title_records = 'Financiamientos'
    @form_entity = 'reestructuracion'
    @form_identity_field = 'id'
    @width_layout = '1000'
    @entidad_financiera_cheque = EntidadFinanciera.find(:all, :conditions=>'entidad_financiera.activo=true and id in (select entidad_financiera_id from cuenta_bcv where activo=true and recaudador = true limit 1)', :select=> 'entidad_financiera.id, entidad_financiera.nombre', :order=>'nombre')
    @cuenta_bcv_select = []
  end
    
    
  def sector_fill(sector_id)
    if sector_id > 0
      @sector_list = Sector.find(:all, :order=>'nombre')
    else
      @sector_list = []
    end
    sub_sector_fill(0)
  end
  
  def sub_sector_fill(sector_id)
    if sector_id.to_i > 0
      @sub_sector_list = SubSector.find(:all, :conditions=>['sector_id = ?', sector_id])
    else
      @sub_sector_list = []
    end
    rubro_fill(0)
  end
  
  def rubro_fill(sub_sector_id)
    if sub_sector_id.to_i > 0
      @rubro_list = Rubro.find(:all, :conditions=>['sub_sector_id = ?', sub_sector_id])
    else
      @rubro_list = []
    end
    sub_rubro_fill(nil)
  end
  
  def sub_rubro_fill(id)
    unless id.nil?
      @sub_rubro_list = SubRubro.find(:all, :conditions=>['activo = true and rubro_id = ?', id], :order => 'nombre')
    else
      @sub_rubro_list =[]
    end
    actividad(nil)
  end
  
  def actividad(id)
    unless id.nil?
      @actividad_list = Actividad.find(:all, :conditions=>['activo = true and sub_rubro_id = ?', id], :order => 'nombre')
    else
      @actividad_list =[]
    end
  end
  
  def fill()
    unless @solicitud.nil?
      modalidad_financiamiento_fill(@solicitud.programa_id)
      origen_fondo_fill(@solicitud.programa_id)
    end
    @unidad_produccion_select = UnidadProduccion.find(:all, :conditions=>['cliente_id = ?', @cliente.id], :order=>'nombre')

  end

  def modalidad_financiamiento_fill(programa_id)
    if !programa_id.nil?
      programa = Programa.find(programa_id)
     @modalidad_financiamiento_select = programa.modalidades_financiamiento
    end
  end

  def origen_fondo_fill(programa_id)
    if !programa_id.nil?
      @programa = Programa.find(programa_id)
      @programa_origen_fondo_select = OrigenFondo.find(:all, :conditions=>["activo=true and id in (select origen_fondo_id from programa_origen_fondo where programa_id = ?)", @programa.id]) unless @programa.nil?
    end
  end

  def programa_fill(programa_id)
    if programa_id.nil?
      @programa = Programa.find(:all, :conditions=>['id in (select programa_id from programa_tipo_cliente where tipo_cliente_id = ? )',@cliente.tipo_cliente_id], :order=>'nombre')
      @modalidad_select = ModalidadFinanciamiento.find(:all, :conditions=>"activo = true")
      @programa_origen_fondo_select = OrigenFondo.find(:all, :conditions=>["activo=true and id in (select origen_fondo_id from programa_origen_fondo where programa_id = ?)", @programa[0].id])
    else
      @programa = Programa.find(:all, :conditions=>['id in (select programa_id from programa_tipo_cliente where tipo_cliente_id   = ? )',@cliente.tipo_cliente_id], :order=>'nombre')
      @programa_origen_fondo_select = OrigenFondo.find(:all, :conditions=>["activo=true and id in (select origen_fondo_id from programa_origen_fondo where programa_id = ?)", @solicitud.programa_id])
    end
  end
  
  def hectareas_unidades(sub_sector_id)
    sub_sector = SubSector.find(sub_sector_id)
    if sub_sector.nemonico == 'VE'
      return 'hectarea'
    elsif sub_sector.nemonico == 'AN'
      return 'semovientes'
    elsif sub_sector.nemonico == 'MA'
      return 'maquinaria'
    else
      return ''
    end
  end
  
end
