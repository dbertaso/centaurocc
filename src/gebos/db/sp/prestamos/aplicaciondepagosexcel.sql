select	empresa.nombre as nombre_empresa, 
	empresa.rif, 
	solicitud.numero as numero_solicitud,
	solicitud.monto_solicitado, 
	programa.nombre as nombre_programa, 
	solicitud.numero_acta_directorio,
	solicitud.numero_resolucion_directorio, 
	partida.nombre as nombre_partida, 
	prestamo.tasa_fija,
	prestamo.tasa_vigente, 
	solicitud.fecha_acta_directorio, 
	prestamo.numero as numero_prestamo, 
	prestamo.monto_solicitado as prestamo_monto_solicitado,
	prestamo.meses_fijos_sin_cambio_tasa, 
	prestamo.frecuencia_pago, 
	prestamo.fecha_inicio,
	prestamo.base_calculo_intereses, 
	tipo_credito.nombre as nombre_tipo_credito, 
	prestamo.dia_facturacion,
	factura.numero as numero_factura,
	factura.tipo as tipo_factura,
	factura.proceso_nocturno as proceso_nocturno,
	factura.fecha as fecha_facturacion,
	factura.fecha_realizacion as fecha_realizacion,
	factura.monto as monto,
	pago_cliente.modalidad as modalidad,
	factura.id as factura_id,
	partida.id as id_partida,
	programa.id as id_programa,
	prestamo.id as id_prestamo,
	solicitud.id as id_solicitud,
	factura.id as id_factura,
	empresa.id as id_empresa,
	pago_cliente.id as id_pago_cliente,
	programa.nombre as programa_alias,
	origen_fondo.descripcion as origen_fondo_descripcion,
	prestamo.id as id_prestamo,
	plan_pago_cuota.numero as numero_cuota,
	plan_pago_cuota.tipo_cuota as tipo_cuota,
	plan_pago_cuota.fecha as fecha_vencimiento,
	plan_pago_cuota.valor_cuota as monto_cuota,
	pago_cuota.interes_corriente as pago_interes_corriente,
	pago_cuota.capital as pago_capital,
	pago_cuota.interes_diferido as pago_interes_diferido,
	pago_cuota.interes_mora as pago_interes_mora,
	pago_cuota.interes_desembolso as pago_interes_desembolso,
	plan_pago_cuota.id as id_plan_pago_cuota,
	pago_cuota.id as id_pago_cuota,
	factura.id as factura_id,
	entidad_financiera.nombre as entidad_financiera,
	pago_forma.referencia as referencia,
	pago_forma.monto as monto,
	entidad_financiera.id as id_entidad_financiera,
	pago_forma.id as id_pago_forma,
	pago_forma.pago_cliente_id,
	pago_cliente."numero_voucher" as numero_voucher

from	solicitud, cliente, empresa, prestamo, partida, tipo_credito, programa,
	factura, pago_cliente,origen_fondo,pago_cuota,plan_pago_cuota,pago_prestamo,
	entidad_financiera,pago_forma

where	solicitud.cliente_id = cliente.id
and	cliente.empresa_id = empresa.id
and	prestamo.tipo_credito_id = tipo_credito.id
and	prestamo.solicitud_id = solicitud.id
and	prestamo.partida_id = partida.id
and	solicitud.programa_id = programa.id
and	factura.pago_cliente_id = pago_cliente.id
and	factura.prestamo_id = prestamo.id
and 	solicitud.origen_fondo_id = origen_fondo.id
and	pago_cuota.plan_pago_cuota_id = plan_pago_cuota.id	
and	pago_cuota.pago_prestamo_id = pago_prestamo.id
and	pago_prestamo.pago_cliente_id = pago_cliente.id
and	factura.pago_cliente_id = pago_cliente.id
and	pago_forma.entidad_financiera_id = entidad_financiera.id
and	pago_forma.pago_cliente_id = pago_cliente.id
and	factura.tipo = 'P'
order by programa_alias, empresa.id