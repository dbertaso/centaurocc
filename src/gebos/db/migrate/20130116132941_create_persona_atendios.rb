# encoding: utf-8

class CreatePersonaAtendios < ActiveRecord::Migration

  def change

    execute "DROP TABLE if exists persona_atendio;
            CREATE TABLE persona_atendio
            (
              id serial NOT NULL,
              descripcion text NOT NULL,
              activo boolean NOT NULL DEFAULT 't',
              CONSTRAINT persona_atendio_pkey PRIMARY KEY (id)
            )
            WITH (
              OIDS=FALSE
            );

            /* Comentarios de tabla y columnas */

            COMMENT ON TABLE persona_atendio IS 'Personas que atendieron las llamadas';
            COMMENT ON COLUMN persona_atendio.id IS 'Clave primaria de la tabla persona_atendio';
            COMMENT ON COLUMN persona_atendio.descripcion IS 'Texto explicativo de la persona que atendio la llamada';
            COMMENT ON COLUMN persona_atendio.activo IS 'Indica si el registro esta Activo (True) o Inactivo (false)';
            "
  end

end
