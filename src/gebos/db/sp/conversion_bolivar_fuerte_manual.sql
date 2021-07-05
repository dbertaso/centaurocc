-- Function: conversion_bolivar_fuerte_manual()

-- DROP FUNCTION conversion_bolivar_fuerte_manual();

CREATE OR REPLACE FUNCTION conversion_bolivar_fuerte_manual()
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
			prestamo.estatus not in ('S', 'L', 'Q', 'R', 'C', 'F', 'A') 
 
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

	--Selecciono el plan pago asociado al prestamo

	select into _plan_pago * from plan_pago 

		where plan_pago.prestamo_id = _prestamo.id and plan_pago.activo = true;


	  /*
	  -----------------------------------------------------------
	  Apertura del cursor para actualizacion de plan_pago_cuota
	  -----------------------------------------------------------
	  */

	  open _cur_plan_pago_cuota for
		
		select * 
		from 
			plan_pago_cuota
		where 
			
			plan_pago_cuota.plan_pago_id = _plan_pago.id
            
		order by tipo_cuota desc,
                         numero asc;

		/*
		--------------------------------------------
		Inicio recorrido de cursor plan_pago_cuota
		--------------------------------------------
		*/

		loop
			fetch _cur_plan_pago_cuota INTO _plan_pago_cuota;
			exit when not found; 

			if _plan_pago_cuota.tipo_cuota = 'G' then

				_monto_cuota_gracia = round((_plan_pago_cuota.valor_cuota/1000),2);
			else
				_monto_cuota = round((_plan_pago_cuota.valor_cuota/1000),2);
			end if;

			
			if _plan_pago_cuota.tipo_cuota = 'M' or
                           _plan_pago_cuota.tipo_cuota = 'G' or 
			   _plan_pago_cuota.tipo_cuota = 'C' then
			
				_saldo_insoluto = round((_plan_pago_cuota.saldo_insoluto/1000),2);
			end if; 
			

			if _plan_pago_cuota.tipo_cuota <> 'M' then

				if _plan_pago_cuota.tipo_cuota = 'C' then
	
					_monto_cuota_aux = _monto_cuota;
				else
					_monto_cuota_aux = _monto_cuota_gracia;
				end if;

				_interes_corriente_aux = round((_plan_pago_cuota.interes_corriente/1000),2);

				if _plan_pago_cuota.tipo_cuota = 'G' then

					_amortizado_aux = 0;
				else
				    
					_amortizado_aux = _monto_cuota_aux - _interes_corriente_aux;
				end if;


				/*
				---------------------------
				Actualizacion de la cuota
				---------------------------
				*/

				update plan_pago_cuota set
						valor_cuota = _monto_cuota_aux,
						interes_corriente = _interes_corriente_aux,
						amortizado = _amortizado_aux,
						amortizado_acumulado = round((amortizado_acumulado / 1000),2),
						interes_corriente_acumulado = round((interes_corriente_acumulado / 1000),2),
						saldo_insoluto = _saldo_insoluto,
						interes_diferido = round((_plan_pago_cuota.interes_diferido / 1000),2),
						interes_mora = round((_plan_pago_cuota.interes_mora / 1000),2),
						pago_interes_mora = round((_plan_pago_cuota.pago_interes_mora / 1000),2),
						pago_interes_corriente = round((_plan_pago_cuota.pago_interes_corriente / 1000),2),
						pago_interes_diferido = round((_plan_pago_cuota.pago_interes_diferido / 1000),2),
						pago_capital = round((_plan_pago_cuota.pago_capital / 1000),2),
						remanente_por_aplicar = round((_plan_pago_cuota.remanente_por_aplicar / 1000),2),
						causado_no_devengado = round((_plan_pago_cuota.causado_no_devengado / 1000),2),
						monto_desembolso = round((_plan_pago_cuota.monto_desembolso / 1000),2),
						monto_abono = round((_plan_pago_cuota.monto_abono / 1000),2),
						interes_desembolso = round((_plan_pago_cuota.interes_desembolso / 1000),2),
						pago_interes_desembolso = round((_plan_pago_cuota.pago_interes_desembolso / 1000),2),
						interes_foncrei = round((_plan_pago_cuota.interes_foncrei / 1000),2),
						interes_intermediario = round((_plan_pago_cuota.interes_intermediario / 1000),2),
						mora_exonerada = round((_plan_pago_cuota.mora_exonerada / 1000),2),
						intereses_por_cobrar_al_30 = round((_plan_pago_cuota.intereses_por_cobrar_al_30 / 1000),2),
						pago_interes_corriente_acumulado = _saldo_insoluto_original
				where
					plan_pago_cuota.id = _plan_pago_cuota.id;


			end if;

		end loop;

		close _cur_plan_pago_cuota;

	-- A continuacion se actualizan los campos del prestamo
	
  end loop;
  
  close _cur_prestamo;
  /*
  -------------------------------------------------
  Después de convertir todas las cuotas a Bolivar
  Fuerte, se actualizan de las últimas cuotas de 
  cada prestamo para actualizar el saldo en cero
  -------------------------------------------------
  */
  

  /*
  --------------------------------------------------
  Se crea un cursor de plan pago para determinar
  la ultima cuota del plan_pago_cuota
  --------------------------------------------------
  */

  open _cur_plan_pago for

	select *
	from
		plan_pago
	where
		plan_pago.activo = true;

  loop
	fetch _cur_plan_pago INTO _plan_pago;
	exit when not found;

	/*
	-----------------------------------------
	Se selecciona la última cuota de amorti-
	zación
	-----------------------------------------
	*/

	select into 
		_plan_pago_cuota *
	from
		plan_pago_cuota
	where
		plan_pago_cuota.plan_pago_id 	= _plan_pago.id and
                plan_pago_cuota.tipo_cuota 	= 'C'

	order by 
		fecha desc
	limit 1;

	if _plan_pago_cuota.id is not null then
	
		update
			plan_pago_cuota 
		set
			saldo_insoluto = 0 
		where
			plan_pago_cuota.id = _plan_pago_cuota.id;
	end if;

  end loop;

  close _cur_plan_pago;

  raise notice 'Termino conversion de prestamo y plan pago_________________________';

	/*
	---------------------------------------------------
	Comienza la actualizacion del resto de las tablas
	---------------------------------------------------
	*/

	/*
	--------------------------------------------------------------
	Actualizacion de la tabla de prestamo_modificacion a Bolivar
	fuerte
	--------------------------------------------------------------
	*/

	open _cur_prestamo_modificacion
	for select * from prestamo_modificacion
	order by id;

	loop
		fetch _cur_prestamo_modificacion INTO _prestamo_modificacion;
		exit when not found;

		-- Redondeo de campos numericos tipo float

		_monto_aux_redondeo 		= _prestamo_modificacion.monto;
		_monto_aux 			= round((_monto_aux_redondeo / 1000),2);

		_monto_aux_redondeo 		= _prestamo_modificacion.aumento_capital;
		_aumento_capital_aux 		= round((_monto_aux_redondeo / 1000),2);

		_monto_aux_redondeo 		= _prestamo_modificacion.saldo_insoluto;
		_saldo_insoluto_aux 		= round((_monto_aux_redondeo / 1000),2);

		_monto_aux_redondeo 		= _prestamo_modificacion.interes_diferido;
		_interes_diferido_aux 		= round((_monto_aux_redondeo / 1000),2);

		_monto_aux_redondeo 		= _prestamo_modificacion.interes_desembolso;
		_interes_desembolso_aux 	= round((_monto_aux_redondeo / 1000),2);

		_monto_aux_redondeo 		= _prestamo_modificacion.interes_mora;
		_interes_mora_aux		= round((_monto_aux_redondeo / 1000),2);

		_monto_aux_redondeo 		= _prestamo_modificacion.interes_ordinario;
		_interes_corriente_aux		= round((_monto_aux_redondeo / 1000),2);

		_monto_aux_redondeo 		= _prestamo_modificacion.interes_causado;
		_interes_causado_aux		= round((_monto_aux_redondeo / 1000),2);

		_monto_aux_redondeo 		= _prestamo_modificacion.remanente_por_aplicar;
		_remanente_por_aplicar_aux	= round((_monto_aux_redondeo / 1000),2);

		_monto_aux_redondeo 		= _prestamo_modificacion.total_deuda;
		_total_deuda_aux		= round((_monto_aux_redondeo / 1000),2);

		-- Actualizacion de registro modificacion del prestamo (prestamo_modificacion)

		update prestamo_modificacion set

			monto 			= _monto_aux,
			aumento_capital		= _aumento_capital_aux,
			saldo_insoluto		= _saldo_insoluto_aux,
			interes_diferido	= _interes_diferido_aux,
			interes_desembolso	= _interes_desembolso_aux,
			interes_mora		= _interes_mora_aux,
			interes_ordinario	= _interes_corriente_aux,
			interes_causado		= _interes_causado_aux,
			remanente_por_aplicar	= _remanente_por_aplicar_aux,
			total_deuda		= _total_deuda_aux
		where
			prestamo_modificacion.id = _prestamo_modificacion.id;

	end loop;

	close _cur_prestamo_modificacion;

	raise notice 'Termino conversion de modificación del préstamo (prestamo_modificacion)___________________';

	/*
	-------------------------------------------------------
	Actualizacion de la tabla de prestamo_rubro a Bolivar
	fuerte
	-------------------------------------------------------
	*/

	open _cur_prestamo_rubro
	for select * from prestamo_rubro
	order by id;

	loop
		fetch _cur_prestamo_rubro INTO _prestamo_rubro;
		exit when not found;

		-- Redondeo de campos numericos tipo float

		_monto_aux_redondeo 	= _prestamo_rubro.aporte_propio;
		_aporte_propio_aux 	= round((_monto_aux_redondeo / 1000),2);

		_monto_aux_redondeo 	= _prestamo_rubro.aporte_foncrei;
		_aporte_foncrei_aux 	= round((_monto_aux_redondeo / 1000),2);

		_monto_aux_redondeo 	= _prestamo_rubro.otras_fuentes;
		_otras_fuentes_aux 	= round((_monto_aux_redondeo / 1000),2);

		_monto_aux_redondeo 	= _prestamo_rubro.valor_total;
		_valor_total_aux 	= round((_monto_aux_redondeo / 1000),2);

		-- Actualizacion de registro rubros del prestamo (prestamo_rubro)

		update prestamo_rubro set

			aporte_propio 		= _aporte_propio_aux,
			aporte_foncrei		= _aporte_foncrei_aux,
			otras_fuentes		= _otras_fuentes_aux,
			valor_total		= _valor_total_aux
		where
			prestamo_rubro.id = _prestamo_rubro.id;

	end loop;

	close _cur_prestamo_rubro;

	raise notice 'Termino conversion de rubros del prestamo (prestamo_rubro)___________________';

	/*
	-------------------------------------------------------
	Actualizacion de la tabla de prestamo_rubro a Bolivar
	fuerte
	-------------------------------------------------------
	*/

	open _cur_prestamo_rubro_atributo
	for select * from prestamo_rubro_atributo
	order by id;

	loop
		fetch _cur_prestamo_rubro_atributo INTO _prestamo_rubro_atributo;
		exit when not found;

		-- Redondeo de campos numericos tipo float

		_monto_aux_redondeo 	= _prestamo_rubro_atributo.valor_f;
		_valor_f_aux 		= round((_monto_aux_redondeo / 1000),2);

		-- Actualizacion de registro atributo del rubro del prestamo (prestamo_rubro_atributo)

		update prestamo_rubro_atributo set

			valor_f 		= _valor_f_aux
		where
			prestamo_rubro_atributo.id = _prestamo_rubro_atributo.id;

	end loop;

	close _cur_prestamo_rubro_atributo;

	raise notice 'Termino conversion de atributos del rubro del prestamo (prestamo_rubro_atributo)___________________';

	/*
	-------------------------------------------------------------------
	Actualizacion de la tabla de prestamo_modifcacion_rubro a Bolivar
	fuerte
	-------------------------------------------------------------------
	*/

	open _cur_prestamo_modificacion_rubro
	for select * from prestamo_modificacion_rubro
	order by id;

	loop
		fetch _cur_prestamo_modificacion_rubro INTO _prestamo_modificacion_rubro;
		exit when not found;

		-- Redondeo de campos numericos tipo float

		_monto_aux_redondeo 	= _prestamo_rubro.aporte_propio;
		_aporte_propio_aux 	= round((_monto_aux_redondeo / 1000),2);

		_monto_aux_redondeo 	= _prestamo_rubro.aporte_foncrei;
		_aporte_foncrei_aux 	= round((_monto_aux_redondeo / 1000),2);

		_monto_aux_redondeo 	= _prestamo_rubro.otras_fuentes;
		_otras_fuentes_aux 	= round((_monto_aux_redondeo / 1000),2);

		_monto_aux_redondeo 	= _prestamo_rubro.valor_total;
		_valor_total_aux 	= round((_monto_aux_redondeo / 1000),2);

		-- Actualizacion de registro rubros del prestamo (prestamo_rubro)

		update prestamo_modificacion_rubro set

			aporte_propio 		= _aporte_propio_aux,
			aporte_foncrei		= _aporte_foncrei_aux,
			otras_fuentes		= _otras_fuentes_aux,
			valor_total		= _valor_total_aux
		where
			prestamo_modificacion_rubro.id = _prestamo_modificacion_rubro.id;

	end loop;

	close _cur_prestamo_modificacion_rubro;

	raise notice 'Termino conversion de rubros del prestamo modificación rubro (prestamo_modificaion_rubro)___________________';

	/*
	-------------------------------------------------------
	Actualizacion de la tabla de prestamo_rubro a Bolivar
	fuerte
	-------------------------------------------------------
	*/

	open _cur_prestamo_modificacion_rubro_atributo
	for select * from prestamo_modificacion_rubro_atributo
	order by id;

	loop
		fetch _cur_prestamo_modificacion_rubro_atributo INTO _prestamo_modificacion_rubro_atributo;
		exit when not found;

		-- Redondeo de campos numericos tipo float

		_monto_aux_redondeo 	= _prestamo_modificacion_rubro_atributo.valor_f;
		_valor_f_aux 		= round((_monto_aux_redondeo / 1000),2);

		-- Actualizacion de registro atributo del rubro del prestamo (prestamo_rubro_atributo)

		update prestamo_modificacion_rubro_atributo set

			valor_f 		= _valor_f_aux
		where
			prestamo_modificacion_rubro_atributo.id = _prestamo_modificacion_rubro_atributo.id;

	end loop;

	close _cur_prestamo_modificacion_rubro_atributo;

	raise notice 'Termino conversion de atributos del rubro del prestamo (prestamo_modificacion_rubro_atributo)___________________';

	/*
	----------------------------------------------------
	Actualizacion de la tabla de solicitudes a Bolivar
	fuerte
	----------------------------------------------------
	*/

	open _cur_solicitud 
	for select * from solicitud
	order by id;

	loop
		fetch _cur_solicitud INTO _solicitud;
		exit when not found;

		-- Redondeo de campos numericos tipo float

		_monto_aux_redondeo = _solicitud.monto_solicitado;
		_monto_solicitado_aux = round((_monto_aux_redondeo / 1000),2);

		_monto_aux_redondeo = _solicitud.monto_aprobado;
		_monto_aprobado_aux = round((_monto_aux_redondeo / 1000),2);

		_monto_aux_redondeo = _solicitud.aumento_capital;
		_aumento_capital_aux = round((_monto_aux_redondeo / 1000),2);

		_monto_aux_redondeo = _solicitud.monto_cliente;
		_monto_cliente_aux = round((_monto_aux_redondeo / 1000),2);

		_monto_aux_redondeo = _solicitud.monto_propuesta_social;
		_monto_propuesta_social_aux = round((_monto_aux_redondeo / 1000),2);

		-- Actualizacion de registro de solicitud

		update solicitud set

			monto_solicitado 	= _monto_solicitado_aux,
			monto_aprobado		= _monto_aprobado_aux,
			aumento_capital		= _aumento_capital_aux,
			monto_cliente		= _monto_cliente_aux,
			monto_propuesta_social	= _monto_propuesta_social_aux
		where
			solicitud.id = _solicitud.id;

	end loop;

	close _cur_solicitud;

	raise notice 'Termino conversion de solicitud___________________';

	/*
	-------------------------------------------------------------------------
	Actualizacion de la tabla de solicitud de anticipo societario a Bolivar
	fuerte
	-------------------------------------------------------------------------
	*/

	open _cur_solicitud_anticipo_societario 
	for select * from solicitud_anticipo_societario
	order by id;

	loop
		fetch _cur_solicitud_anticipo_societario INTO _solicitud_anticipo_societario;
		exit when not found;

		-- Redondeo de campos numericos tipo float

		_monto_aux = _solicitud_anticipo_societario.aporte_mensual;
		_aporte_mensual_aux = round((_monto_aux_redondeo / 1000),2);


		-- Actualizacion de registro de solicitud_anticipo_societario

		update solicitud_anticipo_societario set

			aporte_mensual 	= _aporte_mensual_aux
		where
			solicitud_anticipo_societario.id = _solicitud_anticipo_societario.id;

	end loop;

	close _cur_solicitud_anticipo_societario;

	raise notice 'Termino conversion de solicitud_anticipo_societario___________________';

	/*
	----------------------------------------------------
	Actualizacion de la tabla de desembolso a Bolivar
	fuerte
	----------------------------------------------------
	*/

	open _cur_desembolso 
	for select * from desembolso
	order by id;

	loop
		fetch _cur_desembolso INTO _desembolso;
		exit when not found;

		-- Redondeo de campos numericos tipo float

		_monto_aux_redondeo = _desembolso.monto;
		_monto_aux = round((_monto_aux_redondeo / 1000),2);

		_interes_desembolso_aux = round((_desembolso.interes_desembolso / 1000),2);

		-- Actualizacion de registro de desembolso

		update desembolso set

			monto 			= _monto_aux,
			interes_desembolso	= _interes_desembolso_aux
		where
			desembolso.id = _desembolso.id;

	end loop;

	close _cur_desembolso;

	raise notice 'Termino conversion de desembolso___________________';

	/*
	--------------------------------------------------------
	Actualizacion de la tabla de desembolso_pago a Bolivar
	fuerte
	--------------------------------------------------------
	*/

	open _cur_desembolso_pago 
	for select * from desembolso_pago
	order by id;

	loop
		fetch _cur_desembolso_pago INTO _desembolso_pago;
		exit when not found;

		-- Redondeo de campos numericos tipo float

		_monto_aux_redondeo = _desembolso_pago.monto;
		_monto_aux = round((_monto_aux_redondeo / 1000),2);

		-- Actualizacion de registro de desembolso_pago

		update desembolso_pago set

			monto 			= _monto_aux
		where
			desembolso_pago.id = _desembolso_pago.id;

	end loop;

	close _cur_desembolso_pago;

	raise notice 'Termino conversion de desembolso_pago___________________';

	/*
	--------------------------------------------------------
	Actualizacion de la tabla de pago_forma a Bolivar
	fuerte
	--------------------------------------------------------
	*/

	open _cur_pago_forma 
	for select * from pago_forma
	order by id;

	loop
		fetch _cur_pago_forma INTO _pago_forma;
		exit when not found;

		-- Redondeo de campos numericos tipo float

		_monto_aux_redondeo = _pago_forma.monto;
		_monto_aux = round((_monto_aux_redondeo / 1000),2);

		-- Actualizacion de registro de pago_forma
		update pago_forma set

			monto 			= _monto_aux
		where
			pago_forma.id = _pago_forma.id;

	end loop;

	close _cur_pago_forma;

	raise notice 'Termino conversion de pago_forma___________________';

	/*
	----------------------------------------------------
	Actualizacion de la tabla de pago_cliente a Bolivar
	fuerte
	----------------------------------------------------
	*/

	open _cur_pago_cliente 
	for select * from pago_cliente
	order by id;

	loop
		fetch _cur_pago_cliente INTO _pago_cliente;
		exit when not found;

		-- Redondeo de campos numericos tipo float

		_monto_aux_redondeo = _pago_cliente.monto;
		_monto_aux = round((_monto_aux_redondeo / 1000),2);

		_efectivo_aux = round((_pago_cliente.efectivo / 1000),2);

		-- Actualizacion de registro de desembolso

		update pago_cliente set

			monto 		= _monto_aux,
			efectivo	= _efectivo_aux
		where
			pago_cliente.id = _pago_cliente.id;

	end loop;

	close _cur_pago_cliente;

	raise notice 'Termino conversion de pago_cliente___________________';

	/*
	----------------------------------------------------
	Actualizacion de la tabla de pago_cuota a Bolivar
	fuerte
	----------------------------------------------------
	*/

	open _cur_pago_cuota
	for select * from pago_cuota
	order by id;

	loop
		fetch _cur_pago_cuota INTO _pago_cuota;
		exit when not found;

		_monto_aux = round((_pago_cuota.monto / 1000),2);
		_interes_corriente_aux = round((_pago_cuota.interes_corriente / 1000),2);
		_interes_diferido_aux = round((_pago_cuota.interes_diferido / 1000),2);
		_interes_mora_aux = round((_pago_cuota.interes_mora / 1000),2);
		_capital_aux = round((_pago_cuota.capital / 1000),2);
		_remanente_por_aplicar_aux = round((_pago_cuota.remanente_por_aplicar / 1000),2);
		_interes_desembolso_aux = round((_pago_cuota.interes_desembolso / 1000),2);

		-- Actualizacion de registro de pago_cuota

		update pago_cuota set

			monto 			= _monto_aux,
			interes_corriente	= _interes_corriente_aux,
			interes_diferido	= _interes_diferido_aux,
			interes_mora		= _interes_mora_aux,
			capital			= _capital_aux,
			remanente_por_aplicar	= _remanente_por_aplicar_aux,
			interes_desembolso	= _interes_desembolso_aux
		where
			pago_cuota.id = _pago_cuota.id;

	end loop;

	close _cur_pago_cuota;
	raise notice 'Termino conversion de pago_cuota___________________';

	/*
	----------------------------------------------------
	Actualizacion de la tabla de pago_prestamo a Bolivar
	fuerte
	----------------------------------------------------
	*/

	open _cur_pago_prestamo
	for select * from pago_prestamo
	order by id;

	loop
		fetch _cur_pago_prestamo INTO _pago_prestamo;
		exit when not found;

		_monto_aux = round((_pago_prestamo.monto / 1000),2);
		_interes_corriente_aux = round((_pago_prestamo.interes_corriente / 1000),2);
		_interes_diferido_aux = round((_pago_prestamo.interes_diferido / 1000),2);
		_interes_mora_aux = round((_pago_prestamo.interes_mora / 1000),2);
		_capital_aux = round((_pago_prestamo.capital / 1000),2);
		_remanente_por_aplicar_aux = round((_pago_prestamo.remanente_por_aplicar / 1000),2);
		_interes_desembolso_aux = round((_pago_prestamo.interes_desembolso / 1000),2);
		_interes_causado_aux = round((_pago_prestamo.interes_causado / 1000),2);
		_saldo_insoluto_aux = round((_pago_prestamo.saldo_insoluto / 1000),2);

		-- Actualizacion de registro de pago_prestamo

		update pago_prestamo set

			monto 			= _monto_aux,
			interes_corriente	= _interes_corriente_aux,
			interes_diferido	= _interes_diferido_aux,
			interes_mora		= _interes_mora_aux,
			capital			= _capital_aux,
			remanente_por_aplicar	= _remanente_por_aplicar_aux,
			interes_desembolso	= _interes_desembolso_aux,
			interes_causado		= _interes_causado_aux,
			saldo_insoluto		= _saldo_insoluto_aux
		where
			pago_prestamo.id = _pago_prestamo.id;

	end loop;

	close _cur_pago_prestamo;
	raise notice 'Termino conversion de pago_prestamo___________________';

	/*
	--------------------------------------------------------
	Actualizacion de la tabla de factura a Bolivar
	fuerte
	--------------------------------------------------------
	*/

	open _cur_factura 
	for select * from factura
	order by id;

	loop
		fetch _cur_factura INTO _factura;
		exit when not found;


		_monto_aux 	= round((_factura.monto / 1000),2);

		-- Actualizacion de registro de factura

		update factura set

			monto 			= _monto_aux
		where
			factura.id = _factura.id;

	end loop;

	close _cur_factura;

	raise notice 'Termino conversion de factura___________________';

	/*
	--------------------------------------------------------
	Actualizacion de la tabla de Garantia a Bolivar
	fuerte
	--------------------------------------------------------
	*/

	open _cur_garantia 
	for select * from garantia
	order by id;

	loop
		fetch _cur_garantia INTO _garantia;
		exit when not found;

		-- Redondeo de valores float

		_monto_aux_redondeo 		= _garantia.monto_garantia;
		_monto_garantia_aux 		= round((_monto_aux_redondeo / 1000),2);

		_monto_aux_redondeo 		= _garantia.monto_avaluo_inicial;
		_monto_avaluo_inicial_aux 	= round((_monto_aux_redondeo / 1000),2);

		_monto_aux_redondeo 		= _garantia.monto_avaluo_foncrei;
		_monto_avaluo_foncrei_aux 	= round((_monto_aux_redondeo / 1000),2);


		-- Actualizacion de registro de garantia

		update garantia set

			monto_garantia		= _monto_garantia_aux,
			monto_avaluo_inicial	= _monto_avaluo_inicial_aux,
			monto_avaluo_foncrei	= _monto_avaluo_foncrei_aux
		where
			garantia.id = _garantia.id;

	end loop;

	close _cur_garantia;

	raise notice 'Termino conversion de garantia___________________';

	/*
	--------------------------------------------------------
	Actualizacion de la tabla de empresa a Bolivar
	fuerte
	--------------------------------------------------------
	*/

	open _cur_empresa 
	for select * from empresa
	order by id;

	loop
		fetch _cur_empresa INTO _empresa;
		exit when not found;

		-- Redondeo de valores float

		_monto_aux_redondeo 	= _empresa.capital_suscrito;
		_capital_suscrito_aux 	= round((_monto_aux_redondeo / 1000),2);

		_monto_aux_redondeo 	= _empresa.capital_pagado;
		_capital_pagado_aux 	= round((_monto_aux_redondeo / 1000),2);

		_monto_aux_redondeo 		= _empresa.volumen_facturacion;
		_volumen_facturacion_aux 	= round((_monto_aux_redondeo / 1000),2);


		-- Actualizacion de registro de empresa
		update empresa set

			capital_suscrito	= _capital_suscrito_aux,
			capital_pagado		= _capital_pagado_aux,
			volumen_facturacion	= _volumen_facturacion_aux
		where
			empresa.id = _empresa.id;

	end loop;

	raise notice 'Termino conversion de empresa___________________';

	/*
	--------------------------------------------------------
	Actualizacion de la tabla de producto a Bolivar
	fuerte
	--------------------------------------------------------
	*/

	open _cur_producto 
	for select * from producto
	order by id;

	loop
		fetch _cur_producto INTO _producto;
		exit when not found;


		_monto_aux_redondeo 	= _producto.monto_maximo;
		_monto_maximo_aux 	= round((_monto_aux_redondeo / 1000),2);

		_monto_aux_redondeo 	= _producto.monto_minimo;
		_monto_minimo_aux 	= round((_monto_aux_redondeo / 1000),2);

		_monto_aux_redondeo 	= _producto.abono_monto_minimo;
		_abono_monto_minimo_aux	= round((_monto_aux_redondeo / 1000),2);

		-- Actualizacion de registro de garantia

		update producto set

			monto_maximo		= _monto_maximo_aux,
			monto_minimo		= _monto_minimo_aux,
			abono_monto_minimo	= _abono_monto_minimo_aux
		where
			producto.id = _producto.id;

	end loop;


	close _cur_producto;

	raise notice 'Termino conversion de producto___________________';


	/*
	--------------------------------------------------------
	Actualizacion de la tabla de Plan Pago Mora a Bolivar
	fuerte
	--------------------------------------------------------
	*/

	open _cur_plan_pago_mora 
	for select * from plan_pago_mora
	order by id;

	loop
		fetch _cur_plan_pago_mora INTO _plan_pago_mora;
		exit when not found;

		-- Redondeo de valores float

		_monto_aux_redondeo 	= _plan_pago_mora.monto;
		_monto_aux 		= round((_monto_aux_redondeo / 1000),2);

		_monto_aux_redondeo 	= _plan_pago_mora.capital;
		_capital_aux_f 		= round((_monto_aux_redondeo / 1000),2);

		_monto_aux_redondeo 	= _plan_pago_mora.valor;
		_valor_aux 		= round((_monto_aux_redondeo / 1000),2);


		-- Actualizacion de registro de Plan Pago Mora

		update plan_pago_mora set

			monto		= _monto_aux,
			capital		= _capital_aux_f,
			valor		= _valor_aux
		where
			plan_pago_mora.id = _plan_pago_mora.id;

	end loop;

	close _cur_plan_pago_mora;

	raise notice 'Termino conversion de plan pago mora___________________';



  return true;
 
end;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;
ALTER FUNCTION conversion_bolivar_fuerte_manual() OWNER TO cartera;
