create or replace function conversion_bolivar_fuerte() returns bool as $$
declare
  _prestamo prestamo%rowtype;
  _plan_pago plan_pago%rowtype;
  _plan_pago_cuota plan_pago_cuota%rowtype;
  _cur_plan_pago_cuota refcursor;
  _fecha_focal date;
  _plan_pago_id integer;
  _plan_pago_cuota_id integer;
  _monto_insoluto float;
  _meses_muertos integer = 0;
  _meses_gracia integer = 0;
  _plazo integer = 0;
  _motivo_evento char;
  _valor_tasa float = 0;
  _factura_id integer;
  
  _con_programa_origen_fondo programa_origen_fondo%rowtype;
  _con_solicitud solicitud%rowtype;
  
begin

    open _cur_prestamo for select * from 
    prestamo where estatus not in ('S', 'L', 'Q', 'R', 'C', 'F', 'A') order by id;

  loop
    fetch _cur_prestamo INTO _prestamo;
	exit when not found;

    #Selecciono el plan pago asociado al prestamo
    
    select into _plan_pago * from plan_pago 
      where plan_pago.prestamo_id = _prestamo.id and plan_pago.activo = true;
    	
	# Busca la fecha de la ultima cuota pagada
  
    select 
          into _plan_pago_cuota * from plan_pago_cuota
    
          where plan_pago_cuota.estatus_pago = 'T' and 
                plan_pago_cuota.plan_pago_id = _plan_pago.id
            
          order by fecha desc limit 1;
          
    if _plan_pago_cuota = nil then
        _fecha_focal = _prestamo.fecha_liquidacion;
    else
	    _fecha_focal = _plan_pago_cuota.fecha;
	end if;
	
	
	perform generar_plan_pago_evento(false,
	                                 _prestamo.id,
	                                 _fecha_focal,
	                                 false,
	                                 0,
	                                 false,
	                                 0,
	                                 true,
	                                 0,
	                                 0,
	                                 0);
  # A continuacion se actualizan los campos del prestamo
	
  end loop;
    
  
  return true;
 
end;
$$ language 'plpgsql' volatile;