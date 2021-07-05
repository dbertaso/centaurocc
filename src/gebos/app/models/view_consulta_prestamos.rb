# encoding: utf-8

#
# autor: Diego Bertaso
# clase: ViewConsultaPrestamos
# descripción: Creado en Rails 3
#

class ViewConsultaPrestamos < ActiveRecord::Base
  # attr_accessible :title, :body

  self.table_name = 'view_consulta_prestamos'
  
  attr_accessible :solicitud_id,
                  :id,
                  :numero,
                  :numero_solicitud,
                  :numero_origen,
                  :moneda_id,
                  :moneda_nombre,
                  :moneda_abreviatura,
                  :rubro_nombre,
                  :identificacion,
                  :nombre_cliente,
                  :fecha,
                  :estado_nombre,
                  :saldo_insoluto,
                  :deuda,
                  :exigible,
                  :estatus_p

  public

  def self.search(search, page, sort)

    unless search.nil?
      paginate  :per_page => @records_by_page,
                :page => page,
                :conditions => search,
                :order => sort
    else
      paginate  :per_page => @records_by_page,
                :page => page,
                :order => sort

    end

  end
end

# == Schema Information
#
# Table name: view_consulta_prestamos
#
#  solicitud_id       :integer
#  id                 :integer
#  numero             :integer(8)
#  numero_solicitud   :integer
#  numero_origen      :integer
#  moneda_id          :integer
#  moneda_nombre      :text
#  moneda_abreviatura :string(5)
#  rubro_nombre       :string(100)
#  identificacion     :string
#  nombre_cliente     :string
#  fecha              :date
#  estado_nombre      :string(40)
#  saldo_insoluto     :decimal(16, 2)
#  deuda              :decimal(16, 2)
#  exigible           :decimal(16, 2)
#  estatus_p          :string(1)
#

