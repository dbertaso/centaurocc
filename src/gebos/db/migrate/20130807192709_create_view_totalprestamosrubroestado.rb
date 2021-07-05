class CreateViewTotalprestamosrubroestado < ActiveRecord::Migration
  def up
  execute "

        DROP VIEW IF EXISTS totalprestamosrubroestado;

        CREATE OR REPLACE VIEW totalprestamosrubroestado AS 
         SELECT count(prestamo.numero) AS cantidaprestamos, sum(prestamo.capital_vencido) AS cap_vencidopv, sum(prestamo.interes_vencido + prestamo.interes_diferido_vencido) AS int_vencidopv, rubro.id as rubro_id, estado.id as estado_id
           FROM prestamo prestamo
           JOIN solicitud solicitud ON solicitud.id = prestamo.solicitud_id
           JOIN rubro ON rubro.id = solicitud.rubro_id
           JOIN unidad_produccion up on solicitud.unidad_produccion_id = up.id
           JOIN ciudad on up.ciudad_id = ciudad.id
           JOIN estado ON ciudad.estado_id = estado.id
          WHERE prestamo.estatus = 'E'::bpchar OR prestamo.estatus = 'P'::bpchar
          GROUP BY rubro.id, estado.id
          order by rubro.id, estado.id;    
    
    "
  end

  def self.down
    
    execute " DROP VIEW totalprestamosrubroestado;"
  end
end
