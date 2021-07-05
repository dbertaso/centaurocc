# encoding: utf-8
class ViewBandejaArrime< ActiveRecord::Base

  self.table_name = 'view_bandeja_arrime'
  
  attr_accessible   :id, 
    :numero_ticket, 
    :guia_movilizacion, 
    :silo_id, 
    :nombre_silo, 
    :estatus, 
    :numero_tramite, 
    :cliente_id, 
    :valor_arrime, 
    :arrime_conjunto, 
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
# Table name: view_bandeja_arrime
#
#  id                  :integer
#  numero_ticket       :string(15)
#  guia_movilizacion   :string(20)
#  silo_id             :integer
#  nombre_silo         :string(45)
#  estatus             :string(1)
#  numero_tramite      :integer
#  cliente_id          :integer
#  valor_arrime        :decimal(16, 2)
#  arrime_conjunto     :boolean
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

