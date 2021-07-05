create or replace function agregar_dias(p_fecha date, p_dias integer)
  returns date as
$BODY$
declare
  _fecha_fin date;
  _intervalo interval;
  _interval_units varchar;

begin
  _interval_units := 'day';
  _intervalo := ('\' || p_dias || ' ' ||
  _interval_units || '\')::interval;
  select p_fecha + _intervalo  into _fecha_fin;
  return _fecha_fin;
end;
$BODY$
language 'plpgsql' volatile;
