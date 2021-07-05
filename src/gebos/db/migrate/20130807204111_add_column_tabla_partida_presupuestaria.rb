# encoding: utf-8

class AddColumnTablaPartidaPresupuestaria < ActiveRecord::Migration
  def up
   execute "
            ALTER TABLE partida_presupuestaria ADD COLUMN plazo_ciclo CHAR(1);        
            COMMENT ON COLUMN partida_presupuestaria.plazo_ciclo IS 'Indica si el finaciamiento resultante será de (C)orto plazo o (L)argo plazo';    
            ALTER TABLE partida_presupuestaria ADD COLUMN programa_id integer;
            COMMENT ON COLUMN partida_presupuestaria.programa_id IS 'Referencia al programa';
    "
  end

  def self.down
  
    execute " 
      ALTER TABLE partida_presupuestaria DROP COLUMN plazo_ciclo;
      ALTER TABLE partida_presupuestaria DROP COLUMN programa_id;
    "
  end
end
