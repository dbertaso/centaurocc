
# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Cargo
# descripción: Migración a Rails 3
#

class Cargo < ActiveRecord::Base
  
  self.table_name = 'cargo'
  
  attr_accessible :id,
                  :descripcion,
                  :const_id
end

# == Schema Information
#
# Table name: cargo
#
#  id          :integer         not null, primary key
#  descripcion :string(70)      not null
#  const_id    :string(10)
#

