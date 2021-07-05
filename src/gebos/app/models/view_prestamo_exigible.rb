# encoding: utf-8

#
# autor: Diego Bertaso
# clase: EnvioCobranza
# descripción: Inclusión y Migración a Rails 3

class ViewPrestamoExigible < ActiveRecord::Base

  self.table_name = 'view_prestamo_exigible'
end

# == Schema Information
#
# Table name: view_prestamo_exigible
#
#  prestamo_numero       :integer(8)
#  exigible              :decimal(16, 2)
#  deuda                 :decimal(16, 2)
#  entidad_financiera_id :integer
#  numero_cuenta         :string(20)
#

