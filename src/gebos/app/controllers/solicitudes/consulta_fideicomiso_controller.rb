# encoding: utf-8

#
# autor: Marvin Alfonzo
# clase: Solicitudes::ConsultaFideicomisoController
# descripción: Migración a Rails 3
#

class Solicitudes::ConsultaFideicomisoController < FormTabsController

  skip_before_filter :set_charset, :only=>[:liberar_solicitud, :sub_rubro_form_change, :sub_rubro_change, 
    :rubro_form_change, :rubro_change, :sub_sector_form_change, 
    :sub_sector_change, :sector_form_change, :sector_change]

  layout 'form_basic'

  def index
    @estado = Estado.find(:all, :order => 'nombre')
    @sector = Sector.find(:all, :conditions => 'activo=true', :order => 'nombre')
    sector_fill(@sector[0].id)
    sub_sector_fill(0)
    rubro_fill(0)
    sub_rubro_fill(0)
    actividad_fill(0)
    @moneda = Moneda.find(:all, :conditions => "activo = true", :order => "nombre")
    @meneda_activa = ParametroGeneral.first.moneda_id
    @estatus = Estatus.find(:all, :order => 'nombre')
  end
  
  def sector_fill(sector_id)
    @sector_list = Sector.find(:all, :conditions => 'activo=true', :order=>'nombre')
    if sector_id > 0
      unless @solicitud.nil?
        sub_sector_fill(@solicitud.sector_id)
      else
        sub_sector_fill(@sector_list[0].id)
      end
    else
      sub_sector_fill(@sector_list[0].id)
    end
  end
  
  
  def sub_sector_fill(sector_id)
    
    logger.debug "VALOR DEL SECTOR " << sector_id << " ------- " << sector_id.inspect
    if sector_id.to_s != ""
      @sub_sector_list = SubSector.find(:all, :conditions=>['activo=true and sector_id = ?', sector_id], :order => 'nombre')
    else
      @sub_sector_list = []
    end
    rubro_fill(nil)
    sub_rubro_fill(nil)
    actividad_fill(nil)
  end

  def rubro_fill(sub_sector_id)
    unless sub_sector_id == ""
      @rubro_list = Rubro.find(:all, :conditions=>['activo=true and sub_sector_id = ?', sub_sector_id], :order => 'nombre')
    else
      @rubro_list =[]
    end
    sub_rubro_fill(0)
    actividad_fill(0)
  end

  def sub_rubro_fill(rubro_id)
    unless rubro_id == ""
      @sub_rubro_list = SubRubro.find(:all, :conditions=>['activo=true and rubro_id = ?', rubro_id], :order => 'nombre')
    else
      @sub_rubro_list =[]
    end
    actividad_fill(0)
  end

  def actividad_fill(sub_rubro_id)
    unless sub_rubro_id == ""
      @actividad_list = Actividad.find(:all, :conditions=>['activo=true and sub_rubro_id = ?', sub_rubro_id], :order => 'nombre')
    else
      @actividad_list =[]
    end
  end


  def liberar_solicitud

    estatus_id_inicial = 10048
    logger.debug "al entrar a liberar_solicitud " << params.inspect.to_s << params[:estado_id].to_s << " - " << params[:estado_id][0].to_s
    fecha_evento = Time.now
    fecha_actual_estatus = fecha_evento.strftime(I18n.t('time.formats.gebos_inverted'))  
    @usuario=Usuario.find(session[:id])
    @solicitud = Solicitud.find(:first, :conditions=>"id in (#{params[:solicitud_id]}) and estatus_id = #{estatus_id_inicial}")
    @solicitudes = Solicitud.find(:all, :conditions=>"id in (#{params[:solicitud_id]}) and estatus_id = #{estatus_id_inicial}")
      
    condiciones_modelo = params
    logger.info "CONDICIONES PARA MODELOS ---------" << condiciones_modelo.inspect
    success = @solicitud.avanzar_fideicomiso(@usuario, @solicitudes, params)
    #success = true
    logger.info success.inspect << "---------"  << success.to_s
    logger.info "+++success"
    numero_solicitudes1 = ""
    numero_solicitudes2 = ""
    numero_solicitudes3 = ""
    cantidad_solicitudes1 = 0
    cantidad_solicitudes2 = 0
    cantidad_solicitudes3 = 0
        
    @estatus1 = ConfiguracionAvance.find(:first, :conditions=>['estatus_origen_id = ? and condicionado = false',estatus_id_inicial])
    @estatus2 = ConfiguracionAvance.find(:first, :conditions=>['estatus_origen_id = ? and condicionado = true',estatus_id_inicial])
    @descEstatus1 = Estatus.find(@estatus1.estatus_destino_id)
    @descEstatus2 = Estatus.find(@estatus2.estatus_destino_id)
    @descEstatus3 = Estatus.find(10090)
        
    @grupoSol1 = Solicitud.find(:all, :conditions=>["id in (#{params[:solicitud_id]}) and estatus_id = ?",@estatus1.estatus_destino_id])
    @grupoSol1.each do |solicitud|
      if numero_solicitudes1 == "" 
        numero_solicitudes1  = solicitud.numero.to_s 
      else 
        numero_solicitudes1 = numero_solicitudes1 << ", " << solicitud.numero.to_s 
      end
      cantidad_solicitudes1 = cantidad_solicitudes1 + 1          
    end
        
    @grupoSol2 = Solicitud.find(:all, :conditions=>["id in (#{params[:solicitud_id]}) and estatus_id = ?",@estatus2.estatus_destino_id])
    @grupoSol2.each do |solicitud|
      if numero_solicitudes2 == "" 
        numero_solicitudes2  = solicitud.numero.to_s 
      else 
        numero_solicitudes2 = numero_solicitudes2 << ", " << solicitud.numero.to_s 
      end
      cantidad_solicitudes2 = cantidad_solicitudes2 + 1          
    end

    @grupoSol3 = Solicitud.find(:all, :conditions=>["id in (#{params[:solicitud_id]}) and estatus_id = ?",10090])
    @grupoSol3.each do |solicitud|
      if numero_solicitudes3 == "" 
        numero_solicitudes3  = solicitud.numero.to_s 
      else 
        numero_solicitudes3 = numero_solicitudes3 << ", " << solicitud.numero.to_s 
      end
      cantidad_solicitudes3 = cantidad_solicitudes3 + 1          
    end
            
    logger.debug "params de condiciones -------------- " << params[:estado_id].to_s
    logger.debug "params de condiciones -------------- " << params[:sector_id].to_s
    logger.debug "params de condiciones -------------- " << params[:sub_sector_id].to_s
    logger.debug "params de condiciones -------------- " << params[:rubro_id].to_s
    logger.debug "params de condiciones -------------- " << params[:sub_rubro_id].to_s
    logger.debug "params de condiciones -------------- " << params[:actividad_id].to_s
        
    if success == true
      resumen = " solicitud_id in (select s.id from solicitud s where estatus_id = #{estatus_id_inicial} "
      unless params[:estado_id]==""
        resumen = resumen << " and unidad_produccion_id in (select up.id from unidad_produccion up, municipio m where up.municipio_id = m.id and m.estado_id = #{params[:estado_id]})"
      end
      unless params[:sector_id]==""
        resumen = resumen << " and sector_id = #{params[:sector_id]}"
      end
      unless params[:sub_sector_id]=="" 
        resumen = resumen << " and sub_sector_id = #{params[:sub_sector_id]}" 
      end
      unless params[:rubro_id]=="" 
        resumen = resumen << " and rubro_id = #{params[:rubro_id]}" 
      end        
      unless params[:sub_rubro_id]==""
        resumen = resumen << " and sub_rubro_id = #{params[:sub_rubro_id]}" 
      end
      unless params[:actividad_id]==""
        resumen = resumen << " and actividad_id = #{params[:actividad_id]}" 
      end
      resumen = resumen << ")"
                     
      total_banco = Prestamo.sum(:monto_banco, :conditions=>resumen)
      total_insumos = Prestamo.sum(:monto_insumos, :conditions=>resumen)
      monto_sras = Prestamo.sum(:monto_sras_total, :conditions=>resumen)
      monto_gastos_admin = Prestamo.sum(:monto_gasto_total, :conditions=>resumen)
      tramites = Prestamo.count(:conditions=>resumen)
             
      if  total_banco  == nil 
        total_banco  = 0 
      end 
      if  total_insumos  == nil 
        total_insumos  = 0 
      end 
      if  monto_sras  == nil 
        monto_sras  = 0 
      end
      if monto_gastos_admin == nil 
        monto_gastos_admin = 0 
      end  
      if  tramites  == nil 
        tramites  = 0 
      end 
      logger.debug "AQUI SUCCESS - VOY A RENDER"
      render :update do |page|
        @solicitudes.each do |solicitud|
          page.remove "row_#{solicitud.id}"
        end
        logger.debug "AQUI SUCCESS - DEBIO REMOVER FILA"
        page.replace_html 'dv_total_banco', format_fm(total_banco)
        page.replace_html 'dv_total_insumos', format_fm(total_insumos)
        page.replace_html 'dv_total_sras', format_fm(monto_sras)
        page.replace_html 'dv_total_gastos', format_fm(monto_gastos_admin)
        page.replace_html 'dv_cantidad', tramites
        page.hide 'error'
        page.hide 'message_status1'
        page.hide 'message_status2'
        page.hide 'message_status3'
        if cantidad_solicitudes1 > 0 
          page.replace_html 'message_status1', "#{I18n.t('Sistema.Body.Vistas.General.se_han_enviado')} <a href='javascript:""' title='#{I18n.t('Sistema.Body.Modelos.Errores.tramites')}: #{numero_solicitudes1}'>#{cantidad_solicitudes1} #{I18n.t('Sistema.Body.Modelos.Errores.tramites')}</a> #{I18n.t('Sistema.Body.Vistas.General.a_la_bandeja')} '#{@descEstatus1.nombre}'." 
        end
        if cantidad_solicitudes2 > 0 
          page.replace_html 'message_status2', "#{I18n.t('Sistema.Body.Vistas.General.se_han_enviado')} <a href='javascript:""' title='#{I18n.t('Sistema.Body.Modelos.Errores.tramites')}: #{numero_solicitudes2}'>#{cantidad_solicitudes2} #{I18n.t('Sistema.Body.Modelos.Errores.tramites')}</a> #{I18n.t('Sistema.Body.Vistas.General.a_la_bandeja')} '#{@descEstatus2.nombre}'." 
        end
        if cantidad_solicitudes3 > 0 
          page.replace_html 'message_status3', "#{I18n.t('Sistema.Body.Vistas.General.se_han_enviado')} <a href='javascript:""' title='#{I18n.t('Sistema.Body.Modelos.Errores.tramites')}: #{numero_solicitudes3}'>#{cantidad_solicitudes3} #{I18n.t('Sistema.Body.Modelos.Errores.tramites')}</a> #{I18n.t('Sistema.Body.Vistas.General.a_la_bandeja')} '#{@descEstatus3.nombre}'." 
        end
        if cantidad_solicitudes1 > 0 
          page.show 'message_status1' 
        end
        if cantidad_solicitudes2 > 0 
          page.show 'message_status2' 
        end
        if cantidad_solicitudes3 > 0 
          page.show 'message_status3' 
        end
      end
      return false
    else
      render :update do |page|
        page.hide 'message'
        page.hide 'message_status1'
        page.hide 'message_status2'
        page.form_error
      end
      return false
    end
  end


  def list
    @filtros = [params[:estado_id][0], params[:solicitud][:sector_id], params[:solicitud][:sub_sector_id], params[:solicitud][:rubro_id], params[:solicitud][:sub_rubro_id], params[:solicitud][:actividad_id]]
    logger.debug "esto da los filtros " << @filtros.inspect.to_s << params.inspect.to_s
    estatus_id = 10048
    conditions = " estatus_id = #{estatus_id} "
    estatus = Estatus.find(estatus_id)    

    params['sort'] = "solicitud.numero" unless params['sort']
    
    if params['sort'] == "monto_insumo" 
      params['sort'] = "(select monto_insumos from prestamo p where p.solicitud_id = solicitud.id)" 
    end
    if params['sort'] == "monto_banco" 
      params['sort'] = "(select monto_banco from prestamo p where p.solicitud_id = solicitud.id)"  
    end
    if params['sort'] == "monto_financiamiento" 
      params['sort'] = "(select monto_solicitado from prestamo p where p.solicitud_id = solicitud.id)" 
    end
    if params['sort'] == "monto_sras_total" 
      params['sort'] = "(select monto_sras_total from prestamo p where p.solicitud_id = solicitud.id)" 
    end
    if params['sort'] == "monto_gasto_total" 
      params['sort'] = "(select monto_gasto_total from prestamo p where p.solicitud_id = solicitud.id)"
    end
    if params['sort'] == "monto_total" 
      params['sort'] = "(select monto_solicitado + monto_sras_total from prestamo p where p.solicitud_id = solicitud.id)" 
    end
          
    unless params[:estado_id].nil?
      unless params[:estado_id][0].to_s==''
        estado_id = params[:estado_id][0].to_s
        conditions += " AND unidad_produccion_id in (select up.id from unidad_produccion up, municipio m where m.id = up.municipio_id and m.estado_id = #{params[:estado_id][0].to_s})"
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.estado_igual')} '#{Estado.find(estado_id).nombre}'"
      end
    end

    unless params[:estatus_id].nil?
      unless params[:estatus_id][0].to_s==''
        estatus_id = params[:estatus_id][0].to_s.to_i            
        conditions += " AND estatus_id =  #{params[:estatus_id][0].to_s.to_i}"
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.estatus_igual')} '#{Estatus.find(estatus_id).nombre}'"
      end
    end

    unless params[:numero].to_s.nil? || params[:numero].to_s.empty?            
      conditions += " AND solicitud.numero =  #{params[:numero]}"
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.numero_tramite')} '#{params[:numero]}'"
    end

    unless params[:solicitud][:sector_id].to_s.nil? || params[:solicitud][:sector_id].to_s.empty?
      sector_id = params[:solicitud][:sector_id].to_s                
      conditions += " AND solicitud.sector_id =  #{params[:solicitud][:sector_id]}"                
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.sector_igual')} '#{Sector.find(sector_id).nombre}'"
    end

    unless params[:solicitud][:sub_sector_id].to_s.nil? || params[:solicitud][:sub_sector_id].to_s.empty?
      sub_sector_id = params[:solicitud][:sub_sector_id].to_s              
      conditions += " AND solicitud.sub_sector_id =  #{params[:solicitud][:sub_sector_id]}"                
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.sub_sector_igual')} '#{SubSector.find(sub_sector_id).nombre}'"
    end

    unless params[:solicitud][:rubro_id].to_s.nil? || params[:solicitud][:rubro_id].to_s.empty?
      rubro_id = params[:solicitud][:rubro_id].to_s              
      conditions += " AND solicitud.rubro_id =  #{params[:solicitud][:rubro_id]}"              
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.rubro_igual')} '#{Rubro.find(rubro_id).nombre}'"
    end
            
    unless params[:solicitud][:sub_rubro_id].to_s.nil? || params[:solicitud][:sub_rubro_id].to_s.empty?
      sub_rubro_id = params[:solicitud][:sub_rubro_id].to_s        
      conditions += " AND solicitud.sub_rubro_id =  #{params[:solicitud][:sub_rubro_id]}"          
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.sub_rubro_igual')} '#{SubRubro.find(sub_rubro_id).nombre}'"
    end

    unless params[:solicitud][:actividad_id].to_s.nil? || params[:solicitud][:actividad_id].to_s.empty?
      actividad_id = params[:solicitud][:actividad_id].to_s        
      conditions += " AND solicitud.actividad_id =  #{params[:solicitud][:actividad_id]}"        
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.actividad_igual')} '#{Actividad.find(actividad_id).nombre}'"
    end
    
    unless params[:moneda_id][0].blank?
      moneda = Moneda.find(params[:moneda_id][0])
      conditions << " AND solicitud.moneda_id = '#{params[:moneda_id][0].to_i}' "      
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.moneda')} #{I18n.t('Sistema.Body.Vistas.General.igual')} '#{moneda.nombre}'"
    end
            
      
    @filtro = params

    @list = Solicitud.search(conditions, params[:page], params['sort'])
    @total=@list.count


    condicion_rol = " usuario_rol.rol_id = 7 "
    @aux_roles = @usuario.roles.find(:first, :conditions=>condicion_rol)
       
    logger.debug "LISTADOOOOOOOO ----------------------- " << @list.inspect     
    @monto_bancos = 0
    @monto_insumos = 0
    @monto_sras_total = 0
    @monto_gasto_total = 0            

    @ids = ""
    @list.each do |id|
      @ids == "" ?  @ids = id.id.inspect : @ids = @ids << "," << id.id.inspect 
      logger.info " id " << id.id.inspect
        
      prestamo = Prestamo.find_by_solicitud_id(id.id)
      #prestamo_insumos = Prestamo.find_by_solicitud_id(id.id.inspect).monto_insumos
      #prestamo_sras = Prestamo.find_by_solicitud_id(id.id.inspect).monto_sras_total
      #prestamo_gasto_admin = Prestamo.find_by_solicitud_id(id.id.inspect).monto_gasto_total
      prestamo_banco = prestamo.monto_banco.to_f unless prestamo.nil?
      prestamo_insumos = prestamo.monto_insumos.to_f unless prestamo.nil?
      prestamo_sras = prestamo.monto_sras_total.to_f unless prestamo.nil?
      prestamo_gasto_admin = prestamo.monto_gasto_total.to_f unless prestamo.nil?
        
      if prestamo_banco == nil 
        prestamo_banco = 0.00 
      end
      if prestamo_insumos == nil 
        prestamo_insumos = 0.00 
      end
      if prestamo_sras == nil 
        prestamo_sras = 0.00 
      end
      if prestamo_gasto_admin == nil 
        prestamo_gasto_admin = 0.00 
      end

      @monto_bancos = @monto_bancos + prestamo_banco.to_f
      @monto_insumos = @monto_insumos + prestamo_insumos.to_f
      @monto_sras_total = @monto_sras_total + prestamo_sras.to_f
      @monto_gasto_total = @monto_gasto_total + prestamo_gasto_admin.to_f

    end
    if @ids == "" 
      @ids = "(0)" 
    end
    form_list

  end




  def view
    @solicitud = Solicitud.find(params[:id])
    @cliente = @solicitud.cliente
    @accion = params[:accion]
    @historial = DetalleReestructuracion.find(:all, :conditions=>["solicitud_id = ?", @solicitud.id])
  end

  
  def sector_change
    sub_sector_fill(params[:sector_id])
    render :update do |page|
      page.replace_html 'sub-sector-select', :partial => 'sub_sector_select'
      page.replace_html 'rubro-select', :partial => 'rubro_select'
      page.replace_html 'sub-rubro-select', :partial => 'sub_rubro_select'
      page.replace_html 'actividad-select', :partial => 'actividad_select'
      page.show 'sub-sector-select'
      page.show 'rubro-select'
    end
  end
      
  def sector_form_change
    sub_sector_fill(params[:sector_id])
    render :update do |page|
      page.replace_html 'sub-sector-select', :partial => 'sub_sector_form_select'
      page.replace_html 'rubro-select', :partial => 'rubro_form_select'
      page.replace_html 'sub-rubro-select', :partial => 'sub_rubro_select'
      page.replace_html 'actividad-select', :partial => 'actividad_select'
      page.show 'sub-sector-select'
      page.show 'rubro-select'
      page.show 'sub-rubro-select'
      page.show 'actividad-select'
    end
  end
      
  def sub_sector_change
    rubro_fill(params[:sub_sector_id])
    render :update do |page|
      page.replace_html 'rubro-select', :partial => 'rubro_select'
      page.replace_html 'sub-rubro-select', :partial => 'sub_rubro_select'
      page.replace_html 'actividad-select', :partial => 'actividad_select'
      page.show 'rubro-select'
      page.show 'sub-rubro-select'
      page.show 'actividad-select'
    end
  end
      
  def sub_sector_form_change
    rubro_fill(params[:sub_sector_id])
    render :update do |page|
      page.replace_html 'rubro-select', :partial => 'rubro_form_select'
      page.replace_html 'sub-rubro-select', :partial => 'sub_rubro_select'
      page.replace_html 'actividad-select', :partial => 'actividad_select'
      page.show 'rubro-select'
      page.show 'sub-rubro-select'
      page.show 'actividad-select'
    end
  end
        
  def rubro_change
    sub_rubro_fill(params[:rubro_id])
    render :update do |page|
      page.replace_html 'sub-rubro-select', :partial => 'sub_rubro_select'
      page.replace_html 'actividad-select', :partial => 'actividad_select'
      page.show 'sub-rubro-select'
      page.show 'actividad-select'
    end
  end

  def rubro_form_change
    sub_rubro_fill(params[:rubro_id])
    render :update do |page|
      page.replace_html 'sub-rubro-select', :partial => 'sub_rubro_form_select'
      page.replace_html 'actividad-select', :partial => 'actividad_form_select'
      page.show 'sub-rubro-select'
      page.show 'actividad-select'
    end
  end

  def sub_rubro_change
    actividad_fill(params[:sub_rubro_id])
    render :update do |page|
      page.replace_html 'actividad-select', :partial => 'actividad_select'
      page.show 'actividad-select'
    end
  end

  def sub_rubro_form_change
    actividad_fill(params[:sub_sector_id])
    render :update do |page|
      page.replace_html 'actividad-select', :partial => 'actividad_form_select'
      page.show 'actividad-select'
    end
  end



        
  protected
  def common
    super
    #@form_title = Etiquetas.etiqueta(10)
    @form_title = I18n.t('Sistema.Body.Modelos.Errores.tramites') << " " << I18n.t('Sistema.Body.Modelos.Errores.en_espera_de_fideicomiso')
    @form_title_record = I18n.t('Sistema.Body.Modelos.Errores.tramite_sin_b')
    @form_title_records = I18n.t('Sistema.Body.Modelos.Errores.tramites')
    @form_entity = 'consulta_fideicomiso'
    @form_identity_field = 'numero'
    @width_layout = '1200'
    @records_by_page = 25
    @filtros = ["0","0","0","0","0","0"]  
  end
    
    


      
end

