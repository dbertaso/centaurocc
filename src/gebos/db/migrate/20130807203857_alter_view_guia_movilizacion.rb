# encoding: utf-8

class AlterViewGuiaMovilizacion < ActiveRecord::Migration
  def up
    execute "
              DROP VIEW view_liquidacion_maquinaria_equipo;

              CREATE OR REPLACE VIEW view_liquidacion_maquinaria_equipo AS 
               SELECT s.id AS solicitud_id, 
                      s.cliente_id, 
                      s.numero AS numero_tramite, 
                      s.fecha_solicitud, 
                      s.fecha_registro, 
                      s.monto_aprobado, 
                      s.estatus, 
                      s.estatus_id, 
                      s.oficina_id, 
                      s.sector_id, 
                      s.sub_sector_id, 
                      s.rubro_id, 
                      s.por_inventario, 
                      s.conf_maquinaria, 
                      s.sub_rubro_id, 
                      s.actividad_id, 
                      p.id AS prestamo_id, 
                      p.numero AS prestamo_numero, 
                      o.id AS oficina, 
                      o.nombre AS nombre_oficina, 
                      m.id AS municipio, 
                      m.nombre AS municipio_nombre, 
                      e.id AS estado, 
                      e.nombre AS estado_nombre, 
                      est.nombre AS estatus_tramite, 
                      sec.nombre AS nombre_sector, 
                      sub.nombre AS nombre_sub_sector, 
                      r.nombre AS nombre_rubro, 
                      CASE
                          WHEN empresa.nombre IS NULL 
                          THEN ((((((TRIM(persona.primer_nombre)::text) || ' '::text) || TRIM(persona.primer_apellido)::text))))::character varying
                          ELSE empresa.nombre
                      END AS nombre_beneficiario, 
                      CASE
                          WHEN empresa.rif IS NULL 
                          THEN ((persona.cedula_nacionalidad::text || '-'::text) || persona.cedula::character varying::text)::character varying
                          ELSE empresa.rif
                      END AS documento_beneficiario
                 FROM solicitud s
                 JOIN prestamo p ON s.id = p.solicitud_id
                 JOIN cliente ON s.cliente_id = cliente.id
                 LEFT JOIN empresa ON cliente.empresa_id = empresa.id
                 LEFT JOIN persona ON cliente.persona_id = persona.id
                 JOIN oficina o ON o.id = s.oficina_id
                 JOIN municipio m ON m.id = o.municipio_id
                 JOIN estado e ON e.id = m.estado_id
                 JOIN estatus est ON est.id = s.estatus_id
                 JOIN sector sec ON sec.id = s.sector_id
                 JOIN sub_sector sub ON sub.id = s.sub_sector_id
                 JOIN rubro r ON r.id = s.rubro_id;
             "
  end

  def down
  end
end
