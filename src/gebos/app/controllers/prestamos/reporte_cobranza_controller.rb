# encoding: utf-8

class Prestamos::ReporteCobranzaController < FormTabsController
 
  skip_before_filter :set_charset, :only=>[:reporte]

  layout 'form_basic'
  
  def index
    @ruta = "#{request.protocol}#{request.host}:#{request.port}"
    @moneda_list = Moneda.find(:all, :conditions=> "activo = true", :order => "nombre")
  end 

  def reporte
    logger.info"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"<<params.inspect
    @fecha_desde = params[:fecha_desde]
    @fecha_hasta = params[:fecha_hasta]
    @mostrar = 0
    if params[:moneda_id][0].blank?
      parametro = ParametroGeneral.find(:first)
      @moneda = Moneda.find(parametro.moneda_id.to_s)
    else
      @moneda = Moneda.find(params[:moneda_id][0])
    end
    
    if (@fecha_desde.blank? || @fecha_hasta.blank?)
      @mostrar = 1
      fill
    elsif (@fecha_desde.to_datetime > @fecha_hasta.to_datetime)
      @mostrar = 5
      fill
    elsif (@fecha_desde[/#{I18n.t('Sistema.Body.ExpresionesRegulares.validar_fecha')}/].nil? || @fecha_hasta[/#{I18n.t('Sistema.Body.ExpresionesRegulares.validar_fecha')}/].nil?)
      @mostrar = 2
      fill
    elsif @mostrar == 0
      des = @fecha_desde[6, 4] << '-' << @fecha_desde[3,2] << '-' << @fecha_desde[0, 2]
      has = @fecha_hasta[6, 4] << '-' << @fecha_hasta[3,2] << '-' << @fecha_hasta[0, 2]
      #@control_cobranza = ControlCobranza.find(:first, :conditions=> "fecha_cierre = '#{fec}'")
      
      @cobranza_arrime = ViewCobranzaAplicadaGeneral.find(:all, :conditions=> "fecha_contable >= '#{des}' and fecha_contable <= '#{has}' and modalidad = 'A' and moneda_id = #{@moneda.id}", :order=>"fecha_valor")
      @cobranza_comiciliacion = ViewCobranzaAplicadaGeneral.find(:all, :conditions=> "fecha_contable >= '#{des}' and fecha_contable <= '#{has}' and modalidad = 'D' and moneda_id = #{@moneda.id}", :order=>"fecha_valor")
      @cobranza_cuenta_recaudadora = ViewCobranzaAplicadaGeneral.find(:all, :conditions=> "fecha_contable >= '#{des}' and fecha_contable <= '#{has}' and modalidad = 'R' and moneda_id = #{@moneda.id}", :order=>"fecha_valor")
      
      logger.info"XXXXXXXXXXXXXXXXXXXXXXXX-@cobranza_arrime-XXXXXXXXXXXXXXXXXXXXXXXXXX"<<@cobranza_arrime.inspect
      
      if (@cobranza_arrime.length > 0 || @cobranza_comiciliacion.length > 0 || @cobranza_cuenta_recaudadora.length > 0)
        @mostrar = 3
      else
        @mostrar = 4
      end
      
    end

    render  :layout => 'form_reporte'
  end 
  
  def fill
    @cobranza_arrime = []
    @cobranza_comiciliacion = [] 
    @cobranza_cuenta_recaudadora = []

    
  end
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.CobranzaAplicada.FormTitlesCobranza.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.CobranzaAplicada.FormTitlesCobranza.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.CobranzaAplicada.FormTitlesCobranza.form_title_records')
    @width_layout = '1200'
  end
    
end
