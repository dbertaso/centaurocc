class ChangeTypeDataColumnsPresupuestoPidan < ActiveRecord::Migration
  def up
  execute "
    
      DROP VIEW IF EXISTS view_consulta_disponibilidad;
      DROP VIEW IF EXISTS view_presupuesto_pidan;
              
      ALTER TABLE presupuesto_transferencia
          ALTER COLUMN monto_transferencia TYPE numeric(16,2);
      
      ALTER TABLE presupuesto_carga
          ALTER COLUMN monto_presupuesto TYPE numeric(16,2);
      
      ALTER TABLE presupuesto_pidan
          ALTER COLUMN disponibilidad TYPE numeric(16,2),
          ALTER COLUMN presupuesto TYPE numeric(16,2),
          ALTER COLUMN compromiso TYPE numeric(16,2);
 
       CREATE OR REPLACE VIEW view_consulta_disponibilidad AS 
       SELECT e.id AS estado_id, r.sector_id, r.sub_sector_id, s.rubro_id, sr.id AS sub_rubro_id, e.nombre AS estado, ( SELECT sec.nombre
                 FROM sector sec
                WHERE sec.id = r.sector_id) AS sector, ( SELECT ssec.nombre
                 FROM sub_sector ssec
                WHERE ssec.id = r.sub_sector_id) AS sub_sector, r.nombre AS rubro, sr.nombre AS sub_rubro, sum(p.monto_insumos + p.monto_banco + p.monto_sras_total + p.monto_gasto_total) AS monto_solicitado, s.estatus_id, count(*) AS contador, 
              CASE
                  WHEN (( SELECT pd.disponibilidad
                     FROM presupuesto_pidan pd
                    WHERE pd.sub_rubro_id = s.sub_rubro_id AND pd.estado_id = e.id)) IS NULL THEN 0
                  ELSE ( SELECT pd.disponibilidad
                     FROM presupuesto_pidan pd
                    WHERE pd.sub_rubro_id = s.sub_rubro_id AND pd.estado_id = e.id)
              END AS disponible, 
              CASE
                  WHEN sum(p.monto_insumos + p.monto_banco + p.monto_sras_total + p.monto_gasto_total) <= (( SELECT pd.disponibilidad
                     FROM presupuesto_pidan pd
                    WHERE pd.sub_rubro_id = s.sub_rubro_id AND pd.estado_id = e.id)) THEN 'block'::text
                  ELSE 'none'::text
              END AS mostrar
         FROM prestamo p, solicitud s, rubro r, unidad_produccion up, municipio m, estado e, sub_rubro sr
        WHERE p.solicitud_id = s.id AND r.id = s.rubro_id AND up.id = s.unidad_produccion_id AND up.municipio_id = m.id AND m.estado_id = e.id AND s.sub_rubro_id = sr.id AND s.estatus_id = 10010
        GROUP BY s.estatus_id, e.nombre, r.nombre, sr.nombre, ( SELECT sec.nombre
                 FROM sector sec
                WHERE sec.id = r.sector_id), ( SELECT ssec.nombre
                 FROM sub_sector ssec
                WHERE ssec.id = r.sub_sector_id), sr.id, r.sector_id, r.sub_sector_id, s.rubro_id, s.sub_rubro_id, e.id
        ORDER BY e.nombre, ( SELECT sec.nombre
                 FROM sector sec
                WHERE sec.id = r.sector_id), ( SELECT ssec.nombre
                 FROM sub_sector ssec
                WHERE ssec.id = r.sub_sector_id), r.nombre, sum(p.monto_insumos + p.monto_banco + p.monto_sras_total + p.monto_gasto_total), count(*);

      CREATE OR REPLACE VIEW view_presupuesto_pidan AS 
       SELECT programa.id AS programa_id, programa.nombre AS programa_nombre, estado.id AS estado_id, estado.nombre AS estado_nombre, sector.id AS sector_id, sector.nombre AS sector_nombre, sub_sector.id AS sub_sector_id, sub_sector.nombre AS sub_sector_nombre, rubro.id AS rubro_id, rubro.nombre AS rubro_nombre, presupuesto_pidan.sub_rubro_id, sub_rubro.nombre AS sub_rubro_nombre, presupuesto_pidan.presupuesto AS monto_presupuesto, presupuesto_pidan.compromiso AS monto_compromiso, presupuesto_pidan.monto_liquidado, presupuesto_pidan.disponibilidad AS monto_disponibilidad
         FROM presupuesto_pidan
         JOIN programa ON programa.id = presupuesto_pidan.programa_id
         JOIN estado ON presupuesto_pidan.estado_id = estado.id
         JOIN rubro ON presupuesto_pidan.rubro_id = rubro.id
         JOIN sub_rubro ON presupuesto_pidan.sub_rubro_id = sub_rubro.id
         JOIN sector ON sector.id = rubro.sector_id
         JOIN sub_sector ON sub_sector.id = rubro.sub_sector_id
        WHERE presupuesto_pidan.presupuesto > 0::numeric
        ORDER BY programa.nombre, estado.nombre, sector.nombre, sub_sector.nombre, rubro.nombre, sub_rubro.nombre;

CREATE OR REPLACE VIEW view_pendiente_por_disponibilidad AS 
 SELECT s.id AS solicitud_id, s.numero, p.nombre AS programa, s.monto_solicitado, s.monto_aprobado AS monto_tramite, 
        CASE
            WHEN pd.id IS NULL THEN 0
            ELSE pd.id
        END AS pidan_id, 
        CASE
            WHEN pd.disponibilidad IS NULL THEN 0.00::numeric(16,2)
            ELSE pd.disponibilidad
        END AS disponibilidad, 
        CASE
            WHEN s.monto_aprobado <= pd.disponibilidad::double precision THEN '1'::text
            ELSE '0'::text
        END AS disponible, s.programa_id, st.nombre AS sector, sb.nombre AS sub_sector, r.nombre AS rubro, sr.nombre AS sub_rubro, a.nombre AS actividad, up.nombre AS unidad_produccion, m.nombre AS municipio, e.id AS estado_id, e.nombre AS estado, s.sector_id, s.sub_sector_id, s.rubro_id, s.sub_rubro_id, s.actividad_id, s.estatus_id, 
        CASE
            WHEN empresa.rif IS NULL THEN ((persona.cedula_nacionalidad::text || '-'::text) || persona.cedula::text)::character varying
            ELSE empresa.rif
        END AS cedula_rif, 
        CASE
            WHEN empresa.nombre IS NULL THEN ((persona.primer_nombre::text || ' '::text) || persona.primer_apellido::text)::character varying
            ELSE empresa.nombre
        END AS productor
   FROM solicitud s
   JOIN programa p ON p.id = s.programa_id
   JOIN sector st ON st.id = s.sector_id
   JOIN sub_sector sb ON sb.id = s.sub_sector_id
   JOIN rubro r ON r.id = s.rubro_id
   JOIN sub_rubro sr ON sr.id = s.sub_rubro_id
   JOIN actividad a ON a.id = s.actividad_id
   JOIN unidad_produccion up ON up.id = s.unidad_produccion_id
   JOIN cliente clie ON clie.id = s.cliente_id
   LEFT JOIN persona ON clie.persona_id = persona.id
   LEFT JOIN empresa ON clie.empresa_id = empresa.id
   JOIN municipio m ON m.id = up.municipio_id
   JOIN estado e ON e.id = m.estado_id
   LEFT JOIN presupuesto_pidan pd ON pd.programa_id = s.programa_id AND pd.rubro_id = s.rubro_id AND pd.sub_rubro_id = s.sub_rubro_id AND pd.estado_id = e.id
  WHERE s.estatus_id = 10010;
         
    "
  end

  def down
    execute "DROP VIEW view_consulta_disponibilidad;"
  end
end
