SELECT
     empresa."nombre" AS empresa_nombre,
     empresa."rif" AS empresa_rif,
     partida."nombre" AS partida_nombre,
     prestamo."monto_aprobado" AS prestamo_monto_aprobado,
     prestamo."numero" AS prestamo_numero,
     prestamo."tasa_vigente" AS prestamo_tasa_vigente,
     CASE WHEN plan_pago_cuota."tipo_cuota"='C'THEN 'Amortización'WHEN plan_pago_cuota."tipo_cuota"='G'THEN 'Gracia'ELSE 'Muerto'END AS tipo_cuota,
     plan_pago_cuota."numero" AS plan_pago_cuota_numero,
     plan_pago_cuota."fecha" AS plan_pago_cuota_fecha,
     plan_pago_cuota."valor_cuota" AS plan_pago_cuota_valor_cuota,
     plan_pago_cuota."amortizado" AS plan_pago_cuota_amortizado,
     plan_pago_cuota."interes_corriente" AS plan_pago_cuota_interes_corriente,
     solicitud."numero" AS solicitud_numero,
     programa."nombre" AS programa_nombre,
     plan_pago_cuota."interes_diferido" AS plan_pago_cuota_interes_diferido
FROM
     "public"."cliente" cliente INNER JOIN "public"."prestamo" prestamo ON cliente."id" = prestamo."cliente_id"
     INNER JOIN "empresa" empresa ON cliente."empresa_id" = empresa."id"
     INNER JOIN "public"."partida" partida ON prestamo."partida_id" = partida."id"
     INNER JOIN "public"."plan_pago" plan_pago ON prestamo."id" = plan_pago."prestamo_id"
     INNER JOIN "public"."solicitud" solicitud ON prestamo."solicitud_id" = solicitud."id"
     INNER JOIN "public"."programa" programa ON solicitud."programa_id" = programa."id"
     INNER JOIN "public"."plan_pago_cuota" plan_pago_cuota ON plan_pago."id" = plan_pago_cuota."plan_pago_id"
WHERE
     plan_pago."activo" = 'true'
     and prestamo."numero" = $P{p_prestamo}
ORDER BY
     tipo_cuota DESC,
     plan_pago_cuota."numero" ASC