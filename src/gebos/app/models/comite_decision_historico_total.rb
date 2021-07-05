# encoding: utf-8

#
# autor: Diego Bertaso
# clase: ComiteDecisionHistoricoTotal
# descripción: Build in Rails 3
#


class ComiteDecisionHistoricoTotal < ActiveRecord::Base

  self.table_name = 'comite_decision_historico_total'
  
  attr_accessible :id,
                  :decision,
                  :comite_id,
                  :solicitud_id,
                  :fecha_decision,
                  :oficina_id,
                  :tipo_comite,
                  :comentario

  belongs_to :Comite
  belongs_to :Solicitud
  belongs_to :Ciudad
  belongs_to :ComiteDecisionHistorico
  
end

# == Schema Information
#
# Table name: comite_decision_historico_total
#
#  id             :integer         not null, primary key
#  decision       :string(1)
#  comite_id      :integer
#  solicitud_id   :integer
#  fecha_decision :date
#  oficina_id     :integer         not null
#  tipo_comite    :string(1)       not null
#  comentario     :text
#

