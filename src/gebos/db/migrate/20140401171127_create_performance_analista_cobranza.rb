# encoding: utf-8
class CreatePerformanceAnalistaCobranza < ActiveRecord::Migration
  def up
  	execute "CREATE TABLE performance_analista_cobranza
(
  id serial NOT NULL, 
  analista_cobranzas_id integer NOT NULL, 
  fecha date,
  cantidad_intentos integer NOT NULL DEFAULT 0, 
  cantidad_contactos integer NOT NULL DEFAULT 0, 
  cantidad_contactos_exitosos integer NOT NULL DEFAULT 0, 
  cantidad_promesas_pago integer NOT NULL DEFAULT 0, 
  porcentaje_contactos numeric(5,2) NOT NULL DEFAULT 0, 
  porcentaje_contactos_exitosos numeric(5,2) NOT NULL DEFAULT 0, 
  porcentaje_promesas_pago numeric(5,2) NOT NULL DEFAULT 0, 
  cantidad_email_enviados integer NOT NULL DEFAULT 0, 
  cantidad_sms_enviados integer NOT NULL DEFAULT 0,
  CONSTRAINT performance_analista_cobranza_pkey PRIMARY KEY (id),
  CONSTRAINT performance_analista_cobranza_analista_cobrazas_id_fkey FOREIGN KEY (analista_cobranzas_id)
      REFERENCES analista_cobranzas (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);

COMMENT ON TABLE performance_analista_cobranza
  IS 'Control de desempeño de la cobranza por analista';
COMMENT ON COLUMN performance_analista_cobranza.id IS 'Clave primaria de la tabla desempeño de la cobranza';
COMMENT ON COLUMN performance_analista_cobranza.analista_cobranzas_id IS 'Clave del analista de cobranza asociado';
COMMENT ON COLUMN performance_analista_cobranza.fecha IS 'fecha de la actividad diaria del analista';
COMMENT ON COLUMN performance_analista_cobranza.cantidad_intentos IS 'Cuenta las llamadas hechas al cliente indepedientemente de que se haya contactado o no';
COMMENT ON COLUMN performance_analista_cobranza.cantidad_contactos IS 'Cuenta las llamadas hechas al cliente que han sido atendidas no necesariamente por este';
COMMENT ON COLUMN performance_analista_cobranza.cantidad_contactos_exitosos IS 'Cuenta las llamadas hechas al cliente que han sido atendidas por este';
COMMENT ON COLUMN performance_analista_cobranza.cantidad_promesas_pago IS 'Cuenta las promesas de pago hechas por el deudor independientemente se hayan cumplido o no';
COMMENT ON COLUMN performance_analista_cobranza.porcentaje_contactos IS 'Mide la eficacia de las llamadas es decir, el porcentaje de recepción de las llamadas en relación a los intentos que se hacen Formula => porcentaje_contactos = cantidad_contactos / cantidad_intentos';
COMMENT ON COLUMN performance_analista_cobranza.porcentaje_contactos_exitosos IS 'Mide la eficiencia de las llamadas es decir, el porcentaje de recepción de las llamadas atentidas por el deudor (contactos exitosos) en relación a los contactos que se hacen Formula => porcentaje_contactos_exitosos = cantidad_contactos_exitosos / cantidad_contactos';
COMMENT ON COLUMN performance_analista_cobranza.porcentaje_promesas_pago IS 'Mide el porcentaje de compromisos establecidos por el deudor (promesas de pago cumplidas) en relación al porcentaje de contactos exitosos Formula => porcentaje_promesas_pago = cantidad_promesas_pago / cantidad_contactos_exitosos';
COMMENT ON COLUMN performance_cobranzas.cantidad_email_enviados IS 'Indica la cantidad de correos electrónicos enviados';
COMMENT ON COLUMN performance_cobranzas.cantidad_sms_enviados IS 'Indica la cantidad de mensajes telefónicos enviados';"
  end

  def down
  end
end
