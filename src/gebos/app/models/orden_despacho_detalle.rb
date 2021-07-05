# encoding: utf-8
#
# autor: Marvin Alfonzo
# clase: OrdenDespachoDetalle
# descripción: Migración a Rails 3
#


class OrdenDespachoDetalle < ActiveRecord::Base

  self.table_name = 'orden_despacho_detalle'

  attr_accessible :id,
                  :orden_despacho_id,
                  :item_nombre,
                  :unidad_medida_id,
                  :cantidad,
                  :costo_real,
                  :monto_financiamiento,
                  :monto_facturacion,
                  :cantidad_facturacion,
                  :observacion,
                  :plan_inversion_id,
                  :monto_recomendado

  belongs_to :estatus
  belongs_to :unidad_medida
  belongs_to :plan_inversion
  has_many :orden_despacho
  belongs_to :casa_proveedora
  belongs_to :solicitud
  belongs_to :seguimiento_visita
  belongs_to :prestamo
  belongs_to :factura_orden_despacho

#validates_presence_of :casa_proveedora_id, :sucursal_id,:message => " es requerido"

#validates_length_of :observacion, :within => 1..80, :allow_nil => false,
#    :too_short => " es demasiado corto (mínimo %d)",
#    :too_long => " es demasiado largo (máximo %d)"


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

def monto_financiamiento_f=(valor)
    self.monto_financiamiento = format_valor(valor)
  end

  def monto_financiamiento_f
    format_fm(self.monto_financiamiento)
  end


def monto_facturacion_f=(valor)
    self.monto_facturacion = format_valor(valor)
  end

  def monto_facturacion_f
    format_fm(self.monto_facturacion)
  end


def cantidad_facturacion_f=(valor)
    self.cantidad_facturacion = format_valor(valor)
  end

  def cantidad_facturacion_f
    format_fm(self.cantidad_facturacion)
  end

def monto_recomendado_f=(valor)
    self.monto_recomendado = format_valor(valor)
  end

  def monto_recomendado_f
    format_fm(self.monto_recomendado)
  end


def actualizo_estatus_orden_maquinaria(orden, casa_proveedora, sucursal,usuario,obser)

  begin

     transaction do
       @orden_despacho = OrdenDespacho.find(orden)
       iniciar_transaccion(@orden_despacho.prestamo_id, 'p_orden_despacho_emision', 'L', I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.transaccion_emision_orden_despacho',:numero_orden=>@orden_despacho.numero), usuario, @orden_despacho.monto)

                # emito la orden
                  actualizacion= OrdenDespachoDetalle.find(:all,:conditions=>"orden_despacho_id = #{orden}")

                          actualizacion.each {|orde|

                            orde.observacion=obser
                            orde.save
                          }

            #actualizamos el estatus
                           @orden_despacho.observacion=obser.to_s.strip
                           @orden_despacho.estatus_id=20010
                           success=@orden_despacho.save

                            logger.debug "Esto dio el success 2-2" << success.to_s

            #NUEVO CODIGO

                        if FacturaOrdenDespacho.count(:all,:conditions=>['orden_despacho_detalle_id = ?',OrdenDespachoDetalle.find(:first,:conditions=>['orden_despacho_id = ?',orden]).id]) == 0

                            errores = FacturaOrdenDespacho.create(@orden_despacho.id , casa_proveedora , sucursal)
                            logger.info "$$$$$$$$$$$$$$$$$$$$$1111 2-2" << errores.class.name
                            if errores
                              logger.debug "sali de esta 3-1"
                              #le cambio el estatus a la solicitud
                               solo=Solicitud.find(@orden_despacho.solicitud_id)
                               solo.estatus_id=10095
                               #solo.send(:update_without_callbacks)
                               solo.save
                              return "|#{I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.se_ha_actualizado_registro_exito')}"
                            else
                              logger.debug "Mefui por aca 3-1"
                              return error
                            end
                        else
                        #actualizamos para todas las facturas la casa proveedora y la sucursal
                            logger.debug "EEEEEEEEEEEEE >>>>> " << @orden_despacho.id.to_s
                            errores = FacturaOrdenDespacho.actualizacion(@orden_despacho.id, casa_proveedora, sucursal)
                            logger.info "$$$$$$$$$$$$$$$$$$$$$22222 2-2" << errores.class.name
                            if errores
                              logger.debug "sali de esta 2-2"
                              #le cambio el estatus a la solicitud
                               solo=Solicitud.find(@orden_despacho.solicitud_id)
                               solo.estatus_id=10095
                               solo.save
                              return "|#{I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.se_ha_actualizado_registro_exito')}"
                            else
                              logger.debug "Mefui por aca 2-2"
                              return error
                            end
                        end


                   #fin emito orden



       iniciar_transaccion(@orden_despacho.prestamo_id, 'p_dummy', 'L', I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.transaccion_dummy_orden_despacho',:numero_orden=>@orden_despacho.numero), usuario,0.0)

   end #del transaction

   rescue Exception => e
     @errores = '<label>'.html_safe << e.message.to_s << '</label>'.html_safe
     return @errores
   end # del rescue

  end


  def actualizo_estatus_orden(orden, casa_proveedora, sucursal,usuario,obser)
    logger.debug "Entre actualizo_estatus_orden"

        @orden_despacho = OrdenDespacho.find(orden)

   begin

     transaction do
       iniciar_transaccion(@orden_despacho.prestamo_id, 'p_orden_despacho_emision', 'L', I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.transaccion_emision_orden_despacho',:numero_orden=>@orden_despacho.numero), usuario, @orden_despacho.monto)

    if @orden_despacho.solicitud.estatus_id ==10090 or @orden_despacho.prestamo.monto_banco == 0



                    #if @orden_despacho.prestamo.monto_liquidado > 0 or @orden_despacho.solicitud.estatus_id ==10090

                        actualizacion= OrdenDespachoDetalle.find(:all,:conditions=>"orden_despacho_id = #{orden}")

                          actualizacion.each {|orde|

                            orde.observacion=obser
                            orde.save
                          }

            #actualizamos el estatus
                           @orden_despacho.observacion=obser.to_s.strip
                           @orden_despacho.estatus_id=20010
                           success=@orden_despacho.save

                            logger.debug "Esto dio el success 1" << success.to_s

            #NUEVO CODIGO

                        if FacturaOrdenDespacho.count(:all,:conditions=>['orden_despacho_detalle_id = ?',OrdenDespachoDetalle.find(:first,:conditions=>['orden_despacho_id = ?',orden]).id]) == 0

                            errores = FacturaOrdenDespacho.create(@orden_despacho.id , casa_proveedora , sucursal)
                            logger.info "$$$$$$$$$$$$$$$$$$$$$1111-1" << errores.class.name
                            if errores
                              @orden_despacho.prestamo.liquidar(nil, nil, Usuario.find(usuario), @orden_despacho)
                                #==================================================================================
                                # LLAMADA DEL CAUSADO PARA SIGA ELABORADO POR ALEX CIOFFI 31/05/2013
                                    begin
                                        transaction do
                                            SigaCausado.generar(@orden_despacho.prestamo.solicitud,@orden_despacho.prestamo,nil,'C','I')
                                        end
                                    end
                                    #==================================================================================
                                    # LLAMADA DEL PAGADO PARA SIGA ELABORADO POR ALEX CIOFFI 31/05/2013
                                    begin
                                        transaction do
                                            SigaPagado.generar(@orden_despacho.prestamo.solicitud,@orden_despacho.prestamo,nil,'P','I')
                                        end
                                    end
                                #==================================================================================

                              logger.debug "sali de esta 1-1"
                              return "|#{I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.se_ha_actualizado_registro_exito')}"
                            else
                              logger.debug "Mefui por aca 1-1"
                              return error
                            end
                        else
                        #actualizamos para todas las facturas la casa proveedora y la sucursal
                            logger.debug "EEEEEEEEEEEEE >>>>> " << @orden_despacho.id.to_s
                            errores = FacturaOrdenDespacho.actualizacion(@orden_despacho.id, casa_proveedora, sucursal)
                            logger.info "$$$$$$$$$$$$$$$$$$$$$22222-1" << errores.class.name
                            if errores
                              #@orden_despacho.prestamo.liquidar(nil, nil, usuario, @orden_despacho)
                              logger.debug "sali de esta 2-1"
                              return "|#{I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.se_ha_actualizado_registro_exito')}"
                            else
                              logger.debug "Mefui por aca 2-1"
                              return error
                            end


                        end

    else

                  if @orden_despacho.prestamo.monto_liquidado == 0
                    return I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.orden_despacho_no_generar_hasta_liquide')
                  else
                  # emito la orden
                  actualizacion= OrdenDespachoDetalle.find(:all,:conditions=>"orden_despacho_id = #{orden}")

                          actualizacion.each {|orde|

                            orde.observacion=obser
                            orde.save
                          }

            #actualizamos el estatus
                           @orden_despacho.observacion=obser.to_s.strip
                           @orden_despacho.estatus_id=20010
                           success=@orden_despacho.save

                            logger.debug "Esto dio el success 2-2" << success.to_s

            #NUEVO CODIGO

                        if FacturaOrdenDespacho.count(:all,:conditions=>['orden_despacho_detalle_id = ?',OrdenDespachoDetalle.find(:first,:conditions=>['orden_despacho_id = ?',orden]).id]) == 0

                            errores = FacturaOrdenDespacho.create(@orden_despacho.id , casa_proveedora , sucursal)
                            logger.info "$$$$$$$$$$$$$$$$$$$$$1111 2-2" << errores.class.name
                            if errores
                              logger.debug "sali de esta 3-1"
                              return "|#{I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.se_ha_actualizado_registro_exito')}"
                            else
                              logger.debug "Mefui por aca 3-1"
                              return error
                            end
                        else
                        #actualizamos para todas las facturas la casa proveedora y la sucursal
                            logger.debug "EEEEEEEEEEEEE >>>>> " << @orden_despacho.id.to_s
                            errores = FacturaOrdenDespacho.actualizacion(@orden_despacho.id, casa_proveedora, sucursal)
                            logger.info "$$$$$$$$$$$$$$$$$$$$$22222 2-2" << errores.class.name
                            if errores
                              logger.debug "sali de esta 2-2"
                              return "|#{I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.se_ha_actualizado_registro_exito')}"
                            else
                              logger.debug "Mefui por aca 2-2"
                              return error
                            end
                        end

                  end #fin emito orden

   end #del primer if

   iniciar_transaccion(@orden_despacho.prestamo_id, 'p_dummy', 'L', I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.transaccion_dummy_orden_despacho',:numero_orden=>@orden_despacho.numero), usuario,0.0)

   end #del transaction

   rescue Exception => e
    logger.debug "EEESEE <><<<<" << e.message.to_s
     @errores = '<label>'.html_safe<< e.message.to_s << '</label>'.html_safe

     return @errores
   end # del rescue

  end

  def actualizacion_nueva_factura(id_facturas, casa_proveedora, sucursal,usuario)

    begin

      transaction do


        @orden_despacho = OrdenDespacho.find(OrdenDespachoDetalle.find(:first,:select=>"orden_despacho_id",:conditions=>"id in (select orden_despacho_detalle_id from factura_orden_despacho where id in #{id_facturas} limit 1)",:limit=> 1).orden_despacho_id)

        iniciar_transaccion(@orden_despacho.prestamo_id, 'p_orden_despacho_emision', 'L', I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.transaccion_actualizacion_orden_despacho',:numero_orden=>@orden_despacho.numero), usuario, @orden_despacho.monto)


#NUEVO CODIGO

#actualizamos para todas las facturas la casa proveedora y la sucursal

    errores = FacturaOrdenDespacho.actualizacion_factura(id_facturas, casa_proveedora, sucursal)
    logger.info "$$$$$$$$$$$$$$$$$$$$$" << errores.class.name
    if errores.class.name == "TrueClass"

      #ojo agregado este nuevo codigo el 24/05/2013
      if @orden_despacho.estatus_id==20070
          @orden_despacho.estatus_id=20050
          @orden_despacho.save
      end
      #fin ojo
      return "|#{I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.se_ha_actualizado_registro_exito')}"
    else
      return errores
    end



      iniciar_transaccion(@orden_despacho.prestamo_id, 'p_dummy', 'L', I18n.t('Sistema.Body.Modelos.OrdenDespachoDetalle.Mensajes.transaccion_dummy_orden_despacho',:numero_orden=>@orden_despacho.numero), usuario,0.0)


        end #del transaction

        rescue Exception => e
            logger.debug "EEESEE <><<<<" << e.message.to_s
          @errores = '<label>'.html_safe<< e.message.to_s << '</label>'.html_safe

          return @errores

        end # del rescue

  end
end

# == Schema Information
#
# Table name: orden_despacho_detalle
#
#  id                   :integer         not null, primary key
#  orden_despacho_id    :integer
#  item_nombre          :string(100)     not null
#  unidad_medida_id     :integer         not null
#  cantidad             :decimal(16, 2)  not null
#  costo_real           :decimal(16, 2)  not null
#  monto_financiamiento :decimal(16, 2)  not null
#  monto_facturacion    :decimal(16, 2)  not null
#  cantidad_facturacion :decimal(16, 2)
#  observacion          :text
#  plan_inversion_id    :integer
#  monto_recomendado    :decimal(16, 3)  default(0.0), not null
#

