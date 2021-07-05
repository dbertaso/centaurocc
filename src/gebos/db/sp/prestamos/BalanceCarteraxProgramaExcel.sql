SELECT
     prestamo."numero" AS numero_prestamo,
     prestamo."saldo_insoluto" + prestamo."monto_excedente_sap",
     prestamo."interes_vencido",
     prestamo."monto_mora",
     prestamo."causado_no_devengado",
     prestamo."interes_diferido_vencido",
     prestamo."interes_diferido_por_vencer",
     prestamo."interes_vencido" + prestamo."interes_diferido_vencido" AS interes_total,
     prestamo."capital_pago_parcial",
     prestamo."remanente_por_aplicar",
     prestamo."deuda" + prestamo."monto_excedente_sap" as deuda,
     prestamo."interes_desembolso_vencido",
     empresa."nombre" as empresa_nombre,
     empresa."id",
     programa."nombre" as programa_nombre,
     programa."tipo_credito_id",
     tipo_credito."nombre" as tipo_credito_nombre,
     partida."nombre" as partida_nombre,
     solicitud."numero" as numero_solicitud,
     solicitud."codigo_presupuesto_d3",
     solicitud."codigo_presupuesto_d3" || ' - ' || solicitud."descripcion_presupuesto_d3" AS descripcion_presupuesto_d3
FROM
     solicitud, prestamo, cliente, empresa, programa, tipo_credito, partida
WHERE
	solicitud."id" = prestamo."solicitud_id" and
	prestamo."cliente_id" = cliente."id" AND
	cliente."empresa_id" = empresa."id" AND
	solicitud."programa_id" = programa."id" AND
	programa."tipo_credito_id" = tipo_credito."id" AND
	prestamo."partida_id" = partida."id" AND
	(prestamo.estatus = 'V' or prestamo.estatus =  'E' or prestamo.estatus =  'P')
ORDER BY
	programa."id",
	empresa."id"