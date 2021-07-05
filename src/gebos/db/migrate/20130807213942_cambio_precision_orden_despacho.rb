# encoding: utf-8

class CambioPrecisionOrdenDespacho < ActiveRecord::Migration
  def up
    execute "   

              DROP VIEW if exists view_list_orden_despacho;
              
              DROP VIEW if exists view_list_orden_despacho_consulta;
              
              DROP VIEW if exists view_list_orden_despacho_insumo;
              
              DROP VIEW if exists view_list_orden_despacho_rechazo_archivo;   
              
              DROP VIEW if exists view_monto_total_factura;
              
              DROP VIEW if exists orden_despacho_estadisticas;
                                
              ALTER TABLE factura_orden_despacho
              ALTER COLUMN cantidad TYPE numeric(16,2);
               
              ALTER TABLE factura_orden_despacho
              ALTER COLUMN costo_real TYPE numeric(16,2);
               
              ALTER TABLE factura_orden_despacho
              ALTER COLUMN monto_financiamiento TYPE numeric(16,2);
               
              ALTER TABLE factura_orden_despacho
              ALTER COLUMN monto_factura TYPE numeric(16,2);
               
              ALTER TABLE factura_orden_despacho
              ALTER COLUMN cantidad_factura TYPE numeric(16,2);
               
              ALTER TABLE orden_despacho_detalle
              ALTER COLUMN cantidad TYPE numeric(16,2);
                           
              ALTER TABLE orden_despacho_detalle
              ALTER COLUMN costo_real TYPE numeric(16,2);
                        
              ALTER TABLE orden_despacho_detalle
              ALTER COLUMN monto_financiamiento TYPE numeric(16,2);
                        
              ALTER TABLE orden_despacho_detalle
              ALTER COLUMN monto_facturacion TYPE numeric(16,2);
                        
              ALTER TABLE orden_despacho_detalle
              ALTER COLUMN cantidad_facturacion TYPE numeric(16,2);
                        
              ALTER TABLE orden_despacho
              ALTER COLUMN monto TYPE numeric(16,2);
             
                 
              CREATE OR REPLACE VIEW view_monto_total_factura AS 
                SELECT factura_orden_despacho.numero_factura, ode.id AS orden_despacho_id, sum(factura_orden_despacho.monto_factura) AS monto_total_factura
                  FROM 
                        factura_orden_despacho
                          JOIN orden_despacho_detalle odsd ON odsd.id = factura_orden_despacho.orden_despacho_detalle_id
                          JOIN orden_despacho ode ON odsd.orden_despacho_id = ode.id
                  WHERE
                        factura_orden_despacho.numero_factura IS NOT NULL
                  GROUP BY 
                        factura_orden_despacho.numero_factura, ode.id
                  ORDER BY 
                        factura_orden_despacho.numero_factura, ode.id;
              
              
              
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
                      END AS ciclo_id, or_des.id AS orden_despacho_id, or_des.monto, acti.id AS actividad_id, sub_r.id AS sub_rubro_id
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
              
              
              
              CREATE OR REPLACE VIEW view_list_orden_despacho_consulta AS 
               SELECT DISTINCT ON (fac_or_des.numero_factura) s.id AS solicitud_id, 
                      CASE
                          WHEN e.nombre IS NULL THEN ((p.primer_nombre::text || ' '::text) || p.primer_apellido::text)::character varying
                          ELSE e.nombre
                      END AS nombre, 
                      CASE
                          WHEN e.rif IS NULL THEN ((p.cedula_nacionalidad::text || ' '::text) || p.cedula::text)::character varying
                          ELSE e.rif
                      END AS cedula_rif, s.numero, r.nombre AS rubro, es.nombre AS estatus, s.monto_solicitado, pr.nombre AS programa, su.nombre AS sub_sector, or_des.estatus_id, s.liberada, s.transcriptor, s.oficina_id, se.nombre AS sector, s.sector_id, s.sub_sector_id, s.rubro_id, s.consultoria, mu.nombre AS municipio, pa.nombre AS parroquia, est.nombre AS estado, est.id AS estado_id, or_des.id AS orden_despacho_id, or_des.monto, or_des.fecha_orden_despacho, or_des.fecha_cierre, sub_r.id AS sub_rubro_id, acti.id AS actividad_id, fac_or_des.casa_proveedora_id
                 FROM cliente c
                 LEFT JOIN empresa e ON c.empresa_id = e.id
                 LEFT JOIN persona p ON c.persona_id = p.id
                 JOIN solicitud s ON s.cliente_id = c.id
                 JOIN estatus es ON es.id = s.estatus_id
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
                 JOIN oficina ofi ON ofi.id = s.oficina_id
                 JOIN orden_despacho or_des ON s.id = or_des.solicitud_id
                 JOIN factura_orden_despacho fac_or_des ON fac_or_des.confirmada = true AND fac_or_des.emitida = true
                 JOIN casa_proveedora casa_prov ON casa_prov.id = fac_or_des.casa_proveedora_id
                WHERE c.empresa_id IS NOT NULL OR c.persona_id IS NOT NULL
                ORDER BY fac_or_des.numero_factura DESC;
                
                
                
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
                
                
                
                CREATE OR REPLACE VIEW view_list_orden_despacho_rechazo_archivo AS 
                       SELECT historico_liquidacion_casa_proveedora.archivo AS archivo_historico, historico_liquidacion_casa_proveedora.solicitud_id, historico_liquidacion_casa_proveedora.numero_factura AS numero_historico, historico_liquidacion_casa_proveedora.casa_proveedora_id AS casa_historico, historico_liquidacion_casa_proveedora.fecha_liquidacion, historico_liquidacion_casa_proveedora.monto_liquidacion, historico_liquidacion_casa_proveedora.numero_cuenta_liquidadora, historico_liquidacion_casa_proveedora.numero_cuenta_casa_proveedora
                         FROM historico_liquidacion_casa_proveedora
              UNION ALL 
                       SELECT rechazo_liquidacion_casa_proveedora.archivo AS archivo_historico, rechazo_liquidacion_casa_proveedora.solicitud_numero AS solicitud_id, rechazo_liquidacion_casa_proveedora.numero_factura AS numero_historico, rechazo_liquidacion_casa_proveedora.casa_proveedora_id AS casa_historico, rechazo_liquidacion_casa_proveedora.fecha AS fecha_liquidacion, rechazo_liquidacion_casa_proveedora.monto_pago AS monto_liquidacion, rechazo_liquidacion_casa_proveedora.codigo_error AS numero_cuenta_liquidadora, rechazo_liquidacion_casa_proveedora.descripcion_error AS numero_cuenta_casa_proveedora
                         FROM rechazo_liquidacion_casa_proveedora;
                         
   "
  end

  def down
  end
end
