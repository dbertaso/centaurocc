# encoding: utf-8

class AddColumnFacturaOrdenDespacho < ActiveRecord::Migration
  def up
    execute "
              ALTER TABLE factura_orden_despacho ADD COLUMN observacion text;
              COMMENT ON COLUMN factura_orden_despacho.observacion IS 'Campo de observación al momento de agregar las facturas';
            "

  end

  def down
  end
end
