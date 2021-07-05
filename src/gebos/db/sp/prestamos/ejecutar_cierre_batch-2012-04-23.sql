-- Function: ejecutar_cierre_batch()

-- DROP FUNCTION ejecutar_cierre_batch();

CREATE OR REPLACE FUNCTION ejecutar_cierre_batch()
  RETURNS boolean AS
$BODY$
declare
  _programa programa%rowtype;
  _control_cierre control_cierre%rowtype;
  _fecha_proceso_next date;
  _primero integer = 0;
  _ultimo integer = 0;

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
                control_cierre.senal_enproceso 	= true and
                control_cierre.senal_cerrado	= false and
                control_cierre.senal_shell	= false;

    if _control_cierre.fecha_proceso is not null then

      /*
      ------------------------------------------------------------------
      Actualizacion de la senal en proceso para la tabla control_cierre
      -------------------------------------------------------------------
      */


      raise notice 'Prestamo Inicio cierre__________________________________ % ', _control_cierre.ultimo_prestamo;


      _primero = _control_cierre.ultimo_prestamo;
      _ultimo = _primero + 1000;
      begin
        perform calcular_cartera_prestamo(_control_cierre.fecha_proceso,1, _primero, _ultimo);
      end;

          
      /*
      ----------------------------------------------------------------
      Actualizacion de la senal cerrado para la tabla control_cierre
      ----------------------------------------------------------------
      */
      
      select into
                  _control_cierre *
      from
                  control_cierre
      where
                  control_cierre.senal_enproceso 	= true and
                  control_cierre.senal_cerrado	= false and
                  control_cierre.senal_shell	= false;
                  
      raise notice 'Prestamo siguiente cierre___________________________ % ', _control_cierre.ultimo_prestamo;
      raise notice 'Fecha proceso control cierre___________________________ % ', _control_cierre.fecha_proceso;
                 
      if _control_cierre.ultimo_prestamo = 0 or
         _control_cierre.ultimo_prestamo is null then

        update control_cierre set
              senal_cerrado = true,
              fecha_ejecucion = current_date
        where
              control_cierre.id = _control_cierre.id;


        /*
        --------------------------------------------------------
        Actualización de fecha del cierre en la tabla programa
        --------------------------------------------------------
        */

        update
                programa
        set
                fecha_cierre = _control_cierre.fecha_proceso;
        
         /*
        -----------------------------------------------------------------
        Generacion de nuevo registro en la tabla control_cierre para la
        proxima ejecucion del cierre de cartera
        -----------------------------------------------------------------
        */
               
        _fecha_proceso_next = _control_cierre.fecha_proceso + 1;

        insert into control_cierre
              (
                fecha_proceso,
                ultimo_prestamo
              )
            values
              (
                _fecha_proceso_next,
                0
              );
      end if;
      
    end if;				--> if _control_cierre.fecha_proceso is not null then

  raise notice 'Finalizo el proceso de Cierre de Cartera_________________________';
  return true;

end;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION ejecutar_cierre_batch() OWNER TO cartera;
