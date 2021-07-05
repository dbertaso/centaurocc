# encoding: utf-8
class ViewBoletaArrime< ActiveRecord::Base

  self.table_name = 'view_boleta_arrime'
  
  attr_accessible  :nro_solicitud, 
    :solicitud_id, 
    :nro_prestamo, 
    :prestamo_id, 
    :estado, 
    :estado_id, 
    :municipio, 
    :municipio_id, 
    :cliente_id, 
    :clasificacion, 
    :cedula_rif, 
    :productor, 
    :sector, 
    :sector_id, 
    :sub_sector, 
    :sub_sector_id, 
    :rubro, 
    :rubro_id, 
    :sub_rubro, 
    :sub_rubro_id, 
    :actividad, 
    :actividad_id, 
    :unidad_produccion, 
    :unidad_produccion_id, 
    :estatus, 
    :proyecto,
    :moneda_id
 
  
  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
      :conditions => search, :order => sort,
      :select=>'view_boleta_arrime.*'
  end

end


# == Schema Information
#
# Table name: view_boleta_arrime
#
#  nro_solicitud        :integer
#  solicitud_id         :integer
#  nro_prestamo         :integer(8)
#  prestamo_id          :integer
#  estado               :string(40)
#  estado_id            :integer
#  municipio            :string(40)
#  municipio_id         :integer
#  cliente_id           :integer
#  clasificacion        :string(1)
#  cedula_rif           :string
#  productor            :string
#  sector               :string(100)
#  sector_id            :integer
#  sub_sector           :string(100)
#  sub_sector_id        :integer
#  rubro                :string(100)
#  rubro_id             :integer
#  sub_rubro            :string(100)
#  sub_rubro_id         :integer
#  actividad            :string(150)
#  actividad_id         :integer
#  unidad_produccion    :string(150)
#  unidad_produccion_id :integer
#  estatus              :string(1)
#  proyecto             :string(400)
#  moneda_id            :integer
#

