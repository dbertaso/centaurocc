class CreateCondicionSacoAndUpdateBoletaArrime < ActiveRecord::Migration
  def up
  execute "
    
    -- Table: condicion_saco

-- DROP TABLE condicion_saco;

CREATE TABLE condicion_saco
(
  id serial NOT NULL,
  nombre character varying(25) NOT NULL,
  porcentaje numeric(16,2) DEFAULT 0.00, -- Porcentaje de sacos
  activo boolean DEFAULT true, -- Si es TRUE indica que la condicion de sacos se encuentra activa
  CONSTRAINT pk_condicion_saco PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
--ALTER TABLE condicion_saco
  --OWNER TO robert;
COMMENT ON COLUMN condicion_saco.nombre IS 'Nombre de la condicion del saco';
COMMENT ON COLUMN condicion_saco.porcentaje IS 'Porcentaje de sacos';
COMMENT ON COLUMN condicion_saco.activo IS 'Si es TRUE indica que la condicion de sacos se encuentra activa';


-- Index: condicion_saco_uq_nombre

-- DROP INDEX condicion_saco_uq_nombre;

CREATE UNIQUE INDEX condicion_saco_uq_nombre
  ON condicion_saco
  USING btree
  (nombre );



ALTER TABLE boleta_arrime ADD COLUMN condicion_saco_id integer;

ALTER TABLE boleta_arrime ADD FOREIGN KEY (condicion_saco_id) REFERENCES condicion_saco (id) ON UPDATE NO ACTION ON DELETE NO ACTION;

COMMENT ON COLUMN boleta_arrime.condicion_saco_id IS 'Referencia a la condicion del saco';

    "
  
  end

  def down
  
  execute " 
    
          DROP VIEW view_cartera_programa_plazo;"
  
  end
end
