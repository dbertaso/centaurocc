create or replace function calcular_prestamo_proyeccion(
  p_prestamo_id integer,
  p_fecha_evento date,
  p_monto_abono float) returns bool as $$
declare
  _prestamo prestamo%rowtype;
  _tasa_historico tasa_historico%rowtype;
  _fecha_revision_tasa date;
begin

  update prestamo set proyeccion_remanente_por_aplicar = remanente_por_aplicar where id = p_prestamo_id;
  
  raise notice 'MONTO_ABONO***************************************************%',p_monto_abono;
  
  if p_monto_abono > 0 then
  	update prestamo set proyeccion_remanente_por_aplicar = proyeccion_remanente_por_aplicar + p_monto_abono where id = p_prestamo_id;
  	raise notice 'ENTRA 1 ***************************************************';
  end if;
  
  perform generar_plan_pago_evento(true, p_prestamo_id, p_fecha_evento, false, 0, false, 0, false, 0,0,0);
  	
  select into _prestamo * from prestamo where id = p_prestamo_id;
  
  perform actualizar_cuotas(p_prestamo_id, p_fecha_evento, true);
  perform calcular_saldo_insoluto(p_prestamo_id, p_fecha_evento, true);
  perform calcular_interes_vencido(p_prestamo_id, p_fecha_evento, true);
  perform calcular_capital_vencido(p_prestamo_id, p_fecha_evento, true);
  perform calcular_interes_causado(p_prestamo_id, p_fecha_evento, true);
  perform calcular_cuotas_vencidas(p_prestamo_id, p_fecha_evento, true);
  perform calcular_mora(p_prestamo_id, p_fecha_evento, true);
  perform actualizar_deuda_exigible(p_prestamo_id, true);
  
   raise notice 'REMANENTE POR APLICAR  ***************************************************%',_prestamo.proyeccion_remanente_por_aplicar;
    	
  if p_monto_abono > 0 then
    raise notice 'ENTRA 2 ***************************************************';
  	perform generar_plan_pago_evento(true, _prestamo.id, p_fecha_evento, false, 0, false, 0, true, _prestamo.proyeccion_remanente_por_aplicar,0, 0);
  	update prestamo set proyeccion_remanente_por_aplicar = 0 where id = p_prestamo_id;
  end if; 	
		  
  perform calcular_saldo_insoluto(p_prestamo_id, p_fecha_evento, true);
  perform calcular_interes_vencido(p_prestamo_id, p_fecha_evento, true);
  perform calcular_capital_vencido(p_prestamo_id, p_fecha_evento, true);
  perform calcular_interes_causado(p_prestamo_id, p_fecha_evento, true);
  perform calcular_cuotas_vencidas(p_prestamo_id, p_fecha_evento, true);
  perform calcular_mora(p_prestamo_id, p_fecha_evento, true);
  perform actualizar_deuda_exigible(p_prestamo_id, true);
  
  --raise exception 'HUBO ERROR';
  return true;
 
end;
$$ language 'plpgsql' volatile;