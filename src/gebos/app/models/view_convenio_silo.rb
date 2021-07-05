# encoding: utf-8
class ViewConvenioSilo < ActiveRecord::Base

  self.table_name = 'view_convenio_silo'
  
  attr_accessible :silo_id, 
	:convenio, 
	:convenio_silo_id, 
	:status, 
	:detalle_convenio_silo_id, 
	:actividad_id, 
	:tipo_clase, 
	:valor 

 

end




# == Schema Information
#
# Table name: view_convenio_silo
#
#  silo_id                  :integer
#  convenio                 :boolean
#  convenio_silo_id         :integer
#  status                   :boolean
#  detalle_convenio_silo_id :integer
#  actividad_id             :integer
#  tipo_clase               :string(1)
#  valor                    :decimal(16, 2)
#

