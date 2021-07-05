# encoding: utf-8

#
# autor: Diego Bertaso
# clase: ViewResumenDesembolsosCierre
# descripción: Migración a Rails 3
#


class ViewResumenDesembolsosCierre < ActiveRecord::Base

  self.table_name = 'view_resumen_desembolsos_cierre'
  
  attr_accessible :id,
                  :fecha,
                  :cedula_rif,
                  :beneficiario,
                  :monto,
                  :numero_referencia,
                  :entidad_financiera,
                  :banco_origen

end

# == Schema Information
#
# Table name: view_resumen_desembolsos_cierre
#
#  id                 :integer
#  fecha              :date
#  cedula_rif         :string
#  beneficiario       :string
#  monto              :float
#  numero_referencia  :string(30)
#  entidad_financiera :string(80)
#  banco_origen       :string(25)
#

