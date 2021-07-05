# encoding: utf-8

class TablaYMenuFideicomiso < ActiveRecord::Migration
  def up
    
     execute "   

              DROP TABLE if exists fideicomiso_cuentas;

              CREATE TABLE fideicomiso_cuentas
              (
                id serial NOT NULL,
                fideicomiso_id integer NOT NULL,
                cuenta_bcv_id integer NOT NULL,
                CONSTRAINT fideicomiso_cuentas_pkey PRIMARY KEY (id ),
                CONSTRAINT fideicomiso_cuentas_fk_cuentas_bcv FOREIGN KEY (cuenta_bcv_id)
                    REFERENCES cuenta_bcv (id) MATCH SIMPLE
                    ON UPDATE NO ACTION ON DELETE NO ACTION
              )
              WITH (
                OIDS=FALSE
              );
        
            insert into opcion (nombre,tiene_acciones,ruta,opcion_grupo_id) values ('Fideicomiso',true,'basico/fideicomiso',3);
            insert into menu (nombre,parent_id,orden,opcion_id) values ('Fideicomiso',59,19,currval('opcion_id_seq')); 
   "
  end

  def down
  end
end
