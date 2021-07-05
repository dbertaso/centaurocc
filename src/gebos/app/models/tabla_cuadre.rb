# encoding: utf-8

#
# autor: Diego Bertaso
# clase: TablaCuadre
# descripción: Migración a Rails 3
#

class TablaCuadre < ActiveRecord::Base

self.table_name = 'tabla_cuadre'

attr_accessible :id,
                :mes,
                :ano,
                :saldo,
                :desembolso,
                :cobranza,
                :diferencia,
                :ajuste,
                :banco_origen


# def valid?

#   resultado = PrestamoHistorico.all(:conditions => "mes = #{@@mes} AND ano = #{@@ano} AND banco_origen = '#{@@fondo_origen}'")

#   if (resultado[0].nil?)
#     self.errors.add(:tabla_cuadre, I18n.t('Sistema.Body.Modelos.TablaCuadre.Errores.no_existe_foto_mes_cierre'))
#     return false
#   else
#     return true
#   end

# end


def ejecutar_cierre(str_mes_ano, fondo_origen)

  foto_historico(str_mes_ano)

  #tabla_cuadre = TablaCuadre.new
  logger.info "str_mes_ano ======> #{str_mes_ano}"
  mes_ano = str_mes_ano[0].to_s.split("/")
  @@mes = mes_ano[0]
  @@ano = mes_ano[1]
  @@fondo_origen = fondo_origen
  #Actualizar o Crear registro en tabla_cuadre

  TablaCuadre.delete_all("mes = #{mes_ano[0]} AND ano = #{mes_ano[1]} AND banco_origen = '#{@@fondo_origen}'")
  saldo = PrestamoHistorico.sum("saldo_insoluto - capital_pago_parcial", :conditions => "mes = #{mes_ano[0]} and ano = #{mes_ano[1]} AND banco_origen = '#{@@fondo_origen}'")
  desembolso = ViewResumenDesembolsosCierre.sum("monto", :conditions => "EXTRACT(MONTH from fecha) = #{mes_ano[0]} and EXTRACT(YEAR from fecha) = #{mes_ano[1]} AND banco_origen = '#{@@fondo_origen}'")
  cobranza = ViewResumenPagosCierre.sum("capital + abono_capital", :conditions => "EXTRACT(MONTH from fecha_contable) = #{mes_ano[0]} and EXTRACT(YEAR from fecha_contable) = #{mes_ano[1]} AND banco_origen = '#{@@fondo_origen}'")

  cierres = TablaCuadre.find(:all, :conditions => "banco_origen = '#{@@fondo_origen}'", :order => 'ano, mes DESC')


  if (!cierres[0].nil?)
      @@mes == "1"? mes_anterior = "12" : mes_anterior = @@mes.to_i - 1
      @@mes == "1"? ano_anterior = @@ano.to_i - 1 : ano_anterior = @@ano
      anterior = TablaCuadre.find(:all, :conditions => "banco_origen = '#{fondo_origen}' and mes = #{mes_anterior} and ano=#{ano_anterior}")
      logger.info "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$" << anterior[0].saldo.to_f.to_s << " $$$$$$$$$$$$$$$$$$$$$$$ " << saldo.to_s
      diferencia = saldo.to_f - (anterior[0].saldo.to_f - cobranza.to_f + desembolso.to_f)

  else
   diferencia = 0
  end

  begin
    #self = TablaCuadre.new
    logger.info "Self class =========> #{self.class.to_s}"
    logger.info "Self inspect =======> #{self.inspect}"
    # self.mes = mes_ano[0].to_i, 
    # self.ano = mes_ano[1].to_i, 
    # self.saldo = saldo, 
    # self.desembolso = desembolso, 
    # self.cobranza = cobranza, 
    # self.diferencia = diferencia, 
    # self.banco_origen = @@fondo_origen, 
    # self.ajuste = 0;
    # estatus = self.save

    estatus = self.update_attributes(:mes => @@mes, :ano => @@ano, :saldo => saldo, :desembolso => desembolso, :cobranza => cobranza, :diferencia => diferencia, :banco_origen => @@fondo_origen, :ajuste => 0)
    return estatus

  rescue Exception => e
    logger.error "Tabla Cuadre ========> #{self.inspect}"
    logger.error e.message
    logger.error e.backtrace.join("\n")
  end


end


def get_select_mes_ano(fondo_origen)
  cierres = TablaCuadre.all(:conditions => "banco_origen = '#{fondo_origen}'", :order => 'ano, mes DESC')

  logger.info "Cierres =======> #{cierres.inspect}"
  if (!cierres[0].nil?)
    ultimo_mes = cierres[0].mes.to_s
    ultimo_ano = cierres[0].ano.to_s
    ultimo_mes == "12" ? proximo_mes = "1" : proximo_mes = ultimo_mes.to_i + 1
    ultimo_mes == "12" ? proximo_ano = ultimo_ano.to_i + 1 : proximo_ano = ultimo_ano
    arr_final = [cas_mes(proximo_mes.to_s) + "/" + proximo_ano.to_s + " (Proximo mes a cerrar)", proximo_mes.to_s + "/" + proximo_ano.to_s], [ultimo_mes.to_s + "/" + ultimo_ano.to_s + " (Volver a cerrar)", ultimo_mes.to_s + "/" + ultimo_ano.to_s]
  else
    #Ejecuto el While para buscar el mes anterior restandole dia a dia a la referencia a la fecha actual,  hasta conseguir que los meses de las dos fechas cambien

    control_cierre = ControlCierre.last(:conditions=>"senal_cerrado = true")
    logger.info "Control Cierre =====> #{control_cierre.inspect}"
    unless control_cierre.nil?
      fecha_actual = control_cierre.fecha_proceso
    else
      fecha_actual = Time.now
    end
    logger.info "fecha_actual  =======> #{fecha_actual.to_s}"
    #fecha_actual = Time.now
    fecha_anterior = fecha_actual

    ultimo_dia_mes = fecha_actual.end_of_month.strftime("%Y%m%d")
    fecha_invertida = fecha_actual.strftime("%Y%m%d")
    # while fecha_actual.month == fecha_anterior.month do
    #   fecha_anterior = fecha_anterior
    #   logger.info "fecha anterior - while =======> #{fecha_anterior.to_s}"
    # end

    if ultimo_dia_mes == fecha_invertida
      logger.info "fecha_actual ======> #{fecha_anterior.to_s}"
      arr_final = [[cas_mes(fecha_anterior.month.to_s) + "/" + fecha_anterior.year.to_s + " (Primer cierre del sistema)", fecha_anterior.month.to_s + "/" + fecha_anterior.year.to_s]]
    else
      arr_final = [["No es Fin de Mes"]]
    end

  end

  return arr_final

end

def foto_historico(str_mes_ano)

  logger.info "str_mes_ano (foto_historico) =======> #{str_mes_ano}"
  mes_ano = str_mes_ano[0].to_s.split("/")
  @mes = mes_ano[0]
  @ano = mes_ano[1]

  ajustar_riesgo_provision
  genera_historico(@ano, @mes)

end

def ajustar_riesgo_provision()

  params = nil
  transaction do
    valor = execute_sp('ajustarriesgoyprovision', params)
  end

end

def genera_historico(p_ano, p_mes)

    params = {
      :p_ano=>p_ano,
      :p_mes=>p_mes
    }

    transaction do
      valor = execute_sp('ejecutar_cierre_financiero', params.values_at(
        :p_ano,
        :p_mes))
    end
end

def resolver_mes(mes_numero)

  retorno = I18n.t('date.abbr_month_names')[mes_numero.to_i]
  return retorno
end


def cas_mes(mes)

  logger.info "Mes ===========> #{mes}"
  mes_casteado = I18n.t('date.abbr_month_names')[mes.to_i]

  return mes_casteado

end


end


# == Schema Information
#
# Table name: tabla_cuadre
#
#  id           :integer         not null, primary key
#  mes          :integer         default(0), not null
#  ano          :integer         default(0), not null
#  saldo        :decimal(16, 2)  default(0.0)
#  desembolso   :decimal(16, 2)  default(0.0)
#  cobranza     :decimal(16, 2)  default(0.0)
#  diferencia   :decimal(16, 2)  default(0.0)
#  ajuste       :decimal(16, 2)  default(0.0)
#  banco_origen :string(25)      default("INI")
#

