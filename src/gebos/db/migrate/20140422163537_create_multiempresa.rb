class CreateMultiempresa < ActiveRecord::Migration
  def up
  	execute "CREATE TABLE public.empresa_sistema
             (
                id serial,
                rif character varying(12) NOT NULL,
                nombre_corto character varying(50) NOT NULL,
                nombre character varying(100) NOT NULL,
                direccion character varying(300) NOT NULL,
                telefono character varying(11) NOT NULL,
                representante_legal character varying(100) NOT NULL,
                activo boolean DEFAULT true,
                CONSTRAINT empresa_sistema_pk PRIMARY KEY (id)
             );
    insert into opcion (nombre, tiene_acciones, ruta, opcion_grupo_id) values ('Multiempresa', true, 'sistema/empresa_sistema', 3);

    insert into menu (id, nombre, parent_id, orden, opcion_id, menu_id) values (902, 'Multiempresa', 57, 6, currval('opcion_id_seq'), 902);
    
    ALTER TABLE usuario ADD COLUMN empresa_sistema_id integer;
    ALTER TABLE usuario ADD COLUMN admin_empresa boolean DEFAULT false;
    ALTER TABLE usuario ADD CONSTRAINT empresa_sistema_fk FOREIGN KEY (empresa_sistema_id) REFERENCES empresa_sistema (id) ON UPDATE NO ACTION ON DELETE NO ACTION;
    ALTER TABLE oficina ADD COLUMN empresa_sistema_id integer;
    ALTER TABLE oficina ADD CONSTRAINT empresa_sistema_fk FOREIGN KEY (empresa_sistema_id) REFERENCES empresa_sistema (id) ON UPDATE NO ACTION ON DELETE NO ACTION;
    ALTER TABLE departamento ADD COLUMN empresa_sistema_id integer;
   ALTER TABLE departamento ADD CONSTRAINT empresa_sistema_fk FOREIGN KEY (empresa_sistema_id) REFERENCES empresa_sistema (id) ON UPDATE NO ACTION ON DELETE NO ACTION;"
  end

  def down
  end
end
