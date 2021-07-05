create or replace function calcular_saldo_insoluto(
  p_prestamo_id integer,
  p_fecha_evento date,
  p_proyeccion bool) returns bool as $$
declare  
  _prestamo prestamo%rowtype;
  _rec_plan_pago_cuota record;
  _cur_plan_pago_cuota refcursor;
  _plan_pago plan_pago%rowtype;
  _plan_pago_cuota plan_pago_cuota%rowtype;
  _saldo_insoluto numeric(16,2) = 0;   
begin

  select into _prestamo * from prestamo
    where id = p_prestamo_id;

   
    
  select into _plan_pago * from plan_pago 
    where prestamo_id = p_prestamo_id and activo = not(p_proyeccion) and proyeccion = p_proyeccion;
 
    
  -- Recupera la ultima cuota pagada
  select into _plan_pago_cuota * from plan_pago_cuota 
    where plan_pago_id = _plan_pago.id and (estatus_pago = 'T' or estatus_pago = 'P')
    order by fecha desc limit 1;

  if not found then    
    _saldo_insoluto = _prestamo.monto_liquidado;
    open _cur_plan_pago_cuota for select 0.0 as monto_desembolso, 0.0 as monto_abono
       from plan_pago_cuota    
	  where plan_pago_id = _plan_pago.id;
	  
  else
    _saldo_insoluto = _plan_pago_cuota.saldo_insoluto;
    open _cur_plan_pago_cuota for select sum(monto_desembolso)  as monto_desembolso, sum(monto_abono) as monto_abono
        from plan_pago_cuota    
	   where id >= _plan_pago_cuota.id
	   and plan_pago_id = _plan_pago.id;
	
--	 open _cur_plan_pago_cuota for select sum(monto_desembolso)  as monto_desembolso, sum(monto_abono) as monto_abono
--	    from plan_pago_cuota    
--	    where id >= _plan_pago_cuota.id
--	    and plan_pago_id = _plan_pago.id;
--	  fetch _cur_plan_pago_cuota INTO _rec_plan_pago_cuota;	
--	  _saldo_insoluto = _saldo_insoluto + _rec_plan_pago_cuota.monto_desembolso - _rec_plan_pago_cuota.monto_abono;
  end if;

	fetch _cur_plan_pago_cuota INTO _rec_plan_pago_cuota;
	if found then
	_saldo_insoluto = _saldo_insoluto + _rec_plan_pago_cuota.monto_desembolso - _rec_plan_pago_cuota.monto_abono;    
    end if;
 
  if p_proyeccion = false then  
  	update prestamo set saldo_insoluto = _saldo_insoluto where id = p_prestamo_id;
  else
  	update prestamo set proyeccion_saldo_insoluto = _saldo_insoluto where id = p_prestamo_id;
  end if;
  return false;
 
end;
$$ language 'plpgsql' volatile;