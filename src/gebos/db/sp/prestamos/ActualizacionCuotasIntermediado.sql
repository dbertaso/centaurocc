update plan_pago_cuota set 
	interes_corriente = interes_foncrei,
	valor_cuota = interes_foncrei + amortizado

where plan_pago_cuota.id in (select ppc.id from prestamo
					inner join plan_pago on
							(plan_pago.prestamo_id = prestamo.id and
							 plan_pago.activo = true
							)
					inner join plan_pago_cuota ppc on
							(ppc.plan_pago_id = plan_pago_id and
							 ppc.interes_foncrei <> 0 and
							 ppc.interes_intermediario <> 0
							)
					where
						prestamo.intermediado = true)