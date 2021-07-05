# encoding: utf-8

#
# autor: Marvin Alfonzo
# clase: Solicitudes::OrdenDespachoInsumoController
# descripción: Migración a Rails 3
#

class Solicitudes::OrdenDespachoInsumoController < FormTabsController

  skip_before_filter :set_charset, :only=>[:total_filtro, :entidad_financiera_change, :casa_proveedora_change, :estado_change, :oficina_change]

  def index
    fill()
    @banco_origen = BancoOrigen.find(:all, :order => 'nombre')
    @estado = Estado.find(:all, :order => 'nombre')    
  end



  def index_cheque
    fill()
    @banco_origen = BancoOrigen.find(:all, :order => 'nombre')
    @estado = Estado.find(:all, :order => 'nombre')
   @form_title = I18n.t('Sistema.Body.Modelos.OrdenDespacho.Mensajes.pago_casa_proveedora_cheque')#'Pago a Casa Proveedora por Cheque'
  end




  def list

     params['sort'] = "solicitud_id" unless params['sort']
     @condition = "solicitud_id > 0 #{params[:otra_condicion]}"
    logger.debug "parametros del list->>>>>>> " << params[:otra_condicion].to_s

    unless params[:estado_id].nil?
      unless params[:estado_id][0].to_s==''
        estado_id = params[:estado_id][0].to_s      
        @condition << " and estado_id = #{estado_id} "      
  	    @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.estado_igual')} '#{Estado.find(estado_id).nombre}'"
      end
    end

    
    unless params[:oficina_id].nil?
        unless params[:oficina_id][0].to_s==''
          oficina_id = params[:oficina_id][0].to_s
          @condition << " and oficina_id = #{oficina_id} "        
          @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.oficina_igual')} '#{Oficina.find(oficina_id).nombre}'"
        end
    end


    # busqueda por estatus orden de despacho nuevo filtro al 24/05/2013
    unless params[:estatus_orden_id].nil? 
      unless params[:estatus_orden_id][0].to_s==''
          estatus_id = params[:estatus_orden_id][0].to_s
          orden = OrdenDespacho.find_all_by_estatus_id(estatus_id)
          estatus_nombre=Estatus.find(estatus_id).nombre      
          
          unless orden.empty?
          condi="("
          orden.each{ |ordene|
            condi+=ordene.id.to_s << ","
            }
          condi=condi[0,condi.length-1]
          condi+=")"     
          @condition << " and (orden_despacho_id in #{condi})"
          else
          @condition << " and (orden_despacho_id = 0)"
          end
            
          @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.estatus_od_igual')} '#{estatus_nombre}'"
      end
    
    end
    
    unless params[:casa_proveedora_id].nil? 
      unless params[:casa_proveedora_id][0].to_s==''
          casa = CasaProveedora.find(params[:casa_proveedora_id][0])
          @condition <<" and casa_proveedora = #{params[:casa_proveedora_id][0]} "
          @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.casa_proveedora_igual')} '#{casa.nombre}'"
      end
    end


    # busqueda por numero de tramite
    unless params[:numero].to_s==''
		  id_sol=Solicitud.find_by_numero(params[:numero].to_i)       
		  if id_sol.nil?
            @condition << " AND solicitud_id = 0"  
          else
            @condition << " AND solicitud_id = #{id_sol.id}"  
          end      
          @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.numero_tramite')} '#{params[:numero]}'"
    end

    if (params[:fecha_desde].to_s!='' && params[:fecha_hasta].to_s!='')        
        logger.debug "aqui 1"
           
       fecha =format_fecha_conversion(params[:fecha_desde])
       fecha_hasta =format_fecha_conversion(params[:fecha_hasta])
       @condition << "and (fecha_factura >= '#{fecha}'"
       @condition << " and fecha_factura <= '#{fecha_hasta}')"
       @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.fecha_factura_desde')} '#{params[:fecha_desde].to_s}'"
       @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.fecha_factura_hasta')} '#{params[:fecha_hasta].to_s}'"                                
                   
    
    # casos especiales    
    elsif (params[:fecha_desde]=='' && params[:fecha_hasta].to_s!='')        
        logger.debug "aqui 2"
        
        fecha_hasta=format_fecha_conversion(params[:fecha_hasta])
        @condition << " and fecha_factura <= '#{fecha_hasta}'"
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.fecha_factura_hasta')} '#{params[:fecha_hasta].to_s}'"                                    
        
    
    
    elsif (params[:fecha_desde].to_s!='' && params[:fecha_hasta].to_s=='')
        logger.debug "aqui 3"
        
        fecha =format_fecha_conversion(params[:fecha_desde])
        @condition << "and fecha_factura >= '#{fecha}'"                    
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.fecha_factura_desde')} '#{params[:fecha_desde].to_s}' #{I18n.t('Sistema.Body.Controladores.SearchComun.en_adelante')}"                            
    
    end
    

    logger.debug "la consulta es " << @condition.inspect.to_s
    @list = ViewListOrdenDespachoInsumo.search(@condition, params[:page], params['sort'])        
    @total=@list.count
    
     @condition1 = params[:escon].to_s
    logger.debug "pruebass del list ->>>>>>>" << params.inspect.to_s

    form_list
  end

  def total_filtro
	  logger.info "consulta del total_filtro #{params[:consulta]}"      
    
    wq=params[:consulta].split("·")  
    
    
    if wq.length > 1      
      logger.debug "ESta " << wq[wq.length-1].to_s
      unless Solicitud.find_by_numero(wq[wq.length-1]).nil?
        
          #nueva condicion por el estatus de la orden agregada el 25/06/2013
          condiciones=params[:consulta]
          wq2=condiciones.split("°")
          condicion_especial=""
          if wq2.length > 1      
            estatus_id = wq2[1]
            orden = OrdenDespacho.find_all_by_estatus_id_and_solicitud_id(estatus_id,Solicitud.find_by_numero(wq[wq.length-1]).id)
            estatus_nombre=Estatus.find(estatus_id).nombre      
            
            unless orden.empty?
              condi="("
              orden.each{ |ordene|
                condi+=ordene.id.to_s << ","
                }
              condi=condi[0,condi.length-1]
              condi+=")"     
              condicion_especial << " and (orden_despacho_id in #{condi})"
            else
              condicion_especial << " and (orden_despacho_id = 0)"
            end      
                nu=wq2[0].gsub(" and orden_despacho_id=",condicion_especial)
                condiciones=nu.to_s << wq2[2].gsub("·","'")
                params[:consulta]=condiciones
                logger.debug "cocococo " << condiciones.to_s
                @total_filtro = ViewListOrdenDespachoInsumo.count(:conditions=>params[:consulta])       
          else
            nu=wq[0]<<"'#{wq[wq.length-1]}'"
            logger.debug "ssss11 " << nu.to_s
            nueva_condicion=nu.to_s      
            logger.info "nueva consulta del total_filtro #{nueva_condicion}"     
            @total_filtro = ViewListOrdenDespachoInsumo.count(:conditions=>nueva_condicion) 
          end 
            
            #fin nueva condicion por el estatus de la orden agregada el 25/06/2013        
      else
          #nueva condicion por el estatus de la orden agregada el 25/06/2013
          condiciones=params[:consulta]
          wq2=condiciones.split("°")
          condicion_especial=""
          if wq2.length > 1      
            estatus_id = wq2[1]
            orden = OrdenDespacho.find_all_by_estatus_id(estatus_id)
            estatus_nombre=Estatus.find(estatus_id).nombre      
            
            unless orden.empty?
              condi="("
              orden.each{ |ordene|
                condi+=ordene.id.to_s << ","
                }
              condi=condi[0,condi.length-1]
              condi+=")"     
              condicion_especial << " and (orden_despacho_id in #{condi})"
            else
              condicion_especial << " and (orden_despacho_id = 0)"
            end      
                nu=wq2[0].gsub(" and orden_despacho_id=",condicion_especial)
                condiciones=nu.to_s << wq2[2].gsub("·","'")
                params[:consulta]=condiciones      
                @total_filtro = ViewListOrdenDespachoInsumo.count(:conditions=>params[:consulta]) 
          else
            nu=wq[0]<<"'#{wq[wq.length-1]}'"
            logger.debug "ssss11 " << nu.to_s
            nueva_condicion=nu.to_s      
            logger.info "nueva consulta del total_filtro #{nueva_condicion}"     
            @total_filtro = ViewListOrdenDespachoInsumo.count(:conditions=>nueva_condicion) 
          end       
      end
    else
      #nueva condicion por el estatus de la orden agregada el 25/06/2013
          condiciones=params[:consulta]
          wq2=condiciones.split("°")
          condicion_especial=""
          if wq2.length > 1      
            estatus_id = wq2[1]
            orden = OrdenDespacho.find_all_by_estatus_id(estatus_id)
            estatus_nombre=Estatus.find(estatus_id).nombre      
            
            unless orden.empty?
              condi="("
              orden.each{ |ordene|
                condi+=ordene.id.to_s << ","
                }
              condi=condi[0,condi.length-1]
              condi+=")"     
              condicion_especial << " and (orden_despacho_id in #{condi})"
            else
              condicion_especial << " and (orden_despacho_id = 0)"
            end      
                nu=wq2[0].gsub(" and orden_despacho_id=",condicion_especial)
                condiciones=nu.to_s << wq2[2].to_s
                params[:consulta]=condiciones      
                @total_filtro = ViewListOrdenDespachoInsumo.count(:conditions=>params[:consulta]) 
          else
            @total_filtro = ViewListOrdenDespachoInsumo.count(:conditions=>params[:consulta])    
          end
    end
    
    
    logger.debug "pruebass de total filtro ->>>>>>>" << params[:consulta].to_s	<< " nueva condicion " << nueva_condicion.to_s	<< " tamaño " << wq.length.to_s
	  render :update do |page|
        page.hide 'errorExplanation'
        page.replace_html 'orden_cantidad_total_filtro', :partial => 'cantidad_total_filtro'        
        page.show 'orden_cantidad_total_filtro'        
    end
  end



  def entidad_financiera_change

    unless params[:id].to_s ==''
      @cuenta_bcv_fondas = CuentaBcv.find(:all, :conditions=>"activo=true and entidad_financiera_id = #{params[:id]}", :order=> "numero")
    else
      @cuenta_bcv_fondas =[]
    end  

    render :update do |page|
      page.replace_html 'cuenta_bcv-select', :partial => 'cuenta_bcv_select'
    end
  end


  def casa_proveedora_change

    unless params[:id].to_s ==''
      @cuenta_casa_proveedora = CasaProveedora.find(:all, :conditions=>"activo=true and id = #{params[:id]}", :order=> "numero_cuenta")
    else
      @cuenta_casa_proveedora =[]
    end    

    if params[:tipo_p].to_i == 1  

    render :update do |page|
      page.replace_html 'cuenta-casa-proveedora-select', :partial => 'cuenta_casa_proveedora_select'      
      page.replace_html 'banco-cuenta-casa-proveedora-select', :partial => 'banco_cuenta_casa_proveedora_select'  

    end
    
    end

  end

  def estado_change

    unless params[:id].to_s ==''
      @oficina_select = Oficina.find_by_sql("select * from oficina where ciudad_id in (select id from ciudad where estado_id=#{params[:id]} ) order by nombre")
      @casa_proveedora_select =[]
    else
      @oficina_select  =[]
      @casa_proveedora_select =[]
    end       

    render :update do |page|
      page.replace_html 'oficina-select', :partial => 'oficina_select' , :locals => {:tipo=>params[:tipo_p]}  
      page.replace_html 'casa-proveedora-select', :partial => 'casa_proveedora_select' , :locals => {:tipo=>params[:tipo_p]}      
    end
  end


  def oficina_change

    unless params[:id].to_s ==''
      @estado_aux = Estado.find_by_sql("select estado_id from ciudad where id in (select ciudad_id from oficina where id=#{params[:id]} ) ")
    else
      @estado_aux=[]
    end

    unless @estado_aux.empty? 
      @casa_proveedora_select = CasaProveedora.find_by_sql("select * from casa_proveedora where activo=true and ciudad_id in (select id from ciudad where estado_id=#{@estado_aux[0].estado_id}) and tipo_pago = '#{params[:tipo_p]}' order by nombre")
    else
      @casa_proveedora_select  =[]
    end    
    render :update do |page|
      page.replace_html 'casa-proveedora-select', :partial => 'casa_proveedora_select' , :locals => {:tipo=>params[:tipo_p]}      
      if params[:tipo_p].to_i == 1  
      page.replace_html 'cuenta-casa-proveedora-select', ""
      page.replace_html 'banco-cuenta-casa-proveedora-select', ""
      end
    end
  end





  def fill

    @estado_select = Estado.find(:all , :order =>'nombre')

    if @estado_select.length == 0
       @estado_select = []
    end


    @entidad_financiera_select = EntidadFinanciera.find(:all,:conditions=>"activo=true", :order=>'nombre')

    if @entidad_financiera_select.length == 0
       @entidad_financiera_select = []
    end

    @cuenta_bcv_fondas =[]
    @casa_proveedora_select = []
    @oficina_select=[]
    @cuenta_casa_proveedora =[]
    @oficina=[]
    @estatus_list = Estatus.find(:all,:conditions=>"id >=20000 and id <30000", :order=>'nombre')


  end

   def preparar_transferencia

    nombre = ''
    @form_title_record = I18n.t('Sistema.Body.Modelos.OrdenDespacho.Mensajes.pago_casa_proveedora_transferencia')#'Transferencias para Pago de Orden de Despacho Insumo'
   @form_title_record=I18n.t('Sistema.Body.Modelos.OrdenDespacho.Mensajes.pago_casa_proveedora_transferencia')#'Pago a Casa Proveedora por Transferencia'
    logger.info "Parametros ===> " << params.inspect
    condiciones = params[:parametros_div]
    entidad_financiera_id = params[:id_entidad_financiera][0].to_i
  
    # aqui le eliminamos el numero de solicitud
    wq=condiciones.split("·")
    
    if wq.length > 1      
      
      #wq[0].gsub(" and numero=","")
      #nu=wq[0].gsub(" and numero=","")
      #condiciones=nu.to_s 
      nu=wq[0].gsub(" and numero="," and numero='#{(wq[1].to_i).to_s}'")
      condiciones=nu.to_s
    end

      #nueva condicion por el estatus de la orden agregada el 25/06/2013
      wq2=condiciones.split("°")
      condicion_especial=""
      if wq2.length > 1      
      estatus_id = wq2[1]
      orden = OrdenDespacho.find_all_by_estatus_id(estatus_id)
      estatus_nombre=Estatus.find(estatus_id).nombre      
      
      unless orden.empty?
      condi="("
      orden.each{ |ordene|
        condi+=ordene.id.to_s << ","
        }
      condi=condi[0,condi.length-1]
      condi+=")"     
      condicion_especial << " and (orden_despacho_id in #{condi})"
      else
      condicion_especial << " and (orden_despacho_id = 0)"
      end

      
          nu=wq2[0].gsub(" and orden_despacho_id=",condicion_especial)
          condiciones=nu.to_s 
      end 
        #fin nueva condicion por el estatus de la orden agregada el 25/06/2013



    tipo_archivo = params[:txt]
    cuenta_bcv_fondas = params[:cuenta_bcv_fondas_otro][0] #verificar
    fecha_valor = params[:fecha_valor]
	  items=params[:items_id]
      logger.info 'Parametros      ====> ' << params.inspect

     #`script/runner 'OrdenDespachoInsumo.generar_transferencias(#{entidad_financiera_id.to_s},"#{tipo_archivo.to_s}","#{condiciones.to_s}","#{cuenta_bcv_fondas}","#{fecha_valor}","#{items}")'`

    OrdenDespachoInsumo.generar_transferencias(entidad_financiera_id.to_s,tipo_archivo.to_s,condiciones.to_s,cuenta_bcv_fondas,fecha_valor,items)

    @mostrar_archivo = ControlOrdenDespachoInsumo.find(:all, :conditions=>"not archivo ~* '_'",:order=>"fecha desc,id desc")


  end




  def preparar_cheque

    nombre = ''
   @form_title = I18n.t('Sistema.Body.Modelos.OrdenDespacho.Mensajes.pago_casa_proveedora_cheque')
   @form_title_record = I18n.t('Sistema.Body.Modelos.OrdenDespacho.Mensajes.pago_casa_proveedora_cheque')
    logger.info "Parametros ===> " << params.inspect
    condiciones = params[:parametros_div]
    entidad_financiera_id = params[:id_entidad_financiera][0].to_i


    # aqui le eliminamos el numero de solicitud
    wq=condiciones.split("·")
    
    if wq.length > 1      
      nu=wq[0].gsub(" and numero=","")
      condiciones=nu.to_s 
    end

        #nueva condicion por el estatus de la orden agregada el 25/06/2013
      wq2=condiciones.split("°")
      condicion_especial=""
      if wq2.length > 1      
      estatus_id = wq2[1]
      orden = OrdenDespacho.find_all_by_estatus_id(estatus_id)
      estatus_nombre=Estatus.find(estatus_id).nombre      
      
      unless orden.empty?
      condi="("
      orden.each{ |ordene|
        condi+=ordene.id.to_s << ","
        }
      condi=condi[0,condi.length-1]
      condi+=")"     
      condicion_especial << " and (orden_despacho_id in #{condi})"
      else
      condicion_especial << " and (orden_despacho_id = 0)"
      end      
          nu=wq2[0].gsub(" and orden_despacho_id=",condicion_especial)
          condiciones=nu.to_s 
      end 
        #fin nueva condicion por el estatus de la orden agregada el 25/06/2013

    modalidad = params[:cheque]
    logger.info 'MODALIDAD 111  ====> ' << modalidad.to_s
    cuenta_bcv_fondas = params[:cuenta_bcv_fondas_otro][0] #verificar
    items=params[:items_id]

    logger.info 'MODALIDAD 111  ====> ' << modalidad.to_s
    logger.info 'PARAMETROS_DIV =================>> ' << condiciones.to_s

    logger.info 'Parametros      ====> ' << params.inspect

    # `script/runner 'OrdenDespachoInsumo.generar_cheque(#{entidad_financiera_id.to_s},"#{modalidad.to_s}","#{condiciones.to_s}","#{cuenta_bcv_fondas}","#{items}")'`


    OrdenDespachoInsumo.generar_cheque(entidad_financiera_id.to_s,modalidad.to_s,condiciones.to_s,cuenta_bcv_fondas,items)

`script/runner 'OrdenDespachoInsumo.generar_cheque(#{entidad_financiera_id.to_s},"#{modalidad.to_s}","#{condiciones.to_s}","#{cuenta_bcv_fondas}","#{items}")'`

    @mostrar_archivo = ControlOrdenDespachoInsumo.find(:all, :conditions=>"archivo ~* '_'",:order=>"fecha desc")


  end



  def common
   super
   
   @form_title = I18n.t('Sistema.Body.Modelos.OrdenDespacho.Mensajes.pago_casa_proveedora_transferencia')
   @form_title_record = I18n.t('Sistema.Body.Modelos.OrdenDespacho.Mensajes.orden_pago_casa_proveedora')
   @form_title_records = I18n.t('Sistema.Body.Modelos.OrdenDespacho.Mensajes.ordenes_pago_casas_proveedoras')
   @form_entity = 'view_list_orden_despacho_insumo'
   @form_identity_field = 'orden_despacho_id'
   @width_layout = '1140'
 end

end
