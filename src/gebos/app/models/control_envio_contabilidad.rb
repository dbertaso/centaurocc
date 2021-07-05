# encoding: utf-8

#
# autor: Diego Bertaso
# clase: ControlEnvioContabilidad
# descripción: Build in Rails 3

class ControlEnvioContabilidad < ActiveRecord::Base

  self.table_name = 'control_envio_contabilidad'

  attr_accessible :id,
                  :fecha_inicio,
                  :fecha_fin,
                  :file_name,
                  :total_debe,
                  :total_haber,
                  :cantidad_envio,
                  :diferencia,
                  :usuario_id,
                  :fecha_proceso

end

# == Schema Information
#
# Table name: control_envio_contabilidad
#
#  id             :integer         not null, primary key
#  fecha_inicio   :date
#  fecha_fin      :date
#  file_name      :text
#  total_debe     :decimal(16, 2)
#  total_haber    :decimal(16, 2)
#  cantidad_envio :integer
#  diferencia     :decimal(16, 2)
#  usuario_id     :integer
#  fecha_proceso  :date
#

