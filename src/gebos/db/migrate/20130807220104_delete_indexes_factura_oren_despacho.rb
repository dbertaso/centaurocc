# encoding: utf-8

class DeleteIndexesFacturaOrenDespacho < ActiveRecord::Migration
  def up
    
    execute "
              DROP INDEX IF EXISTS idx_factura_orden_despacho_1;
              DROP INDEX IF EXISTS idx_factura_orden_despacho_2;       

        "
  end

  def down
    
    execute "
              DROP INDEX idx_factura_orden_despacho_1;
              DROP INDEX idx_factura_orden_despacho_2;"
  end
  
end
