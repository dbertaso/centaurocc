class AddRecordMetaTransaccion < ActiveRecord::Migration
  def up
  execute "
      INSERT INTO meta_transaccion (nombre, descripcion) VALUES ('p_confirmacion_boleta', 'Transaccion de confirmacion de la boleta de arrime');
    "
  end

  def down
  execute "
      DELETE FROM meta_transaccion WHERE nombre = 'p_confirmacion_boleta';
    "
  end
end
