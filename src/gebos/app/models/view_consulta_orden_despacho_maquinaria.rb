# encoding: utf-8

#
# autor: Marvin Alfonzo
# clase: ViewConsultaOrdenDespachoMaquinaria
# descripción: Migración a Rails 3
#

class ViewConsultaOrdenDespachoMaquinaria < ActiveRecord::Base
    
  belongs_to :empresa_transporte_maquinaria
  belongs_to :unidad_produccion
  belongs_to :solicitud   
  belongs_to :almacen_maquinaria
  belongs_to :oficina
  
  self.table_name = 'view_consulta_orden_despacho_maquinaria'

  attr_accessible   :programa_id,
                    :beneficiario,
                    :origen,
                    :cedula_rif,
                    :solicitud_id,
                    :nro_tramite,
                    :guia_id,
                    :numero_guia,
                    :fecha_envio,
                    :destino,
                    :estatus,
                    :oficina_id,
                    :unidad_produccion_id,
                    :direccion_destino,
                    :telefono_destino,
                    :cedula_persona_contacto_1,
                    :cedula_persona_contacto_2,
                    :nombre_contacto_1,
                    :nombre_contacto_2,
                    :telefono_contacto_1,
                    :telefono_contacto_2,
                    :fecha_llegada,
                    :conforme,
                    :fecha_envio_f,
                    :fecha_llegada_f

  
  
  def fecha_envio_f=(fecha)
    self.fecha_envio = fecha
  end

  def fecha_envio_f
    format_fecha(self.fecha_envio)
  end  
  
  def fecha_llegada_f=(fecha)
    self.fecha_llegada = fecha
  end

  def fecha_llegada_f
    format_fecha(self.fecha_llegada)
  end  
  
  def self.search(search, page, orden)        
    paginate :per_page=>@records_by_page, :page=>page, :conditions=>search, :order=>orden
  end
  
  
end

# == Schema Information
#
# Table name: view_consulta_orden_despacho_maquinaria
#
#  programa_id               :integer
#  beneficiario              :string
#  origen                    :string
#  cedula_rif                :string
#  solicitud_id              :integer
#  nro_tramite               :integer
#  guia_id                   :integer
#  numero_guia               :string(20)
#  fecha_envio               :date
#  destino                   :string(1)
#  estatus                   :string(1)
#  oficina_id                :integer
#  unidad_produccion_id      :integer
#  direccion_destino         :string(250)
#  telefono_destino          :string(11)
#  cedula_persona_contacto_1 :string
#  cedula_persona_contacto_2 :string
#  nombre_contacto_1         :string(60)
#  nombre_contacto_2         :string(60)
#  telefono_contacto_1       :string(11)
#  telefono_contacto_2       :string(11)
#  fecha_llegada             :date
#  conforme                  :boolean
#

