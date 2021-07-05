# encoding: utf-8

#
# autor: Diego Bertaso
# clase: CompromisoPagos
# creado con Rails 3
#
class GestionCobranzaObservacion < ActiveRecord::Base

  self.table_name = 'gestion_cobranza_observacion'

  attr_accessible :id,
                  :gestion_cobranza_id,
                  :observacion,
                  :activo

end

# == Schema Information
#
# Table name: gestion_cobranza_observacion
#
#  id                  :integer         not null, primary key
#  gestion_cobranza_id :integer         not null
#  observacion         :text
#  activo              :boolean         default(TRUE), not null
#

