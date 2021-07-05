# encoding: utf-8

#
# autor: Marvin Alfonzo
# clase: Etiquetas
# descripción: Migración a Rails 3
#

class Etiquetas < ActiveRecord::Base
  
  self.table_name = 'etiquetas'

  attr_accessible :id, :descripcion, :etiqueta
  
  def self.etiqueta (id)
    a = self.find(id)
    a.etiqueta
  end

end

# == Schema Information
#
# Table name: etiquetas
#
#  id          :integer         not null, primary key
#  descripcion :string(255)     not null
#  etiqueta    :string(100)     not null
#

