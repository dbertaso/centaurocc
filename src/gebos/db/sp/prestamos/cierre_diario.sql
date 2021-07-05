create or replace function cierre_diario(
declare
  _parametro_general parametro_general%rowtype;
  _fecha_hoy date;
begin

  select into _parametro_general for select * from parametro_general;

  _proxima_fecha = agregar_dias(_parametro_general, 1);	 

  perform calcular_cartera(_parametro_general.fecha_proximo_cierre, 1); 
  
  update set fecha_ultimo_cierre = fecha_proximo_cierre, fecha_proximo_cierre = _proxima_fecha;
  
  return true;
 
end;
$$ language 'plpgsql' volatile;