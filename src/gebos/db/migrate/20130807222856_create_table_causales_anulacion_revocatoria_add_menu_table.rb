# encoding: utf-8

class CreateTableCausalesAnulacionRevocatoriaAddMenuTable < ActiveRecord::Migration
  def up
    
    execute "

            CREATE TABLE causales_anulacion_revocatoria 
            (
              id serial NOT NULL,  
              anulacion boolean DEFAULT false,
              revocatoria_parcial boolean DEFAULT false,
              revocatoria_total boolean DEFAULT false,
              causa text,  
              CONSTRAINT causales_anulacion_revocatoria_pkey PRIMARY KEY (id)
            );
            
            
            ALTER TABLE solicitud DROP COLUMN causa_revocatoria_anulacion;
            
            ALTER TABLE solicitud ADD COLUMN causa_revocatoria_anulacion integer;
            
            COMMENT ON COLUMN solicitud.causa_revocatoria_anulacion IS 'Atributo usado para registrar la causa por la cual se hizo la anulación o revocatoria del trámite';
            
            insert into opcion (nombre,tiene_acciones,ruta,opcion_grupo_id) values ('Causales de Anulación y/o Revocatoria',true,'basico/causales_anulacion_revocatoria',(select id from opcion_grupo where trim(lower(nombre)) = 'tablas básicas'));
            INSERT INTO menu (nombre, descripcion, parent_id, orden,opcion_id) VALUES ('Causales de Anulación y/o Revocatoria', 'Tabla básica especial para las causales de la revocatoria total o parcial y la anulación', (select id from menu where trim(nombre) = 'Tablas Básicas'),10,(select id from opcion where trim(nombre)='Causales de Anulación y/o Revocatoria'));
            
            INSERT INTO causales_anulacion_revocatoria (causa, anulacion, revocatoria_parcial, revocatoria_total) VALUES ('Renuncia voluntaria al crédito',true,true,true);
            INSERT INTO causales_anulacion_revocatoria (causa, anulacion, revocatoria_parcial, revocatoria_total) VALUES ('Muerte',true,true,true);
            INSERT INTO causales_anulacion_revocatoria (causa, anulacion, revocatoria_parcial, revocatoria_total) VALUES ('Siniestro',true,true,true);
            INSERT INTO causales_anulacion_revocatoria (causa, anulacion, revocatoria_parcial, revocatoria_total) VALUES ('Documentación legal incompleta o fraudulenta',true,true,true);
            INSERT INTO causales_anulacion_revocatoria (causa, anulacion, revocatoria_parcial, revocatoria_total) VALUES ('Medida extrajudicial',true,true,true);
            INSERT INTO causales_anulacion_revocatoria (causa, anulacion, revocatoria_parcial, revocatoria_total) VALUES ('El beneficiario consiguió otra fuente de financiamiento',true,true,true);
            INSERT INTO causales_anulacion_revocatoria (causa, anulacion, revocatoria_parcial, revocatoria_total) VALUES ('Carga incorrecta de datos',true,false,false);
            INSERT INTO causales_anulacion_revocatoria (causa, anulacion, revocatoria_parcial, revocatoria_total) VALUES ('Datos incorrectos generados por el sistema',true,false,false);
            INSERT INTO causales_anulacion_revocatoria (causa, anulacion, revocatoria_parcial, revocatoria_total) VALUES ('No se entregaron la totalidad de los insumos',false,true,true);
            INSERT INTO causales_anulacion_revocatoria (causa, anulacion, revocatoria_parcial, revocatoria_total) VALUES ('No será financiado en este ciclo productivo',true,true,true);
            INSERT INTO causales_anulacion_revocatoria (causa, anulacion, revocatoria_parcial, revocatoria_total) VALUES ('Tardanza en la liquidación del crédito',true,true,true);

      "
  end

  def down
    execute "DROP TABLE if exists causales_anulacion_revocatoria;"
  end

end
