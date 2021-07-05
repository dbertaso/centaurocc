# encoding: utf-8

#
# 
# clase: ViewGuiaMovilizacion
# descripción: Migración a Rails 3
#

class ViewGuiaMovilizacion < ActiveRecord::Base

  self.table_name = 'view_guia_movilizacion'
  
    attr_accessible :guia_movilizacion_maquinaria_id,
                    :fecha_emision,
                    :fecha_estimada,
                    :solicitud_id,
                    :destino,
                    :numero_guia,
                    :cedula_rif,
                    :productor,
                    :nombre_destino,
                    :estatus,
                    :unidad_produccion_id,
                    :nombre_unidad_produccion,
                    :estatus_solicitud,
                    :encargado,
                    :fecha_emision_f,
                    :fecha_estimada_f

  
  
  
  public 
  
#  def fecha_envio_f=(fecha)
#    self.fecha_envio = fecha
#  end
  def fecha_emision_f
    format_fecha(self.fecha_emision)
  end
  
#  def fecha_estimada_f=(fecha)
#    self.fecha_estimada = fecha
#  end
  def fecha_estimada_f
    format_fecha(self.fecha_estimada)
  end
  
  def estatus_real
    guia = GuiaMovilizacionMaquinaria.find(self.guia_movilizacion_maquinaria_id)
    return guia.estatus
  end
  
  def valida_recepcion
    total = RecepcionMaquinaria.count(:conditions=>"guia_movilizacion_maquinaria_id = #{self.guia_movilizacion_maquinaria_id}")
    unless total > 0
      return false
    else
      return true
    end
  end

  def self.search(search, page, orden)        
    paginate :per_page=>@records_by_page, :page=>page, :conditions=>search, :order=>orden
  end

end

# == Schema Information
#
# Table name: view_guia_movilizacion
#
#  guia_movilizacion_maquinaria_id :integer
#  fecha_emision                   :date
#  fecha_estimada                  :date
#  solicitud_id                    :integer
#  destino                         :string(1)
#  numero_guia                     :string(20)
#  cedula_rif                      :string
#  productor                       :string
#  nombre_destino                  :text
#  estatus                         :string(1)
#  unidad_produccion_id            :integer
#  nombre_unidad_produccion        :string(150)
#  estatus_solicitud               :boolean
#  encargado                       :text
#

