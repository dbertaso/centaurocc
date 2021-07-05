# encoding: utf-8

#
# autor: Diego Bertaso
# clase: AddColumnRecaudadorCuentaBvc
# creado con Rails 3
#

class AddColumnRecaudadorCuentaBvc < ActiveRecord::Migration
  def up
  
      execute "
      --ALTER TABLE cuenta_bcv ADD COLUMN recaudador boolean DEFAULT false;
      
      COMMENT ON COLUMN cuenta_bcv.recaudador IS 'Indica si la cuenta es recaudadora';
      
      --ALTER TABLE pago_cliente ADD COLUMN cuenta_bcv_id integer;
        
      COMMENT ON column pago_cliente.cuenta_bcv_id IS 'Id del número de cuenta recaudadora';

    "
  end

  def down
  
      execute "
      ALTER TABLE cuenta_bcv DROP COLUMN;
      ALTER TABLE pago_cliente DROP COLUMN cuenta_bcv_id;
    "
  end
end
