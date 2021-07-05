-- Function: conversion_bolivar_fuerte_manual()

-- DROP FUNCTION conversion_bolivar_fuerte_manual();

CREATE OR REPLACE FUNCTION convierte_prestamos_via_manual()
  RETURNS bool AS
$BODY$
declare
  _prestamo prestamo%rowtype;
  _plan_pago plan_pago%rowtype;
  _plan_pago_cuota plan_pago_cuota%rowtype;
  _solicitud solicitud%rowtype;
  _solicitud_anticipo_societario solicitud_anticipo_societario%rowtype;
  _desembolso desembolso%rowtype;
  _desembolso_pago desembolso_pago%rowtype;
  _factura factura%rowtype;
  _pago_cuota pago_cuota%rowtype;
  _pago_prestamo pago_prestamo%rowtype;
  _pago_cliente pago_cliente%rowtype;
  _pago_forma pago_forma%rowtype;
  _garantia garantia%rowtype;
  _empresa empresa%rowtype;
  _producto producto%rowtype;
  _programa programa%rowtype;
  _prestamo_modificacion prestamo_modificacion%rowtype;
  _prestamo_modificacion_rubro prestamo_modificacion_rubro%rowtype;
  _prestamo_modificacion_rubro_atributo prestamo_modificacion_rubro_atributo%rowtype;
  _prestamo_rubro prestamo_rubro%rowtype;
  _prestamo_rubro_atributo prestamo_rubro_atributo%rowtype;
  _plan_pago_mora plan_pago_mora%rowtype;
  _cur_plan_pago_cuota refcursor;
  _cur_prestamo refcursor;
  _cur_solicitud refcursor;
  _cur_solicitud_anticipo_societario refcursor;
  _cur_desembolso refcursor;
  _cur_desembolso_pago refcursor;
  _cur_factura refcursor;
  _cur_pago refcursor;
  _cur_pago_cliente refcursor;
  _cur_pago_forma refcursor;
  _cur_pago_cuota refcursor;
  _cur_pago_prestamo refcursor;
  _cur_garantia refcursor;
  _cur_empresa refcursor;
  _cur_producto refcursor;
  _cur_programa refcursor;
  _cur_prestamo_modificacion refcursor;
  _cur_prestamo_modificacion_rubro refcursor;
  _cur_prestamo_modificacion_rubro_atributo refcursor;
  _cur_prestamo_rubro refcursor;
  _cur_prestamo_rubro_atributo refcursor;
  _cur_plan_pago_mora refcursor;
  _cur_plan_pago refcursor;
  _fecha_focal date;
  _plan_pago_id integer;
  _plan_pago_cuota_id integer;
  _monto_insoluto float;
  _meses_muertos integer = 0;
  _meses_gracia integer = 0;
  _plazo integer = 0;
  _motivo_evento char;
  _valor_tasa float = 0;
  _factura_id integer;
  _monto_cuota numeric(16,2);
  _monto_cuota_gracia numeric(16,2);
  _monto_cuota_aux numeric(16,2);
  _saldo_insoluto numeric(16,2);
  _saldo_insoluto_original numeric(16,2);
  _bf bool;
  _saldo_ult_cuota_pagada numeric(16,2);
  _amortizado_aux numeric(16,2);
  _interes_acumulado_ult_cuota_pagada numeric(16,2);
  _amortizacion_acumulada_ult_cuota_pagada numeric(16,2);
  _con_programa_origen_fondo programa_origen_fondo%rowtype;
  _con_solicitud solicitud%rowtype;

  _interes_corriente_aux numeric(16,2);
  _interes_diferido_aux numeric(16,2);
  _interes_mora_aux numeric(16,2);
  _interes_causado_aux numeric(16,2);
  _capital_aux numeric(16,2);

  _monto_aux_redondeo numeric(18,3);

  _saldo_insoluto_aux numeric(16,2);
  _monto_liquidado_aux float;
  _monto_solicitado_aux float;
  _monto_aprobado_aux float;
  _remanente_por_aplicar_aux numeric(16,2);
  _abono_monto_minimo_aux float;
  _saldo_deudor_aux float;
  _saldo_capital_aux float;
  _saldo_cuota_anterior numeric(16,2);

  _aumento_capital_aux float;
  _monto_cliente_aux float;
  _monto_aux float;
  _aporte_mensual_aux float;
  _interes_desembolso_aux numeric(16,2);
  _efectivo_aux numeric(16,2);
  _monto_garantia_aux float;
  _monto_avaluo_inicial_aux float;
  _monto_avaluo_foncrei_aux float;
  _capital_suscrito_aux float;
  _capital_pagado_aux float;
  _monto_maximo_aux float;
  _monto_minimo_aux float;
  _relacion_garantia_aux float;
  _monto_propuesta_social_aux float;
  _volumen_facturacion_aux float;
  _monto_desembolso_aux float;
  _monto_abono_aux float;
  _aporte_propio_aux float;
  _aporte_foncrei_aux float;
  _otras_fuentes_aux float;
  _valor_total_aux float;
  _total_deuda_aux float;
  _valor_f_aux float;
  _capital_aux_f float;
  _valor_aux float;
 
begin

	-- ojo quitar  el join

	open _cur_prestamo for 

		select * 
		from 
			prestamo

		where 
			prestamo.estatus in ('S', 'L', 'Q', 'R', 'C', 'F', 'A') 
 
		order by prestamo.id;

	loop

		fetch _cur_prestamo INTO _prestamo;
		exit when not found;

		  -- redondeo de campos tipo numeric

		  _saldo_insoluto_aux = round((_prestamo.saldo_insoluto / 1000),2);
		  _remanente_por_aplicar_aux = round((_prestamo.remanente_por_aplicar / 1000),2);


		  -- redondeo de campos tipo float

		  _monto_aux_redondeo = _prestamo.monto_liquidado;
		  _monto_liquidado_aux = round((_monto_aux_redondeo / 1000),2);
		
		  _monto_aux_redondeo = _prestamo.monto_solicitado;
		  _monto_solicitado_aux = round((_monto_aux_redondeo / 1000),2);

		  _monto_aux_redondeo = _prestamo.monto_aprobado;
		  _monto_aprobado_aux = round((_monto_aux_redondeo / 1000),2);

		  _monto_aux_redondeo = _prestamo.abono_monto_minimo;
		  _abono_monto_minimo_aux = round((_monto_aux_redondeo / 1000),2);

		  _monto_aux_redondeo = _prestamo.saldo_deudor;
		  _saldo_deudor_aux = round((_monto_aux_redondeo / 1000),2);

		  _monto_aux_redondeo = _prestamo.saldo_capital;
		  _saldo_capital_aux = round((_monto_aux_redondeo / 1000),2);


		-- Actualizacion del prestamo

		update prestamo set 
				saldo_insoluto = _saldo_insoluto_aux,
				monto_liquidado = _monto_liquidado_aux,
				monto_solicitado = _monto_solicitado_aux,
				monto_aprobado =  _monto_aprobado_aux,
				remanente_por_aplicar = _remanente_por_aplicar_aux,
				abono_monto_minimo = _abono_monto_minimo_aux,
				saldo_deudor = _saldo_deudor_aux,
				saldo_capital = _saldo_capital_aux,
				deuda	      = round((deuda/1000),2),
				monto_excedente_sap = round((monto_excedente_sap/1000),2)

		where 
				prestamo.id = _prestamo.id;


	-- A continuacion se actualizan los campos del prestamo
	
  end loop;
  
  close _cur_prestamo;


  return true;
 
end;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;
ALTER FUNCTION convierte_prestamos_via_manual() OWNER TO cartera;

select convierte_prestamos_via_manual()
