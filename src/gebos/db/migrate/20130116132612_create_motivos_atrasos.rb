# encoding: utf-8

class CreateMotivosAtrasos < ActiveRecord::Migration
  def change
    execute "DROP TABLE if exists motivos_atraso;
              CREATE TABLE motivos_atraso
              (
                id serial NOT NULL,
                descripcion text NOT NULL,
                activo boolean NOT NULL DEFAULT 't',
                CONSTRAINT motivo_atraso_pkey PRIMARY KEY (id)
              )
              WITH (
                OIDS=FALSE
              );

              /* Comentarios de tabla y columnas */

              COMMENT ON TABLE motivos_atraso IS 'Motivos de atraso comunes';
              COMMENT ON COLUMN motivos_atraso.id IS 'Clave primaria de la tabla motivo_atraso';
              COMMENT ON COLUMN motivos_atraso.descripcion IS 'Texto explicativo del motivo de atraso';
              COMMENT ON COLUMN motivos_atraso.activo IS 'Indica si el registro esta Activo (True) o Inactivo (false)';
              "
  end
end
