# encoding: utf-8

class CreateViewEnvioAsientoContables < ActiveRecord::Migration
  
  def change
    execute "

        --DROP VIEW IF EXISTS view_envio_asiento_contable;

        CREATE OR REPLACE VIEW view_envio_asiento_contable AS 
         SELECT asiento_contable.comprobante_contable_id, asiento_contable.monto, 
            asiento_contable.tipo, asiento_contable.codigo_contable, 
            asiento_contable.auxiliar_contable
           FROM asiento_contable;
    "
  end
end
