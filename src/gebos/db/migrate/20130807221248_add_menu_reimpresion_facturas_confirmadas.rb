# encoding: utf-8

class AddMenuReimpresionFacturasConfirmadas < ActiveRecord::Migration
  def up
    
    execute "
              insert into opcion (nombre,tiene_acciones,ruta,opcion_grupo_id) values ('Consulta de Facturas Confirmadas',true,'solicitudes/orden_despacho_reimpresion_facturas_confirmadas',(select id from opcion_grupo where trim(lower(nombre)) = 'solicitud'));

              INSERT INTO menu (nombre, descripcion, parent_id, orden,opcion_id) VALUES ('Consulta de Facturas Confirmadas', '', (select id from menu where trim(nombre) = 'Orden de Despacho'),12,(select id from opcion where trim(nombre)='Consulta de Facturas Confirmadas'));

            "
  end

  def down
  end
end
