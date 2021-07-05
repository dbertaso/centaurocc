# encoding: utf-8

class CreateMonedas < ActiveRecord::Migration

  def change

    execute "DROP TABLE if exists moneda;
                CREATE TABLE moneda
                (
                  id serial NOT NULL,
                  nombre text NOT NULL,
                  abreviatura character varying(5) NOT NULL,
                  ruta_icono text,
                  activo boolean NOT NULL DEFAULT 't',
                  CONSTRAINT moneda_pkey PRIMARY KEY (id)


                )
                WITH (
                  OIDS=FALSE
                );

                /* Comentarios de tabla y columnas */

                COMMENT ON TABLE moneda IS 'Tabla para registrar las diferentes monedas usadas por el sistema';
                COMMENT ON COLUMN moneda.id IS 'Clave primaria de la tabla moneda';
                COMMENT ON COLUMN moneda.nombre IS 'Nombre de la moneda (Bolivar, Dolar, Peso, etc.)';
                COMMENT ON COLUMN moneda.abreviatura IS 'Abreviatura de uso comun para la moneda (Bs.,$)';
                COMMENT ON COLUMN moneda.ruta_icono IS 'Ruta donde se encuentra el icono de la moneda';
                COMMENT ON COLUMN moneda.activo  IS 'Indica si el registro esta Activo (True) o Inactivo (false)';

                INSERT INTO moneda (nombre, abreviatura) values ('Bolivar', 'Bs');
                "
  end
end
