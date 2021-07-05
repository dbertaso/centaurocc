class CreateViewTotalprestamosprogramaplazo < ActiveRecord::Migration
  def up
  execute "

        DROP VIEW IF EXISTS totalprestamosprogramaplazo;

        CREATE OR REPLACE VIEW totalprestamosprogramaplazo AS 
         SELECT count(prestamo.numero) AS cantidaprestamos, sum(prestamo.capital_vencido) AS cap_vencidopv, sum(prestamo.interes_vencido + prestamo.interes_diferido_vencido) AS int_vencidopv, actividad.plazo_ciclo, programa.id
           FROM solicitud solicitud
           JOIN prestamo prestamo ON solicitud.id = prestamo.solicitud_id
           JOIN actividad ON actividad.id = solicitud.actividad_id
           JOIN programa programa ON programa.id = solicitud.programa_id
          WHERE prestamo.estatus = 'E'::bpchar OR prestamo.estatus = 'P'::bpchar
          GROUP BY programa.id, actividad.plazo_ciclo;    
            
    
    "
  end

  def self.down
  
    execute "
    
      DROP VIEW totalprestamosprogramaplazo;
    "
  end
end
