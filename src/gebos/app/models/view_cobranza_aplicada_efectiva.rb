# encoding: utf-8

class ViewCobranzaAplicadaEfectiva < ActiveRecord::Base


  self.table_name = 'view_cobranza_aplicada_efectiva'

  attr_accessible :pago_cliente_id,
    :modalidad,
    :cliente_id,
    :numero_voucher,
    :entidad_financiera_id,
    :numero_prestamo,
    :pago_prestamo_id,
    :fecha_valor,
    :fecha_contable,
    :monto,
    :saldo_favor,
    :abono_capital,
    :interes_corriente,
    :interes_diferido,
    :interes_mora,
    :capital,
    :numero_solicitud,
    :entidad_financiera,
    :numero_cuenta,
    :cedula_rif,
    :nombre_cliente,
    :moneda




end


# == Schema Information
#
# Table name: view_cobranza_aplicada_efectiva
#
#  pago_cliente_id       :integer
#  modalidad             :string(1)
#  cliente_id            :integer
#  numero_voucher        :string(20)
#  entidad_financiera_id :integer
#  numero_prestamo       :integer(8)
#  pago_prestamo_id      :integer
#  fecha_valor           :date
#  fecha_contable        :date
#  monto                 :float
#  saldo_favor           :float
#  abono_capital         :float
#  interes_corriente     :float
#  interes_diferido      :float
#  interes_mora          :float
#  capital               :float
#  numero_solicitud      :integer
#  entidad_financiera    :string(20)
#  numero_cuenta         :string(20)
#  cedula_rif            :string
#  nombre_cliente        :string
#  moneda                :string(5)
#

