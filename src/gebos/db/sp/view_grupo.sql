-- View: view_grupo

-- DROP VIEW view_grupo;

CREATE OR REPLACE VIEW view_grupo AS 
 SELECT gi.id, 
	g.id AS grupo_id, 
	g.numero, 
	p.cedula, 
	p.id AS persona_id, 
	t.total, case when p.primer_nombre isnull then 'S/I' ELSE p.primer_nombre end || ' ' || case when p.segundo_nombre isnull then 'S/I' else p.segundo_nombre end || ' ' || case when p.primer_apellido isnull then 'S/I' else p.primer_apellido end || ' ' || case when p.segundo_apellido isnull then 'S/I' else p.segundo_apellido end AS nombre, 
	gi.lider
   FROM grupo g
   JOIN grupo_integrante gi ON gi.grupo_id = g.id
   JOIN persona p ON p.id = gi.persona_id
   JOIN total_grupo_integrante t ON t.grupo_id = g.id;

ALTER TABLE view_grupo OWNER TO gprotec;

