# encoding: utf-8

#
#
# clase: FacturaOrdenDespacho
# autor: Marvin Alfonzo
# descripción: Migración a Rails 3
#


class FacturaOrdenDespacho < ActiveRecord::Base

    self.table_name = 'factura_orden_despacho'


    attr_accessible :id,
                    :orden_despacho_detalle_id,
                    :item_nombre,
                    :unidad_medida_id,
                    :cantidad,
                    :costo_real,
                    :monto_financiamiento,
                    :casa_proveedora_id,
                    :sucursal_casa_proveedora_id,
                    :numero_factura,
                    :monto_factura,
                    :cantidad_factura,
                    :fecha_factura,
                    :fecha_emision,
                    :confirmada,
                    :secuencia,
                    :emitida,
                    :factura_estatus_id,
                    :fecha_factura_f,
                    :fecha_emision_f



belongs_to :unidad_medida
belongs_to :orden_despacho_detalle
belongs_to :casa_proveedora
belongs_to :sucursal_casa_proveedora



  def cantidad_f=(valor)
    self.cantidad = format_valor(valor)
  end

  def cantidad_f
    format_fm(self.cantidad)
  end


  def costo_real_f=(valor)
    self.costo_real = format_valor(valor)
  end

  def costo_real_f
    format_fm(self.costo_real)
  end



  def costo_real_fm
    format_fm(self.costo_real)    
  end


  def monto_financiamiento_f=(valor)
    self.monto_financiamiento = format_valor(valor)
  end

  def monto_financiamiento_f
    format_fm(self.monto_financiamiento)
  end

  def monto_financiamiento_fm
    format_fm(self.monto_financiamiento)
  end


  def monto_factura_f=(valor)
    self.monto_factura = format_valor(valor)
  end

  def monto_factura_f
    format_f(self.monto_factura)
  end

  def monto_factura_fm
    format_fm(self.monto_factura)
  end


  def cantidad_factura_fm
    format_fm(self.cantidad_factura)
  end

  def cantidad_fm
    format_fm(self.cantidad)
  end



  def fecha_factura_f=(fecha)
    self.fecha_factura = fecha
  end

  def fecha_factura_f
    format_fecha(self.fecha_factura)
  end

  def fecha_emision_f=(fecha)
    self.fecha_emision = fecha
  end

  def fecha_emision_f
    format_fecha(self.fecha_emision)
  end

before_create :before_create 

def before_create

 retorno = true
=begin     se quito esta validacion de que no se pudieran generar varias facturas para la misma casa proveedora 06/06/2013
    facturas = FacturaOrdenDespacho.find(:all, :conditions => ["orden_despacho_detalle_id = ? and casa_proveedora_id = ? ", self.orden_despacho_detalle_id, self.casa_proveedora_id ])

    unless facturas.empty?     
      errors.add(nil,"La casa proveedora <label>'#{CasaProveedora.find(self.casa_proveedora_id).nombre.strip.upcase}'</label> ya está asignada para otra factura de orden de despacho detalle con id = <label>#{self.orden_despacho_detalle_id}</label>, por favor seleccione otra casa proveedora")
      retorno = false     
    end
    
=end        
    
    facturas = FacturaOrdenDespacho.find(:all, :conditions => ["sucursal_casa_proveedora_id = ? and numero_factura = ?", self.sucursal_casa_proveedora_id, self.numero_factura ])  #orden_despacho_detalle_id = ? and self.orden_despacho_detalle_id,

    unless facturas.empty?           
      errors.add(:factura_orden_despacho,I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Errores.sucursal_ya_posee_factura_numero',:numero_factura=>self.numero_factura,:sucursal_casa_proveedora=>SucursalCasaProveedora.find(self.sucursal_casa_proveedora_id).nombre.strip.upcase))
      retorno = false     
    end

    
  logger.info "saliendo del before create " << errors.inspect
return retorno

end


before_create :before_update

def before_update

	retorno = true

 
# hacer la validacion para que no me de el error de los indices


=begin se quito esta validacion el 07/06/2013
  facturas1 = FacturaOrdenDespacho.find(:all, :conditions => ["orden_despacho_detalle_id = ? and sucursal_casa_proveedora_id = ? and item_nombre = ?", self.orden_despacho_detalle_id, self.sucursal_casa_proveedora_id,self.item_nombre ])

    unless facturas1.empty?     
      errors.add(nil,"Ya existe una factura hecha para la sucursal <label>'#{SucursalCasaProveedora.find(self.sucursal_casa_proveedora_id).nombre.strip.upcase}'</label> con la orden de despacho Nº <label>#{self.orden_despacho_detalle_id}</label> para el Item <label>'#{FacturaOrdenDespacho.find(self.id).item_nombre.strip.upcase}'</label>, por favor seleccione otra sucursal")     
      retorno = false     
    end
=end
  if retorno
  facturas = FacturaOrdenDespacho.find(:all, :conditions => ["sucursal_casa_proveedora_id = ? and numero_factura = ? and orden_despacho_detalle_id = ?", self.sucursal_casa_proveedora_id,self.numero_factura.to_s,self.orden_despacho_detalle_id ])  #orden_despacho_detalle_id = ? and  self.orden_despacho_detalle_id, 
    unless facturas.empty?           

      errors.add(:factura_orden_despacho,I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Errores.numero_factura_ya_existe_sucursal',:numero_factura=>self.numero_factura.to_s.strip.upcase,:sucursal_casa_proveedora=>SucursalCasaProveedora.find(self.sucursal_casa_proveedora_id).nombre.to_s.strip.upcase)) 
      retorno = false     
    end
    
end

logger.info "saliendo del before update " << errors.inspect



return retorno

end




    def self.create(orden_despacho_id, casa_id, sucursal_id)
	

success = true
    begin
      transaction do
        ordenes_despachos_detalles=OrdenDespachoDetalle.find(:all,:conditions=>['orden_despacho_id = ?',orden_despacho_id])


      ordenes_despachos_detalles.each { |ordenes_despachos_detalle|
 logger.info "Entre aqui en el create nueva factura " << ordenes_despachos_detalle.id.to_s
      factura_orden_despacho=FacturaOrdenDespacho.new
	    factura_orden_despacho.orden_despacho_detalle_id=ordenes_despachos_detalle.id
	    factura_orden_despacho.casa_proveedora_id=casa_id
	    factura_orden_despacho.item_nombre=ordenes_despachos_detalle.item_nombre
	    factura_orden_despacho.unidad_medida_id=ordenes_despachos_detalle.unidad_medida_id
	    factura_orden_despacho.cantidad=ordenes_despachos_detalle.cantidad
	    factura_orden_despacho.costo_real=ordenes_despachos_detalle.costo_real

        #parte del codigo a cambiar, caso de aquellas ordenes donde no se recomienda el total de los insumos (3/9/2013) antes solo estaba "factura_orden_despacho.monto_financiamiento=ordenes_despachos_detalle.monto_financiamiento" sin el if
        if ( ((ordenes_despachos_detalle.cantidad * ordenes_despachos_detalle.costo_real)!=ordenes_despachos_detalle.monto_financiamiento) and (ordenes_despachos_detalle.monto_recomendado!=0))
        factura_orden_despacho.monto_financiamiento=ordenes_despachos_detalle.monto_recomendado
        else
        factura_orden_despacho.monto_financiamiento=ordenes_despachos_detalle.monto_financiamiento
        end
        #fin parte del codigo a cambiar, caso de aquellas ordenes donde no se recomienda el total de los insumos
#eliminado factura_orden_despacho.monto_financiamiento=ordenes_despachos_detalle.cantidad * ordenes_despachos_detalle.costo_real

	    #factura_orden_despacho.monto_factura=ordenes_despachos_detalle.monto_facturacion
	    factura_orden_despacho.monto_factura=0
      factura_orden_despacho.fecha_emision=Time.now
	    factura_orden_despacho.sucursal_casa_proveedora_id=sucursal_id
	    factura_orden_despacho.secuencia='1'

	    success &&=factura_orden_despacho.save


          raise Exception, "#{I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Errores.error_crear_detalle_orden_despacho')} # #{ordenes_despachos_detalle.id}" unless success
        }
      return success
      end
      rescue Exception => e
      logger.error e.message
      logger.error e.backtrace.join("\n")
      return false
    end

end


    def self.actualizacion(orden_despacho_id, casa_id, sucursal_id)
	


success = true
    begin
      transaction do
        ordenes_despachos_detalles=OrdenDespachoDetalle.find(:all,:conditions=>['orden_despacho_id = ?',orden_despacho_id])


      ordenes_despachos_detalles.each { |ordenes_despachos_detalle|

      factura_orden_despacho=FacturaOrdenDespacho.find_by_orden_despacho_detalle_id(ordenes_despachos_detalle.id)
      unless factura_orden_despacho.nil?
	    factura_orden_despacho.casa_proveedora_id=casa_id
	    factura_orden_despacho.sucursal_casa_proveedora_id=sucursal_id

	     success &&=factura_orden_despacho.save
      end  

          raise Exception, "#{I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Errores.error_actualizar_detalle_orden_despacho')} # #{ordenes_despachos_detalle.id}" unless success
        }
      return success
      end
      rescue Exception => e
      logger.error e.message
      logger.error e.backtrace.join("\n")
      return false
    end

end


  def self.actualizacion_factura(facturas_orden_despacho_id, casa_id, sucursal_id)
	

    success = true
    
    begin
    
      transaction do
      
        facturas_ordenes_despachos=FacturaOrdenDespacho.find(:all,:conditions=>"id in #{facturas_orden_despacho_id}")
        facturas_ordenes_despachos.each { |factura_orden|
          factura_orden.casa_proveedora_id=casa_id
          factura_orden.sucursal_casa_proveedora_id=sucursal_id
        
          #factura_orden.emitida=true
        
          success &&=factura_orden.save
          #viejo raise Exception, "Error al Actualizar el Detalle de la Factura de Orden de Despacho # #{factura_orden.id}" unless success
          return factura_orden.errors.full_messages[0] unless success

        }
        return success
      
      end
      
      rescue Exception => e
        logger.error e.message
        logger.error e.backtrace.join("\n")
        return e.message
      # este es el viejo return false
    end



  end



    def crear_nueva(orden_despacho_id)


success = true
    begin
      transaction do
        ordenes_despachos_detalles=OrdenDespachoDetalle.find(:all,:conditions=>['orden_despacho_id = ?',orden_despacho_id])


      ordenes_despachos_detalles.each { |ordenes_despachos_detalle|
 logger.debug "Entre aqui crear_nueva " << ordenes_despachos_detalle.id.to_s
                #factura_orden_despacho_original=FacturaOrdenDespacho.find_by_orden_despacho_detalle_id(ordenes_despachos_detalle.id)

factura_orden_despacho_originals=FacturaOrdenDespacho.find(:all,:conditions=>['orden_despacho_detalle_id = ? ',ordenes_despachos_detalle.id],:order=>"secuencia desc limit 1")

#caso en que secuencia se vaya a crear por primera vez

      factura_orden_despacho_originals.each { |factura_orden_despacho_original|
        

      logger.info "qwqwqwqwqwqwqwqwqw" << factura_orden_despacho_original.cantidad.to_s << " " << factura_orden_despacho_original.cantidad_factura.to_s

      if factura_orden_despacho_original.cantidad != factura_orden_despacho_original.cantidad_factura
      
      factura_orden_despacho=FacturaOrdenDespacho.new
	    factura_orden_despacho.orden_despacho_detalle_id=ordenes_despachos_detalle.id
	    #factura_orden_despacho.casa_proveedora_id=factura_orden_despacho_original.casa_proveedora_id
	    factura_orden_despacho.item_nombre=factura_orden_despacho_original.item_nombre
	    factura_orden_despacho.unidad_medida_id=factura_orden_despacho_original.unidad_medida_id
	    factura_orden_despacho.cantidad=((factura_orden_despacho_original.cantidad.to_f) - (factura_orden_despacho_original.cantidad_factura.to_f))
	    factura_orden_despacho.costo_real=factura_orden_despacho_original.costo_real
	    
        factura_orden_despacho.monto_financiamiento=factura_orden_despacho_original.monto_financiamiento.to_f - factura_orden_despacho_original.monto_factura.to_f
        #eliminado factura_orden_despacho.monto_financiamiento=factura_orden_despacho_original.monto_financiamiento

	    #quitado, ya no se puede hacer la multiplicacion porq no cuadra el monto con los decimales factura_orden_despacho.monto_factura=(factura_orden_despacho.cantidad * factura_orden_despacho_original.costo_real)
        factura_orden_despacho.monto_factura=(factura_orden_despacho_original.monto_financiamiento.to_f - factura_orden_despacho_original.monto_factura.to_f)
#factura_orden_despacho.monto_factura=0	    
      factura_orden_despacho.fecha_emision=Time.now
	    #factura_orden_despacho.sucursal_casa_proveedora_id=factura_orden_despacho_original.sucursal_casa_proveedora_id

      secuencia=factura_orden_despacho_original.secuencia.strip.split("-")
      valor=secuencia[secuencia.length - 1]
      valor=valor.to_i + 1
      factura_orden_despacho.secuencia=factura_orden_despacho_original.secuencia.strip + "-" + valor.to_s

logger.debug "entre aqui en crear nuevas ordenes en validar opciones " << factura_orden_despacho.inspect << "id de las facturas " << factura_orden_despacho_original.id.to_s

	    success &&=factura_orden_despacho.save
      
        
          raise Exception, "#{I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Errores.error_crear_nueva_orden')} # #{ordenes_despachos_detalle.id}" unless success
       end #del if
        }}
      return success
      end
      rescue Exception => e
      logger.error e.message
      logger.error e.backtrace.join("\n")
      return e.message
    end


end

#### crear factura con secuencia nueva individual

def crear_nueva_individual(factura_orden_despacho_id)
	
#logger.info 'valores cuando entro al create ' << orden_despacho_id.to_s << ' ' << casa_id.to_s << ' ' <<  item_nombre.to_s << ' ' <<  unidad_medida_id.to_s << ' ' <<   cantidad.to_s << ' ' <<  costo_real.to_s << ' ' <<  monto_financiamiento.to_s << ' ' <<  monto_facturacion.to_s << ' ' <<  sucursal_id.to_s



success = true
    begin
      transaction do
        
factura_orden_despacho_originals=FacturaOrdenDespacho.find(:all,:conditions=>['id = ?',factura_orden_despacho_id])

#caso en que secuencia se vaya a crear por primera vez

      factura_orden_despacho_originals.each { |factura_orden_despacho_original|

      if factura_orden_despacho_original.cantidad != factura_orden_despacho_original.cantidad_factura
      
      factura_orden_despacho=FacturaOrdenDespacho.new
	    factura_orden_despacho.orden_despacho_detalle_id=factura_orden_despacho_original.orden_despacho_detalle_id
	    #factura_orden_despacho.casa_proveedora_id=factura_orden_despacho_original.casa_proveedora_id
	    factura_orden_despacho.item_nombre=factura_orden_despacho_original.item_nombre
	    factura_orden_despacho.unidad_medida_id=factura_orden_despacho_original.unidad_medida_id
	    factura_orden_despacho.cantidad=((factura_orden_despacho_original.cantidad.to_f) - (factura_orden_despacho_original.cantidad_factura.to_f))
	    factura_orden_despacho.costo_real=factura_orden_despacho_original.costo_real
	    #factura_orden_despacho.monto_financiamiento=factura_orden_despacho_original.monto_financiamiento

#antes estaba esto (eliminado)  factura_orden_despacho.monto_financiamiento=factura_orden_despacho_original.cantidad * factura_orden_despacho_original.costo_real

#factura_orden_despacho.monto_financiamiento=factura_orden_despacho.cantidad * factura_orden_despacho.costo_real
factura_orden_despacho.monto_financiamiento=factura_orden_despacho_original.monto_financiamiento.to_f - factura_orden_despacho_original.monto_factura.to_f

	    #factura_orden_despacho.monto_factura=factura_orden_despacho_original.monto_factura

	    factura_orden_despacho.monto_factura= factura_orden_despacho.monto_financiamiento.to_f
        #factura_orden_despacho.monto_factura=OrdenDespachoDetalle.find(factura_orden_despacho_original.orden_despacho_detalle_id).monto_financiamiento.to_f - factura_orden_despacho.monto_financiamiento.to_f
        #antes estaba esto (eliminado) factura_orden_despacho.monto_factura=0
	    factura_orden_despacho.cantidad_factura=0

	    factura_orden_despacho.fecha_emision=Time.now
	    #factura_orden_despacho.sucursal_casa_proveedora_id=factura_orden_despacho_original.sucursal_casa_proveedora_id

      secuencia=factura_orden_despacho_original.secuencia.strip.split("-")
      valor=secuencia[secuencia.length - 1]
      valor=valor.to_i + 1
      factura_orden_despacho.secuencia=factura_orden_despacho_original.secuencia.strip + "-" + valor.to_s

logger.debug "entre aqui en crear nuevas ordenes en validar opciones individual" << factura_orden_despacho.inspect << "id de las facturas " << factura_orden_despacho_original.id.to_s

	    success &&=factura_orden_despacho.save
      
        
          raise Exception, "#{I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Errores.error_crear_nueva_factura')} # #{factura_orden_despacho_original.id}" unless success
       end #del if
        }
      return success
      end
      rescue Exception => e
      logger.error e.message
      logger.error e.backtrace.join("\n")
      return e.message
    end


end




#### fin de crear factura con secuencia nueva individual


  def actualizar_factura(orden_despacho_id, casa_id,fecha,factura,usuario_id,params)


#  def actualizar_plan_general(solicitud_id,params)

    logger.debug "Actualizando facturas ===============> "
    #logger.debug "PARAMETROS                ===============> " << params.inspect
    total_orden_detalle=OrdenDespachoDetalle.sum(:cantidad,:conditions=>['orden_despacho_id = ?',orden_despacho_id])
    
    @orden_despacho_detalles=OrdenDespachoDetalle.find(:all,:conditions=>['orden_despacho_id = ?',orden_despacho_id])

    @errores = ''
    as=casa_id.split(";")
    sumador_facturada=0.0
    sumador_faltante=0.0
    begin

      transaction do

        iniciar_transaccion(OrdenDespacho.find(orden_despacho_id).prestamo_id, 'p_orden_despacho_confirmacion', 'L', I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.transaccion_actualizacion_factura',:numero_orden=>orden_despacho_id), usuario_id, OrdenDespacho.find(orden_despacho_id).monto)

        @orden_despacho_detalles.each do |orden_despacho_detalle|
        
          #logger.debug "CANTIDAD #{plan.id} =======> " << params[:"cantidad_#{plan.id}"].to_s
          #logger.debug "MONTO #{plan.id} =======> " << params[:"monto_#{plan.id}"].to_s
          #parte nueva, para evitar que el monto facturado por la confirmacion sea mayor al de la orden de despacho detalle

          logger.debug "monto financiamiento de la primera orden " << orden_despacho_detalle.monto_financiamiento.to_s << " monto del confirmar de la primera orden " << params[:"monto_cantidad_facturada_#{orden_despacho_detalle.id}"].to_s
          logger.debug "El resutaldo de la mult " << (orden_despacho_detalle.costo_real.to_f * params[:"monto_cantidad_faltante_#{orden_despacho_detalle.id}"].to_f).to_s << " monto de ese item " << params[:"monto_cantidad_facturada_#{orden_despacho_detalle.id}"].to_s << "\n "
          logger.debug " retorno del if " << (!(orden_despacho_detalle.costo_real.to_f * params[:"monto_cantidad_faltante_#{orden_despacho_detalle.id}"].to_f >= params[:"monto_cantidad_facturada_#{orden_despacho_detalle.id}"].to_f)).to_s

          #eliminado esto no aplica if !((orden_despacho_detalle.costo_real.to_f * params[:"monto_cantidad_faltante_#{orden_despacho_detalle.id}"].to_f) < params[:"monto_cantidad_facturada_#{orden_despacho_detalle.id}"].to_f)
            sumador_facturada+=params[:"monto_cantidad_facturada_#{orden_despacho_detalle.id}"].to_f
          #eliminado esto no aplica else
            
            #eliminado esto no aplica sumador_facturada+=orden_despacho_detalle.monto_financiamiento.to_f - params[:"monto_cantidad_facturada_#{orden_despacho_detalle.id}"].to_f
            #eliminada sumador_facturada+=orden_despacho_detalle.costo_real.to_f * params[:"monto_cantidad_faltante_#{orden_despacho_detalle.id}"].to_f
          #eliminado esto no aplica end
        
          sumador_faltante+=params[:"monto_cantidad_faltante_#{orden_despacho_detalle.id}"].to_f

          plan_inv_id=OrdenDespachoDetalle.find(orden_despacho_detalle.id).plan_inversion_id

          #eliminado esto no aplica if !((orden_despacho_detalle.costo_real.to_f * params[:"monto_cantidad_faltante_#{orden_despacho_detalle.id}"].to_f) < params[:"monto_cantidad_facturada_#{orden_despacho_detalle.id}"].to_f)

            PlanInversion.find(plan_inv_id).update_attributes(:monto_desembolsado=> params[:"monto_cantidad_facturada_#{orden_despacho_detalle.id}"].to_f,:cantidad_liquidada=>params[:"monto_cantidad_faltante_#{orden_despacho_detalle.id}"].to_f)

          #eliminado esto no aplica else
            #eliminado esto no aplica PlanInversion.find(plan_inv_id).update_attributes(:monto_desembolsado=> orden_despacho_detalle.monto_financiamiento.to_f - params[:"monto_cantidad_facturada_#{orden_despacho_detalle.id}"].to_f,:cantidad_liquidada=>params[:"monto_cantidad_faltante_#{orden_despacho_detalle.id}"].to_f)
            #eliminada PlanInversion.find(plan_inv_id).update_attributes(:monto_desembolsado=> orden_despacho_detalle.costo_real.to_f * params[:"monto_cantidad_faltante_#{orden_despacho_detalle.id}"].to_f,:cantidad_liquidada=>params[:"monto_cantidad_faltante_#{orden_despacho_detalle.id}"].to_f)
          #eliminado esto no aplica end

          orden_despacho_detalle=OrdenDespachoDetalle.find(:first,:conditions=>['orden_despacho_id = ? and plan_inversion_id = ?',orden_despacho_id,plan_inv_id])

          #eliminado esto no aplica if !((orden_despacho_detalle.costo_real.to_f * params[:"monto_cantidad_faltante_#{orden_despacho_detalle.id}"].to_f) < params[:"monto_cantidad_facturada_#{orden_despacho_detalle.id}"].to_f)
            orden_despacho_detalle.update_attributes(:monto_facturacion=> params[:"monto_cantidad_facturada_#{orden_despacho_detalle.id}"].to_f,:cantidad_facturacion=>params[:"monto_cantidad_faltante_#{orden_despacho_detalle.id}"].to_f)
          #eliminado esto no aplica else

          #eliminado esto no aplica orden_despacho_detalle.update_attributes(:monto_facturacion=> orden_despacho_detalle.monto_financiamiento.to_f - params[:"monto_cantidad_facturada_#{orden_despacho_detalle.id}"].to_f,:cantidad_facturacion=>params[:"monto_cantidad_faltante_#{orden_despacho_detalle.id}"].to_f)
          #eliminada orden_despacho_detalle.update_attributes(:monto_facturacion=> orden_despacho_detalle.costo_real.to_f * params[:"monto_cantidad_faltante_#{orden_despacho_detalle.id}"].to_f,:cantidad_facturacion=>params[:"monto_cantidad_faltante_#{orden_despacho_detalle.id}"].to_f)

          #eliminado esto no aplica end

          factura_orden_despacho=FacturaOrdenDespacho.find(:first,:conditions=>['orden_despacho_detalle_id = ? and casa_proveedora_id = ? and sucursal_casa_proveedora_id = ?',orden_despacho_detalle.id, as[0].to_i,as[1].to_i])
      
          #antes estaba asi, pero por la condicion nueva en el before update se tuvo q comentar esta linea

          # value = factura_orden_despacho.update_attributes(:numero_factura=> factura,:fecha_factura=> Date.new(fecha[6,4].to_i,fecha[3,2].to_i,fecha[0,2].to_i),:monto_factura=>params[:"monto_cantidad_facturada_#{orden_despacho_detalle.id}"].to_f,:cantidad_factura=>params[:"monto_cantidad_faltante_#{orden_despacho_detalle.id}"].to_i,:confirmada=>'true')

          factura_orden_despacho.numero_factura=factura
          factura_orden_despacho.fecha_factura=Date.new(fecha[0,4].to_i,fecha[5,2].to_i,fecha[8,2].to_i)

          logger.info "monto cantidad facturada >>>>>>> " << params[:"monto_cantidad_facturada_#{orden_despacho_detalle.id}"].to_s

          #eliminado esto no aplica if !((factura_orden_despacho.costo_real.to_f * params[:"monto_cantidad_faltante_#{orden_despacho_detalle.id}"].to_f) < params[:"monto_cantidad_facturada_#{orden_despacho_detalle.id}"].to_f)

            factura_orden_despacho.monto_factura=params[:"monto_cantidad_facturada_#{orden_despacho_detalle.id}"].to_f
          #eliminado esto no aplica else
            #eliminado esto no aplica factura_orden_despacho.monto_factura=(factura_orden_despacho.monto_financiamiento.to_f - params[:"monto_cantidad_facturada_#{orden_despacho_detalle.id}"].to_f)
            #eliminado factura_orden_despacho.monto_factura=factura_orden_despacho.costo_real.to_f * params[:"monto_cantidad_faltante_#{orden_despacho_detalle.id}"].to_f
          #eliminado esto no aplica end
        
          factura_orden_despacho.cantidad_factura=params[:"monto_cantidad_faltante_#{orden_despacho_detalle.id}"].to_f
          factura_orden_despacho.confirmada=true
          logger.info "valor factura 1<<<<<<<>>>>>>>>>>>>>>" << factura_orden_despacho.monto_factura.to_s
          #value=factura_orden_despacho.save false
          #quitado para rails 3 value=factura_orden_despacho.send(:update_without_callbacks)
          value=factura_orden_despacho.save(validate: false)
          logger.info "resultado update 2<<<<<<<>>>>>>>>>>>>>>" << value.to_s
        end #del each

        prestamo=Prestamo.find(OrdenDespacho.find(orden_despacho_id).prestamo_id)
        prestamo.update_attributes(:monto_despachado=> prestamo.monto_despachado + sumador_facturada)
        #ojo aqui no se con certeza si monto factura es el mismo monto despahado
        prestamo.update_attributes(:monto_facturado=> prestamo.monto_facturado + sumador_facturada)

        orden_des=OrdenDespacho.find(orden_despacho_id)
        #logger.debug "este es el id de la orden de despacho "  << orden_des.id
        
        total_montos_cantidad=OrdenDespachoDetalle.sum(:cantidad,:conditions=>"orden_despacho_id = #{orden_des.id}")
        total_montos_cantidad_facturacion=OrdenDespachoDetalle.sum(:cantidad_facturacion,:conditions=>"orden_despacho_id = #{orden_des.id}")

        if total_montos_cantidad.to_f == total_montos_cantidad_facturacion.to_f
          #la orden de despacho queda cerrada completamente porq se despacho todo
          orden_des.update_attributes(:estatus_id=> 20040,:fecha_cierre=>Date.today)
        else
          #esta parcialmente cerrada
          orden_des.update_attributes(:estatus_id=> 20050)
        end              
        iniciar_transaccion(OrdenDespacho.find(orden_despacho_id).prestamo_id, 'p_dummy', 'L', I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.transaccion_dummy_orden_despacho',:numero_orden=>orden_despacho_id), usuario_id,sumador_facturada)


      end #del transaction

    rescue Exception => e

      @errores = '<label>'.html_safe<< e.message.to_s << '</label>'.html_safe
      return @errores

    end # del rescue

    return @errores
#  end

  end

############### actualizacion individual ###########3


  def actualizar_factura_individual(factura_orden_despacho_id, casa_id,fecha,factura,usuario_id,params)


orden_despacho_id=FacturaOrdenDespacho.find(factura_orden_despacho_id).orden_despacho_detalle.orden_despacho_id


    logger.debug "Actualizando facturas individual ===============> "
    #logger.debug "PARAMETROS                ===============> " << params.inspect
    total_orden_detalle=FacturaOrdenDespacho.sum(:cantidad,:conditions=>['id = ?',factura_orden_despacho_id])
    
    @factura_orden_despacho_detalles=FacturaOrdenDespacho.find(:all,:conditions=>['id = ?',factura_orden_despacho_id])

    @errores = ''
    as=casa_id.split(";")
    sumador_facturada=0.0
    sumador_faltante=0.0
    begin

      transaction do

        iniciar_transaccion(OrdenDespacho.find(orden_despacho_id).prestamo_id, 'p_orden_despacho_confirmacion', 'L', I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.transaccion_actualizacion_factura',:numero_orden=>orden_despacho_id), usuario_id, OrdenDespacho.find(orden_despacho_id).monto)

        @factura_orden_despacho_detalles.each do |factura_orden_despacho_detalle|

      #eliminada no aplica if !((factura_orden_despacho_detalle.costo_real.to_f * params[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle.id}"].to_f) < params[:"monto_cantidad_facturada_#{factura_orden_despacho_detalle.id}"].to_f)

        sumador_facturada+=params[:"monto_cantidad_facturada_#{factura_orden_despacho_detalle.id}"].to_f

      #eliminada no aplica else
        #eliminada no aplica sumador_facturada+=factura_orden_despacho_detalle.monto_financiamiento.to_f - params[:"monto_cantidad_facturada_#{factura_orden_despacho_detalle.id}"].to_f
        #eliminada sumador_facturada+=factura_orden_despacho_detalle.costo_real.to_f * params[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle.id}"].to_f
      #eliminada no aplica end


      sumador_faltante+=params[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle.id}"].to_f

      plan_inv_id=FacturaOrdenDespacho.find(factura_orden_despacho_detalle.id).orden_despacho_detalle.plan_inversion_id

      #eliminada no aplica if !((factura_orden_despacho_detalle.costo_real.to_f * params[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle.id}"].to_f) < params[:"monto_cantidad_facturada_#{factura_orden_despacho_detalle.id}"].to_f)

        PlanInversion.find(plan_inv_id).update_attributes(:monto_desembolsado=>PlanInversion.find(plan_inv_id).monto_desembolsado.to_f + params[:"monto_cantidad_facturada_#{factura_orden_despacho_detalle.id}"].to_f,:cantidad_liquidada=>PlanInversion.find(plan_inv_id).cantidad_liquidada.to_f + params[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle.id}"].to_f)

      #eliminada no aplica else
        #eliminada no aplica PlanInversion.find(plan_inv_id).update_attributes(:monto_desembolsado=>PlanInversion.find(plan_inv_id).monto_desembolsado.to_f + (factura_orden_despacho_detalle.monto_financiamiento.to_f - params[:"monto_cantidad_facturada_#{factura_orden_despacho_detalle.id}"].to_f),:cantidad_liquidada=>PlanInversion.find(plan_inv_id).cantidad_liquidada.to_f + params[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle.id}"].to_f)
        #eliminada PlanInversion.find(plan_inv_id).update_attributes(:monto_desembolsado=>PlanInversion.find(plan_inv_id).monto_desembolsado.to_f + (factura_orden_despacho_detalle.costo_real.to_f * params[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle.id}"].to_f),:cantidad_liquidada=>PlanInversion.find(plan_inv_id).cantidad_liquidada.to_f + params[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle.id}"].to_f)

      #eliminada no aplica end




##ojo


orden_despacho_detalle=OrdenDespachoDetalle.find(:first,:conditions=>['orden_despacho_id = ? and plan_inversion_id = ?',orden_despacho_id,plan_inv_id])





      #eliminada no aplica if !((orden_despacho_detalle.costo_real.to_f * params[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle.id}"].to_f) < params[:"monto_cantidad_facturada_#{factura_orden_despacho_detalle.id}"].to_f)

        orden_despacho_detalle.update_attributes(:monto_facturacion=> orden_despacho_detalle.monto_facturacion.to_f + params[:"monto_cantidad_facturada_#{factura_orden_despacho_detalle.id}"].to_f,:cantidad_facturacion=> orden_despacho_detalle.cantidad_facturacion.to_f + params[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle.id}"].to_f)

      #eliminada no aplica else

        #eliminada no aplica orden_despacho_detalle.update_attributes(:monto_facturacion=> params[:"monto_cantidad_facturada_#{factura_orden_despacho_detalle.id}"].to_f + (orden_despacho_detalle.monto_financiamiento.to_f - params[:"monto_cantidad_facturada_#{factura_orden_despacho_detalle.id}"].to_f) ,:cantidad_facturacion=> orden_despacho_detalle.cantidad_facturacion.to_f + params[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle.id}"].to_f)
        #eliminada orden_despacho_detalle.update_attributes(:monto_facturacion=> params[:"monto_cantidad_facturada_#{factura_orden_despacho_detalle.id}"].to_f + (orden_despacho_detalle.costo_real.to_f * params[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle.id}"].to_f) ,:cantidad_facturacion=> orden_despacho_detalle.cantidad_facturacion.to_f + params[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle.id}"].to_f)

      #eliminada no aplica end

  factura_orden_despacho=FacturaOrdenDespacho.find(:first,:conditions=>['id = ? and  orden_despacho_detalle_id = ? and casa_proveedora_id = ? and sucursal_casa_proveedora_id = ?',factura_orden_despacho_id,orden_despacho_detalle.id, as[0].to_i,as[1].to_i])

        
      #ojo aqui esto solo actualiza los valores de los atributos en la factura, no crea una nueva



#      value = factura_orden_despacho.update_attributes(:numero_factura=> factura,:fecha_factura=> Date.new(fecha[6,4].to_i,fecha[3,2].to_i,fecha[0,2].to_i),:monto_factura=>params[:"monto_cantidad_facturada_#{factura_orden_despacho_detalle.id}"].to_f,:cantidad_factura=>params[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle.id}"].to_i,:confirmada=>'true')

    factura_orden_despacho.numero_factura=factura
    factura_orden_despacho.fecha_factura=Date.new(fecha[0,4].to_i,fecha[5,2].to_i,fecha[8,2].to_i)




    #eliminada no aplica if !((factura_orden_despacho.costo_real.to_f * params[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle.id}"].to_f) < params[:"monto_cantidad_facturada_#{factura_orden_despacho_detalle.id}"].to_f)

        factura_orden_despacho.monto_factura=params[:"monto_cantidad_facturada_#{factura_orden_despacho_detalle.id}"].to_f

    #eliminada no aplica else
        #eliminada no aplica factura_orden_despacho.monto_factura=(factura_orden_despacho.monto_financiamiento.to_f - params[:"monto_cantidad_facturada_#{factura_orden_despacho_detalle.id}"].to_f)
        # eliminada factura_orden_despacho.monto_factura=factura_orden_despacho.costo_real.to_f * params[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle.id}"].to_f
    #eliminada no aplica end

    factura_orden_despacho.cantidad_factura=params[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle.id}"].to_f
    factura_orden_despacho.confirmada=true


  #quitado para rails 3 value=factura_orden_despacho.send(:update_without_callbacks)
  value=factura_orden_despacho.save(validate: false)

      #hubo un error al actualizar
    return factura_orden_despacho.errors.full_messages[0] unless value

    if (factura_orden_despacho.cantidad_factura < factura_orden_despacho.cantidad)
      #creo una nueva factura con la secuencia siguiente 
      logger.debug "Entre aqui para crear una nueva factura <<<< " << value.to_s << " " << factura.to_s << " "<< Date.new(fecha[0,4].to_i,fecha[5,2].to_i,fecha[8,2].to_i).to_s << " "  << params[:"monto_cantidad_facturada_#{factura_orden_despacho_detalle.id}"].to_f.to_s << " " << params[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle.id}"].to_f.to_s

        

        crear_nueva_individual(factura_orden_despacho.id)

    
    end

#luego de actualizar crear otra factura si todavia siguen siendo parciales




        end #del each

        prestamo=Prestamo.find(OrdenDespacho.find(orden_despacho_id).prestamo_id)
        prestamo.update_attributes(:monto_despachado=> prestamo.monto_despachado.to_f +  sumador_facturada)
        #ojo aqui no se con certeza si monto factura es el mismo monto despahado
        prestamo.update_attributes(:monto_facturado=> prestamo.monto_facturado.to_f +  sumador_facturada)

        orden_des=OrdenDespacho.find(orden_despacho_id)
      ####ojojoojoojojoojj
        

        total_montos_cantidad=OrdenDespachoDetalle.sum(:cantidad,:conditions=>"orden_despacho_id = #{orden_des.id}")
        total_montos_cantidad_facturacion=OrdenDespachoDetalle.sum(:cantidad_facturacion,:conditions=>"orden_despacho_id = #{orden_des.id}")


        if total_montos_cantidad.to_f == total_montos_cantidad_facturacion.to_f
          #la orden de despacho queda cerrada completamente porq se despacho todo
          orden_des.update_attributes(:estatus_id=> 20040,:fecha_cierre=>Date.today)
        else
          #esta parcialmente cerrada
          orden_des.update_attributes(:estatus_id=> 20050)
        end

        iniciar_transaccion(OrdenDespacho.find(orden_despacho_id).prestamo_id, 'p_dummy', 'L', I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.transaccion_dummy_orden_despacho',:numero_orden=>orden_despacho_id), usuario_id,sumador_facturada)


      end #del transaction

    rescue Exception => e

      @errores = '<label>'.html_safe<< e.message.to_s << '</label>'.html_safe
      return @errores

    end # del rescue

    return @errores

  end




#############3 fin ##############



### para las parciales

  def actualizar_factura_parciales(factura_orden_despacho_id, casa_id,fecha,factura,usuario_id,params)


#  def actualizar_plan_general(solicitud_id,params)


orden_despacho_id=FacturaOrdenDespacho.find(:first,:conditions=>"id in #{factura_orden_despacho_id}").orden_despacho_detalle.orden_despacho_id


    logger.debug "Actualizando facturas individual ===============> "
    #logger.debug "PARAMETROS                ===============> " << params.inspect
    total_orden_detalle=FacturaOrdenDespacho.sum(:cantidad,:conditions=>"id in #{factura_orden_despacho_id}")
    
    @factura_orden_despacho_detalles=FacturaOrdenDespacho.find(:all,:conditions=>"id in #{factura_orden_despacho_id}")

    @errores = ''
    as=casa_id.split(";")
    sumador_facturada=0.0
    sumador_faltante=0.0
    
    begin

      transaction do
        iniciar_transaccion(OrdenDespacho.find(orden_despacho_id).prestamo_id, 'p_orden_despacho_confirmacion', 'L', I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.transaccion_actualizacion_factura',:numero_orden=>orden_despacho_id), usuario_id, OrdenDespacho.find(orden_despacho_id).monto)
        @factura_orden_despacho_detalles.each do |factura_orden_despacho_detalle|
            #logger.debug "CANTIDAD #{plan.id} =======> " << params[:"cantidad_#{plan.id}"].to_s
            #logger.debug "MONTO #{plan.id} =======> " << params[:"monto_#{plan.id}"].to_s
            
          #eliminado ya no aplica if !((factura_orden_despacho_detalle.costo_real.to_f * params[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle.id}"].to_f) < params[:"monto_cantidad_facturada_#{factura_orden_despacho_detalle.id}"].to_f)

            sumador_facturada+=params[:"monto_cantidad_facturada_#{factura_orden_despacho_detalle.id}"].to_f

          #eliminado ya no aplica else
            #eliminado ya no aplica sumador_facturada+=(factura_orden_despacho_detalle.monto_financiamiento.to_f - params[:"monto_cantidad_facturada_#{factura_orden_despacho_detalle.id}"].to_f)
            #sumador_facturada+=factura_orden_despacho_detalle.costo_real.to_f * params[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle.id}"].to_f
          #eliminado ya no aplica end

          sumador_faltante+=params[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle.id}"].to_f

          plan_inv_id=FacturaOrdenDespacho.find(factura_orden_despacho_detalle.id).orden_despacho_detalle.plan_inversion_id

          #eliminado ya no aplica if !((factura_orden_despacho_detalle.costo_real.to_f * params[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle.id}"].to_f) < params[:"monto_cantidad_facturada_#{factura_orden_despacho_detalle.id}"].to_f)

            PlanInversion.find(plan_inv_id).update_attributes(:monto_desembolsado=>PlanInversion.find(plan_inv_id).monto_desembolsado.to_f + params[:"monto_cantidad_facturada_#{factura_orden_despacho_detalle.id}"].to_f,:cantidad_liquidada=>PlanInversion.find(plan_inv_id).cantidad_liquidada.to_f + params[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle.id}"].to_f)

          #eliminado ya no aplica else
            
            #eliminado ya no aplica PlanInversion.find(plan_inv_id).update_attributes(:monto_desembolsado=>PlanInversion.find(plan_inv_id).monto_desembolsado.to_f + (factura_orden_despacho_detalle.monto_financiamiento.to_f - params[:"monto_cantidad_facturada_#{factura_orden_despacho_detalle.id}"].to_f),:cantidad_liquidada=>PlanInversion.find(plan_inv_id).cantidad_liquidada.to_f + params[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle.id}"].to_f)            
            #eliminada PlanInversion.find(plan_inv_id).update_attributes(:monto_desembolsado=>PlanInversion.find(plan_inv_id).monto_desembolsado.to_f + (factura_orden_despacho_detalle.costo_real.to_f * params[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle.id}"].to_f),:cantidad_liquidada=>PlanInversion.find(plan_inv_id).cantidad_liquidada.to_f + params[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle.id}"].to_f)

          #eliminado ya no aplica end

          orden_despacho_detalle=OrdenDespachoDetalle.find(:first,:conditions=>['orden_despacho_id = ? and plan_inversion_id = ?',orden_despacho_id,plan_inv_id])

          #logger.info "monto facturacion actual" << orden_despacho_detalle.monto_facturacion.to_s << "monto facturacion nuevo " << params[:"monto_cantidad_facturada_#{factura_orden_despacho_detalle.id}"].to_s << " orden_despacho_id " << orden_despacho_id.to_s << " plan inversion " << plan_inv_id.to_s

          #eliminado ya no aplica if !((orden_despacho_detalle.costo_real.to_f * params[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle.id}"].to_f) < params[:"monto_cantidad_facturada_#{factura_orden_despacho_detalle.id}"].to_f)

            orden_despacho_detalle.update_attributes(:monto_facturacion=> orden_despacho_detalle.monto_facturacion.to_f + params[:"monto_cantidad_facturada_#{factura_orden_despacho_detalle.id}"].to_f,:cantidad_facturacion=> orden_despacho_detalle.cantidad_facturacion.to_f + params[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle.id}"].to_f)

          #eliminado ya no aplica else
            #ojo aqui
            #eliminado ya no aplica orden_despacho_detalle.update_attributes(:monto_facturacion=> orden_despacho_detalle.monto_facturacion.to_f + (orden_despacho_detalle.monto_financiamiento.to_f - params[:"monto_cantidad_facturada_#{factura_orden_despacho_detalle.id}"].to_f) ,:cantidad_facturacion=> orden_despacho_detalle.cantidad_facturacion.to_f + params[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle.id}"].to_f)            
            # eliminada orden_despacho_detalle.update_attributes(:monto_facturacion=> orden_despacho_detalle.monto_facturacion.to_f + (orden_despacho_detalle.costo_real.to_f * params[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle.id}"].to_f) ,:cantidad_facturacion=> orden_despacho_detalle.cantidad_facturacion.to_f + params[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle.id}"].to_f)

          #eliminado ya no aplica end

          factura_orden_despacho=FacturaOrdenDespacho.find(:first,:conditions=>"id in #{factura_orden_despacho_id} and  orden_despacho_detalle_id = #{orden_despacho_detalle.id} and casa_proveedora_id = #{as[0].to_s} and sucursal_casa_proveedora_id = #{as[1].to_s}")        
          #ojo aqui esto solo actualiza los valores de los atributos en la factura, no crea una nueva
          # value = factura_orden_despacho.update_attributes(:numero_factura=> factura,:fecha_factura=> Date.new(fecha[6,4].to_i,fecha[3,2].to_i,fecha[0,2].to_i),:monto_factura=>params[:"monto_cantidad_facturada_#{factura_orden_despacho_detalle.id}"].to_f,:cantidad_factura=>params[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle.id}"].to_i,:confirmada=>'true')

          factura_orden_despacho.numero_factura=factura
          factura_orden_despacho.fecha_factura=Date.new(fecha[0,4].to_i,fecha[5,2].to_i,fecha[8,2].to_i)

          #eliminado ya no aplica if !((factura_orden_despacho.costo_real.to_f * params[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle.id}"].to_f) < params[:"monto_cantidad_facturada_#{factura_orden_despacho_detalle.id}"].to_f)

            factura_orden_despacho.monto_factura=params[:"monto_cantidad_facturada_#{factura_orden_despacho_detalle.id}"].to_f

          #eliminado ya no aplica else
            
            #eliminado ya no aplica factura_orden_despacho.monto_factura=(factura_orden_despacho.monto_financiamiento.to_f - params[:"monto_cantidad_facturada_#{factura_orden_despacho_detalle.id}"].to_f)
            #eliminada factura_orden_despacho.monto_factura=factura_orden_despacho.costo_real.to_f * params[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle.id}"].to_f
          #eliminado ya no aplica end

          factura_orden_despacho.cantidad_factura=params[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle.id}"].to_f
          factura_orden_despacho.confirmada=true

          #quitado para rails 3 value=factura_orden_despacho.send(:update_without_callbacks)
          value=factura_orden_despacho.save(validate: false)

          #hubo un error al actualizar
          return factura_orden_despacho.errors.full_messages[0] unless value

          if (factura_orden_despacho.cantidad_factura < factura_orden_despacho.cantidad)
            #creo una nueva factura con la secuencia siguiente 
            logger.debug "Entre aqui para crear una nueva factura <<<< " << value.to_s << " " << factura.to_s << " "<< Date.new(fecha[0,4].to_i,fecha[5,2].to_i,fecha[8,2].to_i).to_s << " "  << params[:"monto_cantidad_facturada_#{factura_orden_despacho_detalle.id}"].to_f.to_s << " " << params[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle.id}"].to_f.to_s
            crear_nueva_individual(factura_orden_despacho.id)    
          end

          #luego de actualizar crear otra factura si todavia siguen siendo parciales
        end #del each

        prestamo=Prestamo.find(OrdenDespacho.find(orden_despacho_id).prestamo_id)
        prestamo.update_attributes(:monto_despachado=> prestamo.monto_despachado.to_f +  sumador_facturada)
        #ojo aqui no se con certeza si monto factura es el mismo monto despahado
        prestamo.update_attributes(:monto_facturado=> prestamo.monto_facturado.to_f +  sumador_facturada)

        orden_des=OrdenDespacho.find(orden_despacho_id)
        ####ojojoojoojojoojj
        

        total_montos_cantidad=OrdenDespachoDetalle.sum(:cantidad,:conditions=>"orden_despacho_id = #{orden_des.id}")
        total_montos_cantidad_facturacion=OrdenDespachoDetalle.sum(:cantidad_facturacion,:conditions=>"orden_despacho_id = #{orden_des.id}")


        if total_montos_cantidad.to_f == total_montos_cantidad_facturacion.to_f
          #la orden de despacho queda cerrada completamente porq se despacho todo
          orden_des.update_attributes(:estatus_id=> 20040,:fecha_cierre=>Date.today)
        else
          #esta parcialmente cerrada
          orden_des.update_attributes(:estatus_id=> 20050)
        end

        #
        #====================================================
        # AQUI VA LA LLAMADA DEL CAUSADO Y PAGADO PARA SIGA
        #====================================================
        #

        iniciar_transaccion(OrdenDespacho.find(orden_despacho_id).prestamo_id, 'p_dummy', 'L', I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.transaccion_dummy_orden_despacho',:numero_orden=>orden_despacho_id), usuario_id,sumador_facturada)


      end #del transaction

    rescue Exception => e

      @errores = '<label>'.html_safe<< e.message.to_s << '</label>'.html_safe
      return @errores

    end # del rescue

    return @errores

  end


### end de las parciales

  def self.search(search, page, orden)    
    paginate :per_page=>@records_by_page, :page=>page, :conditions=>search, :order=>orden
  end

### para las multiples parciales funcion agregada el 6/6/2013 para las multiples facturas 

  
  def FacturaOrdenDespacho.iniciar_transaccion(prestamo,nombre_transaccion,tipo,descripcion,usuario,monto)

    logger.info "NOMBRE TRANSACCION #{nombre_transaccion}"
    logger.info "USUARIO #{usuario.inspect}"
    
    fecha = Time.now.strftime('%Y-%m-%d %H:%M:%S')
    meta = MetaTransaccion.find_by_nombre(nombre_transaccion)
   
    transaccion = Transaccion.new
    
    if nombre_transaccion == 'p_dummy'
      transaccion.reversada = true
    end
    
    transaccion.prestamo_id = prestamo
    transaccion.meta_transaccion_id = meta.id
    transaccion.usuario_id = usuario
    transaccion.fecha = fecha
    transaccion.tipo = tipo
    transaccion.descripcion = descripcion
    transaccion.monto = monto
    transaccion.save
    
    logger.debug "frfrfrfr " << transaccion.errors.full_messages.to_s #<< " error " << transaccion.errors[0].to_s
    unless transaccion.errors.full_messages.empty?
      @msg = transaccion.errors.full_messages[0].to_s       
      return @msg 
    else
      @transaccion_id = transaccion.id
      return @transaccion_id
    end
  
  end
  
  
  
  def actualizar_multiples_factura_parciales(factura_orden_despacho_id, casa_id,fecha,factura,usuario_id,params)

    orden_despacho_id=FacturaOrdenDespacho.find(:first,:conditions=>"id in #{factura_orden_despacho_id}").orden_despacho_detalle.orden_despacho_id


    logger.debug "Actualizando facturas individual ===============> "
    #logger.debug "PARAMETROS                ===============> " << params.inspect
    total_orden_detalle=FacturaOrdenDespacho.sum(:cantidad,:conditions=>"id in #{factura_orden_despacho_id}")
    
    @factura_orden_despacho_detalles=FacturaOrdenDespacho.find(:all,:conditions=>"id in #{factura_orden_despacho_id}")

    @errores = ''
    @transaccion_id=0
    as=casa_id.split("-")
    sumador_facturada=0.0
    sumador_faltante=0.0
    
    begin

      transaction do
        
          resul=FacturaOrdenDespacho.find(:all,:conditions=>"numero_factura='#{factura}' and sucursal_casa_proveedora_id=#{as[1]} ")  #(orden_despacho_detalle_id in (select id from orden_despacho_detalle where orden_despacho_id=#{orden_despacho_id})) and 
          unless resul.empty?                      
           raise Exception, "#{I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Errores.ya_existe_numero_factura_repetido')} "
          end
        logger.debug "jsjsjsjsjsjssjsjsj"
          @transaccion_id=FacturaOrdenDespacho.iniciar_transaccion(OrdenDespacho.find(orden_despacho_id).prestamo_id, 'p_orden_despacho_confirmacion', 'L', I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.transaccion_actualizacion_factura',:numero_orden=>orden_despacho_id), usuario_id, OrdenDespacho.find(orden_despacho_id).monto)
          
          @factura_orden_despacho_detalles.each do |factura_orden_despacho_detalle|            
            #logger.debug "CANTIDAD #{plan.id} =======> " << params[:"cantidad_#{plan.id}"].to_s
            #logger.debug "MONTO #{plan.id} =======> " << params[:"monto_#{plan.id}"].to_s
            
          #eliminado ya no aplica if !((factura_orden_despacho_detalle.costo_real.to_f * params[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle.id}"].to_f) < params[:"monto_cantidad_facturada_#{factura_orden_despacho_detalle.id}"].to_f)

            #caso especial cuando la diferencia es demasiada corta en terminos de decimales (caso extremo)
            if factura_orden_despacho_detalle.cantidad.to_f == params[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle.id}"].to_f 
              sumador_facturada+=factura_orden_despacho_detalle.monto_financiamiento
            else
              sumador_facturada+=params[:"monto_cantidad_facturada_#{factura_orden_despacho_detalle.id}"].to_f
            end
          #eliminado ya no aplica else
            
            #eliminado ya no aplica sumador_facturada+=(factura_orden_despacho_detalle.monto_financiamiento.to_f - params[:"monto_cantidad_facturada_#{factura_orden_despacho_detalle.id}"].to_f)
            #eliminada sumador_facturada+=factura_orden_despacho_detalle.costo_real.to_f * params[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle.id}"].to_f
          #eliminado ya no aplica end

          sumador_faltante+=params[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle.id}"].to_f

          plan_inv_id=FacturaOrdenDespacho.find(factura_orden_despacho_detalle.id).orden_despacho_detalle.plan_inversion_id

          #eliminado ya no aplica if !((factura_orden_despacho_detalle.costo_real.to_f * params[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle.id}"].to_f) < params[:"monto_cantidad_facturada_#{factura_orden_despacho_detalle.id}"].to_f)

            #caso especial cuando la diferencia es demasiada corta en terminos de decimales (caso extremo)
            if factura_orden_despacho_detalle.cantidad.to_f == params[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle.id}"].to_f 
              PlanInversion.find(plan_inv_id).update_attributes(:monto_desembolsado=>PlanInversion.find(plan_inv_id).monto_desembolsado.to_f + factura_orden_despacho_detalle.monto_financiamiento.to_f,:cantidad_liquidada=>PlanInversion.find(plan_inv_id).cantidad_liquidada.to_f + params[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle.id}"].to_f)            
            else
              PlanInversion.find(plan_inv_id).update_attributes(:monto_desembolsado=>PlanInversion.find(plan_inv_id).monto_desembolsado.to_f + params[:"monto_cantidad_facturada_#{factura_orden_despacho_detalle.id}"].to_f,:cantidad_liquidada=>PlanInversion.find(plan_inv_id).cantidad_liquidada.to_f + params[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle.id}"].to_f)
            end
          #eliminado ya no aplica else
            
            #eliminado ya no aplica PlanInversion.find(plan_inv_id).update_attributes(:monto_desembolsado=>PlanInversion.find(plan_inv_id).monto_desembolsado.to_f + (factura_orden_despacho_detalle.monto_financiamiento.to_f - params[:"monto_cantidad_facturada_#{factura_orden_despacho_detalle.id}"].to_f),:cantidad_liquidada=>PlanInversion.find(plan_inv_id).cantidad_liquidada.to_f + params[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle.id}"].to_f)
            #eliminada PlanInversion.find(plan_inv_id).update_attributes(:monto_desembolsado=>PlanInversion.find(plan_inv_id).monto_desembolsado.to_f + (factura_orden_despacho_detalle.costo_real.to_f * params[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle.id}"].to_f),:cantidad_liquidada=>PlanInversion.find(plan_inv_id).cantidad_liquidada.to_f + params[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle.id}"].to_f)

          #eliminado ya no aplica end

          orden_despacho_detalle=OrdenDespachoDetalle.find(:first,:conditions=>['orden_despacho_id = ? and plan_inversion_id = ?',orden_despacho_id,plan_inv_id])

          #logger.info "monto facturacion actual" << orden_despacho_detalle.monto_facturacion.to_s << "monto facturacion nuevo " << params[:"monto_cantidad_facturada_#{factura_orden_despacho_detalle.id}"].to_s << " orden_despacho_id " << orden_despacho_id.to_s << " plan inversion " << plan_inv_id.to_s

          #eliminado ya no aplica if !((orden_despacho_detalle.costo_real.to_f * params[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle.id}"].to_f) < params[:"monto_cantidad_facturada_#{factura_orden_despacho_detalle.id}"].to_f)

            #caso especial cuando la diferencia es demasiada corta en terminos de decimales (caso extremo)
            if factura_orden_despacho_detalle.cantidad.to_f == params[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle.id}"].to_f             
              orden_despacho_detalle.update_attributes(:monto_facturacion=> orden_despacho_detalle.monto_facturacion.to_f + factura_orden_despacho_detalle.monto_financiamiento.to_f,:cantidad_facturacion=> orden_despacho_detalle.cantidad_facturacion.to_f + params[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle.id}"].to_f)
            else
              orden_despacho_detalle.update_attributes(:monto_facturacion=> orden_despacho_detalle.monto_facturacion.to_f + params[:"monto_cantidad_facturada_#{factura_orden_despacho_detalle.id}"].to_f,:cantidad_facturacion=> orden_despacho_detalle.cantidad_facturacion.to_f + params[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle.id}"].to_f)
            end
          #eliminado ya no aplica else
            #ojo aqui
            
            #eliminado ya no aplica orden_despacho_detalle.update_attributes(:monto_facturacion=> orden_despacho_detalle.monto_facturacion.to_f + (orden_despacho_detalle.monto_financiamiento.to_f - params[:"monto_cantidad_facturada_#{factura_orden_despacho_detalle.id}"].to_f) ,:cantidad_facturacion=> orden_despacho_detalle.cantidad_facturacion.to_f + params[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle.id}"].to_f)
            #orden_despacho_detalle.update_attributes(:monto_facturacion=> orden_despacho_detalle.monto_facturacion.to_f + (orden_despacho_detalle.costo_real.to_f * params[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle.id}"].to_f) ,:cantidad_facturacion=> orden_despacho_detalle.cantidad_facturacion.to_f + params[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle.id}"].to_f)

          #eliminado ya no aplica end

          factura_orden_despacho=FacturaOrdenDespacho.find(:first,:conditions=>"id in #{factura_orden_despacho_id} and orden_despacho_detalle_id = #{orden_despacho_detalle.id} and casa_proveedora_id = #{as[0].to_s} and sucursal_casa_proveedora_id = #{as[1].to_s}")        
          #ojo aqui esto solo actualiza los valores de los atributos en la factura, no crea una nueva
          # value = factura_orden_despacho.update_attributes(:numero_factura=> factura,:fecha_factura=> Date.new(fecha[6,4].to_i,fecha[3,2].to_i,fecha[0,2].to_i),:monto_factura=>params[:"monto_cantidad_facturada_#{factura_orden_despacho_detalle.id}"].to_f,:cantidad_factura=>params[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle.id}"].to_i,:confirmada=>'true')

          factura_orden_despacho.numero_factura=factura
          factura_orden_despacho.observacion=params[:"observacion"].strip
          factura_orden_despacho.fecha_factura=Date.new(fecha[0,4].to_i,fecha[5,2].to_i,fecha[8,2].to_i)

          #eliminado ya no aplica if !((factura_orden_despacho.costo_real.to_f * params[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle.id}"].to_f) < params[:"monto_cantidad_facturada_#{factura_orden_despacho_detalle.id}"].to_f)

            #caso especial cuando la diferencia es demasiada corta en terminos de decimales (caso extremo)
            if factura_orden_despacho_detalle.cantidad.to_f == params[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle.id}"].to_f             
              factura_orden_despacho.monto_factura=factura_orden_despacho_detalle.monto_financiamiento.to_f            
            else
              factura_orden_despacho.monto_factura=params[:"monto_cantidad_facturada_#{factura_orden_despacho_detalle.id}"].to_f
            end
          #eliminado ya no aplica else
            #eliminado ya no aplica factura_orden_despacho.monto_factura=(factura_orden_despacho.monto_financiamiento.to_f - params[:"monto_cantidad_facturada_#{factura_orden_despacho_detalle.id}"].to_f)
            #eliminada factura_orden_despacho.monto_factura=factura_orden_despacho.costo_real.to_f * params[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle.id}"].to_f
          #eliminado ya no aplica end

          factura_orden_despacho.cantidad_factura=params[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle.id}"].to_f
          factura_orden_despacho.confirmada=true

          #quitado para rails 3 value=factura_orden_despacho.send(:update_without_callbacks)         
          value=factura_orden_despacho.save(validate: false)
          logger.debug "jsjsjjsjsjs =" << value.to_s
          #hubo un error al actualizar
          return factura_orden_despacho.errors.full_messages[0],@transaccion_id unless value 

          if (factura_orden_despacho.cantidad_factura < factura_orden_despacho.cantidad)
            #creo una nueva factura con la secuencia siguiente 
            logger.debug "Entre aqui para crear una nueva factura <<<< " << value.to_s << " " << factura.to_s << " "<< Date.new(fecha[0,4].to_i,fecha[5,2].to_i,fecha[8,2].to_i).to_s << " "  << params[:"monto_cantidad_facturada_#{factura_orden_despacho_detalle.id}"].to_f.to_s << " " << params[:"monto_cantidad_faltante_#{factura_orden_despacho_detalle.id}"].to_f.to_s
            begin
              transaction do
                @errores =crear_nueva_multiple_individual(factura_orden_despacho.id)                    
                return @errores,@transaccion_id unless @errores.class == TrueClass
              end
            end
            
          end

          #luego de actualizar crear otra factura si todavia siguen siendo parciales
        end #del each

        prestamo=Prestamo.find(OrdenDespacho.find(orden_despacho_id).prestamo_id)
        prestamo.update_attributes(:monto_despachado=> prestamo.monto_despachado.to_f +  sumador_facturada)
        #ojo aqui no se con certeza si monto factura es el mismo monto despahado
        prestamo.update_attributes(:monto_facturado=> prestamo.monto_facturado.to_f +  sumador_facturada)

        orden_des=OrdenDespacho.find(orden_despacho_id)
        ####ojojoojoojojoojj
        

        total_montos_cantidad=OrdenDespachoDetalle.sum(:cantidad,:conditions=>"orden_despacho_id = #{orden_des.id}")
        total_montos_cantidad_facturacion=OrdenDespachoDetalle.sum(:cantidad_facturacion,:conditions=>"orden_despacho_id = #{orden_des.id}")


        if total_montos_cantidad.to_f == total_montos_cantidad_facturacion.to_f
          #la orden de despacho queda cerrada completamente porq se despacho todo
          orden_des.update_attributes(:estatus_id=> 20040,:fecha_cierre=>Date.today)
        else
          #esta parcialmente cerrada
          orden_des.update_attributes(:estatus_id=> 20050)
        end

        #
        #====================================================
        # AQUI VA LA LLAMADA DEL CAUSADO Y PAGADO PARA SIGA
        #====================================================
        #

        FacturaOrdenDespacho.iniciar_transaccion(OrdenDespacho.find(orden_despacho_id).prestamo_id, 'p_dummy', 'L', I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.transaccion_dummy_orden_despacho',:numero_orden=>orden_despacho_id), usuario_id,sumador_facturada)


      end #del transaction

    rescue Exception => e
        #raise ActiveRecord::Rollback
      @errores = '<label>'.html_safe<< e.message.to_s << '</label>'.html_safe
      return @errores,@transaccion_id

    end # del rescue

    return '',@transaccion_id #quitado el 7/6/2013 return @errores,@transaccion_id

  end


### end de las multiples parciales


def crear_nueva_multiple_individual(factura_orden_despacho_id)

success = true
    begin
      transaction do
        
factura_orden_despacho_originals=FacturaOrdenDespacho.find(:all,:conditions=>['id = ?',factura_orden_despacho_id])

#caso en que secuencia se vaya a crear por primera vez

      factura_orden_despacho_originals.each { |factura_orden_despacho_original|

      if factura_orden_despacho_original.cantidad != factura_orden_despacho_original.cantidad_factura
      
      factura_orden_despacho=FacturaOrdenDespacho.new
	    factura_orden_despacho.orden_despacho_detalle_id=factura_orden_despacho_original.orden_despacho_detalle_id
	    factura_orden_despacho.casa_proveedora_id=factura_orden_despacho_original.casa_proveedora_id
	    factura_orden_despacho.sucursal_casa_proveedora_id=factura_orden_despacho_original.sucursal_casa_proveedora_id
        factura_orden_despacho.emitida=factura_orden_despacho_original.emitida
        #factura_orden_despacho.numero_factura=numer_factura
        factura_orden_despacho.item_nombre=factura_orden_despacho_original.item_nombre
	    factura_orden_despacho.unidad_medida_id=factura_orden_despacho_original.unidad_medida_id
	    factura_orden_despacho.cantidad=((factura_orden_despacho_original.cantidad.to_f) - (factura_orden_despacho_original.cantidad_factura.to_f))
	    factura_orden_despacho.costo_real=factura_orden_despacho_original.costo_real
	    #factura_orden_despacho.monto_financiamiento=factura_orden_despacho_original.monto_financiamiento

#antes estaba esto (eliminado)  factura_orden_despacho.monto_financiamiento=factura_orden_despacho_original.cantidad * factura_orden_despacho_original.costo_real


factura_orden_despacho.monto_financiamiento=factura_orden_despacho_original.monto_financiamiento.to_f - factura_orden_despacho_original.monto_factura.to_f
#eliminado factura_orden_despacho.monto_financiamiento=factura_orden_despacho.cantidad * factura_orden_despacho.costo_real

	    #factura_orden_despacho.monto_factura=factura_orden_despacho_original.monto_factura

	    #factura_orden_despacho.monto_factura=OrdenDespachoDetalle.find(factura_orden_despacho_original.orden_despacho_detalle_id).monto_financiamiento.to_f - factura_orden_despacho.monto_financiamiento.to_f
        factura_orden_despacho.monto_factura= factura_orden_despacho.monto_financiamiento.to_f
        #antes estaba esto (eliminado) factura_orden_despacho.monto_factura=0
	    factura_orden_despacho.cantidad_factura=0

	    factura_orden_despacho.fecha_emision=Time.now
	    #factura_orden_despacho.sucursal_casa_proveedora_id=factura_orden_despacho_original.sucursal_casa_proveedora_id

      secuencia=factura_orden_despacho_original.secuencia.strip.split("-")
      valor=secuencia[secuencia.length - 1]
      valor=valor.to_i + 1
      factura_orden_despacho.secuencia=factura_orden_despacho_original.secuencia.strip + "-" + valor.to_s

logger.debug "entre aqui en crear nuevas ordenes en validar opciones individual" << factura_orden_despacho.inspect << "id de las facturas " << factura_orden_despacho_original.id.to_s

	    success &&=factura_orden_despacho.save
        
          raise Exception, "<u>#{I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Errores.error_crear_nueva_factura')}</u>: #{factura_orden_despacho.errors.full_messages.to_s}" unless success
       end #del if
        }
      return success
      end
      rescue Exception => e
      logger.error e.message
      logger.error e.backtrace.join("\n")      
      return e.message
    end
end

end

# == Schema Information
#
# Table name: factura_orden_despacho
#
#  id                          :integer         not null, primary key
#  orden_despacho_detalle_id   :integer
#  item_nombre                 :string(100)     not null
#  unidad_medida_id            :integer         not null
#  cantidad                    :decimal(16, 2)  not null
#  costo_real                  :decimal(16, 2)  not null
#  monto_financiamiento        :decimal(16, 2)  not null
#  casa_proveedora_id          :integer
#  sucursal_casa_proveedora_id :integer
#  numero_factura              :string(20)
#  monto_factura               :decimal(16, 2)  not null
#  cantidad_factura            :decimal(16, 2)
#  fecha_factura               :date
#  fecha_emision               :date
#  confirmada                  :boolean         default(FALSE), not null
#  secuencia                   :string(100)
#  emitida                     :boolean         default(FALSE), not null
#  factura_estatus_id          :integer         default(0)
#  observacion                 :text
#

