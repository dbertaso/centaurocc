class UpdateVistaViewPrestamosReestructurar < ActiveRecord::Migration
  def change

    execute "

        DROP VIEW if exists view_prestamos_reestructurar;

        CREATE OR REPLACE VIEW view_prestamos_reestructurar AS 
                 SELECT
                        CASE
                            WHEN empresa.nombre IS NULL THEN ((persona.primer_nombre::text || ' '::text) || persona.primer_apellido::text)::character varying
                            ELSE empresa.nombre
                        END AS beneficiario,
                        CASE
                            WHEN empresa.rif IS NULL THEN ((persona.cedula_nacionalidad::text || ' '::text) || persona.cedula::text)::character varying
                            ELSE empresa.rif
                        END AS cedula_rif,
                    p.cliente_id,
                    sum(p.monto_solicitado) AS monto_solicitado,
                    sum(p.deuda) AS deuda,
                    sum(p.saldo_insoluto) - sum(p.capital_pago_parcial) AS saldo_deudor,
                    count(p.numero) AS contador_prestamos,
                    sum(p.capital_vencido) AS capital_vencido,
                    sum(p.interes_vencido) AS interes_vencido,
                    sum(p.capital_vencido) + sum(p.interes_vencido) AS deuda_calculada,
                    0 AS estatus_reestructuracion,
                    NULL::integer AS reestructuracion_id
                   FROM cliente cli
              JOIN prestamo p ON cli.id = p.cliente_id
           LEFT JOIN persona ON cli.persona_id = persona.id
           LEFT JOIN empresa ON cli.empresa_id = empresa.id
          WHERE p.estatus = 'E'::bpchar AND NOT (p.solicitud_id IN ( SELECT rd.solicitud_origen_id
            FROM reestructuracion_detalle rd,
             reestructuracion r
           WHERE r.id = rd.reestructuracion_id AND r.cliente_id = cli.id))
          GROUP BY p.cliente_id,
         CASE
             WHEN empresa.nombre IS NULL THEN ((persona.primer_nombre::text || ' '::text) || persona.primer_apellido::text)::character varying
             ELSE empresa.nombre
         END,
         CASE
             WHEN empresa.rif IS NULL THEN ((persona.cedula_nacionalidad::text || ' '::text) || persona.cedula::text)::character varying
             ELSE empresa.rif
         END
        UNION
                 SELECT
                        CASE
                            WHEN empresa.nombre IS NULL THEN ((persona.primer_nombre::text || ' '::text) || persona.primer_apellido::text)::character varying
                            ELSE empresa.nombre
                        END AS beneficiario,
                        CASE
                            WHEN empresa.rif IS NULL THEN ((persona.cedula_nacionalidad::text || ' '::text) || persona.cedula::text)::character varying
                            ELSE empresa.rif
                        END AS cedula_rif,
                    p.cliente_id,
                    sum(p.monto_solicitado) AS monto_solicitado,
                    sum(p.deuda) AS deuda,
                    sum(p.saldo_insoluto) AS saldo_deudor,
                    count(p.numero) AS contador_prestamos,
                    sum(p.capital_vencido) AS capital_vencido,
                    sum(p.interes_vencido) AS interes_vencido,
                    sum(p.capital_vencido) + sum(p.interes_vencido) AS deuda_calculada,
                    rees.estatus AS estatus_reestructuracion,
                    rees.id AS reestructuracion_id
                   FROM cliente cli
              JOIN prestamo p ON cli.id = p.cliente_id
           LEFT JOIN persona ON cli.persona_id = persona.id
           LEFT JOIN empresa ON cli.empresa_id = empresa.id
           JOIN reestructuracion rees ON cli.id = rees.cliente_id
          WHERE rees.estatus > 0 AND (p.solicitud_id IN ( SELECT rdet.solicitud_origen_id
           FROM reestructuracion_detalle rdet
          WHERE rdet.reestructuracion_id = rees.id))
          GROUP BY p.cliente_id,
        CASE
            WHEN empresa.nombre IS NULL THEN ((persona.primer_nombre::text || ' '::text) || persona.primer_apellido::text)::character varying
            ELSE empresa.nombre
        END,
        CASE
            WHEN empresa.rif IS NULL THEN ((persona.cedula_nacionalidad::text || ' '::text) || persona.cedula::text)::character varying
            ELSE empresa.rif
        END, rees.estatus, rees.id;
    "
  end

end
