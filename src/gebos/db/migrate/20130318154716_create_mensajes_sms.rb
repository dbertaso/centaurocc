# encoding: utf-8

#
# autor: Diego Bertaso
# clase: CreateMensajesSms
# creado con Rails 3
#

class CreateMensajesSms < ActiveRecord::Migration
  def change
    create_table :mensajes_sms do |t|
      t.string :nombre
      t.text :descripcion
      t.boolean :activo

    end

    execute "

      COMMENT ON TABLE mensajes_sms IS 'Relación de mensajes de cobranzas para ser enviados por sms';

      COMMENT ON COLUMN mensajes_sms.id IS 'Clave principal de la tabla mensajes_sms';
      COMMENT ON COLUMN mensajes_sms.nombre IS 'Nombre para identificar el mensaje';
      COMMENT ON COLUMN mensajes_sms.descripcion IS 'Texto del mensaje a ser enviado por sms';
      COMMENT ON COLUMN mensajes_sms.activo IS 'Indica si el registro esta activo (true) o inactivo (false)';

    "
  end
end
