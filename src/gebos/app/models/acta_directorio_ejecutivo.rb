# encoding: utf-8

#
# autor: Diego Bertaso
# clase: ActaDirectorioEjecutivo
# descripción: Migración a Rails 3
#

class ActaDirectorioEjecutivo < ActiveRecord::Base

  self.table_name = 'acta_directorio_ejecutivo'
  
  attr_accessible :acta_directorio_ejecutivo_id,
                  :base1,
                  :base2,
                  :base3
  
end


# == Schema Information
#
# Table name: acta_directorio_ejecutivo
#
#  acta_directorio_ejecutivo_id :integer(8)      not null, primary key
#  base1                        :text
#  base2                        :text
#  base3                        :text
#  id                           :integer         not null
#

