# encoding: utf-8

#
# 
# clase: ViewPlanInversionPesca
# descripción: Migración a Rails 3
#

class ViewPlanInversionPesca < ActiveRecord::Base

  self.table_name = 'view_plan_inversion_pesca'
  
  attr_accessible :solicitud_id,:manga,:eslora,:puntal,:nombre_embarcacion,:modelo_motor,:tipo_material,:numero_serial,:tipo_motor,:cantidad_motores,:es_propia

end



# == Schema Information
#
# Table name: view_plan_inversion_pesca
#
#  solicitud_id       :integer
#  manga              :decimal(16, 2)
#  eslora             :decimal(16, 2)
#  puntal             :decimal(16, 2)
#  nombre_embarcacion :string(120)
#  modelo_motor       :string(160)
#  tipo_material      :string(100)
#  numero_serial      :string(100)
#  tipo_motor         :string(100)
#  cantidad_motores   :integer
#  es_propia          :boolean
#

