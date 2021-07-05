class ChangeColumnMotivosAtrasoIdTablaTelecobranzas < ActiveRecord::Migration
  def up

    execute "
      --ALTER TABLE telecobranzas DROP CONSTRAINT telecobranzas_motivos_atraso_id_fkey;

      ALTER TABLE telecobranzas RENAME COLUMN motivo_atraso_id TO motivos_atraso_id;

      ALTER TABLE telecobranzas ADD CONSTRAINT telecobranzas_motivos_atraso_id_fkey FOREIGN KEY (motivos_atraso_id)
      REFERENCES motivos_atraso (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION

      "
  end

  def down

      execute "
      ALTER TABLE telecobranzas DROP CONSTRAINT telecobranzas_motivos_atraso_id_fkey;

      ALTER TABLE telecobranzas RENAME COLUMN motivos_atraso_id TO motivo_atraso_id;

      ALTER TABLE telecobranzas ADD CONSTRAINT telecobranzas_motivos_atraso_id_fkey FOREIGN KEY (motivo_atraso_id)
      REFERENCES motivos_atraso (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION

      "
  end
end
