# encoding: utf-8
class ViewPrecioGaceta < ActiveRecord::Base

  self.table_name = 'view_precio_gaceta'
  
  attr_accessible :id, 
    :actividad_id, 
    :tipo_clase, 
    :valor 
 

end

# == Schema Information
#
# Table name: view_precio_gaceta
#
#  id           :integer
#  actividad_id :integer
#  tipo_clase   :string(1)
#  valor        :float
#

