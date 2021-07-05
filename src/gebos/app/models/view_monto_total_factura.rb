# encoding: utf-8

#
# autor: Marvin Alfonzo
# clase: ViewMontoTotalFactura
# descripción: Migración a Rails 3
#
class ViewMontoTotalFactura < ActiveRecord::Base

    self.table_name = 'view_monto_total_factura' 
  
    attr_accessible :numero_factura,
					:orden_despacho_id,
					:monto_total_factura


end

# == Schema Information
#
# Table name: view_monto_total_factura
#
#  numero_factura      :string(20)
#  orden_despacho_id   :integer
#  monto_total_factura :decimal(, )
#

