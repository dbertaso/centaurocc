-- Function: actualizar_compromiso()

-- DROP FUNCTION actualizar_compromiso();

CREATE OR REPLACE FUNCTION actualizar_compromiso()
  RETURNS bool AS
$BODY$
declare
  
  _rechazos rechazos%rowtype;
  _solicitud solicitud%rowtype;
  _prestamo prestamo%rowtype;
  _programa programa%rowtype;
  _presupuesto_pidan presupuesto_pidan%rowtype;
  _view_total_compromiso view_total_compromiso%rowtype;
  _plan_pago plan_pago%rowtype;
  _plan_pago_cuota plan_pago_cuota%rowtype;
  _desembolso desembolso%rowtype;
  _fecha_proceso_next date;

  -- Cursor para recorrer los programas sociales y efectuar el cierre diario de cartera
  _cur_plan_pago_cuota refcursor;
  _cur_desembolso refcursor;
  _cur_view_total_compromiso refcursor;
 

begin

	/*
	-------------------------------------------------------------------------------
	Crea cursor de rechazos
	-------------------------------------------------------------------------------
	*/

  open _cur_view_total_compromiso for 

    select 
      *
    from
      view_total_compromiso;

  loop

    fetch _cur_view_total_compromiso INTO _view_total_compromiso;
    exit when not found;
    
    select
    into
          _presupuesto_pidan *
    from
          presupuesto_pidan
    where
          presupuesto_pidan.estado_id = _view_total_compromiso.estado_id and
          presupuesto_pidan.rubro_id = _view_total_compromiso.rubro_id and
          presupuesto_pidan.sub_rubro_id = _view_total_compromiso.sub_rubro_id;
          
    if found then
    
       
       update
              presupuesto_pidan
       set
              compromiso = _view_total_compromiso."Compromiso"
       where
            presupuesto_pidan.estado_id = _view_total_compromiso.estado_id and
            presupuesto_pidan.rubro_id = _view_total_compromiso.rubro_id and
            presupuesto_pidan.sub_rubro_id = _view_total_compromiso.sub_rubro_id;
       
      
    end if;

  end loop;
		
  close _cur_view_total_compromiso;

  return true;
 
end;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;

