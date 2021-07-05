# encoding: utf-8

#
# autor: Diego Bertaso
# clase: MiembroComite
# descripción: Migración a Rails 3
#

class ComiteMiembro < ActiveRecord::Base
  
  self.table_name = 'comite_miembro'
  
  attr_accessible :id,
                  :miembro_comite_id,
                  :comite_id,
                  :fecha_ingreso,
                  :firma,
                  :rol_comite_id
  
  has_one :miembro_comite
end

# == Schema Information
#
# Table name: comite_miembro
#
#  id                :integer         not null, primary key
#  miembro_comite_id :integer         not null
#  comite_id         :integer         not null
#  fecha_ingreso     :date            not null
#  firma             :boolean
#  rol_comite_id     :integer
#

