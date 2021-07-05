# encoding: utf-8

#
# autor: Marvin Alfonzo
# clase: ComiteEstadal
# descripción: Migración a Rails 3
#

class ComiteEstadal < ActiveRecord::Base

  self.table_name = 'comite_estadal'
  
  def self.decision_comite(params,usuario_id)
    
    transaction do
      
      #array_solicitudes=params[:decision_solicitud_id].split(',')
      array_solicitudes = '{' + params[:decision_solicitud_id] + '}'
      
      logger.info "Array #{array_solicitudes.inspect}"
      unless array_solicitudes.empty?
      
        #Se invoca la función de actualización de la decisión del comite estadal
        
        params = {
          :p_solicitudes=>array_solicitudes,
          :p_hay_items =>true,
          :p_tipo_decision =>params[:tipo_decision],
          :p_comentario=>params[:comentario],
          :p_usuario_id=>usuario_id
        }
        
        ejecutar = execute_sp('aprobacion_comite_estadal', params.values_at(
              :p_solicitudes,
              :p_hay_items,
              :p_tipo_decision,
              :p_comentario,
              :p_usuario_id))
      end

      #array_solicitudes.each { |x|        
        #solicitud            = Solicitud.find(x)
        #estatus_id_inicial   = solicitud.estatus_id
        #configuracion_avance = ConfiguracionAvance.find_by_estatus_origen_id(estatus_id_inicial)        
        #solicitud.decision_comite_estadal   = params[:tipo_decision]
        #solicitud.comentario_comite_estadal = params[:comentario]
        #estatus_id_final                    = 10033
        #parametro_general=ParametroGeneral.find(:all)[0]

        #if params[:tipo_decision]=='A'
          ##if solicitud.monto_solicitado>100000
          #if solicitud.monto_solicitado>parametro_general.banda_inferior_comite_credito
            #estatus_id_final = configuracion_avance[:estatus_destino_id] #10034
          #else
            #estatus_id_final = 10040
          #end
          #solicitud.fecha_aprobacion=Time.now
          #solicitud.monto_aprobado=solicitud.monto_solicitado
          
        	##==================================================================================
        	## LLAMADA DEL COMPROMISO PARA SIGA ELABORADO POR ALEX CIOFFI 23/04/2013
					#begin
						#transaction do
							#SigaCompromiso.generar(solicitud,'C')
						#end
					#end
        	##==================================================================================
        
        #elsif params[:tipo_decision]=='R'
          #estatus_id_final = 10024
          #ComiteEstadal.liberar_recursos(solicitud)
          ##estatus_id_final = configuracion_avance[:estatus_destino_id]
        #end
        
        #solicitud.estatus_id = estatus_id_final
        #solicitud.save
        
        #fecha_actual=Time.now

        #cdh=ComiteDecisionHistorico.find(:first,:conditions=>"solicitud_id=#{x} and comite_id=#{solicitud.comite_estadal_id}")
        #cdh.decision=params[:tipo_decision]
        #cdh.comentario=solicitud.comentario_comite_estadal
        #cdh.fecha_decision=fecha_actual
        #cdh.save!
        
        #ControlSolicitud.create(
                #:solicitud_id=>solicitud.id,
                #:estatus_id=>estatus_id_final,
                #:usuario_id=>usuario_id,
                #:fecha => fecha_actual,
                #:estatus_origen_id => estatus_id_inicial,
                #:comentario => params[:comentario],
                #:accion => 'Avanzar'
        #)
      #}
      
    end
  end
  
  def self.liberar_recursos(solicitud)
    if solicitud.por_inventario == true
      Catalogo.find_by_sql("UPDATE catalogo SET solicitud_id = null, estatus = 'L' where solicitud_id = #{solicitud.id}")
    else
      p = PresupuestoPidan.find(:all, :conditions=>"estado_id = #{solicitud.UnidadProduccion.Ciudad.estado_id} and sub_rubro_id = #{solicitud.sub_rubro_id} and programa_id = #{solicitud.programa_id}")
      pidan = p[0]
      pidan.compromiso = pidan.compromiso - solicitud.monto_solicitado
      pidan.disponibilidad = pidan.disponibilidad + solicitud.monto_solicitado
      pidan.save!
    end
  end
  
#  def self.cerrar_comite numero_comite_estadal
#    comite = Comite.find_by_numero(numero_comite_estadal)
#    total = Solicitud.count(:all,:conditions=>"numero_comite_estadal= '#{numero_comite_estadal}'",:group=>"numero_comite_estadal")
#    total_con_decision = Solicitud.count(:all,:conditions=>"numero_comite_estadal= '#{numero_comite_estadal}' and decision_comite_estadal is not null ",:group=>"numero_comite_estadal")
#    if total[numero_comite_estadal].to_i==total_con_decision[numero_comite_estadal].to_i
#     comite.update_attribute("solicitudes_decision_activo",false)
#    end
#  end
  
end
