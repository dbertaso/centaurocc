# encoding: utf-8

#
# autor: Diego Bertaso
# clase: ContabilizarDevengo
# descripción: Migrado a Rails 3
#

class DevengoMensual < ActiveRecord::Base

   set_table_name :plan_pago_cuota

   @devengos = nil
   @tipo = ''

   def self.contabilizacion_devengos(devengos, tipo)

    begin

      logger.info "COMENZANDO LA CONTABILIZACION DE LOS DEVENGOS"

      transaction do

        logger.info "COMENZANDO LA TRANSACCION DE CONTABILIZACION DE LOS DEVENGOS"
        logger.info "ARCHIVO DEVENGOS =====> " << devengos.inspect
        logger.info "TIPO DE DEVENGOS =====> " << tipo.to_s
        logger.info "CANTIDAD DE DEVENGOS ====> " << devengos.length.to_s

        devengos.each do |devengo|

          prestamo = Prestamo.find(devengo.prestamo_id)

          logger.info "PRESTAMO =======> " << prestamo.inspect

          monto_interes = 0.00
          monto_interes_diferido = 0.00

          if tipo == 'C'
             codigo = 19
             nombre = 'DEVENGO INTERESES ORDINARIOS'
          else
             codigo = 19
             nombre = 'DEVENGO INTERESES DIFERIDOS'
          end

          monto_interes_ordinario = devengo.monto.to_f - devengo.monto_dif.to_f
          monto_interes_diferido = devengo.monto_dif.to_f
          monto_total = devengo.monto

          logger.info "Monto Interes ====> " << monto_interes_ordinario.to_s
          logger.info "Monto Interes Diferido====> " << monto_interes_diferido.to_s

          if prestamo.banco_origen == 'FONDAS'
            fuente_recursos_id = 1
          elsif prestamo.banco_origen == 'AGROVENEZUELA'
            fuente_recursos_id = 2
          elsif prestamo.banco_origen == 'FONDAFA'
            fuente_recursos_id = 3
          end

          cliente = Cliente.find(prestamo.cliente_id)

          #logger.info "SECTOR ECONOMICO ===> " << sector_economico_id.to_s

          #fecha = Time.now
          #fecha = Time.now.strftime("%d%m%y")
          #logger.info "FECHA DE HOY " << fecha.to_s

          #contar += 1
          #logger.info "CONTADOR ====> " << contar.to_s

          logger.info "MONTO DEVENGO ====> " << devengo.monto.to_s

          if devengo.monto.to_f > 0

            params = {  :p_transaccion_contable_id=>codigo,
                        :p_modalidad=>'D',
                        :p_fuente_recursos_id=>2,
                        :p_programa_id=> prestamo.solicitud.programa_id,
                        :p_estatus=>prestamo.estatus,
                        :p_entidad_financiera_id=>0,
                        :p_monto_pago=>monto_total,
                        :p_monto_ingreso_intereses=>monto_interes_ordinario,
                        :p_monto_por_cobrar_intereses=>0,
                        :p_remanente_por_aplicar=>0,
                        :p_monto_capital_cuota=>0,
                        :p_ingreso_mora=>0,
                        :p_remanente_por_aplicar_inicial=>0,
                        :p_monto_comision_intereses=>0,
                        :p_interes_diferido=>monto_interes_diferido,
                        :p_monto_gasto=>0,
                        :p_monto_sras=>0,
                        :p_monto_excedente=>0,
                        :p_monto_desembolso=>0,
                        :p_fecha_registro=>Time.now.strftime("%Y-%m-%d"),
                        :p_fecha_comprobante=>devengo.fecha.strftime("%Y-%m-%d"),
                        :p_prestamo_id=>prestamo.id,
                        :p_factura_id=>0,
                        :p_anio=>devengo.fecha.year,
                        :p_voucher=>prestamo.numero.to_s,
                        :p_banco=>(prestamo.cliente.entidad_financiera.nil? ? 'N/A' : prestamo.cliente.entidad_financiera.nombre) ,
                        :p_nombre=>prestamo.cliente.nombre,
                        :p_tipo_transaccion=>nombre,
                        :p_prestamo=>prestamo.numero.to_s,
                        :p_reestructurado=>prestamo.reestructurado,
                        :p_transaccion_id=>0
                      }
             execute_sp('registro_contable', params.values_at(
                          :p_transaccion_contable_id,
                          :p_modalidad,
                          :p_fuente_recursos_id,
                          :p_programa_id,
                          :p_estatus,
                          :p_entidad_financiera_id,
                          :p_monto_pago,
                          :p_monto_ingreso_intereses,
                          :p_monto_por_cobrar_intereses,
                          :p_remanente_por_aplicar,
                          :p_monto_capital_cuota,
                          :p_ingreso_mora,
                          :p_remanente_por_aplicar_inicial,
                          :p_monto_comision_intereses,
                          :p_interes_diferido,
                          :p_monto_gasto,
                          :p_monto_sras,
                          :p_monto_excedente,
                          :p_monto_desembolso,
                          :p_fecha_registro,
                          :p_fecha_comprobante,
                          :p_prestamo_id,
                          :p_factura_id,
                          :p_anio,
                          :p_voucher,
                          :p_banco,
                          :p_nombre,
                          :p_tipo_transaccion,
                          :p_prestamo,
                          :p_reestructurado,
                          :p_transaccion_id))

            end

          end

        end

        rescue Exception=>error

          logger.info "Error de proceso ====> " << error.message
          logger.info "Backtrace error  ====> " << error.backtrace.join("\n")

    end

  end

  def self.contabilizar_devengos(tipo,year,mes)

     logger.info "ENTRANDO A LA CONTABILIZACION DE LOS DEVENGOS =====> " << tipo.to_s
    # Contabilización de los devengos según el origen (Diferidos o Amortización)

   if tipo == 'C'

      logger.info "ENTRANDO POR TIPO = 'C' =====> "

      sql_detalle = "select prestamo.id as prestamo_id, prestamo.numero as prestamo, prestamo.codigo_contable as codigo, prestamo.estatus as estatus, "
      sql_detalle += " plan_pago_cuota.fecha_ord_devengado as fecha, plan_pago_cuota.interes_ord_devengado_mes as monto, plan_pago_cuota.interes_dif_devengado_mes as monto_dif from plan_pago_cuota"
      sql_detalle += " inner join plan_pago on plan_pago_cuota.plan_pago_id = plan_pago.id"
      sql_detalle += " inner join prestamo on plan_pago.prestamo_id = prestamo.id"
      sql_detalle += " where plan_pago_cuota.tipo_cuota in ('C')"
      sql_detalle += " and extract(year from fecha_ord_devengado) = #{year}"
      sql_detalle += " and extract(month from fecha_ord_devengado) = #{mes}"

        logger.info "SALIENDO DEL  TIPO = 'C' =====> "
        logger.info "SQL DETALLE (IF) =====> " << sql_detalle.to_s

    elsif tipo == 'G'

      sql_detalle = "select prestamo.id as prestamo_id, prestamo.numero as prestamo, prestamo.codigo_contable as codigo, prestamo.estatus as estatus, "
      sql_detalle += " plan_pago_cuota.fecha_ord_devengado as fecha, plan_pago_cuota.interes_ord_devengado_mes as monto, plan_pago_cuota.interes_dif_devengado_mes as monto_dif from plan_pago_cuota"
      sql_detalle += " inner join plan_pago on plan_pago_cuota.plan_pago_id = plan_pago.id"
      sql_detalle += " inner join prestamo on plan_pago.prestamo_id = prestamo.id"
      sql_detalle += " where plan_pago_cuota.tipo_cuota = 'G'"
      sql_detalle += " and extract(year from fecha_ord_devengado) = #{year}"
      sql_detalle += " and extract(month from fecha_ord_devengado) =  #{mes}"

    end

    logger.info "SQL DETALLE =====> " << sql_detalle.to_s

    @devengos = DevengoMensual.find_by_sql(sql_detalle)

    logger.info "@DEVENGOS  ======> " << @devengos.inspect

    @tipo = tipo

    self.contabilizacion_devengos(@devengos, @tipo)

  end

  def self.verificar_devengos?(tipo,year,mes)

     logger.info "ENTRANDO A LA verificación DE LOS DEVENGOS =====> " << tipo.to_s
    # Contabilización de los devengos según el origen (Gracia o Amortización)

   if tipo == 'C'

      logger.info "ENTRANDO POR TIPO = 'C' =====> "

      sql_detalle = "select prestamo.id as prestamo_id, prestamo.numero as prestamo, prestamo.codigo_contable as codigo, prestamo.estatus as estatus, "
      sql_detalle += " plan_pago_cuota.fecha_ord_devengado as fecha, plan_pago_cuota.interes_ord_devengado_mes as monto, plan_pago_cuota.interes_dif_devengado_mes as monto_dif from plan_pago_cuota"
      sql_detalle += " inner join plan_pago on plan_pago_cuota.plan_pago_id = plan_pago.id"
      sql_detalle += " inner join prestamo on plan_pago.prestamo_id = prestamo.id"
      sql_detalle += " where plan_pago_cuota.tipo_cuota in ('G','C')"
      sql_detalle += " and extract(year from fecha_ord_devengado) = #{year}"
      sql_detalle += " and extract(month from fecha_ord_devengado) = #{mes}"

        logger.info "SALIENDO DEL  TIPO = 'C' =====> "
        logger.info "SQL DETALLE (IF) =====> " << sql_detalle.to_s


    elsif tipo == 'G'

      sql_detalle = "select prestamo.id as prestamo_id, prestamo.numero as prestamo, prestamo.codigo_contable as codigo, prestamo.estatus as estatus,"
      sql_detalle += " plan_pago_cuota.fecha_ord_devengado as fecha, plan_pago_cuota.interes_ord_devengado_mes as monto, plan_pago_cuota.interes_dif_devengado_mes as monto_dif from plan_pago_cuota"
      sql_detalle += " inner join plan_pago on plan_pago_cuota.plan_pago_id = plan_pago.id"
      sql_detalle += " inner join prestamo on plan_pago.prestamo_id = prestamo.id"
      sql_detalle += " where plan_pago_cuota.tipo_cuota = 'G'"
      sql_detalle += " and extract(year from fecha_ord_devengado) = #{year}"
      sql_detalle += " and extract(month from fecha_ord_devengado) =  #{mes}"

    end

    logger.info "SQL DETALLE =====> " << sql_detalle.to_s

    @devengos = DevengoMensual.find_by_sql(sql_detalle)

    if @devengos.length > 0
      return true
    else
      return false
    end



  end

end



# == Schema Information
#
# Table name: plan_pago_cuota
#
#  id                               :integer         not null, primary key
#  plan_pago_id                     :integer         not null
#  fecha                            :date
#  numero                           :integer(2)      default(1)
#  valor_cuota                      :decimal(16, 2)  default(0.0)
#  amortizado                       :decimal(16, 2)  default(0.0)
#  amortizado_acumulado             :decimal(16, 2)  default(0.0)
#  interes_corriente                :decimal(16, 2)  default(0.0)
#  interes_corriente_acumulado      :decimal(16, 2)  default(0.0)
#  interes_diferido                 :decimal(16, 2)  default(0.0)
#  interes_mora                     :decimal(16, 2)  default(0.0)
#  saldo_insoluto                   :decimal(16, 2)  default(0.0)
#  tasa_periodo                     :float           default(0.0)
#  tipo_cuota                       :string(1)
#  vencida                          :boolean         default(FALSE)
#  estatus_pago                     :string(1)       default("X")
#  fecha_ultimo_pago                :date
#  pago_interes_mora                :decimal(16, 2)  default(0.0)
#  pago_interes_corriente           :decimal(16, 2)  default(0.0)
#  pago_interes_diferido            :decimal(16, 2)  default(0.0)
#  pago_interes_corriente_acumulado :decimal(16, 2)  default(0.0)
#  pago_capital                     :decimal(16, 2)  default(0.0)
#  remanente_por_aplicar            :decimal(16, 2)  default(0.0)
#  causado_no_devengado             :decimal(16, 2)  default(0.0)
#  desembolso                       :boolean         default(FALSE)
#  cambio_tasa                      :boolean         default(FALSE)
#  abono_extraordinario             :boolean         default(FALSE)
#  monto_desembolso                 :decimal(16, 2)  default(0.0)
#  monto_abono                      :decimal(16, 2)  default(0.0)
#  dias_mora                        :integer(2)      default(0)
#  tasa_nominal_anual               :float           default(0.0)
#  interes_desembolso               :decimal(16, 2)  default(0.0)
#  cantidad_dias                    :integer(2)      default(0)
#  pago_interes_desembolso          :decimal(16, 2)  default(0.0)
#  cancelacion_prestamo             :boolean         default(FALSE)
#  reclasificada                    :boolean         default(FALSE)
#  intereses_por_cobrar_al_30       :decimal(16, 2)  default(0.0)
#  mora_exonerada                   :decimal(16, 2)  default(0.0)
#  migrado_d3                       :boolean         default(FALSE)
#  bolivar_fuerte                   :boolean
#  fecha_ultima_mora                :date            default(Mon, 01 Jan 1900)
#  interes_ord_devengado_mes        :decimal(16, 2)  default(0.0)
#  fecha_ord_devengado              :date
#  interes_ord_devengado_acum       :decimal(16, 2)  default(0.0)
#  ajuste_devengo                   :decimal(16, 2)  default(0.0)
#  pago_total_cliente               :decimal(16, 2)  default(0.0)
#  cuota_extra                      :decimal(16, 2)  default(0.0)
#  pago_cuota_extra                 :decimal(16, 2)  default(0.0)
#  interes_dif_devengado_mes        :decimal(16, 2)  default(0.0)
#

