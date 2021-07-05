create or replace function calcular_interes_causado(
  p_prestamo_id integer,
  p_fecha_evento date,
  p_proyeccion bool) returns bool as $$
declare
  _prestamo prestamo%rowtype;
  _plan_pago plan_pago%rowtype;
  _plan_pago_cuota plan_pago_cuota%rowtype;
  _plan_pago_cuota_anterior plan_pago_cuota%rowtype;
  _monto_causado numeric = 0;
  _dias_causados integer = 0;
  _fecha date;
  _fecha_ultima_cuota date;
  _base_calculo_intereses integer = 0;
  _saldo_insoluto numeric;
begin

  select into _prestamo * from prestamo
    where id = p_prestamo_id;

 raise notice '[GEBOS] calcular_interes_causado: NUMERO PRESTAMO_____________________________%',_prestamo.numero;

  _base_calculo_intereses = _prestamo.base_calculo_intereses;

  select into _plan_pago * from plan_pago
    where prestamo_id = p_prestamo_id and activo = not(p_proyeccion) and proyeccion = p_proyeccion;

  update plan_pago_cuota set causado_no_devengado = 0
    where causado_no_devengado <> 0 and plan_pago_id = _plan_pago.id;

  if p_proyeccion = false then
  	update prestamo set causado_no_devengado = 0 where id = p_prestamo_id;
  else
  	update prestamo set proyeccion_causado_no_devengado = 0 where id = p_prestamo_id;
  end if;

-- Recupera la ultima cuota anterior a la fecha de evaluación
  select into _plan_pago_cuota_anterior * from plan_pago_cuota
    where plan_pago_id = _plan_pago.id
    and fecha < p_fecha_evento order by fecha desc limit 1;
  if found then
    _saldo_insoluto = _plan_pago_cuota_anterior.saldo_insoluto+_plan_pago_cuota_anterior.monto_desembolso-_plan_pago_cuota_anterior.monto_abono;
    _fecha_ultima_cuota = _plan_pago_cuota_anterior.fecha;
  else
    -- Si no encuentra una cuota anterior busca el monto del prestamo
    _saldo_insoluto = _plan_pago.monto;
    select into _fecha_ultima_cuota fecha_liquidacion from prestamo where id = p_prestamo_id;
  end if;

-- Recupera la ultima cuota posterior a la fecha de evaluación
  select into _plan_pago_cuota * from plan_pago_cuota
    where plan_pago_id = _plan_pago.id and interes_corriente > pago_interes_corriente
    and fecha >= p_fecha_evento order by fecha asc limit 1;

  if found then
    --raise notice 'si_encontro***__________%',_plan_pago_cuota.numero;
    --raise notice 'si_encontro***__________%',_plan_pago_cuota.tipo_cuota;
    --_fecha = agregar_meses(_plan_pago_cuota.fecha,-_prestamo.frecuencia_pago);
    raise notice '[GEBOS] calcular_interes_causado: _fecha cuota siguiente***__________%', _plan_pago_cuota.fecha;
    if _base_calculo_intereses = 360 then
      --_dias_causados = calcular_dias_360(_fecha, p_fecha_evento)-1;
      -- Se reemplazo la sentencia anterior por la siguiente
      -- Diego Bertaso
      --_dias_causados = calcular_dias_360(_fecha, p_fecha_evento);
      _dias_causados = p_fecha_evento - _fecha_ultima_cuota;
    else
      --_dias_causados = (p_fecha_evento - _fecha)-1;
      _dias_causados = p_fecha_evento - _fecha_ultima_cuota;
    end if;
        raise notice '[GEBOS] calcular_interes_causado: SALDO INSOLUTO_____________________________%',_saldo_insoluto;
        raise notice '[GEBOS] calcular_interes_causado: TASA_VIGENTE_____________________________%',_prestamo.tasa_vigente;
        raise notice '[GEBOS] calcular_interes_causado: BASE CALCULO INTERES_____________________________%',_base_calculo_intereses;
        raise notice '[GEBOS] calcular_interes_causado: DIAS CAUSADOS_____________________________%',_dias_causados;
	if _dias_causados > 0 then
	  _monto_causado = (((_prestamo.tasa_vigente/100)/_base_calculo_intereses)*
	     (_saldo_insoluto))*_dias_causados;
	  raise notice '[GEBOS] calcular_interes_causado: MONTO_CAUSADO_____________________________%',_monto_causado;
	  update plan_pago_cuota set causado_no_devengado = _monto_causado where id = _plan_pago_cuota.id;
	  if p_proyeccion = false then
	  	update prestamo set causado_no_devengado = _monto_causado where id = p_prestamo_id;
	  else
	  	update prestamo set proyeccion_causado_no_devengado = _monto_causado where id = p_prestamo_id;
	  end if;
	end if;
  end if;
   return false;

end;
$$ language 'plpgsql' volatile;