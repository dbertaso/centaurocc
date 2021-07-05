# encoding: utf-8

#
# autor: Marvin Alfonzo
# clase: Solicitudes::OrdenDespachoHistoricoController
# descripción: Migración a Rails 3
#


class Solicitudes::OrdenDespachoHistoricoController < FormTabsController

  layout 'form_basic'

skip_before_filter :set_charset, :only=>[:oficina_change,:estado_change,:casa_proveedora_change,:sector_change,:collapse,:expand]  

  def index
    
    @form_title = I18n.t('Sistema.Body.Menu.menu811')
    fill()
  end


  def reimpresion
    fill()
    @form_title = I18n.t('Sistema.Body.Menu.menu811')
    @municipio = Municipio.find(Oficina.find(session[:oficina]).municipio_id)
    #anterioir @estado = Estado.find(@municipio.estado_id)
    @estado = Estado.find(:all,:order=>"nombre")    
    @oficina_select=[]
    @cuenta_casa_proveedora =[]
    #@casa_proveedora_select = []
    @casa_proveedora_select = CasaProveedora.find_by_sql("select * from casa_proveedora where activo=true and tipo_cuenta <> '' order by nombre") #ciudad_id in (select id from ciudad where estado_id=#{@estado.id}) and
  end


  def view

	#unless params[:solicitud_id].nil?	
	#@orden_despacho = OrdenDespacho.find_by_solicitud_id(params[:solicitud_id])
	#else
	@orden_despacho = OrdenDespacho.find(params[:id])
	#end	

    #nuevo codigo
    @solicitud1=Solicitud.find(@orden_despacho.solicitud_id)
    @usuario_auc = Usuario.find(:first, :conditions=>['nombre_usuario = ?',@solicitud1.usuario_pre_evaluacion])
    @usuario_select1 = Usuario.find(:first, :conditions=>['cedula in (select cedula from tecnico_campo) and nombre_usuario = ? ', @solicitud1.usuario_pre_evaluacion], :order=>'primer_nombre, primer_apellido')

    #fin nuevo codigo


	@sucursal_casa_proveedora = []
	@usuario = Usuario.find(session[:id])
	@solicitudes  = Solicitud.find(:all, :conditions => ['id = ? ', @orden_despacho.solicitud_id])


	unless @solicitudes[0].nil?
	     if !@solicitudes[0].cliente.persona_id.nil?
   
		@es_no=1
		@datos_cliente=Persona.find(@solicitudes[0].cliente.persona_id) unless @solicitudes[0].nil?
   	     else
		@es_no=2
		@datos_cliente=Empresa.find(@solicitudes[0].cliente.empresa_id) unless @solicitudes[0].nil?
	    end
	end

@orden_despacho_detalle =OrdenDespachoDetalle.find(:all, :conditions=> ['orden_despacho_id = ?',@orden_despacho.id])

	#list(@orden_despacho.id)

 #del list

    @numero_desembolso=@orden_despacho.id


    @condition = " orden_despacho_id = #{@orden_despacho.id} and cantidad > 0"

    @total = OrdenDespachoDetalle.count(:conditions=>@condition)
    @list  = OrdenDespachoDetalle.find(:all, :conditions => ['orden_despacho_id = ? and cantidad > 0', @orden_despacho.id])


	@total_saldo_entregar=0
	@total_precio_total=0
	cont=0
  diferencia=0.00
  @total_monto_confirmado=0.00
	while cont< @total

  #if OrdenDespacho.find(@numero_desembolso).estatus_id==20000 || OrdenDespacho.find(@numero_desembolso).estatus_id==20010 || OrdenDespacho.find(@numero_desembolso).estatus_id==20020
	
        # codigo nuevo al 3/9/2013 
        if ( ((@list[cont].cantidad * @list[cont].costo_real)!=@list[cont].monto_financiamiento) and (@list[cont].monto_recomendado!=0))
        
        @total_saldo_entregar+=@list[cont].monto_recomendado
        diferencia=@list[cont].monto_recomendado - @list[cont].monto_facturacion        
        
        else
        
        @total_saldo_entregar+=@list[cont].monto_financiamiento
        diferencia=@list[cont].monto_financiamiento - @list[cont].monto_facturacion
        end
        #codigo nuevo al 3/9/2013    
    
    
  #else
	  #@total_saldo_entregar+=@list[cont].monto_recomendado
    #diferencia=@list[cont].monto_recomendado - @list[cont].monto_facturacion

  #end



  @total_monto_confirmado+=@list[cont].monto_facturacion

  logger.debug "monto financiamiento = " << @list[cont].monto_financiamiento.to_s
  logger.debug "monto facturacion = " << @list[cont].monto_facturacion.to_s
  logger.debug "diferencia = " << diferencia.to_s
  if diferencia < 0
    diferencia=diferencia * -1  

  end
  
	@total_precio_total+=diferencia

  #@total_precio_total+=@list[cont].monto_facturacion
	cont+=1	
	end
  

#fin del list

  end


  def expand
    @mis_ordenes=OrdenDespachoDetalle.find(:all ,:conditions=>"orden_despacho_id = #{params[:orden_id]}") 

    unless @mis_ordenes.empty?
    condi="("
        @mis_ordenes.each{ |orden_detalle|

          condi+=orden_detalle.id.to_s << "," 
        }
    condi=condi[0,condi.length-1]      
    condi+=")"   

      logger.debug "condiciones >>>>>>>>>> " << condi.to_s


    @facturas = FacturaOrdenDespacho.find(:all,:conditions=>"emitida=true and orden_despacho_detalle_id in #{condi} ",:select=>"distinct numero_factura, sum (monto_factura) as monto_total_factura,sum (cantidad_factura) as cantidad_total_factura,casa_proveedora_id,sucursal_casa_proveedora_id,emitida,confirmada,fecha_factura,fecha_emision,factura_estatus_id,secuencia",:group=>"numero_factura,casa_proveedora_id,sucursal_casa_proveedora_id,emitida,confirmada,fecha_factura,fecha_emision,factura_estatus_id,secuencia",:order=>"secuencia")

#anteriormente estaba esto
      #@facturas = FacturaOrdenDespacho.find(:all,:conditions=>"orden_despacho_detalle_id in #{condi} ",:order=>"secuencia")    
    else
      @facturas=[]           
    end    
		render :update do |page|
  		page.<< 'if ($(\'error\')) { Element.hide(\'error\'); }'
  		page.<< 'if ($(\'message\')) { Element.hide(\'message\'); }'
      page.hide "row_#{params[:orden_id]}"
      page.insert_html :after, "row_#{params[:orden_id]}", :partial => 'detail' , :orden_id=>params[:orden_id]
  		page.visual_effect :highlight, "row_#{params[:orden_id]}_view", :duration => 1.6
    end


    #form_expand @orden
  end


  def collapse
    @mis_ordenes=OrdenDespachoDetalle.find(:all ,:conditions=>"orden_despacho_id = #{params[:orden_id]}") 

    unless @mis_ordenes.empty?
    condi="("
        @mis_ordenes.each{ |orden_detalle|

          condi+=orden_detalle.id.to_s << "," 
        }
    condi=condi[0,condi.length-1]      
    condi+=")"   



      @facturas = FacturaOrdenDespacho.find(:all,:conditions=>"emitida=true and orden_despacho_detalle_id in #{condi}",:order=>"secuencia")    
    else
      @facturas=[]           
    end    

		render :update do |page|
  		page.<< 'if ($(\'error\')) { Element.hide(\'error\'); }'
  		page.<< 'if ($(\'message\')) { Element.hide(\'message\'); }'
      page.remove "row_#{params[:orden_id]}_view"
      page.show "row_#{params[:orden_id]}"
  		page.visual_effect :highlight, "row_#{params[:orden_id]}", :duration => 1.6
    end

  end


  def list_especial(oid)
  logger.info "list =============>>>>>>" << oid.inspect


    @numero_desembolso=oid


    @condition = " orden_despacho_id = #{oid} and cantidad > 0"

    @total = OrdenDespachoDetalle.count(:conditions=>@condition)
    @list  = OrdenDespachoDetalle.find(:all, :conditions => ['orden_despacho_id = ? and cantidad > 0', oid])


	@total_saldo_entregar=0
	@total_precio_total=0
	cont=0
  diferencia=0.00
  @total_monto_confirmado=0.00
	while cont< @total
  #if OrdenDespacho.find(@numero_desembolso).estatus_id==20000 || OrdenDespacho.find(@numero_desembolso).estatus_id==20010 || OrdenDespacho.find(@numero_desembolso).estatus_id==20020
	  
        # codigo nuevo al 3/9/2013 
        if ( ((@list[cont].cantidad * @list[cont].costo_real)!=@list[cont].monto_financiamiento) and (@list[cont].monto_recomendado!=0))
        
          @total_saldo_entregar+=@list[cont].monto_recomendado
          diferencia=@list[cont].monto_recomendado - @list[cont].monto_facturacion        
        
        else
        
          @total_saldo_entregar+=@list[cont].monto_financiamiento
          diferencia=@list[cont].monto_financiamiento - @list[cont].monto_facturacion
        end
        #codigo nuevo al 3/9/2013    
      
      
      
  #else
	  #@total_saldo_entregar+=@list[cont].monto_recomendado
    #diferencia=@list[cont].monto_recomendado - @list[cont].monto_facturacion
  #end

  @total_monto_confirmado+=@list[cont].monto_facturacion

  logger.debug "monto financiamiento = " << @list[cont].monto_financiamiento.to_s
  logger.debug "monto facturacion = " << @list[cont].monto_facturacion.to_s
  logger.debug "diferencia = " << diferencia.to_s
  if diferencia < 0
    diferencia=diferencia * -1  

  end
  
	@total_precio_total+=diferencia

  #@total_precio_total+=@list[cont].monto_facturacion
	cont+=1	
	end
  

    form_list
  end




   def imprimir

 # aqui guardo todos los datos que necesito para imprimirlos en las variable

    @width_layout = '955'
    @form_title = ''
    @imprimo='1'
   @orden_despacho_detalle=OrdenDespachoDetalle.find(:all,:conditions=>['orden_despacho_id = ?',params[:id]])
   orden_despacho_count=OrdenDespachoDetalle.count(:all,:conditions=>['orden_despacho_id = ?',params[:id]])



@factura_orden_despacho =FacturaOrdenDespacho.find_by_sql("select * from factura_orden_despacho where monto_factura>0 and orden_despacho_detalle_id in (select id from orden_despacho_detalle where orden_despacho_id = #{params[:id]});")

#anteriormente estaba esto @factura_orden_despacho =FacturaOrdenDespacho.find_by_orden_despacho_detalle_id(@orden_despacho_detalle[0].id)

#@factura_orden_despacho =FacturaOrdenDespacho.find(params[:factura_id])
#@factura_orden_despacho.update_attributes(:emitida=>true)

@solicitudes = Solicitud.find(:all,:conditions => ['id = ?', params[:solicitud_id]])

   unless @solicitudes[0].nil?
     if !@solicitudes[0].cliente.persona_id.nil?
   
	@es_no=1
	@datos_cliente=Persona.find(@solicitudes[0].cliente.persona_id) unless @solicitudes[0].nil?
   else
	@es_no=2
	@datos_cliente=Empresa.find(@solicitudes[0].cliente.empresa_id) unless @solicitudes[0].nil?
   end
   end

@orden_despacho= OrdenDespacho.find(:all,:conditions => ['id = ?', params[:id]])

#@facturas_totales= FacturaOrdenDespacho.count(:all,:conditions => ['orden_despacho_id = ?', @orden_despacho[0].id])

#@facturas_emitidas= FacturaOrdenDespacho.count(:all,:conditions => ['orden_despacho_id = ? and emitida=true', @orden_despacho[0].id])



#@casa_proveedora=CasaProveedora.find(:all)
#@sucursal=SucursalCasaProveedora.find(:all)

@oficina= Oficina.find(:all,:conditions => ['id = ?', @solicitudes[0].oficina_id]) unless @solicitudes[0].nil?

#if @facturas_totales == @facturas_emitidas

#OrdenDespacho.find(@orden_despacho[0].id).update_attributes(:estatus_id=> 20020)    	

#end

@parametros_general=ParametroGeneral.find(:first)

@marca=params[:marca]

#list_especial(@orden_despacho[0].id)

logger.debug "esto es lo que hay " << params[:id].to_s

list_especial(params[:id])

#@vista = 'view_orden_despacho_planilla'

 end





###todas las parciales de un solo golpe, por factura

   def imprimir_todo

 # aqui guardo todos los datos que necesito para imprimirlos en las variable

    @width_layout = '955'
    @form_title = ''
    @imprimo='1'
    
    #@ordenes_de_despacho_aux=OrdenDespachoDetalle.find(:all, :conditions=>"id in #{params[:ordenes_despachos_id]}")


   @factura_orden_despacho_otra= FacturaOrdenDespacho.find(:all, :conditions=>"orden_despacho_detalle_id in #{params[:parciales_id]} and secuencia='#{params[:secuencia]}' and monto_factura>0")

   factura_orden_despacho_count=FacturaOrdenDespacho.count(:all, :conditions=>"orden_despacho_detalle_id in #{params[:parciales_id]} and secuencia='#{params[:secuencia]}' and monto_factura>0")

@factura_orden_despacho=FacturaOrdenDespacho.find(:first, :conditions=>"orden_despacho_detalle_id in #{params[:parciales_id]} and secuencia='#{params[:secuencia]}' and monto_factura>0")


solicitu=OrdenDespacho.find(OrdenDespachoDetalle.find(@factura_orden_despacho.orden_despacho_detalle_id).orden_despacho_id).solicitud_id

@solicitudes = Solicitud.find(:all,:conditions => ['id = ?', solicitu])

   unless @solicitudes[0].nil?
     if !@solicitudes[0].cliente.persona_id.nil?
   
	@es_no=1
	@datos_cliente=Persona.find(@solicitudes[0].cliente.persona_id) unless @solicitudes[0].nil?
   else
	@es_no=2
	@datos_cliente=Empresa.find(@solicitudes[0].cliente.empresa_id) unless @solicitudes[0].nil?
   end
   end
@numero_desembolso=OrdenDespachoDetalle.find(@factura_orden_despacho.orden_despacho_detalle_id).orden_despacho_id

@orden_despacho= OrdenDespacho.find(:all,:conditions => ['id = ?', @numero_desembolso])


@oficina= Oficina.find(:all,:conditions => ['id = ?', @solicitudes[0].oficina_id]) unless @solicitudes[0].nil?


@parametros_general=ParametroGeneral.find(:first)

    @condition = " orden_despacho_id = #{@factura_orden_despacho.orden_despacho_detalle.orden_despacho_id} and cantidad > 0"

    @total = OrdenDespachoDetalle.count(:conditions=>@condition)
    @list  = OrdenDespachoDetalle.find(:all, :conditions => ['orden_despacho_id = ? and cantidad > 0', @factura_orden_despacho.orden_despacho_detalle.orden_despacho_id])

	@total_saldo_entregar=0
	@total_precio_total=0
	cont=0
  diferencia=0.00
  @total_monto_confirmado=0.00
	while cont< @total
  #if OrdenDespacho.find(@numero_desembolso).estatus_id==20000 || OrdenDespacho.find(@numero_desembolso).estatus_id==20010 || OrdenDespacho.find(@numero_desembolso).estatus_id==20020
	  
      # codigo nuevo al 3/9/2013 
        if ( ((@list[cont].cantidad * @list[cont].costo_real)!=@list[cont].monto_financiamiento) and (@list[cont].monto_recomendado!=0))
        
        @total_saldo_entregar+=@list[cont].monto_recomendado
        diferencia=@list[cont].monto_recomendado - @list[cont].monto_facturacion        
        
        else
        
        @total_saldo_entregar+=@list[cont].monto_financiamiento
        diferencia=@list[cont].monto_financiamiento - @list[cont].monto_facturacion
        end
        #codigo nuevo al 3/9/2013    
      
      
  #else
	  #@total_saldo_entregar+=@list[cont].monto_recomendado
    #diferencia=@list[cont].monto_recomendado - @list[cont].monto_facturacion
  #end

  @total_monto_confirmado+=@list[cont].monto_facturacion

  logger.debug "monto financiamiento = " << @list[cont].monto_financiamiento.to_s
  logger.debug "monto facturacion = " << @list[cont].monto_facturacion.to_s
  logger.debug "diferencia = " << diferencia.to_s
  if diferencia < 0
    diferencia=diferencia * -1  

  end
  
	@total_precio_total+=diferencia

  #@total_precio_total+=@list[cont].monto_facturacion
	cont+=1	
	end


@marca=params[:marca]

#@vista = 'view_factura_orden_despacho_parciales'

 end


##fin todas las parciales de un solo golpe, por factura


#### funcion para generar las planillas en pdf con un codigo super sencillo



  def generar_planilla_siniestro
    add_variables_to_assigns
    htmldoc_env = "HTMLDOC_NOCGI=TRUE;export HTMLDOC_NOCGI"
    generator = IO.popen("#{htmldoc_env};htmldoc -t pdf --path  \".;#{request.protocol}#{@request.env["HTTP_HOST"]}\" --footer / --fontsize 10  --webpage -", "w+")
    generator.puts @template.render("/solicitudes/orden_despacho_historico/_view_orden_despacho_planilla.rhtml")
    generator.close_write
    send_data(generator.read, :filename => "orden_despacho.pdf", :type =>  "application/pdf")
  end




###### fin de la funcion generadora del pdf



# list especial para el proceso de reimpresion y consulta
  def list

    #@orden_despacho = ViewListOrdenDespacho.find(:all)
    identificador_estado=Oficina.find(Usuario.find(session[:id]).oficina_id).ciudad.estado_id
identificador_oficina=Usuario.find(session[:id]).oficina_id


   #anterior @condition ="solicitud_id > 0 and oficina_id = #{identificador_oficina}"
    @condition ="solicitud_id > 0 "

    params['sort'] = "numero" unless params['sort']


    # busqueda por estado
    unless params[:estado_id].nil?
      unless params[:estado_id][0].to_s==''      
      @condition << " AND estado_id =  #{params[:estado_id][0].to_i}"
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.estado_igual')} '#{Estado.find(params[:estado_id][0]).nombre}'"
      logger.info "XXXXXXXXXXXX==============>>>>>>>" << @form_search_expression.inspect
      end
    end



    # busqueda por numero de tramite
    unless params[:numero].to_s==""
      @condition << " AND numero =  #{params[:numero].to_i}"
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.numero_tramite')} '#{params[:numero]}'"
      logger.info "XXXXXXXXXXXX==============>>>>>>>" << @form_search_expression.inspect
    end

    # busqueda por cedula
    unless params[:identificacion].to_s=="" 
      @condition << " AND (cedula_rif) = '#{params[:tipo].to_s}#{params[:identificacion].to_s}' "
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.rif_cedula_contenga')} '#{params[:tipo].to_s}#{params[:identificacion]}'"
    end

    # busqueda por nombre o apellido
  
    unless params[:nombre].to_s=="" 
      @condition << " AND UPPER(nombre) LIKE UPPER('%#{params[:nombre].strip}%')"
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.nombre_apellido')} '#{params[:nombre]}'"
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

 # busqueda por casa proveedora
    unless params[:casa_proveedora_id].nil?
      unless params[:casa_proveedora_id][0].to_s==''      
      casa=CasaProveedora.find(params[:casa_proveedora_id][0])            
      unless (OrdenDespachoDetalle.find_by_sql("select orden_despacho_id from orden_despacho_detalle where id in (select orden_despacho_detalle_id from factura_orden_despacho where casa_proveedora_id =#{params[:casa_proveedora_id][0]})")).empty?
      @condition << " AND orden_despacho_id in (select orden_despacho_id from orden_despacho_detalle where id in (select orden_despacho_detalle_id from factura_orden_despacho where casa_proveedora_id =#{params[:casa_proveedora_id][0]}))"
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.casa_proveedora_igual')} '#{casa.nombre}'"
      end
    end
    end

   
   if (params[:fecha_desde_f].to_s!='' && params[:fecha_hasta_f].to_s!='')        

       fecha =format_fecha_conversion(params[:fecha_desde_f])
       fecha_hasta =format_fecha_conversion(params[:fecha_hasta_f])        
        
       @condition << "and (fecha_orden_despacho >= '#{fecha}'"
       @condition << " and fecha_orden_despacho <= '#{fecha_hasta}')"
       @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.fecha_registro_desde')} '#{params[:fecha_desde_f].to_s}'"
       @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.fecha_registro_hasta')} '#{params[:fecha_hasta_f].to_s}'"                    
        
    
    # casos especiales    
    elsif (params[:fecha_desde_f].to_s=='' && params[:fecha_hasta_f].to_s!='')
        
        fecha_hasta =format_fecha_conversion(params[:fecha_hasta_f])        
        @condition << " and fecha_orden_despacho <= '#{fecha_hasta}'"
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.fecha_registro_hasta')} '#{params[:fecha_hasta_f].to_s}'"                                    
        
    
    
    elsif (params[:fecha_desde_f].to_s!='' && params[:fecha_hasta_f].to_s=='') 
        
        fecha =format_fecha_conversion(params[:fecha_desde_f])
        @condition << "and fecha_orden_despacho >= '#{fecha}'"                    
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.fecha_registro_desde')} '#{params[:fecha_desde_f].to_s}' #{I18n.t('Sistema.Body.Controladores.SearchComun.en_adelante')}"                                
    
    end  
    
    @list = ViewListOrdenDespacho.search(@condition, params[:page], params['sort'])    
    @total=@list.count


    form_list
  end





  def sector_change
    logger.info "XXXXX:::=========================>>>>>>" << params[:id].to_s
    @rubro_list = Rubro.find(:all, :conditions=>"activo=true and sector_id = #{params[:id]}", :order=>"nombre")
    render :update do |page|
      page.replace_html 'rubro-select', :partial => 'rubro_select'
    end
  end

    
  def casa_proveedora_change

    @cuenta_casa_proveedora = params[:id].to_s=='' ? [] : CasaProveedora.find(:all, :conditions=>"activo=true and id = #{params[:id]}", :order=> "numero_cuenta")


    unless @cuenta_casa_proveedora.empty?
      if @cuenta_casa_proveedora[0].tipo_pago.strip == "1"
          render :update do |page|
            page.replace_html 'cuenta-casa-proveedora-select', :partial => 'cuenta_casa_proveedora_select'      
            page.replace_html 'banco-cuenta-casa-proveedora-select', :partial => 'banco_cuenta_casa_proveedora_select'  
          
          end
      else
          render :update do |page|
            page.replace_html 'cuenta-casa-proveedora-select', :partial => 'en_blanco'      
            page.replace_html 'banco-cuenta-casa-proveedora-select', :partial => 'en_blanco'
          end
      end
    else
      render :update do |page|
        page.replace_html 'cuenta-casa-proveedora-select', :partial => 'en_blanco'      
        page.replace_html 'banco-cuenta-casa-proveedora-select', :partial => 'en_blanco'
      end
    end
  end


def estado_change

    @casa_proveedora_select=CasaProveedora.find(:all,:conditions=>["activo=true and estado_id = ?",params[:id]],:order=>"nombre")

    #@oficina_select = Oficina.find_by_sql("select * from oficina where ciudad_id in (select id from ciudad where estado_id=#{params[:id]} ) ")

    render :update do |page|
      page.replace_html 'casa-proveedora-select', :partial => 'casa_proveedora_select'      
    end
  end


  def oficina_change

    @estado_aux = Estado.find_by_sql("select estado_id from ciudad where id in (select ciudad_id from oficina where id=#{params[:id]} ) ")

    @casa_proveedora_select = CasaProveedora.find_by_sql("select * from casa_proveedora where activo=true and ciudad_id in (select id from ciudad where estado_id=#{@estado_aux[0].estado_id}) and tipo_cuenta <> '' order by nombre")

    render :update do |page|
      page.replace_html 'casa-proveedora-select', :partial => 'casa_proveedora_select'      
    end
  end

protected

  def fill
    @estado = Estado.find(:all, :order=>'nombre')
    @sector = Sector.find(:all, :conditions=>"activo=true", :order=>'nombre')
    @estatus_list = Estatus.find(:all,:conditions=>"id >=20000 and id <30000", :order=>'nombre')
    @rubro_list = []
  end

  def common
    super
    @form_title = I18n.t('Sistema.Body.Modelos.OrdenDespacho.Mensajes.orden_despacho') 
    @form_title_record = I18n.t('Sistema.Body.Modelos.OrdenDespacho.Mensajes.orden_despacho') 
    @form_title_records = I18n.t('Sistema.Body.Modelos.OrdenDespacho.Mensajes.ordenes_despachos') 
    @form_entity = 'orden_despacho_historico'
    @form_identity_field = 'id'
    @width_layout = '1180'
  end



end
