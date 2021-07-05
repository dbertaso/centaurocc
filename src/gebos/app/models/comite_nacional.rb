# encoding: utf-8

#
# autor: Marvin Alfonzo
# clase: ComiteNacional
# descripción: Migración a Rails 3
#

class ComiteNacional < ActiveRecord::Base  
  
  self.table_name = 'comite_nacional'
  
  belongs_to :rubro
  belongs_to :solicitud
  
  def self.decision_comite(params,usuario_id) 
  
    # Se cambió la forma de actualización de recorrido de un arreglo y
    # múltiples llamadas de actualización a la base de datos
    # por llamada a una función en la base de datos (DB-20130715) 
      
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
        
        ejecutar = execute_sp('aprobacion_comite_nacional', params.values_at(
              :p_solicitudes,
              :p_hay_items,
              :p_tipo_decision,
              :p_comentario,
              :p_usuario_id))
      end
           
      #logger.info "Array #{params[:decision_solicitud_id].inspect}"
      #array_solicitudes.each { |x|        
        ## 10034(nacional) -> 10040(documentacion) , 10035 ->(Rechazado)
        #solicitud=Solicitud.find(x)
        #estatus_id_inicial=solicitud.estatus_id
        ##configuracion_avance = ConfiguracionAvance.find_by_estatus_origen_id(estatus_id_inicial)
        
        #solicitud.decision_comite_nacional=params[:tipo_decision]
        #solicitud.comentario_comite_nacional=params[:comentario]

        #estatus_id_final=solicitud.estatus_id
        
        ##logger.info "Decision =======> #{params[:tipo_decision]}"
        #if params[:tipo_decision] == 'A'          
          #estatus_id_final = 10040
          #solicitud.fecha_aprobacion=Time.now
          #solicitud.monto_aprobado=solicitud.monto_solicitado

        #elsif params[:tipo_decision]=='R'
        	##==================================================================================
        	## LLAMADA DEL COMPROMISO PARA SIGA ELABORADO POR ALEX CIOFFI 23/04/2013
					#begin
						#transaction do
							#SigaCompromiso.generar(solicitud,'R')
						#end
					#end
        	##==================================================================================
          #estatus_id_final = 10035
          #solicitud.fecha_aprobacion=nil
          #solicitud.monto_aprobado=0
          #ComiteEstadal.liberar_recursos(solicitud)

        #elsif params[:tipo_decision]=='D'
          #estatus_id_final = estatus_id_inicial
          #solicitud.fecha_aprobacion=nil
          #solicitud.monto_aprobado=0
        #end
        
        #solicitud.estatus_id = estatus_id_final
        #solicitud.save

        #fecha_actual=Time.now

        #cdh=ComiteDecisionHistorico.find(:first,:conditions=>"solicitud_id=#{x} and comite_id=#{solicitud.comite_id}")
        #cdh.decision=params[:tipo_decision]
        #cdh.comentario=solicitud.comentario_comite_nacional
        #cdh.fecha_decision=fecha_actual
        #cdh.save!        
        
        #solicitud.update_attribute('estatus_id',estatus_id_final)        
        #ControlSolicitud.create(
                #:solicitud_id=>solicitud.id,
                #:estatus_id=>estatus_id_inicial,
                #:usuario_id=>usuario_id,
                #:fecha => fecha_actual,
                #:estatus_origen_id => estatus_id_final,
                #:accion => 'Avanzar'
        #)        
      #}
    end
  end

end
