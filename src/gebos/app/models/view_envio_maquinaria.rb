# encoding: utf-8

#
# autor: Diego Bertaso
# clase: ViewEnvioMaquinaria
# descripción: Migración a Rails 3
#

class ViewEnvioMaquinaria < ActiveRecord::Base
    
    self.table_name = 'view_envio_maquinaria'
    
    attr_accessible :solicitud_id,
                    :nro_tramite,
                    :unidad_produccion_id,
                    :estatus_id,
                    :cliente_id,
                    :por_inventario,
                    :fecha_solicitud,
                    :oficina_id,
                    :cedula_rif,
                    :productor,
                    :unidad_produccion,
                    :unidad_produccion_direccion,
                    :estado,
                    :estado_id,
                    :municipio,
                    :municipio_id,
                    :parroquia_id,
                    :parroquia,
                    :estatus,
                    :encargado,
                    :telefono,
                    :estatus_solicitud,
                    :fecha_solicitud_f
   
  
  belongs_to :oficina
  
  def fecha_solicitud_f
    format_fecha(self.fecha_solicitud)
  end

  def self.search(search, page, orden)        
    paginate :per_page=>@records_by_page, :page=>page, :conditions=>search, :order=>orden
  end


end




# == Schema Information
#
# Table name: view_envio_maquinaria
#
#  solicitud_id                :integer
#  nro_tramite                 :integer
#  unidad_produccion_id        :integer
#  estatus_id                  :integer
#  cliente_id                  :integer
#  por_inventario              :boolean
#  fecha_solicitud             :date
#  oficina_id                  :integer
#  cedula_rif                  :string
#  productor                   :string
#  unidad_produccion           :string(150)
#  unidad_produccion_direccion :text
#  estado                      :string(40)
#  estado_id                   :integer
#  municipio                   :string(40)
#  municipio_id                :integer
#  parroquia_id                :integer
#  parroquia                   :string(40)
#  estatus                     :text
#  encargado                   :text
#  telefono                    :text
#  estatus_solicitud           :boolean
#

