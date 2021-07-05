# encoding: utf-8

class CreatePagosCompromisos < ActiveRecord::Migration

  def change

    execute "DROP TABLE if exists pagos_compromiso;
                CREATE TABLE pagos_compromiso
                (
                  id serial NOT NULL,
                  compromiso_pago_id integer NOT NULL,
                  pago_cliente_id integer NOT NULL,
                  pago_prestamo_id integer NOT NULL,
                  CONSTRAINT pagos_compromiso_pkey PRIMARY KEY (id),
                  CONSTRAINT pagos_compromiso_compromiso_pago_id_fkey FOREIGN KEY (pago_cliente_id)
                      REFERENCES pago_cliente (id) MATCH SIMPLE
                      ON UPDATE NO ACTION ON DELETE NO ACTION,
                  CONSTRAINT pagos_compromiso_pago_cliente_id_fkey FOREIGN KEY (pago_cliente_id)
                      REFERENCES pago_cliente (id) MATCH SIMPLE
                      ON UPDATE NO ACTION ON DELETE NO ACTION,
                  CONSTRAINT pagos_compromiso_pago_prestamo_id_fkey FOREIGN KEY (pago_prestamo_id)
                      REFERENCES pago_prestamo (id) MATCH SIMPLE
                      ON UPDATE NO ACTION ON DELETE NO ACTION


                )
                WITH (
                  OIDS=FALSE
                );

                /* Comentarios de tabla y columnas */

                COMMENT ON TABLE pagos_compromiso IS 'Tabla para registrar los pagos de los compromisos de pago';
                COMMENT ON COLUMN pagos_compromiso.id IS 'Clave primaria de la tabla pagos_compromiso';
                COMMENT ON COLUMN pagos_compromiso.compromiso_pago_id IS 'Relación con el compromiso de pago';
                COMMENT ON COLUMN pagos_compromiso.pago_cliente_id IS 'Relación con el pago realizado por el cliente';
                COMMENT ON COLUMN pagos_compromiso.pago_prestamo_id IS 'Relación con el pago realizado por cliente registrado en la tabla pago_prestamo';
                "
  end
end
