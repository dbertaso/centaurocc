-- Function: ejecutar_pago(integer, character varying[], integer, character, double precision, integer, date, date, character varying, double precision, integer, boolean, boolean, boolean)

-- DROP FUNCTION ejecutar_pago(integer, character varying[], integer, character, double precision, integer, date, date, character varying, double precision, integer, boolean, boolean, boolean);

CREATE OR REPLACE FUNCTION ejecutar_pago(p_cliente_id integer, p_cheques character varying[], p_prestamo_id integer, p_modalidad character, p_monto double precision, p_oficina_id integer, p_fecha_realizacion date, p_fecha date, p_numero_voucher character varying, p_monto_efectivo double precision, p_entidad_financiera_id integer, p_proceso_nocturno boolean, p_hay_cheques boolean, p_exonerar_mora boolean, p_consultoria_juridica boolean, p_observaciones_analista varchar, p_analista_nombre_completo varchar(50))
  RETURNS integer AS
$BODY$





 declare





     _factura_id integer;





  





 begin





  _factura_id = ejecutar_pago(





 	  p_cliente_id,





 	  p_cheques,





 	  p_prestamo_id,





 	  p_modalidad,





 	  p_monto,





 	  p_oficina_id,





 	  p_fecha_realizacion,





 	  p_fecha,





 	  p_numero_voucher,





 	  p_monto_efectivo,





 	  p_entidad_financiera_id,





 	  p_proceso_nocturno, false, p_hay_cheques, p_exonerar_mora, p_consultoria_juridica, p_observaciones_analista, p_analista_nombre_completo);





   





   return _factura_id;





 





   





 end;





 $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION ejecutar_pago(integer, character varying[], integer, character, double precision, integer, date, date, character varying, double precision, integer, boolean, boolean, boolean,boolean,varchar,varchar(50)) OWNER TO cartera;

