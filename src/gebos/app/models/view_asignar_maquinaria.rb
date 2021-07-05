# encoding: utf-8

#
# autor: Marvin Alfonzo
# clase: ViewAsignarMaquinaria
# descripción: Migración a Rails 3
#

class ViewAsignarMaquinaria < ActiveRecord::Base

  self.table_name = 'view_asignar_maquinaria'

  attr_accessible   :solicitud_id,
                    :numero,
                    :beneficiario,
                    :cedula_rif,
                    :estatus,
                    :estado,
                    :municipio,
                    :parroquia,
                    :unidad_produccion,
                    :municipio_id,
                    :estado_id,
                    :parroquia_id

  def self.search(search, page, orden)        
    paginate :per_page=>@records_by_page, :page=>page, :conditions=>search, :order=>orden
  end

end

# == Schema Information
#
# Table name: view_asignar_maquinaria
#
#  solicitud_id      :integer
#  numero            :integer
#  beneficiario      :text
#  cedula_rif        :text
#  estatus           :text
#  estado            :string(40)
#  municipio         :string(40)
#  parroquia         :string(40)
#  unidad_produccion :string(150)
#  municipio_id      :integer
#  estado_id         :integer
#  parroquia_id      :integer
#

