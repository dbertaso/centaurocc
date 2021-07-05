# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Contabilidad::ReporteContabilidadController
# descripción: Migración a Rails 3

class Contabilidad::ReporteContabilidadController < FormTabsController
 
  skip_before_filter :set_charset, :only=>[:reporte]

  def index
    hoy = Time.now.strftime("%d/%m/%Y")
    #@mes = Time.now.month
    #@ano = Time.now.year
  end 

  def reporte
    @fecha_desde = params[:fecha_desde]
    @mostrar = 0
    if @fecha_desde.blank?
      @mostrar = 1
    elsif @fecha_desde[/#{I18n.t('Sistema.Body.ExpresionesRegulares.validar_fecha')}/].nil?
      @mostrar = 2
    end

    if @mostrar == 0
      @fecha_hasta = params[:fecha_hasta]
      if @fecha_hasta.blank?
        @mostrar = 4
      elsif @fecha_hasta[/#{I18n.t('Sistema.Body.ExpresionesRegulares.validar_fecha')}/].nil?
        @mostrar = 5
      elsif @fecha_desde.to_datetime > @fecha_hasta.to_datetime
        @mostrar = 6
      end
    end

    if @mostrar == 0
      @fdesde = @fecha_desde[6, 4] << '-' << @fecha_desde[3,2] << '-' << @fecha_desde[0, 2]
      @fhasta = @fecha_hasta[6, 4] << '-' << @fecha_hasta[3,2] << '-' << @fecha_hasta[0, 2]
      @comprabante_contrable = ComprobanteContable.find(:all, :conditions=> "fecha_comprobante >= '#{@fdesde}' and fecha_comprobante <= '#{@fhasta}'")
      if @comprabante_contrable.length == 0
        @mostrar = 3
      end
    end
    render  :layout => 'form_reporte'
  end 
  
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.Contabilidad.ReporteContabilidad.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.Contabilidad.ReporteContabilidad.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.Contabilidad.ReporteContabilidad.FormTitles.form_title_records')
    @width_layout = '1200'
  end
  
  def fecha?(valor, formato = "%d/%m/%Y")
  
    logger.info formato
    Date.strptime(valor, formato)
    rescue ArgumentError
    false
  end
  
  def conversionfecha(valor, formato = "%d/%m/%Y")
  
    Date.strptime(valor, formato)
    
  end

  
 end
