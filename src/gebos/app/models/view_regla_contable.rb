# encoding: UTF-8

#
# autor: Diego Bertaso
# clase: ViewReglaContable
# descripción: Creado con Rails 3
#
class ViewReglaContable < ActiveRecord::Base
  # attr_accessible :title, :body

  self.table_name = 'view_regla_contable'

  attr_accessible :rc_id,
                  :fuente_recursos_id,
                  :estatus,
                  :secuencia,
                  :tipo_movimiento,
                  :codigo_contable,
                  :codigo_descripcion,
                  :auxiliar_contable,
                  :tipo_monto,
                  :modalidad_pago,
                  :entidad_financiera_id,
                  :entidad_nombre,
                  :reestructurado,
                  :programa_id,
                  :transaccion_contable_id,
                  :plazos,
                  :programa_nombre,
                  :moneda_nombre,
                  :moneda_abreviatura,
                  :nombre_transaccion

  public

  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
      :conditions => search, :order => sort
  end

end

# == Schema Information
#
# Table name: view_regla_contable
#
#  rc_id                   :integer
#  fuente_recursos_id      :integer
#  estatus                 :string(1)
#  secuencia               :integer
#  tipo_movimiento         :string(1)
#  codigo_contable         :string(25)
#  codigo_descripcion      :string(255)
#  auxiliar_contable       :string(7)
#  tipo_monto              :string(2)
#  modalidad_pago          :string(1)
#  entidad_financiera_id   :integer
#  entidad_nombre          :string
#  reestructurado          :string(1)
#  programa_id             :integer
#  transaccion_contable_id :integer
#  plazos                  :string(1)
#  programa_nombre         :string(255)
#  moneda_nombre           :text
#  moneda_abreviatura      :string(5)
#  nombre_transaccion      :string(50)
#

