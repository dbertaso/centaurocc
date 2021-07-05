# encoding: utf-8

#
# autor: 
# clase: ViewConsultaDisponibilidad
# descripción: Migración a Rails 3
#

class ViewConsultaDisponibilidad < ActiveRecord::Base

  self.table_name = 'view_consulta_disponibilidad'
  
    attr_accessible :estado,
                    :sector,
                    :sub_sector,
                    :nombre,
                    :monto_solicitado,
                    :estatus_id,
                    :contador,
                    :disponible,
                    :mostrar,
                    :sector_id,
                    :sub_sector_id,
                    :rubro_id,
                    :estado_id

  def self.devuelta(solicitud_id)
   control_solicitud = ControlSolicitud.find(:first, :conditions=>['solicitud_id = ?', solicitud_id], :order => 'id desc')
   if control_solicitud.accion == 'Reversar'
     return true
   else
     return false
   end
  end

  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
             :conditions => search, :order => sort
  end


end


# == Schema Information
#
# Table name: view_consulta_disponibilidad
#
#  estado_id        :integer
#  sector_id        :integer
#  sub_sector_id    :integer
#  rubro_id         :integer
#  programa_id      :integer
#  programa         :string(255)
#  sub_rubro_id     :integer
#  estado           :string(40)
#  sector           :string(100)
#  sub_sector       :string(100)
#  rubro            :string(100)
#  sub_rubro        :string(100)
#  monto_solicitado :decimal(, )
#  estatus_id       :integer
#  contador         :integer(8)
#  disponible       :decimal(, )
#  mostrar          :text
#

