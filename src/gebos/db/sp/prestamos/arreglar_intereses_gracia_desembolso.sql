-- Function: arreglar_interes_gracia_desembolso(bigint)

-- DROP FUNCTION arreglar_interes_gracia_desembolso(bigint);

CREATE OR REPLACE FUNCTION arreglar_interes_gracia_desembolso()
  RETURNS boolean AS
$BODY$

  declare

    _rechazos rechazos%rowtype;
    _solicitud solicitud%rowtype;
    _prestamo prestamo%rowtype;
    _prestamo_tasa_historico prestamo_tasa_historico%rowtype;
    _programa programa%rowtype;
    _plan_pago plan_pago%rowtype;
    _plan_pago_cuota plan_pago_cuota%rowtype;
    _desembolso desembolso%rowtype;
    _comprobante_contable comprobante_contable%rowtype;
    _factura factura%rowtype;
    _desembolso_pago desembolso_pago%rowtype;
    _fecha_proceso_next date;
    _estatus_prestamo varchar(1);
    _fecha_tope date;
    _dias_interes int;
    _interes_gracia decimal(16,2);
    _total_interes_gracia decimal(16,2);

    -- Cursor para recorrer los programas sociales y efectuar el cierre diario de cartera
    _cur_plan_pago_cuota refcursor;
    _cur_desembolso refcursor;
    _cur_desembolso_pago refcursor;
    _cur_prestamo refcursor;

  begin

    _total_interes_gracia := 0;

	/*
	--------------------------------
	Abriendo cursor de prestamos
	--------------------------------
	*/

	open _cur_prestamo for

	select
	      *
	from
	      prestamo
	where
	      prestamo.ultimo_desembolso <> 0 and
	      prestamo.estatus = 'V' ;

	/*
	--------------------------------------------------
	Comienzo del recorrido del cursor de prestamos
	--------------------------------------------------
	*/

	loop

    fetch _cur_prestamo INTO _prestamo;
    exit when not found;

		raise notice 'Prestamo # - Fecha Base, %, %', _prestamo.numero, _prestamo.fecha_base;


	  /*
	  --------------------------------
	  Abriendo cursor de desembolsos
	  --------------------------------
	  */

	  open _cur_desembolso for

	  select
	        *
	  from
	        desembolso
	  where
	        desembolso.prestamo_id  = _prestamo.id
    order by
	        desembolso.fecha_realizacion;

	  /*
	  --------------------------------------------------
	  Comienzo del recorrido del cursor de desembolsos
	  --------------------------------------------------
	  */

	  loop

	    fetch _cur_desembolso INTO _desembolso;
	    exit when not found;

       raise notice 'Fecha Tope, %', _prestamo.fecha_base;

      _dias_interes = calcular_dias_360(_desembolso.fecha_realizacion, _prestamo.fecha_base);
      _interes_gracia := ((_desembolso.monto * _prestamo.tasa_vigente) / 36000) * _dias_interes;

      raise notice 'Dias Interes - Interes Gracia, %, %', _dias_interes, _interes_gracia;

      /*
	    -----------------------------------------------------------
	    Actualización de los intereses de gracia en el desembolso
	    -----------------------------------------------------------
	    */

      update
		        desembolso
	    set
		        interes_gracia = _interes_gracia,
            tasa = _prestamo.tasa_vigente
      where
		        id = _desembolso.id;


	  /*
	  -------------------------------------------------
	  Fin del recorrido del cursor de desembolsos
	  -------------------------------------------------
	  */

	  end loop;

	  /*
	  -------------------------------
	  Cerrando cursor de desembolso
	  -------------------------------
	  */

    close _cur_desembolso;

	 /*
	 -------------------------------------------------
	 Fin del recorrido del cursor de prestamos
	 -------------------------------------------------
	 */

	end loop;

  close _cur_prestamo;

  return true;

  end;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION arreglar_interes_gracia_desembolso() OWNER TO cartera;
GRANT EXECUTE ON FUNCTION arreglar_interes_gracia_desembolso() TO cartera;
GRANT EXECUTE ON FUNCTION arreglar_interes_gracia_desembolso() TO public;

