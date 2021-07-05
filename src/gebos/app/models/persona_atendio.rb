# encoding: utf-8

#
# autor: Diego Bertaso
# clase: TipoGasto
# creado en rails 3
#

class PersonaAtendio < ActiveRecord::Base

  self.table_name = 'persona_atendio'

  attr_accessible :id,
                  :descripcion,
                  :activo

end

# == Schema Information
#
# Table name: persona_atendio
#
#  id          :integer         not null, primary key
#  descripcion :text            not null
#  activo      :boolean         default(TRUE), not null
#

