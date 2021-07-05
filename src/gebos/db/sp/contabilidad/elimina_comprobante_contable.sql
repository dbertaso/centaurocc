-- Function: registro_contable(character varying, integer, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, integer, integer, integer, date, date, integer, integer, integer)

-- DROP FUNCTION registro_contable(character varying, integer, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, integer, integer, integer, date, date, integer, integer, integer);

CREATE OR REPLACE FUNCTION elimina_comprobante_contable(p_codigo_transaccion character varying,
                                                        p_fecha date)
  RETURNS boolean AS
$BODY$

 declare

   _prestamo prestamo%rowtype;
   _comprobante_contable_id integer;
   _cuenta_contable_id integer;
   _cuenta_contable cuenta_contable%rowtype;
   _cuenta_contable_presupuesto_id integer = null;
   _cuenta_contable_presupuesto cuenta_contable_presupuesto%rowtype;
   _transaccion_contable transaccion_contable%rowtype;
   _total_debe float;
   _total_haber float;
   _factura_id integer = null;
   _transaccion_id integer;
   _cur_regla_contable refcursor;
   _regla_contable regla_contable%rowtype;
   _referencia character varying;
   _codigo_contable character varying;
   _monto_contabilizacion double precision;

 begin


    raise notice 'Fecha proceso =======> %', p_fecha;
    raise notice 'Transaccion =========> %', p_codigo_transaccion;
    delete
    from
            asiento_contable
    where
            comprobante_contable_id in (select
                                                id
                                        from
                                                comprobante_contable
                                        where
                                                comprobante_contable.fecha_comprobante = p_fecha and
                                                comprobante_contable.codigo_transaccion = upper(p_codigo_transaccion));


    delete
    from
            comprobante_contable
    where
            comprobante_contable.fecha_comprobante = p_fecha and
            comprobante_contable.codigo_transaccion = upper(p_codigo_transaccion);


   return true;

 end;

 $BODY$
 LANGUAGE 'plpgsql' VOLATILE;