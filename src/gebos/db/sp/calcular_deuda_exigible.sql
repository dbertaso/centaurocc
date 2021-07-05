-- Function: actualizar_deuda_exigible(p_prestamo_id int4, p_proyeccion bool)

-- DROP FUNCTION actualizar_deuda_exigible(p_prestamo_id int4, p_proyeccion bool);

CREATE OR REPLACE FUNCTION actualizar_deuda_exigible(p_prestamo_id int4, p_proyeccion bool)
  RETURNS bool AS
$BODY$





    -- ......................................................................................................


    -- Se incluyÃ³ en el calculo de la deuda las columnas interes_diferido_por_vencer y capital_pago_parcial


    -- Se eliminÃ³ la columna interes_diferido_vencido porque en la deuda se debe incluir el


    -- interes diferido por vencer


    -- ......................................................................................................





declare





  _prestamo prestamo%rowtype;





begin





	select into 


		_prestamo * 


	from 


		prestamo 


	where 


		id = p_prestamo_id;





	-- Verifica que el monto de mora no es null si la proyecciÃ³n es false





	if p_proyeccion = false then	





		if _prestamo.monto_mora is null then





			update prestamo set monto_mora = 0 where id = p_prestamo_id; 





		end if;








		update prestamo 





			set 	deuda = 	((saldo_insoluto +
						interes_vencido + 
						interes_desembolso_vencido + 
						interes_diferido_por_vencer + 
						interes_diferido_vencido +
						monto_mora + 
						causado_no_devengado)-
						(remanente_por_aplicar +
						 capital_pago_parcial)), 

				exigible = 


						((monto_cuotas_vencidas + 
						  monto_mora)-
						  remanente_por_aplicar)





				where 


						id = p_prestamo_id;


			else





				update prestamo 





					set 


						proyeccion_deuda = 	((proyeccion_saldo_insoluto +


									proyeccion_interes_vencido + 


									proyeccion_interes_desembolso_vencido + 


									proyeccion_interes_diferido_vencido + 


									proyeccion_monto_mora + 


									proyeccion_causado_no_devengado)-


									proyeccion_remanente_por_aplicar),





						proyeccion_exigible = 





									((proyeccion_monto_cuotas_vencidas + 


									  proyeccion_monto_mora)-


									  proyeccion_remanente_por_aplicar)





					where 


						id = p_prestamo_id;  








	end if;





  return false;

















 

















end;

















$BODY$
  LANGUAGE 'plpgsql' VOLATILE;
ALTER FUNCTION actualizar_deuda_exigible(p_prestamo_id int4, p_proyeccion bool) OWNER TO cartera;
