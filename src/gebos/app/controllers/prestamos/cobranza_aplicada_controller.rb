  # encoding: utf-8

class Prestamos::CobranzaAplicadaController < FormTabsController
 
  skip_before_filter :set_charset, :only=>[:reporte]

  layout 'form_basic'
  
  def index
    @ruta = "#{request.protocol}#{request.host}:#{request.port}"
  end 

  def reporte
    @fecha_desde = params[:fecha_desde]
    @fecha_hasta = params[:fecha_hasta]
    @mostrar = 0
    if (@fecha_desde.blank? || @fecha_hasta.blank?)
      @mostrar = 1
    elsif (@fecha_desde.to_datetime > @fecha_hasta.to_datetime)
      @mostrar = 5
    elsif (@fecha_desde[/#{I18n.t('Sistema.Body.ExpresionesRegulares.validar_fecha')}/].nil? || @fecha_hasta[/#{I18n.t('Sistema.Body.ExpresionesRegulares.validar_fecha')}/].nil?)
      @mostrar = 2
    elsif @mostrar == 0
      des = @fecha_desde[6, 4] << '-' << @fecha_desde[3,2] << '-' << @fecha_desde[0, 2]
      has = @fecha_hasta[6, 4] << '-' << @fecha_hasta[3,2] << '-' << @fecha_hasta[0, 2]
      
      #"fecha_cierre >= '2010-09-29' and fecha_cierre <= '2014-03-25' and entidad_financiera_id is not null"
      @control = ControlCobranza.find(:all, :conditions=>"fecha_cierre >= '#{des}' and fecha_cierre <= '#{has}' and entidad_financiera_id is not null")
      
      #@control_cobranza = ControlCobranza.find(:first, :conditions=> "fecha_cierre = '#{fec}'")
      #@cobranza_aplicada = ViewCobranzaAplicadaEfectiva.find(:all, :conditions=> "fecha_contable >= '#{des}' and fecha_contable <= '#{has}'", :order=>"fecha_valor")
      if @control.length > 0 
        @mostrar = 3
      else
        @mostrar = 4
      end
    end

    render  :layout => 'form_reporte'
  end 
  
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.CobranzaAplicada.FormTitles.form_title_record')
    @form_title_record = I18n.t('Sistema.Body.Controladores.CobranzaAplicada.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.CobranzaAplicada.FormTitles.form_title_records')
    @width_layout = '1200'
  end
    
end
