# encoding: utf-8

class CreateGestionCobranzas < ActiveRecord::Migration

  def change

    execute "DROP TABLE if exists gestion_cobranzas;
                CREATE TABLE gestion_cobranzas
                (
                  id serial NOT NULL,
                  analista_cobranza_id integer NOT NULL,
                  prestamo_id integer NOT NULL,
                  fecha_registro date NOT NULL,
                  tipo_gestion_cobranza_id integer NOT NULL,
                  estatus character varying(1) NOT NULL,
                  saldo_insoluto numeric(16,2) NOT NULL DEFAULT 0,
                  deuda numeric(16,2) NOT NULL DEFAULT 0,
                  exigible numeric(16,2) NOT NULL DEFAULT 0,
                  cantidad_cuotas_prestamo integer NOT NULL DEFAULT 0,
                  cantidad_cuotas_vencidas integer NOT NULL DEFAULT 0,
                  monto_capital_vencido numeric(16,2) NOT NULL DEFAULT 0,
                  monto_interes_vencido numeric(16,2) NOT NULL DEFAULT 0,
                  monto_interes_diferido_vencido numeric(16,2) NOT NULL DEFAULT 0,
                  monto_interes_mora numeric(16,2) NOT NULL DEFAULT 0,
                  monto_capital_pagado numeric(16,2) NOT NULL DEFAULT 0,
                  monto_interes_pagado numeric(16,2) NOT NULL DEFAULT 0,
                  monto_interes_diferido_pagado numeric(16,2) NOT NULL DEFAULT 0,
                  monto_interes_mora_pagado numeric(16,2) NOT NULL DEFAULT 0,
                  monto_liquidado numeric(16,2) NOT NULL DEFAULT 0,
                  estatus_prestamo character varying(1) NOT NULL,
                  cantidad_veces_vigente integer NOT NULL DEFAULT 0,
                  cantidad_veces_mora integer NOT NULL DEFAULT 0,
                  cantidad_dias_mora_acumulados integer NOT NULL DEFAULT 0,
                  confirmada boolean DEFAULT 'f',
                  fecha_confirmacion date,
                  hora_confirmacion time(6),
                  activo boolean NOT NULL DEFAULT 't',
                  CONSTRAINT gestion_cobranza_pkey PRIMARY KEY (id),
                  CONSTRAINT gestion_cobranza_analista_cobranza_id_fkey FOREIGN KEY (analista_cobranza_id)
                      REFERENCES analista_cobranzas (id) MATCH SIMPLE
                      ON UPDATE NO ACTION ON DELETE NO ACTION,
                  CONSTRAINT gestion_cobranza_prestamo_id_fkey FOREIGN KEY (prestamo_id)
                      REFERENCES prestamo (id) MATCH SIMPLE
                      ON UPDATE NO ACTION ON DELETE NO ACTION,
                  CONSTRAINT gestion_cobranza_tipo_gestion_cobranza_id_fkey FOREIGN KEY (tipo_gestion_cobranza_id)
                      REFERENCES tipo_gestion_cobranza (id) MATCH SIMPLE
                      ON UPDATE NO ACTION ON DELETE NO ACTION
                )
                WITH (
                  OIDS=FALSE
                );

                /* Comentarios de tabla y columnas */

                COMMENT ON TABLE gestion_cobranzas IS 'Registro de gestiones de cobranzas efectuadas por el analista';
                COMMENT ON COLUMN gestion_cobranzas.id IS 'Clave primaria de la tabla gestion_cobranza';
                COMMENT ON COLUMN gestion_cobranzas.analista_cobranza_id IS 'Clave del analista de cobranza que realiza la gestion de cobro';
                COMMENT ON COLUMN gestion_cobranzas.prestamo_id IS 'Prestamo al que se le esta realizando la gestion de cobranza';
                COMMENT ON COLUMN gestion_cobranzas.fecha_registro IS 'Fecha de inicio de la gestion de cobranza';
                COMMENT ON COLUMN gestion_cobranzas.tipo_gestion_cobranza_id IS 'Indica el tipo de cobranza iniciada (Ver tabla tipo_gestion_cobranza)';
                COMMENT ON COLUMN gestion_cobranzas.estatus IS 'Indica el estatus de la cobranza P=En Proceso, C=Confirmada';
                COMMENT ON COLUMN gestion_cobranzas.saldo_insoluto IS 'Saldo insoluto del prestamo al momento del registro de la gestion de cobranza';
                COMMENT ON COLUMN gestion_cobranzas.deuda IS 'Monto de la Deuda del prestamo al momento del registro de la gestion de cobranza';
                COMMENT ON COLUMN gestion_cobranzas.exigible IS 'Monto Exigible del prestamo al momento del registro de la gestion de cobranza';
                COMMENT ON COLUMN gestion_cobranzas.cantidad_cuotas_prestamo IS 'Número de cuotas totales del prestamo al momento del registro de la gestion de cobranza';
                COMMENT ON COLUMN gestion_cobranzas.cantidad_cuotas_vencidas IS 'Número de cuotas vencidas al momento del registro de la gestion de cobranza';
                COMMENT ON COLUMN gestion_cobranzas.monto_capital_vencido IS 'Monto del capital vencido del prestamo al momento del registro de la gestion de cobranza';
                COMMENT ON COLUMN gestion_cobranzas.monto_interes_vencido IS 'Monto del interes vencido del prestamo al momento del registro de la gestion de cobranza';
                COMMENT ON COLUMN gestion_cobranzas.monto_interes_diferido_vencido IS 'Monto del interes diferido vencido del prestamo al momento del registro de la gestion de cobranza';
                COMMENT ON COLUMN gestion_cobranzas.monto_interes_mora IS 'Monto del interes de mora del prestamo al momento del registro de la gestion de cobranza';
                COMMENT ON COLUMN gestion_cobranzas.monto_capital_pagado IS 'Monto del capital pagado del prestamo al momento del registro de la gestion de cobranza';
                COMMENT ON COLUMN gestion_cobranzas.monto_interes_pagado IS 'Monto del interes pagado del prestamo al momento del registro de la gestion de cobranza';
                COMMENT ON COLUMN gestion_cobranzas.monto_interes_diferido_pagado IS 'Monto del interes pagado vencido del prestamo al momento del registro de la gestion de cobranza';
                COMMENT ON COLUMN gestion_cobranzas.monto_interes_mora_pagado IS 'Monto del interes de mora pagado del prestamo al momento del registro de la gestion de cobranza';
                COMMENT ON COLUMN gestion_cobranzas.monto_liquidado IS 'Monto liquidado del prestamo al  momento del registro de la gestion de cobranza';
                COMMENT ON COLUMN gestion_cobranzas.estatus_prestamo IS 'Estatus del prestamo al momento del registro de la gestion de cobranza';
                COMMENT ON COLUMN gestion_cobranzas.cantidad_veces_vigente IS 'Cantidad de veces que el prestamo estuvo vigente al  momento del registro de la gestion de cobranza';
                COMMENT ON COLUMN gestion_cobranzas.cantidad_veces_mora IS 'Cantidad de veces que el prestamo estuvo moroso al  momento del registro de la gestion de cobranza';
                COMMENT ON COLUMN gestion_cobranzas.cantidad_dias_mora_acumulados IS 'Acumulado de dias en mora del prestamo al  momento del registro de la gestion de cobranza';
                COMMENT ON COLUMN gestion_cobranzas.confirmada IS 'Indica si la gestion fue confirmada (true) o no (false)';
                COMMENT ON COLUMN gestion_cobranzas.fecha_confirmacion IS 'Fecha de confirmacion de la gestiń de cobranza';
                COMMENT ON COLUMN gestion_cobranzas.hora_confirmacion IS 'Hora  de confirmacion de la gestiń de cobranza';"
  end
end
