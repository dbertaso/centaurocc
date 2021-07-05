# encoding: utf-8

class CreateTasaConversionMonedas < ActiveRecord::Migration

  def change

    execute "DROP TABLE if exists tasa_conversion_moneda;
                CREATE TABLE tasa_conversion_moneda
                (
                  id serial NOT NULL,
                  moneda_id integer NOT NULL,
                  fecha date NOT NULL,
                  tasa_conversion numeric(16,2) NOT NULL,
                  activo boolean NOT NULL DEFAULT 't',
                  CONSTRAINT tasa_conversion_pkey PRIMARY KEY (id),
                  CONSTRAINT tasa_conversion_moneda_id_fkey FOREIGN KEY (moneda_id)
                      REFERENCES moneda (id) MATCH SIMPLE
                      ON UPDATE NO ACTION ON DELETE NO ACTION


                )
                WITH (
                  OIDS=FALSE
                );

                /* Comentarios de tabla y columnas */

                COMMENT ON TABLE tasa_conversion_moneda IS 'Tabla para registrar la tasa de cambio de moneda';
                COMMENT ON COLUMN tasa_conversion_moneda.id IS 'Clave primaria de la tabla tasa_conversion';
                COMMENT ON COLUMN tasa_conversion_moneda.fecha IS 'Fecha en que ocurrio el cambio';
                COMMENT ON COLUMN tasa_conversion_moneda.tasa_conversion IS 'Valor de conversion de lamoneda';
                COMMENT ON COLUMN tasa_conversion_moneda.activo  IS 'Indica si el registro esta Activo (True) o Inactivo (false)';
                "
  end
end
