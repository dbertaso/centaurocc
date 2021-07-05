# encoding: utf-8

require 'rubygems'
require 'fastercsv'
require 'csv'

class OrdenDespacho < ActiveRecord::Base

  self.table_name = 'orden_despacho'


  attr_accessible   :id,
                    :solicitud_id,
                    :seguimiento_visita_id,
                    :prestamo_id,
                    :numero,
                    :estatus_id,
                    :monto,
                    :observacion,
                    :estado_id,
                    :usuario_id,
                    :fecha_orden_despacho,
                    :fecha_cierre,
                    :realizado,
                    :fecha_liquidacion,
                    :tipo_pago,
                    :observacion_cerrado,
                    :casa_proveedora_id,
                    :fecha_orden_despacho_f,
                    :fecha_cierre_f

  belongs_to :estado
  belongs_to :rubro
  belongs_to :sector
  belongs_to :prestamo
  belongs_to :municipio
  belongs_to :estatus
  belongs_to :programa
  belongs_to :solicitud
  belongs_to :casa_proveedora
  belongs_to :seguimiento_visita

  has_many :orden_despacho_detalle

  def monto_fm
    format_fm(self.monto)
  end


  def fecha_orden_despacho_f=(fecha)
    self.fecha_orden_despacho = fecha
  end

  def fecha_orden_despacho_f
    format_fecha(self.fecha_orden_despacho)
  end


  def fecha_cierre_f=(fecha)
    self.fecha_cierre = fecha
  end

  def fecha_cierre_f
    format_fecha(self.fecha_cierre)
  end




  def generar_detalle_despacho_v(items)
    success = true
    begin
      transaction do
        items = items.split(',')
        items.each { |i|
          plan = PlanInversion.find(i)
          montodes = (plan.monto_financiamiento - plan.monto_desembolsado)
          montoxrec = (self.seguimiento_visita.seguimiento_cultivo.superficie_recomendada * plan.costo_real)
          if (montodes < montoxrec)
            montoxrec = montodes
          end

          logger.debug "Item nro. "<< plan.id.to_s
          success &&=OrdenDespachoDetalle.create!(
            :orden_despacho_id=>self.id,
            :plan_inversion_id=>plan.id,
            :item_nombre=>plan.item_nombre,
            :unidad_medida_id=>plan.unidad_medida_id,
            :cantidad=>self.seguimiento_visita.seguimiento_cultivo.superficie_recomendada * plan.cantidad_por_hectarea,
            :costo_real=>plan.costo_real,
            :monto_financiamiento=>plan.monto_financiamiento,
            :monto_facturacion=>0,
            :monto_recomendado=>montoxrec

          )
          raise "#{I18n.t('Sistema.Body.Modelos.OrdenDespacho.Errores.crear_detalle_orden_despacho')} #{plan.id}" unless success
        }
        monto_total_orden_despacho = OrdenDespachoDetalle.sum(:monto_recomendado, :conditions=>"orden_despacho_id = #{self.id}")
        self.monto = monto_total_orden_despacho
        success &&=self.save!
        raise I18n.t('Sistema.Body.Modelos.OrdenDespacho.Errores.actualizar_orden_despacho') unless success

        ## ruta donde debe avanzar el credito
        # solicitud = Solicitud.find(self.solicitud_id)
        # estatus_id_inicial = solicitud.estatus_id
        # unless  estatus_id_inicial == 10050
        #  fecha_evento = Time.now
        #  estatus_id_final = 10090
        #  solicitud.estatus_id = estatus_id_final
        #  solicitud.fecha_actual_estatus = fecha_evento.strftime("%Y/%m/%d")
        #  success &&= solicitud.save
        #  raise Exception, "Error al guardar la solicitud" unless success
        #  # Crea un nuevo registro en la tabla control_solicitud
        #  success &&= ControlSolicitud.create_new(solicitud.id, estatus_id_final, @usuario.id, 'Avanzar', estatus_id_inicial, '')
        #  raise Exception, "Error al registrar la traza de seguimiento" unless success
        #end
        ##

        return success
      end
    rescue Exception => e
      logger.error e.message
      logger.error e.backtrace.join("\n")
      return false
    end
  end

  def generar_detalle_despacho_g(items, params)
    success = true
    begin
      transaction do
        items = items.split(',')
        items.each { |i|
          plan = PlanInversion.find(i)
          logger.debug "Item nro. "<< plan.id.to_s
          success &&=OrdenDespachoDetalle.create!(
            :orden_despacho_id=>self.id,
            :plan_inversion_id=>plan.id,
            :item_nombre=>plan.item_nombre,
            :unidad_medida_id=>plan.unidad_medida_id,
            :cantidad=>plan.cantidad,
            :costo_real=>plan.costo_real,
            :monto_financiamiento=>plan.monto_financiamiento,
            :monto_facturacion=>0,
            :monto_recomendado=>params[:"monto_recomendado_#{plan.id}"].to_f

          )
          raise "#{I18n.t('Sistema.Body.Modelos.OrdenDespacho.Errores.crear_detalle_orden_despacho')} #{plan.id}" unless success
        }
        monto_total_orden_despacho = OrdenDespachoDetalle.sum(:monto_recomendado, :conditions=>"orden_despacho_id = #{self.id}")
        self.monto = monto_total_orden_despacho
        success &&=self.save!
        raise I18n.t('Sistema.Body.Modelos.OrdenDespacho.Errores.actualizar_orden_despacho') unless success

        # ruta donde debe avanzar el credito
        solicitud = Solicitud.find(self.solicitud_id)
        estatus_id_inicial = solicitud.estatus_id
        unless  estatus_id_inicial == 10050
          fecha_evento = Time.now
          estatus_id_final = 10090
          solicitud.estatus_id = estatus_id_final
          solicitud.fecha_actual_estatus = fecha_evento
          success &&= solicitud.save
          raise I18n.t('Sistema.Body.Modelos.OrdenDespacho.Errores.guardar_solicitud') unless success
          # Crea un nuevo registro en la tabla control_solicitud
          #success &&= ControlSolicitud.create_new(solicitud.id, estatus_id_final, @usuario.id, 'Avanzar', estatus_id_inicial, '')
          #raise Exception, "Error al registrar la traza de seguimiento" unless success
        end
        ####

        return success
      end
    rescue Exception => e
      logger.error e.message
      logger.error e.backtrace.join("\n")
      return false
    end
  end

  def cantidad_f=(valor)
    self.cantidad = format_valor(valor)
  end

  def cantidad_f
    format_f(self.cantidad)
  end

  def monto_f=(valor)
    self.monto = format_valor(valor)
  end

  def monto_f
    format_fm(self.monto)
  end

  ##################################### nuevos metodos


def self.rectifico(parametro)
  begin
      transaction do
    unless parametro[:buenos].nil?
      par=ViewListOrdenDespachoInsumo.find(:first,:conditions=>"identificador = '#{parametro[:buenos][:identificador]}'")

      control_historico = HistoricoLiquidacionCasaProveedora.new
                control_historico.fecha_liquidacion = Time.now
                control_historico.solicitud_id = OrdenDespacho.find(par.orden_despacho_id).solicitud_id
                control_historico.prestamo_id = Prestamo.find_by_solicitud_id(OrdenDespacho.find(par.orden_despacho_id).solicitud_id).id
                casa_pr=CasaProveedora.find_by_sql("select id,entidad_financiera_id,numero_cuenta from casa_proveedora where id=(select casa_proveedora_id from factura_orden_despacho where numero_factura='#{par.numero_factura}' and orden_despacho_detalle_id in (select id from orden_despacho_detalle where orden_despacho_id=#{par.orden_despacho_id}) limit 1)" )
                control_historico.casa_proveedora_id = casa_pr[0].id
                control_historico.archivo = I18n.t('Sistema.Body.General.no_aplica')
                control_historico.monto_liquidacion= par.monto_total_factura
                control_historico.numero_factura =par.numero_factura
                control_historico.numero_cuenta_liquidadora =I18n.t('Sistema.Body.General.no_aplica')
                control_historico.entidad_financiera_casa_proveedora_id =casa_pr[0].entidad_financiera_id
                control_historico.numero_cuenta_casa_proveedora = casa_pr[0].numero_cuenta
                control_historico.save

                #cambiamos el estatus de la factura
                factura_ord=FacturaOrdenDespacho.find_by_sql("select * from factura_orden_despacho where numero_factura='#{par.numero_factura}' and factura_estatus_id=10057 and confirmada=true and orden_despacho_detalle_id in (select id from orden_despacho_detalle where orden_despacho_id=#{par.orden_despacho_id})")

                factura_ord.each{|factura|

                #factura.factura_estatus_id=10070
                #factura.send(:update_without_callbacks)
                factura.update_column(:factura_estatus_id, 10070)


                }

                #verificamos si todas las facturas de esa orden fueron liquidadas

                cantidad_orden=FacturaOrdenDespacho.find_by_sql("select * from factura_orden_despacho where orden_despacho_detalle_id in (select id from orden_despacho_detalle where orden_despacho_id=#{par.orden_despacho_id})")
                cantidad_orden_aprobado=FacturaOrdenDespacho.find_by_sql("select * from factura_orden_despacho where orden_despacho_detalle_id in (select id from orden_despacho_detalle where orden_despacho_id=#{par.orden_despacho_id}) and factura_estatus_id=10070")

                logger.debug "Orden id= " << par.orden_despacho_id.to_s << " cantidad orden " << cantidad_orden.to_s << " cantidad aprobada " << cantidad_orden_aprobado.to_s


                # esto sirve para cambiarle el estatus de la orden para verificar si esta completamente liquidada
                if cantidad_orden.length == cantidad_orden_aprobado.length
                  ordden=OrdenDespacho.find(par.orden_despacho_id)

                  ordden.estatus_id=20080

                  ordden.save

                #else
                  #ordden=OrdenDespacho.find(par.orden_despacho_id)
                  # por liquidar
                  #ordden.estatus_id=20060

                  #ordden.save

                end

    end

      unless parametro[:malos].nil?

      par_malos=ViewListOrdenDespachoInsumo.find(:first,:conditions=>"identificador = '#{parametro[:malos][:identificador]}'")

    control_rechazo = RechazoLiquidacionCasaProveedora.new
              control_rechazo.fecha =Time.now
              control_rechazo.archivo=I18n.t('Sistema.Body.General.no_aplica')
              control_rechazo.prestamo_numero= Prestamo.find_by_solicitud_id(OrdenDespacho.find(par_malos.orden_despacho_id).solicitud_id).numero
              control_rechazo.solicitud_numero= Solicitud.find(OrdenDespacho.find(par_malos.orden_despacho_id).solicitud_id).numero
              casa_pr2=CasaProveedora.find_by_sql("select id,entidad_financiera_id,numero_cuenta from casa_proveedora where id=(select casa_proveedora_id from factura_orden_despacho where numero_factura='#{par_malos.numero_factura}' and orden_despacho_detalle_id in (select id from orden_despacho_detalle where orden_despacho_id=#{par_malos.orden_despacho_id}) limit 1)" )
              control_rechazo.casa_proveedora_id=casa_pr2[0].id
              control_rechazo.numero_factura = par_malos.numero_factura
              control_rechazo.monto_pago= par_malos.monto_total_factura
              control_rechazo.codigo_error=I18n.t('Sistema.Body.General.no_aplica')
              control_rechazo.descripcion_error=I18n.t('Sistema.Body.General.no_aplica')
              control_rechazo.entidad_financiera_id=casa_pr2[0].entidad_financiera_id
              control_rechazo.numero_cuenta=casa_pr2[0].numero_cuenta
              control_rechazo.procesado=true
              control_rechazo.save

              #verificar esto ya q no es correcto
              factura_ord=FacturaOrdenDespacho.find_by_sql("select * from factura_orden_despacho where numero_factura='#{par_malos.numero_factura}' and factura_estatus_id=10057 and confirmada=true and orden_despacho_detalle_id in (select id from orden_despacho_detalle where orden_despacho_id=#{par_malos.orden_despacho_id})")

              factura_ord.each{|factura|

              #factura.factura_estatus_id=10080
              #factura.send(:update_without_callbacks)
              factura.update_column(:factura_estatus_id, 10080)


              }


              cantidad_orden=FacturaOrdenDespacho.find_by_sql("select * from factura_orden_despacho where orden_despacho_detalle_id in (select id from orden_despacho_detalle where orden_despacho_id=#{par_malos.orden_despacho_id})")
              cantidad_orden_rechazado=FacturaOrdenDespacho.find_by_sql("select * from factura_orden_despacho where  orden_despacho_detalle_id in (select id from orden_despacho_detalle where orden_despacho_id=#{par_malos.orden_despacho_id}) and factura_estatus_id=10080")



              # esto sirve para cambiarle el estatus de la orden para verificar si esta completamente rechazada por el banco


              logger.debug "Orden id= " << par_malos.orden_despacho_id.to_s << " cantidad orden " << cantidad_orden.to_s << " cantidad rechazado " << cantidad_orden_rechazado.to_s

              if cantidad_orden.length == cantidad_orden_rechazado.length
                ordden=OrdenDespacho.find(par_malos.orden_despacho_id)

                ordden.estatus_id=20090

                ordden.save

              #else
                #ordden=OrdenDespacho.find(par_malos.orden_despacho_id)
                # por liquidar
                #ordden.estatus_id=20060

                #ordden.save
              end

    end
    end # do

    end  #begin
  end




def self.save_montos( archivo, fecha, usuario_id )
    @ids_r = []
    @ids= []
    @msg= []
    @total=0

    begin
      transaction do
        name =  archivo[:datafile].original_filename.to_s
        unless name.nil? || name.empty?
          ext  =  name[(name.length - 3),name.length]
          unless ext == 'txt'
            @msg << I18n.t('Sistema.Body.Modelos.OrdenDespacho.Errores.formato_txt_incorrecto')
            @clase = "error"
            if fecha.nil? || fecha.empty?
              @msg << I18n.t('Sistema.Body.Modelos.Desembolso.Errores.fecha_real')
            end
          else
          if fecha.nil? || fecha.empty?
            @msg << I18n.t('Sistema.Body.Modelos.Desembolso.Errores.fecha_real')
            return
          end

          fecha =format_fecha_conversion(fecha)

          directory = "tmp"
          count = 0
          path = File.join(directory, name)

          File.open(path, "wb") { |f| f.write(archivo[:datafile].read) }
          count = 0

          File.foreach(path) do |row|

            count = count + 1
            contenido = row.to_s.gsub(/\r\n/,"").to_s

            logger.info "LONGITUD antes de hacer gsub =====>" << row.to_s.length.to_s
            contenido = contenido.gsub(/[áÁäÄ]/, 'a')
            contenido = contenido.gsub(/[éÉëË]/, 'e')
            contenido = contenido.gsub(/[íÍïÏ]/, 'i')
            contenido = contenido.gsub(/[óÓöÖ]/, 'o')
            contenido = contenido.gsub(/[úÚüÜ]/, 'u')
            contenido = contenido.gsub(/[ñÑ]/, 'ñ')
            contenido = contenido.gsub(/[#°ººÂÃ@]/, ' ')
            contenido = contenido.delete('"')

            logger.debug "COUNTTT ===>>>>>>" << count.to_s

            logger.info "LONGITUD con =====>" << row.to_s.length.to_s


            logger.info "LONGITUD sin =====>" << row.to_s.gsub(/\r\n/,"").length.to_s


            # antes "\n", ""

            if row.to_s.gsub(/\r\n/,"").length == 200 || row.to_s.gsub(/\r\n/,"").length == 138 || row.to_s.gsub(/\r\n/,"").length == 251 || row.to_s.gsub(/\r\n/,"").length == 103 || row.to_s.gsub(/\r\n/,"").length == 88 || row.to_s.gsub(/\r\n/,"").length == 37
            # se quito if row.to_s.gsub(/\r\n/,"").length == 199 || row.to_s.gsub(/\r\n/,"").length == 139 || row.to_s.gsub(/\r\n/,"").length == 250 || row.to_s.gsub(/\r\n/,"").length == 102 || row.to_s.gsub(/\r\n/,"").length == 87 || row.to_s.gsub(/\r\n/,"").length == 36

                logger.info "LONGITUD PERMITIDA=====>" << row.to_s.length.to_s

               if row.to_s.gsub(/\r\n/,"").length == 200
                  numero_cta_otorgante=contenido[73,20]
                  logger.info "numero de cuenta del otorgante " << numero_cta_otorgante.to_s
               end
               if row.to_s.gsub(/\r\n/,"").length == 251

                  nro_solicitud = contenido[8,8]
                  ci_rif = contenido[16,10]
                  monto = contenido[78,18]
                  status = contenido[167,4]
                  des_status = contenido[171,80]

                  if ci_rif[0,1].upcase == I18n.t('Sistema.Body.General.TipoDocumento.juridico') || ci_rif[0,1].upcase == I18n.t('Sistema.Body.General.TipoDocumento.gobierno')
                    ci_rif=ci_rif[0,1] << "-" << ci_rif[1,8] << "-" << ci_rif[9,1]
                  else

                    ci_rif= ci_rif[1,9]

                  end

					#OJO con esto 27/08/2013
					monto=monto.gsub("#{I18n.t('Sistema.Body.ExpresionesRegulares.separador_decimal')}","#{I18n.t('Sistema.Body.ExpresionesRegulares.separador_miles')}")
                  	#OJO
                  logger.info "primer monto ====>>> " << monto.to_s


                  monto= monto.to_f
                  valorito = format_fm(monto)
				  monto_formateado=valorito

                  logger.info "Monto Dividido====>>" << monto.to_s

                  logger.info "ROWWW=====>>>>>>>>>>" << row.to_s
                  logger.debug "NRO SOLICITUD====>" << nro_solicitud.inspect
                  logger.debug "CIRIF========>" << ci_rif.inspect
                  logger.debug "estatus =====>" << status.inspect
                  logger.debug "descripcion ===>" << des_status.inspect
                  logger.info "MONTO=======> " << monto.to_s
                  fecha_evento = Time.now

                  #buscamos todas las facturas sospechosas

                  sentencia="SELECT * from (SELECT factura_orden_despacho.numero_factura,factura_orden_despacho.factura_estatus_id, ode.id AS orden_despacho_id, sum(factura_orden_despacho.monto_factura) AS monto_total_factura
							FROM factura_orden_despacho JOIN orden_despacho_detalle odsd ON odsd.id = factura_orden_despacho.orden_despacho_detalle_id and factura_orden_despacho.factura_estatus_id=10057
							JOIN orden_despacho ode ON odsd.orden_despacho_id = ode.id
							WHERE factura_orden_despacho.numero_factura IS NOT NULL and numero_factura='#{nro_solicitud}'
							GROUP BY factura_orden_despacho.numero_factura,factura_orden_despacho.factura_estatus_id, ode.id
							ORDER BY factura_orden_despacho.numero_factura,factura_orden_despacho.factura_estatus_id, ode.id) ss where monto_total_factura=#{monto} "

                  factuu=FacturaOrdenDespacho.find_by_sql(sentencia)
                        arreg_global=[]
                        condi_global="("
                        condi_global_numero="("
						  factuu.each{ |fact|
							solicitud_global=Solicitud.find(OrdenDespacho.find(fact.orden_despacho_id).solicitud_id)
							arreg_global << solicitud_global.numero.to_s+"^"+fact.numero_factura
							condi_global+=solicitud_global.id.to_s << ","
							condi_global_numero+=solicitud_global.numero.to_s << ","
							}
						  condi_global=condi_global[0,condi_global.length-1]
						  condi_global+=")"
						  condi_global_numero=condi_global_numero[0,condi_global_numero.length-1]
						  condi_global_numero+=")"
                  logger.debug "como quedaron " << arreg_global.inspect.to_s << " " << condi_global << " " << condi_global_numero

                  result = true

                  if status != 'VE6 '

                    result2 = false

                  else
                    result2 = true
                  end

                  if result and result2

                    logger.info "Result entrando =====> " << result.to_s << " " << result2.to_s

# fue exitoso
                    la_factura=FacturaOrdenDespacho.find_by_sql(sentencia)
                    unless la_factura.length == 0

                        #verificamos si esa factura se liquido anteriormente

            if la_factura.length!=1
							@ids << arreg_global
						else
							if HistoricoLiquidacionCasaProveedora.find(:all,:conditions=>"monto_liquidacion=#{monto} and numero_factura='#{nro_solicitud}' and solicitud_id = #{OrdenDespacho.find(la_factura[0].orden_despacho_id).solicitud_id}").length==0
								control_historico = HistoricoLiquidacionCasaProveedora.new
								control_historico.fecha_liquidacion = fecha_evento
								control_historico.solicitud_id = OrdenDespacho.find(la_factura[0].orden_despacho_id).solicitud_id
								control_historico.prestamo_id = Prestamo.find_by_solicitud_id(OrdenDespacho.find(la_factura[0].orden_despacho_id).solicitud_id).id
								casa_pr=CasaProveedora.find_by_sql("select id,entidad_financiera_id,numero_cuenta from casa_proveedora where id=(select casa_proveedora_id from factura_orden_despacho where numero_factura='#{nro_solicitud}' and factura_estatus_id=10057 and orden_despacho_detalle_id in (select id from orden_despacho_detalle where orden_despacho_id=#{la_factura[0].orden_despacho_id}) limit 1)" )
								control_historico.casa_proveedora_id = casa_pr[0].id
								control_historico.archivo = name
								control_historico.monto_liquidacion= monto
								control_historico.numero_factura =nro_solicitud
								control_historico.numero_cuenta_liquidadora =numero_cta_otorgante
								control_historico.entidad_financiera_casa_proveedora_id =casa_pr[0].entidad_financiera_id
								control_historico.numero_cuenta_casa_proveedora = casa_pr[0].numero_cuenta
								control_historico.save
								#actualizamos el estatus de las facturas

								factura_ord=FacturaOrdenDespacho.find_by_sql("select * from factura_orden_despacho where numero_factura='#{nro_solicitud}' and factura_estatus_id=10057 and confirmada=true and orden_despacho_detalle_id in (select id from orden_despacho_detalle where orden_despacho_id=#{la_factura[0].orden_despacho_id})")

								factura_ord.each{|factura|

								#factura.factura_estatus_id=10070
								#factura.send(:update_without_callbacks)
                factura.update_column(:factura_estatus_id, 10070)


								}

								cantidad_orden=FacturaOrdenDespacho.find_by_sql("select * from factura_orden_despacho where orden_despacho_detalle_id in (select id from orden_despacho_detalle where orden_despacho_id=#{la_factura[0].orden_despacho_id})")
							  cantidad_orden_aprobado=FacturaOrdenDespacho.find_by_sql("select * from factura_orden_despacho where  orden_despacho_detalle_id in (select id from orden_despacho_detalle where orden_despacho_id=#{la_factura[0].orden_despacho_id}) and factura_estatus_id=10070")

								logger.debug "Orden id= " << la_factura[0].orden_despacho_id.to_s << " cantidad orden " << cantidad_orden.to_s << " cantidad aprobada " << cantidad_orden_aprobado.to_s


								# esto sirve para cambiarle el estatus de la orden para verificar si esta completamente liquidada
								if cantidad_orden.length == cantidad_orden_aprobado.length
									ordden=OrdenDespacho.find(la_factura[0].orden_despacho_id)

									ordden.estatus_id=20080

									ordden.save

								#else
									#ordden=OrdenDespacho.find(la_factura[0].orden_despacho_id)
									# por liquidar
									#ordden.estatus_id=20060

									#ordden.save

								end

								@total = @total + 1
								logger.info "TOTALLLL ======>>>>>>>>" << @total.inspect

							else
								@msg << I18n.t('Sistema.Body.Modelos.OrdenDespacho.Errores.ya_ha_sido_liquidada',:nro_solicitud=>nro_solicitud)
							end

						end
                    else

                      #@ids=''
                      #@total=''
                      @msg << I18n.t('Sistema.Body.Modelos.OrdenDespacho.Errores.no_se_localizo_la_factura',:nro_solicitud=>nro_solicitud,:monto_formateado=>monto_formateado)

                    logger.debug "eeeeeeeeeeeeeee " <<  @msg.to_s
                    #return @total, @ids, @msg
                    end


            end

            if !result2
              @total = @total + 1
				la_fact2=FacturaOrdenDespacho.find_by_sql(sentencia)
             unless la_fact2.length == 0
              if la_fact2.length!=1
							 @ids_r << arreg_global
						  else
  							control_rechazo = RechazoLiquidacionCasaProveedora.new
  							control_rechazo.fecha =fecha_evento
  							control_rechazo.archivo=name
  							control_rechazo.prestamo_numero= Prestamo.find_by_solicitud_id(OrdenDespacho.find(la_fact2[0].orden_despacho_id).solicitud_id).numero
  							control_rechazo.solicitud_numero= Solicitud.find(OrdenDespacho.find(la_fact2[0].orden_despacho_id).solicitud_id).numero
  							casa_pr2=CasaProveedora.find_by_sql("select id,entidad_financiera_id,numero_cuenta from casa_proveedora where id=(select casa_proveedora_id from factura_orden_despacho where numero_factura='#{nro_solicitud}' and factura_estatus_id=10057 and orden_despacho_detalle_id in (select id from orden_despacho_detalle where orden_despacho_id=#{la_fact2[0].orden_despacho_id}) limit 1)" )
  							control_rechazo.casa_proveedora_id=casa_pr2[0].id
  							control_rechazo.numero_factura = nro_solicitud
  							control_rechazo.monto_pago= monto
  							control_rechazo.codigo_error=status
  							control_rechazo.descripcion_error=des_status
  							control_rechazo.entidad_financiera_id=casa_pr2[0].entidad_financiera_id
  							control_rechazo.numero_cuenta=casa_pr2[0].numero_cuenta
  							control_rechazo.procesado=true
  							control_rechazo.save

  							factura_ord=FacturaOrdenDespacho.find_by_sql("select * from factura_orden_despacho where numero_factura='#{nro_solicitud}' and factura_estatus_id=10057 and confirmada=true and orden_despacho_detalle_id in (select id from orden_despacho_detalle where orden_despacho_id=#{la_fact2[0].orden_despacho_id})")

  							factura_ord.each{|factura|

  							#factura.factura_estatus_id=10080
  							#factura.send(:update_without_callbacks)
                factura.update_column(:factura_estatus_id, 10080)


  							}


							cantidad_orden=FacturaOrdenDespacho.find_by_sql("select * from factura_orden_despacho where orden_despacho_detalle_id in (select id from orden_despacho_detalle where orden_despacho_id=#{la_fact2[0].orden_despacho_id})")
							cantidad_orden_rechazado=FacturaOrdenDespacho.find_by_sql("select * from factura_orden_despacho where orden_despacho_detalle_id in (select id from orden_despacho_detalle where orden_despacho_id=#{la_fact2[0].orden_despacho_id}) and factura_estatus_id=10080")

							# esto sirve para cambiarle el estatus de la orden para verificar si esta completamente rechazada por el banco


							logger.debug "Orden id= " << la_fact2[0].orden_despacho_id.to_s << " cantidad orden " << cantidad_orden.to_s << " cantidad rechazado " << cantidad_orden_rechazado.to_s

							if cantidad_orden.length == cantidad_orden_rechazado.length
								ordden=OrdenDespacho.find(la_fact2[0].orden_despacho_id)

								ordden.estatus_id=20090

								ordden.save

							#else
								#ordden=OrdenDespacho.find(la_fact2[0].orden_despacho_id)
								# por liquidar
								#ordden.estatus_id=20060

								#ordden.save
							end
						end

                    else

                        #@ids=''
                        #@total=0
                        @msg << I18n.t('Sistema.Body.Modelos.OrdenDespacho.Errores.ya_ha_sido_rechazada_o_no_se_encontro',:nro_solicitud=>nro_solicitud)

                        logger.debug "eeeeeeeeeeeeeee " <<  @msg.to_s
                        #return @total, @ids, @msg
                    end


              end

              else

              result = false

                logger.info "REsult ultimo al finalizar la actualizacion"
              end

                logger.info "Resultadossssss =====> " << result.to_s << " " << result2.to_s

          else

              @msg << "#{I18n.t('Sistema.Body.Modelos.OrdenDespacho.Errores.la_linea')} #{count} #{I18n.t('Sistema.Body.Modelos.OrdenDespacho.Errores.formato_adecuado')} #{row.to_s.gsub(/\r\n/,'').length.to_s} #{I18n.t('Sistema.Body.Modelos.OrdenDespacho.Errores.caracter')}"
              #@ids=''
              #@total=0


            logger.debug "NO INGRESO============>>>>>" << row.to_s.gsub(/\r\n/,"") << "CANTIDAD " << row.to_s.gsub(/\r\n/,"").length.to_s
          end
       end
      end
    else
      @msg << I18n.t('Sistema.Body.Modelos.OrdenDespacho.Errores.cargar_archivo')
      if fecha.nil? || fecha.empty?
        @msg << I18n.t('Sistema.Body.Modelos.Desembolso.Errores.fecha_real')
      end
    end
    logger.info "TOTALLLL ======>>>>>>>>" << @total.to_s
    total = @total
    logger.info " TOOOOOOTALL ======>>>>>>>> " << total.to_s
    logger.info " IDS============>>>>> " << @ids.inspect
    logger.info " Ambos ============>>>>> " << @ids.inspect << " rechazados " << @ids_r.inspect

    ids = @ids
    ids_r = @ids_r
    return ids_r, ids, @msg #["Archivo o Tipo de Archivo incorrecto"]

    end # do

    end  #begin

  end

  def confirmar_solo_insumo(user)
    begin
      transaction do
        # ruta donde debe avanzar el credito
        solicitud = Solicitud.find(self.solicitud_id)
        estatus_id_inicial = solicitud.estatus_id
        #NUEVO ESTATUS ORDEN DE DESPACHO SOLO INSUMO
        estatus_id_final = 10090
        success_final = true
        self.seguimiento_visita.confirmada = true
        success_final &&=self.seguimiento_visita.save!
        logger.info "INSPECT SEGUIMIENTO VISITA DENTRO DE VALIDAR ORDEN DE DESPACHO"<< self.seguimiento_visita.inspect.to_s
        logger.info "============================"
        logger.info "Errores en Seguimiento " << self.seguimiento_visita.errors.to_s

        if !success_final
            errors.add(:orden_despacho, "#{I18n.t('Sistema.Body.Modelos.Desembolso.Errores.actualizar_tramite')} #{solicitud.numero} " << self.seguimiento_visita.errors.full_messages.to_s)
            return false
            return success_final
        else

            fecha_evento = Time.now
            solicitud.estatus_id = estatus_id_final
            solicitud.fecha_actual_estatus = fecha_evento

            success = solicitud.save!
            if !success
                errors.add(:orden_despacho, "#{I18n.t('Sistema.Body.Modelos.Desembolso.Errores.actualizar_tramite')} #{solicitud.numero}")
            else

              #----------- GUARDANDO AVANCE DE SOLICITUD ---------------------

              success = ControlSolicitud.create_new(solicitud.id, estatus_id_final, user.id, I18n.t('Sistema.Body.Modelos.OrdenDespacho.Mensajes.envio_inf_orden_despacho'), estatus_id_inicial, '')
              if !success
                errors.add(:orden_despacho, "#{I18n.t('Sistema.Body.Modelos.Desembolso.Errores.traza_tramite')} #{solicitud.numero}")
              else
                self.realizado = false
                self.save!
              end
            end
            return success
        end
     end
     rescue Exception => e
     logger.error e.message
     logger.error e.backtrace.join("\n")
     return false
    end
  end




  ####################### fin de los nuevos metodos

end


# == Schema Information
#
# Table name: orden_despacho
#
#  id                    :integer         not null, primary key
#  solicitud_id          :integer         not null
#  seguimiento_visita_id :integer         not null
#  prestamo_id           :integer         not null
#  numero                :string(32)
#  estatus_id            :integer         not null
#  monto                 :decimal(16, 2)  not null
#  observacion           :text
#  estado_id             :integer         not null
#  usuario_id            :integer         not null
#  fecha_orden_despacho  :date
#  fecha_cierre          :date
#  realizado             :boolean         default(FALSE), not null
#  fecha_liquidacion     :date
#  tipo_pago             :string(1)
#  observacion_cerrado   :text
#  casa_proveedora_id    :integer
#

