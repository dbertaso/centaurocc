# encoding: utf-8

#
# autor: Diego Bertaso
# clase: GebosContabilidadDataload
# descripción: Migración a Rails 3
#

class GebosContabilidadDataload < ActiveRecord::Base


  self.table_name = 'gebos_contabilidad_dataload'
  
  attr_accessible   :id,
                    :usuario_id,
                    :tipo_movimiento,
                    :nombre_archivo,
                    :numero_filas,
                    :ruta_archivo,
                    :fecha_creacion

end
                  
# == Schema Information
#
# Table name: gebos_contabilidad_dataload
#
#  id              :integer         not null, primary key
#  usuario_id      :integer         not null
#  tipo_movimiento :string(255)
#  nombre_archivo  :string(255)
#  numero_filas    :integer
#  ruta_archivo    :string(255)
#  fecha_creacion  :datetime        default(2012-02-06 16:22:10 UTC)
#

