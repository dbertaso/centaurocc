# encoding: utf-8
class Solicitudes::ReestructuracionController < FormTabsController

  skip_before_filter :set_charset, 
  :only=>[:tabs, :printer, :avanzar_reestructuracion, :avanzar_reestructuracion_index, :sector_change, :sub_sector_change, :rubro_change, :sub_rubro_change]

 layout 'form_basic'

  def index
    @estado = Estado.find(:all, :order => 'nombre')
    @sector = Sector.find(:all, :conditions => 'activo=true', :order => 'nombre')
    sector_fill(0)
    @ciclo_productivo = CicloProductivo.find(:all, :order => 'nombre')
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
    logger.info"XXXXXXXX-params-XXXXXXXXX"<<params.inspect
    @cliente = Cliente.find(params[:cliente_id])
    @prestamos = Prestamo.find(:all, :conditions=>[" estatus = 'E' and cliente_id = #{params[:cliente_id]}"])
    @ids = ''
  end
  
  
  def printer
    @listado_prestamos = ""
    @listado_prestamos2 = ""
    @listado_rubros = ""
    @monto_negociacion = 0.0.to_d
    @cantidad_prestamos = 0
    @anio_solicitudes = ""
    @bancos_solicitudes = ""
    
    @cliente = Cliente.find(params[:cliente_id])
    imprimir = true
    aux = Reestructuracion.new()
    @prestamos = aux.reestructurar(@cliente)
    
    if imprimir == true
      if @cliente.type.to_s == 'ClienteEmpresa'
        @registro_mercantil = RegistroMercantil.find(:first, :conditions=>"empresa_id = #{@cliente.empresa_id}" ,:order=>" id desc")
        mes = @registro_mercantil.fecha_registro.to_s.split('-')[1]
        letras_mes = I18n.t('date.month_names')
        if mes == "01"
          mes_letras = letras_mes[1] 
        elsif mes == "02"
          mes_letras = letras_mes[2] 
        elsif mes == "03" 
          mes_letras = letras_mes[3] 
        elsif mes == "04" 
          mes_letras = letras_mes[4] 
        elsif mes == "05"
          mes_letras = letras_mes[5]
        elsif mes == "06" 
          mes_letras = letras_mes[6]
        elsif mes == "07" 
          mes_letras = letras_mes[7]
        elsif mes == "08"
          mes_letras = letras_mes[8]
        elsif mes == "09"
          mes_letras = letras_mes[9] 
        elsif mes == "10"
          mes_letras = letras_mes[10]
        elsif mes == "11"
          mes_letras = letras_mes[11]
        elsif mes == "12"
          mes_letras = letras_mes[12]
        end
        @fecha_registro = @registro_mercantil.fecha_registro.to_s.split('-')[2] << " #{I18n.t('Sistema.Body.Vistas.General.de')} " << mes_letras << " #{I18n.t('Sistema.Body.Vistas.General.del')} #{ I18n.t('Sistema.Body.Modelos.Motores.Columnas.ano')} " <<  @registro_mercantil.fecha_registro.to_s.split('-')[0]
      end
         
      @prestamos.each do |prestamo|
        if @listado_prestamos == ""
          @listado_prestamos = prestamo.numero.to_s 
        else 
          @listado_prestamos = @listado_prestamos << ",<br>" << prestamo.numero.to_s
        end
        if @listado_prestamos2 == ""
          @listado_prestamos2 = prestamo.numero.to_s 
        else
          @listado_prestamos2 = @listado_prestamos2 << ", " << prestamo.numero.to_s
        end
        if @listado_rubros == ""
          @listado_rubros = prestamo.solicitud.rubro.nombre.to_s 
        else 
          @listado_rubros = @listado_rubros << ", " << prestamo.solicitud.rubro.nombre.to_s
        end
      
        anio = prestamo.solicitud.fecha_aprobacion.to_s.split('-')[0]
        if @anio_solicitudes.index(anio) == nil
          if @anio_solicitudes == ""
            @anio_solicitudes << anio 
          else
            @anio_solicitudes << ", " << anio
          end
        end
        
        banco = prestamo.banco_origen
        if @bancos_solicitudes.index(banco) == nil
          if @bancos_solicitudes == ""
            @bancos_solicitudes << banco 
          else 
            @bancos_solicitudes << ", " << banco
          end
        end
      
        if @bancos_solicitudes.rindex(',') != nil
          @bancos_solicitudes[@bancos_solicitudes.rindex(',')] = ' y'
        end
      
        @monto_negociacion = @monto_negociacion + prestamo.deuda
        @cantidad_prestamos =  @cantidad_prestamos + 1
      end
      render  :layout => 'form_reporte'
    end
  end
  
  def avanzar_reestructuracion
      #@cliente = Cliente.find(@params[:cliente_id])
      reestructuracion = Reestructuracion.find(:first, :conditions=>"cliente_id = #{params[:cliente_id]} and estatus = 1")
      logger.debug "reestructuracion ------ " << reestructuracion.inspect
      
      unless reestructuracion.nil?
        envio_reestructuracion = true
        reestructuracion.estatus = 2
        envio_reestructuracion = reestructuracion.save
        
        if envio_reestructuracion == true
          logger.debug "valor retornado t - " << envio_reestructuracion.inspect
          render :update do |page|
            page.redirect_to :action => "index"
          end
        else
          logger.debug "valor retornado f - " << envio_reestructuracion.inspect
          render :update do |page|
            msg_error = "<LI>#{I18n.t('Sistema.Body.Controladores.Reestructuracion.Errores.no_es_posible_actualizar_solicitud')}</LI>"
            page.hide 'message'
            page.hide 'errorExplanation'
            page.replace_html 'errorExplanation',"<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL>" << msg_error
            page.show 'errorExplanation'
          end
        end
      else
        render :update do |page|          
          msg_error = "<LI>#{I18n.t('Sistema.Body.Controladores.Reestructuracion.Errores.debe_imprimir_formato_solicitud')}</LI>"
          page.hide 'message'
          page.hide 'errorExplanation'
          page.replace_html 'errorExplanation',"<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL>" << msg_error
          page.show 'errorExplanation'
        end        
      end

      return false
  end
  
  def avanzar_reestructuracion_index

      #@cliente = Cliente.find(@params[:cliente_id])
      reestructuracion = Reestructuracion.find(:first, :conditions=>"cliente_id = #{params[:cliente_id]} and estatus = 1")
      logger.debug "reestructuracion ------ " << reestructuracion.inspect
      
      unless reestructuracion.nil?
        envio_reestructuracion = true
        reestructuracion.estatus = 2
        envio_reestructuracion = reestructuracion.save
        #envio_reestructuracion = false
        
        if envio_reestructuracion == true
          logger.debug "valor retornado t - " << envio_reestructuracion.inspect
          render :update do |page|
            
            page.hide 'errorExplanation'
            page.replace_html 'message',"#{I18n.t('Sistema.Body.Controladores.Reestructuracion.Errores.los_financiamientos_del_beneficiario')} #{reestructuracion.cliente.class.to_s=='ClienteEmpresa' ? reestructuracion.cliente.empresa.nombre : reestructuracion.cliente.persona.nombre_corto} #{I18n.t('Sistema.Body.Controladores.Reestructuracion.Errores.se_enviaron_comite_reestructuracion')}"
            page.remove "row_#{reestructuracion.cliente_id}"
            page.remove "row_detalle_#{reestructuracion.cliente_id}"
            page.show 'message'
          end
        else
          logger.debug "valor retornado f - " << envio_reestructuracion.inspect
          render :update do |page|
            msg_error = "<LI>#{I18n.t('Sistema.Body.Controladores.Reestructuracion.Errores.no_es_posible_actualizar_solicitud')}</LI>"
            page.hide 'message'
            page.hide 'errorExplanation'
            page.replace_html 'errorExplanation',"<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL>" << msg_error
            page.show 'errorExplanation'
          end
        end
      else
        render :update do |page|          
          msg_error = "<LI>#{I18n.t('Sistema.Body.Controladores.Reestructuracion.Errores.debe_imprimir_formato_solicitud')}</LI>"
          page.hide 'message'
          page.hide 'errorExplanation'
          page.replace_html 'errorExplanation',"<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL>" << msg_error
          page.show 'errorExplanation'
        end        
      end

      return false
  end



  def list
    conditions = ' estatus_reestructuracion in (0,1) '
    estatus_prestamo = 'E'
    @form_search_expression << "Estatus igual 'Vencido'"

    params['sort'] = "beneficiario" unless params['sort']
    
    if params['sort'] == "monto_insumo"
      params['sort'] = "(select monto_insumos from prestamo p where p.solicitud_id = solicitud.id)"
    elsif params['sort'] == "monto_banco"
      params['sort'] = "(select monto_banco from prestamo p where p.solicitud_id = solicitud.id)"
    elsif params['sort'] == "monto_financiamiento"
      params['sort'] = "(select monto_solicitado from prestamo p where p.solicitud_id = solicitud.id)"
    elsif params['sort'] == "monto_sras_total"
      params['sort'] = "(select monto_sras_total from prestamo p where p.solicitud_id = solicitud.id)"
    elsif params['sort'] == "monto_total"
      params['sort'] = "(select monto_solicitado + monto_sras_total from prestamo p where p.solicitud_id = solicitud.id)"
    end

    conditions = "#{conditions} and cliente_id > 0 "
          
    unless params[:estado_id][0].to_s.nil? || params[:estado_id][0].to_s.empty?
      estado_id = params[:estado_id][0].to_s
      estado = Estado.find(estado_id) 
      conditions = "#{conditions} and cliente_id in (select up.cliente_id from unidad_produccion up, municipio m where m.id = up.municipio_id and m.estado_id = #{params[:estado_id][0]})"      
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.estado')} #{I18n.t('Sistema.Body.General.es')} #{I18n.t('Sistema.Body.Vistas.General.igual')} '#{estado.nombre}'"
    end

#    unless params[:estatus_id][0].to_s.nil? || params[:estatus_id][0].to_s.empty?
#      estatus_id = params[:estatus_id][0].to_s
#      estatus = Estatus.find(estatus_id)
#      conditions += "  AND estatus_id =  #{params[:estatus_id][0]}"
#      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.Form.estatus')} #{I18n.t('Sistema.Body.Vistas.General.igual')} '#{estatus.nombre}'"
#    end
     logger.info"XXXXXXX-params[:sector_id.inspect]-XXXXXXX<<<<<<<<<"<<params.inspect
      unless params[:sector_id][0].to_s.nil? || params[:sector_id][0].to_s.empty?
          sector_id = params[:sector_id][0].to_s
          sector = Sector.find(sector_id)
          conditions = "#{conditions}  AND cliente_id in (select s.cliente_id from solicitud s, prestamo p where s.id = p.solicitud_id and p.estatus = 'E' and  sector_id =  #{params[:sector_id][0]})"
          @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.Form.sector')} #{I18n.t('Sistema.Body.Vistas.General.igual')} '#{sector.nombre}'"
      end
      
      
logger.info"XXXXXXX-params[:sub_sector_id]-XXXXXXX<<<<<<<<<"<<params.inspect
      unless params[:sub_sector_id][0].to_s.nil? || params[:sub_sector_id][0].to_s.empty?
        sub_sector_id = params[:sub_sector_id][0].to_s
        sub_sector = SubSector.find(sub_sector_id)
          conditions = "#{conditions}  AND cliente_id in (select s.cliente_id from solicitud s, prestamo p where s.id = p.solicitud_id and p.estatus = 'E' and sub_sector_id =  #{params[:sub_sector_id][0]})"
          @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.Form.sub_sector')} #{I18n.t('Sistema.Body.Vistas.General.igual')} '#{sub_sector.nombre}'"
      end

      unless params[:rubro_id][0].to_s.nil? || params[:rubro_id][0].to_s.empty?
        rubro_id = params[:rubro_id][0].to_s
        rubro = Rubro.find(rubro_id)
        conditions = "#{conditions}  AND cliente_id in (select p.cliente_id from prestamo p where p.estatus = 'E' and rubro_id =  #{params[:rubro_id][0]})"
        @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.Form.rubro')} #{I18n.t('Sistema.Body.Vistas.General.igual')} '#{rubro.nombre}'"
      end
      
      unless params[:sub_rubro_id][0].to_s.nil? || params[:sub_rubro_id][0].to_s.empty?
        sub_rubro_id = params[:sub_rubro_id][0].to_s
        sub_rubro = SubRubro.find(sub_rubro_id)
        conditions = "#{conditions} and cliente_id in (select p.cliente_id from prestamo p where p.estatus = 'E' and sub_rubro_id = #{sub_rubro_id}) "
        @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.Form.sub_rubro')} #{I18n.t('Sistema.Body.General.es')} #{I18n.t('Sistema.Body.Vistas.General.igual')} '#{sub_rubro.nombre}'"
      end

    unless params[:identificacion].nil? ||  params[:identificacion].empty?
      conditions += " AND lower(cedula_rif) LIKE lower('%#{params[:tipo]+params[:identificacion].strip}%') "
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.VisitaSolicitud.Etiquetas.cedula_rif')} #{I18n.t('Sistema.Body.Vistas.General.contenga')}'#{params[:tipo]+params[:identificacion]}'"
    end

    unless params[:nombre].nil? ||  params[:nombre].empty?
      conditions += " AND lower(beneficiario) LIKE lower('%#{params[:nombre]}%') "
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Vistas.General.contenga')} #{params[:nombre]}"
    end

      unless params[:actividad_id][0].to_s.nil? || params[:actividad_id][0].to_s.empty?
        actividad_id = params[:actividad_id][0].to_s
        actividad = Actividad.find(actividad_id)
        conditions = "#{conditions} and cliente_id in (select p.cliente_id from prestamo p where p.estatus = 'E' and actividad_id = #{actividad_id}) "
        @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.actividad')} #{I18n.t('Sistema.Body.General.es')} #{I18n.t('Sistema.Body.Vistas.General.igual')} '#{actividad.nombre}'"
      end
            
      @filtro = conditions
      logger.debug "condiciones de busqueda de reestructuracion " <<  @filtro.inspect

      #@total = ViewPrestamosReestructurar.count(:conditions=>@filtro)
     #@list = ViewPrestamosReestructurar.search(conditions, params[:page], params[:sort])
#          @pages, @list = paginate(:view_prestamos_reestructurar, :class_name => 'ViewPrestamosReestructurar',
#           :per_page => @records_by_page,
#           :conditions => @filtro,
#           :select=>'*',
#           :order_by => @params['sort'])

            
        @list = ViewPrestamosReestructurar.search(@filtro, params[:page], params['sort'])
        @total=@list.count
           #condicion_rol = " usuario_rol.rol_id = 7 "
           #@aux_roles = @usuario.roles.find(:first, :conditions=>condicion_rol)

    form_list
  end

  def sector_change
    sub_sector_fill(params[:sector_id])
    render :update do |page|
      page.replace_html 'sub-sector-select', :partial => 'sub_sector_select'
      page.replace_html 'sub_rubro-select', :partial => 'sub_rubro_select'
      page.replace_html 'actividad-select', :partial => 'actividad_select'
      page.replace_html 'rubro-select', :partial => 'rubro_select'
      page.show 'rubro-select'
      page.show 'sub_rubro-select'
      page.show 'actividad-select'
      page.show 'sub-sector-select'
    end
  end
  
  def sub_sector_change
    rubro_fill(params[:sub_sector_id])
    render :update do |page|
      page.replace_html 'rubro-select', :partial => 'rubro_select'
      page.replace_html 'sub_rubro-select', :partial => 'sub_rubro_select'
      page.replace_html 'actividad-select', :partial => 'actividad_select'
      page.show 'rubro-select'
      page.show 'sub_rubro-select'
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

  def view
    @solicitud = Solicitud.find(params[:id])
    @cliente = @solicitud.cliente
    @accion = params[:accion]
    @historial = DetalleReestructuracion.find(:all, :conditions=>["solicitud_id = ?", @solicitud.id])
  end
        
  protected
  def common
    super
    #@form_title = Etiquetas.etiqueta(10)
    @form_title = I18n.t('Sistema.Body.Vistas.Reestructuracion.Header.form_title')
    @form_title_record = I18n.t('Sistema.Body.Vistas.Reestructuracion.Header.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Vistas.Reestructuracion.Header.form_title_records')
    @form_entity = 'reestructuracion'
    @form_identity_field = 'id'
    @width_layout = '1000'
    @entidad_financiera_cheque = EntidadFinanciera.find(:all,:conditions=>'entidad_financiera.activo=true', :select=> 'entidad_financiera.id, entidad_financiera.nombre', :order=>'nombre', :joins=>"INNER JOIN cuenta_bcv on entidad_financiera.id = cuenta_bcv.entidad_financiera_id")
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
  
end
