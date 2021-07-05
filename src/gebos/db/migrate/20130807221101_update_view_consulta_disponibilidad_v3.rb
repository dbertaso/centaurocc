# encoding: utf-8

class UpdateViewConsultaDisponibilidadV3 < ActiveRecord::Migration
  def up
    
    execute "
    
      DROP VIEW view_consulta_disponibilidad;

      CREATE OR REPLACE VIEW view_consulta_disponibilidad AS 
       SELECT e.id AS estado_id, r.sector_id, r.sub_sector_id, s.rubro_id, s.programa_id, pr.nombre AS programa, sr.id AS sub_rubro_id, e.nombre AS estado, sec.nombre AS sector, ssec.nombre AS sub_sector, r.nombre AS rubro, sr.nombre AS sub_rubro, sum(p.monto_insumos + p.monto_banco + p.monto_sras_total + p.monto_gasto_total) AS monto_solicitado, s.estatus_id, count(*) AS contador, 
              CASE
                  WHEN (( SELECT pd.disponibilidad
                     FROM presupuesto_pidan pd
                    WHERE pd.programa_id = s.programa_id AND pd.sub_rubro_id = s.sub_rubro_id AND pd.estado_id = e.id limit 1)) IS NULL THEN 0::numeric
                  ELSE ( SELECT pd.disponibilidad
                     FROM presupuesto_pidan pd
                    WHERE pd.programa_id = s.programa_id AND pd.sub_rubro_id = s.sub_rubro_id AND pd.estado_id = e.id limit 1)
              END AS disponible, 
              CASE
                  WHEN sum(p.monto_insumos + p.monto_banco + p.monto_sras_total + p.monto_gasto_total) <= (( SELECT pd.disponibilidad
                     FROM presupuesto_pidan pd
                    WHERE pd.programa_id = s.programa_id AND pd.sub_rubro_id = s.sub_rubro_id AND pd.estado_id = e.id limit 1)) THEN 'block'::text
                  ELSE 'none'::text
              END AS mostrar
         FROM prestamo p
         JOIN solicitud s ON s.id = p.solicitud_id
         JOIN programa pr ON pr.id = s.programa_id
         JOIN sector sec ON sec.id = s.sector_id
         JOIN sub_sector ssec ON ssec.id = s.sub_sector_id
         JOIN rubro r ON r.id = s.rubro_id
         JOIN sub_rubro sr ON sr.id = s.sub_rubro_id
         JOIN unidad_produccion up ON up.id = s.unidad_produccion_id
         JOIN municipio m ON m.id = up.municipio_id
         JOIN estado e ON e.id = m.estado_id
        WHERE s.estatus_id = 10010
        GROUP BY s.estatus_id, s.programa_id, pr.nombre, e.nombre, r.nombre, sr.nombre, sec.nombre, ssec.nombre, sr.id, r.sector_id, r.sub_sector_id, s.rubro_id, s.sub_rubro_id, e.id
        ORDER BY e.nombre, sec.nombre, ssec.nombre, r.nombre, sum(p.monto_insumos + p.monto_banco + p.monto_sras_total + p.monto_gasto_total), count(*);
    
    "
  end

  def down
  end
end
