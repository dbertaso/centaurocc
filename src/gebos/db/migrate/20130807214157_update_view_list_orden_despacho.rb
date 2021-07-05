# encoding: utf-8

class UpdateViewListOrdenDespacho < ActiveRecord::Migration
  def up
    
  execute "   
    
    DROP VIEW if exists view_list_orden_despacho;
    
    CREATE OR REPLACE VIEW view_list_orden_despacho AS 
    SELECT s.id AS solicitud_id, 
        CASE
            WHEN e.nombre IS NULL THEN ((p.primer_nombre::text || ' '::text) || p.primer_apellido::text)::character varying
            ELSE e.nombre
        END AS nombre, 
        CASE
            WHEN e.rif IS NULL THEN ((p.cedula_nacionalidad::text || ' '::text) || p.cedula::text)::character varying
            ELSE e.rif
        END AS cedula_rif, s.numero, r.nombre AS rubro, es.nombre AS estatus, s.monto_solicitado, pr.nombre AS programa, s.programa_id, su.nombre AS sub_sector, or_des.estatus_id, s.liberada, s.transcriptor, es.const_id, s.oficina_id, se.nombre AS sector, s.sector_id, s.sub_sector_id, s.rubro_id, s.consultoria, mu.nombre AS municipio, pa.nombre AS parroquia, est.nombre AS estado, est.id AS estado_id, 
        CASE
            WHEN cp.nombre IS NULL THEN 'N/A'::character varying
            ELSE cp.nombre
        END AS ciclo, 
        CASE
            WHEN cp.id IS NULL THEN 0
            ELSE cp.id
        END AS ciclo_id, or_des.id AS orden_despacho_id,or_des.fecha_orden_despacho AS fecha_orden_despacho, or_des.monto, acti.id AS actividad_id, sub_r.id AS sub_rubro_id
   FROM cliente c
   LEFT JOIN empresa e ON c.empresa_id = e.id
   LEFT JOIN persona p ON c.persona_id = p.id
   JOIN solicitud s ON s.cliente_id = c.id
   JOIN estatus es ON es.id = s.estatus_id
   JOIN prestamo pres ON pres.solicitud_id = s.id
   JOIN programa pr ON pr.id = s.programa_id
   JOIN sector se ON se.id = s.sector_id
   JOIN sub_sector su ON su.id = s.sub_sector_id
   JOIN rubro r ON r.id = s.rubro_id
   JOIN sub_rubro sub_r ON s.sub_rubro_id = sub_r.id
   JOIN actividad acti ON s.actividad_id = acti.id
   JOIN unidad_produccion up ON up.id = s.unidad_produccion_id
   JOIN municipio mu ON mu.id = up.municipio_id
   JOIN parroquia pa ON pa.id = up.parroquia_id
   JOIN estado est ON est.id = mu.estado_id
   LEFT JOIN ciclo_productivo cp ON cp.id = acti.ciclo_productivo_id
   JOIN oficina ofi ON ofi.id = s.oficina_id
   JOIN orden_despacho or_des ON s.id = or_des.solicitud_id
  WHERE c.empresa_id IS NOT NULL OR c.persona_id IS NOT NULL;

    "
  end

  def down
    execute "DROP VIEW view_list_orden_despacho;"
  end
end
