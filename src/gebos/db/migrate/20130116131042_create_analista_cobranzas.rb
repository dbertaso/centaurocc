# encoding: utf-8

class CreateAnalistaCobranzas < ActiveRecord::Migration

  def change

    execute "DROP TABLE if exists analista_cobranzas;
              CREATE TABLE analista_cobranzas
              (
                id serial NOT NULL,
                usuario_id integer NOT NULL,
                estatus character varying(1) NOT NULL,
                senal_supervisor boolean NOT NULL DEFAULT 't',
                CONSTRAINT analista_cobranza_pkey PRIMARY KEY (id),
                CONSTRAINT analista_cobranza_usuario_id_fkey FOREIGN KEY (usuario_id)
                    REFERENCES usuario (id) MATCH SIMPLE
                    ON UPDATE NO ACTION ON DELETE NO ACTION

              )
              WITH (
                OIDS=FALSE
              );

              /* Comentarios de tabla y columnas */

              COMMENT ON TABLE analista_cobranzas IS 'Registro de los analista autorizados para realizar gestión de cobranza';
              COMMENT ON COLUMN analista_cobranzas.id IS 'Clave primaria de la tabla analista_cobranza';
              COMMENT ON COLUMN analista_cobranzas.usuario_id IS 'Usuario relacionado con el analista de cobranza';
              COMMENT ON COLUMN analista_cobranzas.estatus IS 'Estatus del analista A=Activo, B=Baja, I=Inactivo';
              COMMENT ON COLUMN analista_cobranzas.senal_supervisor IS 'Indica si el analista es supervisor'; "
  end

end
