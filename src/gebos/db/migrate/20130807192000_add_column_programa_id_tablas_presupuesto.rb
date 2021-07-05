class AddColumnProgramaIdTablasPresupuesto < ActiveRecord::Migration
  def up
  execute "
    
      ALTER TABLE presupuesto_pidan ADD COLUMN programa_id integer NOT NULL DEFAULT 0;
      ALTER TABLE presupuesto_carga ADD COLUMN programa_id integer NOT NULL DEFAULT 0;
      
      COMMENT ON COLUMN presupuesto_pidan.programa_id IS 'Campo de enlace para la tabla programa (Foreing Key)';
      COMMENT ON COLUMN presupuesto_carga.programa_id IS 'Campo de enlace para la tabla programa (Foreing Key)'
      
    "
  end

  def down
  
    execute "
    
      ALTER TABLE presupuesto_pidan DROP COLUMN programa_id;
      ALTER TABLE presupuesto_carga DROP COLUMN programa_id;
    
    "
  end
end
