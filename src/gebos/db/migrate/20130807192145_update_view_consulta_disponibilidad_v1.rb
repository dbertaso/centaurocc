class UpdateViewConsultaDisponibilidadV1 < ActiveRecord::Migration
  def up
  execute "

            DROP VIEW IF EXISTS view_consulta_disponibilidad;

            CREATE OR REPLACE VIEW view_consulta_disponibilidad AS 
             SELECT e.id AS estado_id, 
              r.sector_id, 
              r.sub_sector_id, 
              s.rubro_id, 
              s.programa_id,
              sr.id AS sub_rubro_id, 
              e.nombre AS estado,
              sec.nombre AS sector,
              ssec.nombre  AS sub_sector, 
              r.nombre AS rubro, 
              sr.nombre AS sub_rubro, 
              sum(p.monto_insumos + p.monto_banco + p.monto_sras_total + p.monto_gasto_total) AS monto_solicitado, 
              s.estatus_id, 
              count(*) AS contador, 
                    CASE
                        WHEN (( SELECT pd.disponibilidad
                           FROM presupuesto_pidan pd
                          WHERE pd.programa_id = s.programa_id and pd.sub_rubro_id = s.sub_rubro_id AND pd.estado_id = e.id)) IS NULL THEN 0::numeric
                        ELSE ( SELECT pd.disponibilidad
                           FROM presupuesto_pidan pd
                          WHERE pd.programa_id = s.programa_id and pd.sub_rubro_id = s.sub_rubro_id AND pd.estado_id = e.id)
                    END AS disponible, 
                    CASE
                        WHEN sum(p.monto_insumos + p.monto_banco + p.monto_sras_total + p.monto_gasto_total) <= (( SELECT pd.disponibilidad
                           FROM presupuesto_pidan pd
                          WHERE pd.programa_id = s.programa_id AND pd.sub_rubro_id = s.sub_rubro_id AND pd.estado_id = e.id)) THEN 'block'::text
                        ELSE 'none'::text
                    END AS mostrar
               FROM prestamo p, solicitud s, rubro r, sector sec, sub_sector ssec, unidad_produccion up, municipio m, estado e, sub_rubro sr, programa pr
              WHERE 
              p.solicitud_id = s.id AND 
              s.programa_id = pr.id AND
              r.id = s.rubro_id AND 
              up.id = s.unidad_produccion_id 
              AND up.municipio_id = m.id 
              AND m.estado_id = e.id 
              AND s.sub_rubro_id = sr.id 
              AND s.estatus_id = 10010
              GROUP BY 
              s.estatus_id, 
              s.programa_id, 
              e.nombre, 
              r.nombre, 
              sr.nombre, 
              sec.nombre, 
              ssec.nombre, 
              sr.id, 
              r.sector_id, 
              r.sub_sector_id, 
              s.rubro_id, 
              s.sub_rubro_id, 
              e.id
              ORDER BY 
              e.nombre, 
              sec.nombre, 
              ssec.nombre, 
              r.nombre, 
              sum(p.monto_insumos + p.monto_banco + p.monto_sras_total + p.monto_gasto_total), 
              count(*);   
    
    "
  
  end

  def down
  execute "DROP VIEW view_consulta_disponibilidad;"
  end
end
