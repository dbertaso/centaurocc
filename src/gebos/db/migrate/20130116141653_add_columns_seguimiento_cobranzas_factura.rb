# encoding: utf-8

class AddColumnsSeguimientoCobranzasFactura < ActiveRecord::Migration

  def up

    execute " ALTER TABLE prestamo ADD COLUMN porcentaje_veces_mora numeric(5,2);
                ALTER TABLE prestamo ADD COLUMN porcentaje_dias_mora numeric(5,2);
                ALTER TABLE prestamo ADD COLUMN indice_morosidad numeric(5,2);
                ALTER TABLE prestamo ADD COLUMN porcentaje_recuperacion_real_capital numeric(5,2);
                ALTER TABLE prestamo ADD COLUMN porcentaje_recuperacion_esperada_capital numeric(5,2);
                ALTER TABLE prestamo ADD COLUMN capital_cuotas_fecha numeric(16,2);
                ALTER TABLE prestamo ADD COLUMN desviacion_recuperacion_capital numeric(5,2);
                ALTER TABLE prestamo ADD COLUMN dias_atraso_promedio integer;
                ALTER TABLE prestamo ADD COLUMN porcentaje_recuperacion_real_intereses numeric(5,2);
                ALTER TABLE prestamo ADD COLUMN total_interes numeric(16,2);
                ALTER TABLE prestamo ADD COLUMN porcentaje_recuperacion_esperado_intereses numeric(5,2);
                ALTER TABLE prestamo ADD COLUMN interes_cuota_fecha numeric(16,2);
                ALTER TABLE prestamo ADD COLUMN desviacion_recuperacion_intereses numeric(5,2);
                ALTER TABLE prestamo ADD COLUMN porcentaje_pagos_incumplidos numeric(5,2);
                ALTER TABLE prestamo ADD COLUMN cantidad_intentos integer;

                COMMENT ON COLUMN prestamo.cantidad_intentos IS 'Cuenta las llamadas hechas al cliente independientemente se hayan contactado o no';

                COMMENT ON COLUMN prestamo.porcentaje_pagos_incumplidos IS 'Mide en términos porcentuales  la cantidad de cuotas impagas en relación a las cuotas totales del préstamo y su formula es: {% pagos incumplidos = cantidad cuotas impagas => [cantidad_cuotas_vencidas] / cantidad total de cuotas =. [plazo / frecuencia_pago]}';

                COMMENT ON COLUMN prestamo.desviacion_recuperacion_intereses IS 'Nos indica en términos porcentuales cuanto rédito ha dejado de percibir el banco a la fecha por incumplmiento en los pagos y su formula es: {% Desviación recuperación interés = %recuperación interés esperado => [porcentaje_recupeacion_esperado_intereses] - % recuperación real intereses => [porcentaje_real_recuperacion_intereses]}';

                COMMENT ON COLUMN prestamo.porcentaje_recuperacion_esperado_intereses IS 'Mide en términos porcentuales cuanto del rédito del banco se debería haber recuperado a la fecha y su formula es: {% recuperacion esperada del interés = Suma del interés de las cuotas a la fecha => [interes_cuotas_fecha] / Total interés del préstamo => [total_interes]}';

                COMMENT ON COLUMN prestamo.total_interes IS 'Total de intereses del préstamo y se debe calcular al momento de generar la tabla de amortización o cuando la misma se actualice, se deben tomar en cuenta los intereses de gracia/';

                COMMENT ON COLUMN prestamo.porcentaje_recuperacion_real_intereses IS 'Este indicador nos muestra en términos porcentuales cuanto del rédito del banco se ha recuperado a la fecha para un préstamp específico y su formula es: {% recuperación real de intereses ordinarios = (Intereses pagados => [interes_pagado] / Total intereses del préstamo = [total_interes])}';

                COMMENT ON COLUMN prestamo.dias_atraso_promedio IS 'Muestra al analista la cobranza lo días de atraso (promedio) en que el cliente cumple con el pago y su formula es: {Dias de atraso promedio = (Suma de dias atraso en pagos / cantidad de pagos)}';

                COMMENT ON COLUMN prestamo.porcentaje_dias_mora IS 'Esta variable nos da una medida de los dias que ha pasado en mora un préstamo particular en relación a los días totales que tiene la obligación y su formula es: {% de dia en mora = (días máximos continuos que ha permanecido en mora => [cantidad_dias_mora_acumulados] / total días del prestamo => [plazo_amortizacion * 30])}';

                COMMENT ON COLUMN prestamo.porcentaje_veces_mora IS 'Mide la relación entre las veces que el cliente incumple un pago en relación a la cantidad de pagos totales que tiene la obligación y su formula es: {% veces que ha caido en mora = (Veces que ha caido en mora => [numero_veces_mora] / Cantidad de cuotas de amortización que tiene el préstamo => [plazo / frecuencia_pago])}';

                COMMENT ON COLUMN prestamo.indice_morosidad IS 'Mide el porcentaje del capital vencido en relación al monto liquidado al cliente y su formula es: {IM = (Capital Vencido => [capital_vencido] / Monto Liquidado => [monto_liquidado])}';

                COMMENT ON COLUMN prestamo.porcentaje_recuperacion_real_capital IS 'Este indicador nos muestra en terminos porcentuales cuanto del patrimonio del banco se ha recuperado a la fecha para un préstamo especifíco y formula es: {%recuperacion real del capital = (Capital Pagado => [capital_pagado] / Monto Liquidado => [monto_liquidado])}';

                COMMENT ON COLUMN prestamo.porcentaje_recuperacion_esperada_capital IS 'Mide en términos porcentuales cuanto del patromonio del banco se debería haber recuperado a la fecha y su formula es: {%recuperacion esperada del capital = (Suma del capital de las cuotas a la fecha [capital_cuotas_fecha] / Monto Liquidado [monto_liquidado])}';

                COMMENT ON COLUMN prestamo.capital_cuotas_fecha IS 'Capital de las cuotas a la fecha y su formula es: {Capital cuotas a la fecha = (Sumatoria del capital de la cuota [amortizado] a la fecha de proceso)}';

                COMMENT ON COLUMN prestamo.interes_cuota_fecha IS 'Interés de las cuotas a la fecha y su formula es: {Interés cuotas a la fecha = (Sumatoria del interés de la cuota [interes_corriente] a la fecha de proceso)}';

                COMMENT ON COLUMN prestamo.desviacion_recuperacion_capital IS 'Nos indica en términos porcentuales cuanto patrimonio ha dejado de recuperar el banco a la fecha por incumplimiento en los pagos y su formula es: {%desviacion_recuperacion_capital = %recuperación del capital esperado => [porcentaje_recuperacion_esperada_capital] - %recuperacion_real_capital => [porcentaje_recuperacion_real_capital]}';
                "
  end

  def self.down

    execute "ALTER TABLE prestamo DROP COLUMN moneda_id;
              ALTER TABLE prestamo DROP COLUMN cantidad_veces_mora;
              ALTER TABLE prestamo DROP COLUMN cantidad_veces_vigente;
              ALTER TABLE prestamo DROP COLUMN cantidad_dias_mora_acumulados;
              ALTER TABLE prestamo DROP COLUMN cantidad_compromisos_incumplidos;
              ALTER TABLE prestamo DROP COLUMN empresa_cobranza_id;
              ALTER TABLE prestamo DROP COLUMN tasa_conversion;
              ALTER TABLE prestamo DROP COLUMN fecha_tasa_conversion;
              ALTER TABLE prestamo DROP COLUMN valor_moneda_nacional;"
  end
end
