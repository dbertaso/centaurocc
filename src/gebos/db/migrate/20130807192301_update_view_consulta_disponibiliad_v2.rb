class UpdateViewConsultaDisponibiliadV2 < ActiveRecord::Migration
  def up
   execute "
      DROP VIEW if exists view_consulta_disponibilidad;

      CREATE OR REPLACE VIEW view_consulta_disponibilidad AS 
       SELECT e.id AS estado_id, 
           r.sector_id, 
           r.sub_sector_id, 
           s.rubro_id, 
           s.programa_id,
           pr.nombre as programa,
           sr.id AS sub_rubro_id, 
           e.nombre AS estado, 
           sec.nombre AS sector, 
           ssec.nombre AS sub_sector, 
           r.nombre AS rubro, 
           sr.nombre AS sub_rubro, 
           sum(p.monto_insumos + p.monto_banco + p.monto_sras_total + p.monto_gasto_total) AS monto_solicitado, 
           s.estatus_id, count(*) AS contador, 
              CASE
                  WHEN (( SELECT pd.disponibilidad
                     FROM presupuesto_pidan pd
                    WHERE pd.programa_id = s.programa_id AND 
              pd.sub_rubro_id = s.sub_rubro_id AND 
              pd.estado_id = e.id)) IS NULL THEN 0::numeric
                  ELSE ( SELECT pd.disponibilidad
                     FROM presupuesto_pidan pd
                    WHERE pd.programa_id = s.programa_id AND pd.sub_rubro_id = s.sub_rubro_id AND pd.estado_id = e.id)
              END AS disponible, 
              CASE
                  WHEN sum(p.monto_insumos + p.monto_banco + p.monto_sras_total + p.monto_gasto_total) <= (( SELECT pd.disponibilidad
                     FROM presupuesto_pidan pd
                    WHERE pd.programa_id = s.programa_id AND 
            pd.sub_rubro_id = s.sub_rubro_id AND 
            pd.estado_id = e.id)) THEN 'block'::text
                  ELSE 'none'::text
              END AS mostrar
         FROM prestamo p
          inner join solicitud s on (s.id = p.solicitud_id)
          inner join programa pr on (pr.id = s.programa_id)
          inner join sector sec on (sec.id = s.sector_id) 
          inner join sub_sector ssec on (ssec.id = s.sub_sector_id)
          inner join rubro r on (r.id = s.rubro_id) 
          inner join sub_rubro sr on (sr.id = s.sub_rubro_id) 
          inner join unidad_produccion up on (up.id = s.unidad_produccion_id) 
          inner join municipio m on (m.id = up.municipio_id) 
          inner join estado e on (e.id = m.estado_id)
         WHERE 
          s.estatus_id = 10010
        GROUP BY s.estatus_id, s.programa_id, pr.nombre, e.nombre, r.nombre, sr.nombre, sec.nombre, ssec.nombre, sr.id, r.sector_id, r.sub_sector_id, s.rubro_id, s.sub_rubro_id, e.id
        ORDER BY e.nombre, sec.nombre, ssec.nombre, r.nombre, sum(p.monto_insumos + p.monto_banco + p.monto_sras_total + p.monto_gasto_total), count(*);

    "
  
  end

  def down
  execute "
      DROP VIEW view_consulta_disponibilidad;"
  end
end
