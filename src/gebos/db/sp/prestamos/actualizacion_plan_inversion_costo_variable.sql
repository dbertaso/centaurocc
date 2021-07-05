-- Function: actualizar_plan_inversion_costo_variable()

-- DROP FUNCTION actualizar_plan_inversion_costo_variable();

CREATE OR REPLACE FUNCTION actualizar_plan_inversion_costo_variable(p_solicitud_id integer, 
                                                                  p_items_plan character varying[],
                                                                  p_hay_items boolean)
  RETURNS bool AS
$BODY$
declare
  
  _rechazos rechazos%rowtype;
  _solicitud solicitud%rowtype;
  _prestamo prestamo%rowtype;
  _programa programa%rowtype;
  _presupuesto_pidan presupuesto_pidan%rowtype;
  _plan_pago plan_pago%rowtype;
  _plan_pago_cuota plan_pago_cuota%rowtype;
  _desembolso desembolso%rowtype;
  _fecha_proceso_next date;

  -- Cursor para recorrer los programas sociales y efectuar el cierre diario de cartera
  _cur_solicitudes refcursor;
  _cur_desembolso refcursor;
  _cur_view_total_compromiso refcursor;
 

begin

  /*
  ----------------------------------------------------
  Actualización de plan de inversión de costos fijos
  ----------------------------------------------------
  */
  
  if p_hay_items = true then
  
    for i in array_lower(p_items_plan,1) .. array_upper(p_items_plan,1) 
      loop
        update
          plan_inversion 
        set
           cantidad = cast(p_items_plan[i][2] as numeric(16,3)),
           costo_real = cast(p_items_plan[i][3] as numeric(16,3)),
           monto_financiamiento = cast(p_items_plan[i][2] as numeric(16,3)) * cast(p_items_plan[i][3] as numeric(16,3))
        where
          id = cast(p_items_plan[i][1] as integer) and
          solicitud_id = p_solicitud_id;
          
          
      end loop;
    
  end if;
  
  return true;
 
end;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;

