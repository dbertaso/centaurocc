# encoding: utf-8

#
# 
# clase: CodigoContable
# descripción: Migración a Rails 3
#

class CodigoContable < ActiveRecord::Base

  self.table_name = 'codigo_contable'

  attr_accessible :id,
                  :nombre,
                  :codigo

   validates_presence_of :nombre, :codigo,
    :message => " es requerido"
  
   validates_uniqueness_of :nombre, :codigo,
    :message => " ya existe"
  
end

# == Schema Information
#
# Table name: codigo_contable
#
#  id     :integer         not null, primary key
#  nombre :string(100)     not null
#  codigo :string(20)      not null
#

