
# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Prestamos::SimuladorController
# descripción: Migración a Rails 3
#

#require "calculadora"

class Prestamos::SimuladorController < FormClassicController

  layout 'form'

  skip_before_filter :set_charset, :only=>[:calcular]

  def index
    @calculadora = Calculadora.new
    fill
  end

  def calcular

    @calculadora = Calculadora.new(params[:calculadora])
    @params_calculadora = params[:calculadora]

    if @calculadora.valid?
      @calculadora.calcular
      render :update do |page|
        page.hide 'error'
        page.hide 'condiciones'
        page.replace_html 'list', render(:partial=>'list')
      end
    else
      render :update do |page|
        page.replace_html 'error', render(:partial=>'error')
        page.show 'error'
      end
    end

  end

  def imprimir

    fecha = params[:fecha_f].split('/')
    fecha = Time.gm(fecha[2].to_i, fecha[1].to_i, fecha[0].to_i, 0, 0, 0)

    logger.info "\nParametros ======> " << params.to_s
    @calculadora = Calculadora.new(
    :gracia_periodo=>params[:gracia_periodo],
    :periodo_gracia=>params[:gracia_periodo],
    :metodo=>params[:metodo],
    :periodo_muerto=>params[:periodo_muerto],
    :monto_f=>params[:monto_f],
    :fecha_f=>fecha,
    :gracia_plazo=>params[:gracia_plazo],
    :muerto_plazo=>params[:muerto_plazo],
    :tasa_f=>params[:tasa_f],
    :gracia_tasa_f=>params[:gracia_tasa_f],
    :periodo=>params[:periodo],
    :_365=>params[:_365],
    :plazo=>params[:plazo],
    :diferir_intereses=>params[:diferir_intereses])
    @calculadora.calcular
  end

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.Simulador.FormTitles.form_title')
  end

  private
  def fill
    @formula_select = Formula.find(:all, :order=>'nombre')
  end

  def helper_encabezado_cuota
    html = '<tr style="display: none" id="encabezado">'
    html += '<th style="width: 1%"></th>'
    html += '<th style="width: 5%">' + I18n.t('Sistema.Body.Vistas.Simulador.Etiquetas.numero') + '</th>'
    html += '<th style="width: 10%">'+ I18n.t('Sistema.Body.Vistas.Simulador.Etiquetas.fecha_pago') + '</th>'
    html += '<th style="width: 10%">' + I18n.t('Sistema.Body.Vistas.Simulador.Etiquetas.monto_cuota') + '</th>'
    html += '<th style="width: 10%">' + I18n.t('Sistema.Body.Vistas.Simulador.Etiquetas.intereses') + '</th>'
    html += '<th style="width: 10%">' + I18n.t('Sistema.Body.Vistas.Simulador.Etiquetas.intereses_acumulados') + '</th>'
    html += '<th style="width: 10%">' + I18n.t('Sistema.Body.Vistas.Simulador.Etiquetas.capital') + '</th>'
    html += '<th style="width: 10%">' + I18n.t('Sistema.Body.Vistas.Simulador.Etiquetas.capital_acumulado') + '</th>'
    html += '<th style="width: 10%">' + I18n.t('Sistema.Body.Vistas.Simulador.Etiquetas.saldo_insoluto') + '</th>'
    html += '<th style="width: 10%">' + I18n.t('Sistema.Body.Vistas.Simulador.Etiquetas.porcentaje_tasa_periodo') + '</th></tr>'
    html.html_safe
  end

end

