/*****************************************************************************************************

 Función que ajusta el monto de los interes corriente
 dado.
 Params:
 @p_prestamo_id		Identificador del préstamo
 @p_fecha_evento	Fecha a la que se realizará el ajuste

 Desarrollado por: Alexander Belisario
*****************************************************************************************************/
-- Function: ajustar_intereses(integer, date)

-- DROP FUNCTION ajustar_intereses(integer, date);

CREATE OR REPLACE FUNCTION ajustar_intereses(p_prestamo_id integer, p_fecha_evento date)
  RETURNS numeric AS
$BODY$
declare

  _prestamo prestamo%rowtype;
  _tasa_valor tasa_valor%rowtype;
  _plan_pago plan_pago%rowtype;
  _cuota_anterior plan_pago_cuota%rowtype;
  _cuota_siguiente plan_pago_cuota%rowtype;

  _cur_plan_pago_cuota refcursor;
  _cur_tasa_valor refcursor;


  _fecha_cuota_anterior date;
  _fecha_cuota_siguiente date;
  _tasa_activa float;
  _tpp float;

begin

        raise info '[GEBOS] ajustar_intereses {p_prestamo_id: %, p_fecha_evento: %', p_prestamo_id, p_fecha_evento;
	/*
	----------------------
	Paso 1: Lectura del prestamo
	----------------------
	*/

	select
	  into _prestamo *
	from
	  prestamo
	where
	  prestamo.id = p_prestamo_id;

	if not found then
          raise debug '[GEBOS] ajustar_intereses: Préstamo % no encontrado', p_prestamo_id;
          return 0;
	end if;

	/*
	----------------------
	paso 2: Lectura del plan_pago
	----------------------
	*/

	select
	  into _plan_pago *
	from
	  plan_pago
	where
	  plan_pago.prestamo_id = _prestamo.id and activo = true;

	if not found then
          raise debug '[GEBOS] ajustar_intereses: Plan_Pago no encontrado';
          return 0;
	end if;

	/*
	----------------------
	paso 3: Lectura de cuotas plan_pago_cuota
	(Cuota anterior y siguiente a la fecha actual)
	----------------------
	*/
	open _cur_plan_pago_cuota for
	  select *, ABS(fecha - p_fecha_evento) as indice
	  from plan_pago_cuota
	  where plan_pago_id = _plan_pago.id and ABS(fecha - p_fecha_evento) <= 30 * _prestamo.frecuencia_pago
	  order by indice, fecha
	  limit 2;

	if not found then
	  close _cur_plan_pago_cuota;
          raise debug '[GEBOS] ajustar_intereses: No existen cuotas próximas';
          return 0;
	end if;

        -- Caso 1 ideal: existe una cuota anterior y una cuota siguiente
        fetch _cur_plan_pago_cuota INTO _cuota_anterior;
        fetch _cur_plan_pago_cuota INTO _cuota_siguiente;
        _fecha_cuota_anterior = _cuota_anterior.fecha;
        _fecha_cuota_siguiente = _cuota_siguiente.fecha;

        if p_fecha_evento = _fecha_cuota_anterior then
          close _cur_plan_pago_cuota;
          raise debug '[GEBOS] ajustar_intereses: Fecha actual corresponde a la fecha focal';
          return 0;
        end if;

        if p_fecha_evento > _fecha_cuota_siguiente then
          close _cur_plan_pago_cuota;
          raise debug '[GEBOS] ajustar_intereses: Ultima cuota ya aplicada';
          return 0;
        end if;

        if p_fecha_evento < _fecha_cuota_anterior then
          -- Caso 2: No existe una cuota anterior. El cambio ocurrió antes de la primera cuota --
          _cuota_siguiente = _cuota_anterior;
          _fecha_cuota_siguiente = _cuota_anterior.fecha;
          _fecha_cuota_anterior = _prestamo.fecha_inicio;
        end if;

	select
	  into _tasa_activa valor
	from
	  tasa_valor
	where
	  tasa_id = _prestamo.tasa_id
	  and fecha_resolucion_hasta is null;

	/*
	---------------------
	Paso 4: Cambios de tasa ocurridos en el intervalo de fecha entre cuotas
	----------------------
	*/
        open _cur_tasa_valor for
          select *
          from tasa_valor
          where tasa_id = _prestamo.tasa_id
            and (fecha_resolucion_desde between _fecha_cuota_anterior and _fecha_cuota_siguiente
                 or fecha_resolucion_hasta between _fecha_cuota_anterior and _fecha_cuota_siguiente
                 or fecha_resolucion_hasta is null)
          order by fecha_resolucion_desde asc;


	_tpp = calcular_tasa_promedio(_prestamo.tasa_id, _fecha_cuota_anterior, _fecha_cuota_siguiente);
	raise debug '[GEBOS] ajustar_intereses: Tasa calculada____ %', _tpp;
        if _tpp <> _tasa_activa then
          raise debug '[GEBOS] ajustar_intereses: Ocurrió un cambio de tasa';
          --Ajusto el monto de interés corriente en base a la tpp, si se encuentra variación en la tasa
          update plan_pago_cuota
            set interes_corriente = (saldo_insoluto * _tpp / 36000) * 30 * _prestamo.frecuencia_pago
           where id = _cuota_siguiente.id;

          --Ajusto el monto de la cuota
          update plan_pago_cuota
            set valor_cuota = amortizado + interes_corriente
           where id = _cuota_siguiente.id;
	end if;
	close _cur_plan_pago_cuota;
	close _cur_tasa_valor;
        raise info '[GEBOS] ajustar_intereses finalizado. Retorna tpp: %', _tpp;
  return _tpp;

end;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE;
ALTER FUNCTION ajustar_intereses(integer, date) OWNER TO cartera;