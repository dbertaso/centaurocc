# encoding: utf-8

class CreateTipoGestionCobranzas < ActiveRecord::Migration
  def change
  execute "DROP TABLE if exists tipo_gestion_cobranza;
            CREATE TABLE tipo_gestion_cobranza
            (
              id serial NOT NULL,
              descripcion text NOT NULL,
              activo boolean NOT NULL DEFAULT 't',
              CONSTRAINT tipo_gestion_cobranza_pkey PRIMARY KEY (id)
            )
            WITH (
              OIDS=FALSE
            );

            /* Comentarios de tabla y columnas */

            COMMENT ON TABLE tipo_gestion_cobranza IS 'Tipos de gestión de cobranzas permitidas por el sistema';
            COMMENT ON COLUMN tipo_gestion_cobranza.id IS 'Clave primaria de la tabla tipo_gestion_cobranza';
            COMMENT ON COLUMN tipo_gestion_cobranza.descripcion IS 'Texto explicativo del tipo de cobranzas a realizar';
            COMMENT ON COLUMN tipo_gestion_cobranza.activo IS 'Indica si el registro esta Activo (True) o Inactivo (false)';"
  end
end
