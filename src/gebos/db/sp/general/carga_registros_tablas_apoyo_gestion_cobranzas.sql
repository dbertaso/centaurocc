COPY mensajes_correo  ( id,nombre,descripcion, activo) 
    FROM { '/home/dbertaso/sandboxes/gebos_migracion_rails/src/gebos/db/mensajes_correo.txt'}
    with
        DELMITER ','
        CSV;