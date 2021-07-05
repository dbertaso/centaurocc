# encoding: utf-8

class CreateLlamadaInfructuosas < ActiveRecord::Migration

  def change

    execute "DROP TABLE if exists llamada_infructuosa;
            CREATE TABLE llamada_infructuosa
            (
              id serial NOT NULL,
              descripcion text NOT NULL,
              activo boolean NOT NULL DEFAULT 't',
              CONSTRAINT llamada_infructuosa_pkey PRIMARY KEY (id)
            )
            WITH (
              OIDS=FALSE
            );

            /* Comentarios de tabla y columnas */

            COMMENT ON TABLE llamada_infructuosa IS 'Descripción de llamadas infructuosas';
            COMMENT ON COLUMN llamada_infructuosa.id IS 'Clave primaria de la tabla llamada_infructuosa';
            COMMENT ON COLUMN llamada_infructuosa.descripcion IS 'Texto explicativo de la llamada infructuosa';
            COMMENT ON COLUMN llamada_infructuosa.activo IS 'Indica si el registro esta Activo (True) o Inactivo (false)';
            "
  end

end
