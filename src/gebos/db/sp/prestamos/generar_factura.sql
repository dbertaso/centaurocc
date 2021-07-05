CREATE OR REPLACE FUNCTION generar_factura(p_numero integer, p_monto_factura numeric(14,2), p_fecha date,
                 p_fecha_realizacion date, p_pago_cliente_id integer, p_tipo_factura char, p_proceso_nocturno boolean,
                 p_prestamo_id integer, p_remanente_por_aplicar numeric(14,2), p_tipo_cartera_id integer,
                 p_codigo_contable varchar(10), p_sector_economico varchar(50), p_estado_prestamo varchar(20),
                 p_observaciones_analista varchar, p_distincion_cobranza varchar(3), p_analista varchar(50),
                 p_consultoria_juridica boolean, p_abono_capital numeric(14,2)) RETURNS boolean AS
$body$
declare

   _plan_pago plan_pago%rowtype;
   _prestamo prestamo%rowtype;
   _plan_pago_cuota plan_pago_cuota%rowtype;
   _plan_pago_cuota_ultima plan_pago_cuota%rowtype;

   _remanente_por_aplicar decimal(14,2);
   _abono_capital decimal(14,2);
   _fecha_inicio date;
   _estado_prestamo varchar(20);


begin

  /*
  --------------------------------------------------------------
  Si el remanente por aplicar es mayor que cero se procede
  a la verificación de abono a capital/cancelación de préstamo
  y si aplica la generación de una nueva tabla de amortización
  --------------------------------------------------------------
  */


        _estado_prestamo = (SELECT resolver_estatus(p_estado_prestamo));
        --_estado_prestamo = p_estado_prestamo;
        raise notice 'Estatus del prestamo despues de leer %', _prestamo.estatus;

       insert into factura (numero, monto, fecha, fecha_realizacion, pago_cliente_id, tipo,
                             proceso_nocturno, prestamo_id, remanente_por_aplicar,
                             tipo_cartera_id, codigo_contable, sector_economico, estado,
                             comentario_analista, distincion_cobranza, analista,
                             consultoria_juridica, abono_capital)
        values (p_numero, p_monto_factura, p_fecha,
                 p_fecha_realizacion, p_pago_cliente_id, p_tipo_factura, p_proceso_nocturno,
                 p_prestamo_id, p_remanente_por_aplicar, p_tipo_cartera_id,
                 p_codigo_contable, p_sector_economico, _estado_prestamo,
                 p_observaciones_analista, p_distincion_cobranza, p_analista,
                 p_consultoria_juridica, p_abono_capital) ;


  return true;

end;
$body$
LANGUAGE 'plpgsql' VOLATILE;
ALTER FUNCTION generar_factura( integer, numeric(14,2), date, date, integer, char, boolean, integer, numeric(14,2), integer,
                 varchar(10), varchar(50), varchar(20), varchar, varchar(3),  varchar(50),
                 boolean, numeric(14,2)) OWNER TO cartera;
