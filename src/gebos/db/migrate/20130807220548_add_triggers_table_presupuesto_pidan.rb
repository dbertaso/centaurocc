# encoding: utf-8

class AddTriggersTablePresupuestoPidan < ActiveRecord::Migration
  def up
    
     execute "


            CREATE TRIGGER log_e_trigger_presupuesto_pidan
              BEFORE UPDATE OR DELETE
              ON presupuesto_pidan
              FOR EACH ROW
              EXECUTE PROCEDURE log_transaccion();
              
        
            CREATE TRIGGER log_trigger_presupuesto_pidan
              AFTER INSERT OR UPDATE
              ON presupuesto_pidan
              FOR EACH ROW
              EXECUTE PROCEDURE log_transaccion();
    "
  end

  def down
    execute "
    
      DROP TRIGGER log_e_trigger_presupuesto_pidan ON presupuesto_pidan;
      DROP TRIGGER log_trigger_presupuesto_pidan ON presupuesto_pidan;
    "
  end
end
