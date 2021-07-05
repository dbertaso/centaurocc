# encoding: utf-8

#
# autor: Marvin Alfonzo
# clase: ViewPendientePorDisponibilidad
# descripción: Migración a Rails 3
#
class ViewPendientePorDisponibilidad < ActiveRecord::Base

  self.table_name = 'view_pendiente_por_disponibilidad'
  
  attr_accessible   :solicitud_id,
                    :numero,
                    :programa,
                    :monto_solicitado,
                    :monto_tramite,
                    :pidan_id,
                    :disponibilidad,
                    :disponible,
                    :programa_id,
                    :sector,
                    :sub_sector,
                    :rubro,
                    :sub_rubro,
                    :actividad,
                    :unidad_produccion,
                    :municipio,
                    :estado_id,
                    :estado,
                    :sector_id,
                    :sub_sector_id,
                    :rubro_id,
                    :sub_rubro_id,
                    :actividad_id,
                    :estatus_id,
                    :cedula_rif,
                    :productor

    def self.search(search, page, orden)    
        paginate :per_page=>@records_by_page, :page=>page, :conditions=>search, :order=>orden
    end


  def self.devuelta(solicitud_id)
   control_solicitud = ControlSolicitud.find(:first, :conditions=>['solicitud_id = ?', solicitud_id], :order => 'id desc')
   if control_solicitud.accion == I18n.t('Sistema.Body.General.reversar')
     return true
   else
     return false
   end
  end
  
  def moneda
    return Programa.find(self.programa_id).moneda.nombre
  end

end





# == Schema Information
#
# Table name: view_pendiente_por_disponibilidad
#
#  solicitud_id      :integer
#  numero            :integer
#  programa          :string(255)
#  monto_solicitado  :float
#  monto_tramite     :float
#  pidan_id          :integer
#  disponibilidad    :decimal(16, 2)
#  disponible        :text
#  programa_id       :integer
#  sector            :string(100)
#  sub_sector        :string(100)
#  rubro             :string(100)
#  sub_rubro         :string(100)
#  actividad         :string(150)
#  unidad_produccion :string(150)
#  municipio         :string(40)
#  estado_id         :integer
#  estado            :string(40)
#  sector_id         :integer
#  sub_sector_id     :integer
#  rubro_id          :integer
#  sub_rubro_id      :integer
#  actividad_id      :integer
#  estatus_id        :integer
#  cedula_rif        :string
#  productor         :string
#

