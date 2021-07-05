-- Recalcula un préstamo en específico (Mora, Interes Vencidos, 
-- Saldo insoluto, etc). Igual que el cierre diario, pero para un préstamo 
-- en específico. Esta función no genera pagos ni abonos

create or replace function calcular_prestamo(
  p_prestamo_id integer,
  p_fecha_evento date,
  p_proyeccion bool) returns bool as $$
declare
  _prestamo prestamo%rowtype;
  _tasa_historico tasa_historico%rowtype;
  _plan_pago plan_pago%rowtype;
  _fecha_revision_tasa date;
  _cantidad_cuotas_mora integer = 0;
begin


  select into _plan_pago * from plan_pago 
	  where prestamo_id = p_prestamo_id and activo = not(p_proyeccion) and proyeccion = p_proyeccion;
	    
	    
	raise notice 'ENTRA A CALCULAR EL PRESTAMO *********************************************';
  select into _prestamo * from prestamo where id = p_prestamo_id;
  if _prestamo.estatus <> 'L' then
	  perform actualizar_cuotas(p_prestamo_id, p_fecha_evento, p_proyeccion);
  end if;
  perform calcular_saldo_insoluto(p_prestamo_id, p_fecha_evento, p_proyeccion);
  perform calcular_interes_vencido(p_prestamo_id, p_fecha_evento, p_proyeccion);
  perform calcular_capital_vencido(p_prestamo_id, p_fecha_evento, p_proyeccion);
  if _prestamo.estatus <> 'L' then
    perform calcular_interes_causado(p_prestamo_id, p_fecha_evento, p_proyeccion);
  end if;
  perform calcular_cuotas_vencidas(p_prestamo_id, p_fecha_evento, p_proyeccion);
  if _prestamo.estatus <> 'L' then
  	update prestamo set dias_mora = 
  		(select sum(dias_mora) from plan_pago_cuota where estatus_pago in ('N', 'P') and plan_pago_id in 
  		(select id from plan_pago where prestamo_id = _prestamo.id and activo = true )),
  		monto_mora = 
  		(select sum(interes_mora - pago_interes_mora) from plan_pago_cuota where estatus_pago in ('N', 'P') and vencida = true and plan_pago_id in 
  		(select id from plan_pago where prestamo_id = _prestamo.id and activo = true )) where id = p_prestamo_id;
   -- perform calcular_mora(p_prestamo_id, p_fecha_evento, p_fecha_evento, p_proyeccion);

	  select into  _cantidad_cuotas_mora count(*) from plan_pago_cuota where plan_pago_id = _plan_pago.id and estatus_pago in ('N', 'P') and vencida = true and dias_mora > 0;
	  
	  if _cantidad_cuotas_mora > 0 then
	  	if _prestamo.numero =  8000000764 then
		raise notice '????????????????_va poner el prestamo en vencido cuotas__%', _cantidad_cuotas_mora;
		end if;
	  	update prestamo set estatus = 'E' where id = p_prestamo_id;
	  end if;
	  
  end if;
  perform actualizar_deuda_exigible(p_prestamo_id, p_proyeccion);
  
  if p_proyeccion = false then  
	  -- Si el prestamo se pagó en su totalidad lo actualiza a cancelado 
	  select into _prestamo * from prestamo where id = p_prestamo_id;
	  if _prestamo.deuda <= 0 then
	    raise notice 'Le Cambió el Estatus del Préstamo a Cancelado';
	    update prestamo set estatus = 'C' where id = _prestamo.id;
	  end if;
  end if;
--  if (_prestamo.fecha_revision_tasa = p_fecha_evento) then
--  raise notice 'SI ES FECHA DE REVISION';
    
--    _fecha_revision_tasa = _prestamo.fecha_revision_tasa;
--    
--    select into _tasa_historico * from tasa_historico
--      where tasa_valor_id in (select id from tasa_valor where tasa_id = _prestamo.tasa_id) order by id desc limit 1;
--    raise notice 'BUSCO LA ULTIMA TASA%',_tasa_historico.tasa_cliente;  
--    
--    if (_tasa_historico.tasa_cliente <> _prestamo.tasa_vigente)  then    
--    
--      raise notice 'LA ULTIMA TASA ES DIFERENTE A LA TASA ACTUAL DEL PRESTAMO';
--      perform generar_plan_pago_evento(false, p_prestamo_id, p_fecha_evento, false, 0, true, _tasa_historico.tasa_cliente, false,0);
--     raise notice 'GENERO EL NUEVO PLAN PAGO';
--      
--      insert into prestamo_tasa_historico 
--        (tasa_foncrei, tasa_intermediario, tasa_cliente, prestamo_id, tasa_historico_id, fecha) 
--        values(_tasa_historico.tasa_foncrei, _tasa_historico.tasa_intermediario,
--        _tasa_historico.tasa_cliente, p_prestamo_id, _tasa_historico.id, p_fecha_evento);
--        raise notice 'GRABO EL HISTORICO DEL PRESTAMO';
--        
--        
--        _fecha_revision_tasa = agregar_meses(_fecha_revision_tasa, _prestamo.meses_fijos_sin_cambio_tasa);
--        
--        
--        raise notice 'CALCULO LA NUEVA FECHA DE REVISION%',_fecha_revision_tasa;
--        update prestamo set  fecha_revision_tasa =  
--          _fecha_revision_tasa, tasa_vigente = _tasa_historico.tasa_cliente
--          where id = p_prestamo_id;
--        raise notice 'ACTUALIZO EL PRESTAMO';
--        
--   end if;
--  end if;
  --raise exception 'HUBO ERROR';
  return true;
 
end;
$$ language 'plpgsql' volatile;