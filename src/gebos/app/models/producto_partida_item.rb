# encoding: utf-8

#
# autor: Diego Bertaso
# clase: ProductoPartidaItem
# descripción: Migración a Rails 3
#

class ProductoPartidaItem < ActiveRecord::Base

  self.table_name = 'producto_partida_item'

  attr_accessible :id,
                  :producto_partida_id,
                  :producto_id,
                  :rubro_id,
                  :partida_id,
                  :item_id,
                  :sub_rubro_id,
                  :actividad_id

  belongs_to :partida
  belongs_to :producto
  belongs_to :producto_partida
  belongs_to :rubro
  belongs_to :item

  validates_presence_of :rubro, :partida, :item, :producto, :producto_partida, :partida,
    :message => " es requerido"

end

# == Schema Information
#
# Table name: producto_partida_item
#
#  id                  :integer         not null, primary key
#  producto_partida_id :integer         default(0), not null
#  producto_id         :integer         not null
#  rubro_id            :integer         not null
#  partida_id          :integer         not null
#  item_id             :integer         not null
#  sub_rubro_id        :integer
#  actividad_id        :integer
#

