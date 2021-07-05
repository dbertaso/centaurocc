
# encoding: utf-8

#
# autor: Diego Bertaso
# clase: ProductoPartida
# descripción: Migración a Rails 3
#

class ProductoPartida < ActiveRecord::Base

  self.table_name = 'producto_partida'

  attr_accessible :id,
                  :producto_id,
                  :partida_id

  belongs_to :producto
  belongs_to :partida

  has_and_belongs_to_many :items, :class_name=>'Item', :join_table=>'producto_partida_item',  :delete_sql =>
  'delete from producto_partida_item where producto_partida_id = #{self.id}'

  validates_presence_of :producto, :partida,
    :message => " es requerido"
  validates_uniqueness_of :producto_id, :scope=>'partida_id' ,
    :message => " ya existe"

end

# == Schema Information
#
# Table name: producto_partida
#
#  id          :integer         not null, primary key
#  producto_id :integer         not null
#  partida_id  :integer         not null
#

