# encoding: utf-8

#
# 
# clase: ViewConyuge
# descripción: Migración a Rails 3
#

class ViewConyuge < ActiveRecord::Base

  self.table_name = 'view_conyuge'
  
  attr_accessible   :estado_civil_beneficiario,
                    :conyuge_cedula,
                    :conyuge_nombre_apellido,
                    :conyuge_lugar_nacimiento,
                    :conyuge_nacionalidad,
                    :conyuge_profesion,
                    :conyuge_oficio,
                    :conyuge_direccion_trabajo,
                    :conyuge_telefono,
                    :conyuge_celular,
                    :conyuge_empresa,
                    :solicitud_id

end


# == Schema Information
#
# Table name: view_conyuge
#
#  estado_civil_beneficiario :string(1)
#  conyuge_cedula            :text
#  conyuge_nombre_apellido   :string(100)
#  conyuge_lugar_nacimiento  :string(50)
#  conyuge_nacionalidad      :string(50)
#  conyuge_profesion         :string(50)
#  conyuge_oficio            :string(50)
#  conyuge_direccion_trabajo :string(250)
#  conyuge_telefono          :string(16)
#  conyuge_celular           :string(25)
#  conyuge_empresa           :string(100)
#  solicitud_id              :integer
#

