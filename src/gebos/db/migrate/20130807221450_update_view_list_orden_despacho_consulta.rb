# encoding: utf-8

class UpdateViewListOrdenDespachoConsulta < ActiveRecord::Migration
  def up
    
    execute " 
    
          DROP VIEW if exists view_list_orden_despacho_consulta;
          
          CREATE OR REPLACE VIEW view_list_orden_despacho_consulta AS
          
          SELECT DISTINCT on (sol.numero) ode.prestamo_id AS prestamo, cli.id AS cliente_id, fac_or_des.numero_factura, 
                CASE
                    WHEN emp.nombre IS NULL THEN ((per.primer_nombre::text || ' '::text) || per.primer_apellido::text)::character varying
                    ELSE emp.nombre
                END AS nombre, 
                CASE
                    WHEN emp.rif IS NULL THEN ((per.cedula_nacionalidad::text || ' '::text) || per.cedula::text)::character varying
                    ELSE emp.rif
                END AS cedula_rif, sol.numero::text AS numero, sol.id AS solicitud_id, ode.id AS orden_despacho_id, r.nombre AS rubro, es.nombre AS estatus,es.id AS estatus_tramite_id, sol.monto_solicitado, su.nombre AS sub_sector, ode.estatus_id,  sol.oficina_id, se.nombre AS sector, sol.sector_id, sol.sub_sector_id, sol.rubro_id, seg_vis.codigo_visita ,seg_vis.fecha_visita,ode.monto, ode.fecha_orden_despacho AS fecha_orden, acti.id AS actividad_id, sub_r.id AS sub_rubro_id
           FROM factura_orden_despacho fac_or_des   
           LEFT JOIN orden_despacho_detalle odsd ON odsd.id = fac_or_des.orden_despacho_detalle_id
           LEFT JOIN orden_despacho ode ON odsd.orden_despacho_id = ode.id 
           LEFT JOIN solicitud sol ON ode.solicitud_id = sol.id
           JOIN seguimiento_visita seg_vis ON seg_vis.solicitud_id = sol.id   
           JOIN cliente cli ON sol.cliente_id = cli.id
           LEFT JOIN empresa emp ON cli.empresa_id = emp.id
           LEFT JOIN persona per ON cli.persona_id = per.id   
           JOIN estatus es ON es.id = sol.estatus_id   
           JOIN sector se ON se.id = sol.sector_id
           JOIN sub_sector su ON su.id = sol.sub_sector_id
           JOIN rubro r ON r.id = sol.rubro_id
           JOIN sub_rubro sub_r ON sol.sub_rubro_id = sub_r.id
           JOIN actividad acti ON sol.actividad_id = acti.id   
          WHERE fac_or_des.confirmada = true AND fac_or_des.emitida = true;
                      
         COMMENT ON VIEW view_list_orden_despacho_consulta IS 'Vista especial para el módulo de reimpresión de facturas de ordenes de despacho confirmadas';
    "
  end

  def down
  
    execute " 
      DROP VIEW IF EXISTS view_list_orden_despacho_consulta;
    "
  end
end
