# encoding: utf-8

class CreateCompromisoPagos < ActiveRecord::Migration

  def change

    execute "DROP TABLE if exists compromiso_pago;
                CREATE TABLE compromiso_pago
                (
                  id serial NOT NULL,
                  telecobranza_id integer NOT NULL,
                  prestamo_id integer NOT NULL,
                  fecha_pago date NOT NULL,
                  hora_pago time NOT NULL,
                  fecha_limite_pago date NOT NULL,
                  senal_rango_gracia integer NOT NULL,
                  monto_pago numeric(16,2) NOT NULL,
                  estatus character varying(1) NOT NULL,
                  observacion text,
                  CONSTRAINT compromiso_pago_pkey PRIMARY KEY (id),
                  CONSTRAINT compromiso_pago_telecobranza_id_fkey FOREIGN KEY (telecobranza_id)
                      REFERENCES telecobranzas (id) MATCH SIMPLE
                      ON UPDATE NO ACTION ON DELETE NO ACTION,
                  CONSTRAINT compromiso_pago_prestamo_id_fkey FOREIGN KEY (prestamo_id)
                      REFERENCES prestamo (id) MATCH SIMPLE
                      ON UPDATE NO ACTION ON DELETE NO ACTION
                  )
                  WITH (
                  OIDS=FALSE
                );

                /* Comentarios de tabla y columnas */

                COMMENT ON TABLE compromiso_pago IS 'Registro de las compromiso de pago realizados por los analistas';
                COMMENT ON COLUMN compromiso_pago.id IS 'Clave primaria de la tabla compromiso_pago';
                COMMENT ON COLUMN compromiso_pago.telecobranza_id IS 'Codigo de la telecobranza con la cual esta relacionada la tabla de la telecobranza';
                COMMENT ON COLUMN compromiso_pago.prestamo_id IS 'Código del prestamo con el cual esta relacionado la telecobranza';
                COMMENT ON COLUMN compromiso_pago.fecha_pago IS 'Fecha en la cual el cliente de comprometio a realizar el pago';
                COMMENT ON COLUMN compromiso_pago.hora_pago IS 'Hora en la cual el cliete se comprometio a realizar el pago';
                COMMENT ON COLUMN compromiso_pago.fecha_limite_pago IS 'Fecha maxima para realizar el pago (fecha_pago + dias de gracia)';
                COMMENT ON COLUMN compromiso_pago.senal_rango_gracia IS 'Senal que indica en el rango que se realizo el pago  S=La fecha del Compromiso de Pago está dentro del Rango de Gracia establecido, N=la Fecha del compromiso de Pago está fuera del Rango de Gracia establecido';
                COMMENT ON COLUMN compromiso_pago.monto_pago IS 'Monto del pago que el cliente se comprometio a pagar';
                COMMENT ON COLUMN compromiso_pago.estatus IS 'E= En espera de cumplimiento de Fecha (estatus por default cuando se crea el Compromiso, A= Cumplido antes del Vencimiento del Compromiso, V= Cumplido en la Fecha del compromiso, R=Cumplido dentro del rango de gracia, N=No Cumplido (No hay pagos registrados en el sistema hasta la Fecha límite del compromiso)). NOTA IMPORTANTE: El Proceso de Pago de Cuota debe actualizar los estatus  (A,V,R). El estatus “N” lo actualiza el Cierre Especial de Cobranza conjuntamente con el campo Cantidad de Compromisos de Pago Incumplidos que está en el Préstamo.';
                COMMENT ON COLUMN compromiso_pago.observacion IS 'Texto libre para observaciones del analista';
               "
  end
end
