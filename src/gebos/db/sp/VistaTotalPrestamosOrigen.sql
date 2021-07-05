-- View: "totalprestamosorigenfondo"

--DROP VIEW totalprestamosorigen;

CREATE OR REPLACE VIEW totalprestamosprograma AS 
 SELECT count(prestamo.numero) AS cantidaprestamos, programa.id
   FROM solicitud solicitud
   JOIN prestamo prestamo ON (solicitud.id = prestamo.solicitud_id)
   JOIN programa programa ON (programa.id = solicitud.programa_id)

  WHERE prestamo.estatus = 'E'::bpchar
  GROUP BY 	programa.id,
		solicitud."origen_fondo_id";

ALTER TABLE totalprestamosprograma OWNER TO postgres;