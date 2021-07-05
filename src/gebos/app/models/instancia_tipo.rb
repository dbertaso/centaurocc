# encoding: utf-8

#
# autor: 
# clase: InstanciaTipo
# descripción: Migración a Rails 3
#

class InstanciaTipo < ActiveRecord::Base

  self.table_name = 'instancia_tipo'
  
  attr_accessible :id,
                  :nombre,
                  :estatus_id

  has_many :comite

end

# == Schema Information
#
# Table name: instancia_tipo
#
#  id         :integer         not null, primary key
#  nombre     :string(20)
#  estatus_id :integer(8)      default(1)
#

