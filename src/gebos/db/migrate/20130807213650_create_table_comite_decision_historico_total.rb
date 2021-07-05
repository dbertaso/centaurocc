# encoding: utf-8

class CreateTableComiteDecisionHistoricoTotal < ActiveRecord::Migration
  def up
      execute "
            CREATE TABLE comite_decision_historico_total
                (
                  id serial NOT NULL,
                  decision character varying(1) DEFAULT NULL::character varying,
                  comite_id integer,
                  solicitud_id integer,
                  fecha_decision date,
                  oficina_id integer NOT NULL,
                  tipo_comite character varying(1) NOT NULL,
                  comentario text,
                  CONSTRAINT comite_decision_historico_total_pk PRIMARY KEY (id ),
                  CONSTRAINT comite_decision_historico_total_fk_comite FOREIGN KEY (comite_id)
                      REFERENCES comite (id) MATCH SIMPLE
                      ON UPDATE NO ACTION ON DELETE NO ACTION,
                  CONSTRAINT comite_decision_historico_total_fk_solicitud FOREIGN KEY (solicitud_id)
                      REFERENCES solicitud (id) MATCH SIMPLE
                      ON UPDATE NO ACTION ON DELETE NO ACTION
                )
                WITH (
                  OIDS=FALSE
                );

            INSERT INTO comite_decision_historico_total
            SELECT *
              FROM comite_decision_historico
            where
              decision is not null;
    
            DELETE
            FROM 
                comite_decision_historico
            where
                decision is not null;
    "
  end

  def down

  end
  
end
