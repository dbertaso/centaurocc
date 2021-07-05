# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Acta
# descripción: Migración a Rails 3
#

class Acta < ActiveRecord::Base

	self.table_name = 'acta'
  
  attr_accessible :tipo_acta,
                  :contenido
  
end


# == Schema Information
#
# Table name: acta
#
#  id        :integer         not null
#  tipo_acta :string(25)
#  contenido :text
#

