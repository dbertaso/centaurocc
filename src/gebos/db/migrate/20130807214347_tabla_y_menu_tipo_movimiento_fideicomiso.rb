# encoding: utf-8

class TablaYMenuTipoMovimientoFideicomiso < ActiveRecord::Migration
  def up
     execute "   
          DROP TABLE if exists tipo_movimiento_fideicomiso;
      
          CREATE TABLE tipo_movimiento_fideicomiso
          (
            id serial NOT NULL,
            tipo_nota integer NOT NULL,
            modo_nota character varying(3) NOT NULL,
            motivo text NOT NULL,
            sub_cuenta_banco boolean DEFAULT false,
            sub_cuenta_insumos boolean DEFAULT false,
            sub_cuenta_gastos boolean DEFAULT false,
            sub_cuenta_sras boolean DEFAULT false,
            comision boolean DEFAULT false,
            CONSTRAINT tipo_movimiento_fideicomiso_pkey PRIMARY KEY (id)
          );
      
      
          update menu set orden = 52 where nombre ='Proveedor Marino';
          insert into opcion (nombre,tiene_acciones,ruta,opcion_grupo_id) values ('Tipo Movimientos Fideicomiso',true,'basico/tipo_movimiento_fideicomiso',3);
          insert into menu (nombre,parent_id,orden,opcion_id) values ('Tipo Movimientos Fideicomiso',59,51,currval('opcion_id_seq'));   
   "
  end

  def down
  end
end
