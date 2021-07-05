# encoding: utf-8

#
# 
# clase: ViewEmpresa
# descripción: Migración a Rails 3
#

class ViewEmpresa < ActiveRecord::Base
  
  self.table_name = 'view_empresa'
  
  attr_accessible   :rif,
                    :nombre_empresa,
                    :fecha_constitucion,
                    :fecha_inicio_operaciones,
                    :capital_suscrito,
                    :capital_pagado,
                    :numero_patente,
                    :numero_sunacop,
                    :producto,
                    :nro_registro_mercantil,
                    :nro_folio_inicial,
                    :nro_folio_final,
                    :nro_protocolo,
                    :nro_tomo,
                    :nro_trimestre,
                    :nit,
                    :estado_registro,
                    :municipio_registro,
                    :parroquia_registro,
                    :solicitud_id  

end



# == Schema Information
#
# Table name: view_empresa
#
#  rif                      :string(15)
#  nombre_empresa           :string(255)
#  fecha_constitucion       :text
#  fecha_inicio_operaciones :text
#  capital_suscrito         :float
#  capital_pagado           :float
#  numero_patente           :string(15)
#  numero_sunacop           :string(15)
#  producto                 :string(500)
#  nro_registro_mercantil   :string(20)
#  nro_folio_inicial        :string(10)
#  nro_folio_final          :string(10)
#  nro_protocolo            :string(10)
#  nro_tomo                 :string(10)
#  nro_trimestre            :string(2)
#  nit                      :string(15)
#  estado_registro          :string(40)
#  municipio_registro       :string(40)
#  parroquia_registro       :string(40)
#  solicitud_id             :integer
#

