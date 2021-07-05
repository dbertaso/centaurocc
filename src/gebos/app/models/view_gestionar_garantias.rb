# encoding: utf-8


class ViewGestionarGarantias < ActiveRecord::Base

    
  attr_accessible :solicitud_id, 
	:numero,
	:monto_solicitado, 
	:estatus_id, 
	:liberada, 
	:usuario_pre_evaluacion, 
	:consultoria, 
	:decision_final, 
	:confirmacion, 
	:oficina_id, 
	:sector_id,
	:sub_sector_id,
	:rubro_id,
	:sub_rubro_id,
	:actividad_id,
	:cliente_numero,
	:cedula_rif, 
	:nombre, 
	:estatus,
	:const_id,  
	:programa,
	:financiamiento, 
	:estado_id, 
	:estado,
	:usuario, 
	:sector, 
	:sub_sector, 
	:rubro, 
	:unidad_produccion, 
	:municipio_id,
	:parroquia_id, 
	:municipio,  
	:parroquia, 
	:sub_rubro, 
	:actividad,
  :moneda_id,
  :moneda


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
# Table name: view_gestionar_garantias
#
#  solicitud_id           :integer
#  numero                 :integer
#  monto_solicitado       :float
#  estatus_id             :integer
#  liberada               :boolean
#  usuario_pre_evaluacion :string(30)
#  consultoria            :boolean
#  decision_final         :boolean
#  confirmacion           :boolean
#  oficina_id             :integer
#  sector_id              :integer
#  sub_sector_id          :integer
#  rubro_id               :integer
#  sub_rubro_id           :integer
#  actividad_id           :integer
#  cliente_numero         :integer
#  cedula_rif             :string
#  nombre                 :string
#  estatus                :text
#  const_id               :string(6)
#  programa               :string(255)
#  financiamiento         :integer(8)
#  estado_id              :integer
#  estado                 :string(40)
#  usuario                :text
#  sector                 :string(100)
#  sub_sector             :string(100)
#  rubro                  :string(100)
#  unidad_produccion      :string(150)
#  municipio_id           :integer
#  parroquia_id           :integer
#  municipio              :string(40)
#  parroquia              :string(40)
#  sub_rubro              :string(100)
#  actividad              :string(150)
#  moneda_id              :integer
#  moneda                 :text
#

