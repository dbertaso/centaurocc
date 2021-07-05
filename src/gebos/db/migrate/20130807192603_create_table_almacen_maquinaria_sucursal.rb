class CreateTableAlmacenMaquinariaSucursal < ActiveRecord::Migration
  def up
  execute "ALTER TABLE catalogo ADD COLUMN por_gastos_administrativos integer DEFAULT 2;
            ALTER TABLE catalogo ADD COLUMN por_nacionalizacion integer DEFAULT 2;
            ALTER TABLE catalogo ADD COLUMN por_almacenamiento integer DEFAULT 2;
            ALTER TABLE catalogo
              ALTER COLUMN por_seguro SET DEFAULT 2;
            ALTER TABLE catalogo
              ALTER COLUMN por_flete SET DEFAULT 2;
            update catalogo set por_seguro = 2, por_flete = 2;

          CREATE TABLE almacen_maquinaria_sucursal
          (
            id serial NOT NULL, -- Clave priemaria de la tabla
            nombre character varying(100), -- Nombre de la sucursal
            estado_id integer, -- Estado donde se encuentra ubicada
            municipio_id integer, -- Municipio donde se encuentra ubicada
            ciudad_id integer, -- Ciudad donde se encuentra ubicada
            direccion text, -- Direccion donde se encuentra ubicada
            persona_contacto character varying(100), -- Persona contacto en la sucursal
            telefono character varying(11), -- Telefono de la sucursal
            activo boolean, -- Senal de activacion
            almacen_maquinaria_id integer, -- relacion con la tabla almacen_maquiria
            CONSTRAINT pk_almacen_maquinaria_sucursal PRIMARY KEY (id ),
            CONSTRAINT almacen_maquinaria_id FOREIGN KEY (almacen_maquinaria_id)
                REFERENCES almacen_maquinaria (id) MATCH SIMPLE
                ON UPDATE NO ACTION ON DELETE NO ACTION,
            CONSTRAINT ciudad_fk FOREIGN KEY (ciudad_id)
                REFERENCES ciudad (id) MATCH SIMPLE
                ON UPDATE NO ACTION ON DELETE NO ACTION,
            CONSTRAINT fk_estado FOREIGN KEY (estado_id)
                REFERENCES estado (id) MATCH SIMPLE
                ON UPDATE NO ACTION ON DELETE NO ACTION,
            CONSTRAINT municipio_fk FOREIGN KEY (municipio_id)
                REFERENCES municipio (id) MATCH SIMPLE
                ON UPDATE NO ACTION ON DELETE NO ACTION
          )
          WITH (
            OIDS=FALSE
          );

          COMMENT ON COLUMN almacen_maquinaria_sucursal.id IS 'Clave priemaria de la tabla';
          COMMENT ON COLUMN almacen_maquinaria_sucursal.nombre IS 'Nombre de la sucursal';
          COMMENT ON COLUMN almacen_maquinaria_sucursal.estado_id IS 'Estado donde se encuentra ubicada';
          COMMENT ON COLUMN almacen_maquinaria_sucursal.municipio_id IS 'Municipio donde se encuentra ubicada';
          COMMENT ON COLUMN almacen_maquinaria_sucursal.ciudad_id IS 'Ciudad donde se encuentra ubicada';
          COMMENT ON COLUMN almacen_maquinaria_sucursal.direccion IS 'Direccion donde se encuentra ubicada';
          COMMENT ON COLUMN almacen_maquinaria_sucursal.persona_contacto IS 'Persona contacto en la sucursal ';
          COMMENT ON COLUMN almacen_maquinaria_sucursal.telefono IS 'Telefono de la sucursal';
          COMMENT ON COLUMN almacen_maquinaria_sucursal.activo IS 'Senal de activacion';
          COMMENT ON COLUMN almacen_maquinaria_sucursal.almacen_maquinaria_id IS 'relacion con la tabla almacen_maquiria';"
  
  end

  def down
  execute "DROP TABLE almacen_maquinaria_sucursal;"
  end
end
