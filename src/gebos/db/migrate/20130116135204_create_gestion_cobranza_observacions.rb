# encoding: utf-8

class CreateGestionCobranzaObservacions < ActiveRecord::Migration

  def change

    execute "DROP TABLE if exists gestion_cobranza_observacion;
              CREATE TABLE gestion_cobranza_observacion
              (
                id serial NOT NULL,
                gestion_cobranza_id integer NOT NULL,
                observacion text,
                activo boolean NOT NULL DEFAULT 't',
                CONSTRAINT gestion_cobranza_observacion_pkey PRIMARY KEY (id),
                CONSTRAINT gestion_cobranza_observacion_gestion_cobranza_id_fkey FOREIGN KEY (gestion_cobranza_id)
                    REFERENCES gestion_cobranzas (id) MATCH SIMPLE
                    ON UPDATE NO ACTION ON DELETE NO ACTION
              )
              WITH (
                OIDS=FALSE
              );

              /* Comentarios de tabla y columnas */

              COMMENT ON TABLE gestion_cobranza_observacion IS 'Observaciones sobre gestión de cobranza';
              COMMENT ON COLUMN gestion_cobranza_observacion.id IS 'Clave primaria de la tabla gestion_cobranza_observacion';
              COMMENT ON COLUMN gestion_cobranza_observacion.gestion_cobranza_id IS 'Código de la gestion de cobranza relacionada con la observacion';
              COMMENT ON COLUMN gestion_cobranza_observacion.activo IS 'Indica si el registro esta Activo (True) o Inactivo (false)';
              "
  end
end
