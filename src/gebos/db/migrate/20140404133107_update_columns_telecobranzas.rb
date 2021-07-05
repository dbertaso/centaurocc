class UpdateColumnsTelecobranzas < ActiveRecord::Migration
  def change
    execute "

        ALTER TABLE telecobranzas
        ALTER COLUMN motivos_atraso_id DROP NOT NULL;
        ALTER TABLE telecobranzas
        ALTER COLUMN persona_atendio_id DROP NOT NULL;
        ALTER TABLE telecobranzas
          DROP CONSTRAINT telecobranza_llamada_infructuosa_id_fkey;
        ALTER TABLE telecobranzas
          DROP CONSTRAINT telecobranza_motivo_atraso_id_fkey;
        ALTER TABLE telecobranzas
          DROP CONSTRAINT telecobranza_persona_atendio_id_fkey;
        ALTER TABLE telecobranzas
          DROP CONSTRAINT telecobranzas_gestion_cobranzas_id_fkey;
        ALTER TABLE telecobranzas
          DROP CONSTRAINT telecobranzas_motivos_atraso_id_fkey;
        ALTER TABLE telecobranzas
          ADD CONSTRAINT telecobranza_llamada_infructuosa_id_fkey FOREIGN KEY (llamada_infructuosa_id)
              REFERENCES llamada_infructuosa (id) MATCH SIMPLE
              ON UPDATE NO ACTION ON DELETE NO ACTION;
        ALTER TABLE telecobranzas
          ADD CONSTRAINT telecobranza_persona_atendio_id_fkey FOREIGN KEY (persona_atendio_id)
              REFERENCES persona_atendio (id) MATCH SIMPLE
              ON UPDATE NO ACTION ON DELETE NO ACTION;
        ALTER TABLE telecobranzas
          ADD CONSTRAINT telecobranzas_gestion_cobranzas_id_fkey FOREIGN KEY (gestion_cobranzas_id)
              REFERENCES gestion_cobranzas (id) MATCH SIMPLE
              ON UPDATE NO ACTION ON DELETE NO ACTION;
        ALTER TABLE telecobranzas
          ADD CONSTRAINT telecobranzas_motivos_atraso_id_fkey FOREIGN KEY (motivos_atraso_id)
              REFERENCES motivos_atraso (id) MATCH SIMPLE
              ON UPDATE NO ACTION ON DELETE NO ACTION;
    "
  end


end
