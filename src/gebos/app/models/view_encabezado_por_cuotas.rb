
# encoding: utf-8

#
# autor: Diego Bertaso
# clase: ViewEncabezadoPorCuotas
# descripción: Inclusión y Migración a Rails 3

class ViewEncabezadoPorCuotas < ActiveRecord::Base

  self.table_name = 'view_encabezado_por_cuotas'
  
end

# == Schema Information
#
# Table name: view_encabezado_por_cuotas
#
#  cantidad_cuota        :integer(8)
#  total_cuota           :decimal(, )
#  entidad_financiera_id :integer
#  cuenta_matriz         :string(20)
#

