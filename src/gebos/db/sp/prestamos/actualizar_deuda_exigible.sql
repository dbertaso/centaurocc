create or replace function actualizar_deuda_exigible(
  p_prestamo_id integer,
  p_proyeccion bool) returns bool as $$
declare

    -- ......................................................................................................
    -- Se incluyo en el calculo de la deuda las columnas interes_diferido_por_vencer y capital_pago_parcial
    -- Se elimino la columna interes_diferido_vencido porque en la deuda se debe incluir el
    -- interes diferido por vencer
    -- ......................................................................................................

begin

  if p_proyeccion = false then
    update
            prestamo
    set
          deuda =
                  ((saldo_insoluto +
                    interes_vencido +
                    interes_desembolso_vencido +
                    interes_diferido_por_vencer +
                    interes_diferido_vencido +
                    monto_mora +
                    causado_no_devengado)-
                    ( remanente_por_aplicar +
                      capital_pago_parcial)),
          exigible =
                    ((monto_cuotas_vencidas +
                      interes_diferido_vencido +
                      monto_mora)-
                      remanente_por_aplicar)

    where
          id = p_prestamo_id and
          saldo_insoluto > 0;
  else

    update
            prestamo
    set
            proyeccion_deuda =
                             ((proyeccion_saldo_insoluto +
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
$$ language 'plpgsql' volatile;

