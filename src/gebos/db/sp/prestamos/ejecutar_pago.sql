create or replace function ejecutar_pago(
  p_cliente_id integer,
  p_cheques varchar[][],
  p_prestamo_id integer,
  p_modalidad char,
  p_monto float,
  p_oficina_id integer,
  p_fecha_realizacion date,
  p_fecha date,
  p_numero_voucher varchar,
  p_monto_efectivo float,
  p_entidad_financiera_id integer,
  p_proceso_nocturno bool,
  p_hay_cheques bool,
  p_exonerar_mora bool ) returns integer as $$
declare
    _factura_id integer;
 
begin
 _factura_id = ejecutar_pago(
	  p_cliente_id,
	  p_cheques,
	  p_prestamo_id,
	  p_modalidad,
	  p_monto,
	  p_oficina_id,
	  p_fecha_realizacion,
	  p_fecha,
	  p_numero_voucher,
	  p_monto_efectivo,
	  p_entidad_financiera_id,
	  p_proceso_nocturno, false, p_hay_cheques, p_exonerar_mora);
  
  return _factura_id;

  
end;
$$ language 'plpgsql' volatile;