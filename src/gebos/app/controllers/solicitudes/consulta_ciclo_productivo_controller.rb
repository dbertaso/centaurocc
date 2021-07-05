# encoding: utf-8

# autor: Marvin Alfonzo
# clase: Solicitudes::ConsultaCicloProductivoController
# descripción: Migración a Rails 3
#

class Solicitudes::ConsultaCicloProductivoController < FormTabsController


  skip_before_filter :set_charset, :only=>[:sector_change, :sub_sector_change, :rubro_change, :sub_rubro_change, :liberar_grupo, :liberar_solicitud]

 layout 'form_basic'

  def index
    @estado = Estado.find(:all, :order => 'nombre')
    @sector = Sector.find(:all, :conditions => 'activo=true', :order => 'nombre')
    sector_fill(0)
    @ciclo_productivo = CicloProductivo.find(:all, :order => 'nombre')
        
    @estatus = Estatus.find(:all, :order => 'nombre')
  end

  def liberar_solicitud

    estatus_id_inicial = 10005
    
    fecha_evento = Time.now
    fecha_actual_estatus = fecha_evento.strftime(I18n.t('time.formats.gebos_inverted'))  

      @solicitud = Solicitud.find(params[:solicitud_id])
        unless @solicitud.prestamos[0].total_financiamiento_fm.nil? 
          total_financiamiento = @solicitud.prestamos[0].total_financiamiento_fm
          #total_financiamiento = total_financiamiento.gsub('.','').gsub(',','.')
        else
          total_financiamiento = @solicitud.monto_solicitado
        end
        @presupuesto_pidan = PresupuestoPidan.find(:first, :conditions=>['sub_rubro_id = ? and estado_id = ? ',@solicitud.sub_rubro_id, @solicitud.unidad_produccion.municipio.estado_id])
        unless  @presupuesto_pidan.nil? 
          if  @presupuesto_pidan.disponibilidad < total_financiamiento.to_f
            estatus_id_nuevo = 10010
            accion = I18n.t('Sistema.Body.Modelos.Errores.ciclo_productivo_sin_disponibilidad_pidan')
            mensaje_envio = I18n.t('Sistema.Body.Modelos.Errores.enviado_con_exito_a_la_bandeja') << I18n.t('Sistema.Body.Modelos.Errores.en_espera_disponibilidad_presupuestaria')
          else
            @presupuesto_pidan.disponibilidad = @presupuesto_pidan.disponibilidad - total_financiamiento.to_f
            @presupuesto_pidan.compromiso = @presupuesto_pidan.compromiso + total_financiamiento.to_f
            @presupuesto_pidan.save
           
            @estatus_destino = Estatus.find_by_sql("select estatus_destino_id from configuracion_avance where estatus_origen_id = #{estatus_id_inicial}")
            estatus_id_nuevo = @estatus_destino[0].estatus_destino_id
            accion = I18n.t('Sistema.Body.Modelos.Errores.ciclo_productivo_con_disponibilidad')
            estatus = Estatus.find(estatus_id_nuevo)
            mensaje_envio = I18n.t('Sistema.Body.Modelos.Errores.enviado_con_exito_a_la_bandeja') << "'#{estatus.nombre}'"
          end
        
              ActiveRecord::Base.connection.execute("
              insert into control_solicitud 
                (fecha,estatus_id,solicitud_id,usuario_id,estatus_origen_id,accion)
                VALUES ('#{fecha_evento}',#{estatus_id_nuevo},#{@solicitud.id},#{session[:id]},#{estatus_id_inicial},'#{accion}')")
                
              ActiveRecord::Base.connection.execute("update solicitud set estatus_id = #{estatus_id_nuevo} where id = #{@solicitud.id}")

              render :update do |page|
                page.remove "row_#{@solicitud.id}"
                page.hide 'error'
                page.hide 'message_pidan'
                page.hide 'message_comite'
                page.replace_html 'message', mensaje_envio
                page.show 'message'
              end
              return false
        else
          render :update do |page|            
            page.hide 'message'
            page.hide 'message_pidan'
            page.hide 'message_comite'
            page.replace_html 'error', I18n.t('Sistema.Body.Vistas.PresupuestoPidan.Mensajes.no_existe_presupuesto_asignado')
            page.show 'error'
          end
          return false  

        end
  
  end

  def liberar_grupo
    #logger.debug "CONDICIONES ---------------------" << @params[:condiciones]
    estatus_id_inicial = 10005
    
    @grupo_solicitudes = Solicitud.find(:all,:conditions=>params[:condiciones], :order=>'id')
    cantidad_pidan = 0
    cantidad_comite = 0
    grupo_pidan = ""
    grupo_comite = ""
    acultar_solicitudes = ""
    estatus =""
    #logger.debug "SOLICITUDES ---------------------" << @grupo_solicitudes.inspect
    fecha_evento = Time.now
    fecha_actual_estatus = fecha_evento.strftime(I18n.t('time.formats.gebos_inverted'))
       
    @grupo_solicitudes.each do |solicitud|
      @solicitud = Solicitud.find(solicitud.id)
      #ojo se cambio @solicitud.rubro.ciclo_productivo.activo por @solicitud.actividad.ciclo_productivo.activo
      if @solicitud.actividad.ciclo_productivo.activo == true
          @presupuesto_pidan = PresupuestoPidan.find(:first, :conditions=>['sub_rubro_id = ? and estado_id = ? ',@solicitud.sub_rubro_id, @solicitud.unidad_produccion.municipio.estado_id])
          
          unless @presupuesto_pidan.nil?
            if  @presupuesto_pidan.disponibilidad < @solicitud.monto_solicitado 
              estatus_id_nuevo = 10010
              accion = I18n.t('Sistema.Body.Modelos.Errores.ciclo_productivo_sin_disponibilidad_pidan')
              cantidad_pidan = cantidad_pidan + 1
              grupo_pidan == "" ?  grupo_pidan  = @solicitud.numero.to_s : grupo_pidan = grupo_pidan << ", " << @solicitud.numero.to_s 
              acultar_solicitudes == "" ? acultar_solicitudes  = @solicitud.id.to_s : acultar_solicitudes = acultar_solicitudes << "," << @solicitud.id.to_s 
          
            else
              @presupuesto_pidan.disponibilidad = @presupuesto_pidan.disponibilidad - @solicitud.monto_solicitado
              @presupuesto_pidan.compromiso = @presupuesto_pidan.compromiso + @solicitud.monto_solicitado
              @presupuesto_pidan.save
          
              cantidad_comite = cantidad_comite + 1
              grupo_comite == "" ?  grupo_comite  = @solicitud.numero.to_s : grupo_comite = grupo_comite << ", " << @solicitud.numero.to_s 
              acultar_solicitudes == "" ? acultar_solicitudes  = @solicitud.id.to_s : acultar_solicitudes = acultar_solicitudes << "," << @solicitud.id.to_s 
        
              @estatus_destino = Estatus.find_by_sql("select estatus_destino_id from configuracion_avance where estatus_origen_id = #{estatus_id_inicial}")
              estatus_id_nuevo = @estatus_destino[0].estatus_destino_id
              accion = I18n.t('Sistema.Body.Modelos.Errores.ciclo_productivo_con_disponibilidad')
              estatus = Estatus.find(estatus_id_nuevo)
            
            end 
            ActiveRecord::Base.connection.execute("insert into control_solicitud (fecha,estatus_id,solicitud_id,usuario_id,estatus_origen_id,accion) VALUES ('#{fecha_evento}',#{estatus_id_nuevo},#{@solicitud.id},#{session[:id]},#{estatus_id_inicial},'#{accion}')")
            ActiveRecord::Base.connection.execute("update solicitud set estatus_id = #{estatus_id_nuevo} where id = #{@solicitud.id}")      
          else
            render :update do |page|            
              page.hide 'message'
              page.hide 'message_pidan'
              page.hide 'message_comite'
              page.replace_html 'error', I18n.t('Sistema.Body.Vistas.PresupuestoPidan.Mensajes.no_existe_presupuesto_asignado')
              page.show 'error'
            end
            return false  
          end
      end
    end

     render :update do |page|
        page.hide 'error'
        page.hide 'message'
        
        acultar_solicitudes = acultar_solicitudes.split(',')
         acultar_solicitudes.each {|solicitud|
          page.remove "row_#{solicitud}"          
          if grupo_pidan != ""  
            page.replace_html 'message_pidan', "#{I18n.t('Sistema.Body.Modelos.Errores.se_han_enviado')}<a href='javascript:""' title='#{I18n.t('Sistema.Body.Controladores.ConsultaCicloProductivo.FormTitles.form_title_records')}:#{grupo_pidan}'>#{cantidad_pidan} #{I18n.t('Sistema.Body.Controladores.ConsultaCicloProductivo.FormTitles.form_title_records')}</a> #{I18n.t('Sistema.Body.Vistas.General.a')} #{I18n.t('Sistema.Body.Vistas.General.la')} #{I18n.t('Sistema.Body.Vistas.General.bandeja')} #{I18n.t('Sistema.Body.Modelos.Errores.en_espera_disponibilidad_presupuestaria')}." 
          end
          if grupo_comite != ""
            page.replace_html 'message_comite', "#{I18n.t('Sistema.Body.Modelos.Errores.se_han_enviado')}<a href='javascript:""' title='#{I18n.t('Sistema.Body.Controladores.ConsultaCicloProductivo.FormTitles.form_title_records')}:#{grupo_comite}'>#{cantidad_comite} #{I18n.t('Sistema.Body.Controladores.ConsultaCicloProductivo.FormTitles.form_title_records')}</a> #{I18n.t('Sistema.Body.Vistas.General.a')} #{I18n.t('Sistema.Body.Vistas.General.la')} #{I18n.t('Sistema.Body.Vistas.General.bandeja')} '#{estatus.nombre}'." 
          end
          if grupo_pidan != "" 
            page.show 'message_pidan' 
          end
          if grupo_comite != "" 
            page.show 'message_comite' 
          end
        }
     end

    return false
  
  end

  def list

    estatus_id = 10005
    conditions = " solicitud.estatus_id = #{estatus_id} "
    estatus = Estatus.find(estatus_id)
    @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.estatus_igual')} '#{estatus.nombre}'"

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
    if params['sort'] == "monto_total" 
      params['sort'] = "(select monto_solicitado + monto_sras_total from prestamo p where p.solicitud_id = solicitud.id)" 
    end
          
    unless params[:estado_id].nil?
      unless params[:estado_id][0].to_s==''
  		  estado_id = params[:estado_id][0].to_s		  
  		  conditions = "#{conditions}  AND unidad_produccion_id in (select up.id from unidad_produccion up, municipio m where m.id = up.municipio_id and m.estado_id = #{estado_id})"      
  		  @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.estado_igual')} '#{Estado.find(estado_id).nombre}'"		  
      end
    end

    unless params[:estatus_id].to_s.nil? || params[:estatus_id].blank?
      if params[:estatus_id][0].to_s.to_i!=0
  		  estatus_id = params[:estatus_id][0].to_s		  
  		  conditions = "#{conditions}  AND estatus_id =  #{estatus_id}"		  
  		  @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.estatus_igual')} '#{Estatus.find(estatus_id).nombre}'"
      end
    end
 
    unless params[:solicitud][:ciclo_productivo_id].to_s.nil? || params[:solicitud][:ciclo_productivo_id].to_s.empty?
        ciclo_productivo_id = params[:solicitud][:ciclo_productivo_id].to_s        
        conditions = "#{conditions}  AND solicitud.actividad_id in ( select id from actividad where ciclo_productivo_id =  #{ciclo_productivo_id})"        
    		@form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.ciclo_productivo_igual')} '#{CicloProductivo.find(ciclo_productivo_id).nombre}'"
    end
     
      unless params[:solicitud][:sector_id].to_s.nil? || params[:solicitud][:sector_id].to_s.empty?
          sector_id = params[:solicitud][:sector_id].to_s          
          conditions = "#{conditions}  AND solicitud.sector_id =  #{sector_id}"         
		      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.sector_igual')} '#{Sector.find(sector_id).nombre}'"
      end

      unless params[:sub_sector_id].to_s.nil? || params[:sub_sector_id].blank?
        if params[:sub_sector_id][0].to_s.to_i!=0
    			sub_sector_id = params[:sub_sector_id][0].to_s			
    			conditions = "#{conditions}  AND solicitud.sub_sector_id =  #{sub_sector_id}"
    			@form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.sub_sector_igual')} '#{SubSector.find(sub_sector_id).nombre}'"
        end
      end

      unless params[:rubro_id].to_s.nil? || params[:rubro_id].blank?
        if params[:rubro_id][0].to_s.to_i!=0
    			rubro_id = params[:rubro_id][0].to_s			
    			conditions = "#{conditions}  AND solicitud.rubro_id =  #{rubro_id}"		
    			@form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.rubro_igual')} '#{Rubro.find(rubro_id).nombre}'"
        end
      end
      
      unless params[:sub_rubro_id].to_s.nil? || params[:sub_rubro_id].blank?
        if params[:sub_rubro_id][0].to_s.to_i!=0
    			sub_rubro_id = params[:sub_rubro_id][0].to_s
    			conditions = "#{conditions} and solicitud.sub_rubro_id = " + sub_rubro_id
    			@form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.sub_rubro_igual')} '#{SubRubro.find(sub_rubro_id).nombre}'"
        end             
      end

      unless params[:actividad_id].to_s.nil? || params[:actividad_id].blank?
        if params[:actividad_id][0].to_s.to_i!=0
    			actividad_id = params[:actividad_id][0].to_s
    			conditions = "#{conditions} and solicitud.actividad_id = " + actividad_id
    			@form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.actividad_igual')} '#{Actividad.find(actividad_id).nombre}'"
		    end
      end
            
      
      @filtro = conditions
          
      @list = Solicitud.search(conditions, 
                            params[:page], 
                            params['sort'])
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
    @form_title = I18n.t('Sistema.Body.Controladores.ConsultaCicloProductivo.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.ConsultaCicloProductivo.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.ConsultaCicloProductivo.FormTitles.form_title_records')
    @form_entity = 'consulta_ciclo_productivo'
    @form_identity_field = 'nombre'
    @width_layout = '1000'
  end
    
    
  def sector_fill(sector_id)
    if sector_id > 0
      @sector_list = Sector.find(:all, :conditions=>"activo=true",:order=>'nombre')
    else
      @sector_list = []
    end
    sub_sector_fill(0)
  end
  
  def sub_sector_fill(sector_id)
    if sector_id.to_i > 0
      @sub_sector_list = SubSector.find(:all, :conditions=>['activo = true and sector_id = ?', sector_id], :order=>'nombre')
    else
      @sub_sector_list = []
    end
    rubro_fill(0)
  end
  
  def rubro_fill(sub_sector_id)
    if sub_sector_id.to_i > 0
      @rubro_list = Rubro.find(:all, :conditions=>['activo = true and sub_sector_id = ?', sub_sector_id], :order=>'nombre')
    else
      @rubro_list = []
    end
    sub_rubro_fill(0)
  end
  
  def sub_rubro_fill(id)
    if id.to_i > 0
      @sub_rubro_list = SubRubro.find(:all, :conditions=>['activo = true and rubro_id = ?', id], :order => 'nombre')
    else
      @sub_rubro_list =[]
    end
    actividad(0)
  end
  
  def actividad(id)
    if id.to_i > 0
      @actividad_list = Actividad.find(:all, :conditions=>['activo = true and sub_rubro_id = ?', id], :order => 'nombre')
    else
      @actividad_list =[]
    end
  end
end
