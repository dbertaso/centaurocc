# encoding: utf-8

#
# autor: Marvin Alfonzo
# clase: ViewListOrdenDespachoInsumo
# descripción: Migración a Rails 3
#


class ViewListOrdenDespachoInsumo < ActiveRecord::Base

    self.table_name = 'view_list_orden_despacho_insumo' 
  
    attr_accessible :prestamo,
                    :cliente_id,
                    :numero_factura,
                    :nombre,
                    :cedula_rif,
                    :numero,
                    :rubro,
                    :estatus,
                    :monto_solicitado,
                    :programa,
                    :sub_sector,
                    :estatus_id,
                    :liberada,
                    :transcriptor,
                    :tipo_cuenta,
                    :numero_cuenta,
                    :entidad_financiera_id,
                    :oficina_id,
                    :sector,
                    :sector_id,
                    :sub_sector_id,
                    :rubro_id,
                    :consultoria,
                    :municipio,
                    :parroquia,
                    :estado,
                    :estado_id,
                    :monto,
                    :num_factura,
                    :fecha_factura,
                    :fecha_orden,
                    :casa_proveedora,
                    :actividad_id,
                    :sub_rubro_id,
                    :monto_total_factura,
                    :tipo_pago_casa_proveedora,
                    :orden_despacho_id,
                    :solicitud_id


public
  def monto_factura_fm    
      format_fm(self.monto_factura)
  end

  def monto_total_factura_fm    
      format_fm(self.monto_total_factura)
  end

  def self.search(search, page, orden)    
    paginate :per_page=>@records_by_page, :page=>page, :conditions=>search, :order=>orden
  end

end

# == Schema Information
#
# Table name: view_list_orden_despacho_insumo
#
#  prestamo                  :integer
#  cliente_id                :integer
#  numero_factura            :string(20)
#  nombre                    :string
#  cedula_rif                :string
#  numero                    :text
#  solicitud_id              :integer
#  orden_despacho_id         :integer
#  rubro                     :string(100)
#  estatus                   :text
#  monto_solicitado          :float
#  programa                  :string(255)
#  sub_sector                :string(100)
#  estatus_id                :integer
#  liberada                  :boolean
#  transcriptor              :string(25)
#  tipo_cuenta               :string(1)
#  numero_cuenta             :string(20)
#  entidad_financiera_id     :integer
#  oficina_id                :integer
#  sector                    :string(100)
#  sector_id                 :integer
#  sub_sector_id             :integer
#  rubro_id                  :integer
#  consultoria               :boolean
#  municipio                 :string(40)
#  parroquia                 :string(40)
#  estado                    :string(40)
#  estado_id                 :integer
#  monto                     :decimal(16, 2)
#  num_factura               :string(20)
#  fecha_factura             :date
#  fecha_orden               :date
#  casa_proveedora           :integer
#  tipo_pago_casa_proveedora :string(1)
#  actividad_id              :integer
#  sub_rubro_id              :integer
#  monto_total_factura       :decimal(, )
#  identificador             :text
#

