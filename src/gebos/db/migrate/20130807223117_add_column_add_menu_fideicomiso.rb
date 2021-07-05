# encoding: utf-8

class AddColumnAddMenuFideicomiso < ActiveRecord::Migration
  def up
    
    execute "

          alter table parametro_general add column nro_lote_fideicomiso integer;
          
          DROP TABLE if exists fideicomiso_movimientos;
          
          CREATE TABLE fideicomiso_movimientos 
          (
            id serial NOT NULL,
            fideicomiso_id integer NOT NULL,
            tipo_movimiento_id integer,
            nro_lote integer,
            fecha_movimiento timestamp without time zone DEFAULT now(),
            referencia text,
            justificacion text,
            saldo_disponible_antes double precision,
            monto_operacion double precision,
            monto_banco double precision,
            monto_insumos double precision,
            monto_sras double precision,
            monto_gastos double precision,
            monto_primer_desembolso double precision,
            comision double precision,
            saldo_disponible_despues double precision,
            usuario_id integer,
            CONSTRAINT fideicomiso_movimientos_pkey PRIMARY KEY (id )
          )
          WITH (
            OIDS=FALSE
          );
          
          insert into opcion (nombre,tiene_acciones,ruta,opcion_grupo_id) values ('Actualización de Fideicomiso',true,'finanzas/actualizacion_fideicomiso',3);
          insert into menu (nombre,parent_id,orden,opcion_id) values ('Actualización de Fideicomiso',757,8,currval('opcion_id_seq'));   
          
          insert into opcion (nombre,tiene_acciones,ruta,opcion_grupo_id) values ('Consulta de Disponibilidad de Fideicomiso',true,'finanzas/consulta_disponibilidad_fideicomiso',3);
          insert into menu (nombre,parent_id,orden,opcion_id) values ('Consulta de Disponibilidad de Fideicomiso',757,9,currval('opcion_id_seq'));   
          

    "
  end

  def down
  end
end
