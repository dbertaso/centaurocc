# encoding: utf-8

class AddColumnsMonedaSolicitudPrograma < ActiveRecord::Migration
  def up

    execute " ALTER TABLE solicitud ADD COLUMN moneda_id integer NOT NULL DEFAULT 0;
            ALTER TABLE programa ADD COLUMN moneda_id integer NOT NULL DEFAULT 0;

            UPDATE solicitud set moneda_id = (select id from moneda where nombre = 'Bolivar');
            UPDATE programa set moneda_id = (select id from moneda where nombre = 'Bolivar');

            ALTER TABLE solicitud ADD CONSTRAINT solicitud_moneda_id_fkey FOREIGN KEY (moneda_id)
              REFERENCES moneda (id) MATCH SIMPLE
              ON UPDATE NO ACTION ON DELETE NO ACTION;

            ALTER TABLE programa ADD CONSTRAINT programa_moneda_id_fkey FOREIGN KEY (moneda_id)
              REFERENCES moneda (id) MATCH SIMPLE
              ON UPDATE NO ACTION ON DELETE NO ACTION;

            COMMENT ON COLUMN solicitud.moneda_id IS 'Moneda en la cual están expresados los montos de la solicitud';
            COMMENT ON COLUMN programa.moneda_id IS 'Moneda en la cual pueden ser otorgados los montos de la solicitud';
            "
  end

  def down

    execute "ALTER TABLE solicitud DROP COLUMN moneda_id;
            ALTER TABLE programa DROP COLUMN moneda_id;"

  end
end
