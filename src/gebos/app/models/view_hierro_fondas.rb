# encoding: utf-8

#
# 
# clase: ViewHierroFondas
# descripción: Migración a Rails 3
#

class ViewHierroFondas < ActiveRecord::Base

  self.table_name = 'view_hierro_fondas'
  
  attr_accessible   :nombre_registro_hierro,
                    :ciudad_hierro,
                    :estado_hierro,
                    :municipio_hierro,
                    :fecha_registro_hierro,
                    :numero_registro_hierro,
                    :tomo_hierro,
                    :protocolo_hierro,
                    :nombre_oficina_hierro,
                    :oficina_id

end


# == Schema Information
#
# Table name: view_hierro_fondas
#
#  nombre_registro_hierro :string(100)
#  ciudad_hierro          :string(40)
#  estado_hierro          :string(40)
#  municipio_hierro       :string(40)
#  fecha_registro_hierro  :text
#  numero_registro_hierro :string(100)
#  tomo_hierro            :integer
#  protocolo_hierro       :string(100)
#  nombre_oficina_hierro  :string(80)
#  oficina_id             :integer
#

