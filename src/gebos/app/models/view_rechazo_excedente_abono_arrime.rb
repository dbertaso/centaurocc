# encoding: utf-8
# 
# autor: Luis Rojas
# clase: ViewRechazoExcedenteAbonoArrime
# descripción: Migración a Rails 3

class ViewRechazoExcedenteAbonoArrime < ActiveRecord::Base
  
  self.table_name = 'view_rechazo_excedente_abono_arrime'

  def self.search(search, page, orden)    
    paginate :per_page=>@records_by_page, :page=>page, :conditions=>search, :order=>orden
  end
  
end
# == Schema Information
#
# Table name: view_rechazo_excedente_abono_arrime
#
#  id                    :integer
#  fecha                 :date
#  archivo               :string(100)
#  prestamo_numero       :integer(8)
#  solicitud_numero      :integer(8)
#  identificacion        :text
#  nombre                :text
#  monto_pago            :decimal(, )
#  descripcion_error     :string(255)
#  entidad_financiera_id :integer
#  nombre_entidad        :string(80)
#  procesado             :boolean
#

