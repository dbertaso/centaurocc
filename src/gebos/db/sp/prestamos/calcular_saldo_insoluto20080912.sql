-- Function: calcular_saldo_insoluto(integer, date, boolean)

-- DROP FUNCTION calcular_saldo_insoluto(integer, date, boolean);

CREATE OR REPLACE FUNCTION calcular_saldo_insoluto(p_prestamo_id integer, p_fecha_evento date, p_proyeccion boolean)
  RETURNS boolean AS
$BODY$



 declare  


   _prestamo prestamo%rowtype;
   _rec_plan_pago_cuota record;
   _cur_plan_pago_cuota refcursor;
   _plan_pago plan_pago%rowtype;
   _plan_pago_cuota plan_pago_cuota%rowtype;
   _saldo_insoluto numeric(16,2) = 0;
   _saldo_capitales numeric(16,2) = 0;

 begin

   select into _prestamo * from prestamo
     where id = p_prestamo_id;

   select into _plan_pago * from plan_pago 
     where prestamo_id = _prestamo.id and activo = true;


   select 
   into _saldo_insoluto
   
		sum(plan_pago_cuota.amortizado)
   from
		plan_pago_cuota
   where
		estatus_pago <> 'T' and
		tipo_cuota = 'C'    and
		plan_pago_id = _plan_pago.id
   group by
		plan_pago_id;
		
		

   update prestamo set saldo_insoluto = _saldo_insoluto where id = p_prestamo_id;
--   raise notice 'saldo_insoluto ____________% ', _saldo_insoluto;
   
   return true;
   
 end;





 $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
ALTER FUNCTION calcular_saldo_insoluto(integer, date, boolean) OWNER TO cartera;
