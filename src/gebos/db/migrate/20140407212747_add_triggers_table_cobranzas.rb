class AddTriggersTableCobranzas < ActiveRecord::Migration
  def up

    execute "

          CREATE TRIGGER log_e_trigger_compromiso_pago
            BEFORE UPDATE OR DELETE
            ON compromiso_pago
            FOR EACH ROW
            EXECUTE PROCEDURE log_transaccion();

          CREATE TRIGGER log_trigger_compromiso_pago
            AFTER INSERT OR UPDATE
            ON compromiso_pago
            FOR EACH ROW
            EXECUTE PROCEDURE log_transaccion();

          CREATE TRIGGER log_e_trigger_performance_cobranzas
            BEFORE UPDATE OR DELETE
            ON performance_cobranzas
            FOR EACH ROW
            EXECUTE PROCEDURE log_transaccion();

          CREATE TRIGGER log_trigger_performance_cobranzas
            AFTER INSERT OR UPDATE
            ON performance_cobranzas
            FOR EACH ROW
            EXECUTE PROCEDURE log_transaccion();

          CREATE TRIGGER log_e_trigger_pagos_compromiso
            BEFORE UPDATE OR DELETE
            ON pagos_compromiso
            FOR EACH ROW
            EXECUTE PROCEDURE log_transaccion();

          CREATE TRIGGER log_trigger_pagos_compromiso
            AFTER INSERT OR UPDATE
            ON pagos_compromiso
            FOR EACH ROW
            EXECUTE PROCEDURE log_transaccion();

    "
  end

  def down
  end
end
