# encoding: utf-8

class UpdateViewListSolicitud < ActiveRecord::Migration
  def up
    execute "
    
              DROP VIEW if exists view_list_solicitud;
    
              CREATE OR REPLACE VIEW view_list_solicitud AS 
          SELECT s.id AS solicitud_id,s.fecha_solicitud as fecha_solicitud, s.numero, e.id AS cliente_numero, e.rif AS cedula_rif, r.nombre AS rubro, e.nombre, es.nombre AS estatus, s.monto_solicitado, p.nombre AS programa,p.id as programa_id, su.nombre AS sub_sector, s.estatus_id, s.liberada, s.transcriptor, es.const_id, s.oficina_id, se.nombre AS sector, s.sector_id, s.sub_sector_id, s.rubro_id, s.consultoria, s.sub_rubro_id, sr.nombre AS sub_rubro, s.actividad_id, a.nombre AS actividad, est.nombre AS estado, ci.estado_id, o.nombre AS oficina
                     FROM solicitud s
                JOIN cliente c ON c.id = s.cliente_id
             JOIN empresa e ON e.id = c.empresa_id
             JOIN estatus es ON es.id = s.estatus_id
             JOIN programa p ON p.id = s.programa_id
             JOIN sector se ON se.id = s.sector_id
             JOIN sub_sector su ON su.id = s.sub_sector_id
             JOIN rubro r ON r.id = s.rubro_id
             JOIN sub_rubro sr ON sr.id = s.sub_rubro_id
             JOIN actividad a ON a.id = s.actividad_id
             JOIN oficina o ON o.id = s.oficina_id
             JOIN ciudad ci ON ci.id = o.ciudad_id
             JOIN estado est ON est.id = ci.estado_id
          UNION 
                   SELECT s.id AS solicitud_id,s.fecha_solicitud as fecha_solicitud, s.numero, per.id AS cliente_numero, per.cedula || ''::text AS cedula_rif, r.nombre AS rubro, (per.primer_nombre::text || ' '::text) || per.primer_apellido::text AS nombre, es.nombre AS estatus, s.monto_solicitado, p.nombre AS programa, p.id as programa_id, su.nombre AS sub_sector, s.estatus_id, s.liberada, s.transcriptor, es.const_id, s.oficina_id, se.nombre AS sector, s.sector_id, s.sub_sector_id, s.rubro_id, s.consultoria, s.sub_rubro_id, sr.nombre AS sub_rubro, s.actividad_id, a.nombre AS actividad, est.nombre AS estado, ci.estado_id, o.nombre AS oficina
                     FROM solicitud s
                JOIN cliente c ON c.id = s.cliente_id
             JOIN persona per ON per.id = c.persona_id
             JOIN estatus es ON es.id = s.estatus_id
             JOIN programa p ON p.id = s.programa_id
             JOIN sector se ON se.id = s.sector_id
             JOIN sub_sector su ON su.id = s.sub_sector_id
             JOIN rubro r ON r.id = s.rubro_id
             JOIN sub_rubro sr ON sr.id = s.sub_rubro_id
             JOIN actividad a ON a.id = s.actividad_id
             JOIN oficina o ON o.id = s.oficina_id
             JOIN ciudad ci ON ci.id = o.ciudad_id
             JOIN estado est ON est.id = ci.estado_id;
            "
  end

  def down
    execute "DROP VIEW view_list_solicitud;"
  end
end
