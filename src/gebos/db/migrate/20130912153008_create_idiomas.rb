# encoding: utf-8
class CreateIdiomas < ActiveRecord::Migration
  def up
  
  execute "
  
  CREATE TABLE idioma
(
   id serial, 
   nombre character varying(200), 
   bandera character varying(200), 
   nemonico character varying(2), 
   activo boolean,    
   CONSTRAINT id_prk PRIMARY KEY (id), 
   CONSTRAINT nemonico_unico UNIQUE (nemonico)
) 
WITH (
  OIDS = FALSE
)
;
COMMENT ON TABLE idioma
  IS 'tabla de idiomas';
  
  insert into idioma (nombre,bandera,nemonico,activo) values ('Español','spain.gif','es',true);
  insert into idioma (nombre,bandera,nemonico,activo) values ('Inglés','unitedkingdom.gif','en',true);
  insert into idioma (nombre,bandera,nemonico,activo) values ('Árabe','unitedarabemirates.gif','ar',false);
  insert into idioma (nombre,bandera,nemonico,activo) values ('Checo','czechrepublic.gif','cs',false);
  insert into idioma (nombre,bandera,nemonico,activo) values ('Danés','denmark.gif','da',false);
  insert into idioma (nombre,bandera,nemonico,activo) values ('Alemán','germany.gif','de',false);
  insert into idioma (nombre,bandera,nemonico,activo) values ('Finlandés','finland.gif','fi',false);
  insert into idioma (nombre,bandera,nemonico,activo) values ('Fracés','france.gif','fr',false);
  insert into idioma (nombre,bandera,nemonico,activo) values ('Húngaro','hungary.gif','hu',false);
  insert into idioma (nombre,bandera,nemonico,activo) values ('Italiano','italy.gif','it',false);
  insert into idioma (nombre,bandera,nemonico,activo) values ('Japonés','japan.gif','ja',false);
  insert into idioma (nombre,bandera,nemonico,activo) values ('Holandés','netherlands.gif','nl',false);
  insert into idioma (nombre,bandera,nemonico,activo) values ('Polaco','poland.gif','pl',false);
  insert into idioma (nombre,bandera,nemonico,activo) values ('Portugués','portugal.gif','pt',false);
  insert into idioma (nombre,bandera,nemonico,activo) values ('Ruso','russia.gif','ru',false);
  insert into idioma (nombre,bandera,nemonico,activo) values ('Eslovaco','slovakia.gif','sl',false);
  insert into idioma (nombre,bandera,nemonico,activo) values ('Sueco','sweden.gif','sv',false);
  insert into idioma (nombre,bandera,nemonico,activo) values ('Chino','china.gif','cn',false);
  
  
  insert into opcion (nombre,tiene_acciones,ruta,opcion_grupo_id) values ('Idiomas',true,'basico/idioma',(select id from opcion_grupo where trim(lower(nombre)) = 'tablas básicas'));

  INSERT INTO menu (nombre, descripcion, parent_id, orden,opcion_id) VALUES ('Idiomas', 'Tabla de todos los idiomas soportados por la aplicación', (select id from menu where trim(nombre) = 'Tablas Básicas'),26,(select id from opcion where trim(nombre)='Idiomas'));
  
  "
  
  end

  def down
  
  execute "drop table idioma;"
  
  end
end
