# encoding: utf-8
# 
# autor: Luis Rojas
# clase: ViewRechazoLiquidacion
# descripción: Migración a Rails 3

class ViewRechazoLiquidacion < ActiveRecord::Base
  
  self.table_name = 'view_rechazo_liquidacion'

  def self.search(search, page, orden)    
    paginate :per_page=>@records_by_page, :page=>page, :conditions=>search, :order=>orden
  end
  
end
# == Schema Information
#
# Table name: view_rechazo_liquidacion
#
#  id                    :integer
#  fecha                 :date
#  archivo               :string(100)
#  prestamo_numero       :integer(8)
#  solicitud_numero      :integer(8)
#  identificacion        :string
#  nombre                :string
#  monto_pago            :decimal(, )
#  descripcion_error     :string(255)
#  entidad_financiera_id :integer
#  nombre_entidad        :string(80)
#  procesado             :boolean
#  moneda_id             :integer
#  moneda_nombre         :text
#  abreviatura           :string(5)
#

