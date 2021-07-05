# encoding: utf-8
class CreateNemonico < ActiveRecord::Migration
  def up
    execute "CREATE TABLE public.nemonico
            (
               id serial NOT NULL, 
               nemonico character varying(2) NOT NULL, 
               nombre character varying(50) NOT NULL, 
               descripcion character varying(250) NOT NULL, 
               CONSTRAINT nemonico_pk PRIMARY KEY (id), 
               CONSTRAINT nemonico_uk UNIQUE (nemonico)
            );

            INSERT INTO nemonico (nemonico, nombre, descripcion) VALUES ('VE', 'Vegetal', 'Sub-Sector Vegetal');
            INSERT INTO nemonico (nemonico, nombre, descripcion) VALUES ('AC', 'Acuicola', 'Sub-Sector Acuicola');
            INSERT INTO nemonico (nemonico, nombre, descripcion) VALUES ('AN', 'Animal', 'Sub-Sector Animal');
            INSERT INTO nemonico (nemonico, nombre, descripcion) VALUES ('MA', 'Maquinaria', 'Sub-Sector Maquinaria');
            INSERT INTO nemonico (nemonico, nombre, descripcion) VALUES ('PE', 'Pesca', 'Sub-Sector Pesca');

            ALTER TABLE sub_sector
              ADD CONSTRAINT nemonico_fk FOREIGN KEY (nemonico) REFERENCES nemonico (nemonico) ON UPDATE NO ACTION ON DELETE NO ACTION;

            insert into opcion (nombre, tiene_acciones, ruta, opcion_grupo_id) values ('Nemónico', true, 'basico/nemonico', 3);

            insert into menu (id, nombre, parent_id, orden, opcion_id) values ('Nemónico', currval('opcion_id_seq'), 99, currval('opcion_id_seq'));
  "
  end

  def down
  end
end
