# encoding: utf-8
class ActualizacionVistasOrdenDespacho < ActiveRecord::Migration
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
            WHEN s.estatus_id = 10130 THEN 
            CASE
                WHEN prest.monto_insumos = prest.monto_despachado THEN 'NO VA'::text
                ELSE ''::text
            END
            ELSE ''::text
        END AS no_va, 
        CASE
            WHEN e.rif IS NULL THEN ((p.cedula_nacionalidad::text || ' '::text) || p.cedula::text)::character varying
            ELSE e.rif
        END AS cedula_rif, s.numero, r.nombre AS rubro, es.nombre AS estatus, s.monto_solicitado, pr.nombre AS programa, s.programa_id, su.nombre AS sub_sector, or_des.estatus_id, s.transcriptor, s.oficina_id, se.nombre AS sector, s.sector_id, s.sub_sector_id, s.rubro_id, s.consultoria, mu.nombre AS municipio, pa.nombre AS parroquia, est.nombre AS estado, est.id AS estado_id, 
        CASE
            WHEN cp.nombre IS NULL THEN 'N/A'::character varying
            ELSE cp.nombre
        END AS ciclo, 
        CASE
            WHEN cp.id IS NULL THEN 0
            ELSE cp.id
        END AS ciclo_id, or_des.id AS orden_despacho_id, or_des.fecha_orden_despacho, or_des.monto, acti.id AS actividad_id, sub_r.id AS sub_rubro_id
   FROM cliente c
   LEFT JOIN empresa e ON c.empresa_id = e.id
   LEFT JOIN persona p ON c.persona_id = p.id
   JOIN solicitud s ON s.cliente_id = c.id
   LEFT JOIN prestamo prest ON prest.solicitud_id = s.id
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
   join seguimiento_visita seg_vi on seg_vi.id=or_des.seguimiento_visita_id and seg_vi.confirmada=true
  WHERE (c.empresa_id IS NOT NULL OR c.persona_id IS NOT NULL) AND (s.estatus_id <> ALL (ARRAY[10140, 10150, 10130]));   
  
  
  DROP VIEW if exists view_list_orden_despacho_consulta;
  
  CREATE OR REPLACE VIEW view_list_orden_despacho_consulta AS
  SELECT DISTINCT ON (orden_despacho_id) ode.prestamo_id AS prestamo, cli.id AS cliente_id, fac_or_des.numero_factura, 
        CASE
            WHEN emp.nombre IS NULL THEN ((per.primer_nombre::text || ' '::text) || per.primer_apellido::text)::character varying
            ELSE emp.nombre
        END AS nombre, 
        CASE
            WHEN sol.estatus_id=10130 THEN 
		CASE
		  WHEN prest.monto_insumos = prest.monto_despachado THEN 'NO VA'::text
		  ELSE ''::text
		END
	    ELSE ''::text
        END AS no_va, 
        CASE
            WHEN emp.rif IS NULL THEN ((per.cedula_nacionalidad::text || ' '::text) || per.cedula::text)::character varying
            ELSE emp.rif
        END AS cedula_rif, sol.numero::text AS numero, sol.id AS solicitud_id, ode.id AS orden_despacho_id, r.nombre AS rubro, es.nombre AS estatus, es.id AS estatus_tramite_id, sol.monto_solicitado, su.nombre AS sub_sector, ode.estatus_id, sol.oficina_id, se.nombre AS sector, sol.sector_id, sol.sub_sector_id, sol.rubro_id, seg_vis.codigo_visita, seg_vis.fecha_visita, ode.monto, ode.fecha_orden_despacho AS fecha_orden, acti.id AS actividad_id, sub_r.id AS sub_rubro_id
   FROM factura_orden_despacho fac_or_des
   LEFT JOIN orden_despacho_detalle odsd ON odsd.id = fac_or_des.orden_despacho_detalle_id
   LEFT JOIN orden_despacho ode ON odsd.orden_despacho_id = ode.id
   LEFT JOIN solicitud sol ON ode.solicitud_id = sol.id
   LEFT JOIN prestamo prest ON prest.solicitud_id = sol.id
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
  WHERE fac_or_des.confirmada = true AND fac_or_des.emitida = true and sol.estatus_id not in (10140,10150,10130);
  
  
  
  DROP VIEW if exists view_list_orden_despacho_insumo;
  
  CREATE OR REPLACE VIEW view_list_orden_despacho_insumo AS
  SELECT DISTINCT ON ((sol.numero::text || '^'::text) || fac_or_des.numero_factura::text) ode.prestamo_id AS prestamo, cli.id AS cliente_id, fac_or_des.numero_factura, 
        CASE
            WHEN emp.nombre IS NULL THEN ((per.primer_nombre::text || ' '::text) || per.primer_apellido::text)::character varying
            ELSE emp.nombre
        END AS nombre, 
        CASE
            WHEN emp.rif IS NULL THEN ((per.cedula_nacionalidad::text || ' '::text) || per.cedula::text)::character varying
            ELSE emp.rif
        END AS cedula_rif, sol.numero::text AS numero, sol.id AS solicitud_id, ode.id AS orden_despacho_id, r.nombre AS rubro, es.nombre AS estatus, sol.monto_solicitado, pr.nombre AS programa, su.nombre AS sub_sector, ode.estatus_id, sol.liberada, sol.transcriptor, casa_prov.tipo_cuenta, casa_prov.numero_cuenta, casa_prov.entidad_financiera_id, sol.oficina_id, se.nombre AS sector, sol.sector_id, sol.sub_sector_id, sol.rubro_id, sol.consultoria, mu.nombre AS municipio, pa.nombre AS parroquia, est.nombre AS estado, est.id AS estado_id, ode.monto, fac_or_des.numero_factura AS num_factura, fac_or_des.fecha_factura, ode.fecha_orden_despacho AS fecha_orden, fac_or_des.casa_proveedora_id AS casa_proveedora, casa_prov.tipo_pago AS tipo_pago_casa_proveedora, acti.id AS actividad_id, sub_r.id AS sub_rubro_id, vmtf.monto_total_factura, (sol.numero::text || '^'::text) || fac_or_des.numero_factura::text AS identificador
   FROM factura_orden_despacho fac_or_des
   LEFT JOIN view_monto_total_factura vmtf ON fac_or_des.numero_factura::text = vmtf.numero_factura::text
   JOIN casa_proveedora casa_prov ON casa_prov.id = fac_or_des.casa_proveedora_id
   LEFT JOIN orden_despacho_detalle odsd ON odsd.id = fac_or_des.orden_despacho_detalle_id
   LEFT JOIN orden_despacho ode ON odsd.orden_despacho_id = ode.id AND ode.id = vmtf.orden_despacho_id
   LEFT JOIN solicitud sol ON ode.solicitud_id = sol.id
   JOIN programa pr ON pr.id = sol.programa_id
   JOIN cliente cli ON sol.cliente_id = cli.id
   LEFT JOIN empresa emp ON cli.empresa_id = emp.id
   LEFT JOIN persona per ON cli.persona_id = per.id
   LEFT JOIN cuenta_bancaria cuenta_ban ON cli.id = cuenta_ban.cliente_id
   JOIN estatus es ON es.id = sol.estatus_id
   JOIN sector se ON se.id = sol.sector_id
   JOIN sub_sector su ON su.id = sol.sub_sector_id
   JOIN rubro r ON r.id = sol.rubro_id
   JOIN sub_rubro sub_r ON sol.sub_rubro_id = sub_r.id
   JOIN actividad acti ON sol.actividad_id = acti.id
   JOIN unidad_produccion up ON up.id = sol.unidad_produccion_id
   JOIN municipio mu ON mu.id = up.municipio_id
   JOIN parroquia pa ON pa.id = up.parroquia_id
   JOIN estado est ON est.id = mu.estado_id
  WHERE fac_or_des.confirmada = true AND fac_or_des.emitida = true AND fac_or_des.factura_estatus_id <> 10070 AND (sol.estatus_id = ANY (ARRAY[10090, 10070, 10110, 10100, 10057, 10060]))
  ORDER BY (sol.numero::text || '^'::text) || fac_or_des.numero_factura::text DESC;

  
  
  "
  
  end

  def down
  
  execute "
    
      DROP VIEW view_list_orden_despacho_insumo;
      DROP VIEW view_list_orden_despacho_consulta;
      DROP VIEW view_list_orden_despacho;
    "
  
  end
end