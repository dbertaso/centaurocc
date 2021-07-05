# encoding: utf-8

#
# 
# clase: ViewOficina
# descripción: Migración a Rails 3
#

class ViewOficina < ActiveRecord::Base

  self.table_name = 'view_oficina'
  
  attr_accessible   :oficina_id,
                    :oficina,
                    :municipio_oficina,
                    :ciudad_oficina,
                    :estado_oficina,
                    :representante_oficina,
                    :cedula_representante,
                    :nombre_abogado,
                    :cedula_abogado,
                    :inpreabogado,
                    :bicentenario,
                    :federacion,
                    :documento_autenticacion,
                    :tomo_autenticacion,
                    :solicitud_id

end

# == Schema Information
#
# Table name: view_oficina
#
#  oficina_id              :integer
#  oficina                 :string(80)
#  municipio_oficina       :string(40)
#  ciudad_oficina          :string(40)
#  estado_oficina          :string(40)
#  representante_oficina   :text
#  cedula_representante    :text
#  nombre_abogado          :string(100)
#  cedula_abogado          :string(10)
#  inpreabogado            :string(15)
#  bicentenario            :text
#  federacion              :text
#  documento_autenticacion :integer
#  tomo_autenticacion      :integer
#  solicitud_id            :integer
#

