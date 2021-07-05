# encoding: utf-8

#
# 
# clase: ViewSolicitudPreEvaluacion
# descripción: Migración a Rails 3
#

class ViewSolicitudPreEvaluacion < ActiveRecord::Base

  self.table_name = 'view_solicitud_pre_evaluacion'
  
  attr_accessible :solicitud_id,
    :numero,
    :cliente_numero,
    :cedula_rif,
    :nombre,
    :estatus,
    :monto_solicitado,
    :programa,
    :estado_id,
    :estado,
    :usuario,
    :estatus_id,
    :liberada,
    :usuario_pre_evaluacion,
    :const_id,
    :consultoria,
    :decision_final,
    :confirmacion,
    :oficina_id,
    :sector_id,
    :sector,
    :sub_sector_id,
    :sub_sector,
    :rubro_id,
    :rubro,
    :unidad_produccion,
    :municipio_id,
    :municipio, 
    :parroquia_id,
    :parroquia,
    :sub_rubro_id,
    :sub_rubro,
    :actividad_id,
    :actividad


  def self.mostrar_estatus(solicitud_id)
    solicitud = Solicitud.find(solicitud_id)
    estatus = ""
    if (solicitud.estatus_id == 10004)
      unless solicitud.consultoria
        estatus << "(CJ"
      end

      unless solicitud.avaluo
        if estatus.length > 0
          estatus << "+AI"
        else
          estatus << "(AI"
        end
      end

      unless solicitud.resguardo
        if estatus.length > 0
          estatus << "+RI"
        else
          estatus << "(RI"
        end
      end

      if estatus.length > 0
        estatus << ")"
        return estatus
      else
        return ''
      end
    else
      return ''
    end
  end
  
  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
      :conditions => search, :order => sort,
      :select=>'*'
  end

end


# == Schema Information
#
# Table name: view_solicitud_pre_evaluacion
#
#  solicitud_id           :integer
#  numero                 :integer
#  cliente_numero         :integer
#  cedula_rif             :string
#  nombre                 :string
#  estatus                :text
#  monto_solicitado       :float
#  programa               :string(255)
#  estado_id              :integer
#  estado                 :string(40)
#  usuario                :text
#  estatus_id             :integer
#  liberada               :boolean
#  usuario_pre_evaluacion :string(30)
#  const_id               :string(6)
#  consultoria            :boolean
#  decision_final         :boolean
#  confirmacion           :boolean
#  oficina_id             :integer
#  sector_id              :integer
#  sector                 :string(100)
#  sub_sector_id          :integer
#  sub_sector             :string(100)
#  rubro_id               :integer
#  rubro                  :string(100)
#  unidad_produccion      :string(150)
#  municipio_id           :integer
#  municipio              :string(40)
#  parroquia_id           :integer
#  parroquia              :string(40)
#  sub_rubro_id           :integer
#  sub_rubro              :string(100)
#  actividad_id           :integer
#  actividad              :string(150)
#

