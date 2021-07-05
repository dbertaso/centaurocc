# encoding: utf-8

#
# autor: Diego Bertaso
# clase: TipoGasto
# creado en rails 3
#
class TipoGestionCobranzas < ActiveRecord::Base

  self.table_name = 'tipo_gestion_cobranza'

  attr_accessible :id,
                  :descripcion,
                  :activo

end

# == Schema Information
#
# Table name: tipo_gestion_cobranza
#
#  id          :integer         not null, primary key
#  descripcion :text            not null
#  activo      :boolean         default(TRUE), not null
#

