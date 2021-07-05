# encoding: utf-8

#
# 
# clase: ViewHierroBeneficiario
# descripción: Migración a Rails 3
#

class ViewHierroBeneficiario < ActiveRecord::Base

  self.table_name = 'view_hierro_beneficiario'
  
  attr_accessible   :fecha_registro_hierro_beneficiario,
                    :numero_registro_hierro_beneficiario,
                    :nro_tomo_hierro_beneficiario,
                    :nro_protocolo_hierro_beneficiario,
                    :nombre_registro_hierro_beneficiario,
                    :municipio_registro_hierro_beneficiario,
                    :estado_registro_hierro_beneficiario,
                    :solicitud_id

end


# == Schema Information
#
# Table name: view_hierro_beneficiario
#
#  fecha_registro_hierro_beneficiario     :text
#  numero_registro_hierro_beneficiario    :string(20)
#  nro_tomo_hierro_beneficiario           :string(20)
#  nro_protocolo_hierro_beneficiario      :string(20)
#  nombre_registro_hierro_beneficiario    :string(80)
#  municipio_registro_hierro_beneficiario :string(40)
#  estado_registro_hierro_beneficiario    :string(40)
#  solicitud_id                           :integer
#

