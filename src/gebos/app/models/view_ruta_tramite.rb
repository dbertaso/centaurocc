# encoding: utf-8

#
# autor: Diego Bertaso
# clase: ViewRutaTramite
# descripción: Migración a Rails 3
#
class ViewRutaTramite < ActiveRecord::Base

  self.table_name = 'view_ruta_tramite'

  attr_accessible :ruta
  
end

# == Schema Information
#
# Table name: view_ruta_tramite
#
#  nombre :string(250)
#  ruta   :string(250)
#

