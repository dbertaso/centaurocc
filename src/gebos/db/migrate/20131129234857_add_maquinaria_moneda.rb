# encoding: utf-8
class AddMaquinariaMoneda < ActiveRecord::Migration
  def up
    execute "ALTER TABLE configurador
               ADD COLUMN moneda_id integer;
             ALTER TABLE configurador
               ADD CONSTRAINT modeda_fk FOREIGN KEY (moneda_id) REFERENCES moneda (id) ON UPDATE NO ACTION ON DELETE NO ACTION;
             ALTER TABLE catalogo
               ADD COLUMN moneda_id integer;
             ALTER TABLE catalogo
               ADD CONSTRAINT modeda_fk FOREIGN KEY (moneda_id) REFERENCES moneda (id) ON UPDATE NO ACTION ON DELETE NO ACTION;
    
             CREATE TABLE public.convertidor
              (id serial NOT NULL, 
              moneda_origen_id integer NOT NULL, 
              moneda_destino_id integer NOT NULL, 
              valor double precision NOT NULL, 
              CONSTRAINT convertidor_pk PRIMARY KEY (id), 
              CONSTRAINT moneda_oregen FOREIGN KEY (moneda_origen_id) REFERENCES moneda (id) ON UPDATE NO ACTION ON DELETE NO ACTION, 
              CONSTRAINT moneda_destino FOREIGN KEY (moneda_destino_id) REFERENCES moneda (id) ON UPDATE NO ACTION ON DELETE NO ACTION);

              insert into opcion (nombre,tiene_acciones,ruta,opcion_grupo_id) values ('Convertidor',true,'basico/convertidor',3);
              insert into menu (id,nombre,parent_id,orden,opcion_id) values (880,'Convertidor',703,49,currval('opcion_id_seq'));
    "
  end

  def down
  end
end