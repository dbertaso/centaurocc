# encoding: utf-8

#
# 
# clase: ViewGrupo
# descripción: Migración a Rails 3
#

class ViewGrupo < ActiveRecord::Base

  self.table_name = 'view_grupo'
  
  attr_accessible :id,
				  :grupo_id,
				  :numero,
				  :cedula,
				  :persona_id,
				  :total,
				  :nombre,
				  :lider  
  
end

# == Schema Information
#
# Table name: view_grupo
#
#  id         :integer
#  grupo_id   :integer
#  numero     :integer
#  cedula     :integer
#  persona_id :integer
#  total      :integer(8)
#  nombre     :text
#  lider      :boolean
#

