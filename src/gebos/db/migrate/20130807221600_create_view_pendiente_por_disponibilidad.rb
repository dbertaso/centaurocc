# encoding: utf-8

class CreateViewPendientePorDisponibilidad < ActiveRecord::Migration
  def up
    
    execute"

        DROP VIEW if exists view_pendiente_por_disponibilidad;

        CREATE OR REPLACE VIEW view_pendiente_por_disponibilidad AS 
         SELECT 
          s.id AS solicitud_id, 
          s.numero, 
          p.nombre AS programa, 
          s.monto_solicitado, 
          s.monto_aprobado AS monto_tramite, 
          pd.id AS pidan_id, 
          pd.disponibilidad, 
                CASE
                    WHEN s.monto_aprobado <= pd.disponibilidad::double precision THEN '1'::text
                    ELSE '0'::text
                END AS disponible, 
                s.programa_id, 
                st.nombre AS sector, 
                sb.nombre AS sub_sector, 
                r.nombre AS rubro, 
                sr.nombre AS sub_rubro, 
                a.nombre AS actividad, 
                up.nombre AS unidad_produccion, 
                m.nombre AS municipio,
                e.id as estado_id, 
                e.nombre AS estado, 
                s.sector_id, 
                s.sub_sector_id, 
                s.rubro_id, 
                s.sub_rubro_id, 
                s.actividad_id, 
                s.estatus_id, 
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
           JOIN presupuesto_pidan pd ON pd.programa_id = p.id
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
          WHERE pd.rubro_id = s.rubro_id AND pd.sub_rubro_id = s.sub_rubro_id AND pd.estado_id = e.id;

    "
  end

  def down
  end
end
