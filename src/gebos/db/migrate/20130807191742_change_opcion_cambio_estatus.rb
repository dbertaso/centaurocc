class ChangeOpcionCambioEstatus < ActiveRecord::Migration
  def up
  execute " 
          update 
                  opcion
          set
                  ruta = 'prestamos/prestamo_cambio_estatus'
          where
                  id = 64;
    "
  end

  def down
  
   execute " 
          update 
                  opcion
          set
                  ruta = 'solicitudes/reestructuracion_cambio_estatus'
          where
                  id = 64;
    "
  end
end
