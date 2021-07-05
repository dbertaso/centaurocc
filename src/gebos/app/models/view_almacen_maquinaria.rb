# encoding: utf-8

#
# 
# clase: ViewAlmacenMaquinaria
# descripción: Migración a Rails 3
#

class ViewAlmacenMaquinaria< ActiveRecord::Base

    self.table_name = 'view_almacen_maquinaria'
  
    attr_accessible :catalogo_id,
                    :serial,
                    :modelo_id,
                    :marca_maquinaria_id,
                    :almacen_maquinaria_id,
                    :clase_id,
                    :contrato_maquinaria_equipo_id,
                    :rubro_id,
                    :oficina_id,
                    :solicitud_id,
                    :guia_catalogo_id,
                    :guia_movilizacion_maquinaria_id,
                    :modelo,
                    :marca,
                    :almacen,
                    :tipo_clase,
                    :rubro,
                    :oficina,
                    :nombre_convenio




public

end


# == Schema Information
#
# Table name: view_almacen_maquinaria
#
#  catalogo_id                     :integer
#  serial                          :string(30)
#  modelo_id                       :integer
#  marca_maquinaria_id             :integer
#  almacen_maquinaria_id           :integer
#  clase_id                        :integer
#  contrato_maquinaria_equipo_id   :integer
#  rubro_id                        :integer
#  oficina_id                      :integer
#  solicitud_id                    :integer
#  guia_catalogo_id                :integer
#  guia_movilizacion_maquinaria_id :integer
#  modelo                          :string(100)
#  marca                           :string(100)
#  almacen                         :string(60)
#  tipo_clase                      :string(100)
#  rubro                           :string(100)
#  oficina                         :string(80)
#  nombre_convenio                 :string(255)
#


