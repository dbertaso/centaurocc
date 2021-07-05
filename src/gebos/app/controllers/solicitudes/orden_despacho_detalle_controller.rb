# encoding: utf-8

#
# autor: Marvin Alfonzo
# clase: Solicitudes::OrdenDespachoDetalleController
# descripción: Migración a Rails 3
#

class Solicitudes::OrdenDespachoDetalleController < FormTabsController

  skip_before_filter :set_charset, :only=>[:save_multiples_confirmar_parciales,:save_explicacion_cierre,:save_nueva_orden, :eliminar_transaccion_multiple_parcial, :sucursal_casa_proveedora_change, :casa_proveedora_change, :tipo_casa_proveedora_change,:reactualizacion_emitidas]

  layout 'form_basic'

  def index
   @casa_proveedora = CasaProveedora.find(:all,:conditions=>['activo=true and estado_id = ?',Usuario.find(session[:id]).oficina.ciudad.estado_id],:order=>"nombre")
   logger.info "DDDD=============>>>>>>" << @casa_proveedora.inspect
   @sucursal_casa_proveedora = []
  end  
  
  
## validacion para las parciales

def validar_opciones_parciales(parametros,id_factura_despachos)
    
    variable='-1'
    logger.debug "entre aqui en validar opciones individual" << parametros.inspect << " con factura de despacho = " << id_factura_despachos.inspect
    @factura_orden_despacho_detalle_resultados=FacturaOrdenDespacho.find(:all,:conditions=>"id in #{id_factura_despachos}")

    otra_var=""
    @factura_orden_despacho_detalle_resultados.each do |factura_orden_despacho_detalle_resultado|


      if parametros[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle_resultado.id}"].to_f == 0 && parametros[:"monto_cantidad_facturada_#{factura_orden_despacho_detalle_resultado.id}"].to_f != 0
        variable = factura_orden_despacho_detalle_resultado.id.to_s << ";#{I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.mensajes_cantidad_factura_no_cero',:item_nombre=>factura_orden_despacho_detalle_resultado.item_nombre)}"
        break
      end

      if parametros[:"monto_cantidad_facturada_#{factura_orden_despacho_detalle_resultado.id}"].to_f == 0 && parametros[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle_resultado.id}"].to_f != 0
        variable = factura_orden_despacho_detalle_resultado.id.to_s << ";#{I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.mensajes_monto_factura_no_cero',:item_nombre=>factura_orden_despacho_detalle_resultado.item_nombre)}"
        break
      end

      if parametros[:"monto_cantidad_facturada_#{factura_orden_despacho_detalle_resultado.id}"].to_f != 0 && parametros[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle_resultado.id}"].to_f != 0
        otra_var="1"
      end
      
    end  
    if variable=="-1" && otra_var==""
      variable = "Algo" << ";#{I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.mensaje_final')}"
    end
  return variable
end

## end validacion pra las parciales

  # funciones agregadas para las multiples confirmaciones de facturas 11/06/2013  
  
  def multiples_facturas_confirmar_parciales
    @width_layout=1180
    @form_title = I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.orden_despacho_insumos') 
    @form_title_record = I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.orden_despacho_insumo') 
  end


  def save_multiples_confirmar_parciales
      correcto=false
      if params[:fecha_factura_f] !=''    
          correcto=true    
      else
        mensaje_fecha="#{I18n.t('Sistema.Body.Modelos.OrdenDespacho.Mensajes.no_se_ha_seleccionado_fecha_para_factura')} \n"
      end

      resultado=validar_opciones_parciales(params,params[:parciales_id])

      if params[:observacion]=='' || params[:numero_factura]=='' || params[:casa_proveedora_id]=='0' || !correcto || resultado !='-1'

        mensaje="#{I18n.t('Sistema.Body.Modelos.Desembolso.Errores.posee_errores_en_los_siguientes_campos')}: \n\n"

        if params[:observacion]==''
          mensaje+="#{I18n.t('Sistema.Body.Modelos.Desembolso.Errores.no_ha_escrito_observacion')} \n"
        end

        if params[:numero_factura]==''
          mensaje+="#{I18n.t('Sistema.Body.Modelos.OrdenDespacho.Mensajes.no_ha_escrito_numero_factura')} \n"
        end

        if params[:casa_proveedora_id]=='0'
          mensaje+="#{I18n.t('Sistema.Body.Modelos.Desembolso.Errores.no_ha_seleccionado_casa_proveedora')} \n"
        end


        if !correcto
          mensaje+=mensaje_fecha
        end

        render :update do |page|

          if resultado=='-1'      
            page.hide 'errorExplanation'
            page.alert mensaje
          else
            resultado_final=resultado.split(";")      	
            page.replace_html 'errorExplanation',"<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL>".html_safe << resultado_final[1].to_s.html_safe << '</UL></p>'.html_safe
            page.show 'errorExplanation'
            page.<< "window.scrollTo(0,0);"
          end    
        end

      else

          
          factura=FacturaOrdenDespacho.find(:first)
          if !factura.nil?
              factura_formateada = ('0' * (8 - params[:numero_factura].to_s.length)) + params[:numero_factura].to_s        

              errores,transaccion_id = factura.actualizar_multiples_factura_parciales(params[:parciales_id] , 
                                                 params[:casa_proveedora_id],
                                                 format_fecha_conversion(params[:fecha_factura_f]),
                                                 factura_formateada,
                                                 session[:id],params)
            logger.info "valor de errores <<<<<<<<<<<<" << errores.size.to_s << " id de la transaccion " << transaccion_id.to_s << " - " << errores.class.to_s
            if errores == ''
              
              #factura_orden_despacho = FacturaOrdenDespacho.find(errores.id)
              logger.info "valor de parciales_id <<<<<<<<<<<<" << params[:parciales_id].to_s << "id de la transaccion " << transaccion_id.to_s
              
              orden_despacho_id=FacturaOrdenDespacho.find(:first,:conditions=>"id in #{params[:parciales_id]}").orden_despacho_detalle.orden_despacho_id          
              if OrdenDespachoDetalle.sum(:cantidad,:conditions=>"orden_despacho_id=#{orden_despacho_id}") == OrdenDespachoDetalle.sum(:cantidad_facturacion,:conditions=>"orden_despacho_id=#{orden_despacho_id}")
              arr_aux=[]
              params[:parciales_id]="(0)"
              else
              arr_aux=FacturaOrdenDespacho.find(:all,:select=>"id",:conditions=>"orden_despacho_detalle_id in (select id from orden_despacho_detalle where orden_despacho_id=#{orden_despacho_id}) and length(secuencia)=(select max(length(secuencia)) from factura_orden_despacho where orden_despacho_detalle_id in (select id from orden_despacho_detalle where orden_despacho_id=#{orden_despacho_id}) )")
              end
              condi33=''
                
                if params[:transacciones].to_s.length>0              
                  params[:transacciones]=params[:transacciones].to_s+","+transaccion_id.to_s              
                else
                  params[:transacciones]=transaccion_id.to_s
                end
              unless arr_aux.empty?
                condi33="("            
                arr_aux.each{ |facr|
                condi33+=facr.id.to_s << ","
                }
                condi33=condi33[0,condi33.length-1]
                condi33+=")"
              end
              logger.debug "la sesion es " << params[:transacciones].to_s << " - " << params[:parciales_id].to_s
              params[:parciales_id]=condi33 unless arr_aux.empty?
              #al retornar despues de ir agregando  
                  flash[:notice] = I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.se_agrego_con_exito_factura') 
                  render :update do |page|      
                      new_options = {:action=>'multiples_facturas_confirmar_parciales',:controller=>'orden_despacho_detalle',:parciales_id => params[:parciales_id] ,:casa_proveedora_id => params[:casa_proveedora_id],:accion => params[:accion],:oid => params[:oid],:transacciones => params[:transacciones]}
                      page.redirect_to new_options           
                  end
            else
              params[:transacciones]=nil
              render :update do |page|
                page.hide 'message'
                page.replace_html 'errorExplanation',"<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL>".html_safe << errores.html_safe << '</UL></p>'.html_safe unless errores.empty?
                page.show 'errorExplanation'
                page.<< "window.scrollTo(0,0);"
              end
            end
          end
      end
  
  
  end
  
  def cancel_multiple_parcial
    #aqui echamos para atras todos los cambios uno por uno
    unless params[:transacciones].nil? 
        @transa=Transaccion.find(:all,:select=>"id",:conditions=>"id in (#{params[:transacciones]}) and reversada=false",:order=>"id desc")
    else
        @transa=[]
    end  
    errore=""
      
        unless @transa.empty?    
            @transa.each{ |transaccion|
            valor = Transaccion.reversar(transaccion.id)                        
            }    
            
            @ordenes_de_despacho_aux=OrdenDespachoDetalle.find(:all, :conditions=>" orden_despacho_id = #{params[:oid]} ")
            unless @ordenes_de_despacho_aux.empty?
              condi="("
              @ordenes_de_despacho_aux.each{ |orden|
                condi+=orden.id.to_s << ","
                }
              condi=condi[0,condi.length-1]
              condi+=")"
              @facturas_faltantes_aux=FacturaOrdenDespacho.find(:all, :conditions=>"orden_despacho_detalle_id in #{condi} and confirmada=false") #and length(secuencia)>1
              condi2="("
              @facturas_faltantes_aux.each{ |facturat|
                condi2+=facturat.id.to_s << ","
                }
              condi2=condi2[0,condi2.length-1]
              condi2+=")"      
             end     
          if params[:accion]=="nueva_confirmar_parciales"
            new_options = {:action=>:index,:controller=>'orden_despacho'} 
          else
            new_options = {:action=>:index,:controller=>'orden_despacho'}              
          end              
        
        else
          if params[:accion]=="nueva_confirmar_parciales"
            new_options = {:action=>:index,:controller=>'orden_despacho'}              
          else
            new_options = {:action=>:index,:controller=>'orden_despacho'}              
          end
        end
        
      #render :update do |page|       
        redirect_to new_options
      #end    
  
  end
  
  def eliminar_transaccion_multiple_parcial
      #aqui echamos para atras todos los cambios  
      valor = Transaccion.reversar(params[:transaccion_id])    
      #si es true se hizo el reverso
      render :update do |page|          
        if valor==true                
                @ordenes_de_despacho_aux=OrdenDespachoDetalle.find(:all, :conditions=>" orden_despacho_id = #{params[:oid]} ")
                unless @ordenes_de_despacho_aux.empty?
                  condi="("
                  @ordenes_de_despacho_aux.each{ |orden|
                    condi+=orden.id.to_s << ","
                    }
                  condi=condi[0,condi.length-1]
                  condi+=")"
                  @facturas_faltantes_aux=FacturaOrdenDespacho.find(:all, :conditions=>"orden_despacho_detalle_id in #{condi} and confirmada=false") #and length(secuencia)>1
                  condi2="("
                  @facturas_faltantes_aux.each{ |facturat|
                    condi2+=facturat.id.to_s << ","
                    }
                  condi2=condi2[0,condi2.length-1]
                  condi2+=")"                    
                  logger.debug "que me dio condi2 " << condi2
                 end     
              new_options = {:action=>'multiples_facturas_confirmar_parciales',:controller=>'orden_despacho_detalle',:parciales_id => condi2 ,:casa_proveedora_id => params[:casa_proveedora_id],:accion => params[:accion],:oid => params[:oid],:transacciones => params[:transacciones]}    
            
            page.hide 'error'
            page.remove "row_#{params[:transaccion_id]}"
            flash[:notice] = I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.factura_eliminada_con_exito') 
            page.redirect_to new_options             
        else
            page.hide 'message'
            page.replace_html 'errorExplanation',"<h2>#{I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.error_al_reversar',:transaccion_id=>params[:transaccion_id])}</h2><p><UL>".html_safe << valor.split(".")[1].strip.to_s << '</UL></p>'.html_safe
            page.show 'errorExplanation'
            page.<< "window.scrollTo(0,0);"        
        end
            
      end
  
  end
  
  
  def reactualizacion_emitidas          
     
     
         if OrdenDespacho.find(params[:oid]).casa_proveedora_id.to_s==''
           success=FacturaOrdenDespacho.update_all( "emitida = false, fecha_emision = CAST(NULL AS DATE), casa_proveedora_id=NULL, sucursal_casa_proveedora_id=NULL", "id in #{params[:parciales_id]}" )
           new_options = {:action=>:index,:controller=>'orden_despacho'}              
           render :update do |page|          
            page.redirect_to new_options             
           end
         else
            if params[:parciales_id]!="(0)"
                #se verifica si confirmo todos los item de la orden
                  render :update do |page|          
                    page.hide 'message' 
                    page.replace_html 'errorExplanation',"<h2>#{I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.esto_es_proforma') }</h2><p><UL>#{I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.proforma_tiene_confirmarse') }</UL></p>".html_safe
                    page.show 'errorExplanation'
                    page.<< "window.scrollTo(0,0);"   
                  end
                
            else
                success=FacturaOrdenDespacho.update_all( "emitida = false, fecha_emision = CAST(NULL AS DATE), casa_proveedora_id=NULL, sucursal_casa_proveedora_id=NULL", "id in #{params[:parciales_id]}" )
                new_options = {:action=>:index,:controller=>'orden_despacho'}              
                render :update do |page|          
                  page.redirect_to new_options                     
                end
            end
         end     
  end
  
  # fin funciones agregadas para las multiples confirmaciones de facturas 11/06/2013  
  
  def view
	
    @width_layout=1180
    @form_title = I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.orden_despacho_insumos') 
    @form_title_record = I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.orden_despacho_insumo') 
  	@orden_despacho = OrdenDespacho.find(params[:id])
  	
  	@sucursal_casa_proveedora = []
  	@usuario = Usuario.find(session[:id])

      #nuevo codigo
    @solicitud1=Solicitud.find(@orden_despacho.solicitud_id)
    @usuario_auc = Usuario.find(:first, :conditions=>['nombre_usuario = ?',@solicitud1.usuario_pre_evaluacion])
    @usuario_select1 = Usuario.find(:first, :conditions=>['cedula in (select cedula from tecnico_campo ) and nombre_usuario = ? ', @solicitud1.usuario_pre_evaluacion], :order=>'primer_nombre, primer_apellido')
      #fin nuevo codigo
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

  	list(@orden_despacho.id)

  end

  def casa_proveedora_change       

        @nueva_orden_para_sucursal=params[:nueva].to_s
        
        unless params[:tipo_casa_id].nil?
            if params[:tipo_casa_id]=='false'
              @sucursal_casa_proveedora = SucursalCasaProveedora.find_by_sql("select id,nombre from sucursal_casa_proveedora where casa_proveedora_id = #{params[:id]} and ciudad_id in (select id from ciudad where estado_id<>(select estado_id from ciudad where id=(select ciudad_id from oficina where id=#{Usuario.find(session[:id]).oficina_id})) or estado_id=(select estado_id from ciudad where id=(select ciudad_id from oficina where id=#{Usuario.find(session[:id]).oficina_id}))) order by nombre")      
            else
              @sucursal_casa_proveedora = SucursalCasaProveedora.find_by_sql("select id,nombre from sucursal_casa_proveedora where casa_proveedora_id = #{params[:id]} and ciudad_id in (select id from ciudad where estado_id=(select estado_id from ciudad where id=(select ciudad_id from oficina where id=#{Usuario.find(session[:id]).oficina_id}))) order by nombre")      
            end    
        else    
            @sucursal_casa_proveedora = SucursalCasaProveedora.find_by_sql("select id,nombre from sucursal_casa_proveedora where casa_proveedora_id = #{params[:id]} order by nombre")
        end
        logger.info "DDDD=============>>>>>> #{@nueva_orden_para_sucursal}" << @sucursal_casa_proveedora.inspect
    	   @casa=nil	
    	   @casa=CasaProveedora.find(params[:id],:conditions=>"activo=true",:order=>"nombre") unless params[:id]=='0'
         @sucursal_estado=nil if params[:id]=='0'

        render :update do |page|
          page.replace_html 'sucursal-select', :partial => 'sucursal_select'
          page.replace_html 'tipo-pago-sucursal', :partial => 'mensaje_orden_despacho'
          page.replace_html 'estado-sucursal', :partial => 'estado_sucursal'
        end


  end

  def sucursal_casa_proveedora_change
    @sucursal_estado=SucursalCasaProveedora.find(params[:id],:order=>"nombre") unless params[:id]=='0'      
    render :update do |page|      
      page.replace_html 'estado-sucursal', :partial => 'estado_sucursal'
    end
  end  
  
  def tipo_casa_proveedora_change
    
    if params[:tipo_casa_id]=='false'
      @casa_proveedora = CasaProveedora.find_by_sql("SELECT distinct (id), nombre,'' as tipo from casa_proveedora where id in (select casa_proveedora_id from sucursal_casa_proveedora where casa_proveedora_id in (select id from casa_proveedora where activo=true) and ciudad_id in (select id from ciudad where estado_id<>(select estado_id from ciudad where id=(select ciudad_id from oficina where id=#{Usuario.find(session[:id]).oficina_id})) or estado_id=(select estado_id from ciudad where id=(select ciudad_id from oficina where id=#{Usuario.find(session[:id]).oficina_id})) )) order by nombre;")      
      #@casa_proveedora = CasaProveedora.find_by_sql("select id,nombre,'' as tipo from casa_proveedora where id not in (SELECT distinct on (casa.id) casa.id FROM casa_proveedora casa JOIN sucursal_casa_proveedora sucurs ON sucurs.casa_proveedora_id = casa.id  JOIN ciudad ciu ON ciu.id = sucurs.ciudad_id  JOIN estado esta ON esta.id = ciu.estado_id where casa.activo=true and esta.id=(select estado_id from ciudad where id=(select ciudad_id from oficina where id=#{Usuario.find(session[:id]).oficina_id}))) order by tipo,nombre")      
      #@casa_proveedora = CasaProveedora.find_by_sql("select * from (SELECT distinct on (casa.id) casa.id,casa.nombre,'background-color:cadetblue' as tipo FROM casa_proveedora casa JOIN sucursal_casa_proveedora sucurs ON sucurs.casa_proveedora_id = casa.id  JOIN ciudad ciu ON ciu.id = sucurs.ciudad_id  JOIN estado esta ON esta.id = ciu.estado_id where casa.activo=true and esta.id=(select estado_id from ciudad where id=(select ciudad_id from oficina where id=#{Usuario.find(session[:id]).oficina_id})) union all select id,nombre,'' as tipo from casa_proveedora where id not in (SELECT distinct on (casa.id) casa.id FROM casa_proveedora casa JOIN sucursal_casa_proveedora sucurs ON sucurs.casa_proveedora_id = casa.id  JOIN ciudad ciu ON ciu.id = sucurs.ciudad_id  JOIN estado esta ON esta.id = ciu.estado_id where casa.activo=true and esta.id=(select estado_id from ciudad where id=(select ciudad_id from oficina where id=#{Usuario.find(session[:id]).oficina_id})))) as tempo order by tempo.tipo,tempo.nombre")
    else
      @casa_proveedora = CasaProveedora.find_by_sql("SELECT distinct (id),nombre,'' as tipo from casa_proveedora where id in (select casa_proveedora_id from sucursal_casa_proveedora where casa_proveedora_id in (select id from casa_proveedora where activo=true) and ciudad_id in (select id from ciudad where estado_id=(select estado_id from ciudad where id=(select ciudad_id from oficina where id=#{Usuario.find(session[:id]).oficina_id})))) order by nombre;")
      #@casa_proveedora = CasaProveedora.find_by_sql("SELECT distinct on (casa.id) casa.*,'' as tipo FROM casa_proveedora casa JOIN sucursal_casa_proveedora sucurs ON sucurs.casa_proveedora_id = casa.id  JOIN ciudad ciu ON ciu.id = sucurs.ciudad_id  JOIN estado esta ON esta.id = ciu.estado_id where casa.activo=true and esta.id=(select estado_id from ciudad where id=(select ciudad_id from oficina where id=#{Usuario.find(session[:id]).oficina_id}));")
    end    
    @sucursal_estado=nil 
    @sucursal_casa_proveedora=[]
    @casa=nil
    
    render :update do |page|
      page.replace_html 'casa-proveedora-select', :partial => 'casa_proveedora_select'      
      page.replace_html 'sucursal-select', :partial => 'sucursal_select'
      page.replace_html 'tipo-pago-sucursal', :partial => 'mensaje_orden_despacho'
      page.replace_html 'estado-sucursal', :partial => 'estado_sucursal'
    end
  end
  
  def edit
	
   @width_layout=1180
    @form_title = I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.orden_despacho_insumos') 
    @form_title_record = I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.orden_despacho_insumo') 

   #nuevo codigo al 21/05/2013 
   unless params[:solicitud_id].nil?	
    @orden_despacho_aux = OrdenDespacho.find_by_solicitud_id(params[:solicitud_id])
   else
    @orden_despacho_aux = OrdenDespacho.find(params[:id])
   end	
   
   estatus_prestamo_aux=Prestamo.find(@orden_despacho_aux.prestamo_id).estatus
   if estatus_prestamo_aux == 'E' || estatus_prestamo_aux == 'L' || estatus_prestamo_aux == 'C' || estatus_prestamo_aux == 'F' || estatus_prestamo_aux == 'A' 
           # el prestamo esta vencido por lo tanto no se le puede crear una orden de despacho 21/05/2013
           case estatus_prestamo_aux
                when 'E'
                  flash[:notice] = I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.no_se_puede_emitir_vencida')
                when 'L'
                  flash[:notice] = I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.no_se_puede_emitir_litigio')
                when 'C'
                  flash[:notice] = I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.no_se_puede_emitir_prestamo_cancelado')
                when 'F'
                  flash[:notice] = I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.no_se_puede_emitir_prestamo_cancelado_reestructuracion')
                else
                  flash[:notice] = I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.no_se_puede_emitir_prestamo_cancelado_reestructuracion_admn')
           end
           #render :update do |page|          
               new_options = {:action=>'index',:controller=>'orden_despacho'}
               redirect_to new_options           
           #end           
   else       
   
   # nueva validacion para los nuevos requerimientos del fondas, no permitir que una orden de despacho se cree si el prestamo esta por vencerse 21/05/2013
   plan=PlanPago.find_by_prestamo_id_and_activo(@orden_despacho_aux.prestamo_id,true)
   
       unless plan.nil?
           segundos_diferencia=(Time.now - ((plan.cuotas.sort_by{|e| -e[:id]})[0].fecha).to_time).to_i
           minutos_diferencia = (segundos_diferencia/60).to_i
           horas_diferencia = (minutos_diferencia/60).to_i
           dias_diferencia = (horas_diferencia/24).to_i
           
           
            if (dias_diferencia.abs <= ParametroGeneral.find(1).dias_max_vencimiento_ultima_cuota) 
                   
                   flash[:notice] = I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.no_se_puede_emitir_por_vencerse')
                   #render :update do |page|          
                       new_options = {:action=>'index',:controller=>'orden_despacho'}
                       redirect_to new_options               
                   #end           
            end  
       end
       #else         
           #emito la orden
           
           #@casa_proveedora = CasaProveedora.find_by_sql("SELECT distinct on (casa.id) casa.* FROM casa_proveedora casa JOIN sucursal_casa_proveedora sucurs ON sucurs.casa_proveedora_id = casa.id  JOIN ciudad ciu ON ciu.id = sucurs.ciudad_id  JOIN estado esta ON esta.id = ciu.estado_id where casa.activo=true and esta.id=(select estado_id from ciudad where id=(select ciudad_id from oficina where id=#{Usuario.find(session[:id]).oficina_id}));")
           
           #nueva sentencia al 15/8/2013
           
           hay_casa=FacturaOrdenDespacho.find(:first,:select=>"casa_proveedora_id,sucursal_casa_proveedora_id",:conditions=>"orden_despacho_detalle_id in (select id from orden_despacho_detalle where orden_despacho_id=#{params[:id]})",:order=>"id desc")
           unless hay_casa.nil?
               params[:casa_id]=hay_casa.casa_proveedora_id
               params[:casa_sucursal_id]=hay_casa.sucursal_casa_proveedora_id                      
               if params[:es].nil?                
                @casa_proveedora = CasaProveedora.find(:all,:conditions=>"activo=true",:order=>"nombre")
               else                
                unless params[:tipo_casa_id].nil?
                    if params[:tipo_casa_id]=='false'
                      #nacional
                      @casa_proveedora = CasaProveedora.find_by_sql("SELECT distinct (id), nombre,'' as tipo from casa_proveedora where id in (select casa_proveedora_id from sucursal_casa_proveedora where casa_proveedora_id in (select id from casa_proveedora where activo=true) and ciudad_id in (select id from ciudad where estado_id<>(select estado_id from ciudad where id=(select ciudad_id from oficina where id=#{Usuario.find(session[:id]).oficina_id})) or estado_id=(select estado_id from ciudad where id=(select ciudad_id from oficina where id=#{Usuario.find(session[:id]).oficina_id})))) order by nombre;")      
                      #@casa_proveedora = CasaProveedora.find_by_sql("select id,nombre,'' as tipo from casa_proveedora where id not in (SELECT distinct on (casa.id) casa.id FROM casa_proveedora casa JOIN sucursal_casa_proveedora sucurs ON sucurs.casa_proveedora_id = casa.id  JOIN ciudad ciu ON ciu.id = sucurs.ciudad_id  JOIN estado esta ON esta.id = ciu.estado_id where casa.activo=true and esta.id=(select estado_id from ciudad where id=(select ciudad_id from oficina where id=#{Usuario.find(session[:id]).oficina_id}))) order by tipo,nombre")      
                      #@casa_proveedora = CasaProveedora.find_by_sql("select * from (SELECT distinct on (casa.id) casa.id,casa.nombre,'background-color:cadetblue' as tipo FROM casa_proveedora casa JOIN sucursal_casa_proveedora sucurs ON sucurs.casa_proveedora_id = casa.id  JOIN ciudad ciu ON ciu.id = sucurs.ciudad_id  JOIN estado esta ON esta.id = ciu.estado_id where casa.activo=true and esta.id=(select estado_id from ciudad where id=(select ciudad_id from oficina where id=#{Usuario.find(session[:id]).oficina_id})) union all select id,nombre,'' as tipo from casa_proveedora where id not in (SELECT distinct on (casa.id) casa.id FROM casa_proveedora casa JOIN sucursal_casa_proveedora sucurs ON sucurs.casa_proveedora_id = casa.id  JOIN ciudad ciu ON ciu.id = sucurs.ciudad_id  JOIN estado esta ON esta.id = ciu.estado_id where casa.activo=true and esta.id=(select estado_id from ciudad where id=(select ciudad_id from oficina where id=#{Usuario.find(session[:id]).oficina_id})))) as tempo order by tempo.tipo,tempo.nombre")
                    else
                      #regional
                      @casa_proveedora = CasaProveedora.find_by_sql("SELECT distinct (id),nombre,'' as tipo from casa_proveedora where id in (select casa_proveedora_id from sucursal_casa_proveedora where casa_proveedora_id in (select id from casa_proveedora where activo=true) and ciudad_id in (select id from ciudad where estado_id=(select estado_id from ciudad where id=(select ciudad_id from oficina where id=#{Usuario.find(session[:id]).oficina_id})))) order by nombre;")
                      #@casa_proveedora = CasaProveedora.find_by_sql("SELECT distinct on (casa.id) casa.*,'' as tipo FROM casa_proveedora casa JOIN sucursal_casa_proveedora sucurs ON sucurs.casa_proveedora_id = casa.id  JOIN ciudad ciu ON ciu.id = sucurs.ciudad_id  JOIN estado esta ON esta.id = ciu.estado_id where casa.activo=true and esta.id=(select estado_id from ciudad where id=(select ciudad_id from oficina where id=#{Usuario.find(session[:id]).oficina_id}));")
                    end
                else
                  #regional
                  @casa_proveedora = CasaProveedora.find_by_sql("SELECT distinct (id),nombre,'' as tipo from casa_proveedora where id in (select casa_proveedora_id from sucursal_casa_proveedora where casa_proveedora_id in (select id from casa_proveedora where activo=true) and ciudad_id in (select id from ciudad where estado_id=(select estado_id from ciudad where id=(select ciudad_id from oficina where id=#{Usuario.find(session[:id]).oficina_id})))) order by nombre;")
                  #@casa_proveedora = CasaProveedora.find_by_sql("SELECT distinct on (casa.id) casa.*,'' as tipo FROM casa_proveedora casa JOIN sucursal_casa_proveedora sucurs ON sucurs.casa_proveedora_id = casa.id  JOIN ciudad ciu ON ciu.id = sucurs.ciudad_id  JOIN estado esta ON esta.id = ciu.estado_id where casa.activo=true and esta.id=(select estado_id from ciudad where id=(select ciudad_id from oficina where id=#{Usuario.find(session[:id]).oficina_id}));")
                end
               end           
           else
               params[:casa_id]=nil
               params[:casa_sucursal_id]=nil           
               @casa_proveedora = CasaProveedora.find_by_sql("SELECT distinct (id),nombre,'' as tipo from casa_proveedora where id in (select casa_proveedora_id from sucursal_casa_proveedora where casa_proveedora_id in (select id from casa_proveedora where activo=true) and ciudad_id in (select id from ciudad where estado_id=(select estado_id from ciudad where id=(select ciudad_id from oficina where id=#{Usuario.find(session[:id]).oficina_id})))) order by nombre;")
               #@casa_proveedora = CasaProveedora.find_by_sql("select * from (SELECT distinct on (casa.id) casa.id,casa.nombre,'background-color:cadetblue' as tipo FROM casa_proveedora casa JOIN sucursal_casa_proveedora sucurs ON sucurs.casa_proveedora_id = casa.id  JOIN ciudad ciu ON ciu.id = sucurs.ciudad_id  JOIN estado esta ON esta.id = ciu.estado_id where casa.activo=true and esta.id=(select estado_id from ciudad where id=(select ciudad_id from oficina where id=#{Usuario.find(session[:id]).oficina_id})) union all select id,nombre,'' as tipo from casa_proveedora where id not in (SELECT distinct on (casa.id) casa.id FROM casa_proveedora casa JOIN sucursal_casa_proveedora sucurs ON sucurs.casa_proveedora_id = casa.id  JOIN ciudad ciu ON ciu.id = sucurs.ciudad_id  JOIN estado esta ON esta.id = ciu.estado_id where casa.activo=true and esta.id=(select estado_id from ciudad where id=(select ciudad_id from oficina where id=#{Usuario.find(session[:id]).oficina_id})))) as tempo order by tempo.tipo,tempo.nombre")
           end
           
           

           #fin nueva sentecia
           
           #@casa_proveedora = CasaProveedora.find_by_sql("select * from casa_proveedora where id in (select casa_proveedora_id from sucursal_casa_proveedora where ciudad_id in (select ciudad_id from oficina where id=#{Usuario.find(session[:id]).oficina_id}))")

            unless params[:solicitud_id].nil?	
                @orden_despacho = OrdenDespacho.find_by_solicitud_id(params[:solicitud_id])
            else
                @orden_despacho = OrdenDespacho.find(params[:id])
            end	

            #nuevo codigo
            @solicitud1=Solicitud.find(@orden_despacho.solicitud_id)
            @usuario_auc = Usuario.find(:first, :conditions=>['nombre_usuario = ?',@solicitud1.usuario_pre_evaluacion])
            @usuario_select1 = Usuario.find(:first, :conditions=>['cedula in (select cedula from tecnico_campo ) and nombre_usuario = ? ', @solicitud1.usuario_pre_evaluacion], :order=>'primer_nombre, primer_apellido')

    #fin nuevo codigo


            @sucursal_casa_proveedora = params[:casa_id].nil?  ? [] : SucursalCasaProveedora.find(:all,:conditions=>"casa_proveedora_id=#{params[:casa_id]}")
            #@sucursal_casa_proveedora =[]
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

            list(@orden_despacho.id)
       
       
       
       #end
   
   
   
   end
	
  end

  def list(oid)
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

          #arreglar esto aqui dependiendo del estatus de la solicitud como esta en el _data
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


  def list_especial(oid)
    logger.info "list =============>>>>>>" << oid.inspect


    @numero_desembolso=oid
    @condition = " orden_despacho_id = #{oid} and cantidad > 0"

    @total = OrdenDespachoDetalle.count(:conditions=>@condition)
    @list  = OrdenDespachoDetalle.find(:all, :conditions => ['orden_despacho_id = ? and cantidad > 0', oid])    

  	@total_saldo_entregar=0
  	@total_precio_total=0
  	cont=0
  	while cont< @total

    #if OrdenDespacho.find(@numero_desembolso).estatus_id==20000 || OrdenDespacho.find(@numero_desembolso).estatus_id==20010 || OrdenDespacho.find(@numero_desembolso).estatus_id==20020

  	# codigo nuevo al 3/9/2013 
        if ( ((@list[cont].cantidad * @list[cont].costo_real)!=@list[cont].monto_financiamiento) and (@list[cont].monto_recomendado!=0))
          @total_saldo_entregar+=@list[cont].monto_recomendado        
        else        
          @total_saldo_entregar+=@list[cont].monto_financiamiento
        end
        #codigo nuevo al 3/9/2013    
    
    
    #else
    	#@total_saldo_entregar+=@list[cont].monto_recomendado
    #end  

      	@total_precio_total+=@list[cont].monto_facturacion
      	cont+=1	
	   end
    
    #@pages, @list = OrdenDespachoDetalle.find_by_orden_despacho_id(oid)
    form_list
  end



  def list_nueva(oid)
    logger.info "list =============>>>>>>" << oid.inspect


    @numero_desembolso=oid
    @condition = " orden_despacho_id = #{oid} and cantidad > 0"

    @ordenes_de_despacho=OrdenDespachoDetalle.find(:all, :conditions=>@condition)
    unless @ordenes_de_despacho.empty?
      condi="("
      @ordenes_de_despacho.each{ |orden|
        condi+=orden.id.to_s << ","
        }
      condi=condi[0,condi.length-1]
      condi+=")"
      @facturas_faltantes=FacturaOrdenDespacho.find(:all, :conditions=>"orden_despacho_detalle_id in #{condi} and confirmada='f'")
      @list=@facturas_faltantes
      @total=FacturaOrdenDespacho.count(:conditions=>"orden_despacho_detalle_id in #{condi}  and confirmada='f'")
    else
      @facturas_faltantes=[]
      @total=0    
      @list=[]
    end
    form_list
  end


  def save_edit
    logger.info "parametros save_edit >>>>>>>>>>>>" << params.inspect

    if params[:observacion]=='' || params[:sucursal_id]=='0' || params[:casa_proveedora_id]=='0'
      mensaje="#{I18n.t('Sistema.Body.Modelos.Desembolso.Errores.posee_errores_en_los_siguientes_campos')}: \n\n"
      if params[:observacion]==''
        mensaje+="#{I18n.t('Sistema.Body.Modelos.Desembolso.Errores.no_ha_escrito_observacion')} \n"
      end

      if params[:sucursal_id]=='0'
        mensaje+="#{I18n.t('Sistema.Body.Modelos.Desembolso.Errores.no_ha_seleccionado_sucursal_casa_proveedora')} \n"
      end

      if params[:casa_proveedora_id]=='0'
        mensaje+="#{I18n.t('Sistema.Body.Modelos.Desembolso.Errores.no_ha_seleccionado_casa_proveedora')} \n"
      end

      render :update do |page|
        page.alert mensaje
      end

    else
        
      despa=OrdenDespachoDetalle.find(:first)
      orde=OrdenDespacho.find(params[:id])
      if orde.prestamo.monto_inventario.to_f > 0 and orde.prestamo.monto_insumos.to_f > 0 #and orde.prestamo.monto_banco.to_f==0
        men=despa.actualizo_estatus_orden_maquinaria(params[:id],params[:casa_proveedora_id],params[:sucursal_id],session[:id],params[:observacion].to_s.strip)        
      else
        men=despa.actualizo_estatus_orden(params[:id],params[:casa_proveedora_id],params[:sucursal_id],session[:id],params[:observacion].to_s.strip)        
      end        
            
      if men.to_s.index('|').nil?
        render :update do |page|
          page.hide 'message'
          page.replace_html "errorExplanation","<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL>".html_safe << men.to_s << "</UL></p>".html_safe
          page.show 'errorExplanation'
          page.<< "window.scrollTo(0,0);"
        end
      else
        flash[:notice] = men[1,men.length] #"Se ha generado la orden de despacho con éxito"
        render :update do |page|
          page.visual_effect :pulsate, "mensaje", :duration => 46.6
          new_options = {:action=>'edit', :id=>params[:id],:casa_id=>params[:casa_proveedora_id],:casa_sucursal_id=>params[:sucursal_id],:es=>params[:es],:tipo_casa_id=>params[:tipo_casa_id]}
          logger.info "++++++++++++++++" << new_options.to_s
          page.redirect_to new_options
        end
      end

    end

  end

def explicacion_cierre
  @width_layout=1180
  @form_title = I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.orden_despacho_insumos') 
  @form_title_record = I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.orden_despacho_insumo') 
end

def save_explicacion_cierre
  logger.info "parametros save_explicacion_cierre >>>>>>>>>>>>" << params.inspect

  if params[:observacion_cerrado]==''

    mensaje="#{I18n.t('Sistema.Body.Modelos.Desembolso.Errores.posee_errores_en_los_siguientes_campos')}: \n\n"

    if params[:observacion_cerrado]==''
      mensaje+="#{I18n.t('Sistema.Body.Modelos.Desembolso.Errores.no_ha_escrito_explicacion_cerrado',:parametro=>params[:id])} \n"
    end
    render :update do |page|
     page.alert mensaje
    end

  else

    #NUEVO CODIGO
    logger.info "parametros save_nueva_orden else >>>>>>>>>>>>" << params.inspect
    #actualizamos para todas las facturas la casa proveedora y la sucursal


    @orden_despacho1212 = OrdenDespacho.find(params[:id])
    @orden_despacho1212.update_attributes(:estatus_id=> 20030,:observacion_cerrado=>params[:observacion_cerrado],:fecha_cierre=>Date.today)


    flash[:notice] = I18n.t('Sistema.Body.Modelos.OrdenDespacho.Mensajes.orden_despacho_cerrada_manualmente',:parame=>@orden_despacho1212.numero)

    render :update do |page|
      page.visual_effect :highlight, "mensaje", :duration => 46.6
      new_options = {:action=>'index',:controller=>'orden_despacho'}
      page.redirect_to new_options
    end

  end
end




def abrir_nueva_orden


  se_vencio=""
  #nuevo codigo al 21/05/2013    
  @orden_despacho_aux = OrdenDespacho.find(params[:id])   
   
  estatus_prestamo_aux=Prestamo.find(@orden_despacho_aux.prestamo_id).estatus
  if estatus_prestamo_aux == 'E' || estatus_prestamo_aux == 'L' || estatus_prestamo_aux == 'C' || estatus_prestamo_aux == 'F' || estatus_prestamo_aux == 'A' 
           # el prestamo esta vencido por lo tanto no se le puede crear una orden de despacho 21/05/2013
           case estatus_prestamo_aux
                when 'E'
                  flash[:notice] = I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.no_se_puede_emitir_vencida')
                when 'L'
                  flash[:notice] = I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.no_se_puede_emitir_litigio')
                when 'C'
                  flash[:notice] = I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.no_se_puede_emitir_prestamo_cancelado')
                when 'F'
                  flash[:notice] = I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.no_se_puede_emitir_prestamo_cancelado_reestructuracion')
                else
                  flash[:notice] = I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.no_se_puede_emitir_prestamo_cancelado_reestructuracion_admn')
           end
       new_options = {:action=>'index',:controller=>'orden_despacho'}
       redirect_to new_options                    
           
  else       
   
      # nueva validacion para los nuevos requerimientos del fondas, no permitir que una orden de despacho se cree si el prestamo esta por vencerse 21/05/2013
      plan=PlanPago.find_by_prestamo_id_and_activo(@orden_despacho_aux.prestamo_id,true)
      unless plan.nil?
        segundos_diferencia=(Time.now - ((plan.cuotas.sort_by{|e| -e[:id]})[0].fecha).to_time).to_i
        minutos_diferencia = (segundos_diferencia/60).to_i
        horas_diferencia = (minutos_diferencia/60).to_i
        dias_diferencia = (horas_diferencia/24).to_i

        if (dias_diferencia.abs <= ParametroGeneral.find(1).dias_max_vencimiento_ultima_cuota) 
          flash[:notice] =I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.no_se_puede_emitir_por_vencerse')
          logger.debug "asadaeeeeeeeee"
          se_vencio="1"
          new_options = {:action=>'index',:controller=>'orden_despacho'}
          redirect_to new_options                           
        end       
      end
      
      if se_vencio !="1"

        ##parte del edit
      	@orden_despacho = OrdenDespacho.find(params[:id])
        logger.debug "el parametro en abrir_nueva es " << params[:id]

        ##fin
        
        orden_detalle = OrdenDespachoDetalle.find(:first,:conditions=>"orden_despacho_id=#{@orden_despacho.id}")

        if !orden_detalle.nil?
          factura=FacturaOrdenDespacho.find(:first,:conditions=>"orden_despacho_detalle_id=#{orden_detalle.id}")
          if !factura.nil?
            errores = factura.crear_nueva(@orden_despacho.id)
            if errores.to_s == 'true'
              redirect_to :action => 'nueva_orden', :id => params[:id], :oid=> @orden_despacho.id,:casa_id=>params[:casa_id],:casa_sucursal_id=>params[:casa_sucursal_id],:una=>"2"          
            else
              flash[:notice] = "<p><font size='3' face='arial' color='red'>#{I18n.t('Sistema.Body.General.ocurrio_error')}</font></p><UL>".html_safe << errores << "</UL>".html_safe
              new_options = {:action=>'index',:controller=>'orden_despacho'}
              redirect_to new_options            
            end
          end
        end
      end # del if vencio
  end

end

  
def nueva_orden
  
  
  @width_layout=1180
  @form_title = I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.orden_despacho_insumos') 
  @form_title_record = I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.orden_despacho_insumo') 
  se_vencio=""
  #nuevo codigo al 21/05/2013    
  @orden_despacho_aux = OrdenDespacho.find(params[:oid])   
   
  estatus_prestamo_aux=Prestamo.find(@orden_despacho_aux.prestamo_id).estatus
  if estatus_prestamo_aux == 'E' || estatus_prestamo_aux == 'L' || estatus_prestamo_aux == 'C' || estatus_prestamo_aux == 'F' || estatus_prestamo_aux == 'A' 
           # el prestamo esta vencido por lo tanto no se le puede crear una orden de despacho 21/05/2013
           case estatus_prestamo_aux
                when 'E'
                  flash[:notice] = I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.no_se_puede_emitir_vencida')
                when 'L'
                  flash[:notice] = I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.no_se_puede_emitir_litigio')
                when 'C'
                  flash[:notice] = I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.no_se_puede_emitir_prestamo_cancelado')
                when 'F'
                  flash[:notice] = I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.no_se_puede_emitir_prestamo_cancelado_reestructuracion')
                else
                  flash[:notice] = I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.no_se_puede_emitir_prestamo_cancelado_reestructuracion_admn')
           end           
           
           new_options = {:action=>'index',:controller=>'orden_despacho'}
           redirect_to new_options
  else       
   
     # nueva validacion para los nuevos requerimientos del fondas, no permitir que una orden de despacho se cree si el prestamo esta por vencerse 21/05/2013
     plan=PlanPago.find_by_prestamo_id_and_activo(@orden_despacho_aux.prestamo_id,true)
        unless plan.nil?
           segundos_diferencia=(Time.now - ((plan.cuotas.sort_by{|e| -e[:id]})[0].fecha).to_time).to_i
           minutos_diferencia = (segundos_diferencia/60).to_i
           horas_diferencia = (minutos_diferencia/60).to_i
           dias_diferencia = (horas_diferencia/24).to_i
                    
           if (dias_diferencia.abs <= ParametroGeneral.find(1).dias_max_vencimiento_ultima_cuota) 
             flash[:notice] =I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.no_se_puede_emitir_por_vencerse')
             logger.debug "asadaeeeeeeeee"
             se_vencio="1"
             new_options = {:action=>'index',:controller=>'orden_despacho'}
             redirect_to new_options
           end       
        end
  end 
  
end
  
  
  
def save_nueva_orden
    logger.info "parametros save_nueva_orden >>>>>>>>>>>>" << params.inspect

    if params[:sucursal_id]=='0' || params[:casa_proveedora_id]=='0'

      mensaje="#{I18n.t('Sistema.Body.Modelos.Desembolso.Errores.posee_errores_en_los_siguientes_campos')}: \n\n"


      if params[:sucursal_id]=='0'
        mensaje+="#{I18n.t('Sistema.Body.Modelos.Desembolso.Errores.no_ha_seleccionado_sucursal_casa_proveedora')} \n"
      end

      if params[:casa_proveedora_id]=='0'
        mensaje+="#{I18n.t('Sistema.Body.Modelos.Desembolso.Errores.no_ha_seleccionado_casa_proveedora')} \n"
      end

      render :update do |page|
        page.alert mensaje
      end

    else

      #emito la orden
      despa=OrdenDespachoDetalle.find(:first)
      men=despa.actualizacion_nueva_factura(params[:id_todas_facturas],params[:casa_proveedora_id] , params[:sucursal_id],session[:id])        
                    
      if men.to_s.index('|').nil?                
          render :update do |page|
              page.hide 'message'
              page.replace_html 'errorExplanation',"<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL>".html_safe << men.to_s << '</UL></p>'.html_safe
              page.show 'errorExplanation'
              page.<< "window.scrollTo(0,0);"
          end
      else
          flash[:notice] = men[1,men.length] #"Se ha generado la orden de despacho con éxito"                
          render :update do |page|
            page.visual_effect :highlight, "mensaje", :duration => 46.6
            new_options = {:action=>'nueva_orden', :oid=>params[:oid], :casa_id=>params[:casa_id], :casa_sucursal_id=>params[:casa_sucursal_id], :una=>'2'}
            logger.info "++++++++++++++++" << new_options.to_s
            page.redirect_to new_options
          end
      end

    end #else principal
end

  ####una por una cada de las facturas

def abrir_nueva_factura_individual
  redirect_to :action => 'nueva_orden', :id => params[:id_factura], :oid=> params[:oid],:una=>"1"
end

  

def save_nueva_factura_individual
    logger.info "parametros save_nueva_factura_individual >>>>>>>>>>>>" << params.inspect

    if params[:sucursal_id]=='0' || params[:casa_proveedora_id]=='0'

      mensaje="#{I18n.t('Sistema.Body.Modelos.Desembolso.Errores.posee_errores_en_los_siguientes_campos')}: \n\n"


      if params[:sucursal_id]=='0'
        mensaje+="#{I18n.t('Sistema.Body.Modelos.Desembolso.Errores.no_ha_seleccionado_sucursal_casa_proveedora')} \n"
      end

      if params[:casa_proveedora_id]=='0'
        mensaje+="#{I18n.t('Sistema.Body.Modelos.Desembolso.Errores.no_ha_seleccionado_casa_proveedora')} \n"
      end

      render :update do |page|
        page.alert mensaje
      end

    else

      #NUEVO CODIGO
      logger.info "parametros save_nueva_factura_individual else >>>>>>>>>>>>" << params.inspect
      #actualizamos para todas las facturas la casa proveedora y la sucursal

      errores = FacturaOrdenDespacho.actualizacion_factura("(" << params[:id] << ")" , params[:casa_proveedora_id] , params[:sucursal_id])
      logger.info "$$$$$$$$$$$$$$$$$$$$$" << errores.class.name
      if errores.class.name !="String"
      
        #factura_orden_despacho = FacturaOrdenDespacho.find(errores.id)
        flash[:notice] = I18n.t('Sistema.Body.Modelos.OrdenDespacho.Mensajes.datos_factura_se_actualizaron_con_exito')

        una_factura=FacturaOrdenDespacho.find(params[:id])

        una_factura.update_column(:emitida, false)
        #una_factura.emitida=false      
        #una_factura.send(:update_without_callbacks)
    	
      
        render :update do |page|
          page.visual_effect :highlight, "mensaje", :duration => 46.6
          new_options = {:action=>'nueva_orden', :id=>params[:id],:oid=>params[:oid]}
          logger.info "++++++++++++++++" << new_options.to_s
          page.redirect_to new_options
        end
        
      else
        render :update do |page|
          page.hide 'message'
          page.replace_html 'errorExplanation',"<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL>".html_safe << errores.to_s << "</UL></p>".html_safe
          page.show 'errorExplanation'
          page.<< "window.scrollTo(0,0);"
        end
      end
      
    end
end



  #end



  def confirmar_individual

    @form_title=I18n.t('Sistema.Body.Modelos.OrdenDespacho.Mensajes.confirmacion_orden_despacho_contra_factura')
    @form_title_record = I18n.t('Sistema.Body.Modelos.OrdenDespacho.Mensajes.confirmacion_orden_despacho_contra_factura')

    redirect_to :action => 'nueva_confirmar', :id => params[:id],:una=>"1"

  end



  def save_confirmar_individual

    correcto=false


    if params[:fecha_factura_f] !=''


      if I18n.locale.to_s=="es" || I18n.locale.to_s=="fr" || I18n.locale.to_s=="ar" || I18n.locale.to_s=="cs" || I18n.locale.to_s=="da" || I18n.locale.to_s=="de" || I18n.locale.to_s=="fi" || I18n.locale.to_s=="hu" || I18n.locale.to_s=="it" || I18n.locale.to_s=="ru" ||  I18n.locale.to_s=="nl" || I18n.locale.to_s=="pl" || I18n.locale.to_s=="pt" || I18n.locale.to_s=="sl" || I18n.locale.to_s=="sv"
        
        fecha_fac=Date.new(params[:fecha_factura_f].to_s[6,4].to_i,
                       params[:fecha_factura_f].to_s[3,2].to_i,
                       params[:fecha_factura_f].to_s[0,2].to_i)        
        
      elsif I18n.locale.to_s=="ja"        
        
        fecha_fac=Date.new(params[:fecha_factura_f].to_s[0,4].to_i,
                       params[:fecha_factura_f].to_s[5,2].to_i,
                       params[:fecha_factura_f].to_s[8,2].to_i)        
        
      else
        
        fecha_fac=Date.new(params[:fecha_factura_f].to_s[6,4].to_i,
                       params[:fecha_factura_f].to_s[0,2].to_i,
                       params[:fecha_factura_f].to_s[3,2].to_i) 
        
      end         

      if fecha_fac <= Date.today
        correcto=true
      else
        mensaje_fecha="#{I18n.t('Sistema.Body.Modelos.OrdenDespacho.Mensajes.fecha_factura_no_puede_ser_posterior_actual')} \n"
      end

    else
      mensaje_fecha="#{I18n.t('Sistema.Body.Modelos.OrdenDespacho.Mensajes.no_se_ha_seleccionado_fecha_para_factura')} \n"
    end

    resultado=validar_opciones_individual(params,params[:id])

    if params[:observacion]=='' || params[:numero_factura]=='' || params[:casa_proveedora_id]=='0' || !correcto || resultado !='-1'

      mensaje="#{I18n.t('Sistema.Body.Modelos.Desembolso.Errores.posee_errores_en_los_siguientes_campos')}: \n\n"

      if params[:observacion]==''
        mensaje+="#{I18n.t('Sistema.Body.Modelos.Desembolso.Errores.no_ha_escrito_observacion')} \n"
      end

      if params[:numero_factura]==''
        mensaje+="#{I18n.t('Sistema.Body.Modelos.OrdenDespacho.Mensajes.no_ha_escrito_numero_factura')} \n"
      end

      if params[:casa_proveedora_id]=='0'
        mensaje+="#{I18n.t('Sistema.Body.Modelos.Desembolso.Errores.no_ha_seleccionado_casa_proveedora')} \n"
      end


      if !correcto
        mensaje+=mensaje_fecha
      end

      render :update do |page|

        if resultado=='-1'      
          page.hide 'errorExplanation'
          page.alert mensaje
        else
          resultado_final=resultado.split(";")
          page.visual_effect :highlight, "row_#{resultado_final[0].to_f}", :duration => 6.6
          page.replace_html 'errorExplanation',"<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL>".html_safe << resultado_final[1].to_s.html_safe << "</UL></p>".html_safe 
          page.show 'errorExplanation'
          page.<< "window.scrollTo(0,0);"
        end 
         
      end

    else


      factura=FacturaOrdenDespacho.find(params[:id])
      if !factura.nil?
        factura_formateada = ('0' * (8 - params[:numero_factura].to_s.length)) + params[:numero_factura].to_s
        errores = factura.actualizar_factura_individual(params[:id] , 
                                             params[:casa_proveedora_id],
                                             format_fecha_conversion(params[:fecha_factura_f]),
                                             factura_formateada,
                                             session[:id],params)
        if errores == ''
      
          #factura_orden_despacho = FacturaOrdenDespacho.find(errores.id)
          flash[:notice] = "#{I18n.t('Sistema.Body.Modelos.OrdenDespacho.Mensajes.se_actualizaron_datos_confirmacion')}"
          render :update do |page|
            new_options = {:action=>'index',:controller=>'orden_despacho'}
            #new_options = {:action=>'nueva_confirmar', :id=>params[:id]}
            logger.info "++++++++++++++++" << new_options.to_s
	          page.redirect_to new_options
          end
        else
          render :update do |page|
            page.hide 'message'
            page.replace_html 'errorExplanation',"<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL>".html_safe << errores << "</UL></p>".html_safe unless errores.nil?
            page.show 'errorExplanation'
            page.<< "window.scrollTo(0,0);"
          end
        end
      end
    end
  
  end


  ####fin de una por una

  ### parciales

  def save_confirmar_parciales

    correcto=false


    if params[:fecha_factura_f] !=''


      if I18n.locale.to_s=="es" || I18n.locale.to_s=="fr" || I18n.locale.to_s=="ar" || I18n.locale.to_s=="cs" || I18n.locale.to_s=="da" || I18n.locale.to_s=="de" || I18n.locale.to_s=="fi" || I18n.locale.to_s=="hu" || I18n.locale.to_s=="it" || I18n.locale.to_s=="ru" ||  I18n.locale.to_s=="nl" || I18n.locale.to_s=="pl" || I18n.locale.to_s=="pt" || I18n.locale.to_s=="sl" || I18n.locale.to_s=="sv"
        
        fecha_fac=Date.new(params[:fecha_factura_f].to_s[6,4].to_i,
                       params[:fecha_factura_f].to_s[3,2].to_i,
                       params[:fecha_factura_f].to_s[0,2].to_i)        
        
      elsif I18n.locale.to_s=="ja"        
        
        fecha_fac=Date.new(params[:fecha_factura_f].to_s[0,4].to_i,
                       params[:fecha_factura_f].to_s[5,2].to_i,
                       params[:fecha_factura_f].to_s[8,2].to_i)        
        
      else
        
        fecha_fac=Date.new(params[:fecha_factura_f].to_s[6,4].to_i,
                       params[:fecha_factura_f].to_s[0,2].to_i,
                       params[:fecha_factura_f].to_s[3,2].to_i) 
        
      end             

      if fecha_fac <= Date.today
        correcto=true
      else
        mensaje_fecha="#{I18n.t('Sistema.Body.Modelos.OrdenDespacho.Mensajes.fecha_factura_no_puede_ser_posterior_actual')} \n"
      end

    else
      mensaje_fecha="#{I18n.t('Sistema.Body.Modelos.OrdenDespacho.Mensajes.no_se_ha_seleccionado_fecha_para_factura')} \n"
    end

    resultado=validar_opciones_parciales(params,params[:parciales_id])

    if params[:observacion]=='' || params[:numero_factura]=='' || params[:casa_proveedora_id]=='0' || !correcto || resultado !='-1'

      mensaje="#{I18n.t('Sistema.Body.Modelos.Desembolso.Errores.posee_errores_en_los_siguientes_campos')}: \n\n"

      if params[:observacion]==''
        mensaje+="#{I18n.t('Sistema.Body.Modelos.Desembolso.Errores.no_ha_escrito_observacion')} \n"
      end

      if params[:numero_factura]==''
        mensaje+="#{I18n.t('Sistema.Body.Modelos.OrdenDespacho.Mensajes.no_ha_escrito_numero_factura')} \n"
      end

      if params[:casa_proveedora_id]=='0'
        mensaje+="#{I18n.t('Sistema.Body.Modelos.Desembolso.Errores.no_ha_seleccionado_casa_proveedora')} \n"
      end


      if !correcto
        mensaje+=mensaje_fecha
      end

      render :update do |page|

        if resultado=='-1'      
          page.hide 'errorExplanation'
          page.alert mensaje
        else
          resultado_final=resultado.split(";")
          page.visual_effect :highlight, "row_#{resultado_final[0].to_f}", :duration => 6.6
          page.replace_html 'errorExplanation',"<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL>".html_safe << resultado_final[1].to_s.html_safe << "</UL></p>".html_safe
          page.show 'errorExplanation'
          page.<< "window.scrollTo(0,0);"
        end    
      end

    else


      factura=FacturaOrdenDespacho.find(:first)
      if !factura.nil?
          factura_formateada = ('0' * (8 - params[:numero_factura].to_s.length)) + params[:numero_factura].to_s        

          errores = factura.actualizar_factura_parciales(params[:parciales_id] , 
                                             params[:casa_proveedora_id],
                                             format_fecha_conversion(params[:fecha_factura_f]),
                                             factura_formateada,
                                             session[:id],params)
        if errores == ''
      
          #factura_orden_despacho = FacturaOrdenDespacho.find(errores.id)
          logger.info "valor de parciales_id <<<<<<<<<<<<" << params[:parciales_id].to_s         
          flash[:notice] = "#{I18n.t('Sistema.Body.Modelos.OrdenDespacho.Mensajes.se_actualizaron_datos_confirmacion')}"
          render :update do |page|
           new_options = {:action=>'index',:controller=>'orden_despacho'}
            #new_options = {:action=>'nueva_confirmar_parciales', :parciales_id=>params[:parciales_id]}
            logger.info "++++++++++++++++" << new_options.to_s
	          page.redirect_to new_options
          end
        else
          render :update do |page|
            page.hide 'message'
            page.replace_html 'errorExplanation',"<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL>".html_safe << errores << "</UL></p>".html_safe unless errores.nil?
            page.show 'errorExplanation'
            page.<< "window.scrollTo(0,0);"
          end
        end
      end
    end
  end



  ##fin parciales
  
def imprimir1

    # aqui guardo todos los datos que necesito para imprimirlos en las variable
    logger.debug "jujujujuju"
    logger.info "jujujujuju22"
    @width_layout = '955'
    @form_title = ''
    @imprimo='1'
    @orden_despacho_detalle=OrdenDespachoDetalle.find(:all,:conditions=>['orden_despacho_id = ?',params[:id]])
    orden_despacho_count=OrdenDespachoDetalle.count(:all,:conditions=>['orden_despacho_id = ?',params[:id]])

    contw=0
    while contw < orden_despacho_count

      @factura_orden_despacho_otra= FacturaOrdenDespacho.find_by_orden_despacho_detalle_id(@orden_despacho_detalle[contw].id)
      @factura_orden_despacho_otra.update_column(:emitida, true)
      #@factura_orden_despacho_otra.emitida=true
      #@factura_orden_despacho_otra.send(:update_without_callbacks)
      contw+=1

    end

    @factura_orden_despacho =FacturaOrdenDespacho.find_by_orden_despacho_detalle_id(@orden_despacho_detalle[0].id)


    #@factura_orden_despacho =FacturaOrdenDespacho.find_by_sql("select * from factura_orden_despacho where orden_despacho_detalle_id in (select id from orden_despacho_detalle where orden_despacho_id = #{params[:id]});")

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

     OrdenDespacho.find(params[:id]).update_attributes(:estatus_id=> 20020)     

    #end

    @parametros_general=ParametroGeneral.find(:first)

    #list(@orden_despacho[0].id)

    #@vista = 'view_orden_despacho_planilla'

    list(params[:id])


    #@vista = 'view_orden_despacho_planilla'


      
      #render  :layout => 'form_reporte'
end

def imprimir2

    # aqui guardo todos los datos que necesito para imprimirlos en las variable

    @width_layout = '955'
    @form_title = ''
    @imprimo='1'
    @orden_despacho_detalle=OrdenDespachoDetalle.find(:all,:conditions=>['orden_despacho_id = ?',params[:id]])
    orden_despacho_count=OrdenDespachoDetalle.count(:all,:conditions=>['orden_despacho_id = ?',params[:id]])

    contw=0
    
    while contw < orden_despacho_count

      @factura_orden_despacho_otra= FacturaOrdenDespacho.find_by_orden_despacho_detalle_id(@orden_despacho_detalle[contw].id)
      @factura_orden_despacho_otra.update_column(:emitida, true)
      #@factura_orden_despacho_otra.emitida=true
      #@factura_orden_despacho_otra.send(:update_without_callbacks)
      contw+=1

    end

    @factura_orden_despacho =FacturaOrdenDespacho.find_by_orden_despacho_detalle_id(@orden_despacho_detalle[0].id)

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

    OrdenDespacho.find(params[:id]).update_attributes(:estatus_id=> 20020)     

    #end

    @parametros_general=ParametroGeneral.find(:first)

    #list(@orden_despacho[0].id)
    list(params[:id])


    @vista = 'view_orden_despacho_planilla'
    #render  :layout => 'form_reporte'
end

def imprimir3

    # aqui guardo todos los datos que necesito para imprimirlos en las variable

    @width_layout = '955'
    @form_title = ''
    @imprimo='1'
    @orden_despacho_detalle=OrdenDespachoDetalle.find(:all,:conditions=>['orden_despacho_id = ?',params[:id]])
    orden_despacho_count=OrdenDespachoDetalle.count(:all,:conditions=>['orden_despacho_id = ?',params[:id]])

    contw=0
    
    while contw < orden_despacho_count

      @factura_orden_despacho_otra= FacturaOrdenDespacho.find_by_orden_despacho_detalle_id(@orden_despacho_detalle[contw].id)
      @factura_orden_despacho_otra.update_column(:emitida, true)
      #@factura_orden_despacho_otra.emitida=true
      #@factura_orden_despacho_otra.send(:update_without_callbacks)
      contw+=1

    end

    @factura_orden_despacho =FacturaOrdenDespacho.find_by_orden_despacho_detalle_id(@orden_despacho_detalle[0].id)

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

    #estatus_mi_orden=OrdenDespacho.find(params[:id]).estatus_id
    #if (estatus_mi_orden!=20030 && estatus_mi_orden!=20040 && estatus_mi_orden!=20050)

    OrdenDespacho.find(params[:id]).update_attributes(:estatus_id=> 20020)     
    #end


    #end

    @parametros_general=ParametroGeneral.find(:first)

    #list(@orden_despacho[0].id)
    list(params[:id])
    @vista = 'view_orden_despacho_planilla'
    #render  :layout => 'form_reporte'
end


def imprimir_individual

    #aqui guardo todos los datos que necesito para imprimirlos en las variable

    @width_layout = '955'
    @form_title = ''
    @imprimo='1'


    @factura_orden_despacho= FacturaOrdenDespacho.find(params[:id])

    @orden_despacho= OrdenDespacho.find(@factura_orden_despacho.orden_despacho_detalle.orden_despacho_id) 
    @numero_desembolso=@orden_despacho.id

    # esta instruccion permite actualizar el campo sin llamar a ninguna validacion que se tenga como un before_update o algo parecido    
    @factura_orden_despacho.update_column(:emitida, true)
    #@factura_orden_despacho.emitida=true  
    #@factura_orden_despacho.send(:update_without_callbacks)


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

    #@orden_despacho= OrdenDespacho.find(:all,:conditions => ['solicitud_id = ?', params[:solicitud_id]])


    @oficina= Oficina.find(:all,:conditions => ['id = ?', @solicitudes[0].oficina_id]) unless @solicitudes[0].nil?


    #OrdenDespacho.find(@orden_despacho[0].id).update_attributes(:estatus_id=> 20020)    	


    @parametros_general=ParametroGeneral.find(:first)

    #list(@orden_despacho[0].id)
    
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
        
          if diferencia < 0
            diferencia=diferencia * -1  

            #else
          	  #@total_saldo_entregar+=@list[cont].monto_recomendado
              #diferencia=@list[cont].monto_recomendado - @list[cont].monto_facturacion
            #end
            @total_monto_confirmado+=@list[cont].monto_facturacion

            logger.debug "monto financiamiento = " << @list[cont].monto_financiamiento.to_s
            logger.debug "monto facturacion = " << @list[cont].monto_facturacion.to_s
            logger.debug "diferencia = " << diferencia.to_s            
            
          	@total_precio_total+=diferencia

            #@total_precio_total+=@list[cont].monto_facturacion
          end  
          cont+=1	
    end
      
    @vista = 'view_factura_orden_despacho_planilla'
  
end


###todas las parciales de un solo golpe, por factura

def imprimir_parciales1

    #aqui guardo todos los datos que necesito para imprimirlos en las variable

    @width_layout = '955'
    @form_title = ''
    @imprimo='1'

    @factura_orden_despacho_otra= FacturaOrdenDespacho.find(:all, :conditions=>"id in #{params[:parciales_id]}")

    factura_orden_despacho_count=FacturaOrdenDespacho.count(:all, :conditions=>"id in #{params[:parciales_id]}")

    @factura_orden_despacho=FacturaOrdenDespacho.find(:first, :conditions=>"id in #{params[:parciales_id]}")

    contw=0
    
    while contw < factura_orden_despacho_count
      @factura_orden_despacho_otra[contw].update_column(:emitida, true)
      #@factura_orden_despacho_otra[contw].emitida=true
      #@factura_orden_despacho_otra[contw].send(:update_without_callbacks)
      contw+=1

    end

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

    @orden_despacho= OrdenDespacho.find(:all,:conditions => ['solicitud_id = ?', solicitu])


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
    @vista = 'view_factura_orden_despacho_parciales'

end


def imprimir_parciales2

    # aqui guardo todos los datos que necesito para imprimirlos en las variable

    @width_layout = '955'
    @form_title = ''
    @imprimo='1'
    


    @factura_orden_despacho_otra= FacturaOrdenDespacho.find(:all, :conditions=>"id in #{params[:parciales_id]}")

    factura_orden_despacho_count=FacturaOrdenDespacho.count(:all, :conditions=>"id in #{params[:parciales_id]}")

    @factura_orden_despacho=FacturaOrdenDespacho.find(:first, :conditions=>"id in #{params[:parciales_id]}")

    contw=0
    
    while contw < factura_orden_despacho_count

      @factura_orden_despacho_otra[contw].update_column(:emitida, true)
      #@factura_orden_despacho_otra[contw].emitida=true
      #@factura_orden_despacho_otra[contw].send(:update_without_callbacks)
      contw+=1

    end

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

    @orden_despacho= OrdenDespacho.find(:all,:conditions => ['solicitud_id = ?', solicitu])


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

    @vista = 'view_factura_orden_despacho_parciales'

end


def imprimir_parciales3

 # aqui guardo todos los datos que necesito para imprimirlos en las variable

    @width_layout = '955'
    @form_title = ''
    @imprimo='1'
    


    @factura_orden_despacho_otra= FacturaOrdenDespacho.find(:all, :conditions=>"id in #{params[:parciales_id]}")

    factura_orden_despacho_count=FacturaOrdenDespacho.count(:all, :conditions=>"id in #{params[:parciales_id]}")

    @factura_orden_despacho=FacturaOrdenDespacho.find(:first, :conditions=>"id in #{params[:parciales_id]}")

    contw=0
    while contw < factura_orden_despacho_count

       @factura_orden_despacho_otra[contw].update_column(:emitida, true)
       #@factura_orden_despacho_otra[contw].emitida=true
       #@factura_orden_despacho_otra[contw].send(:update_without_callbacks)
       contw+=1

    end

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

    @orden_despacho= OrdenDespacho.find(:all,:conditions => ['solicitud_id = ?', solicitu])


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
    @vista = 'view_factura_orden_despacho_parciales'

end




##fin todas las parciales de un solo golpe, por factura


 def deshacer

   @orden_despacho_detalle=OrdenDespachoDetalle.find(:all,:conditions=>['orden_despacho_id = ?',params[:id]])
   orden_despacho_count=OrdenDespachoDetalle.count(:all,:conditions=>['orden_despacho_id = ?',params[:id]])

   contw=0
   while contw < orden_despacho_count

    @factura_orden_despacho_otra= FacturaOrdenDespacho.find_by_orden_despacho_detalle_id(@orden_despacho_detalle[contw].id)
    @factura_orden_despacho_otra.destroy
    contw+=1

   end

   flash[:notice] = I18n.t('Sistema.Body.Modelos.OrdenDespacho.Mensajes.deshacer_realizado_con_exito')

   @orden_despacho=OrdenDespacho.find(params[:id])
   @orden_despacho.update_attributes(:estatus_id=>20000)

   new_options = {:action=>'index',:controller=>'orden_despacho'}
   redirect_to new_options
 
 end



 def deshacer_parciales

   @factura_orden_despacho_otra= FacturaOrdenDespacho.find(:all, :conditions=>"id in #{params[:parciales_id]}")

   factura_orden_despacho_count=FacturaOrdenDespacho.count(:all, :conditions=>"id in #{params[:parciales_id]}")

   contw=0

           
   while contw < factura_orden_despacho_count

      @orden_des=OrdenDespachoDetalle.find(@factura_orden_despacho_otra[contw].orden_despacho_detalle_id)
      #ojo aqui
      @orden_des.update_attributes(:monto_facturacion=> @orden_des.monto_facturacion.to_f - @factura_orden_despacho_otra[contw].monto_factura.to_f,:cantidad_facturacion=>@orden_des.cantidad_facturacion.to_f - @factura_orden_despacho_otra[contw].cantidad_factura.to_f)    
      prestamo=Prestamo.find(OrdenDespacho.find(@orden_des.orden_despacho_id).prestamo_id)
      prestamo.update_attributes(:monto_despachado=> prestamo.monto_despachado.to_f - @orden_des.monto_facturacion.to_f)
      #ojo aqui no se con certeza si monto factura es el mismo monto despahado
      prestamo.update_attributes(:monto_facturado=> prestamo.monto_facturado.to_f - @orden_des.monto_facturacion.to_f)     
      @factura_orden_despacho_otra[contw].destroy
      contw+=1

   end

   flash[:notice] = I18n.t('Sistema.Body.Modelos.OrdenDespacho.Mensajes.deshacer_realizado_con_exito')

   new_options = {:action=>'index',:controller=>'orden_despacho'}
   redirect_to new_options
 
 end


 def deshacer_individual


   @factura_orden_despacho_otra= FacturaOrdenDespacho.find(params[:id])
   @orden_des=OrdenDespachoDetalle.find(@factura_orden_despacho_otra.orden_despacho_detalle_id)   #ojo aqui
   @orden_des.update_attributes(:monto_facturacion=> @orden_des.monto_facturacion.to_f - @factura_orden_despacho_otra.monto_factura.to_f,:cantidad_facturacion=>@orden_des.cantidad_facturacion.to_f - @factura_orden_despacho_otra.cantidad_factura.to_f)    
   prestamo=Prestamo.find(OrdenDespacho.find(@orden_des.orden_despacho_id).prestamo_id)
   prestamo.update_attributes(:monto_despachado=> prestamo.monto_despachado.to_f - @orden_des.monto_facturacion.to_f)
   #ojo aqui no se con certeza si monto factura es el mismo monto despahado
   prestamo.update_attributes(:monto_facturado=> prestamo.monto_facturado.to_f - @orden_des.monto_facturacion.to_f)     
   @factura_orden_despacho_otra.destroy
   flash[:notice] = I18n.t('Sistema.Body.Modelos.OrdenDespacho.Mensajes.deshacer_realizado_con_exito')
   new_options = {:action=>'index',:controller=>'orden_despacho'}
   redirect_to new_options
 
 end



def casa_proveedora_change_otra

    if params[:id] != '0'
      arre=params[:id].split(";")
      @sucursal_casa_proveedora_otra = SucursalCasaProveedora.find(arre[1])
      @casa=CasaProveedora.find(arre[0])     	
    else
      @sucursal_casa_proveedora_otra=nil
      @casa=nil
    end

    render :update do |page|
      page.replace_html 'casa-select', :partial => 'mensaje_tabla'
      page.replace_html 'sucursal-select', :partial => 'mensaje_tabla_sucursal'
    end
end



def confirmar
  @imprimio=''

  @form_title= I18n.t('Sistema.Body.Modelos.OrdenDespacho.Mensajes.confirmacion_orden_despacho_contra_factura')
  @form_title_record = I18n.t('Sistema.Body.Modelos.OrdenDespacho.Mensajes.confirmacion_orden_despacho_contra_factura')

  unless params[:solicitud_id].nil?	
	  @orden_despacho = OrdenDespacho.find_by_solicitud_id(params[:solicitud_id])
	else
	  @orden_despacho = OrdenDespacho.find(params[:id])
	end	
	@sucursal_casa_proveedora = []
	@usuario = Usuario.find(session[:id])
	@solicitudes  = Solicitud.find(:all, :conditions => ['id = ? ', @orden_despacho.solicitud_id])

  #nuevo codigo
  @solicitud1=Solicitud.find(@orden_despacho.solicitud_id)
  @usuario_auc = Usuario.find(:first, :conditions=>['nombre_usuario = ?',@solicitud1.usuario_pre_evaluacion])
  @usuario_select1 = Usuario.find(:first, :conditions=>['cedula in (select cedula from tecnico_campo ) and nombre_usuario = ? ', @solicitud1.usuario_pre_evaluacion], :order=>'primer_nombre, primer_apellido')

  #fin nuevo codigo


	unless @solicitudes[0].nil?
	     if !@solicitudes[0].cliente.persona_id.nil?   
      		@es_no=1
      		@datos_cliente=Persona.find(@solicitudes[0].cliente.persona_id) unless @solicitudes[0].nil?
   	   else
      		@es_no=2
      		@datos_cliente=Empresa.find(@solicitudes[0].cliente.empresa_id) unless @solicitudes[0].nil?
	     end
	end

	@orden_despacho_detalle=OrdenDespachoDetalle.find(:all,:conditions=>['orden_despacho_id = ?',@orden_despacho.id])


	#eliminado el 18/06/2013 @factura_casa_proveedora=FacturaOrdenDespacho.find(:all, :conditions=> ['orden_despacho_detalle_id = ? and emitida=true',@orden_despacho_detalle[0].id])	
  @factura_casa_proveedora_aux=FacturaOrdenDespacho.find(:all, :conditions=> ['orden_despacho_detalle_id = ? and emitida=true',@orden_despacho_detalle[0].id])	
  @factura_casa_proveedora=@factura_casa_proveedora_aux[0].casa_proveedora_id.to_s+";"+@factura_casa_proveedora_aux[0].sucursal_casa_proveedora_id.to_s
  logger.debug "casa proveedora " << @factura_casa_proveedora.inspect.to_s
	list_especial(@orden_despacho.id)

end

def validar_opciones(parametros,id_orden_despacho)
    
    variable='-1'
    logger.debug "entre aqui en validar opciones " << parametros.inspect << " con orden de despacho = " << id_orden_despacho.inspect

    @orden_despacho_detalle_resultados=OrdenDespachoDetalle.find(:all,:conditions=>['orden_despacho_id = ?',id_orden_despacho])
    otra_var=""
    @orden_despacho_detalle_resultados.each do |orden_despacho_detalle_resultado|
    #antes estaba esto en la validacion parametros[:"monto_cantidad_faltante_#{orden_despacho_detalle_resultado.id}"] == '' ||
      

      if parametros[:"monto_cantidad_faltante_#{orden_despacho_detalle_resultado.id}"].to_f == 0 && parametros[:"monto_cantidad_facturada_#{orden_despacho_detalle_resultado.id}"].to_f != 0
        variable = orden_despacho_detalle_resultado.id.to_s << ";#{I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.mensajes_cantidad_factura_no_cero',:item_nombre=>PlanInversion.find(orden_despacho_detalle_resultado.plan_inversion_id).item_nombre)}"
        break
      end

      
      if parametros[:"monto_cantidad_facturada_#{orden_despacho_detalle_resultado.id}"].to_f == 0 && parametros[:"monto_cantidad_faltante_#{orden_despacho_detalle_resultado.id}"].to_f != 0
        variable = orden_despacho_detalle_resultado.id.to_s << ";#{I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.mensajes_monto_factura_no_cero',:item_nombre=>PlanInversion.find(orden_despacho_detalle_resultado.plan_inversion_id).item_nombre)}"
        break
      end

  	  if parametros[:"monto_cantidad_facturada_#{orden_despacho_detalle_resultado.id}"].to_f != 0 && parametros[:"monto_cantidad_faltante_#{orden_despacho_detalle_resultado.id}"].to_f != 0
  		  otra_var="1"
  	  end

    end      
    if variable=="-1" && otra_var==""
      variable = "Algo" << ";#{I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.mensaje_final')}"
    end
  return variable
end



def validar_opciones_individual(parametros,id_factura_despacho)
    
    variable='-1'
    logger.debug "entre aqui en validar opciones individual" << parametros.inspect << " con factura de despacho = " << id_factura_despacho.inspect

    factura_despacho_detalle_resultado=FacturaOrdenDespacho.find(id_factura_despacho)    

    if parametros[:"monto_cantidad_faltante_#{factura_despacho_detalle_resultado.id}"].to_f == 0
      variable = factura_despacho_detalle_resultado.id.to_s << ";#{I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.mensajes_cantidad_factura_no_cero_vacio',:item_nombre=>factura_orden_despacho_detalle_resultado.item_nombre)}"       
    end

      
    if parametros[:"monto_cantidad_facturada_#{factura_despacho_detalle_resultado.id}"].to_f == 0
      variable = factura_despacho_detalle_resultado.id.to_s << ";#{I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.mensajes_monto_factura_no_cero_vacio',:item_nombre=>factura_orden_despacho_detalle_resultado.item_nombre)}"
    end

      
  return variable
end



def save_confirmar

  correcto=false


  if params[:fecha_factura_f] !=''


      if I18n.locale.to_s=="es" || I18n.locale.to_s=="fr" || I18n.locale.to_s=="ar" || I18n.locale.to_s=="cs" || I18n.locale.to_s=="da" || I18n.locale.to_s=="de" || I18n.locale.to_s=="fi" || I18n.locale.to_s=="hu" || I18n.locale.to_s=="it" || I18n.locale.to_s=="ru" ||  I18n.locale.to_s=="nl" || I18n.locale.to_s=="pl" || I18n.locale.to_s=="pt" || I18n.locale.to_s=="sl" || I18n.locale.to_s=="sv"
        
        fecha_fac=Date.new(params[:fecha_factura_f].to_s[6,4].to_i,
                       params[:fecha_factura_f].to_s[3,2].to_i,
                       params[:fecha_factura_f].to_s[0,2].to_i)        
        
      elsif I18n.locale.to_s=="ja"        
        
        fecha_fac=Date.new(params[:fecha_factura_f].to_s[0,4].to_i,
                       params[:fecha_factura_f].to_s[5,2].to_i,
                       params[:fecha_factura_f].to_s[8,2].to_i)        
        
      else
        
        fecha_fac=Date.new(params[:fecha_factura_f].to_s[6,4].to_i,
                       params[:fecha_factura_f].to_s[0,2].to_i,
                       params[:fecha_factura_f].to_s[3,2].to_i) 
        
      end             

    if fecha_fac <= Date.today
      correcto=true
    else
      mensaje_fecha="#{I18n.t('Sistema.Body.Modelos.OrdenDespacho.Mensajes.fecha_factura_no_puede_ser_posterior_actual')} \n"
    end

  else
    mensaje_fecha="#{I18n.t('Sistema.Body.Modelos.OrdenDespacho.Mensajes.no_se_ha_seleccionado_fecha_para_factura')} \n"
  end

  resultado=validar_opciones(params,params[:id])

  if params[:observacion]=='' || params[:numero_factura]=='' || params[:casa_proveedora_id]=='0' || !correcto || resultado !='-1'

    mensaje="#{I18n.t('Sistema.Body.Modelos.Desembolso.Errores.posee_errores_en_los_siguientes_campos')}: \n\n"

    if params[:observacion]==''
      mensaje+="#{I18n.t('Sistema.Body.Modelos.Desembolso.Errores.no_ha_escrito_observacion')} \n"
    end

    if params[:numero_factura]==''
      mensaje+="#{I18n.t('Sistema.Body.Modelos.OrdenDespacho.Mensajes.no_ha_escrito_numero_factura')} \n"
    end

    if params[:casa_proveedora_id]=='0'
      mensaje+="#{I18n.t('Sistema.Body.Modelos.Desembolso.Errores.no_ha_seleccionado_casa_proveedora')} \n"
    end


    if !correcto
      mensaje+=mensaje_fecha
    end

    render :update do |page|

      if resultado=='-1'      
        page.hide 'errorExplanation'
        page.alert mensaje
      else
        resultado_final=resultado.split(";")
      	page.visual_effect :highlight, "row_#{resultado_final[0].to_f}", :duration => 6.6
        page.replace_html 'errorExplanation',"<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL>".html_safe << resultado_final[1].to_s.html_safe << "</UL></p>".html_safe 
        page.show 'errorExplanation'
        page.<< "window.scrollTo(0,0);"
      end    
    end

  else
    @orden_despacho = OrdenDespacho.find(params[:id])
    @orden_despacho.observacion=params[:observacion]
    

    actualizacion= OrdenDespachoDetalle.find(:all,:conditions=>"orden_despacho_id = #{params[:id]}")

      actualizacion.each {|orde|

        orde.observacion=params[:observacion]
        orde.save        
      }



    #actualizamos el estatus
    #OrdenDespacho.find(@orden_despacho_detalle.orden_despacho_id).update_attributes(:estatus_id=> 20010)    	

    #NUEVO CODIGO


    #logger.info "parametros 3 >>>>>>>>>>>>" << params[1].to_s
    orden_detalle = OrdenDespachoDetalle.find(:first, 
                                          :conditions=>"orden_despacho_id=#{@orden_despacho.id}")

    if !orden_detalle.nil?
      factura=FacturaOrdenDespacho.find(:first, 
                                    :conditions=>"orden_despacho_detalle_id=#{orden_detalle.id}")
      if !factura.nil?
        
          factura_formateada = ('0' * (8 - params[:numero_factura].to_s.length)) + params[:numero_factura].to_s

            errores = factura.actualizar_factura(@orden_despacho.id , 
                                             params[:casa_proveedora_id],
                                             format_fecha_conversion(params[:fecha_factura_f]),
                                             factura_formateada,
                                             session[:id],params)
        if errores == ''
      
          #factura_orden_despacho = FacturaOrdenDespacho.find(errores.id)
          flash[:notice] = I18n.t('Sistema.Body.Modelos.OrdenDespacho.Mensajes.se_actualizaron_datos_confirmacion')
          render :update do |page|
          #redirecciono al index antes redireccionaba a la misma confirmar
           new_options = {:action=>'index',:controller=>'orden_despacho'}            
            #new_options = {:action=>'confirmar', :id=>params[:id]}
            logger.info "++++++++++++++++" << new_options.to_s
	          page.redirect_to new_options
          end
        else
          render :update do |page|
            page.hide 'message'
            page.replace_html 'errorExplanation',"<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL>".html_safe << errores.html_safe << "</UL></p>".html_safe unless errores.nil?
            page.show 'errorExplanation'
            page.<< "window.scrollTo(0,0);"
          end
        end
      end
    end
  end

end


protected
 def common
    super
    @form_title = I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.orden_despacho_insumos') #'Orden de Despacho de Insumos'
    @form_title_record = I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.orden_despacho_insumo') #'Orden de Despacho de Insumo'
    @form_title_records = I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.orden_despacho_detalle') #'Orden de Despacho Detalle'
    @form_entity = 'orden_despacho_detalle'
    @form_identity_field = 'id'
    @width_layout = '1180'
 end

end