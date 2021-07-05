CREATE OR REPLACE FUNCTION get_datos_cliente(_cliente_id integer, info_request varchar)
  RETURNS varchar AS
$BODY$
/*
PROPOSITO: alcanzar facilmente atributos de cliente que pueden estar en las tablas EMPRESA o PERSONA.
PARAMETROS: info_request : [nombre, cedula_rif]
*/
declare
	_identificacion_cliente varchar;
	_resultado varchar = 'INI';
        _tipo_cliente int = 0;
begin 

/*
Se precisa el id del cliente, bien sea este empresa o persona
*/

_identificacion_cliente = (SELECT persona_id as ide from cliente where cliente.id  = _cliente_id);
raise notice '___%', _identificacion_cliente;

	if (_identificacion_cliente is null) then
		
		_identificacion_cliente = (SELECT empresa_id as ide from cliente where cliente.id  = _cliente_id);
                _tipo_cliente = 1;
	end if;

/*
Si el request del usuario es el nombre 
*/
if info_request = 'nombre' then 

	if (_tipo_cliente = 0 ) then
		_resultado = (SELECT (primer_nombre || ' ' ||   segundo_nombre || ' ' || primer_apellido || ' ' || segundo_apellido) from persona where id = _identificacion_cliente::integer);
	else
		_resultado = (SELECT nombre from empresa where id = _identificacion_cliente::integer); 
	end if;
end if;


/*
Si el request del usuario es el cedula_rif 
*/
if info_request = 'cedula_rif' then 

	if (_tipo_cliente = 0 ) then
		_resultado = (SELECT cedula from persona where id = _identificacion_cliente::integer)::varchar;
	else
		_resultado = (SELECT rif from empresa where id = _identificacion_cliente::integer)::varchar; 
	end if;
end if;

/*
Si el request del usuario es el sector_economico
*/
if info_request = 'sector_economico' then 

	if (_tipo_cliente = 0 ) then
		_resultado = (SELECT (SELECT descripcion FROM sector_economico WHERE sector_economico.id = persona.sector_economico_id) FROM persona where persona.id = _identificacion_cliente::integer)::varchar; 
	else
		_resultado = (SELECT (SELECT descripcion FROM sector_economico WHERE sector_economico.id = empresa.sector_economico_id) FROM empresa where empresa.id = _identificacion_cliente::integer)::varchar; 
	end if;
end if;

/*
Si el request del usuario es el estado
*/
if info_request = 'estado' then 

	if (_tipo_cliente = 0 ) then
		_resultado = (SELECT (SELECT (SELECT nombre from estado where estado.id =ciudad.estado_id) FROM ciudad where ciudad.id = persona_direccion.ciudad_id) FROM persona_direccion where persona_direccion.persona_id = _identificacion_cliente::integer)::varchar;
	else
		_resultado = (SELECT (SELECT (SELECT nombre from estado where estado.id =ciudad.estado_id) FROM ciudad where ciudad.id = empresa_direccion.ciudad_id) FROM empresa_direccion where empresa_direccion.empresa_id = _identificacion_cliente::integer)::varchar;
	end if;
end if;



/*
Si el request del usuario es el cedula
*/
if info_request = 'cedula' then 

	if (_tipo_cliente = 0 ) then
		_resultado = (SELECT cedula from persona where persona.id = _identificacion_cliente::integer);
	else
		_resultado = (SELECT cedula FROM persona WHERE persona.id IN (SELECT persona_id  from empresa_integrante where empresa_id = _identificacion_cliente::integer and cargo = 'Representante Legal')); 
	end if;
     
end if;

/*
Si el request del usuario es el cedula
*/
if info_request = 'rif' then 

	if (_tipo_cliente = 0 ) then
		_resultado = (SELECT rif_personal from persona where persona.id = _identificacion_cliente::integer);
	else
		_resultado = (SELECT rif from empresa where id = _identificacion_cliente::integer)::varchar; 
	end if;
     
end if;

if info_request = 'tipo_organizacion' then 

	if (_tipo_cliente = 0 ) then
		_resultado = 'NATURAL';
	else
                _resultado = (SELECT descripcion FROM tipo_empresa WHERE tipo_empresa.id IN (SELECT tipo_empresa_id FROM empresa WHERE empresa.id =  _identificacion_cliente::integer));
	end if;
     
end if;

if info_request = 'beneficiario_nombre' then 

	if (_tipo_cliente = 0 ) then
		_resultado = (SELECT (primer_nombre || ' ' ||   segundo_nombre || ' ' || primer_apellido || ' ' || segundo_apellido) from persona where id = _identificacion_cliente::integer);
	else
                _resultado = (SELECT (primer_nombre || ' ' ||   segundo_nombre || ' ' || primer_apellido || ' ' || segundo_apellido) FROM persona WHERE persona.id IN (SELECT persona_id  from empresa_integrante where empresa_id = _identificacion_cliente::integer and cargo = 'Representante Legal')); 
	end if;
     
end if;


if info_request = 'capital_suscrito' then 

	if (_tipo_cliente = 0 ) then
		_resultado = 'N/A';
	else
                _resultado = (SELECT capital_suscrito from empresa where id = _identificacion_cliente::integer)::varchar; 
	end if;
     
end if;



if info_request = 'municipio' then 

	if (_tipo_cliente = 0 ) then
		_resultado = (SELECT (SELECT nombre from municipio where municipio.id = persona_direccion.municipio_id)  FROM persona_direccion where persona_direccion.persona_id = _identificacion_cliente::integer)::varchar;
	else
		_resultado =  (SELECT (SELECT nombre from municipio where municipio.id = empresa_direccion.municipio_id) FROM empresa_direccion where empresa_direccion.empresa_id = _identificacion_cliente::integer)::varchar;
	end if;
     
end if;


if info_request = 'parroquia' then 

	if (_tipo_cliente = 0 ) then
		_resultado = (SELECT (SELECT nombre from parroquia where parroquia.id = persona_direccion.parroquia_id)  FROM persona_direccion where persona_direccion.persona_id = _identificacion_cliente::integer)::varchar;
	else
		_resultado =  (SELECT (SELECT nombre from parroquia where parroquia.id = empresa_direccion.parroquia_id) FROM empresa_direccion where empresa_direccion.empresa_id = _identificacion_cliente::integer)::varchar;
	end if;
     
end if;

if info_request = 'localidad' then 

	if (_tipo_cliente = 0 ) then
		_resultado = (SELECT localidad FROM persona_direccion where persona_direccion.persona_id = _identificacion_cliente::integer)::varchar;
	else
		_resultado =  'INI'::varchar;
	end if;
     
end if;

if info_request = 'avenida' then 

	if (_tipo_cliente = 0 ) then
		_resultado = (SELECT avenida FROM persona_direccion where persona_direccion.persona_id = _identificacion_cliente::integer)::varchar;
	else
		_resultado = (SELECT avenida FROM empresa_direccion where empresa_direccion.empresa_id = _identificacion_cliente::integer)::varchar;
	end if;
     
end if;

if info_request = 'edif_casa' then 

	if (_tipo_cliente = 0 ) then
		_resultado = (SELECT edificio FROM persona_direccion where persona_direccion.persona_id = _identificacion_cliente::integer)::varchar;
	else
		_resultado = (SELECT edificio FROM empresa_direccion where empresa_direccion.empresa_id = _identificacion_cliente::integer)::varchar;
	end if;
     
end if;

if info_request = 'telefonos' then 

	if (_tipo_cliente = 0 ) then
		_resultado = (SELECT codigo || '-' || numero  FROM persona_telefono where persona_telefono.persona_id = _identificacion_cliente::integer limit 1)::varchar;
	else
		_resultado = (SELECT codigo || '-' || numero  FROM empresa_telefono where empresa_telefono.empresa_id = _identificacion_cliente::integer limit 1)::varchar;
	end if;
     
end if;

if info_request = 'banco_recaudador' then 

	
		_resultado = (SELECT (SELECT nombre from entidad_financiera where entidad_financiera.id = cliente.entidad_financiera_id)  FROM cliente where cliente.id = _identificacion_cliente::integer)::varchar;
	
     
end if;

if info_request = 'numero_cuenta' then 

		_resultado = (SELECT numero_cuenta  FROM cliente where cliente.id = _identificacion_cliente::integer)::varchar;
end if;

/*
Si el request del usuario es el sector_economico
*/
if info_request = 'sector_economico_id' then 

	if (_tipo_cliente = 0 ) then
		_resultado = (SELECT (SELECT sector_economico.id FROM sector_economico WHERE sector_economico.id = persona.sector_economico_id) FROM persona where persona.id = _identificacion_cliente::integer)::varchar; 
	else
		_resultado = (SELECT (SELECT sector_economico.id FROM sector_economico WHERE sector_economico.id = empresa.sector_economico_id) FROM empresa where empresa.id = _identificacion_cliente::integer)::varchar; 
	end if;
end if;



/*
Si el request del usuario es el estado
*/
if info_request = 'estado_id' then 

	if (_tipo_cliente = 0 ) then
		_resultado = (SELECT (SELECT (SELECT id from estado where estado.id =ciudad.estado_id) FROM ciudad where ciudad.id = persona_direccion.ciudad_id) FROM persona_direccion where persona_direccion.persona_id = _identificacion_cliente::integer)::varchar;
	else
		_resultado = (SELECT (SELECT (SELECT id from estado where estado.id =ciudad.estado_id) FROM ciudad where ciudad.id = empresa_direccion.ciudad_id) FROM empresa_direccion where empresa_direccion.empresa_id = _identificacion_cliente::integer)::varchar;
	end if;
end if;

	return _resultado;

 
end;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE; 
ALTER FUNCTION get_datos_cliente(_cliente_id integer, info_request varchar) OWNER TO cartera;

