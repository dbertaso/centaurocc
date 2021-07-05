

# encoding: utf-8

#
# autor: Diego Bertaso
# clase: ViewEncabezadoPorExigible
# descripción: Inclusión y Migración a Rails 3

class ViewEncabezadoPorExigible < ActiveRecord::Base

  self.table_name = 'view_encabezado_por_exigible'
end

# == Schema Information
#
# Table name: view_encabezado_por_exigible
#
#  cantidad_cuota        :integer(8)
#  total_cuota           :decimal(, )
#  monto_cuota           :decimal(, )
#  entidad_financiera_id :integer
#  cuenta_matriz         :string
#

