# encoding: utf-8
class ViewBandejaOtroArrime< ActiveRecord::Base

  self.table_name = 'view_bandeja_otro_arrime'
 
  attr_accessible :id, 
    :numero_ticket,
    :guia_movilizacion,
    :silo_id,
    :nombre_silo,
    :estado_silo,
    :estatus, 
    :numero_tramite,
    :fecha_salida,
    :fecha_entrada,
    :fecha_confirmacion,
    :cliente_id,
    :monto_arrime,
    :sector_id,
    :sub_sector_id,
    :confirmacion,
    :resultado,
    :sector,
    :sub_sector,
    :sub_rubro,
    :actividad, 
    :cedula_rif, 
    :nombre_beneficiario,
    :rubro,
    :rubro_id,
    :sub_rubro_id,
    :actividad_id

  
  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
      :conditions => search, :order => sort,
      :select=>'*'
  end
  
end


# == Schema Information
#
# Table name: view_bandeja_otro_arrime
#
#  id                  :integer
#  numero_ticket       :string(15)
#  guia_movilizacion   :string(20)
#  silo_id             :integer
#  nombre_silo         :string(45)
#  estado_silo         :string(40)
#  estatus             :string(1)
#  numero_tramite      :integer
#  fecha_salida        :date
#  fecha_entrada       :date
#  fecha_confirmacion  :date
#  cliente_id          :integer
#  monto_arrime        :decimal(16, 2)
#  sector_id           :integer
#  sub_sector_id       :integer
#  confirmacion        :boolean
#  resultado           :string(30)
#  sector              :string(100)
#  sub_sector          :string(100)
#  sub_rubro           :string(100)
#  actividad           :string(150)
#  cedula_rif          :string
#  nombre_beneficiario :string
#  rubro               :string(100)
#  rubro_id            :integer
#  sub_rubro_id        :integer
#  actividad_id        :integer
#

