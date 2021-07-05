create or replace function calcular_cuotas_vencidas(
  p_prestamo_id integer,
  p_fecha_evento date,
  p_proyeccion bool) returns bool as $$
declare  
  _plan_pago plan_pago%rowtype;
  _plan_pago_cuota record;
  _cur_plan_pago_cuota refcursor;  
begin

 update prestamo set monto_cuotas_vencidas = 0 
        where id = p_prestamo_id;
        
  select into _plan_pago * from plan_pago 
    where prestamo_id = p_prestamo_id and activo = not(p_proyeccion) and proyeccion = p_proyeccion;
  
  open _cur_plan_pago_cuota for select 
    sum((valor_cuota + interes_diferido + interes_desembolso) -(pago_interes_corriente + pago_capital + pago_interes_diferido + pago_interes_desembolso)) as total_monto, count(id) as total_cantidad
    from plan_pago_cuota 
    where vencida = true and estatus_pago <> 'T' 
    and plan_pago_id = _plan_pago.id;
   
   fetch _cur_plan_pago_cuota INTO _plan_pago_cuota;
   
   if found then   
     if p_proyeccion = false then
     	update prestamo set monto_cuotas_vencidas = _plan_pago_cuota.total_monto,
        	cantidad_cuotas_vencidas = _plan_pago_cuota.total_cantidad
        	where id = p_prestamo_id;
     else
     	update prestamo set proyeccion_monto_cuotas_vencidas = _plan_pago_cuota.total_monto,
        	proyeccion_cantidad_cuotas_vencidas = _plan_pago_cuota.total_cantidad
        	where id = p_prestamo_id;     
     end if;   
   end if;   
    
   return false;

end;
$$ language 'plpgsql' volatile;