# encoding: utf-8

class CreateRechazoEnvioComprobante < ActiveRecord::Migration
  def change
    create_table :rechazo_envio_comprobante do |t|

      t.date :fecha_comprobante
      t.text :referencia
      t.text :motivo
      t.decimal :total_debe, :precision=>16, :scale=>2
      t.decimal :total_haber, :precision=>16, :scale=>2
      t.integer :numero
      t.integer :usuario_id
      t.date :fecha_proceso    
    end
    execute "

      COMMENT ON TABLE rechazo_envio_comprobante IS 'Registro de Comprobantes rechazados durante el proceso de envío';
      COMMENT ON COLUMN rechazo_envio_comprobante.fecha_comprobante IS 'Fecha de comprobante que no fue enviado';
      COMMENT ON COLUMN rechazo_envio_comprobante.referencia IS 'Referencia del comprobante que no fue enviado';
      COMMENT ON COLUMN rechazo_envio_comprobante.motivo IS 'Motivo por el cual no fue ennviado el comprobante';
      COMMENT ON COLUMN rechazo_envio_comprobante.total_debe IS 'Total del monto de débitos del comprobante no enviado';
      COMMENT ON COLUMN rechazo_envio_comprobante.total_haber IS 'Total del monto de créditos del comprobante no enviado';
      COMMENT ON COLUMN rechazo_envio_comprobante.numero IS 'Numero del Comprobante no enviado';
      COMMENT ON COLUMN rechazo_envio_comprobante.usuario_id IS 'Usuario que realizó el proceso';
      COMMENT ON COLUMN rechazo_envio_comprobante.fecha_proceso IS 'Fecha del proceso';



    "  
  end
end
