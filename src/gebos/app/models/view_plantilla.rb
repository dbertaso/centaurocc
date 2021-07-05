# encoding: utf-8

#
# 
# clase: ViewPlantilla
# descripción: Migración a Rails 3
#
class ViewPlantilla < ActiveRecord::Base

  self.table_name = 'view_plantilla'
  
  attr_accessible :id,:solicitud_id
end


# == Schema Information
#
# Table name: view_plantilla
#
#  id           :integer
#  solicitud_id :integer
#

