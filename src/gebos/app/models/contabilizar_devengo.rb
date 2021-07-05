# encoding: utf-8

#
# autor: Diego Bertaso
# clase: ContabilizarDevengo
# descripción: Migrado a Rails 3
#

# To change this template, choose Tools | Templates
# and open the template in the editor.

class ContabilizarDevengo < DevengoMensual

  self.table_name = 'contabilizar_devengo'
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

