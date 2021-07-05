# encoding: utf-8
#
# autor: Luis Rojas
# clase: ViewStockMaquinaria
# descripción: Migración a Rails 3
#
class ViewStockMaquinaria < ActiveRecord::Base
  
  self.table_name = 'view_stock_maquinaria'
  
  def self.existencia(clase_id, marca_id, modelo_id)
    total = Catalogo.count(:conditions => "estatus = 'L' and clase_id = #{clase_id} and marca_maquinaria_id = #{marca_id} and modelo_id = #{modelo_id}")
    stock = ViewStockMaquinaria.find(:first, :conditions => "tipo_id = #{clase_id} and marca_id = #{marca_id} and modelo_id = #{modelo_id}")
    if stock.minimo > total
      color = "red"
    elsif stock.minimo = total
      color = "green"
    elsif stock.maximo >= total
      color = "green"
    elsif stock.maximo < total
      color = "black"
    end
    return "<span style='color: #{color}'>#{total}</span>"
  end
  
  def self.reposicion(clase_id, marca_id, modelo_id)
    total = Catalogo.count(:conditions => "estatus = 'L' and clase_id = #{clase_id} and marca_maquinaria_id = #{marca_id} and modelo_id = #{modelo_id}")
    stock = ViewStockMaquinaria.find(:first, :conditions => "tipo_id = #{clase_id} and marca_id = #{marca_id} and modelo_id = #{modelo_id}")
    return stock.maximo - total
  end
  
  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
             :conditions => search, :order => sort, 
             :select => '*'
  end
end
# == Schema Information
#
# Table name: view_stock_maquinaria
#
#  id        :integer
#  rubro_id  :integer
#  rubro     :string(100)
#  tipo_id   :integer
#  tipo      :string(100)
#  marca_id  :integer
#  marca     :string(100)
#  modelo_id :integer
#  modelo    :string(100)
#  minimo    :integer
#  maximo    :integer
#

