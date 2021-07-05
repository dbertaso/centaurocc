# encoding: utf-8

#
# autor: Diego Bertaso
# clase: ViewGebosContabilidadDataload
# descripción: Migración a Rails 3
#

class ViewGebosContabilidadDataload < ActiveRecord::Base

  self.table_name = 'view_gebos_contabilidad_dataload'
  
  attr_accessible :comprobante_contable_id,
                  :fecha_registro,
                  :fecha_comprobante,
                  :fecha_envio,
                  :enviado,
                  :numero_lote_envio,
                  :total_debe,
                  :total_haber,
                  :numero_contabilidad,
                  :unidad_asiento,
                  :prestamo_id,
                  :factura_id,
                  :anio,
                  :transaccion_id,
                  :reversado,
                  :reverso,
                  :comprobante_reverso_id,
                  :comprobante_reversado_id,
                  :referencia,
                  :codigo_transaccion,
                  :comprobante_estatus,
                  :asiento_contable_id,
                  :monto,
                  :tipo,
                  :codigo_contable

end


# == Schema Information
#
# Table name: view_gebos_contabilidad_dataload
#
#  comprobante_contable_id  :integer
#  fecha_registro           :date
#  fecha_comprobante        :date
#  fecha_envio              :date
#  enviado                  :boolean
#  numero_lote_envio        :integer
#  total_debe               :float
#  total_haber              :float
#  numero_contabilidad      :integer
#  unidad_asiento           :integer
#  prestamo_id              :integer
#  factura_id               :integer
#  anio                     :integer
#  transaccion_id           :integer
#  reversado                :boolean
#  reverso                  :boolean
#  comprobante_reverso_id   :integer
#  comprobante_reversado_id :integer
#  referencia               :text
#  nombre                   :string(50)
#  comprobante_estatus      :string(1)
#  asiento_contable_id      :integer
#  monto                    :float
#  tipo                     :string(1)
#  codigo_contable          :text
#

