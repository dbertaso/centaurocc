-- Function: generar_factura_insumos()

-- DROP FUNCTION generar_factura_insumos();

CREATE OR REPLACE FUNCTION generar_factura_insumos()
  RETURNS boolean AS
$BODY$

  declare
  
    _prestamo prestamo%rowtype;
    _factura factura%rowtype;
    _plan_pago plan_pago%rowtype;
    _plan_pago_cuota plan_pago_cuota%rowtype;
    _plan_pago_cuota_ultima plan_pago_cuota%rowtype;
    _cur_plan_pago_cuota refcursor;
    _cur_prestamo refcursor;
    _monto_insoluto numeric(16,2) = 0;
    _fecha_corte date;
    _fecha_inicio date;
    _fecha_calculo date;
    _plan_pago_id integer;
    _plan_pago_cuota_id integer;
    _desembolso_id integer = 0;
    
  begin
  
    open
        _cur_prestamo
    for
        select  
               pt.*
        from 
                prestamo_temporal pt inner join solicitud on (pt.solicitud_id = solicitud.id)
        where
                solicitud.estatus_id in (10100,10110);

                
    loop
    
      fetch _cur_prestamo INTO _prestamo;
      exit when not found;
      
      raise notice 'Prestamo Número ---------> %', _prestamo.numero;
      
      select
      into
            _factura *
      from
            factura
      where
            prestamo_id = _prestamo.id
      order by
            fecha_realizacion desc
      limit 1;
      
      if found then
      
        update 
                factura
        set
                monto_insumos = _prestamo.monto_facturado
        where
                id = _factura.id and
                prestamo_id = _prestamo.id;
      
      end if;

    
    end loop;
    
    close _cur_prestamo;
    
    return true;
    
  end;
  
  $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
