# encoding: utf-8

#
# autor: Marvin Alfonzo
# clase: ViewListOrdenDespacho
# descripción: Migración a Rails 3
#


class ViewListOrdenDespacho < ActiveRecord::Base

  
  self.table_name = 'view_list_orden_despacho' 
  
    attr_accessible :solicitud_id,
                    :nombre,
                    :cedula_rif,
                    :numero,
                    :rubro,
                    :estatus,
                    :monto_solicitado,
                    :programa,
                    :programa_id,
                    :sub_sector,
                    :estatus_id,
                    :liberada,
                    :transcriptor,
                    :const_id,
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
                    :ciclo,
                    :ciclo_id,
                    :orden_despacho_id,
                    :monto,
                    :actividad_id,
                    :sub_rubro_id

  
  
  def self.devuelta(solicitud_id)
   orden_despacho = OrdenDespacho.find(:first, :conditions=>['solicitud_id = ?', solicitud_id], :order => 'id desc')
   if control_solicitud.accion == I18n.t('Sistema.Body.General.reversar')
     return true
   else
     return false
   end
  end




public
  def monto_fm
    format_fm(self.monto)
  end

  def self.search(search, page, orden)    
    paginate :per_page=>@records_by_page, :page=>page, :conditions=>search, :order=>orden
  end

  def self.search_join(search, page, orden, join)    
    paginate :per_page=>@records_by_page, :page=>page, :conditions=>search, :order=>orden,:joins=>join
  end

end  

# == Schema Information
#
# Table name: view_list_orden_despacho
#
#  solicitud_id         :integer
#  nombre               :string
#  no_va                :text
#  cedula_rif           :string
#  numero               :integer
#  rubro                :string(100)
#  estatus              :text
#  monto_solicitado     :float
#  programa             :string(255)
#  programa_id          :integer
#  sub_sector           :string(100)
#  estatus_id           :integer
#  transcriptor         :string(25)
#  oficina_id           :integer
#  sector               :string(100)
#  sector_id            :integer
#  sub_sector_id        :integer
#  rubro_id             :integer
#  consultoria          :boolean
#  municipio            :string(40)
#  parroquia            :string(40)
#  estado               :string(40)
#  estado_id            :integer
#  ciclo                :string
#  ciclo_id             :integer
#  orden_despacho_id    :integer
#  fecha_orden_despacho :date
#  monto                :decimal(16, 2)
#  actividad_id         :integer
#  sub_rubro_id         :integer
#  moneda_id            :integer
#

# == Schema Information
#
# Table name: view_list_orden_despacho
#
#  solicitud_id      :integer
#  nombre            :string
#  cedula_rif        :string
#  numero            :integer
#  rubro             :string(100)
#  estatus           :string(50)
#  monto_solicitado  :float
#  programa          :string(255)
#  sub_sector        :string(100)
#  estatus_id        :integer
#  liberada          :boolean
#  transcriptor      :string(25)
#  const_id          :string(6)
#  oficina_id        :integer
#  sector            :string(100)
#  sector_id         :integer
#  sub_sector_id     :integer
#  rubro_id          :integer
#  consultoria       :boolean
#  municipio         :string(40)
#  parroquia         :string(40)
#  estado            :string(40)
#  estado_id         :integer
#  orden_despacho_id :integer
#  monto             :decimal(16, 3)
#  actividad_id      :integer
#  sub_rubro_id      :integer
#

