class AddColumnNombreInstitucionToParametroGeneral < ActiveRecord::Migration
  def change

    execute "

      ALTER TABLE parametro_general ADD COLUMN nombre_institucion text;
      COMMENT ON COLUMN parametro_general.nombre_institucion IS 'Nombre de la institución financiera';

      ALTER TABLE prestamo
        ALTER COLUMN banco_origen DROP DEFAULT;
    "
  end
end
