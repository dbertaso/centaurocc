# encoding: utf-8

class CreateTelecobranzas < ActiveRecord::Migration
  def change

   execute "DROP TABLE if exists telecobranzas;
              CREATE TABLE telecobranzas
              (
                id serial NOT NULL,
                gestion_cobranza_id integer NOT NULL,
                direccion_id integer NOT NULL,
                telefono_id integer NOT NULL,
                senal_compromiso boolean NOT NULL DEFAULT 'f',
                motivo_atraso_id integer NOT NULL,
                persona_atendio_id integer NOT NULL,
                llamada_infructuosa_id integer NOT NULL,
                estatus character varying(1) NOT NULL,
                cantidad_intentos_fallidos integer NOT NULL DEFAULT 0,
                observacion text,
                CONSTRAINT telecobranza_pkey PRIMARY KEY (id),

                CONSTRAINT telecobranza_gestion_cobranza_id_fkey FOREIGN KEY (gestion_cobranza_id)
                    REFERENCES gestion_cobranzas (id) MATCH SIMPLE
                    ON UPDATE NO ACTION ON DELETE NO ACTION,
                CONSTRAINT telecobranza_motivo_atraso_id_fkey FOREIGN KEY (motivo_atraso_id)
                    REFERENCES motivos_atraso (id) MATCH SIMPLE
                    ON UPDATE NO ACTION ON DELETE NO ACTION,
                CONSTRAINT telecobranza_persona_atendio_id_fkey FOREIGN KEY (persona_atendio_id)
                    REFERENCES persona_atendio (id) MATCH SIMPLE
                    ON UPDATE NO ACTION ON DELETE NO ACTION,
                CONSTRAINT telecobranza_llamada_infructuosa_id_fkey FOREIGN KEY (llamada_infructuosa_id)
                    REFERENCES llamada_infructuosa (id) MATCH SIMPLE
                    ON UPDATE NO ACTION ON DELETE NO ACTION  )
                WITH (
                OIDS=FALSE
              );

              /* Comentarios de tabla y columnas */

              COMMENT ON TABLE telecobranzas IS 'Registro de las telecobranzas realizadas por los analistas';
              COMMENT ON COLUMN telecobranzas.id IS 'Clave primaria de la tabla telecobranza';
              COMMENT ON COLUMN telecobranzas.gestion_cobranza_id IS 'Codigo de la gestion de cobranza con la cual esta relacionada la telecobranza';
              COMMENT ON COLUMN telecobranzas.direccion_id IS 'Dirección del cliente en tabla de direcciones';
              COMMENT ON COLUMN telecobranzas.telefono_id IS 'Telefono del cliente en tabla de telefonos';
              COMMENT ON COLUMN telecobranzas.senal_compromiso IS 'Indica si el cliente se comprometio con el pago (true) o no (false)';
              COMMENT ON COLUMN telecobranzas.motivo_atraso_id IS 'Motivo de atraso de los pagos del cliente (tabla motivo_atraso)';
              COMMENT ON COLUMN telecobranzas.persona_atendio_id IS 'Persona que recibio la llamada realizada por el analista (tabla persona_atendio)';
              COMMENT ON COLUMN telecobranzas.llamada_infructuosa_id IS 'Código de llamada infructuosa (no se pudo contactar al cliente) (tabla llamada_infructuosa)';
              COMMENT ON COLUMN telecobranzas.estatus IS 'Indica el estado de la telecobranza C=Cliente contactado; N=Cliente no contactado';
              COMMENT ON COLUMN telecobranzas.cantidad_intentos_fallidos IS 'Cantidad de veces que no se logro contactar al cliente';
              COMMENT ON COLUMN telecobranzas.observacion IS 'Texto libre para observaciones del analista';
             "
  end
end
