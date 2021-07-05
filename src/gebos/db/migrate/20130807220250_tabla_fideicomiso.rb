# encoding: utf-8

class TablaFideicomiso < ActiveRecord::Migration
  def up
    
    execute "
    
        DROP TABLE if exists fideicomiso;
     
        CREATE TABLE fideicomiso
            (
                 id serial NOT NULL,
                 entidad_financiera_id integer NOT NULL,
                 programa_id integer NOT NULL,
                 numero_fideicomiso integer NOT NULL,
                 fecha_creacion date,
                 fecha_ultima_actualizacion date,
                 porcentaje double precision,
                 monto_disponible double precision,
                 subcuenta_banco double precision,
                 subcuenta_insumos double precision,
                 subcuenta_sras double precision,
                 subcuenta_gastos double precision,
                 activo boolean DEFAULT false,
                 CONSTRAINT fideicomiso_pkey PRIMARY KEY (id ),
                 CONSTRAINT fideicomiso_fk_entidad_financiera FOREIGN KEY (entidad_financiera_id)
                 REFERENCES entidad_financiera (id) MATCH SIMPLE
                 ON UPDATE NO ACTION ON DELETE NO ACTION
            )
            WITH (
             OIDS=FALSE
            );


   "
  end

  def down
  end
end
