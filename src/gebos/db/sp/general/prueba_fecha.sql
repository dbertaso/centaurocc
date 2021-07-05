
-- Function: calcular_dias_360(date, date)

-- DROP FUNCTION calcular_dias_360(date, date);

--select prueba_fecha('2008-04-16', '2008-04-17');
CREATE OR REPLACE FUNCTION prueba_fecha(p_fecha_inicial date, p_fecha_final date)
  RETURNS integer AS
$BODY$

 declare

   _fecha date;
   _meses integer = 0;
   _dias integer = 0;
   _dias_total integer = 0;
   
 begin

   _dias_total = p_fecha_final - p_fecha_inicial;
   return _dias_total;





 end;


 $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
ALTER FUNCTION prueba_fecha(date, date) OWNER TO cartera;