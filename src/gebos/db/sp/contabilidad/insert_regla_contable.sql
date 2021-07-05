CREATE OR REPLACE FUNCTION insert_regla_contable(p_codigo_transaccion character varying,
                                                 p_fuente_recursos_id integer,
                                                 p_sector_economico_id integer,
                                                 p_estatus char(1),
                                                 p_secuencia integer,
                                                 p_tipo char(1),
                                                 p_codigo_contable character varying(20),
                                                 p_auxiliar_contable character varying(7),
                                                 p_fin_codigo character varying(4),
                                                 p_tipo_monto character varying(2),
                                                 p_modalidad_pago character varying(2),
                                                 p_entidad_financiera_id integer,
                                                 p_reestructurado character varying(1)) RETURNS VOID AS $$
declare

begin

  insert
  into
         regla_contable
                       ( codigo_transaccion,
                         fuente_recursos_id,
                         sector_economico_id,
                         estatus,
                         secuencia,
                         tipo_movimiento,
                         codigo_contable,
                         auxiliar_contable,
                         fin_codigo,
                         tipo_monto,
                         modalidad_pago,
                         entidad_financiera_id,
                         reestructurado)

              values

                       ( p_codigo_transaccion,
                         p_fuente_recursos_id,
                         p_sector_economico_id,
                         p_estatus,
                         p_secuencia,
                         p_tipo,
                         p_codigo_contable,
                         p_auxiliar_contable,
                         p_fin_codigo,
                         p_tipo_monto,
                         p_modalidad_pago,
                         p_entidad_financiera_id,
                         p_reestructurado);

end;


$$
language plpgsql;

