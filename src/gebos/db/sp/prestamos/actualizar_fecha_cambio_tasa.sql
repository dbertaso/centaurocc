create or replace function actualizar_fecha_cambio_tasa(
  p_prestamo_id integer,
  p_fecha_evento date) returns bool as $$
declare
  _prestamo prestamo%rowtype;
  _plan_pago_cuota plan_pago_cuota%rowtype;
  _fecha_revision_tasa date;

begin

  select into _prestamo * from prestamo where id = p_prestamo_id;

  select into _plan_pago_cuota * from plan_pago_cuota 
    where plan_pago_id in (select id from plan_pago 
    where prestamo_id = p_prestamo_id and activo = true 
    and proyeccion = false) and tipo_cuota = 'C' order by numero desc limit 1;

  _fecha_revision_tasa = agregar_meses(_prestamo.fecha_revision_tasa, _prestamo.meses_fijos_sin_cambio_tasa);
     
  if  _fecha_revision_tasa < _plan_pago_cuota.fecha then   		    
    update prestamo set  fecha_revision_tasa =  _fecha_revision_tasa where id = _prestamo.id;	
  end if;
  
  return false;
 
end;
$$ language 'plpgsql' volatile;