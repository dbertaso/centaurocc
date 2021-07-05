# encoding: utf-8

#
# 
# clase: ViewDatosMaquinaria
# descripción: Migración a Rails 3
#

class ViewDatosMaquinaria < ActiveRecord::Base

    self.table_name = 'view_datos_maquinaria'
  
    attr_accessible :id,
                    :descripcion,
                    :chasis,
                    :serial,
                    :monto,
                    :pais,
                    :modelo,
                    :marca,
                    :clase,
                    :solicitud_id,
                    :guia_movilizacion_maquinaria_id



end


# == Schema Information
#
# Table name: view_datos_maquinaria
#
#  id                              :integer
#  descripcion                     :text
#  chasis                          :string(30)
#  serial                          :string(30)
#  monto                           :decimal(16, 2)
#  pais                            :string(50)
#  modelo                          :string(100)
#  marca                           :string(100)
#  clase                           :string(100)
#  solicitud_id                    :integer
#  guia_movilizacion_maquinaria_id :integer
#

