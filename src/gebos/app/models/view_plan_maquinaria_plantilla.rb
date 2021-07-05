# encoding: utf-8

#
# 
# clase: ViewPlanMaquinariaPlantilla
# descripción: Migración a Rails 3
#

class ViewPlanMaquinariaPlantilla < ActiveRecord::Base

  self.table_name = 'view_plan_maquinaria_plantilla'
  
  attr_accessible :marca_maquinaria,:clase_maquinaria,:modelo_maquinaria,:serial,:chasis,:solicitud_id,:id

end


# == Schema Information
#
# Table name: view_plan_maquinaria_plantilla
#
#  marca_maquinaria  :string
#  clase_maquinaria  :string(100)
#  modelo_maquinaria :string
#  serial            :string(30)
#  chasis            :string(30)
#  solicitud_id      :integer
#  id                :integer
#

