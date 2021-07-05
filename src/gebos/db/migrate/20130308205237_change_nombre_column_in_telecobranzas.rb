class ChangeNombreColumnInTelecobranzas < ActiveRecord::Migration
  def up
  
    execute "
    
        ALTER TABLE telecobranzas DROP CONSTRAINT telecobranza_gestion_cobranza_id_fkey;
        
        ALTER TABLE telecobranzas RENAME COLUMN gestion_cobranza_id TO gestion_cobranzas_id;
    
        ALTER TABLE telecobranzas ADD CONSTRAINT telecobranzas_gestion_cobranzas_id_fkey FOREIGN KEY (gestion_cobranzas_id)
      REFERENCES gestion_cobranzas (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;
    "
  end

  def down
  
  
      execute "
    
        ALTER TABLE telecobranzas DROP CONSTRAINT telecobranza_gestion_cobranzas_id_fkey;
        
        ALTER TABLE telecobranzas RENAME COLUMN gestion_cobranzas_id TO gestion_cobranza_id;
    
        ALTER TABLE telecobranzas ADD CONSTRAINT telecobranzas_gestion_cobranza_id_fkey FOREIGN KEY (gestion_cobranza_id)
      REFERENCES gestion_cobranzas (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;
      
    "
  
  end
end
