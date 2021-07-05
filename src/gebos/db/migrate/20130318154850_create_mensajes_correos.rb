# encoding: utf-8

#
# autor: Diego Bertaso
# clase: CreateMensajesCorreo
# creado con Rails 3
#

class CreateMensajesCorreos < ActiveRecord::Migration
  def change
    create_table :mensajes_correo do |t|
      t.string :nombre
      t.text :descripcion
      t.boolean :activo

    end

    execute "

      COMMENT ON TABLE mensajes_correo IS 'Relación de mensajes de cobranzas para ser enviados por email';

      COMMENT ON COLUMN mensajes_correo.id IS 'Clave principal de la tabla mensajes_correo';
      COMMENT ON COLUMN mensajes_correo.nombre IS 'Nombre para identificar el mensaje';
      COMMENT ON COLUMN mensajes_correo.descripcion IS 'Texto del mensaje a ser enviado por correo';
      COMMENT ON COLUMN mensajes_correo.activo IS 'Indica si el registro esta activo (true) o inactivo (false)';
      "
  end
end
