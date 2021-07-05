class ChangeSizeColumnCodigoCuentaContableV1 < ActiveRecord::Migration
  def up
  execute "
    
      ALTER TABLE cuenta_contable
          ALTER COLUMN codigo TYPE varchar(25);
          
      ALTER TABLE regla_contable
          ALTER COLUMN codigo_contable TYPE varchar(25);

      DROP VIEW if exists view_gebos_contabilidad_dataload;
    
      ALTER TABLE asiento_contable
          ALTER COLUMN codigo_contable TYPE varchar(25);
    
      CREATE OR REPLACE VIEW view_gebos_contabilidad_dataload AS 
       SELECT cc.id AS comprobante_contable_id, cc.fecha_registro, cc.fecha_comprobante, cc.fecha_envio, cc.enviado, cc.numero_lote_envio, cc.total_debe, cc.total_haber, cc.numero_contabilidad, cc.unidad_asiento, cc.prestamo_id, cc.factura_id, cc.anio, cc.transaccion_id, cc.reversado, cc.reverso, cc.comprobante_reverso_id, cc.comprobante_reversado_id, cc.referencia, tc.nombre, cc.estatus AS comprobante_estatus, ac.id AS asiento_contable_id, ac.monto, ac.tipo, ac.codigo_contable::text || ac.auxiliar_contable::text AS codigo_contable
         FROM comprobante_contable cc
         JOIN asiento_contable ac ON cc.id = ac.comprobante_contable_id
         JOIN transaccion_contable tc ON cc.transaccion_contable_id = tc.id;
       

    "
    
  end

  def down

    execute "
    
      ALTER TABLE cuenta_contable
          ALTER COLUMN codigo TYPE varchar(20);

      ALTER TABLE regla_contable
          ALTER COLUMN codigo_contable TYPE varchar(20);

      DROP VIEW if exists view_gebos_contabilidad_dataload;
    
      ALTER TABLE asiento_contable
          ALTER COLUMN codigo_contable TYPE varchar(20);
    
      CREATE OR REPLACE VIEW view_gebos_contabilidad_dataload AS 
       SELECT cc.id AS comprobante_contable_id, cc.fecha_registro, cc.fecha_comprobante, cc.fecha_envio, cc.enviado, cc.numero_lote_envio, cc.total_debe, cc.total_haber, cc.numero_contabilidad, cc.unidad_asiento, cc.prestamo_id, cc.factura_id, cc.anio, cc.transaccion_id, cc.reversado, cc.reverso, cc.comprobante_reverso_id, cc.comprobante_reversado_id, cc.referencia, tc.nombre, cc.estatus AS comprobante_estatus, ac.id AS asiento_contable_id, ac.monto, ac.tipo, ac.codigo_contable::text || ac.auxiliar_contable::text AS codigo_contable
         FROM comprobante_contable cc
         JOIN asiento_contable ac ON cc.id = ac.comprobante_contable_id
         JOIN transaccion_contable tc ON cc.transaccion_contable_id = tc.id;
          
    "
  end
end
