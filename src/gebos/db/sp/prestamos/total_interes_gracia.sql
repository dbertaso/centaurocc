CREATE OR REPLACE FUNCTION total_interes_gracia(p_prestamo_id bigint) RETURNS SETOF decimal(16,2) AS $$
BEGIN


	RETURN QUERY SELECT
		sum(interes_gracia)
	from
		desembolso
	where
		desembolso.prestamo_id = p_prestamo_id
	group by
	        desembolso.prestamo_id;
END;
$$ LANGUAGE plpgsql;

