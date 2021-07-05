# encoding: utf-8

#
# 
# clase: ComiteResumen
# descripción: Migración a Rails 3
#


class ComiteResumen < ActiveRecord::Base
  
    
  def self.solicitudes_detalle tipo_comite,tipo_decision,comite_id, rubro_id, sector_id, subsector_id,estado_id
    filtro=""
    filtro += " and sector.id=#{sector_id}"
    filtro += " and sub_sector.id=#{subsector_id}"
    filtro += " and rubro.id=#{rubro_id}"

    sql=" select
                count(cdh.decision) as total_decision, sum(s.monto_solicitado) as total_monto
          from 
                comite_decision_historico cdh
                  inner join solicitud s on s.id=cdh.solicitud_id
                  inner join oficina on oficina.id=s.oficina_id
                  inner join ciudad on ciudad.id=oficina.ciudad_id
                  inner join estado on estado.id=ciudad.estado_id and estado.id= #{estado_id}
                  INNER JOIN rubro  ON s.rubro_id = rubro.id
                  INNER JOIN sub_sector ON rubro.sub_sector_id = sub_sector.id
                  INNER JOIN sector ON sub_sector.sector_id = sector.id
          where 
                cdh.tipo_comite='#{tipo_comite}'
                and cdh.decision='#{tipo_decision}'
                and cdh.comite_id=#{comite_id}
          #{filtro}
          group by cdh.decision
          
  union
  
         select
                count(cdht.decision) as total_decision, sum(s.monto_solicitado) as total_monto
          from 
                comite_decision_historico_total cdht
                  inner join solicitud s on s.id=cdht.solicitud_id
                  inner join oficina on oficina.id=s.oficina_id
                  inner join ciudad on ciudad.id=oficina.ciudad_id
                  inner join estado on estado.id=ciudad.estado_id and estado.id= #{estado_id}
                  INNER JOIN rubro  ON s.rubro_id = rubro.id
                  INNER JOIN sub_sector ON rubro.sub_sector_id = sub_sector.id
                  INNER JOIN sector ON sub_sector.sector_id = sector.id
          where 
                cdht.tipo_comite='#{tipo_comite}'
                and cdht.decision='#{tipo_decision}'
                and cdht.comite_id=#{comite_id}
                #{filtro}
          group by cdht.decision"

    cdh=ComiteDecisionHistorico.find_by_sql(sql)[0]
    total_decision=0
    total_monto   =0
    unless cdh.nil?
      total_decision =cdh[:total_decision]
      total_monto    =cdh[:total_monto]
    end
    {:total_decision=>total_decision,:total_monto=>total_monto}
  end

#  def self.solicitudes_detalle2 tipo_comite,tipo_decision,comite_id, rubro_id, sector_id, subsector_id, estado_id
#    filtro  = tipo_comite=='e' ? " solicitud.decision_comite_estadal='#{tipo_decision}' " : " solicitud.decision_comite_nacional='#{tipo_decision}' "
#    filtro += " and rubro.id=#{rubro_id}"
#    filtro += " and sector.id=#{sector_id}"
#    filtro += " and sub_sector.id=#{subsector_id}"
#    filtro += " and estado.id=#{estado_id}"
#    filtro += tipo_comite=='e' ? " and comite.id=solicitud.comite_estadal_id and solicitud.comite_estadal_id=#{comite_id}" : " and comite.id=solicitud.comite_id and solicitud.comite_id=#{comite_id} "
#    group_by = tipo_comite=='e' ? " group by solicitud.decision_comite_estadal " : " group by solicitud.decision_comite_nacional "
#    sql="select
#          count(solicitud.decision_comite_estadal) as total_decision
#          , sum(solicitud.monto_solicitado) as total_monto
#          from comite,solicitud
#          inner join unidad_produccion on unidad_produccion.id=solicitud.unidad_produccion_id
#          inner join ciudad on ciudad.id=unidad_produccion.ciudad_id
#          inner join estado on estado.id=ciudad.estado_id
#          INNER JOIN rubro  ON solicitud.rubro_id = rubro.id
#          INNER JOIN sub_sector ON rubro.sub_sector_id = sub_sector.id
#          INNER JOIN sector ON sub_sector.sector_id = sector.id
#          where  #{filtro}
#          #{group_by} "
#    solicitud=Comite.find_by_sql(sql)[0]
#
#    logger.debug "debug resumen sql........................................." << sql
#
#    total_decision=0
#    total_monto   =0
#    unless solicitud.nil?
#      total_decision =solicitud[:total_decision]
#      total_monto    =solicitud[:total_monto]
#    end
#    {:total_decision=>total_decision,:total_monto=>total_monto}
#  end
end
