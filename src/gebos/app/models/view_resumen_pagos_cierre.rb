# encoding: utf-8

#
# autor: Diego Bertaso
# clase: ViewResumenPagosCierre
# descripción: Migración a Rails 3
#

class ViewResumenPagosCierre < ActiveRecord::Base


  self.table_name = 'view_resumen_pagos_cierre'
  
  attr_accessible :id,
                  :fecha_contable,
                  :tipo_aplicacion,
                  :analista,
                  :beneficiario,
                  :cedula_rif,
                  :fecha,
                  :banco,
                  :numero_documento,
                  :codigo_contable,
                  :monto,
                  :capital,
                  :intereses_ordinarios,
                  :intereses_diferidos,
                  :intereses_mora,
                  :saldo_a_favor,
                  :interes_causado,
                  :sector_economico,
                  :estatus_contabilidad,
                  :estado,
                  :banco_origen,
                  :abono_capital

end


# == Schema Information
#
# Table name: view_resumen_pagos_cierre
#
#  id                   :integer
#  fecha_contable       :date
#  tipo_aplicacion      :string
#  analista             :string(50)
#  beneficiario         :string
#  cedula_rif           :string
#  fecha                :date
#  banco                :string(80)
#  numero_documento     :string(20)
#  codigo_contable      :string(6)
#  monto                :float
#  capital              :decimal(, )
#  intereses_ordinarios :decimal(, )
#  intereses_diferidos  :decimal(, )
#  intereses_mora       :decimal(, )
#  saldo_a_favor        :decimal(16, 2)
#  interes_causado      :decimal(, )
#  sector_economico     :string
#  estatus_contabilidad :string
#  estado               :string
#  banco_origen         :string(25)
#  abono_capital        :decimal(16, 2)
#

