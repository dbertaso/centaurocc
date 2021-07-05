class AddColumnasVariasBoletaArrime < ActiveRecord::Migration
  def up
  execute "
    
    DROP VIEW if exists view_excedente_arrime;

    CREATE OR REPLACE VIEW view_excedente_arrime AS 
     SELECT s.oficina_id, 
            CASE
                WHEN empresa.nombre IS NULL THEN ((persona.primer_nombre::text || ' '::text) || persona.primer_apellido::text)::character varying
                ELSE empresa.nombre
            END AS beneficiario, 
            CASE
                WHEN empresa.nombre IS NULL THEN persona_email.email
                ELSE empresa_email.email
            END AS email, 
            CASE
                WHEN empresa.rif IS NULL THEN ((persona.cedula_nacionalidad::text || ' '::text) || persona.cedula::text)::character varying
                ELSE empresa.rif
            END AS cedula_rif, s.id AS solicitud_id, s.numero AS nro_tramite, s.unidad_produccion_id, uni.ciudad_id, ciu.nombre AS ciudad, ciu.estado_id, est.nombre AS estado, sect.id AS sector_id, sect.nombre AS sector, rub.nombre AS rubro, s.rubro_id, s.estatus_id AS estatus, pres.monto_banco, pres.monto_liquidado, pres.id AS prestamo_id, pres.numero AS nro_prestamo, aexa.id AS orden_abono_excedente_arrime_id, aexa.monto_abono, aexa.estatus_id AS estatus_excedente, aexa.fecha_envio, aexa.fecha_envio_banco, aexa.fecha_valor, aexa.fecha_abono_cuenta, aexa.tipo_cheque, aexa.referencia, aexa.fecha_registro_cheque, cta.tipo, cta.numero AS numero_cuenta, ent.nombre AS banco, ent.cod_swift, ent.id AS entidad_financiera_id, sub_rub.nombre AS sub_rubro, sub_rub.id AS sub_rubro_id, acti.nombre AS actividad, acti.id AS actividad_id, sub_sec.id AS sub_sector_id
       FROM orden_abono_excedente_arrime aexa
       INNER JOIN solicitud s ON s.id = aexa.solicitud_id
       JOIN prestamo pres ON pres.solicitud_id = s.id  
       INNER JOIN cliente cli ON cli.id = s.cliente_id
       LEFT JOIN cuenta_bancaria cta ON cta.cliente_id = cli.id
       LEFT JOIN entidad_financiera ent ON cta.entidad_financiera_id = ent.id
       LEFT JOIN persona ON cli.persona_id = persona.id
       LEFT JOIN empresa ON cli.empresa_id = empresa.id
       LEFT JOIN persona_email ON cli.persona_id = persona.id AND persona_email.persona_id = persona.id AND persona_email.tipo = 'P'::bpchar
       LEFT JOIN empresa_email ON cli.empresa_id = empresa.id AND empresa_email.empresa_id = empresa.id AND empresa_email.tipo = 'P'::bpchar
       JOIN oficina ofi ON ofi.id = s.oficina_id
       JOIN sector sect ON sect.id = s.sector_id
       JOIN sub_sector sub_sec ON sub_sec.id = s.sub_sector_id
       JOIN rubro rub ON rub.id = s.rubro_id
       JOIN sub_rubro sub_rub ON sub_rub.id = s.sub_rubro_id
       JOIN actividad acti ON acti.id = s.actividad_id
       JOIN unidad_produccion uni ON uni.id = s.unidad_produccion_id
       JOIN ciudad ciu ON ciu.id = uni.ciudad_id
       JOIN estado est ON est.id = ciu.estado_id;
    
    "
  end

  def down
   execute "DROP VIEW view_excedente_arrime;"
  end
end
