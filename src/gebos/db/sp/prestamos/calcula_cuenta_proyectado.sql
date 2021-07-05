CREATE OR REPLACE FUNCTION calcula_cuenta_proyectado(p_prestamo_id integer, p_fecha date)
  RETURNS boolean AS
$BODY$

declare _prestamo prestamo%rowtype;

begin
  select into _prestamo * from prestamo where prestamo.id = p_prestamo_id;
  
  if found then
    if _prestamo.intermediado = false then
     -- raise notice 'no es intermediado PRETAMO NUMERO ++++++++++++++++++++ %', _prestamo.numero;  
       perform actualizar_cuotas(_prestamo.id, p_fecha, false); 
    else
       perform actualizar_cuotas_intermediado(_prestamo.id, p_fecha); 
       perform actualizar_fecha_cobranza_intermediado(_prestamo.id, p_fecha); 
    end if;
      
    perform calcular_saldo_insoluto_dos(_prestamo.id, p_fecha, false);  
    perform calcular_interes_vencido(_prestamo.id, p_fecha, false); 
    perform calcular_capital_vencido(_prestamo.id, p_fecha, false); 
    perform calcular_interes_causado(_prestamo.id, p_fecha, false);        
    perform calcular_cuotas_vencidas(_prestamo.id, p_fecha, false);
    
    perform calcular_mora_mod(_prestamo.id, p_fecha, p_fecha, false,1);
    perform actualizar_deuda_exigible(_prestamo.id, false);

  end if;

  return true;
end;

$BODY$

  LANGUAGE 'plpgsql' VOLATILE;
