create or replace function generar_plan_pago_reestructuracion(
  p_prestamo_id integer,
  p_fecha date,
  p_formula_id integer,
  p_frecuencia_pago integer,
  p_monto float,
  p_plazo integer,
  p_valor_tasa float
  ) returns bool as $$
declare
  
  
begin

  perform generar_plan_pago(
    false,
    p_formula_id,
    p_prestamo_id,
    0,
    null,
    'C',
    0,
    0,
    p_fecha,
    p_monto,
    p_plazo,
    p_frecuencia_pago,
    p_valor_tasa,
    0,
    0,
    0,
    false,
    p_valor_tasa,
    p_frecuencia_pago,
    null,
    true,
    null,
    0
  );  
  
  return true;
 
end;
$$ language 'plpgsql' volatile;