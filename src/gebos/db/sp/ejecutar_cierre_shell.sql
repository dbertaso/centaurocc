-- Function: ejecutar_cierre_shell()

-- DROP FUNCTION ejecutar_cierre_shell();

CREATE OR REPLACE FUNCTION ejecutar_cierre_shell()
  RETURNS boolean AS
$BODY$
declare  
  _programa programa%rowtype;
  _control_cierre control_cierre%rowtype;
  _fecha_proceso_next date;

  -- Cursor para recorrer los programas sociales y efectuar el cierre diario de cartera
  _cur_programa refcursor;
  
  
begin

	/*
	-------------------------------------------------------------------------------
	Se verifica que el cierre no se encuentre ejecutandose o que ya fue ejecutado.
	-------------------------------------------------------------------------------
	*/

	select into 
			_control_cierre * 
	from 
			control_cierre  
	where
			control_cierre.senal_enproceso 	= false and
			control_cierre.senal_cerrado	= false and
      control_cierre.senal_shell	= true
	order by	
			fecha_proceso desc
	limit 1;

	if _control_cierre.fecha_proceso is not null then
	
		/*
		------------------------------------------------------------------
		Actualizacion de la senal de shell para la tabla control_cierre
		-------------------------------------------------------------------
		*/

		update control_cierre set
					senal_shell = false
		where
					control_cierre.id = _control_cierre.id;


	end if;				--> if _control_cierre.fecha_proceso is not null then
    
  return true;
 
end;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION ejecutar_cierre_shell() OWNER TO cartera;
