# encoding: utf-8

#
# 
# clase: ViewRegistroNaval
# descripción: Migración a Rails 3
#

class ViewRegistroNaval < ActiveRecord::Base

  self.table_name = 'view_registro_naval'
  
  attr_accessible   :fecha_registro_naval,
                    :numero_registro_naval,
                    :nro_tomo_registro_naval,
                    :nro_protocolo_registro_naval,
                    :nombre_registro_naval,
                    :municipio_registro_naval,
                    :estado_registro_naval,
                    :matricula,
                    :nombre_embarcacion,
                    :solicitud_id

  

end


# == Schema Information
#
# Table name: view_registro_naval
#
#  fecha_registro_naval         :text
#  numero_registro_naval        :string(20)
#  nro_tomo_registro_naval      :string(20)
#  nro_protocolo_registro_naval :string(20)
#  nombre_registro_naval        :string(80)
#  municipio_registro_naval     :string(40)
#  estado_registro_naval        :string(40)
#  matricula                    :string(20)
#  nombre_embarcacion           :string(120)
#  solicitud_id                 :integer
#

