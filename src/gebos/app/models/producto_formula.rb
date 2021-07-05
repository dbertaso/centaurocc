# encoding: utf-8

#
# autor: Diego Bertaso
# clase: ProductoFormula
# descripción: Migración a Rails 3
#

class ProductoFormula < ActiveRecord::Base

  self.table_name = 'producto_formula'

  attr_accessible :producto_id,
    :formula_id

  belongs_to :producto
  belongs_to :formula

  def nombre
    self.formula.nombre
  end

  def self.search(search, page, sort)

    joins = 'INNER JOIN formula ON producto_formula.formula_id = formula.id'
    unless search.nil?
      paginate  :per_page => @records_by_page, :page => page,
        :conditions => search, :order => sort, :joins=>joins
    else
      paginate  :per_page => @records_by_page, :page => page,
        :order => sort, :joins=>joins

    end

  end
  
  
  def self.delete_registro(producto, formula)
    ProductoFormula.find_by_sql("DELETE FROM producto_formula WHERE producto_id = #{producto} and formula_id = #{formula}")

      return true

  end
  
end

# == Schema Information
#
# Table name: producto_formula
#
#  producto_id :integer         not null, primary key
#  formula_id  :integer         not null
#

