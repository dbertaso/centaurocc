# encoding: utf-8

#
# 
# clase: ViewPlanInversionPlantilla
# descripción: Migración a Rails 3
#

class ViewPlanInversionPlantilla < ActiveRecord::Base

  self.table_name = 'view_plan_inversion_plantilla'
  
  attr_accessible   :nombre_partida,
                    :nombre,
                    :cant,
                    :abrev,
                    :monto_financiamiento,
                    :solicitud_id

end


# == Schema Information
#
# Table name: view_plan_inversion_plantilla
#
#  nombre_partida       :string(100)
#  nombre               :string(100)
#  cant                 :decimal(16, 3)
#  abrev                :string(10)
#  monto_financiamiento :decimal(16, 2)
#  solicitud_id         :integer
#

