# encoding: utf-8
class AddTransaccionesContables < ActiveRecord::Migration
  def up

    execute "
      insert into transaccion_contable
           (id,nombre,descripcion) values (29, 'CAMBIO ESTATUS CONSULTORIA-LITIGIO', 'Pase de consultoría a litigio');

      insert into transaccion_contable
           (id,nombre,descripcion) values (31, 'CAMBIO ESTATUS CONSULTORIA-CONDONADO', 'Pase de consultoría a condonado');

      insert into transaccion_contable
           (id,nombre,descripcion) values (28, 'CAMBIO ESTATUS VENCIDO-CONDONADO', 'Pase de vencido a condonado');

      insert into transaccion_contable
           (id,nombre,descripcion) values (27, 'CAMBIO ESTATUS LITIGIO-CONDONADO', 'Pase de litigio a condonado');

      insert into transaccion_contable
           (id,nombre,descripcion) values (32, 'CAMBIO ESTATUS VIGENTE-CONDONADO', 'Pase de vigente a condonado');

      insert into transaccion_contable
           (id,nombre,descripcion) values (25, 'CAMBIO ESTATUS VIGENTE-CASTIGADO', 'Pase de vigente a castigado');

      insert into transaccion_contable
           (id,nombre,descripcion) values (30, 'CAMBIO ESTATUS CONSULTORIA-CASTIGADO', 'Pase de Consultoria a castigado');

      insert into transaccion_contable
           (id,nombre,descripcion) values (33, 'CAMBIO ESTATUS LITIGIO-CASTIGADO', 'Pase de litigioa castigado');

      insert into transaccion_contable
           (id,nombre,descripcion) values (26, 'CAMBIO ESTATUS VENCIDO-CASTIGADO', 'Pase de vencido a castigado');

      insert into transaccion_contable
           (id,nombre,descripcion) values (34, 'CANCELACION POR REVOCATORIA', 'Cancelación por Revocatoria');

      SELECT setval('transaccion_contable_id_seq', 34);

    "
  end

  def down
  end
end
