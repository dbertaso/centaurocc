# encoding: utf-8

#
# autor: Luis Rojas
# clase: Solicitudes::SolicitudController
# descripción: Migración a Rails 3
#

class Solicitudes::SolicitudController < FormTabsController

  skip_before_filter :set_charset, :only=>[:tipo_cliente_change, :sector_change, :sector_tasa_change, :sector_tasa_change_list, :sub_sector_tasa_change, :sub_sector_tasa_change_list, :rubro_tasa_change, :rubro_tasa_change_list, :sector_form_change, :sub_sector_change, :sub_sector_form_change, :rubro_list, :rubro_form_select, :sub_rubro_form_select, :sub_rubro_list, :auto_complete_for_cliente_nombre, :ubicacion, :region_change, :estado_change, :municipio_change, :propuesta_social_trabajadores_change, :propuesta_social_comunidad_change, :propuesta_social_ambiente_change, :ver_observaciones, :avanzar, :programa_change,  :rechazar, :check_new,:save_anulacion,:save_revocatoria]

 layout Proc.new { |controller| (controller.action_name=="anulacion" || controller.action_name=="revocatoria")  ? "form_popup" : "form_basic" }

  def index
    @sector_list = Sector.find(:all, :conditions=>"activo=true",:order=>'nombre')
    sector_fill(0)
    @usuarios = Usuario.find(:all, :conditions=>['id in (select usuario_id from usuario_rol where rol_id = 42)'], :order=>"primer_nombre, primer_apellido")
  end

  
  #nuevas funciones anulacion, revocatoria agregadas el 19/06/2013
  def anulacion  
  @solicitud=Solicitud.find(params[:id])
  @causal_select=CausalesAnulacionRevocatoria.find(:all,:conditions=>"anulacion=true",:order=>"causa asc")
  @width_layout = '660'
  end
  
  def save_anulacion    
    render :update do |page|      
      sol=Solicitud.find(params[:solicitud][:id]) 
      unless sol.estatus_id == 10150
          if params[:solicitud][:causa_revocatoria_anulacion]==""
            page.replace_html 'errorExplanation', "<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL>#{I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Mensajes.debe_especificar_causal_anulacion')}</UL></p>".html_safe      
            page.show 'errorExplanation'
            page.<< "window.scrollTo(0,0);"        
          elsif params[:solicitud][:justificacion_revocatoria_anulacion].strip.length==0
            page.replace_html 'errorExplanation', "<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL>#{I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Mensajes.debe_especificar_justificacion_anulacion')}</UL></p>".html_safe      
            page.show 'errorExplanation'
            page.<< "window.scrollTo(0,0);"                
          else
            page.hide 'errorExplanation'                            
            #hacemos validaciones y si todo esta bien ent se anula el tramite
            begin
                #transaction do
                   
                        hoy=Time.now
                        control_solicitud = ControlSolicitud.new 
                        control_solicitud.fecha = hoy
                        control_solicitud.estatus_id = 10150
                        control_solicitud.estatus_origen_id = sol.estatus_id
                        control_solicitud.solicitud_id = sol.id
                        control_solicitud.usuario_id = session[:id]
                        control_solicitud.comentario = ("<b><u>#{I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Mensajes.causa_por_cual_anulo')}:</u></b> " + CausalesAnulacionRevocatoria.find(params[:solicitud][:causa_revocatoria_anulacion]).causa + "<br><br><b><u>#{I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Mensajes.justificacion_por_cual_anulo')}:</u></b> " + params[:solicitud][:justificacion_revocatoria_anulacion].strip)[0,1800]
                        control_solicitud.accion = I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Mensajes.anulacion')
                        control_solicitud.save
                        
                        sol.causa_revocatoria_anulacion=params[:solicitud][:causa_revocatoria_anulacion]
                        sol.fecha_hora_revocatoria_anulacion=hoy
                        sol.usuario_responsable_revocatoria_anulacion=session[:id]
                        sol.justificacion_revocatoria_anulacion=params[:solicitud][:justificacion_revocatoria_anulacion].strip
                        sol.estatus_id =10150
                        sol.save!
                        #sol.send(:update_without_callbacks)            
                   
                #end #del transaction
                
            page.alert("#{I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Mensajes.anulo_con_exito')}");                        
            elem="row_#{sol.id}"                                    
            page.<< "window.close();if(window.opener.document.getElementById('"+elem+"')){window.opener.document.getElementById('"+elem+"').remove();}"  
                
                rescue Exception => e
                    logger.debug "EEESEE <><<<<" << e.message.to_s                            
                    page.replace_html 'errorExplanation',"<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL>" << e.message.to_s << "</UL></p>".html_safe      
                    page.show 'errorExplanation'
                    page.<< "window.scrollTo(0,0);"
                end #del exception
            
            
            end #del begin                       
          
      else 
        page.replace_html 'errorExplanation', "<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL>#{I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Mensajes.tramite_ha_sido_anulado',:numero=>sol.numero)}</UL></p>".html_safe      
        page.show 'errorExplanation'
        page.<< "window.scrollTo(0,0);"                
      end
    end
  end
  
  def revocatoria  
  @solicitud=Solicitud.find(params[:id])
  @prestamo=Prestamo.find_by_solicitud_id(params[:id])
  
  arre=DesembolsoDetalle.find_by_sql("select count(*) from desembolso_detalle where desembolso_id in (select id from desembolso where prestamo_id =#{@prestamo.id}) union select count(*) from orden_despacho_detalle where orden_despacho_id in (select id from orden_despacho where prestamo_id = #{@prestamo.id})")
  if arre.length > 1
    cantidad_total_aux=arre[0].count.to_i + arre[1].count.to_i  
  else
    cantidad_total_aux=arre[0].count.to_i
  end
  
  if cantidad_total_aux==0
      @tipo_revocatoria=I18n.t('Sistema.Body.Vistas.General.total').downcase
      @causal_select=CausalesAnulacionRevocatoria.find(:all,:conditions=>"revocatoria_total=true",:order=>"causa asc")
  else  
      arre2=FacturaOrdenDespacho.find_by_sql("select count(*) from factura_orden_despacho where orden_despacho_detalle_id in (select id from orden_despacho_detalle where orden_despacho_id in (select id from orden_despacho where prestamo_id=#{@prestamo.id})) and confirmada=true union select count(*) from orden_despacho where estatus_id=20030 and prestamo_id=#{@prestamo.id}")
      if arre2.length > 1
        cantidad_total_aux2=arre2[0].count.to_i + arre2[1].count.to_i
      else
        cantidad_total_aux2=arre2[0].count.to_i
      end
      if (@prestamo.monto_liquidado > 0 || cantidad_total_aux2 > 0)
        @tipo_revocatoria=I18n.t('Sistema.Body.Vistas.General.parcial').downcase
        @causal_select=CausalesAnulacionRevocatoria.find(:all,:conditions=>"revocatoria_parcial=true",:order=>"causa asc")
      else
        @tipo_revocatoria=I18n.t('Sistema.Body.Vistas.General.total').downcase
        @causal_select=CausalesAnulacionRevocatoria.find(:all,:conditions=>"revocatoria_total=true",:order=>"causa asc")
      end
  end
  
  @width_layout = '700'
  end
  
  def save_revocatoria    
    
    render :update do |page|            
      sol=Solicitud.find(params[:solicitud][:id])      
      pre=Prestamo.find_by_solicitud_id(params[:solicitud][:id])      
      params[:solicitud_s][:tipo_revocatoria].to_s==I18n.t('Sistema.Body.Vistas.General.total').downcase ? men2="#{I18n.t('Sistema.Body.Vistas.General.total').downcase} " : men2="#{I18n.t('Sistema.Body.Vistas.General.parcial').downcase} "
      unless sol.estatus_id == 10130 || sol.estatus_id == 10140                          
              if params[:solicitud][:causa_revocatoria_anulacion]==""
                page.replace_html 'errorExplanation', "<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL>#{I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Mensajes.debe_especificar_causal_revocatoria',:men2=>men2)}</UL></p>".html_safe      
                page.show 'errorExplanation'
                page.<< "window.scrollTo(0,0);"
              elsif params[:solicitud][:justificacion_revocatoria_anulacion].strip.length==0
                page.replace_html 'errorExplanation', "<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL>#{I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Mensajes.debe_especificar_justificacion_revocatoria',:men2=>men2)}</UL></p>".html_safe      
                page.show 'errorExplanation'
                page.<< "window.scrollTo(0,0);"                                                                                                                
              elsif params[:solicitud][:numero_oficio_revocatoria_anulacion].strip.length==0
                page.replace_html 'errorExplanation', "<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL>#{I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Mensajes.debe_especificar_numero_oficio_revocatoria',:men2=>men2)}</UL></p>".html_safe      
                page.show 'errorExplanation'
                page.<< "window.scrollTo(0,0);"                        
              elsif params[:solicitud][:fecha_aprobacion_oficio_revocatoria_anulacion].strip.length==0
                page.replace_html 'errorExplanation', "<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL>#{I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Mensajes.debe_especificar_fecha_aprobacion_revocatoria',:men2=>men2)}</UL></p>".html_safe      
                page.show 'errorExplanation'
                page.<< "window.scrollTo(0,0);"              
              elsif !sol.por_inventario and pre.monto_liquidado > 0 and params[:solicitud][:referencia_revocatoria_liquidacion].to_s.strip.length==0
                page.replace_html 'errorExplanation', "<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL>#{I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Mensajes.debe_especificar_referencia_revocatoria',:men2=>men2)}</UL></p>".html_safe      
                page.show 'errorExplanation'
                page.<< "window.scrollTo(0,0);"                        
              elsif !sol.por_inventario and pre.monto_liquidado > 0 and params[:solicitud][:fecha_pago_revocatoria_liquidacion].to_s.strip.length==0    
                page.replace_html 'errorExplanation', "<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL>#{I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Mensajes.debe_especificar_fecha_pago_revocatoria',:men2=>men2)}</UL></p>".html_safe      
                page.show 'errorExplanation'
                page.<< "window.scrollTo(0,0);"                        
              elsif !sol.por_inventario and pre.monto_liquidado > 0 and params[:revocatoria_monto_total_revocar].to_s.strip[/^[0-9.]+$/].nil?
                page.replace_html 'errorExplanation', "<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL>#{I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Mensajes.debe_especificar_monto_revocatoria',:men2=>men2)}</UL></p>".html_safe      
                page.show 'errorExplanation'
                page.<< "window.scrollTo(0,0);"              
              else                
                
                    page.hide 'errorExplanation'     
                    begin
                        #transaction do
                            prestamo=Prestamo.find_by_solicitud_id(params[:solicitud][:id])                        
                            arre=DesembolsoDetalle.find_by_sql("select count(*) from desembolso_detalle where desembolso_id in (select id from desembolso where prestamo_id =#{prestamo.id}) union select count(*) from orden_despacho_detalle where orden_despacho_id in (select id from orden_despacho where prestamo_id = #{prestamo.id})")
                            if arre.length > 1
                                cantidad_total_aux=arre[0].count.to_i + arre[1].count.to_i
                            else
                                cantidad_total_aux=arre[0].count.to_i
                            end
                            cantidad_total_aux==0 ? tipo_revocatoria="T" : tipo_revocatoria="P"
                            
                            if tipo_revocatoria=='T'                              
                                men="#{I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Mensajes.totalmente')} "                                
                                prestamo.estatus='R'
                                prestamo.save!
                                #prestamo.send(:update_without_callbacks)                        
                                
                                #reversar presupuesto pidan
                                if sol.por_inventario == true
                                    Catalogo.find_by_sql("UPDATE catalogo SET solicitud_id = null, estatus = 'L' where solicitud_id = #{sol.id}")
                                else
                                  pidan = PresupuestoPidan.find(:first, :conditions=>"estado_id = #{sol.unidad_produccion.ciudad.estado_id} and sub_rubro_id = #{sol.sub_rubro_id} and programa_id=#{sol.programa_id}")                          
                                  unless pidan.nil?
                                    pidan.compromiso = pidan.compromiso - (prestamo.monto_insumos.to_f + prestamo.monto_banco.to_f + prestamo.monto_sras_total.to_f  + prestamo.monto_gasto_total.to_f)
                                    pidan.disponibilidad = pidan.disponibilidad + (prestamo.monto_insumos.to_f + prestamo.monto_banco.to_f + prestamo.monto_sras_total.to_f  + prestamo.monto_gasto_total.to_f)
                                    pidan.save!
                                  else
                                    raise Exception, I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Errores.no_se_puede_realizar_revocatoria_total_pidan')
                                  end
                                end                                                       
                                
                                
                               #caso SigaCompromiso
                               #==================================================================================
                                    # LLAMADA DEL COMPROMISO PARA SIGA ELABORADO POR ALEX CIOFFI 23/04/2013
                                            
                                                    SigaCompromiso.generar_para_revocatoria(sol,'R','T',nil)
                                                
                               #==================================================================================
                                
                                #caso SigaPagado            
                                #==================================================================================
                                            # LLAMADA DEL PAGADO PARA SIGA ELABORADO POR ALEX CIOFFI 31/05/2013
                                            
                                                    Desembolso.find_by_prestamo_id(prestamo.id,:order=>"id desc",:limit=>1).nil? ? SigaPagado.generar_para_revocatoria(sol,prestamo,nil,'R','','T',nil) : SigaPagado.generar_para_revocatoria(sol,prestamo,nil,'R',Desembolso.find_by_prestamo_id(prestamo.id,:order=>"id desc",:limit=>1).modalidad,'T',nil)
                                                
                                #==================================================================================
                                
                                #caso SigaCausado            
                                #==================================================================================
                                            # LLAMADA DEL PAGADO PARA SIGA ELABORADO POR ALEX CIOFFI 31/05/2013
                                            
                                                    Desembolso.find_by_prestamo_id(prestamo.id,:order=>"id desc",:limit=>1).nil? ? SigaCausado.generar_para_revocatoria(sol,prestamo,nil,'R','','T',nil) : SigaCausado.generar_para_revocatoria(sol,prestamo,nil,'R',Desembolso.find_by_prestamo_id(prestamo.id,:order=>"id desc",:limit=>1).modalidad,'T',nil)
                                                
                                #==================================================================================
                                
                                hoy=Time.now
                                control_solicitud = ControlSolicitud.new 
                                control_solicitud.fecha = hoy
                                control_solicitud.estatus_id = 10140
                                control_solicitud.estatus_origen_id = sol.estatus_id
                                control_solicitud.solicitud_id = sol.id
                                control_solicitud.usuario_id = session[:id]
                                unless sol.por_inventario
                                  valor_total_re = format_fm((prestamo.monto_insumos.to_f + prestamo.monto_banco.to_f + prestamo.monto_sras_total.to_f  + prestamo.monto_gasto_total.to_f))                                  
                                  control_solicitud.comentario = ("<b><u>#{I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Mensajes.causa_por_la_se_revoco_totalmente')}:</u></b> " + CausalesAnulacionRevocatoria.find(params[:solicitud][:causa_revocatoria_anulacion]).causa + "<br><br><b><u>#{I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Mensajes.justificacion_por_la_se_revoco_totalmente')}:</u></b> " + params[:solicitud][:justificacion_revocatoria_anulacion].strip + "<br><br><b><u>#{I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Mensajes.numero_oficio')}:</u></b> " + params[:solicitud][:numero_oficio_revocatoria_anulacion].strip + "<br><br><b><u>#{I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Mensajes.fecha_aprobacion')}:</u></b> " + params[:solicitud][:fecha_aprobacion_oficio_revocatoria_anulacion] + "<br><br><b><u>#{I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Mensajes.monto_revocado')}:</u></b> " + valor_total_re)[0,1800]                                
                                else
                                  control_solicitud.comentario = ("<b><u>#{I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Mensajes.causa_por_la_se_revoco_totalmente')}:</u></b> " + CausalesAnulacionRevocatoria.find(params[:solicitud][:causa_revocatoria_anulacion]).causa + "<br><br><b><u>#{I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Mensajes.justificacion_por_la_se_revoco_totalmente')}:</u></b> " + params[:solicitud][:justificacion_revocatoria_anulacion].strip + "<br><br><b><u>#{I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Mensajes.numero_oficio')}:</u></b> " + params[:solicitud][:numero_oficio_revocatoria_anulacion].strip + "<br><br><b><u>#{I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Mensajes.fecha_aprobacion')}:</u></b> " + params[:solicitud][:fecha_aprobacion_oficio_revocatoria_anulacion])[0,1800]                                
                                end
                                control_solicitud.accion = "#{I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Mensajes.revocatoria_total')}"
                                control_solicitud.save
                                
                                sol.fecha_hora_revocatoria_anulacion=hoy
                                sol.usuario_responsable_revocatoria_anulacion=session[:id]
                                sol.causa_revocatoria_anulacion=params[:solicitud][:causa_revocatoria_anulacion]
                                sol.justificacion_revocatoria_anulacion=params[:solicitud][:justificacion_revocatoria_anulacion].strip
                                sol.fecha_aprobacion_oficio_revocatoria_anulacion=params[:solicitud][:fecha_aprobacion_oficio_revocatoria_anulacion]
                                sol.numero_oficio_revocatoria_anulacion=params[:solicitud][:numero_oficio_revocatoria_anulacion].strip
                                sol.estatus_id=10140
                                sol.save!
                                #sol.send(:update_without_callbacks)                                                                       
                                
                            else
                            #caso parcial
                                
                                #busca todas aquellas facturas confirmadas del tramite hay que agregarle el estatus estatus_id=20030 cerrada manualmente
                                
                                arre2=FacturaOrdenDespacho.find_by_sql("select count(*) from factura_orden_despacho where orden_despacho_detalle_id in (select id from orden_despacho_detalle where orden_despacho_id in (select id from orden_despacho where prestamo_id=#{prestamo.id})) and confirmada=true union select count(*) from orden_despacho where estatus_id=20030 and prestamo_id=#{prestamo.id}")
                                if arre2.length > 1
                                    cantidad_total_aux2=arre2[0].count.to_i + arre2[1].count.to_i
                                else
                                    cantidad_total_aux2=arre2[0].count.to_i 
                                end                                
                                
                                if (prestamo.monto_liquidado > 0 || cantidad_total_aux2 > 0)
                                    
                                    if params[:revocatoria_monto_total_revocar].to_f<0.0 and prestamo.monto_liquidado > 0
                                      raise Exception, "#{I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Errores.monto_revocar_invalido')}"
                                    end
                                    hay_orde=OrdenDespacho.find_by_prestamo_id_and_estatus_id(prestamo.id,20020)
                                    unless hay_orde.nil?
                                        raise Exception, "#{I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Errores.no_se_puede_revocar_por_ordenes_emitidas')}"
                                    else
                                        men="#{I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Mensajes.parcialmente')} "                                    
                                        #reversar presupuesto pidan
                                        if sol.por_inventario == true
                                            Catalogo.find_by_sql("UPDATE catalogo SET solicitud_id = null, estatus = 'L' where solicitud_id = #{sol.id}")
                                        else
                                          pidan = PresupuestoPidan.find(:first, :conditions=>"estado_id = #{sol.unidad_produccion.ciudad.estado_id} and sub_rubro_id = #{sol.sub_rubro_id} and programa_id=#{sol.programa_id}")                          
                                          # aqui se tiene que hacer la diferencia entre insumo y banco 
                                          unless pidan.nil?
                                            if prestamo.monto_liquidado > 0
                                                if params[:revocatoria][:monto_liquidado]=="n"
                                                    pidan.compromiso = pidan.compromiso - ((prestamo.monto_insumos.to_f + prestamo.monto_banco.to_f + prestamo.monto_sras_total.to_f  + prestamo.monto_gasto_total.to_f) - (prestamo.monto_despachado + prestamo.monto_liquidado))
                                                    pidan.disponibilidad = pidan.disponibilidad + ((prestamo.monto_insumos.to_f + prestamo.monto_banco.to_f + prestamo.monto_sras_total.to_f  + prestamo.monto_gasto_total.to_f) - (prestamo.monto_despachado + prestamo.monto_liquidado))                                                
                                                elsif params[:revocatoria][:monto_liquidado]=="p"
                                                    pidan.compromiso = pidan.compromiso - ((prestamo.monto_insumos.to_f + prestamo.monto_banco.to_f + prestamo.monto_sras_total.to_f  + prestamo.monto_gasto_total.to_f) - prestamo.monto_despachado - prestamo.monto_liquidado + params[:revocatoria_monto_total_revocar].to_f)
                                                    pidan.disponibilidad = pidan.disponibilidad + ((prestamo.monto_insumos.to_f + prestamo.monto_banco.to_f + prestamo.monto_sras_total.to_f  + prestamo.monto_gasto_total.to_f) - prestamo.monto_despachado - prestamo.monto_liquidado + params[:revocatoria_monto_total_revocar].to_f)
                                                else
                                                    pidan.compromiso = pidan.compromiso - ((prestamo.monto_insumos.to_f + prestamo.monto_banco.to_f + prestamo.monto_sras_total.to_f  + prestamo.monto_gasto_total.to_f) - (prestamo.monto_despachado))
                                                    pidan.disponibilidad = pidan.disponibilidad + ((prestamo.monto_insumos.to_f + prestamo.monto_banco.to_f + prestamo.monto_sras_total.to_f  + prestamo.monto_gasto_total.to_f) - (prestamo.monto_despachado))
                                                end
                                            else
                                                pidan.compromiso = pidan.compromiso - ((prestamo.monto_insumos.to_f + prestamo.monto_banco.to_f + prestamo.monto_sras_total.to_f  + prestamo.monto_gasto_total.to_f) - (prestamo.monto_despachado))
                                                pidan.disponibilidad = pidan.disponibilidad + ((prestamo.monto_insumos.to_f + prestamo.monto_banco.to_f + prestamo.monto_sras_total.to_f  + prestamo.monto_gasto_total.to_f) - (prestamo.monto_despachado))
                                            end
                                            pidan.save!
                                          else
                                            raise Exception, "#{I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Errores.no_se_puede_realizar_revocatoria_parcial_pidan')}"
                                          end
                                          #viejo
                                          #pidan.compromiso = pidan.compromiso - ((prestamo.monto_banco-prestamo.monto_liquidado) + (prestamo.monto_insumos-prestamo.monto_despachado))
                                          #pidan.disponibilidad = pidan.disponibilidad + ((prestamo.monto_banco-prestamo.monto_liquidado) + (prestamo.monto_insumos-prestamo.monto_despachado))                                                                                    
                                          #pidan.save!
                                        end
                                        
                                        
                                        if prestamo.monto_liquidado > 0
                                        
                                        if params[:revocatoria][:monto_liquidado].to_s=="n"
                                           
                                           #caso SigaCompromiso
                                        #==================================================================================
                                            # LLAMADA DEL COMPROMISO PARA SIGA ELABORADO POR ALEX CIOFFI 23/04/2013
                                                    
                                                            prestamo.monto_liquidado > 0 ? SigaCompromiso.generar_para_revocatoria(sol,'R','P',((prestamo.monto_insumos.to_f + prestamo.monto_banco.to_f + prestamo.monto_sras_total.to_f  + prestamo.monto_gasto_total.to_f) - (prestamo.monto_despachado + prestamo.monto_liquidado))) : SigaCompromiso.generar_para_revocatoria(sol,'R','P',((prestamo.monto_insumos.to_f + prestamo.monto_banco.to_f + prestamo.monto_sras_total.to_f  + prestamo.monto_gasto_total.to_f) - (prestamo.monto_despachado)))
                                                        
                                        #==================================================================================
                                        
                                        #caso SigaPagado            
                                        #==================================================================================
                                                    # LLAMADA DEL PAGADO PARA SIGA ELABORADO POR ALEX CIOFFI 31/05/2013
                                                    
                                                            prestamo.monto_liquidado > 0 ? Desembolso.find_by_prestamo_id(prestamo.id,:order=>"id desc",:limit=>1).nil? ? SigaPagado.generar_para_revocatoria(sol,prestamo,nil,'R','','P',((prestamo.monto_insumos.to_f + prestamo.monto_banco.to_f + prestamo.monto_sras_total.to_f  + prestamo.monto_gasto_total.to_f) - (prestamo.monto_despachado + prestamo.monto_liquidado))) : SigaPagado.generar_para_revocatoria(sol,prestamo,nil,'R',Desembolso.find_by_prestamo_id(prestamo.id,:order=>"id desc",:limit=>1).modalidad,'P',((prestamo.monto_insumos.to_f + prestamo.monto_banco.to_f + prestamo.monto_sras_total.to_f  + prestamo.monto_gasto_total.to_f) - (prestamo.monto_despachado + prestamo.monto_liquidado))) : Desembolso.find_by_prestamo_id(prestamo.id,:order=>"id desc",:limit=>1).nil? ? SigaPagado.generar_para_revocatoria(sol,prestamo,nil,'R','','P',((prestamo.monto_insumos.to_f + prestamo.monto_banco.to_f + prestamo.monto_sras_total.to_f  + prestamo.monto_gasto_total.to_f) - (prestamo.monto_despachado))) : SigaPagado.generar_para_revocatoria(sol,prestamo,nil,'R',Desembolso.find_by_prestamo_id(prestamo.id,:order=>"id desc",:limit=>1).modalidad,'P',((prestamo.monto_insumos.to_f + prestamo.monto_banco.to_f + prestamo.monto_sras_total.to_f  + prestamo.monto_gasto_total.to_f) - (prestamo.monto_despachado)))
                                                                        
                                        #==================================================================================
                                        
                                        #caso SigaCausado            
                                        #==================================================================================
                                                    # LLAMADA DEL PAGADO PARA SIGA ELABORADO POR ALEX CIOFFI 31/05/2013
                                                    
                                                            prestamo.monto_liquidado > 0 ? Desembolso.find_by_prestamo_id(prestamo.id,:order=>"id desc",:limit=>1).nil? ? SigaCausado.generar_para_revocatoria(sol,prestamo,nil,'R','','P',((prestamo.monto_insumos.to_f + prestamo.monto_banco.to_f + prestamo.monto_sras_total.to_f  + prestamo.monto_gasto_total.to_f) - (prestamo.monto_despachado + prestamo.monto_liquidado))) : SigaCausado.generar_para_revocatoria(sol,prestamo,nil,'R',Desembolso.find_by_prestamo_id(prestamo.id,:order=>"id desc",:limit=>1).modalidad,'P',((prestamo.monto_insumos.to_f + prestamo.monto_banco.to_f + prestamo.monto_sras_total.to_f  + prestamo.monto_gasto_total.to_f) - (prestamo.monto_despachado + prestamo.monto_liquidado))) : Desembolso.find_by_prestamo_id(prestamo.id,:order=>"id desc",:limit=>1).nil? ? SigaCausado.generar_para_revocatoria(sol,prestamo,nil,'R','','P',((prestamo.monto_insumos.to_f + prestamo.monto_banco.to_f + prestamo.monto_sras_total.to_f  + prestamo.monto_gasto_total.to_f) - (prestamo.monto_despachado))) : SigaCausado.generar_para_revocatoria(sol,prestamo,nil,'R',Desembolso.find_by_prestamo_id(prestamo.id,:order=>"id desc",:limit=>1).modalidad,'P',((prestamo.monto_insumos.to_f + prestamo.monto_banco.to_f + prestamo.monto_sras_total.to_f  + prestamo.monto_gasto_total.to_f) - (prestamo.monto_despachado)))
                                                                        
                                        #==================================================================================
                                           
                                           
                                        elsif params[:revocatoria][:monto_liquidado].to_s=="p"
                                           
                                           #caso SigaCompromiso
                                        #==================================================================================
                                            # LLAMADA DEL COMPROMISO PARA SIGA ELABORADO POR ALEX CIOFFI 23/04/2013
                                                    
                                                            prestamo.monto_liquidado > 0 ? SigaCompromiso.generar_para_revocatoria(sol,'R','P',((prestamo.monto_insumos.to_f + prestamo.monto_banco.to_f + prestamo.monto_sras_total.to_f  + prestamo.monto_gasto_total.to_f) - prestamo.monto_despachado - prestamo.monto_liquidado + params[:revocatoria_monto_total_revocar].to_f)) : SigaCompromiso.generar_para_revocatoria(sol,'R','P',((prestamo.monto_insumos.to_f + prestamo.monto_banco.to_f + prestamo.monto_sras_total.to_f  + prestamo.monto_gasto_total.to_f) - (prestamo.monto_despachado)))
                                                        
                                        #==================================================================================
                                        
                                        #caso SigaPagado            
                                        #==================================================================================
                                                    # LLAMADA DEL PAGADO PARA SIGA ELABORADO POR ALEX CIOFFI 31/05/2013
                                                    
                                                            prestamo.monto_liquidado > 0 ? Desembolso.find_by_prestamo_id(prestamo.id,:order=>"id desc",:limit=>1).nil? ? SigaPagado.generar_para_revocatoria(sol,prestamo,nil,'R','','P',((prestamo.monto_insumos.to_f + prestamo.monto_banco.to_f + prestamo.monto_sras_total.to_f  + prestamo.monto_gasto_total.to_f) - prestamo.monto_despachado - prestamo.monto_liquidado + params[:revocatoria_monto_total_revocar].to_f)) : SigaPagado.generar_para_revocatoria(sol,prestamo,nil,'R',Desembolso.find_by_prestamo_id(prestamo.id,:order=>"id desc",:limit=>1).modalidad,'P',((prestamo.monto_insumos.to_f + prestamo.monto_banco.to_f + prestamo.monto_sras_total.to_f  + prestamo.monto_gasto_total.to_f) - prestamo.monto_despachado - prestamo.monto_liquidado + params[:revocatoria_monto_total_revocar].to_f)) : Desembolso.find_by_prestamo_id(prestamo.id,:order=>"id desc",:limit=>1).nil? ? SigaPagado.generar_para_revocatoria(sol,prestamo,nil,'R','','P',((prestamo.monto_insumos.to_f + prestamo.monto_banco.to_f + prestamo.monto_sras_total.to_f  + prestamo.monto_gasto_total.to_f) - (prestamo.monto_despachado))) : SigaPagado.generar_para_revocatoria(sol,prestamo,nil,'R',Desembolso.find_by_prestamo_id(prestamo.id,:order=>"id desc",:limit=>1).modalidad,'P',((prestamo.monto_insumos.to_f + prestamo.monto_banco.to_f + prestamo.monto_sras_total.to_f  + prestamo.monto_gasto_total.to_f) - (prestamo.monto_despachado)))
                                                                        
                                        #==================================================================================
                                        
                                        #caso SigaCausado            
                                        #==================================================================================
                                                    # LLAMADA DEL PAGADO PARA SIGA ELABORADO POR ALEX CIOFFI 31/05/2013
                                                    
                                                            prestamo.monto_liquidado > 0 ? Desembolso.find_by_prestamo_id(prestamo.id,:order=>"id desc",:limit=>1).nil? ? SigaCausado.generar_para_revocatoria(sol,prestamo,nil,'R','','P',((prestamo.monto_insumos.to_f + prestamo.monto_banco.to_f + prestamo.monto_sras_total.to_f  + prestamo.monto_gasto_total.to_f) - prestamo.monto_despachado - prestamo.monto_liquidado + params[:revocatoria_monto_total_revocar].to_f)) : SigaCausado.generar_para_revocatoria(sol,prestamo,nil,'R',Desembolso.find_by_prestamo_id(prestamo.id,:order=>"id desc",:limit=>1).modalidad,'P',((prestamo.monto_insumos.to_f + prestamo.monto_banco.to_f + prestamo.monto_sras_total.to_f  + prestamo.monto_gasto_total.to_f) - prestamo.monto_despachado - prestamo.monto_liquidado + params[:revocatoria_monto_total_revocar].to_f)) : Desembolso.find_by_prestamo_id(prestamo.id,:order=>"id desc",:limit=>1).nil? ? SigaCausado.generar_para_revocatoria(sol,prestamo,nil,'R','','P',((prestamo.monto_insumos.to_f + prestamo.monto_banco.to_f + prestamo.monto_sras_total.to_f  + prestamo.monto_gasto_total.to_f) - (prestamo.monto_despachado))) : SigaCausado.generar_para_revocatoria(sol,prestamo,nil,'R',Desembolso.find_by_prestamo_id(prestamo.id,:order=>"id desc",:limit=>1).modalidad,'P',((prestamo.monto_insumos.to_f + prestamo.monto_banco.to_f + prestamo.monto_sras_total.to_f  + prestamo.monto_gasto_total.to_f) - (prestamo.monto_despachado)))
                                                                        
                                        #==================================================================================
                                           
                                           
                                           
                                        else
                                           
                                           #caso SigaCompromiso
                                        #==================================================================================
                                            # LLAMADA DEL COMPROMISO PARA SIGA ELABORADO POR ALEX CIOFFI 23/04/2013
                                                    
                                                            prestamo.monto_liquidado > 0 ? SigaCompromiso.generar_para_revocatoria(sol,'R','P',((prestamo.monto_insumos.to_f + prestamo.monto_banco.to_f + prestamo.monto_sras_total.to_f  + prestamo.monto_gasto_total.to_f) - (prestamo.monto_despachado))) : SigaCompromiso.generar_para_revocatoria(sol,'R','P',((prestamo.monto_insumos.to_f + prestamo.monto_banco.to_f + prestamo.monto_sras_total.to_f  + prestamo.monto_gasto_total.to_f) - (prestamo.monto_despachado)))
                                                        
                                        #==================================================================================
                                        
                                        #caso SigaPagado            
                                        #==================================================================================
                                                    # LLAMADA DEL PAGADO PARA SIGA ELABORADO POR ALEX CIOFFI 31/05/2013
                                                    
                                                            prestamo.monto_liquidado > 0 ? Desembolso.find_by_prestamo_id(prestamo.id,:order=>"id desc",:limit=>1).nil? ? SigaPagado.generar_para_revocatoria(sol,prestamo,nil,'R','','P',((prestamo.monto_insumos.to_f + prestamo.monto_banco.to_f + prestamo.monto_sras_total.to_f  + prestamo.monto_gasto_total.to_f) - (prestamo.monto_despachado))) : SigaPagado.generar_para_revocatoria(sol,prestamo,nil,'R',Desembolso.find_by_prestamo_id(prestamo.id,:order=>"id desc",:limit=>1).modalidad,'P',((prestamo.monto_insumos.to_f + prestamo.monto_banco.to_f + prestamo.monto_sras_total.to_f  + prestamo.monto_gasto_total.to_f) - (prestamo.monto_despachado))) : Desembolso.find_by_prestamo_id(prestamo.id,:order=>"id desc",:limit=>1).nil? ? SigaPagado.generar_para_revocatoria(sol,prestamo,nil,'R','','P',((prestamo.monto_insumos.to_f + prestamo.monto_banco.to_f + prestamo.monto_sras_total.to_f  + prestamo.monto_gasto_total.to_f) - (prestamo.monto_despachado))) : SigaPagado.generar_para_revocatoria(sol,prestamo,nil,'R',Desembolso.find_by_prestamo_id(prestamo.id,:order=>"id desc",:limit=>1).modalidad,'P',((prestamo.monto_insumos.to_f + prestamo.monto_banco.to_f + prestamo.monto_sras_total.to_f  + prestamo.monto_gasto_total.to_f) - (prestamo.monto_despachado)))
                                                                        
                                        #==================================================================================
                                        
                                        #caso SigaCausado            
                                        #==================================================================================
                                                    # LLAMADA DEL PAGADO PARA SIGA ELABORADO POR ALEX CIOFFI 31/05/2013
                                                    
                                                            prestamo.monto_liquidado > 0 ? Desembolso.find_by_prestamo_id(prestamo.id,:order=>"id desc",:limit=>1).nil? ? SigaCausado.generar_para_revocatoria(sol,prestamo,nil,'R','','P',((prestamo.monto_insumos.to_f + prestamo.monto_banco.to_f + prestamo.monto_sras_total.to_f  + prestamo.monto_gasto_total.to_f) - (prestamo.monto_despachado))) : SigaCausado.generar_para_revocatoria(sol,prestamo,nil,'R',Desembolso.find_by_prestamo_id(prestamo.id,:order=>"id desc",:limit=>1).modalidad,'P',((prestamo.monto_insumos.to_f + prestamo.monto_banco.to_f + prestamo.monto_sras_total.to_f  + prestamo.monto_gasto_total.to_f) - (prestamo.monto_despachado))) : Desembolso.find_by_prestamo_id(prestamo.id,:order=>"id desc",:limit=>1).nil? ? SigaCausado.generar_para_revocatoria(sol,prestamo,nil,'R','','P',((prestamo.monto_insumos.to_f + prestamo.monto_banco.to_f + prestamo.monto_sras_total.to_f  + prestamo.monto_gasto_total.to_f) - (prestamo.monto_despachado))) : SigaCausado.generar_para_revocatoria(sol,prestamo,nil,'R',Desembolso.find_by_prestamo_id(prestamo.id,:order=>"id desc",:limit=>1).modalidad,'P',((prestamo.monto_insumos.to_f + prestamo.monto_banco.to_f + prestamo.monto_sras_total.to_f  + prestamo.monto_gasto_total.to_f) - (prestamo.monto_despachado)))
                                                                        
                                        #==================================================================================
                                           
                                           
                                        end                                        
                                        else
                                        #caso viejo SigaCompromiso
                                        #==================================================================================
                                            # LLAMADA DEL COMPROMISO PARA SIGA ELABORADO POR ALEX CIOFFI 23/04/2013
                                                    
                                                            SigaCompromiso.generar_para_revocatoria(sol,'R','P',((prestamo.monto_insumos.to_f + prestamo.monto_banco.to_f + prestamo.monto_sras_total.to_f  + prestamo.monto_gasto_total.to_f) - (prestamo.monto_despachado)))
                                                        
                                        #==================================================================================
                                        
                                        #caso SigaPagado            
                                        #==================================================================================
                                                    # LLAMADA DEL PAGADO PARA SIGA ELABORADO POR ALEX CIOFFI 31/05/2013
                                                    
                                                            Desembolso.find_by_prestamo_id(prestamo.id,:order=>"id desc",:limit=>1).nil? ? SigaPagado.generar_para_revocatoria(sol,prestamo,nil,'R','','P',((prestamo.monto_insumos.to_f + prestamo.monto_banco.to_f + prestamo.monto_sras_total.to_f  + prestamo.monto_gasto_total.to_f) - (prestamo.monto_despachado))) : SigaPagado.generar_para_revocatoria(sol,prestamo,nil,'R',Desembolso.find_by_prestamo_id(prestamo.id,:order=>"id desc",:limit=>1).modalidad,'P',((prestamo.monto_insumos.to_f + prestamo.monto_banco.to_f + prestamo.monto_sras_total.to_f  + prestamo.monto_gasto_total.to_f) - (prestamo.monto_despachado)))
                                                                        
                                        #==================================================================================
                                        
                                        #caso SigaCausado            
                                        #==================================================================================
                                                    # LLAMADA DEL PAGADO PARA SIGA ELABORADO POR ALEX CIOFFI 31/05/2013
                                                    
                                                            Desembolso.find_by_prestamo_id(prestamo.id,:order=>"id desc",:limit=>1).nil? ? SigaCausado.generar_para_revocatoria(sol,prestamo,nil,'R','','P',((prestamo.monto_insumos.to_f + prestamo.monto_banco.to_f + prestamo.monto_sras_total.to_f  + prestamo.monto_gasto_total.to_f) - (prestamo.monto_despachado))) : SigaCausado.generar_para_revocatoria(sol,prestamo,nil,'R',Desembolso.find_by_prestamo_id(prestamo.id,:order=>"id desc",:limit=>1).modalidad,'P',((prestamo.monto_insumos.to_f + prestamo.monto_banco.to_f + prestamo.monto_sras_total.to_f  + prestamo.monto_gasto_total.to_f) - (prestamo.monto_despachado)))
                                                                        
                                        #==================================================================================
                                        end
                                        hoy=Time.now
                                        control_solicitud = ControlSolicitud.new 
                                        control_solicitud.fecha = hoy
                                        control_solicitud.estatus_id = 10130
                                        control_solicitud.estatus_origen_id = sol.estatus_id
                                        control_solicitud.solicitud_id = sol.id
                                        control_solicitud.usuario_id = session[:id]
                                        unless sol.por_inventario
                                          if prestamo.monto_liquidado > 0
                                                if params[:revocatoria][:monto_liquidado]=="n"
                                                    valor_total_re = format_fm((prestamo.monto_insumos.to_f + prestamo.monto_banco.to_f + prestamo.monto_sras_total.to_f  + prestamo.monto_gasto_total.to_f) - (prestamo.monto_despachado + prestamo.monto_liquidado))                                                    
                                                elsif params[:revocatoria][:monto_liquidado]=="p"
                                                    valor_total_re = format_fm((prestamo.monto_insumos.to_f + prestamo.monto_banco.to_f + prestamo.monto_sras_total.to_f  + prestamo.monto_gasto_total.to_f) - (prestamo.monto_despachado - prestamo.monto_liquidado + params[:revocatoria_monto_total_revocar].to_f))                                                    
                                                else
                                                    valor_total_re = format_fm((prestamo.monto_insumos.to_f + prestamo.monto_banco.to_f + prestamo.monto_sras_total.to_f  + prestamo.monto_gasto_total.to_f) - (prestamo.monto_despachado))                                                    
                                                end
                                                control_solicitud.comentario = ("<b><u>#{I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Mensajes.causa_por_la_se_revoco_parcialmente')}:</u></b> " + CausalesAnulacionRevocatoria.find(params[:solicitud][:causa_revocatoria_anulacion]).causa + "<br><br><b><u>#{I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Mensajes.justificacion_por_la_se_revoco_parcialmente')}:</u></b> " + params[:solicitud][:justificacion_revocatoria_anulacion].strip + "<br><br><b><u>#{I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Mensajes.numero_oficio')}:</u></b> " + params[:solicitud][:numero_oficio_revocatoria_anulacion].strip + "<br><br><b><u>#{I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Mensajes.fecha_aprobacion')}:</u></b> " + params[:solicitud][:fecha_aprobacion_oficio_revocatoria_anulacion] + "<br><br><b><u>#{I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Mensajes.referencia_pago_realizado_administrativamente')}:</u></b> " + params[:solicitud][:referencia_revocatoria_liquidacion].strip + "<br><br><b><u>#{I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Mensajes.fecha_del_pago')}:</u></b> " + params[:solicitud][:fecha_pago_revocatoria_liquidacion] + "<br><br><b><u>#{I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Mensajes.monto_revocado')}:</u></b> " + valor_total_re)[0,1800]                                                                    
                                          else
                                              valor_total_re = format_fm((prestamo.monto_insumos.to_f + prestamo.monto_banco.to_f + prestamo.monto_sras_total.to_f  + prestamo.monto_gasto_total.to_f) - (prestamo.monto_despachado))                                              
                                              control_solicitud.comentario = ("<b><u>#{I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Mensajes.causa_por_la_se_revoco_parcialmente')}:</u></b> " + CausalesAnulacionRevocatoria.find(params[:solicitud][:causa_revocatoria_anulacion]).causa + "<br><br><b><u>#{I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Mensajes.justificacion_por_la_se_revoco_parcialmente')}:</u></b> " + params[:solicitud][:justificacion_revocatoria_anulacion].strip + "<br><br><b><u>#{I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Mensajes.numero_oficio')}:</u></b> " + params[:solicitud][:numero_oficio_revocatoria_anulacion].strip + "<br><br><b><u>#{I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Mensajes.fecha_aprobacion')}:</u></b> " + params[:solicitud][:fecha_aprobacion_oficio_revocatoria_anulacion] + "<br><br><b><u>#{I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Mensajes.monto_revocado')}:</u></b> " + valor_total_re)[0,1800]                                                                    
                                          end                                          
                                        else
                                          control_solicitud.comentario = ("<b><u>#{I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Mensajes.causa_por_la_se_revoco_parcialmente')}:</u></b> " + CausalesAnulacionRevocatoria.find(params[:solicitud][:causa_revocatoria_anulacion]).causa + "<br><br><b><u>#{I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Mensajes.justificacion_por_la_se_revoco_parcialmente')}:</u></b> " + params[:solicitud][:justificacion_revocatoria_anulacion].strip + "<br><br><b><u>#{I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Mensajes.numero_oficio')}:</u></b> " + params[:solicitud][:numero_oficio_revocatoria_anulacion].strip + "<br><br><b><u>#{I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Mensajes.fecha_aprobacion')}:</u></b> " + params[:solicitud][:fecha_aprobacion_oficio_revocatoria_anulacion])[0,1800]                                                                    
                                        end
                                        control_solicitud.accion = "#{I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Mensajes.revocatoria_parcial')}"
                                        control_solicitud.save
                                        
                                        sol.fecha_hora_revocatoria_anulacion=hoy
                                        sol.usuario_responsable_revocatoria_anulacion=session[:id]
                                        sol.causa_revocatoria_anulacion=params[:solicitud][:causa_revocatoria_anulacion]
                                        sol.justificacion_revocatoria_anulacion=params[:solicitud][:justificacion_revocatoria_anulacion].strip
                                        sol.fecha_aprobacion_oficio_revocatoria_anulacion=params[:solicitud][:fecha_aprobacion_oficio_revocatoria_anulacion]
                                        sol.numero_oficio_revocatoria_anulacion=params[:solicitud][:numero_oficio_revocatoria_anulacion].strip
                                        
                                        unless sol.por_inventario
                                          if prestamo.monto_liquidado > 0
                                            sol.referencia_revocatoria_liquidacion=params[:solicitud][:referencia_revocatoria_liquidacion].strip
                                            sol.fecha_pago_revocatoria_liquidacion=params[:solicitud][:fecha_pago_revocatoria_liquidacion]
                                          end
                                        end
                                        
                                        sol.estatus_id=10130
                                        sol.save!
                                        #sol.send(:update_without_callbacks)
                                    end  
                                else
                                # caso en que no cumpla con las codiciones de la parcial, en este caso es una revocatoria total                                
                                    #raise Exception, "No se pudo realizar la revocatoria parcial debido a que el financiamiento no cumple con las condiciones necesarias para aplicar dicha revocatoria"                                                                        
                                    men="#{I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Mensajes.totalmente')} "                                
                                    prestamo.estatus='R'
                                    prestamo.save!
                                    #prestamo.send(:update_without_callbacks)                        
                                    
                                    #reversar presupuesto pidan
                                    if sol.por_inventario == true
                                        Catalogo.find_by_sql("UPDATE catalogo SET solicitud_id = null, estatus = 'L' where solicitud_id = #{sol.id}")
                                    else
                                      pidan = PresupuestoPidan.find(:first, :conditions=>"estado_id = #{sol.unidad_produccion.ciudad.estado_id} and sub_rubro_id = #{sol.sub_rubro_id} and programa_id=#{sol.programa_id}")                          
                                      unless pidan.nil?
                                        pidan.compromiso = pidan.compromiso - (prestamo.monto_insumos.to_f + prestamo.monto_banco.to_f + prestamo.monto_sras_total.to_f  + prestamo.monto_gasto_total.to_f)
                                        pidan.disponibilidad = pidan.disponibilidad + (prestamo.monto_insumos.to_f + prestamo.monto_banco.to_f + prestamo.monto_sras_total.to_f  + prestamo.monto_gasto_total.to_f)
                                        pidan.save!
                                      else
                                        raise Exception, I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Errores.no_se_puede_realizar_revocatoria_total_pidan')
                                      end
                                    end                                                           
                                    
                                    
                                   #caso SigaCompromiso
                                   #==================================================================================
                                        # LLAMADA DEL COMPROMISO PARA SIGA ELABORADO POR ALEX CIOFFI 23/04/2013
                                                
                                                        SigaCompromiso.generar_para_revocatoria(sol,'R','T',nil)
                                                    
                                   #==================================================================================
                                    
                                    #caso SigaPagado            
                                    #==================================================================================
                                                # LLAMADA DEL PAGADO PARA SIGA ELABORADO POR ALEX CIOFFI 31/05/2013
                                                
                                                        Desembolso.find_by_prestamo_id(prestamo.id,:order=>"id desc",:limit=>1).nil? ? SigaPagado.generar_para_revocatoria(sol,prestamo,nil,'R','','T',nil) : SigaPagado.generar_para_revocatoria(sol,prestamo,nil,'R',Desembolso.find_by_prestamo_id(prestamo.id,:order=>"id desc",:limit=>1).modalidad,'T',nil)
                                                    
                                    #==================================================================================
                                    
                                    #caso SigaCausado            
                                    #==================================================================================
                                                # LLAMADA DEL PAGADO PARA SIGA ELABORADO POR ALEX CIOFFI 31/05/2013
                                                
                                                        Desembolso.find_by_prestamo_id(prestamo.id,:order=>"id desc",:limit=>1).nil? ? SigaCausado.generar_para_revocatoria(sol,prestamo,nil,'R','','T',nil) : SigaCausado.generar_para_revocatoria(sol,prestamo,nil,'R',Desembolso.find_by_prestamo_id(prestamo.id,:order=>"id desc",:limit=>1).modalidad,'T',nil)
                                                    
                                    #==================================================================================
                                    
                                    hoy=Time.now
                                    control_solicitud = ControlSolicitud.new 
                                    control_solicitud.fecha = hoy
                                    control_solicitud.estatus_id = 10140
                                    control_solicitud.estatus_origen_id = sol.estatus_id
                                    control_solicitud.solicitud_id = sol.id
                                    control_solicitud.usuario_id = session[:id]
                                    unless sol.por_inventario
                                        valor_total_re = format_fm(prestamo.monto_insumos.to_f + prestamo.monto_banco.to_f + prestamo.monto_sras_total.to_f  + prestamo.monto_gasto_total.to_f)                                        
                                        control_solicitud.comentario = ("<b><u>#{I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Mensajes.causa_por_la_se_revoco_totalmente')}:</u></b> " + CausalesAnulacionRevocatoria.find(params[:solicitud][:causa_revocatoria_anulacion]).causa + "<br><br><b><u>#{I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Mensajes.justificacion_por_la_se_revoco_totalmente')}:</u></b> " + params[:solicitud][:justificacion_revocatoria_anulacion].strip + "<br><br><b><u>#{I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Mensajes.numero_oficio')}:</u></b> " + params[:solicitud][:numero_oficio_revocatoria_anulacion].strip + "<br><br><b><u>#{I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Mensajes.fecha_aprobacion')}:</u></b> " + params[:solicitud][:fecha_aprobacion_oficio_revocatoria_anulacion] + "<br><br><b><u>#{I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Mensajes.monto_revocado')}:</u></b> " + valor_total_re)[0,1800]                                
                                    else
                                        control_solicitud.comentario = ("<b><u>#{I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Mensajes.causa_por_la_se_revoco_totalmente')}:</u></b> " + CausalesAnulacionRevocatoria.find(params[:solicitud][:causa_revocatoria_anulacion]).causa + "<br><br><b><u>#{I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Mensajes.justificacion_por_la_se_revoco_totalmente')}:</u></b> " + params[:solicitud][:justificacion_revocatoria_anulacion].strip + "<br><br><b><u>#{I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Mensajes.numero_oficio')}:</u></b> " + params[:solicitud][:numero_oficio_revocatoria_anulacion].strip + "<br><br><b><u>#{I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Mensajes.fecha_aprobacion')}:</u></b> " + params[:solicitud][:fecha_aprobacion_oficio_revocatoria_anulacion])[0,1800]                                
                                    end
                                    control_solicitud.accion = "#{I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Mensajes.revocatoria_total')}"
                                    control_solicitud.save
                                    
                                    sol.fecha_hora_revocatoria_anulacion=hoy
                                    sol.usuario_responsable_revocatoria_anulacion=session[:id]
                                    sol.causa_revocatoria_anulacion=params[:solicitud][:causa_revocatoria_anulacion]
                                    sol.justificacion_revocatoria_anulacion=params[:solicitud][:justificacion_revocatoria_anulacion].strip
                                    sol.fecha_aprobacion_oficio_revocatoria_anulacion=params[:solicitud][:fecha_aprobacion_oficio_revocatoria_anulacion]
                                    sol.numero_oficio_revocatoria_anulacion=params[:solicitud][:numero_oficio_revocatoria_anulacion].strip
                                    sol.estatus_id=10140
                                    sol.save!
                                    #sol.send(:update_without_callbacks)
                                end                                                                       
                                
                            end                    
                            
                    page.alert("#{I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Mensajes.revoco_con_exito',:men=>men)}")           
                    elem="row_#{sol.id}"                                    
                    page.<< "window.close();if(window.opener.document.getElementById('"+elem+"')){window.opener.document.getElementById('"+elem+"').remove();}"   
                            
                        #end #del transaction
                    
                        rescue Exception => e
                            logger.debug "EEESEE <><<<<" << e.message.to_s                                                                                    
                            page.replace_html 'errorExplanation',"<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL>" << e.message.to_s <<  "</UL></p>".html_safe      
                            page.show 'errorExplanation'
                            page.<< "window.scrollTo(0,0);"                            
                        end #del exception                   
                    
                    
                    end #del begin
                
              
          
    else
        page.replace_html 'errorExplanation', "<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL>#{I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Mensajes.tramite_ha_sido_revocado',:numero=>sol.numero,:men=>men)}</UL></p>".html_safe      
        page.show 'errorExplanation'
        page.<< "window.scrollTo(0,0);"                        
    end
  end
  end
  #fin nuevas funciones anulacion, revocatoria agregadas el 19/06/2013
  
  def list

    @oficina_id = @usuario.oficina_id

    @condition ="estatus_id = '10001' and liberada = false and oficina_id = #{@oficina_id}"
    params['sort'] = "numero" unless params['sort']

    unless params[:sector_id][0].blank?
      sector_id = params[:sector_id][0].to_s
      sector = Sector.find(sector_id)
      @condition << " and sector_id = #{params[:sector_id][0]} "
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.sector')} #{I18n.t('Sistema.Body.General.es')} #{I18n.t('Sistema.Body.Vistas.General.igual')} '#{sector.nombre}'"
    end
    unless params[:sub_sector_id][0].blank?
      sub_sector_id = params[:sub_sector_id][0].to_s
      sub_sector = SubSector.find(sub_sector_id)
      @condition << " and sub_sector_id = #{params[:sub_sector_id][0]} "
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.sub_sector')} #{I18n.t('Sistema.Body.General.es')} #{I18n.t('Sistema.Body.Vistas.General.igual')} '#{sub_sector.nombre}'"
    end

    unless params[:rubro_id][0].blank?
      rubro_id = params[:rubro_id][0].to_s
      rubro = Rubro.find(rubro_id)
      @condition << " and rubro_id = " + params[:rubro_id][0]
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.rubro')} #{I18n.t('Sistema.Body.General.es')} #{I18n.t('Sistema.Body.Vistas.General.igual')} '#{rubro.nombre}'"
    end

    unless params[:sub_rubro_id][0].blank?
      sub_rubro_id = params[:sub_rubro_id][0].to_s
      sub_rubro = SubRubro.find(sub_rubro_id)
      @condition << " and sub_rubro_id = " + params[:sub_rubro_id][0]
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.sub_rubro')} #{I18n.t('Sistema.Body.General.es')} #{I18n.t('Sistema.Body.Vistas.General.igual')} '#{sub_rubro.nombre}'"
    end

    unless params[:actividad_id][0].blank?
      actividad_id = params[:actividad_id][0].to_s
      actividad = Actividad.find(actividad_id)
      @condition << " and actividad_id = " + params[:actividad_id][0]
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.actividad')} #{I18n.t('Sistema.Body.General.es')} #{I18n.t('Sistema.Body.Vistas.General.igual')} '#{actividad.nombre}'"
    end

    unless params[:identificacion].blank?
      @condition << " AND cedula_rif =  '#{params[:identificacion]}'"
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.cedula')} / #{I18n.t('Sistema.Body.Vistas.General.rif')} #{I18n.t('Sistema.Body.Vistas.General.igual')} '#{params[:identificacion]}'"
    end

    unless params[:numero].blank?
      @condition << " AND numero =  #{params[:numero].to_i}"
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.nro')} #{I18n.t('Sistema.Body.Vistas.General.solicitud')} #{I18n.t('Sistema.Body.Vistas.General.igual')} '#{params[:numero]}'"
    end

    unless params[:nombre].blank?
      @condition << " AND UPPER(nombre) LIKE UPPER('%#{params[:nombre].strip}%')"
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Vistas.General.del')} #{I18n.t('Sistema.Body.General.beneficiario')} #{I18n.t('Sistema.Body.Vistas.General.contenga')} '#{params[:nombre]}'"
    end

    
    @list = ViewListSolicitud.search(@condition, params[:page], params['sort'])
    @total=@list.count


    form_list
  end

  def tipo_cliente_change
    @tipo_cliente = params[:tipo_cliente_id]
    render :update do |page|
      page.replace_html 'tipo-cliente-select', :partial => 'tipo_cliente_select'
    end
  end

  def check_new
    if params[:cliente][:tipo_cliente_id].blank?
      render :update do |page|
        page.hide 'mensaje'
        page.alert "Tipo de Cliente es requerido"
      end
      return
    end
    if params[:cliente][:tipo_cliente_id].to_i == 1
      if params[:rif].blank? || params[:rif1].blank?
        render :update do |page|
          page.hide 'mensaje'
          page.alert "Rif es requerido"
        end
        return
      else
        identificacion = params[:tipo][0] << '-' << params[:rif] << '-' << params[:rif1]
        mensaje = "rif"
      end
    else
      if params[:cedula].blank?
        render :update do |page|
          page.hide 'mensaje'
          page.alert "Cédula es requerido"
        end
        return
      else
        identificacion = params[:cedula]
        mensaje = "cédula"
      end
    end
    unless identificacion.blank?
      cliente = ClienteEmpresa.find(:first, :conditions=>['empresa.rif = ?', identificacion], :include=>'empresa')
      if !cliente
        cliente = ClientePersona.find(:first, :conditions=>['persona.cedula = ?', identificacion.to_i], :include=>'persona')
        if !cliente
          render :update do |page|
            page.alert "El " + Etiquetas.etiqueta(9) + " con la #{mensaje} '#{identificacion}' no existe "
          end
        end
      end
      if cliente
        unless cliente.viable
          render :update do |page|
            page.alert "El " + Etiquetas.etiqueta(9) + " no es viable para el financiamiento"
          end
          return false
        end

        if cliente.viable == false
          render :update do |page|
            page.alert "El " + Etiquetas.etiqueta(9) + " no es viable para el financiamiento."
          end
          return false
        end
        total = Prestamo.count(:conditions=>["cliente_id = ? and estatus not in ('S', 'V', 'C')", cliente.id])
        if total > 0
          cliente.moroso = true
          cliente.viable = false
          cliente.save
          render :update do |page|
            page.alert "El " + Etiquetas.etiqueta(9) + " requiere restructuración de la deuda."
          end
          return false
        end

        total = Programa.count(:id, :conditions=>['activo=true and id in (select programa_id from programa_tipo_cliente where tipo_cliente_id = ? )',cliente.tipo_cliente_id])
        if total > 0
          render :update do |page|
            page.redirect_to :action=>'new', :identificacion=>identificacion
          end
        else
          render :update do |page|
            page.alert 'Debe agregar un programa para el tipo ' + Etiquetas.etiqueta(9) + ' "' + cliente.tipo_cliente.nombre + '"'
          end
          return
        end
      end

    else
      render :update do |page|
        page.alert "Debe introducir una cédula o un rif"
      end
    end

  end

  def nuevo
    @cliente = ClienteEmpresa.find(
      :first,
      :conditions=>['empresa.rif = ?', params[:identificacion]],
      :include=>'empresa')
    if !@cliente
      @cliente = ClientePersona.find(:first,
        :conditions=>['persona.cedula = ?', params[:identificacion].to_i],
        :include=>'persona')
    end

    if Solicitud.count(:conditions=>['estatus_id < 10022 and cliente_id = ?',@cliente.id]) > 0
      render :update do |page|
        page.hide 'mensaje'
        page.alert 'La ' << Etiquetas.etiqueta(9) << ' posee una solicitud en tramite'
      end
      return false
    end

    total = Programa.count(:id, :conditions=>['id in (select programa_id from programa_tipo_cliente where tipo_cliente_id = ? )',@cliente.tipo_cliente_id])
    if total > 0
      render :update do |page|
        page.redirect_to :action=>'new', :identificacion=>params[:identificacion]
      end
    else
      render :update do |page|
        page.hide 'mensaje'
        page.alert 'Debe agregar un programa para el tipo ' + Etiquetas.etiqueta(9) + ' "' + @cliente.tipo_cliente.nombre + '"'
      end
      return false
    end
  end

  def new
    @solicitud = Solicitud.new
    @solicitud.por_inventario = true
    @cliente = ClienteEmpresa.find(
      :first,
      :conditions=>['empresa.rif = ?', params[:identificacion]],
      :include=>'empresa')
    if !@cliente
      @cliente = ClientePersona.find(:first,
        :conditions=>['persona.cedula = ?', params[:identificacion].to_i],
        :include=>'persona')
    end
    @solicitud.oficina_id = session[:oficina].to_i
    @solicitud.cliente_id = @cliente.id
    #@region_select = Region.find(:all, :order=>'nombre')
    @tipo_iniciativa_select = TipoIniciativa.find(:all, :order=>'nombre')
    fill()
    programa_fill(nil)
    sector_fill(0)
    modalidad_financiamiento_fill(@programa[0].id)
    @modalidad_select = ModalidadFinanciamiento.find(:all, :conditions=>['activo=true and id in (select modalidad_financiamiento_id from programa_modalidad_financiamiento where programa_id = ?)', @programa[0].id])
  end

  def sector_change
    sub_sector_fill(params[:sector_id])
    render :update do |page|
      page.replace_html 'sub-sector-select', :partial => 'sub_sector_select'
      page.replace_html 'sub_rubro-select', :partial => 'sub_rubro_list'
      page.replace_html 'actividad-select', :partial => 'actividad_list'
      page.replace_html 'rubro-select', :partial => 'rubro_select'
      page.show 'rubro-select'
      page.show 'sub_rubro-select'
      page.show 'actividad-select'
      page.show 'sub-sector-select'
    end
  end

  def sector_tasa_change
    sub_sector_fill(params[:sector_id])
    render :update do |page|
      page.replace_html 'sub-sector-select', :partial => 'sub_sector_tasa_change'
      page.replace_html 'sub_rubro-select', :partial => 'sub_rubro_tasa_change'
      page.replace_html 'rubro-select', :partial => 'rubro_tasa_change'
      page.show 'rubro-select'
      page.show 'sub_rubro-select'
      page.show 'sub-sector-select'
    end
  end

  def sector_tasa_change_list
    sub_sector_fill(params[:sector_id])
    render :update do |page|
      page.replace_html 'sub-sector-select', :partial => 'sub_sector_tasa_change_list'
      page.replace_html 'sub_rubro-select', :partial => 'sub_rubro_tasa_change_list'
      page.replace_html 'rubro-select', :partial => 'rubro_tasa_change_list'
      page.show 'rubro-select'
      page.show 'sub_rubro-select'
      page.show 'sub-sector-select'
    end
  end


  def sub_sector_tasa_change
    rubro_fill(params[:sub_sector_id])
    render :update do |page|
      page.replace_html 'rubro-select', :partial => 'rubro_tasa_change'
      page.replace_html 'sub_rubro-select', :partial => 'sub_rubro_tasa_change'
      page.show 'rubro-select'
      page.show 'sub_rubro-select'

    end
  end

  def sub_sector_tasa_change_list
    rubro_fill(params[:sub_sector_id])
    render :update do |page|
      page.replace_html 'rubro-select', :partial => 'rubro_tasa_change_list'
      page.replace_html 'sub_rubro-select', :partial => 'sub_rubro_tasa_change_list'
      page.show 'rubro-select'
      page.show 'sub_rubro-select'

    end
  end

  def rubro_tasa_change
    sub_rubro(params[:rubro_id])
    render :update do |page|
      page.replace_html 'sub_rubro-select', :partial => 'sub_rubro_tasa_change'
      page.show 'sub_rubro-select'
    end
  end

  def rubro_tasa_change_list
    sub_rubro(params[:rubro_id])
    render :update do |page|
      page.replace_html 'sub_rubro-select', :partial => 'sub_rubro_tasa_change_list'
      page.show 'sub_rubro-select'
    end
  end

  def sector_form_change
    unless params[:programa_id].nil? || params[:programa_id].empty?
      sub_sector_form_fill(params[:sector_id], params[:programa_id])
      render :update do |page|
        page.replace_html 'sub-sector-select', :partial => 'sub_sector_form_select'
        page.replace_html 'sub_rubro-select', :partial => 'sub_rubro_form_select'
        page.replace_html 'actividad-select', :partial => 'actividad_form_select'
        page.replace_html 'rubro-select', :partial => 'rubro_form_select'
        page.show 'rubro-select'
        page.show 'sub_rubro-select'
        page.show 'actividad-select'
        page.show 'sub-sector-select'
        page.hide 'hectarea'
        page.hide 'semovientes'
        page.hide 'maquinaria'
      end
    else
      render :update do |page|
        page.alert("Debe seleccionar el programa.")
      end
    end
  end

  def sub_sector_change
    rubro_fill(params[:sub_sector_id])
    render :update do |page|
      page.replace_html 'rubro-select', :partial => 'rubro_select'
      page.replace_html 'sub_rubro-select', :partial => 'sub_rubro_list'
      page.replace_html 'actividad-select', :partial => 'actividad_list'
      page.show 'rubro-select'
      page.show 'sub_rubro-select'
      page.show 'actividad-select'
    end
  end

  def sub_sector_form_change
    rubro_fill(params[:sub_sector_id])
    m = hectareas_unidades(params[:sub_sector_id])
    render :update do |page|
      page.hide 'hectarea'
      page.hide 'semovientes'
      if m.length > 0
        page.show m
      end
      page.replace_html 'sub_rubro-select', :partial => 'sub_rubro_form_select'
      page.replace_html 'actividad-select', :partial => 'actividad_form_select'
      page.replace_html 'rubro-select', :partial => 'rubro_form_select'
      page.show 'rubro-select'
      page.show 'sub_rubro-select'
      page.show 'actividad-select'
    end
  end

  def rubro_list
    sub_rubro(params[:rubro_id])
    render :update do |page|
      page.replace_html 'sub_rubro-select', :partial => 'sub_rubro_list'
      page.replace_html 'actividad-select', :partial => 'actividad_list'
      page.show 'sub_rubro-select'
      page.show 'actividad-select'
    end
  end

  def rubro_form_select
    sub_rubro(params[:rubro_id])
    render :update do |page|
      page.replace_html 'sub_rubro-select', :partial => 'sub_rubro_form_select'
      page.replace_html 'actividad-select', :partial => 'actividad_form_select'
      page.show 'sub_rubro-select'
      page.show 'actividad-select'
    end
  end

  def sub_rubro_form_select
    actividad(params[:sub_rubro_id])
    render :update do |page|
      page.replace_html 'actividad-select', :partial => 'actividad_form_select'
      page.show 'actividad-select'
    end
  end

  def sub_rubro_list
    actividad(params[:sub_rubro_id])
    render :update do |page|
      page.replace_html 'actividad-select', :partial => 'actividad_list'
      page.show 'actividad-select'
    end
  end

  def save_new

    @solicitud = Solicitud.new(params[:solicitud])
    @solicitud.usuario = @usuario
    @solicitud.ip_address = session[:ip_address]
    @cliente = Cliente.find(params[:cliente_id])
    @solicitud.cliente = @cliente
    @solicitud.oficina_id = @usuario.oficina_id

    if @cliente.class.to_s=='ClienteEmpresa'
      @solicitud.numero_empresa = @cliente.empresa.numero
      @solicitud.numero_grupo = 0
    else
      if @cliente.persona.grupo_integrante[0] != nil
        @solicitud.numero_empresa = 0
        @solicitud.numero_grupo = @cliente.persona.grupo_integrante[0].grupo.numero
      else
        @solicitud.numero_empresa = 0
        @solicitud.numero_grupo = 0
      end
    end
    #    if @cliente.class.to_s=='ClienteEmpresa'
    #      @solicitud.numero_empresa = @cliente.empresa.numero
    #      @solicitud.numero_grupo = 0
    #    else
    #      if @cliente.persona.GrupoIntegrante[0] != nil
    #        @solicitud.numero_empresa = 0
    #        @solicitud.numero_grupo = @cliente.persona.GrupoIntegrante[0].Grupo.numero
    #      else
    #        @solicitud.numero_empresa = 0
    #        @solicitud.numero_grupo = 0
    #      end
    #    end

    @solicitud.banco_origen = 'Fondas'
    @solicitud.transcriptor = @usuario.nombre_usuario

      @solicitud.monto_solicitado = @solicitud.monto_cliente
      @solicitud.monto_analista = @solicitud.monto_cliente
      unless @solicitud.sub_sector.nil?
        unless @solicitud.sub_sector.nemonico == 'MA'
          @solicitud.por_inventario = false
        else
          @solicitud.por_inventario = true
        end
      end
      if @solicitud.save_new == true
        flash[:notice] = "El trámite #{@solicitud.numero} se ha generado con éxito"
        render :update do |page|
          page.redirect_to :action=>'edit', :id => @solicitud.id
        end
      else
        render :update do |page|
          page.form_error
        end
        return
      end
#      @solicitud.crear_recaudos()
  end

  def delete
    @solicitud = Solicitud.find(params[:id])
    Prestamo.delete_all(["solicitud_id = ?", @solicitud.id])
    SolicitudRecaudo.delete_all(["solicitud_id = ?", @solicitud.id])
    Garantia.delete_all(["solicitud_id = ?", @solicitud.id])
    form_delete @solicitud
  end

  def edit
    @solicitud = Solicitud.find(params[:id])
    if !@solicitud.tramitando and @solicitud.migracion
      logger.debug "<<<<<<<<<<<<<<<<<<<<<<<<<<< paso por el if"
      render  :update do |page|
        page.alert 'Solicitud no puede ser modificada, ver estatus'
        page.redirect_to :action=>'view'
        return
      end
    else
      logger.debug "<<<<<<<<<<<<<<<<<<<<<<<<<<< paso por el else"
      @cliente = @solicitud.cliente
      @region_select = Region.find(:all, :order=>'nombre')
      @modalidad_select = ModalidadFinanciamiento.find(:all, :conditions=>['id in (select modalidad_financiamiento_id from programa_modalidad_financiamiento where programa_id = ?)', @solicitud.programa_id], :order=>'nombre')
      @tipo_iniciativa_select = TipoIniciativa.find(:all, :order=>'nombre')
      fill()
      programa_fill(@solicitud.programa_id)
      sector_fill(@solicitud.sector_id)
    end
  end

  def save_edit
    @solicitud = Solicitud.find(params[:id])
    sector_id = @solicitud.sector_id
    @solicitud.usuario = @usuario
    total = Solicitud.count(:conditions => "id not in (#{@solicitud.id}) and cliente_id = #{@solicitud.cliente_id} and actividad_id = #{params[:solicitud][:actividad_id]} and estatus_id not in (10070, 10100, 10110, 10024, 10080, 10035)")
    if total > 0
      if @solicitud.cliente.type.to_s == "ClientePersona"
        beneficiario = @solicitud.cliente.persona.nombre_corto
      else
        beneficiario = @solicitud.cliente.empresa.nombre
      end
      @solicitud.errors.add(nil, "El Beneficiario #{beneficiario} posee un trámite en la ruta del financiamiento.")
      render :update do |page|
        page.hide 'message'
        page.form_error
       end
       return false
    end
    form_save_edit @solicitud
    @solicitud.monto_solicitado = @solicitud.monto_cliente
    @solicitud.monto_analista = @solicitud.monto_cliente
    unless @solicitud.sub_sector.nemonico == 'MA'
      @solicitud.por_inventario = false
    else
      @solicitud.por_inventario = true
    end
    @solicitud.save
    unless sector_id == @solicitud.sector_id
      @solicitud.crear_recaudos()
    end
    return
  end

  def auto_complete_for_cliente_nombre
    nombre = params[:cliente][:nombre].strip.downcase
    @clientes = ClienteEmpresa.find(:all,
        :conditions => [ 'LOWER(nombre) LIKE ? OR LOWER(nombre) LIKE ?',
              '%' + nombre + '%', '%' + nombre + '%' ],
         :include=>'empresa',
          :order => 'nombre ASC',
          :limit => 15)
    @clientes.concat(ClientePersona.find(:all,
        :conditions => [ 'LOWER(primer_nombre) LIKE ? OR LOWER(primer_apellido) LIKE ?',
              '%' + nombre + '%', '%' + nombre + '%' ],
         :include=>'persona',
          :order => 'primer_nombre ASC',
          :limit => 15))

    @clientes.uniq! if @clientes

    render :partial=>'list_nombre'

  end

  def view
    @solicitud = Solicitud.find(params[:id])
    @cliente = @solicitud.cliente
    @accion = params[:action]
  end

  def ubicacion
    unless params[:id].to_i == 3
      @solicitud_id = params[:solicitud_id]
      @cliente = Cliente.find(params[:cliente_id])
      if @cliente.type.to_s == "ClienteEmpresa"
        if params[:id].to_i == 1
          @direccion = EmpresaDireccion.find(:first, :conditions=>["empresa_id = ? and tipo = 'P'", @cliente.empresa.id])
        else
          @direccion = EmpresaDireccion.find(:first, :conditions=>["empresa_id = ? and unidad_negocio = true", @cliente.empresa.id])
        end
      else
        if params[:id].to_i == 1
          @direccion = PersonaDireccion.find(:first, :conditions=>["persona_id = ? and tipo = 'H'", @cliente.persona.id])
        else
          @direccion = PersonaDireccion.find(:first, :conditions=>["persona_id = ? and unidad_negocio = true", @cliente.persona.id])
        end
      end

      if @direccion.nil?
        if params[:id].to_i == 1
          mensaje = "El cliente no posee ubicación de la 'Sede Principal'"
        else
          mensaje = "El cliente no posee ubicación marcada como 'Unidad de Negocio'"
        end
        render :update do |page|
          page.alert mensaje
        end
        return
      else
        render :update do |page|
          page.replace_html 'region-select', "<label>#{@direccion.ciudad.estado.region.nombre}</label>
                            <input type='hidden' name='solicitud[region_id]' value='#{@direccion.ciudad.estado.region.id}'>"
          page.replace_html 'estado-select', "<label>#{@direccion.ciudad.estado.nombre}</label>
                            <input type='hidden' name='solicitud[estado_id]' value='#{@direccion.ciudad.estado.id}'>"
          page.replace_html 'ciudad-select', "<label>#{@direccion.ciudad.nombre}</label>
                            <input type='hidden' name='solicitud[ciudad_id]' value='#{@direccion.ciudad.id}'>"
          page.replace_html 'municipio-select', "<label>#{@direccion.municipio.nombre}</label>
                            <input type='hidden' name='solicitud[municipio_id]' value='#{@direccion.municipio.id}'>"
          page.replace_html 'eje-select', "<label>#{@direccion.municipio.eje.nombre}</label>
                            <input type='hidden' name='solicitud[eje_id]' value='#{@direccion.municipio.eje.id}'>"
          page.replace_html 'parroquia-select', :partial => 'link_select'
          page << 'inputChange();'
        end
      end
    else
      unless params[:solicitud_id].nil?
        @solicitud = Solicitud.find(params[:solicitud_id])
      end
      @region_select = Region.find(:all, :order=>'nombre')
      fill(@region_select.first.id)
      render :update do |page|
        page.replace_html 'region-select', :partial => 'region_select'
        page.replace_html 'estado-select', :partial => 'estado_select'
        page.replace_html 'ciudad-select', :partial => 'ciudad_select'
        page.replace_html 'municipio-select', :partial => 'municipio_select'
        page.replace_html 'eje-select', :partial => 'eje_select'
        page.replace_html 'parroquia-select', :partial => 'parroquia_select'
      end
    end
  end

  def region_change
    estado_fill(params[:region_id])
    render :update do |page|
      page.replace_html 'estado-select', :partial => 'estado_select'
      page.replace_html 'ciudad-select', :partial => 'ciudad_select'
      page.replace_html 'municipio-select', :partial => 'municipio_select'
      page.replace_html 'parroquia-select', :partial => 'parroquia_select'
    end
  end

  def estado_change
    ciudad_fill(params[:estado_id])
    municipio_fill(params[:estado_id])
    render :update do |page|
      page.replace_html 'ciudad-select', :partial => 'ciudad_select'
      page.replace_html 'municipio-select', :partial => 'municipio_select'
      page.replace_html 'parroquia-select', :partial => 'parroquia_select'
    end
  end

  def municipio_change
    municipio_id = params[:municipio_id]
    parroquia_fill(municipio_id)
    eje_fill(municipio_id)
    render :update do |page|
      page.replace_html 'eje-select', :partial => 'eje_select'
      page.replace_html 'parroquia-select', :partial => 'parroquia_select'
    end
  end

  def propuesta_social_trabajadores_change
    @solicitud = Solicitud.new
    if  params[:propuesta_social_trabajadores] == "true"
      render :update do |page|
        page.hide 'error'
        page.replace_html "trabajadores", :partial => "trabajadores"
        page.show "trabajadores"
      end
    else
      render :update do |page|
        page.hide 'error'
        page.hide "trabajadores"
      end
    end
  end

  def propuesta_social_comunidad_change
    @solicitud = Solicitud.new
    if  params[:propuesta_social_comunidad] == "true"
      render :update do |page|
        page.hide 'error'
        page.replace_html "comunidad", :partial => "comunidad"
        page.show "comunidad"
      end
    else
      render :update do |page|
        page.hide 'error'
        page.hide "comunidad"
      end
    end
  end

  def propuesta_social_ambiente_change
    @solicitud = Solicitud.new
    if  params[:propuesta_social_ambiente] == "true"
      render :update do |page|
        page.hide 'error'
        page.replace_html "ambiente", :partial => "ambiente"
        page.show "ambiente"
      end
    else
      render :update do |page|
        page.hide 'error'
        page.hide "ambiente"
      end
    end
  end

  def ver_observaciones
    @control_solicitud = ControlSolicitud.find(:first, :conditions=>['solicitud_id = ?', params[:id]], :order => 'id desc')
    render :update do |page|
      page.hide 'error'
      page.replace_html "error_#{params[:id]}", :partial => "observaciones".html_safe
      page.show "error_#{params[:id]}"
    end
  end

  def cerrar_observaciones
    render :update do |page|
      page.hide 'error'
      page.hide "error_#{params[:id]}"
    end
  end

  def avanzar
    @solicitud = Solicitud.find(params[:id])
    ruta = request.protocol + request.host.to_s + ":" + request.port.to_s
    if !@solicitud.validar(ruta)
      render :update do |page|
        page.hide 'message'
        page.form_error
      end
      return false
    else
      if @solicitud.decision_comite == 'D'
        @solicitud.decision_comite = nil
        @solicitud.estatus_comite = nil
        @solicitud.comentario_comite = nil
        @solicitud.causa_diferimiento_comite_id = nil
        @solicitud.causa_rechazo_comite_id = nil
        @solicitud.numero_acta_resumen_comite = nil
        @solicitud.comite_id = nil
        @solicitud.control_certificacion = false
        @solicitud.control_disponibilidad = false
      end
      estatus_id_inicial = @solicitud.estatus_id
      fecha_evento = Time.now
      @configuracion_avance = ConfiguracionAvance.find_by_estatus_origen_id(estatus_id_inicial)
      estatus_id_final = @configuracion_avance.estatus_destino_id
      estatus = Estatus.find(estatus_id_final)
      if @solicitud.estatus_id == 10001
        @solicitud.estatus_id = estatus_id_final
        @solicitud.fecha_actual_estatus = fecha_evento.strftime("%Y/%mm/%d")
        @solicitud.save
        # Crea un nuevo registro en la tabla control_solicitud
        ControlSolicitud.create_new(@solicitud.id, estatus_id_final, @usuario.id, 'Avanzar', estatus_id_inicial, '')
      else
        estatus = Estatus.find(@solicitud.estatus_id)
      end

      #nuevo codigo
      result_asignacion_auto= TecnicoCampo.asignacion_tecnico_campo(session[:oficina], @solicitud.id)
      if  result_asignacion_auto != ""
        render :update do |page|
          page.remove "row_#{@solicitud.id}"
          page.hide 'error'
          page.hide 'errorExplanation'
          page.replace_html 'message', "#{I18n.t('Sistema.Body.Modelos.Solicitud.Mensajes.tramite_numero')} #{@solicitud.numero} #{I18n.t('Sistema.Body.Modelos.Solicitud.Mensajes.asignado_tecnico_campo')} #{result_asignacion_auto}."
          page.show 'message'
        end
        return false
      else
        render :update do |page|
          page.hide 'message'
          page.replace_html 'errorExplanation',"<h2>#{I18n.t('Sistema.Body.Vistas.General.advertencia')}</h2><p><UL></UL></p>#{I18n.t('Sistema.Body.Modelos.Solicitud.Mensajes.tramite_no_asignado')}"
          page.show 'errorExplanation'
          page.<< "window.scrollTo(0,130);"
        end
        return false

      end

      #fin nuevo codigo
      #lo que estaba dentro del if estaba anteriormente aqui

    end
  end

  def programa_change
    @solicitud = Solicitud.new
    programa_id = params[:programa_id]
    if programa_id.blank?
      programa_id = nil
      programa = nil
    else
      programa = Programa.find(programa_id)
      @solicitud.programa = programa
    end
    modalidad_financiamiento_fill(programa_id)
    #@destino_credito_select = DestinoCredito.find(:all)
    origen_fondo_fill(programa_id)
    @modalidad_select = programa.modalidades_financiamiento unless programa.nil?
    #@misiones = Mision.find(:all,:conditions=>['id in (select mision_id from programa_mision where programa_id = ?)',programa_id])
    sector_fill(0)
    render :update do |page|
      page.hide 'hectarea'
      page.hide 'semovientes'
      page.hide 'maquinaria'
      page.replace_html 'origen_fondo-select', :partial => 'origen_fondo_select'.html_safe
      page.replace_html 'modalidad-select', :partial => 'modalidad_financiamiento_select'.html_safe
      page.replace_html 'sub-sector-select', :partial => 'sub_sector_blanco'.html_safe
      page.replace_html 'rubro-select', :partial => 'rubro_blanco'.html_safe
      page.replace_html 'sub_rubro-select', :partial => 'sub_rubro_blanco'.html_safe
      page.replace_html 'actividad-select', :partial => 'actividad_blanco'.html_safe
    end
  end

  def rechazar
    @solicitud = Solicitud.find(params[:id])
    estatus = Estatus.find(:first, :conditions=>["const_id = 'ST0024'"])
    estatus_id_inicial = @solicitud.estatus_id
    @solicitud.estatus_id = estatus.id
    fecha_evento = Time.now
    @solicitud.fecha_actual_estatus = fecha_evento.strftime("%Y/%mm/%d")
    @solicitud.save
    # Crea un nuevo registro en la tabla control_solicitud
    ControlSolicitud.create_new(@solicitud.id, estatus.id, @usuario.id, 'Rechazar', estatus_id_inicial, '')
    render :update do |page|
      page.remove "row_#{@solicitud.id}"
      page.hide 'error'
      page.replace_html 'message', "El Trámite Número #{@solicitud.numero} fue rechazado con Exito."
      page.show 'message'
    end
    return false
  end

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Vistas.General.solicitudes')
    @form_title_record = I18n.t('Sistema.Body.Vistas.General.solicitud')
    @form_title_records = I18n.t('Sistema.Body.Vistas.General.solicitudes')
    @form_entity = 'solicitud'
    @form_identity_field = 'numero'
    @width_layout = '1000'
  end

  private

  def fill()
    unless @solicitud.nil?
      modalidad_financiamiento_fill(@solicitud.programa_id)
      origen_fondo_fill(@solicitud.programa_id)
    end
    @unidad_produccion_select = UnidadProduccion.find(:all, :conditions=>['cliente_id = ?', @cliente.id], :order=>'nombre')
  end

  def modalidad_financiamiento_fill(programa_id)
    unless programa_id.blank?
      programa = Programa.find(programa_id)
      @modalidad_financiamiento_select = programa.modalidades_financiamiento
    else
      @modalidad_financiamiento_select = []
    end
  end

  def origen_fondo_fill(programa_id)
    unless programa_id.blank?
      @programa = Programa.find(programa_id)
      @programa_origen_fondo_select = OrigenFondo.find(:all, :conditions=>["activo=true and id in (select origen_fondo_id from programa_origen_fondo where programa_id = ?)", @programa.id], :order=>'nombre') unless @programa.nil?
    else
      @programa_origen_fondo_select = []
    end
  end

  def programa_fill(programa_id)
    if programa_id.blank?
      logger.debug "--------------------------------- paso por aqui 1"
      @programa = Programa.find(:all, :conditions=>['activo=true and id in (select programa_id from programa_tipo_cliente where tipo_cliente_id = ? )',@cliente.tipo_cliente_id], :order=>'nombre')
      @modalidad_select = ModalidadFinanciamiento.find(:all, :conditions=>"activo = true", :order=>'nombre')
      @programa_origen_fondo_select = OrigenFondo.find(:all, :conditions=>["activo=true and id in (select origen_fondo_id from programa_origen_fondo where programa_id = ?)", @programa[0].id], :order=>'nombre')
    else
      logger.debug "--------------------------------- paso por aqui 2"
      @programa = Programa.find(:all, :conditions=>['activo=true and id in (select programa_id from programa_tipo_cliente where tipo_cliente_id   = ? )',@solicitud.cliente.tipo_cliente_id], :order=>'nombre')
      @programa_origen_fondo_select = OrigenFondo.find(:all, :conditions=>["activo=true and id in (select origen_fondo_id from programa_origen_fondo where programa_id = ?)", @solicitud.programa_id], :order=>'nombre')
    end
    logger.debug "--------------------------------------------- total de registros " + programa_id.to_s
  end

  def sector_fill(sector_id)

    #@integrante_list = EmpresaIntegrante.find(:all, :conditions=>['empresa_id in (select empresa_id from cliente where id = ?)', @solicitud.cliente_id]) unless @solicitud.nil?
    @sector_list = Sector.find(:all, :conditions=>"activo=true",:order=>'nombre')
    if sector_id.to_i > 0
      sub_sector_fill(sector_id)
    else
      sub_sector_fill(0)
    end
  end

  def sub_sector_fill(sector_id)
    if sector_id.to_i > 0
      @sub_sector_list = SubSector.find(:all, :conditions=>['activo=true and sector_id = ?', sector_id], :order=>'nombre')
      if @solicitud.nil?
        rubro_fill(0)
      else
        rubro_fill(@solicitud.sub_sector_id)
      end
    else
      @sub_sector_list = []
      rubro_fill(0)
    end
  end

  def sub_sector_form_fill(sector_id, programa_id)
    if sector_id.to_s.length > 0
      @sub_sector_list = SubSector.find(:all, :conditions=>['activo=true and sector_id = ? and id in (select sub_sector_id from producto where programa_id = ? and sector_id = ?)', sector_id, programa_id, sector_id], :order=>'nombre')
      unless @solicitud.nil?
        rubro_form_fill(@solicitud.sub_sector_id)
      else
        rubro_fill(0)
      end
    else
      @sub_sector_list = []
      rubro_fill(0)
    end
  end

  def rubro_fill(sub_sector_id)
    if sub_sector_id.to_i > 0
      @rubro_list = Rubro.find(:all, :conditions=>["activo=true and sub_sector_id = #{sub_sector_id} and activo = true "], :order=>'nombre')
      unless @solicitud.nil?
        sub_rubro(@solicitud.rubro_id)
      else
        sub_rubro(nil)
      end
    else
      @rubro_list = []
      sub_rubro(nil)
    end
  end

  def sub_rubro(id)
    unless id.nil?
      @sub_rubro_list = SubRubro.find(:all, :conditions=>['activo = true and rubro_id = ?', id], :order => 'nombre')
    else
      @sub_rubro_list =[]
    end
    unless @solicitud.nil?
      actividad(@solicitud.sub_rubro_id)
    else
      actividad(nil)
    end
  end

  def actividad(id)
    unless id.blank?
      @actividad_list = Actividad.find(:all, :conditions=>["activo = true and sub_rubro_id = ? and id in (select actividad_id from actividad_oficina where activo = true and oficina_id = #{session[:oficina]})", id.to_s], :order => 'nombre')
    else
      @actividad_list =[]
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
