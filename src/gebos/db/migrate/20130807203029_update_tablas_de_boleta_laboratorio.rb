# encoding: utf-8

class UpdateTablasDeBoletaLaboratorio < ActiveRecord::Migration
  def up
    execute "
              ALTER TABLE boleta_arrime ADD COLUMN unidad integer;
              ALTER TABLE boleta_arrime ADD COLUMN kilogramo numeric(16,2) DEFAULT 0.00;
              ALTER TABLE boleta_arrime ADD COLUMN descuento numeric(16,2) DEFAULT 0.00;
              
              COMMENT ON COLUMN boleta_arrime.unidad IS 'Cantidad de sacos de algodon Unidad';
              COMMENT ON COLUMN boleta_arrime.kilogramo IS 'Cantidad de kilogramos de algodon';
              COMMENT ON COLUMN boleta_arrime.descuento IS 'Cantidad de kilogramos de descuento algodon';

              -- Table: boleta_laboratorio_algodon

              -- DROP TABLE boleta_laboratorio_algodon;

              CREATE TABLE boleta_laboratorio_algodon
              (
                id serial NOT NULL,
                boleta_arrime_id integer NOT NULL,
                humedad double precision NOT NULL,
                humedad_absoluta double precision NOT NULL,
                impureza double precision NOT NULL,
                impureza_absoluta double precision NOT NULL,
                CONSTRAINT boleta_laboratorio_algodon_fk_boleta_arrime FOREIGN KEY (boleta_arrime_id)
                    REFERENCES boleta_arrime (id) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION
              )
              WITH (
                OIDS=FALSE
              );


 --            ALTER TABLE boleta_laboratorio_algodon 
 --            ADD CONSTRAINT boleta_laboratorio_algodon_pkey 
  --           PRIMARY KEY (id);
 --   
    
    ALTER TABLE boleta_arrime ADD COLUMN ciclo_productivo_id integer;

ALTER TABLE boleta_arrime ADD CONSTRAINT boleta_arrime_fk_ciclo_productivo FOREIGN KEY (ciclo_productivo_id) 
REFERENCES ciclo_productivo (id) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION;

COMMENT ON COLUMN boleta_arrime.ciclo_productivo_id IS 'Referencia al Ciclo Productivo';


ALTER TABLE boleta_arrime ADD COLUMN hora_entrada_silo time without time zone;
ALTER TABLE boleta_arrime ADD COLUMN hora_entrada_peso time without time zone;
ALTER TABLE boleta_arrime ADD COLUMN hora_salida_peso time without time zone;
ALTER TABLE boleta_arrime ADD COLUMN peso_tara numeric(16,2) DEFAULT 0.00;
COMMENT ON COLUMN boleta_arrime.hora_entrada_silo IS 'Hora de entrada del arrime al silo';

COMMENT ON COLUMN boleta_arrime.hora_entrada_peso IS 'Hora de entrada del vehículo a la romana';

COMMENT ON COLUMN boleta_arrime.hora_salida_peso IS 'Hora de salida del vehículo de la romana';

COMMENT ON COLUMN boleta_arrime.peso_tara IS 'Peso de los Desperdicios del arrime';

ALTER TABLE boleta_arrime ADD COLUMN peso_bruto numeric(16,2) DEFAULT 0.00;
COMMENT ON COLUMN boleta_arrime.peso_bruto IS 'Resta del peso total de entrada menos el peso total de salida';
COMMENT ON COLUMN boleta_arrime.peso_neto IS 'Resta del peso bruto menos el peso tara';

--ALTER TABLE boleta_laboratorio_maiz ADD COLUMN olor character varying(20);
ALTER TABLE boleta_laboratorio_maiz ADD COLUMN aspecto character varying(20);
ALTER TABLE boleta_laboratorio_maiz ADD COLUMN danados_calor double precision;
ALTER TABLE boleta_laboratorio_maiz ADD COLUMN aflatoxina character varying(6);
ALTER TABLE boleta_laboratorio_maiz ADD COLUMN sensorial double precision;
ALTER TABLE boleta_laboratorio_maiz ADD COLUMN hongos double precision;
ALTER TABLE boleta_laboratorio_maiz ADD COLUMN hibrido double precision;
ALTER TABLE boleta_laboratorio_maiz ADD COLUMN remolque double precision;
ALTER TABLE boleta_laboratorio_maiz ADD COLUMN motriz double precision;


ALTER TABLE boleta_laboratorio_arroz ADD COLUMN olor character varying(20);
ALTER TABLE boleta_laboratorio_arroz ADD COLUMN aspecto character varying(20);
ALTER TABLE boleta_laboratorio_arroz ADD COLUMN rendimiento double precision;
ALTER TABLE boleta_laboratorio_arroz ADD COLUMN yesosos_panza_blanca double precision;
ALTER TABLE boleta_laboratorio_arroz ADD COLUMN partidos double precision;
ALTER TABLE boleta_laboratorio_arroz ADD COLUMN peso_especifico numeric(16,2) DEFAULT 0.00;
    
    
    
    
--ALTER TABLE boleta_arrime ADD COLUMN unidad integer;
--ALTER TABLE boleta_arrime ADD COLUMN kilogramo numeric(16,2) DEFAULT 0.00;
--ALTER TABLE boleta_arrime ADD COLUMN descuento numeric(16,2) DEFAULT 0.00;

COMMENT ON COLUMN boleta_arrime.unidad IS 'Cantidad de sacos de algodon Unidad';
COMMENT ON COLUMN boleta_arrime.kilogramo IS 'Cantidad de kilogramos de algodon';
COMMENT ON COLUMN boleta_arrime.descuento IS 'Cantidad de kilogramos de descuento algodon';

-- Table: boleta_laboratorio_algodon

-- DROP TABLE boleta_laboratorio_algodon;

--CREATE TABLE boleta_laboratorio_algodon
--(
  --id serial NOT NULL,
 -- boleta_arrime_id integer NOT NULL,
 -- humedad double precision NOT NULL,
 -- humedad_absoluta double precision NOT NULL,
 -- impureza double precision NOT NULL,
 -- impureza_absoluta double precision NOT NULL,
--  CONSTRAINT boleta_laboratorio_algodon_fk_boleta_arrime FOREIGN KEY (boleta_arrime_id)
  --    REFERENCES boleta_arrime (id) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION
--)
--WITH (
--  OIDS=FALSE
--);


ALTER TABLE boleta_laboratorio_algodon ADD CONSTRAINT boleta_laboratorio_algodon_pkey PRIMARY KEY (id);
    
            --boleta_laboratorio_algodon;
            ALTER TABLE boleta_laboratorio_algodon ALTER COLUMN humedad TYPE numeric(16,2);
            ALTER TABLE boleta_laboratorio_algodon ALTER COLUMN impureza TYPE numeric(16,2);
            ALTER TABLE boleta_laboratorio_algodon ALTER COLUMN humedad SET DEFAULT 0.00;
            ALTER TABLE boleta_laboratorio_algodon ALTER COLUMN impureza SET DEFAULT 0.00;
            
            --boleta_laboratorio_arroz;
            ALTER TABLE boleta_laboratorio_arroz ALTER COLUMN humedad TYPE numeric(16,2);
            ALTER TABLE boleta_laboratorio_arroz ALTER COLUMN humedad SET DEFAULT 0.00;
            
            ALTER TABLE boleta_laboratorio_arroz ALTER COLUMN impureza TYPE numeric(16,2);
            ALTER TABLE boleta_laboratorio_arroz ALTER COLUMN impureza SET DEFAULT 0.00;
            
            ALTER TABLE boleta_laboratorio_arroz ALTER COLUMN blanco_total TYPE numeric(16,2);
            ALTER TABLE boleta_laboratorio_arroz ALTER COLUMN blanco_total SET DEFAULT 0.00;
            
            ALTER TABLE boleta_laboratorio_arroz ALTER COLUMN enteros TYPE numeric(16,2);
            ALTER TABLE boleta_laboratorio_arroz ALTER COLUMN enteros SET DEFAULT 0.00;
            
            ALTER TABLE boleta_laboratorio_arroz ALTER COLUMN yesosos TYPE numeric(16,2);
            ALTER TABLE boleta_laboratorio_arroz ALTER COLUMN yesosos SET DEFAULT 0.00;
            
            ALTER TABLE boleta_laboratorio_arroz ALTER COLUMN panza_blanca TYPE numeric(16,2);
            ALTER TABLE boleta_laboratorio_arroz ALTER COLUMN panza_blanca SET DEFAULT 0.00;
             
            ALTER TABLE boleta_laboratorio_arroz ALTER COLUMN punta_negra TYPE numeric(16,2);
            ALTER TABLE boleta_laboratorio_arroz ALTER COLUMN punta_negra SET DEFAULT 0.00;
            
            ALTER TABLE boleta_laboratorio_arroz ALTER COLUMN danados TYPE numeric(16,2);
            ALTER TABLE boleta_laboratorio_arroz ALTER COLUMN danados SET DEFAULT 0.00;
            
            ALTER TABLE boleta_laboratorio_arroz ALTER COLUMN rojos TYPE numeric(16,2);
            ALTER TABLE boleta_laboratorio_arroz ALTER COLUMN rojos SET DEFAULT 0.00;
            
            ALTER TABLE boleta_laboratorio_arroz ALTER COLUMN verdes TYPE numeric(16,2);
            ALTER TABLE boleta_laboratorio_arroz ALTER COLUMN verdes SET DEFAULT 0.00;
             
            ALTER TABLE boleta_laboratorio_arroz ALTER COLUMN sin_cascara TYPE numeric(16,2);
            ALTER TABLE boleta_laboratorio_arroz ALTER COLUMN sin_cascara SET DEFAULT 0.00;
            
            ALTER TABLE boleta_laboratorio_arroz ALTER COLUMN manchados TYPE numeric(16,2);
            ALTER TABLE boleta_laboratorio_arroz ALTER COLUMN manchados SET DEFAULT 0.00;
            
            ALTER TABLE boleta_laboratorio_arroz ALTER COLUMN infectados TYPE numeric(16,2);
            ALTER TABLE boleta_laboratorio_arroz ALTER COLUMN infectados SET DEFAULT 0.00;
            
            ALTER TABLE boleta_laboratorio_arroz ALTER COLUMN semillas_objetables TYPE numeric(16,2); 
            ALTER TABLE boleta_laboratorio_arroz ALTER COLUMN semillas_objetables SET DEFAULT 0.00;
            
            ALTER TABLE boleta_laboratorio_arroz ALTER COLUMN rendimiento SET DEFAULT 0.00;
            
            --ALTER TABLE boleta_laboratorio_arroz ADD COLUMN yesosos_panza_blanca numeric(16,2);
            ALTER TABLE boleta_laboratorio_arroz ALTER COLUMN yesosos_panza_blanca SET DEFAULT 0.00;
            
            --ALTER TABLE boleta_laboratorio_arroz ADD COLUMN partidos numeric(16,2);
            ALTER TABLE boleta_laboratorio_arroz ALTER COLUMN partidos SET DEFAULT 0.00;
                      
            --boleta_laboratorio_maiz;
            ALTER TABLE boleta_laboratorio_maiz ALTER COLUMN humedad TYPE numeric(16,2);
            ALTER TABLE boleta_laboratorio_maiz ALTER COLUMN humedad SET DEFAULT 0.00;
            
            ALTER TABLE boleta_laboratorio_maiz ALTER COLUMN impureza TYPE numeric(16,2);
            ALTER TABLE boleta_laboratorio_maiz ALTER COLUMN impureza SET DEFAULT 0.00;
            
            ALTER TABLE boleta_laboratorio_maiz ALTER COLUMN germinados_danados TYPE numeric(16,2);
            ALTER TABLE boleta_laboratorio_maiz ALTER COLUMN germinados_danados SET DEFAULT 0.00;
            
            ALTER TABLE boleta_laboratorio_maiz ALTER COLUMN danados_insectos TYPE numeric(16,2);
            ALTER TABLE boleta_laboratorio_maiz ALTER COLUMN danados_insectos SET DEFAULT 0.00;  
              
            ALTER TABLE boleta_laboratorio_maiz ALTER COLUMN quemados TYPE numeric(16,2);
            ALTER TABLE boleta_laboratorio_maiz ALTER COLUMN quemados SET DEFAULT 0.00;
            
            ALTER TABLE boleta_laboratorio_maiz ALTER COLUMN danados_microorganismos TYPE numeric(16,2);
            ALTER TABLE boleta_laboratorio_maiz ALTER COLUMN danados_microorganismos SET DEFAULT 0.00;
             
            ALTER TABLE boleta_laboratorio_maiz ALTER COLUMN partidos TYPE numeric(16,2);
            ALTER TABLE boleta_laboratorio_maiz ALTER COLUMN partidos SET DEFAULT 0.00;
            
            ALTER TABLE boleta_laboratorio_maiz ALTER COLUMN cristalizados TYPE numeric(16,2);
            ALTER TABLE boleta_laboratorio_maiz ALTER COLUMN cristalizados SET DEFAULT 0.00;
            
            ALTER TABLE boleta_laboratorio_maiz ALTER COLUMN amilaceos TYPE numeric(16,2);
            ALTER TABLE boleta_laboratorio_maiz ALTER COLUMN amilaceos SET DEFAULT 0.00;
            
            ALTER TABLE boleta_laboratorio_maiz ALTER COLUMN mezcla_color TYPE numeric(16,2);
            ALTER TABLE boleta_laboratorio_maiz ALTER COLUMN mezcla_color SET DEFAULT 0.00;  
              
            ALTER TABLE boleta_laboratorio_maiz ALTER COLUMN infectados TYPE numeric(16,2);
            ALTER TABLE boleta_laboratorio_maiz ALTER COLUMN infectados SET DEFAULT 0.00;  
            
            ALTER TABLE boleta_laboratorio_maiz ALTER COLUMN danados_total TYPE numeric(16,2);
            ALTER TABLE boleta_laboratorio_maiz ALTER COLUMN danados_total SET DEFAULT 0.00;
              
            ALTER TABLE boleta_laboratorio_maiz ALTER COLUMN semillas_objetables TYPE numeric(16,2);
            ALTER TABLE boleta_laboratorio_maiz ALTER COLUMN semillas_objetables SET DEFAULT 0.00;  
              
            ALTER TABLE boleta_laboratorio_maiz ALTER COLUMN danados_calor SET DEFAULT 0.00;  
              
            ALTER TABLE boleta_laboratorio_maiz ALTER COLUMN sensorial SET DEFAULT 0.00;  
              
            ALTER TABLE boleta_laboratorio_maiz ALTER COLUMN hongos SET DEFAULT 0.00;   
            
            ALTER TABLE boleta_laboratorio_maiz ALTER COLUMN hibrido SET DEFAULT 0.00;  
            
            ALTER TABLE boleta_laboratorio_maiz ALTER COLUMN remolque SET DEFAULT 0.00; 
              
            ALTER TABLE boleta_laboratorio_maiz ALTER COLUMN motriz SET DEFAULT 0.00;   
              
            --boleta_laboratorio_sorgo;
            ALTER TABLE boleta_laboratorio_sorgo ALTER COLUMN humedad TYPE numeric(16,2);
            ALTER TABLE boleta_laboratorio_sorgo ALTER COLUMN humedad SET DEFAULT 0.00;
            
            ALTER TABLE boleta_laboratorio_sorgo ALTER COLUMN impureza TYPE numeric(16,2);
            ALTER TABLE boleta_laboratorio_sorgo ALTER COLUMN impureza SET DEFAULT 0.00;
            
            ALTER TABLE boleta_laboratorio_sorgo ALTER COLUMN germinados_danados TYPE numeric(16,2);
            ALTER TABLE boleta_laboratorio_sorgo ALTER COLUMN germinados_danados SET DEFAULT 0.00;
            
            ALTER TABLE boleta_laboratorio_sorgo ALTER COLUMN danados_insectos TYPE numeric(16,2);
            ALTER TABLE boleta_laboratorio_sorgo ALTER COLUMN danados_insectos SET DEFAULT 0.00;
            
            ALTER TABLE boleta_laboratorio_sorgo ALTER COLUMN quemados TYPE numeric(16,2);
            ALTER TABLE boleta_laboratorio_sorgo ALTER COLUMN quemados SET DEFAULT 0.00;
              
            ALTER TABLE boleta_laboratorio_sorgo ALTER COLUMN danados_microorganismos TYPE numeric(16,2);
            ALTER TABLE boleta_laboratorio_sorgo ALTER COLUMN danados_microorganismos SET DEFAULT 0.00;
            
            ALTER TABLE boleta_laboratorio_sorgo ALTER COLUMN partidos TYPE numeric(16,2);
            ALTER TABLE boleta_laboratorio_sorgo ALTER COLUMN partidos SET DEFAULT 0.00;
              
            ALTER TABLE boleta_laboratorio_sorgo ALTER COLUMN cristalizados TYPE numeric(16,2);
            ALTER TABLE boleta_laboratorio_sorgo ALTER COLUMN cristalizados SET DEFAULT 0.00;  
              
            ALTER TABLE boleta_laboratorio_sorgo ALTER COLUMN amilaceos TYPE numeric(16,2);
            ALTER TABLE boleta_laboratorio_sorgo ALTER COLUMN amilaceos SET DEFAULT 0.00;
            
            ALTER TABLE boleta_laboratorio_sorgo ALTER COLUMN mezcla_color TYPE numeric(16,2);
            ALTER TABLE boleta_laboratorio_sorgo ALTER COLUMN mezcla_color SET DEFAULT 0.00;
            
            ALTER TABLE boleta_laboratorio_sorgo ALTER COLUMN infectados TYPE numeric(16,2);
            ALTER TABLE boleta_laboratorio_sorgo ALTER COLUMN infectados SET DEFAULT 0.00;
            
            ALTER TABLE boleta_laboratorio_sorgo ALTER COLUMN danados_total TYPE numeric(16,2);
            ALTER TABLE boleta_laboratorio_sorgo ALTER COLUMN danados_total SET DEFAULT 0.00;
            
            ALTER TABLE boleta_laboratorio_sorgo ALTER COLUMN semillas_objetables TYPE numeric(16,2);
            ALTER TABLE boleta_laboratorio_sorgo ALTER COLUMN semillas_objetables SET DEFAULT 0.00;
      "
  end

  def down
  end
end
