# encoding: utf-8

#
# autor: Diego Bertaso
# clase: ControlCierre
# descripción: Migración a Rails 3

class ControlCierre < ActiveRecord::Base
  
  self.table_name = 'control_cierre'

  attr_accessible :id,
                  :fecha_proceso,
                  :senal_enproceso,
                  :fecha_ejecucion,
                  :senal_cerrado,
                  :senal_shell,
                  :ultimo_prestamo


end

# == Schema Information
#
# Table name: control_cierre
#
#  id              :integer         not null, primary key
#  fecha_proceso   :date            default(Mon, 01 Jan 1900)
#  senal_enproceso :boolean         default(FALSE), not null
#  fecha_ejecucion :date            default(Mon, 01 Jan 1900), not null
#  senal_cerrado   :boolean         default(FALSE), not null
#  senal_shell     :boolean         default(TRUE), not null
#  ultimo_prestamo :integer
#

