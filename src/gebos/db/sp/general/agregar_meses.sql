create or replace function agregar_meses(p_fecha date, p_meses integer)
  returns date as
$$
declare
  _fecha_fin date;
  _intervalo interval;
  _interval_units varchar;

begin
  _interval_units := 'month';
  _intervalo := ('\' || p_meses || ' ' ||
  _interval_units || '\')::interval;
  select p_fecha + _intervalo  into _fecha_fin;
  return _fecha_fin;
end;
$$ language 'plpgsql' volatile;
