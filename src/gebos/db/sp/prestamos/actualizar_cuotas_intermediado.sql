create or replace function actualizar_cuotas_intermediado(
  p_prestamo_id integer,
  p_fecha_evento date) returns bool as $$
declare
  _prestamo prestamo%rowtype;
  _plan_pago plan_pago%rowtype;
  _plan_pago_cuota plan_pago_cuota%rowtype;  
  _cur_plan_pago_cuota refcursor;  
  _vencido bool = false;
begin

  select into _prestamo * from prestamo where id = p_prestamo_id;
    
  if found then    
    
	  select into _plan_pago * from plan_pago 
	    where prestamo_id = p_prestamo_id and activo = true and proyeccion = false;
	  
	  --update prestamo set estatus = 'V' where id = p_prestamo_id;
	    
	  
	  open _cur_plan_pago_cuota for select * from plan_pago_cuota 
	    where plan_pago_id = _plan_pago.id and fecha <= p_fecha_evento and ( tipo_cuota = 'C' or tipo_cuota = 'G' )
	    and (estatus_pago = 'N' or estatus_pago = 'P' or estatus_pago = 'X') order by fecha asc;
	
	  loop
	    fetch _cur_plan_pago_cuota INTO _plan_pago_cuota;
		exit when not found;
		
		_vencido = true;			
	    update plan_pago_cuota set vencida = true, estatus_pago = 'N'
		  where id = _plan_pago_cuota.id;	
	  end loop;
	  
	  if _prestamo.fecha_cobranza_intermediario <= p_fecha_evento and _prestamo.estatus <> 'E' then
	    if _vencido = true then
	      update prestamo set estatus = 'P' where id = p_prestamo_id;    
	    end if;
      end if;  	  
  end if;
  return false;
 
end;
$$ language 'plpgsql' volatile;