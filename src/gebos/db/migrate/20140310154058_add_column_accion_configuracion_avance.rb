# encoding: utf-8

class AddColumnAccionConfiguracionAvance < ActiveRecord::Migration

  def change

    execute "

      ALTER TABLE configuracion_avance ADD COLUMN accion text DEFAULT 'avanzar';
      ALTER TABLE configuracion_reverso ADD COLUMN accion text DEFAULT 'reversar';

      COMMENT ON COLUMN configuracion_avance.accion IS 'Acción del controlador que se debe ejecutar al gacer click en el botón avanzar del formulario';
      COMMENT ON COLUMN configuracion_reverso.accion IS 'Acción del controlador que se debe ejecutar al gacer click en el botón reversar del formulario';
    "
  end

end
