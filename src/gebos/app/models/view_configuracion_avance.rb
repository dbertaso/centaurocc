# encoding: utf-8

#
# autor: Diego Bertaso
# clase: ViewConfiguracionAvance
# descripción: Build in Rails 3

class ViewConfiguracionAvance < ActiveRecord::Base

  self.table_name = 'view_configuracion_avance'

  attr_accessible :id,
                  :estatus_origen_id,
                  :estatus_origen_nombre,
                  :estatus_destino_id,
                  :estatus_destino_nombre,
                  :programa_id,
                  :programa_nombre,
                  :ruta_primaria,
                  :condicionado


  def self.search(search, page, sort)

    paginate :per_page => @records_by_page, :page => page,
             :conditions => search, :order => sort
  end
end

# == Schema Information
#
# Table name: view_configuracion_avance
#
#  id                     :integer
#  estatus_origen_id      :integer
#  estatus_origen_nombre  :text
#  estatus_destino_id     :integer
#  estatus_destino_nombre :text
#  programa_id            :integer
#  programa_nombre        :string(255)
#  ruta_primaria          :text
#  condicionado           :boolean
#

