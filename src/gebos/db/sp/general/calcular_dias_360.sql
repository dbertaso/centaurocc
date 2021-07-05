create or replace function calcular_dias_360(p_fecha_inicial date, p_fecha_final date)
  returns integer as
$$
declare
  _fecha date;
  _meses integer = 0;
  _dias integer = 0;
  _dias_total integer = 0;
begin
  if (p_fecha_inicial > p_fecha_final) or (p_fecha_inicial is null) 
      or (p_fecha_final is null) then
    return 0;
  end if;
	loop
	 _meses = _meses + 1;
	 _fecha = agregar_meses(p_fecha_inicial, _meses );	 
	 if _fecha > p_fecha_final then
	  -- raise notice 'es_mayor';
	   _meses = _meses - 1;
	   _fecha = agregar_meses(p_fecha_inicial, _meses );
	   --raise notice '_fecha___________%',_fecha;
	   --raise notice '_fecha_final___________%',p_fecha_final;
	   _dias = p_fecha_final - _fecha;
	   --raise notice '_dias___________%',_dias;
	   exit;
	 end if;
	end loop;
	_dias_total = (_meses*30)+_dias;
  return _dias_total;
end;
$$ language 'plpgsql' volatile;