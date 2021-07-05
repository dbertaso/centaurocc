# encoding: utf-8

class CreateControlEnvioContabilidad < ActiveRecord::Migration
  def change
    create_table :control_envio_contabilidad do |t|

      t.date :fecha_inicio
      t.date :fecha_fin
      t.text :file_name
      t.decimal :total_debe, :precision=>16, :scale=>2
      t.decimal :total_haber, :precision=>16, :scale=>2
      t.integer :cantidad_envio
      t.decimal :diferencia,  :precision=>16, :scale=>2
      t.integer :usuario_id
      t.date :fecha_proceso
    end

    execute "

      COMMENT ON TABLE control_envio_contabilidad IS 'Registro de Comprobantes enviandos al sistema de contabilidad';
      COMMENT ON COLUMN control_envio_contabilidad.fecha_inicio IS 'Fecha desde la cual se tomaron los comprobantes para enviarlos';
      COMMENT ON COLUMN control_envio_contabilidad.fecha_fin IS 'Fecha hasta la cual se tomaron los comprobantes para enviarlos';
      COMMENT ON COLUMN control_envio_contabilidad.file_name IS 'Nombre del archivo incluyendo la ruta donde se grabaron los comprobantes para enviarlos';
      COMMENT ON COLUMN control_envio_contabilidad.total_debe IS 'Total de los montos de débitos de los comprobantes_enviados';
      COMMENT ON COLUMN control_envio_contabilidad.total_haber IS 'Total de los montos de créditos de los comprobantes_enviados';
      COMMENT ON COLUMN control_envio_contabilidad.cantidad_envio IS 'Cantidad de comprobantes_enviados en el archivo';
      COMMENT ON COLUMN control_envio_contabilidad.diferencia IS 'Diferencia de los montos de crédito y débito enviados en el archivo';
      COMMENT ON COLUMN control_envio_contabilidad.usuario_id IS 'Usuario que realizó el proceso';
      COMMENT ON COLUMN control_envio_contabilidad.fecha_proceso IS 'Fecha del proceso';

    "
  end
end
