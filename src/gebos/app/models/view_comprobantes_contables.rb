# encoding: utf-8

#
# autor: 
# clase: ViewComprobantesContables
# descripción: Migración a Rails 3
#


class ViewComprobantesContables < ActiveRecord::Base
  # attr_accessible :title, :body

  self.table_name = 'view_comprobantes_contables'

  attr_accessible :id,
                  :tc_nombre,
                  :tc_id,
                  :fecha_registro,
                  :fecha_comprobante,
                  :enviado,
                  :reverso,
                  :prestamo_numero,
                  :solicitud_numero,
                  :total_debe,
                  :total_haber,
                  :moneda_nombre,
                  :moneda_abreviatura,
                  :moneda_id,
                  :programa_id,
                  :programa_nombre,
                  :identificacion,
                  :nombre_cliente

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
# Table name: view_comprobantes_contables
#
#  id                 :integer
#  tc_nombre          :string(50)
#  tc_id              :integer
#  fecha_registro     :date
#  fecha_comprobante  :date
#  enviado            :boolean
#  reverso            :boolean
#  reversado          :boolean
#  prestamo_numero    :integer(8)
#  solicitud_numero   :integer
#  total_debe         :float
#  total_haber        :float
#  moneda_nombre      :text
#  moneda_abreviatura :string(5)
#  moneda_id          :integer
#  programa_id        :integer
#  programa_nombre    :string(255)
#  identificacion     :string
#  nombre_cliente     :string
#

