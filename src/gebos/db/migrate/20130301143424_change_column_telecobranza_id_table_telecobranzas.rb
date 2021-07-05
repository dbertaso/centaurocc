class ChangeColumnTelecobranzaIdTableTelecobranzas < ActiveRecord::Migration
  def up

    execute "
      ALTER TABLE compromiso_pago DROP CONSTRAINT compromiso_pago_telecobranza_id_fkey;
      ALTER TABLE compromiso_pago RENAME telecobranza_id  TO telecobranzas_id;
      ALTER TABLE compromiso_pago ADD CONSTRAINT compromiso_pago_telecobranzas_id_fkey FOREIGN KEY (telecobranzas_id) REFERENCES telecobranzas (id) ON UPDATE NO ACTION ON DELETE NO ACTION;

    "
  end

  def down

    execute "
            ALTER TABLE compromiso_pago DROP CONSTRAINT compromiso_pago_telecobranzas_id_fkey;
            ALTER TABLE compromiso_pago RENAME telecobranzas_id  TO telecobranza_id;
            ALTER TABLE compromiso_pago ADD CONSTRAINT compromiso_pago_telecobranza_id_fkey FOREIGN KEY (telecobranza_id) REFERENCES telecobranzas (id) ON UPDATE NO ACTION ON DELETE NO ACTION;
    "
  end
end
