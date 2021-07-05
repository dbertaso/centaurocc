create or replace function ejecutar_abono_extraordinario(
  p_cliente_id integer,
  p_prestamo_id integer,
  p_cheques varchar[][],
  p_modalidad char,
  p_monto float,
  p_oficina_id integer,  
  p_fecha date,
  p_efectivo float,
  p_numero_voucher varchar,
  p_entidad_financiera_id integer) returns integer as $$
declare
    _pago_cliente_id integer;   
    _pago_monto_prestamo float;
    _prestamo_id integer;
    _pago_prestamo_id integer;    
    _remanente_por_aplicar NUMERIC(14, 2);
    _factura_id integer;  
    _prestamo prestamo%rowtype;
    _entidad_financiera entidad_financiera%rowtype;
    _cuenta_contable_banco cuenta_contable%rowtype;    
    _codigo_cuenta_contable_banco integer = 0;
    
begin


  raise notice 'monto%',p_monto;
  -- Inserta el pago_cliente
  insert into pago_cliente (fecha, modalidad, monto, cliente_id, oficina_id, fecha_realizacion, numero_voucher, entidad_financiera_id, efectivo)
    values (p_fecha, p_modalidad, p_monto, p_cliente_id, p_oficina_id, p_fecha, p_numero_voucher, p_entidad_financiera_id, p_efectivo);
  
  _pago_cliente_id = currval('pago_cliente_id_seq');
  
  if p_modalidad = 'R' then
    select into _entidad_financiera * from entidad_financiera where id = p_entidad_financiera_id;
    select into _cuenta_contable_banco * from cuenta_contable where id = _entidad_financiera.cuenta_contable_id;
    _codigo_cuenta_contable_banco = _cuenta_contable_banco.id;
  end if;
  
  -- Inserta las pago_forma
  for i in array_lower(p_cheques,1) .. array_upper(p_cheques,1) loop
    insert into pago_forma (forma, entidad_financiera_id, referencia, monto, pago_cliente_id)
        values ( p_cheques[i][1], cast(p_cheques[i][2] as integer), p_cheques[i][3], 
        cast(p_cheques[i][4] as float), _pago_cliente_id );
  end loop;

  -- Paga los prestamos, recorre primero los prestamos que quiere pagar
 -- for i in array_lower(p_prestamos,1) .. array_upper(p_prestamos,1) loop  
      
   -- _pago_monto_prestamo = cast(p_prestamos[i][2] as float);
    _pago_monto_prestamo = p_monto;
    _prestamo_id = p_prestamo_id;
    
    select into _prestamo * from prestamo
      where id = _prestamo_id;
    
    _remanente_por_aplicar = _pago_monto_prestamo + _prestamo.remanente_por_aplicar ;
    
    raise notice 'remanente_por_aplicar antes de iniciar___________________%',_remanente_por_aplicar;     
    
    insert into pago_prestamo (monto, prestamo_id, pago_cliente_id)
        values(_pago_monto_prestamo, _prestamo_id, _pago_cliente_id);

    _pago_prestamo_id = currval('pago_prestamo_id_seq');

    
    update pago_prestamo set 
	  interes_diferido = 0,
	  interes_mora = 0,
	  interes_desembolso = 0,
	  interes_corriente = 0,
	  capital = 0,
	  remanente_por_aplicar = _remanente_por_aplicar,
	  monto = _pago_monto_prestamo
	  where id = _pago_prestamo_id;
    
    update prestamo set remanente_por_aplicar = _remanente_por_aplicar 
      where id = _prestamo_id;
      
    perform calcular_prestamo(_prestamo_id, p_fecha, false);  
    
    
  --end loop;
  
  insert into factura (numero, monto, fecha, fecha_realizacion, pago_cliente_id, tipo, proceso_nocturno, prestamo_id)
    values ((select numero from factura order by numero desc limit 1) + 1, p_monto, p_fecha,
    p_fecha, _pago_cliente_id, 'A', false, _prestamo_id);

  _factura_id = currval('factura_id_seq');
  
 update parametro_general set ultima_factura = ultima_factura + 1;
 
 raise notice 'modalidad________________%',  p_modalidad;
 raise notice '_codigo_cuenta_contable_banco________________%',  _codigo_cuenta_contable_banco;
  perform stc_abono_extraordinario_online(p_modalidad, _codigo_cuenta_contable_banco, p_monto, p_fecha, p_fecha, _prestamo_id, _factura_id, cast( extract(year from p_fecha) as integer));
    
 --raise exception 'error';
  return _factura_id;
  
end;
$$ language 'plpgsql' volatile;