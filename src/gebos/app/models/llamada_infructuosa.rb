# encoding: utf-8

#
# autor: Diego Bertaso
# clase: LlamadaInfructuosa
# creado con Rails 3
#
class LlamadaInfructuosa < ActiveRecord::Base

  self.table_name = 'llamada_infructuosa'

  attr_accessible :id,
                  :descripcion,
                  :activo

end

# == Schema Information
#
# Table name: llamada_infructuosa
#
#  id          :integer         not null, primary key
#  descripcion :text            not null
#  activo      :boolean         default(TRUE), not null
#

