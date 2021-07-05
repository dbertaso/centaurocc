
CREATE OR REPLACE FUNCTION actualizar_estatus_solicitud()
  RETURNS boolean AS
$BODY$
declare
  _estatus estatus%rowtype;
  _cur_plan_pago_cuota refcursor;
  _ultimo_estatus integer = 0;
  _id_estatus integer = 0;
  _nombres_tx character varying = ' ';

  _estatus_id integer[] := '{10001,
                          10002,
                          10003,
                          10004,
                          10005,
                          10010,
                          10024,
                          10031,
                          10033,
                          10034,
                          10035,
                          10040,
                          10045,
                          10048,
                          10050,
                          10055,
                          10057,
                          10060,
                          10070,
                          10080,
                          10085,
                          10090,
                          10095,
                          10100,
                          10110,
                          10120,
                          10150,
                          10160,
                          10180,
                          20000,
                          20010,
                          20020,
                          20030,
                          20040,
                          20050,
                          30000,
                          30050,
                          30060,
                          30100,
                          30110,
                          30150
                          }';

  _nombres text[] := '{"Registrando el trámite",
                       "En espera por asignación técnico de campo",
                        "Elaborando informe de recomendación",
                        "No viable técnicamente",
                        "En espera por apertura de ciclo",
                        "En espera de disponibilidad presupuestaria",
                        "Rechazado",
                        "Diferido - Esperando Instancia",
                        "Por aprobar Comité Estadal",
                        "Por aprobar Comité Nacional",
                        "Rechazado por Comité Nacional",
                        "En documentación",
                        "Elaborando informe de visita",
                        "Por asignar fideicomiso",
                        "Liquidación por Transferencia",
                        "Liquidación en Cheque",
                        "Enviado al Banco",
                        "Elaboración de Cheque",
                        "Liquidado",
                        "Rechazado Liquidación",
                        "Envio al Banco – Apertura Cuenta",
                        "En Cobranza - Solo Insumos",
                        "Liquidación de Maquinaria",
                        "Liquidado Parcial",
                        "Liquidado Total",
                        "Renuncia",
                        "Anulado",
                        "Condonado",
                        "Trámite Reestructurado",
                        "Por generar orden de despacho",
                        "Orden de despacho generada",
                        "Orden de despacho emitida",
                        "Orden de despacho cerrada manualmente",
                        "Orden de despacho cerrada automáticamente",
                        "Orden de despacho parcialmente entregada",
                        "Enviado a Finanzas",
                        "Enviado al Banco",
                        "Elaboración de Cheque",
                        "Abonado en Cuenta",
                        "Cheque Registrado",
                        "Rechazado Abono"
                        }';

begin

  /*
  ----------------------------------
  Proceso actualización de estatus
  ----------------------------------
  */

  for i in 1..41 loop

    raise notice 'Indice %', i;
    raise notice 'Estatus del arreglo %', _estatus_id[i];
    raise notice 'Nombre del arreglo %', _nombres[i];


    _id_estatus = _estatus_id[i];
    _nombres_tx = _nombres[i];

    select
    into
          _estatus *
    from
          estatus
    where
          id = _estatus_id[i];

    if found then

      update
              estatus
      set
              nombre = _nombres_tx
      where
              id = _estatus.id;

    else

      if _nombres_tx is not null then
        insert
        into estatus
                           (id,
                            nombre,
                            descripcion)
                   values
                           (_id_estatus,
                            _nombres_tx,
                            _nombres_tx);
      end if;

    end if;

    _ultimo_estatus = _estatus_id[i]::integer;

  end loop;

  perform setval('estatus_id_seq', _ultimo_estatus,true);

  delete
  from
        estatus
  where
        id not in (10001,
                    10002,
                    10003,
                    10004,
                    10005,
                    10010,
                    10024,
                    10031,
                    10033,
                    10034,
                    10035,
                    10040,
                    10045,
                    10048,
                    10050,
                    10055,
                    10057,
                    10060,
                    10070,
                    10080,
                    10085,
                    10090,
                    10095,
                    10100,
                    10110,
                    10120,
                    10150,
                    10160,
                    10180,
                    20000,
                    20010,
                    20020,
                    20030,
                    20040,
                    20050,
                    30000,
                    30050,
                    30060,
                    30100,
                    30110,
                    30150);

  return true;
end;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION actualizar_estatus_solicitud() OWNER TO cartera;
