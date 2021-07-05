# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Menu
# descripción: Migración a Rails 3
#

class Menu < ActiveRecord::Base

 self.table_name = 'menu'
 acts_as_tree :order => "orden"
 
 attr_accessible :nombre,
                 :descripcion,
                 :parent_id,
                 :orden,
                 :opcion_id
                 
 belongs_to :opcion

  def tiene_opcion
    !opcion.nil?
  end

end

# == Schema Information
#
# Table name: menu
#
#  id          :integer         not null, primary key
#  nombre      :string(50)      not null
#  descripcion :string(300)
#  parent_id   :integer
#  orden       :integer         not null
#  opcion_id   :integer
#  menu_id     :integer
#

