# encoding: utf-8

#
# autor: Luis Rojas
# clase: ViewListSolicitud
# descripcion: Migracion a Rails 3

class ViewListSolicitud < ActiveRecord::Base
  
  self.table_name = 'view_list_solicitud'
  
  attr_accessible :solicitud_id, :numero, :cliente_numero, :cedula_rif, 
    :rubro,:nombre, :estatus, :monto_solicitado, :programa, :sub_sector, 
    :estatus_id, :liberada, :transcriptor, :const_id, :oficina_id, :sector,
    :sector_id, :sub_sector_id, :rubro_id, :consultoria, :sub_rubro_id, 
    :sub_rubro, :actividad_id, :actividad, :estado, :estado_id, :oficina,:moneda_id,:fecha_solicitud_f
  
  belongs_to :moneda
  
  def self.devuelta(solicitud_id)
   control_solicitud = ControlSolicitud.find(:first, :conditions=>['solicitud_id = ?', solicitud_id], :order => 'id desc')
   if control_solicitud.accion == 'Reversar'
     return true
   else
     return false
   end
  end

  def self.deshacer(solicitud_id)
    solicitud = Solicitud.find(solicitud_id)
    unless solicitud.comentario_directorio.nil?
      if solicitud.comentario_directorio.length > 0
        return true
      else
        return false
      end
    else
      return false
    end
  end


  def fecha_solicitud_f    
      format_fecha(self.fecha_solicitud)
  end

  def self.search(search, page, orden)    
    paginate :per_page=>@records_by_page, :page=>page, :conditions=>search, :order=>orden
  end


end

# == Schema Information
#
# Table name: view_list_solicitud
#
#  solicitud_id     :integer
#  fecha_solicitud  :date
#  numero           :integer
#  cliente_numero   :integer
#  cedula_rif       :string
#  nombre           :string
#  rubro            :string(100)
#  estatus          :text
#  monto_solicitado :float
#  programa         :string(255)
#  programa_id      :integer
#  moneda_id        :integer
#  sub_sector       :string(100)
#  estatus_id       :integer
#  liberada         :boolean
#  transcriptor     :string(25)
#  const_id         :string(6)
#  oficina_id       :integer
#  sector           :string(100)
#  sector_id        :integer
#  sub_sector_id    :integer
#  rubro_id         :integer
#  consultoria      :boolean
#  sub_rubro_id     :integer
#  sub_rubro        :string(100)
#  actividad_id     :integer
#  actividad        :string(150)
#  estado           :string(40)
#  estado_id        :integer
#  oficina          :string(80)
#

