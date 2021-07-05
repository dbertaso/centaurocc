# encoding: utf-8

#
# 
# clase: ComiteDecisionHistorico
# descripción: Migración a Rails 3
#

class ComiteDecisionHistorico < ActiveRecord::Base

  self.table_name = 'comite_decision_historico'

  attr_accessible :id,
                  :decision,
                  :comite_id,
                  :solicitud_id,
                  :fecha_decision,
                  :oficina_id ,
                  :tipo_comite,
                  :comentario
  
  
  belongs_to :comite
  belongs_to :solicitud
  belongs_to :ciudad
  belongs_to :comite_decision_historico
  
  
  #search para solicitud en el caso que se quiera agregar a la busqueda selects o joins
  def self.search_especial(search, page, orden, select, from, joins)    
    paginate :per_page=>@records_by_page, :page=>page, :conditions=>search,:select=>select, :from=>from,:joins=>joins, :order=>orden, :include => [:solicitud,:oficina,:ciudad,:estado,:rubro,:sector,:sub_sector]
  end
  
end

# == Schema Information
#
# Table name: comite_decision_historico
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

# == Schema Information
#
# Table name: comite_decision_historico
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

