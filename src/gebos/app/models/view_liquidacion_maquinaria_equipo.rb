# encoding: utf-8

#
# autor: Marvin Alfonzo
# clase: ViewLiquidacionMaquinariaEquipo
# descripción: Migración a Rails 3
#


class ViewLiquidacionMaquinariaEquipo< ActiveRecord::Base

  self.table_name = 'view_liquidacion_maquinaria_equipo'

  attr_accessible   :solicitud_id,
                    :cliente_id,
                    :numero_tramite,
                    :fecha_solicitud,
                    :fecha_registro,
                    :monto_aprobado,
                    :estatus,
                    :estatus_id,
                    :oficina_id,
                    :sector_id,
                    :sub_sector_id,
                    :rubro_id,
                    :por_inventario,
                    :conf_maquinaria,
                    :sub_rubro_id,
                    :actividad_id,
                    :prestamo_id,
                    :prestamo_numero,
                    :oficina,
                    :nombre_oficina,
                    :municipio,
                    :municipio_nombre,
                    :estado,
                    :estado_nombre,
                    :estatus_tramite,
                    :nombre_sector,
                    :nombre_sub_sector,
                    :nombre_rubro,
                    :nombre_beneficiario,
                    :documento_beneficiario


  def self.visible(solicitud_id)
    #total = ViewLiquidacionMaquinariaEquipo.find_by_sql("select count(*) as total from guia_catalogo where conforme = true and guia_movilizacion_maquinaria_id in (select id from guia_movilizacion_maquinaria where solicitud_id =#{solicitud_id})")
    total = GuiaCatalogo.count(:conditions=> "conforme = true and guia_movilizacion_maquinaria_id in (select id from guia_movilizacion_maquinaria where estatus = 'R' and solicitud_id =#{solicitud_id})")
    total1 = Catalogo.count(:conditions => "estatus = 'R' and solicitud_id = #{solicitud_id}")
    if total >= total1
      return true
    else
      return false
    end
  end

  def self.search(search, page, orden)        
    paginate :per_page=>@records_by_page, :page=>page, :conditions=>search, :order=>orden
  end

end

# == Schema Information
#
# Table name: view_liquidacion_maquinaria_equipo
#
#  solicitud_id           :integer
#  cliente_id             :integer
#  numero_tramite         :integer
#  fecha_solicitud        :date
#  fecha_registro         :date
#  monto_aprobado         :float
#  estatus                :string(1)
#  estatus_id             :integer
#  oficina_id             :integer
#  sector_id              :integer
#  sub_sector_id          :integer
#  rubro_id               :integer
#  por_inventario         :boolean
#  conf_maquinaria        :boolean
#  sub_rubro_id           :integer
#  actividad_id           :integer
#  prestamo_id            :integer
#  prestamo_numero        :integer(8)
#  oficina                :integer
#  nombre_oficina         :string(80)
#  municipio              :integer
#  municipio_nombre       :string(40)
#  estado                 :integer
#  estado_nombre          :string(40)
#  estatus_tramite        :text
#  nombre_sector          :string(100)
#  nombre_sub_sector      :string(100)
#  nombre_rubro           :string(100)
#  nombre_beneficiario    :string
#  documento_beneficiario :string
#

