class AlterViewSolicitud09 < ActiveRecord::Migration
  def up
  	execute "DROP VIEW view_solicitud;

CREATE OR REPLACE VIEW view_solicitud AS 
SELECT so.numero AS numero_solicitud, pr.numero AS numero_prestamo, so.numero_grupo, cj.numero AS numero_empresa, es.nombre AS estado, mu.nombre AS municipio, pa.nombre AS parroquia, ci.nombre AS ciudad, so.monto_solicitado AS monto_solicitud, to_char(so.monto_solicitado, '99,999,999,990.00'::text) AS monto_solicitado, so.monto_solicitado AS monto_solicitado_letras, to_char(so.monto_solicitado * 2::double precision, '99,999,999,990.00'::text) AS monto_garantia, so.monto_solicitado * 2::double precision AS monto_garantia_letras, 
        CASE
            WHEN ptg.monto_fijo is null or ptg.monto_fijo = 0 THEN 1
            ELSE 2
        END AS tipo_gasto, 
        CASE
            WHEN tiposolicitud(so.id::bigint)::text = 'COOP'::text THEN cj.rif::text
            ELSE cn.cedula::text
        END AS identificador_cliente, 
        CASE
            WHEN tiposolicitud(so.id::bigint)::text = 'COOP'::text THEN cj.nombre::text
            ELSE (((((cn.primer_apellido::text || ' '::text) || cn.segundo_apellido::text) || ' '::text) || cn.primer_nombre::text) || ' '::text) || cn.segundo_nombre::text
        END AS nombre_cliente, pg.alias AS plan, pr.plazo, pr.meses_muertos, so.id AS solicitud_id, r.nombre AS rubro, ptg.porcentaje, ptg.monto_fijo
   FROM solicitud so
   JOIN prestamo pr ON so.id = pr.solicitud_id
   LEFT JOIN cliente cl ON so.cliente_id = cl.id
   LEFT JOIN ciudad ci ON so.ciudad_id = ci.id
   LEFT JOIN estado es ON ci.estado_id = es.id
   LEFT JOIN municipio mu ON so.municipio_id = mu.id
   LEFT JOIN parroquia pa ON so.parroquia_id = pa.id
   LEFT JOIN persona cn ON cl.persona_id = cn.id
   LEFT JOIN empresa cj ON cl.empresa_id = cj.id
   LEFT JOIN programa pg ON so.programa_id = pg.id
   JOIN actividad r ON so.actividad_id = r.id
   JOIN programa_tipo_gasto ptg ON ptg.programa_id = so.programa_id AND ptg.tipo_gasto_id = 1
  ORDER BY so.numero, pr.numero"
  end

  def down
  end
end
