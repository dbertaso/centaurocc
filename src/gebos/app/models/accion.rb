# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Accion
# descripción: Migración a Rails 3
#
class Accion < ActiveRecord::Base

  self.table_name = 'accion'

  attr_accessible :id,
                  :nombre,
                  :nombre_sistema

  validates_presence_of :nombre, :nombre_sistema
  validates_length_of :nombre, :within => 1..50, :allow_nil => false
  validates_length_of :nombre_sistema, :within => 1..50, :allow_nil => false
  validates_uniqueness_of :nombre
  validates_uniqueness_of :nombre_sistema

  def self.item
    item = Item.find(:all)
    begin
      success = true
      transaction do
        item.each {|i|
          conf = Configurador.find(:all, :conditions=> "item_id = #{i.id}")
          conf.each {|c|
            c.partida_id = i.partida_id
            c.actividad_id = i.partida.actividad_id
            c.sub_rubro_id = i.partida.actividad.sub_rubro_id
            c.rubro_id = i.partida.actividad.sub_rubro.rubro_id
            c.sub_sector_id = i.partida.actividad.sub_rubro.rubro.sub_sector_id
            c.sector_id = i.partida.actividad.sub_rubro.rubro.sub_sector.sector_id
            c.save
          }
        }
        return true
     end
    rescue Exception => e
      return e.mensaje.to_s
    end
  end

end


# == Schema Information
#
# Table name: accion
#
#  id             :integer         not null, primary key
#  nombre         :string(50)      not null
#  nombre_sistema :string(50)      not null
#

