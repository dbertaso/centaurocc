-- View: ""CuotasPagadasPrestamo""

--DROP VIEW "cuotaspagadasprestamo";

CREATE OR REPLACE VIEW "cuotaspagadasprestamo" AS 
 SELECT prestamo.id, count(plan_pago_cuota.id) AS cuotaspagadas
   FROM plan_pago_cuota
   JOIN plan_pago ON plan_pago_cuota.plan_pago_id = plan_pago.id AND plan_pago.activo = true
   JOIN prestamo ON plan_pago.prestamo_id = prestamo.id AND (prestamo.estatus = ANY (ARRAY['E'::bpchar, 'L'::bpchar])) AND prestamo.dias_mora > 0
  WHERE plan_pago_cuota.estatus_pago = 'T'::bpchar
  GROUP BY prestamo.id;

ALTER TABLE "cuotaspagadasprestamo" OWNER TO cartera;
COMMENT ON VIEW "cuotaspagadasprestamo" IS 'Vista para determinar la cantidad de cuotas pagadas por un prestamo';
