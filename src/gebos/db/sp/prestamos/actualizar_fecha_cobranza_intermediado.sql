create or replace function actualizar_fecha_cobranza_intermediado(
  p_prestamo_id integer,
  p_fecha_evento date) returns bool as $$
declare
  _prestamo prestamo%rowtype;
  _proxima_fecha date;
  _parametro_general parametro_general%rowtype;
begin

  select into _parametro_general * from parametro_general limit 1;
  select into _prestamo * from prestamo where id = p_prestamo_id;
 
  if _prestamo.fecha_cobranza_intermediario < p_fecha_evento then
    _proxima_fecha = agregar_meses(_prestamo.fecha_cobranza_intermediario, _prestamo.frecuencia_pago_intermediario);  
   
	if _prestamo.estatus = 'V' then
	   update prestamo set fecha_cobranza_intermediario = _proxima_fecha where id = _prestamo.id;   	 
	end if; 	
	if (_prestamo.estatus = 'E' or _prestamo.estatus = 'P') and _proxima_fecha =  p_fecha_evento then
	   update prestamo set fecha_cobranza_intermediario = _proxima_fecha where id = _prestamo.id;   	 
	end if;	
  end if;  	  

  return false;
 
end;
$$ language 'plpgsql' volatile;