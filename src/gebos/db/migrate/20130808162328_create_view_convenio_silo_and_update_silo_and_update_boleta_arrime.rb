# encoding: utf-8

  class CreateViewConvenioSiloAndUpdateSiloAndUpdateBoletaArrime < ActiveRecord::Migration
    def up
      
      execute "
      
                      -- Table: convenio_silo
              --DROP TABLE IF EXISTS convenio_silo;
              CREATE TABLE convenio_silo
              (
                id serial NOT NULL,
                silo_id integer not null,
                usuario_id integer not null,
                ciclo_productivo_id integer not null,
                numero_memorandum character varying(25) NOT NULL,
                fecha_memorandum date,
                fecha_registro date,
                fecha_cierre date,
                observacion text,
                status boolean,
                CONSTRAINT pk_convenio_silo PRIMARY KEY (id ),
                CONSTRAINT convenio_silo_pk_silo FOREIGN KEY (silo_id)
                    REFERENCES silo (id) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
                CONSTRAINT convenio_silo_pk_usuario FOREIGN KEY (usuario_id)
                    REFERENCES usuario (id) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
                CONSTRAINT convenio_silo_pk_ciclo_productivo FOREIGN KEY (ciclo_productivo_id)
                    REFERENCES ciclo_productivo (id) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION
                
              )
              WITH (
                OIDS=FALSE
              );
              
              COMMENT ON COLUMN convenio_silo.silo_id IS 'Referencia al silo';
              COMMENT ON COLUMN convenio_silo.ciclo_productivo_id IS 'Referencia al ciclo productivo';
              COMMENT ON COLUMN convenio_silo.usuario_id IS 'Referencia al Usuario';
              COMMENT ON COLUMN convenio_silo.numero_memorandum IS 'Número del memorandum';
              COMMENT ON COLUMN convenio_silo.fecha_memorandum IS 'Fecha Memorandum';
              COMMENT ON COLUMN convenio_silo.fecha_registro IS 'Fecha de registro del memorandum';
              COMMENT ON COLUMN convenio_silo.fecha_cierre IS 'Fecha de cierre del memorandum ó (fecha limite de convenio)';
              COMMENT ON COLUMN convenio_silo.observacion IS 'Descripción general sobre el convenio';
              COMMENT ON COLUMN convenio_silo.status IS 'Estatus que Indica si el convenio Esta Vigente o Vencido';
              
              
              
              -- Table: detalle_convenio_silo
              --DROP TABLE IF EXISTS detalle_convenio_silo;
              
              CREATE TABLE detalle_convenio_silo
              (
                id serial NOT NULL,
                convenio_silo_id integer NOT NULL,
                actividad_id integer NOT NULL,
                usuario_id integer not null,
                tipo_clase_grado character varying(1) NOT NULL,
                valor numeric(16,2) NOT NULL DEFAULT 0.00,
                CONSTRAINT idx_detalle_convenio_silo PRIMARY KEY (id ),
                CONSTRAINT detalle_convenio_silo_fk_actividad FOREIGN KEY (actividad_id)
                    REFERENCES actividad (id) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
                CONSTRAINT detalle_convenio_silo_fk_convenio_silo FOREIGN KEY (convenio_silo_id)
                    REFERENCES convenio_silo (id) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
                CONSTRAINT detalle_convenio_silo_fk_usuario FOREIGN KEY (usuario_id)
                    REFERENCES usuario (id) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION
              )
              WITH (
                OIDS=FALSE
              );
              
              COMMENT ON COLUMN detalle_convenio_silo.convenio_silo_id IS 'Referencia al Convenio de silo';
              COMMENT ON COLUMN detalle_convenio_silo.actividad_id IS 'Referencia a la Actividad';
              COMMENT ON COLUMN detalle_convenio_silo.usuario_id IS 'Referencia al Usuario que registro el item';
              COMMENT ON COLUMN detalle_convenio_silo.tipo_clase_grado IS 'Categoria de la Actividad';
              COMMENT ON COLUMN detalle_convenio_silo.valor IS 'Valor monetario por kilogramo';
      

              ALTER TABLE silo ADD COLUMN convenio boolean DEFAULT false;
              COMMENT ON COLUMN silo.convenio IS 'Si es TRUE, indica que el silo posee convenios activos, si es FALSE el silo no posee convenios activos';
          
              ALTER TABLE boleta_arrime ADD COLUMN detalle_convenio_silo_id integer;
              ALTER TABLE boleta_arrime ADD FOREIGN KEY (detalle_convenio_silo_id) REFERENCES detalle_convenio_silo (id) ON UPDATE NO ACTION ON DELETE NO ACTION;
          
          
          
          -- View: view_convenio_silo
          DROP VIEW IF EXISTS view_convenio_silo;
          
          CREATE OR REPLACE VIEW view_convenio_silo AS 
           SELECT 
                  s.id AS silo_id, 
                  s.convenio, 
                  cs.id AS convenio_silo_id, 
                  cs.status, 
                  dc.id AS detalle_convenio_silo_id, 
                  dc.actividad_id, 
                  dc.tipo_clase_grado as tipo_clase, 
                  dc.valor
           FROM silo s
           JOIN convenio_silo cs ON cs.silo_id = s.id
           JOIN detalle_convenio_silo dc ON dc.convenio_silo_id = cs.id;
    
        "
  end

  def down
  end
end
