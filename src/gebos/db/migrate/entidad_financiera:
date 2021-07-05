class MaquinariaNuevaRuta < ActiveRecord::Migration
  def up
    execute "CREATE TABLE proforma
(
  id serial NOT NULL,
  numero character varying(30) NOT NULL,
  fecha_emision date NOT NULL,
  fecha_caduca date NOT NULL,
  usuario_id integer NOT NULL,
  solicitud_id integer NOT NULL,
  casa_proveedora_id integer,
  CONSTRAINT proforma_pk PRIMARY KEY (id),
  CONSTRAINT casa_proveedora_fk FOREIGN KEY (casa_proveedora_id)
      REFERENCES casa_proveedora (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT solicitud_fk FOREIGN KEY (solicitud_id)
      REFERENCES solicitud (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT usuario_fk FOREIGN KEY (usuario_id)
      REFERENCES usuario (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);

ALTER TABLE solicitud_maquinaria DROP COLUMN descripcion;
ALTER TABLE solicitud_maquinaria ADD COLUMN marca_maquinaria_id integer;
ALTER TABLE solicitud_maquinaria ADD COLUMN modelo_id integer;
ALTER TABLE solicitud_maquinaria ADD COLUMN catalogo_id integer;
ALTER TABLE solicitud_maquinaria ADD COLUMN proforma_id integer;
ALTER TABLE solicitud_maquinaria ADD COLUMN estatus character varying(1);
ALTER TABLE solicitud_maquinaria ADD COLUMN serial_motor character varying(50);
ALTER TABLE solicitud_maquinaria ADD COLUMN serial_chasis character varying(50);
ALTER TABLE solicitud_maquinaria ADD COLUMN costo double precision;
ALTER TABLE solicitud_maquinaria ADD CONSTRAINT marca_maquinaria_fk FOREIGN KEY (marca_maquinaria_id) REFERENCES marca_maquinaria (id) ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE solicitud_maquinaria ADD CONSTRAINT modelo_fk FOREIGN KEY (modelo_id) REFERENCES modelo (id) ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE solicitud_maquinaria ADD CONSTRAINT catalogo_fk FOREIGN KEY (catalogo_id) REFERENCES catalogo (id) ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE solicitud_maquinaria ADD CONSTRAINT proforma_fk FOREIGN KEY (proforma_id) REFERENCES proforma (id) ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE plan_inversion ADD COLUMN serial_motor character varying(50);
ALTER TABLE plan_inversion ADD COLUMN serial_chasis character varying(50);
ALTER TABLE plan_inversion ADD COLUMN casa_proveedora_id integer;
ALTER TABLE plan_inversion ADD CONSTRAINT casa_proveedora_fk FOREIGN KEY (casa_proveedora_id) REFERENCES casa_proveedora (id) ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE orden_despacho ADD COLUMN casa_proveedora_id integer;
ALTER TABLE orden_despacho ADD CONSTRAINT casa_proveedora_fk FOREIGN KEY (casa_proveedora_id) REFERENCES casa_proveedora (id) ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE stock_maquinaria ADD COLUMN indicador character varying(1);

CREATE OR REPLACE VIEW view_asignar_maquinaria AS 
         SELECT s.id AS solicitud_id, s.numero, (p.primer_nombre::text || ' '::text) || p.primer_apellido::text AS beneficiario, p.cedula || ''::text AS cedula_rif, es.nombre::text AS estatus, e.nombre AS estado, m.nombre AS municipio, pa.nombre AS parroquia, u.nombre AS unidad_produccion, u.municipio_id, m.estado_id, u.parroquia_id
           FROM solicitud s
      JOIN estatus es ON es.id = s.estatus_id AND es.const_id::text = 'ST0006'::text
   JOIN cliente c ON c.id = s.cliente_id
   JOIN persona p ON p.id = c.persona_id
   JOIN unidad_produccion u ON u.id = s.unidad_produccion_id
   JOIN municipio m ON m.id = u.municipio_id
   JOIN estado e ON e.id = m.estado_id
   JOIN parroquia pa ON pa.id = u.parroquia_id
   JOIN sub_sector ss ON ss.id = s.sub_sector_id AND ss.nemonico::text = 'MA'::text
UNION 
         SELECT s.id AS solicitud_id, s.numero, em.nombre AS beneficiario, em.rif AS cedula_rif, es.nombre::text AS estatus, e.nombre AS estado, m.nombre AS municipio, pa.nombre AS parroquia, u.nombre AS unidad_produccion, u.municipio_id, m.estado_id, u.parroquia_id
           FROM solicitud s
      JOIN estatus es ON es.id = s.estatus_id AND es.const_id::text = 'ST0006'::text
   JOIN cliente c ON c.id = s.cliente_id
   JOIN empresa em ON em.id = c.empresa_id
   JOIN unidad_produccion u ON u.id = s.unidad_produccion_id
   JOIN municipio m ON m.id = u.municipio_id
   JOIN estado e ON e.id = m.estado_id
   JOIN parroquia pa ON pa.id = u.parroquia_id
   JOIN sub_sector ss ON ss.id = s.sub_sector_id AND ss.nemonico::text = 'MA'::text;

CREATE OR REPLACE VIEW view_datos_maquinaria AS 
 SELECT c.id, c.descripcion, c.chasis, c.serial, c.monto, p.nombre AS pais, m.nombre AS modelo,
	mm.nombre AS marca, cl.nombre AS clase, gmm.solicitud_id,
	gmm.id AS guia_movilizacion_maquinaria_id
   FROM catalogo c
   JOIN guia_catalogo gc ON gc.catalogo_id = c.id
   JOIN guia_movilizacion_maquinaria gmm ON gc.guia_movilizacion_maquinaria_id = gmm.id
   JOIN clase cl ON c.clase_id = cl.id
   JOIN marca_maquinaria mm ON c.marca_maquinaria_id = mm.id
   JOIN modelo m ON c.modelo_id = m.id
   LEFT JOIN pais p ON c.pais_id = p.id;

CREATE OR REPLACE VIEW view_envio_maquinaria AS 
 SELECT DISTINCT s.id AS solicitud_id, s.numero AS nro_tramite, s.unidad_produccion_id, s.estatus_id, clie.id AS cliente_id, s.por_inventario, s.fecha_solicitud, s.oficina_id, 
        CASE
            WHEN empresa.rif IS NULL THEN ((persona.cedula_nacionalidad::text || '-'::text) || persona.cedula::text)::character varying
            ELSE empresa.rif
        END AS cedula_rif, 
        CASE
            WHEN empresa.nombre IS NULL THEN ((persona.primer_nombre::text || ' '::text) || persona.primer_apellido::text)::character varying
            ELSE empresa.nombre
        END AS productor, up.nombre AS unidad_produccion, up.direccion AS unidad_produccion_direccion, est.nombre AS estado, est.id AS estado_id, mun.nombre AS municipio, mun.id AS municipio_id, par.id AS parroquia_id, par.nombre AS parroquia, st.nombre AS estatus, (ofi.primer_nombre_supervisor::text || ' '::text) || ofi.primer_apellido_supervisor::text AS encargado, 
        CASE
            WHEN (( SELECT DISTINCT empresa_telefono.id
               FROM empresa_telefono
              WHERE empresa_telefono.empresa_id = empresa.id)) IS NULL THEN ((( SELECT (persona_telefono.codigo::text || '-'::text) || persona_telefono.numero::text AS telefono
               FROM persona_telefono
              WHERE persona_telefono.persona_id = persona.id
             LIMIT 1))::character varying)::text
            ELSE ( SELECT DISTINCT (empresa_telefono.codigo::text || '-'::text) || empresa_telefono.numero::text AS telefono
               FROM empresa_telefono
              WHERE empresa_telefono.empresa_id = empresa.id
             LIMIT 1)
        END AS telefono, 
        CASE
            WHEN s.estatus_id = 10040 THEN true
            WHEN s.estatus_id = 10095 THEN true
            WHEN s.estatus_id = 10048 THEN true
            WHEN s.estatus_id = 10090 THEN true
            ELSE false
        END AS estatus_solicitud
   FROM solicitud s
   JOIN unidad_produccion up ON up.id = s.unidad_produccion_id
   JOIN municipio mun ON mun.id = up.municipio_id
   JOIN estado est ON est.id = mun.estado_id
   JOIN parroquia par ON par.id = up.parroquia_id
   JOIN cliente clie ON clie.id = s.cliente_id
   LEFT JOIN persona ON clie.persona_id = persona.id
   LEFT JOIN empresa ON clie.empresa_id = empresa.id
   JOIN estatus st ON s.estatus_id = st.id
   JOIN oficina ofi ON s.oficina_id = ofi.id
  WHERE (s.estatus_id = ANY (ARRAY[10040, 10095, 10048, 10090])) AND (s.id IN ( SELECT solicitud_maquinaria.solicitud_id
   FROM solicitud_maquinaria
  WHERE solicitud_maquinaria.estatus::text = 'I'::text))
  ORDER BY s.estatus_id;


CREATE OR REPLACE VIEW view_guia_movilizacion AS 
 SELECT gmm.id AS guia_movilizacion_maquinaria_id, gmm.fecha_emision, gmm.fecha_estimada, gmm.solicitud_id, gmm.destino, gmm.numero_guia, 
        CASE
            WHEN empresa.rif IS NULL THEN ((persona.cedula_nacionalidad::text || '-'::text) || persona.cedula::text)::character varying
            ELSE empresa.rif
        END AS cedula_rif, 
        CASE
            WHEN empresa.nombre IS NULL THEN ((persona.primer_nombre::text || ' '::text) || persona.primer_apellido::text)::character varying
            ELSE empresa.nombre
        END AS productor, 
        CASE
            WHEN gmm.destino::text = 'F'::text THEN ('Oficina '::text || ' '::text) || of.nombre::text
            WHEN gmm.destino::text = 'U'::text THEN up.nombre::text
            WHEN gmm.destino::text = 'O'::text THEN ('Evento'::text || ' '::text) || gmm.evento::text
            ELSE NULL::text
        END AS nombre_destino, gmm.estatus, gmm.unidad_produccion_id, up.nombre AS nombre_unidad_produccion, 
        CASE
            WHEN s.estatus_id = 10040 THEN true
            WHEN s.estatus_id = 10095 THEN true
            WHEN s.estatus_id = 10048 THEN true
            WHEN s.estatus_id = 10090 THEN true
            ELSE false
        END AS estatus_solicitud, (ofi.primer_nombre_supervisor::text || ' '::text) || ofi.primer_apellido_supervisor::text AS encargado
   FROM guia_movilizacion_maquinaria gmm
   JOIN solicitud s ON s.id = gmm.solicitud_id
   LEFT JOIN oficina of ON of.id = gmm.oficina_id
   LEFT JOIN unidad_produccion up ON up.id = gmm.unidad_produccion_id
   JOIN cliente clie ON clie.id = s.cliente_id
   LEFT JOIN persona ON clie.persona_id = persona.id
   LEFT JOIN empresa ON clie.empresa_id = empresa.id
   JOIN oficina ofi ON s.oficina_id = ofi.id;"
  end

  def down
  end
end
