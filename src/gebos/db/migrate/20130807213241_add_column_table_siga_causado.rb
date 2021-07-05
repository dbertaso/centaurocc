# encoding: utf-8

class AddColumnTableSigaCausado < ActiveRecord::Migration
  def up

      execute "
    
              ALTER TABLE siga_causado
                  ADD COLUMN cuenta_presupuestaria character varying(20);
                  COMMENT ON COLUMN siga_causado.cuenta_presupuestaria IS 'cuenta presupuestaria';
    
          "
  end
  
  def down
  end
end