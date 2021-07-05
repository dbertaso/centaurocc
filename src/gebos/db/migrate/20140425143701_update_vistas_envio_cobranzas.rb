# encoding: utf-8
class UpdateVistasEnvioCobranzas < ActiveRecord::Migration
  def up

    execute "

            DROP VIEW if exists view_cuotas_exigibles;

            CREATE OR REPLACE VIEW view_cuotas_exigibles AS 
             SELECT prestamo.numero AS prestamo_numero,
                plan_pago_cuota.plan_pago_id,
                plan_pago_cuota.tipo_cuota,
                plan_pago_cuota.numero AS cuota_numero,
                plan_pago_cuota.fecha,
                plan_pago_cuota.valor_cuota + plan_pago_cuota.interes_mora - (plan_pago_cuota.pago_interes_corriente + plan_pago_cuota.pago_capital) AS monto_cuota,
                plan_pago_cuota.estatus_pago,
                prestamo.exigible,
                prestamo.deuda,
                (select entidad_financiera_id from cuenta_bancaria where cuenta_bancaria.cliente_id = cliente.id and cuenta_bancaria.activo = true limit 1),
                (select numero from cuenta_bancaria where cuenta_bancaria.cliente_id = cliente.id and cuenta_bancaria.activo = true limit 1) as numero_cuenta
               FROM plan_pago_cuota
               JOIN plan_pago ON plan_pago_cuota.plan_pago_id = plan_pago.id AND plan_pago.activo = true
               JOIN prestamo ON plan_pago.prestamo_id = prestamo.id AND plan_pago.activo = true
               JOIN cliente ON prestamo.cliente_id = cliente.id
              WHERE plan_pago_cuota.estatus_pago = 'N'::bpchar AND (plan_pago_cuota.tipo_cuota = ANY (ARRAY['G'::bpchar, 'C'::bpchar])) and (select numero from cuenta_bancaria where cuenta_bancaria.cliente_id = cliente.id limit 1) is not null
              ORDER BY entidad_financiera_id, prestamo.numero, plan_pago_cuota.plan_pago_id, plan_pago_cuota.tipo_cuota DESC, plan_pago_cuota.numero;

            DROP VIEW if exists view_prestamo_exigible;

            CREATE OR REPLACE VIEW view_prestamo_exigible AS 
             SELECT prestamo.numero AS prestamo_numero,
                prestamo.exigible,
                prestamo.deuda,
                (select entidad_financiera_id from cuenta_bancaria where cuenta_bancaria.cliente_id = cliente.id and cuenta_bancaria.activo = true limit 1),
                (select numero from cuenta_bancaria where cuenta_bancaria.cliente_id = cliente.id and cuenta_bancaria.activo = true limit 1) as numero_cuenta
                FROM prestamo
               JOIN cliente ON prestamo.cliente_id = cliente.id
              WHERE prestamo.exigible <> 0::numeric and  (select numero from cuenta_bancaria where cuenta_bancaria.cliente_id = cliente.id and cuenta_bancaria.activo = true limit 1) is not null
              ORDER BY entidad_financiera_id, prestamo.numero;

    "
  end

  def down
  end
end
