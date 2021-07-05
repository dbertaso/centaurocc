# encoding: utf-8

#
# autor: Diego Bertaso
# clase: GrupoIntegrante
# descripción: Migración a Rails 3
#
class GrupoIntegrante < ActiveRecord::Base

  self.table_name = 'grupo_integrante'

  attr_accessible :id,
                  :grupo_id,
                  :persona_id,
                  :lider


  belongs_to :grupo
  belongs_to :persona
  
end

# == Schema Information
#
# Table name: grupo_integrante
#
#  id         :integer         not null, primary key
#  grupo_id   :integer         not null
#  persona_id :integer         not null
#  lider      :boolean
#

