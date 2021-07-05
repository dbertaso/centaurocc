# encoding: utf-8

#
# autor: Marvin Alfonzo
# clase: PresupuestoPidan
# descripción: Migración a Rails 3
#

class PresupuestoPidan < ActiveRecord::Base
  
  self.table_name = 'presupuesto_pidan'
  
  
  attr_accessible :id,
                  :rubro_id,
                  :disponibilidad,
                  :estado_id,
                  :presupuesto,
                  :compromiso,
                  :sub_rubro_id,
                  :programa_id,
                  :monto_liquidado,
                  :monto_por_liquidar

  
  belongs_to :rubro
  belongs_to :sub_rubro
  belongs_to :estado
  belongs_to :programa
  
  def disponibilidad_fm
      unless @disponibilidad.nil?        
        format_fm(@disponibilidad)
      end
  end
    

  def validar_transferencia(disponible_origen,monto_transferencia)
      success = true
      errores = 0
      
      if monto_transferencia.match(/^\-{0,1}\d+\.{0,1}\d{0,2}$/)
      
      
	if monto_transferencia.to_f > 0
	  if disponible_origen.to_f < monto_transferencia.to_f
	    errors.add(:presupuesto_pidan,I18n.t('Sistema.Body.Modelos.Errores.no_hay_recursos_en_el_subrubro_para_transferencia'))
	    errores += 1
	  end
	else
	  errors.add(:presupuesto_pidan,"#{I18n.t('Sistema.Body.Vistas.General.monto')} #{I18n.t('errors.messages.greater_than',:count=>0)}")
	  errores += 1	
	end
  
      else	
	  errors.add(:presupuesto_pidan,"#{I18n.t('Sistema.Body.Vistas.General.monto')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalido')}")
	  errores += 1	
      end
      
      if (errores > 0)
        success = false
  
      end
      return success
  
  
    end

  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
             :conditions => search, :order => sort,:include=>[:rubro,:sub_rubro,:estado,:programa]
  end
  
  def self.actualizar_transferencia(params, usuario_id)
  
    begin
    
      PresupuestoPidan.transaction do
	
        @presupuesto_transferencia = PresupuestoTransferencia.new(params[:presupuesto_transferencia])
        @presupuesto_transferencia.usuario_id = usuario_id
        @presupuesto_transferencia.fecha_registro = Time.now
        @presupuesto_transferencia.programa_id_destino = params[:presupuesto_transferencia][:programa_id_origen]
        
        success = true

        if @presupuesto_transferencia.save
        
          @presupuesto_pidan_origen = PresupuestoPidan.find(:first, :conditions=>['programa_id = ? and sub_rubro_id = ? and estado_id = ?', 
                                              params[:presupuesto_transferencia][:programa_id_origen], params[:presupuesto_transferencia][:sub_rubro_id_origen],params[:presupuesto_transferencia][:estado_id_origen]])     
        
          @presupuesto_pidan_origen.disponibilidad =  @presupuesto_pidan_origen.disponibilidad - params[:presupuesto_transferencia][:monto_transferencia].to_f
          @presupuesto_pidan_origen.presupuesto = @presupuesto_pidan_origen.presupuesto - params[:presupuesto_transferencia][:monto_transferencia].to_f
          @presupuesto_pidan_origen.save 

        
          @presupuesto_pidan_destino = PresupuestoPidan.find(:first, 
            :conditions=>['programa_id = ? and sub_rubro_id = ? and estado_id = ?',params[:presupuesto_transferencia][:programa_id_origen], params[:presupuesto_transferencia][:sub_rubro_id_destino],params[:presupuesto_transferencia][:estado_id_destino]])

          @presupuesto_pidan_destino.disponibilidad =  @presupuesto_pidan_destino.disponibilidad + params[:presupuesto_transferencia][:monto_transferencia].to_f
          @presupuesto_pidan_destino.presupuesto =  @presupuesto_pidan_destino.presupuesto + params[:presupuesto_transferencia][:monto_transferencia].to_f
          if @presupuesto_pidan_destino.save  

          return true
          
          end
        else
          return false
        end
		
      end     #====> end transaction do
      
      return true
      
    rescue => detail
    
      logger.info detail.backtrace.join("\n")
      return false
    end
  
  end
  
  
  
  def parametros_verificacion(params)
  
    
    errores=0
   if params[:presupuesto_transferencia][:programa_id_origen]==""
     errors.add(:presupuesto_pidan,"#{I18n.t('Sistema.Body.Vistas.General.programa')} #{I18n.t('Sistema.Body.Vistas.General.origen')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
     errores += 1
   end
   if params[:presupuesto_transferencia][:estado_id_origen]==""
     errors.add(:presupuesto_pidan,"#{I18n.t('Sistema.Body.Vistas.General.estado')} #{I18n.t('Sistema.Body.Vistas.General.origen')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
     errores += 1
   end
   if params[:presupuesto_transferencia][:rubro_id_origen]==""
     errors.add(:presupuesto_pidan,"#{I18n.t('Sistema.Body.Vistas.General.rubro')} #{I18n.t('Sistema.Body.Vistas.General.origen')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
     errores += 1
   end
   if params[:presupuesto_transferencia][:sub_rubro_id_origen]==""
     errors.add(:presupuesto_pidan,"#{I18n.t('Sistema.Body.Vistas.General.sub_rubro')} #{I18n.t('Sistema.Body.Vistas.General.origen')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
     errores += 1
   end
   if params[:presupuesto_transferencia][:estado_id_destino]==""
     errors.add(:presupuesto_pidan,"#{I18n.t('Sistema.Body.Vistas.General.estado')} #{I18n.t('Sistema.Body.Vistas.Form.destino')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
     errores += 1
   end
   if params[:presupuesto_transferencia][:rubro_id_destino]==""
     errors.add(:presupuesto_pidan,"#{I18n.t('Sistema.Body.Vistas.General.rubro')} #{I18n.t('Sistema.Body.Vistas.Form.destino')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
     errores += 1
   end
   if params[:presupuesto_transferencia][:sub_rubro_id_destino]==""
     errors.add(:presupuesto_pidan,"#{I18n.t('Sistema.Body.Vistas.General.sub_rubro')} #{I18n.t('Sistema.Body.Vistas.Form.destino')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
     errores += 1
   end
   
   if params[:presupuesto_transferencia][:observaciones_justificacion].to_s.strip==""
     errors.add(:presupuesto_pidan,"#{I18n.t('Sistema.Body.Vistas.General.justificacion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerida')}")
     errores += 1
   end
   
     if (errores > 0)
        return false
     else   
      return true  
     end
     
     
  end
  
  
  
  
  def self.liberar(solicitudes, usuario_id)
    logger.info"XXXXXX=========liberar-usuario====>>>>>"<<usuario_id.inspect
    estatus_id_inicial = 10010
    
    @estatus_destino = Estatus.find_by_sql("select estatus_destino_id from configuracion_avance where estatus_origen_id = (select estatus_origen_id from control_solicitud where estatus_id = 10010 limit 1)")
    estatus_id_nuevo = @estatus_destino[0].estatus_destino_id
    fecha_evento = Time.now
    #fecha_actual_estatus = fecha_evento.strftime("%Y/%m/%d")
    
        id = ''
    begin

      transaction do

        solicitudes.each do |solicitud|

          @solicitud = Solicitud.find(solicitud.to_i)
          if @solicitud.nil?
            return 1 
          else
            @presupuesto_pidan = PresupuestoPidan.find(:first, :conditions=>["programa_id = #{@solicitud.programa_id} and rubro_id = #{@solicitud.rubro_id} and estado_id = #{@solicitud.unidad_produccion.municipio.estado.id} and sub_rubro_id = #{@solicitud.sub_rubro_id}"])
            logger.info"XXXXXX=========presupuestopidan====>>>>>"<<@presupuesto_pidan.inspect.to_s
            
            if (@solicitud.monto_aprobado.to_f <= @presupuesto_pidan.disponibilidad.to_f)
              @presupuesto_pidan.disponibilidad = @presupuesto_pidan.disponibilidad - @solicitud.monto_aprobado
              @presupuesto_pidan.compromiso = @presupuesto_pidan.compromiso + @solicitud.monto_aprobado
              successPD = @presupuesto_pidan.save
              if !successPD
                errors.add(:presupuesto_pidan, "#{I18n.t('Sistema.Body.Modelos.Desembolso.Errores.actualizar_tramite')}#{@solicitud.numero}")
                return false
              end
              ActiveRecord::Base.connection.execute("insert into control_solicitud (fecha,estatus_id,solicitud_id,usuario_id,estatus_origen_id,accion)(select '#{fecha_evento}',#{estatus_id_nuevo},#{solicitud.to_i},#{usuario_id},#{estatus_id_inicial},'#{I18n.t('Sistema.Body.Vistas.PresupuestoPidan.Mensajes.presupuesto_asignado')}' from solicitud where id = #{solicitud.to_i} and estatus_id = #{estatus_id_inicial})")
              logger.info"XXXXXX=========insert-control_solicitud=======>>>>"
              #ActiveRecord::Base.connection.execute("update solicitud set estatus_id = #{estatus_id_nuevo} where estatus_id= #{estatus_id_inicial} and rubro_id = #{@params[:rubro_id]} and unidad_produccion_id in (select up.id from unidad_produccion up, municipio m where up.municipio_id = m.id and m.estado_id = #{@params[:estado_id]})")
              @solicitud.estatus_id = estatus_id_nuevo
              success = @solicitud.save
              logger.info"XXXXXX=========update-solicitud=======>>>>"<<success.inspect
              if !success
                errors.add(:presupuesto_pidan, "#{I18n.t('Sistema.Body.Modelos.Desembolso.Errores.actualizar_tramite')}#{@solicitud.numero}")
                return false
              end 
              id = id << solicitud.to_s << ','
              logger.info"XXXXXX=========update-solicitud=======>>>>"<<id.inspect
            end
          end    
            
        end
      end
      rescue Exception => e
        logger.error e.message
        logger.error e.backtrace.join("\n")
        logger.info"XXXXX==========E======>>>>>>"<<e.inspect
       return false
    end
    return 0, id
    
  end
  
end



# == Schema Information
#
# Table name: presupuesto_pidan
#
#  id                 :integer         not null, primary key
#  rubro_id           :integer         not null
#  disponibilidad     :decimal(16, 2)
#  estado_id          :integer         not null
#  presupuesto        :decimal(16, 2)  not null
#  compromiso         :decimal(16, 2)  not null
#  sub_rubro_id       :integer
#  programa_id        :integer         default(0), not null
#  monto_liquidado    :decimal(16, 2)  default(0.0)
#  monto_por_liquidar :decimal(16, 2)  default(0.0)
#

