# encoding: utf-8

#
# autor: Luis Rojas
# clase: CondicionamientosNarrativaLibre
# descripción: Migración a Rails 3
#
class CondicionamientosNarrativaLibre < ActiveRecord::Base
  
  self.table_name = 'condicionamientos_narrativa_libre'
  
  attr_accessible :id, :condicionamientos_desembolso, :condicionamientos_financiamiento
  
end

# == Schema Information
#
# Table name: condicionamientos_narrativa_libre
#
#  id                               :integer         not null, primary key
#  condicionamientos_desembolso     :text
#  condicionamientos_financiamiento :text
#

