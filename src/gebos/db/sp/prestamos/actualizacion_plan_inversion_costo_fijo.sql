-- Function: actualizar_plan_inversion_costo_fijo()

-- DROP FUNCTION actualizar_plan_inversion_costo_fijo();

CREATE OR REPLACE FUNCTION actualizar_plan_inversion_costo_fijo(p_solicitud_id integer, p_cantidad numeric(16,3))
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
  
        
  update 
          plan_inversion
  set
          cantidad = p_cantidad,
          monto_financiamiento = p_cantidad * costo_real
  where
          solicitud_id = p_solicitud_id;
  
  
  return true;
 
end;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;

