-- Function: actualizamontodesembolsocuota(pid_programa int4)

-- DROP FUNCTION actualizamontodesembolsocuota(pid_programa int4);

CREATE OR REPLACE FUNCTION last_day(date_last_day date)
  RETURNS date AS
$BODY$

begin 

return  ((date_trunc('month', date_last_day) + interval '1 month') - interval '1 day')::date;
 
end;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE; 
ALTER FUNCTION last_day(date_last_day date) OWNER TO cartera;
