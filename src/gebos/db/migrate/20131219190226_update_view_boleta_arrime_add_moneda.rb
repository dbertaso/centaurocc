class UpdateViewBoletaArrimeAddMoneda < ActiveRecord::Migration
  def up
    execute"
    
-- View: view_boleta_arrime

-- DROP VIEW view_boleta_arrime;

CREATE OR REPLACE VIEW view_boleta_arrime AS 

 SELECT 
	s.numero AS nro_solicitud, 
	s.id AS solicitud_id, 
	pres.numero AS nro_prestamo, 
	pres.id AS prestamo_id, 
	est.nombre AS estado, 
	est.id AS estado_id, 
	mun.nombre AS municipio, 
	mun.id AS municipio_id, 
	clie.id AS cliente_id, 
	tct.clasificacion, 
        CASE
            WHEN empresa.rif IS NULL THEN ((persona.cedula_nacionalidad::text || '-'::text) || persona.cedula::text)::character varying
            ELSE empresa.rif
        END AS cedula_rif, 
        CASE
            WHEN empresa.nombre IS NULL THEN ((persona.primer_nombre::text || ' '::text) || persona.primer_apellido::text)::character varying
            ELSE empresa.nombre
        END AS productor, 
        sec.nombre AS sector, 
        s.sector_id, 
        sub.nombre AS sub_sector, 
        s.sub_sector_id, 
        ru.nombre AS rubro, 
        s.rubro_id, 
        sru.nombre AS sub_rubro, 
        s.sub_rubro_id, 
        a.nombre AS actividad, 
        s.actividad_id, 
        up.nombre AS unidad_produccion, 
        up.id AS unidad_produccion_id, 
        pres.estatus, 
        s.objetivo_proyecto AS proyecto,
        s.moneda_id
   FROM prestamo pres
   JOIN solicitud s ON pres.solicitud_id = s.id
   JOIN unidad_produccion up ON up.id = s.unidad_produccion_id
   JOIN ciudad ciu ON ciu.id = up.ciudad_id
   JOIN estado est ON est.id = ciu.estado_id
   JOIN municipio mun ON mun.id = up.municipio_id
   JOIN cliente clie ON clie.id = s.cliente_id
   JOIN tipo_cliente tct ON tct.id = clie.tipo_cliente_id
   LEFT JOIN persona ON clie.persona_id = persona.id
   LEFT JOIN empresa ON clie.empresa_id = empresa.id
   JOIN sector sec ON sec.id = s.sector_id
   JOIN sub_sector sub ON sub.id = s.sub_sector_id
   JOIN rubro ru ON ru.id = s.rubro_id
   JOIN sub_rubro sru ON sru.id = s.sub_rubro_id
   JOIN actividad a ON a.id = s.actividad_id
   JOIN formato_boleta fb ON fb.actividad_id = s.actividad_id
  WHERE (pres.estatus = ANY (ARRAY['V'::bpchar, 'E'::bpchar, 'C'::bpchar, 'H'::bpchar])) AND fb.status = true;
    
    "
  end

  def down
  end
end
