# encoding: utf-8

#
#
# clase: ReestructuracionDetalle
# autor: Diego Bertaso
# descripción: Migración a Rails 3
#
class ReestructuracionDetalle < ActiveRecord::Base

  self.table_name = 'reestructuracion_detalle'
  
  attr_accessible :id,
                  :reestructuracion_id,
                  :solicitud_nueva_id,
                  :solicitud_origen_id
                
  belongs_to :reestructuracion

# == Schema Information
#
# Table name: reestructuracion_detalle
#
#  id                  :integer         not null, primary key
#  reestructuracion_id :integer
#  solicitud_nueva_id  :integer
#  solicitud_origen_id :integer
#

end