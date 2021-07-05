# encoding: utf-8

class CreatePerformanceCobranzas < ActiveRecord::Migration
  def change

    execute "

          ALTER TABLE prestamo DROP COLUMN cantidad_intentos;

          DROP TABLE if exists performance_cobranzas;
                  CREATE TABLE performance_cobranzas
                  (
                    id serial NOT NULL,
                    prestamo_id integer NOT NULL,
                    cliente_id integer NOT NULL,
                    cantidad_intentos integer NOT NULL DEFAULT 0,
                    cantidad_contactos integer NOT NULL DEFAULT 0,
                    cantidad_contactos_exitosos integer NOT NULL DEFAULT 0,
                    cantidad_promesas_pago integer NOT NULL DEFAULT 0,
                    cantidad_promesas_cumplidas integer NOT NULL DEFAULT 0,
                    cantidad_promesas_cumplidas_parcialmente integer NOT NULL DEFAULT 0,
                    cantidad_promesas_incumplidas integer NOT NULL DEFAULT 0,
                    porcentaje_contactos numeric(5,2) NOT NULL DEFAULT 0,
                    porcentaje_contactos_exitosos numeric(5,2) NOT NULL DEFAULT 0,
                    porcentaje_promesas_pago numeric(5,2) NOT NULL DEFAULT 0,
                    porcentaje_promesas_pago_cumplidas numeric(5,2) NOT NULL DEFAULT 0,
                    porcentaje_promesas_pago_incumplidas numeric(5,2) NOT NULL DEFAULT 0,
                    porcentaje_promesas_pago_parcialmente_cumplidas numeric(5,2) NOT NULL DEFAULT 0,
                    cantidad_email_enviados integer NOT NULL DEFAULT 0,
                    cantidad_sms_enviados integer NOT NULL DEFAULT 0,
                    CONSTRAINT performance_cobranzas_pkey PRIMARY KEY (id),

                    CONSTRAINT performance_cobranza_prestamo_id_fkey FOREIGN KEY (prestamo_id)
                        REFERENCES prestamo (id) MATCH SIMPLE
                        ON UPDATE NO ACTION ON DELETE NO ACTION,
                    CONSTRAINT performance_cobranza_cliente_id_fkey FOREIGN KEY (cliente_id)
                        REFERENCES cliente (id) MATCH SIMPLE
                        ON UPDATE NO ACTION ON DELETE NO ACTION)
                    WITH (
                    OIDS=FALSE
                  );

                  /* Comentarios de tabla y columnas */

                  COMMENT ON TABLE performance_cobranzas IS 'Control de desempeño de la cobranza';
                  COMMENT ON COLUMN performance_cobranzas.id IS 'Clave primaria de la tabla desempeño de la cobranza';
                  COMMENT ON COLUMN performance_cobranzas.prestamo_id IS 'Clave del financiamiento asociado';
                  COMMENT ON COLUMN performance_cobranzas.cliente_id IS 'Clave del cliente asociado';
                  COMMENT ON COLUMN performance_cobranzas.cantidad_intentos IS 'Cuenta las llamadas hechas al cliente indepedientemente de que se haya contactado o no';
                  COMMENT ON COLUMN performance_cobranzas.cantidad_contactos IS 'Cuenta las llamadas hechas al cliente que han sido atendidas no necesariamente por este';
                  COMMENT ON COLUMN performance_cobranzas.cantidad_contactos_exitosos IS 'Cuenta las llamadas hechas al cliente que han sido atendidas por este';
                  COMMENT ON COLUMN performance_cobranzas.cantidad_promesas_pago IS 'Cuenta las promesas de pago hechas por el deudor independientemente se hayan cumplido o no';
                  COMMENT ON COLUMN performance_cobranzas.cantidad_promesas_cumplidas IS 'Cuenta las promesas de pago hechas por el deudor que fueron cumplidas satisfactoriamente';
                  COMMENT ON COLUMN performance_cobranzas.cantidad_promesas_cumplidas_parcialmente IS 'Cuenta las promesas de pago hechas por el deudor en el período establecido pero con un monto menor al acordado';
                  COMMENT ON COLUMN performance_cobranzas.cantidad_promesas_incumplidas IS 'Cuenta las promesas de pago que no fueron honradas por el deudor, Se suma al 1 al vencimiento de la promesa (cierre)';
                  COMMENT ON COLUMN performance_cobranzas.porcentaje_contactos IS 'Mide la eficacia de las llamadas es decir, el porcentaje de recepción de las llamadas en relación a los intentos que se hacen Formula => porcentaje_contactos = cantidad_contactos / cantidad_intentos';
                  COMMENT ON COLUMN performance_cobranzas.porcentaje_contactos_exitosos IS 'Mide la eficiencia de las llamadas es decir, el porcentaje de recepción de las llamadas atentidas por el deudor (contactos exitosos) en relación a los contactos que se hacen Formula => porcentaje_contactos_exitosos = cantidad_contactos_exitosos / cantidad_contactos';
                  COMMENT ON COLUMN performance_cobranzas.porcentaje_promesas_pago IS 'Mide el porcentaje de compromisos establecidos por el deudor (promesas de pago cumplidas) en relación al porcentaje de contactos exitosos Formula => porcentaje_promesas_pago = cantidad_promesas_pago / cantidad_contactos_exitosos';
                  COMMENT ON COLUMN performance_cobranzas.porcentaje_promesas_pago_cumplidas IS 'Mide la efectividad de las promesas de pago es decir, el porcentaje de promesas cumplidas Formula => porcentaje_promesas_pago_cumplidas = cantidad_promesas_pago_cumplidas / cantidad_promesas_pago';
                  COMMENT ON COLUMN performance_cobranzas.porcentaje_promesas_pago_incumplidas IS 'Mide la efectividad de las promesas de pago es decir, el porcentaje de promesas cumplidas Formula => porcentaje_promesas_pago_cumplidas = cantidad_promesas_pago_cumplidas / cantidad_promesas_pago';
                  COMMENT ON COLUMN performance_cobranzas.porcentaje_promesas_pago_incumplidas IS 'Mide cuanto representa las promesas no honradas por el deudor => porcentaje_promesas_pago_incumplidas = cantidad_promesas_pago_incumplidas / cantidad_promesas_pago';
                  COMMENT ON COLUMN performance_cobranzas.porcentaje_promesas_pago_parcialmente_cumplidas IS 'Mide cuanto representa las promesas parcialmente honradas por el deudor => porcentaje_promesas_pago_parcialmente cumplidas = cantidad_promesas_pago_parciales / cantidad_promesas_pago';
                  COMMENT ON COLUMN performance_cobranzas.cantidad_email_enviados IS 'Indica la cantidad de correos electrónicos enviados';
                  COMMENT ON COLUMN performance_cobranzas.cantidad_sms_enviados IS 'Indica la cantidad de mensajes telefónicos enviados';
                  "

    end
end
