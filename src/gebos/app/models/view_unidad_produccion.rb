# encoding: utf-8

#
# 
# clase: ViewUnidadProduccion
# descripción: Migración a Rails 3
#

class ViewUnidadProduccion < ActiveRecord::Base
 
  self.table_name = 'view_unidad_produccion'
  
  attr_accessible :nombre_lote,:total_hectareas,:total_hectareas_letras,:ciudad_lote,:municipio_lote,:parroquia_lote,:estado_lote,:direccion_lote,:referencia_lote,:lindero_norte,:lindero_sur,:lindero_este,:lindero_oeste,:fecha_registro_lote,:numero_registro_lote,:nro_tomo_lote,:nro_protocolo_lote,:nombre_registro_lote,:municipio_registro_lote,:estado_registro_lote,:id_tipo_lote,:tipo_lote,:solicitud_id
 
end


# == Schema Information
#
# Table name: view_unidad_produccion
#
#  nombre_lote             :string(150)
#  total_hectareas         :float
#  total_hectareas_letras  :
#  ciudad_lote             :string(40)
#  municipio_lote          :string(40)
#  parroquia_lote          :string(40)
#  estado_lote             :string(40)
#  direccion_lote          :text
#  referencia_lote         :text
#  lindero_norte           :string(200)
#  lindero_sur             :string(200)
#  lindero_este            :string(200)
#  lindero_oeste           :string(200)
#  fecha_registro_lote     :text
#  numero_registro_lote    :string(20)
#  nro_tomo_lote           :string(20)
#  nro_protocolo_lote      :string(20)
#  nombre_registro_lote    :string(80)
#  municipio_registro_lote :string(40)
#  estado_registro_lote    :string(40)
#  id_tipo_lote            :integer
#  tipo_lote               :string(100)
#  solicitud_id            :integer
#

