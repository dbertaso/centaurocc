# encoding: utf-8
class ViewActaSilo< ActiveRecord::Base

  self.table_name = 'view_acta_silo'
 
  attr_accessible :id, 
    :nombre, 
    :rif, 
    :estado_id, 
    :acta_silo_id, 
    :actividad_id, 
    :nro_acta, 
    :status, 
    :fecha_fin, 
    :nombre_compuesto 

end




# == Schema Information
#
# Table name: view_acta_silo
#
#  id               :integer
#  nombre           :string(45)
#  rif              :string(15)
#  estado_id        :integer
#  acta_silo_id     :integer
#  actividad_id     :integer
#  nro_acta         :integer
#  status           :boolean
#  fecha_fin        :date
#  nombre_compuesto :text
#

