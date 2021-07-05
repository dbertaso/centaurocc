# encoding: utf-8

class CreateViewEnvioComprobanteContables < ActiveRecord::Migration
  def change
    execute "

      --DROP VIEW if exist view_envio_comprobante_contable;

      CREATE OR REPLACE VIEW view_envio_comprobante_contable AS 
       SELECT comprobante_contable.id, comprobante_contable.fecha_registro, 
          comprobante_contable.fecha_comprobante, comprobante_contable.fecha_envio, 
          comprobante_contable.referencia, comprobante_contable.factura_id, 
          comprobante_contable.prestamo_id, comprobante_contable.anio, 
          comprobante_contable.transaccion_id, comprobante_contable.total_debe, 
          comprobante_contable.total_haber
         FROM comprobante_contable;
    "
  end
  
end

