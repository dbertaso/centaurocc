class ViewGestionarGarantiasV1 < ActiveRecord::Migration
  def up 
    execute"
-- View: view_gestionar_garantias

DROP VIEW IF EXISTS view_gestionar_garantias;

CREATE OR REPLACE VIEW view_gestionar_garantias AS 
 SELECT s.id AS solicitud_id, s.numero, s.monto_solicitado, s.estatus_id, s.liberada, s.usuario_pre_evaluacion, s.consultoria, s.decision_final, s.confirmacion, s.oficina_id, s.sector_id, s.sub_sector_id, s.rubro_id, s.sub_rubro_id, s.actividad_id, 
        CASE
            WHEN e.id IS NULL THEN per.id
            ELSE e.id
        END AS cliente_numero, 
        CASE
            WHEN e.rif IS NULL THEN ((per.cedula_nacionalidad::text || '-'::text) || per.cedula::text)::character varying
            ELSE e.rif
        END AS cedula_rif, 
        CASE
            WHEN e.nombre IS NULL THEN ((per.primer_nombre::text || ' '::text) || per.primer_apellido::text)::character varying
            ELSE e.nombre
        END AS nombre, es.nombre AS estatus, es.const_id, p.nombre AS programa, pr.numero AS financiamiento, est.id AS estado_id, est.nombre AS estado, (u.primer_nombre::text || ' '::text) || u.primer_apellido::text AS usuario, sec.nombre AS sector, sub.nombre AS sub_sector, r.nombre AS rubro, up.nombre AS unidad_produccion, up.municipio_id, up.parroquia_id, m.nombre AS municipio, pa.nombre AS parroquia, sr.nombre AS sub_rubro, a.nombre AS actividad
   FROM solicitud s
   JOIN cliente c ON c.id = s.cliente_id
   LEFT JOIN empresa e ON e.id = c.empresa_id
   LEFT JOIN persona per ON per.id = c.persona_id
   JOIN estatus es ON es.id = s.estatus_id
   JOIN programa p ON p.id = s.programa_id
   LEFT JOIN prestamo pr ON pr.solicitud_id = s.id
   JOIN sector sec ON sec.id = s.sector_id
   JOIN sub_sector sub ON sub.id = s.sub_sector_id
   JOIN rubro r ON r.id = s.rubro_id
   JOIN sub_rubro sr ON sr.id = s.sub_rubro_id
   JOIN actividad a ON a.id = s.actividad_id
   LEFT JOIN unidad_produccion up ON up.id = s.unidad_produccion_id
   LEFT JOIN municipio m ON m.id = up.municipio_id
   LEFT JOIN parroquia pa ON pa.id = up.parroquia_id
   LEFT JOIN estado est ON est.id = m.estado_id
   LEFT JOIN usuario u ON s.usuario_pre_evaluacion::text = u.nombre_usuario::text;




    "
  end

  def down
  end
end
