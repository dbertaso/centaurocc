INSERT
INTO
      mensajes_correo
          (id, nombre, descripcion, activo)
    values
          (1,'Primer Aviso','Estimado Cliente le informamos que su financiamiento presenta un atraso de 1 (una) cuota vencida.','t');
INSERT
INTO
      mensajes_correo
          (id, nombre, descripcion, activo)
    values            
          (2,'Segundo Aviso','Estimado Cliente le informamos que su financiamiento presenta un atraso de 2 (dos) cuotas vencidas.','t');
INSERT
INTO
      mensajes_correo
          (id, nombre, descripcion, activo)
    values            
          (3,'Tercer Aviso','Estimado Cliente le informamos que su financiamiento presenta un atraso de 3 (tres) cuotas vencidas, lo invitamos a pasar por nuestro de departamento de Cobranzas','t');

SELECT pg_catalog.setval('mensajes_correo_id_seq', 3, false);

INSERT
INTO
      mensajes_sms
          (id, nombre, descripcion, activo)
    values
          (1,'Primer Aviso','Estimado Cliente le informamos que su financiamiento presenta un atraso de 1 (una) cuota vencida.','t');
INSERT
INTO
      mensajes_sms
          (id, nombre, descripcion, activo)
    values            
          (2,'Segundo Aviso','Estimado Cliente le informamos que su financiamiento presenta un atraso de 2 (dos) cuotas vencidas.','t');
INSERT
INTO
      mensajes_sms
          (id, nombre, descripcion, activo)
    values            
          (3,'Tercer Aviso','Estimado Cliente le informamos que su financiamiento presenta un atraso de 3 (tres) cuotas vencidas, lo invitamos a pasar por nuestro de departamento de Cobranzas','t');

SELECT pg_catalog.setval('mensajes_sms_id_seq', 3, false);

INSERT
INTO
      llamada_infructuosa
          (id, descripcion, activo)
    values
          (1,'Atendida','t');
INSERT
INTO
      llamada_infructuosa
          (id, descripcion, activo)
    values
          (2,'No Contesta','t');
INSERT
INTO
      llamada_infructuosa
          (id, descripcion, activo)
    values
          (3,'Ocupado','t');
INSERT
INTO
      llamada_infructuosa
          (id, descripcion, activo)
    values
          (4,'Número Equivocado','t');

SELECT pg_catalog.setval('llamada_infructuosa_id_seq', 4, false);

INSERT
INTO
      motivos_atraso
          (id, descripcion, activo)
    values
          (2,'Sin Disponibilidad','t');

INSERT
INTO
      motivos_atraso
          (id, descripcion, activo)
    values
          (3,'Sin Trabajo','t');

INSERT
INTO
      motivos_atraso
          (id, descripcion, activo)
    values
          (4,'Enfermedad','t');

INSERT
INTO
      motivos_atraso
          (id, descripcion, activo)
    values
          (1,'Viaje','t');

SELECT pg_catalog.setval('motivos_atraso_id_seq', 4, false);

INSERT
INTO
      persona_atendio
          (id, descripcion, activo)
    values
          (1,'Cliente','t');

INSERT
INTO
      persona_atendio
          (id, descripcion, activo)
    values
          (2,'Familiar','t');

INSERT
INTO
      persona_atendio
          (id, descripcion, activo)
    values
          (3,'Conocido','t');
INSERT
INTO
      persona_atendio
          (id, descripcion, activo)
    values
          (4,'Desconocido','t');

SELECT pg_catalog.setval('persona_atendio_id_seq', 4, false);

INSERT
INTO
      tipo_gestion_cobranza
          (id, descripcion, activo)
    values
          (1,'Correo Electrónico','t');
INSERT
INTO
      tipo_gestion_cobranza
          (id, descripcion, activo)
    values          
          (2,'Mensaje de Texto','t');
INSERT
INTO
      tipo_gestion_cobranza
          (id, descripcion, activo)
    values                    
          (3,'Telecobranza','t');

SELECT pg_catalog.setval('tipo_gestion_cobranza_id_seq', 3, false);
