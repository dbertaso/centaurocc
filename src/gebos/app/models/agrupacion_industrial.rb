# encoding: utf-8
class AgrupacionIndustrial < ActiveRecord::Base

  self.table_name = 'agrupacion_industrial'

  attr_accessible :id,
                  :nombre,
                  :descripcion

  validates_presence_of :nombre, :descripcion,
    :message => " es requerido"

  validates_length_of :nombre, :within => 1..40, :allow_nil => false

  validates_length_of :descripcion, :within => 1..300, :allow_nil => false

  validates_uniqueness_of :nombre,
    :message => " ya existe"

end

# == Schema Information
#
# Table name: agrupacion_industrial
#
#  id          :integer         not null, primary key
#  nombre      :string(40)      not null
#  descripcion :string(300)     not null
#

