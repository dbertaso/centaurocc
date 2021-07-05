# encoding: utf-8

class Prestamos::RechazoDomiciliacionController < FormTabsController
 
  skip_before_filter :set_charset, :only=>[:reporte]

  layout 'form_basic'
  
  def index
    @ruta = "#{request.protocol}#{request.host}:#{request.port}"
  end 

  def reporte
    @fecha_rechazo = params[:fecha_rechazo]
    @mostrar = 0
    if @fecha_rechazo.blank?
      @mostrar = 1
    elsif @fecha_rechazo[/#{I18n.t('Sistema.Body.ExpresionesRegulares.validar_fecha')}/].nil?
      @mostrar = 2
    elsif @mostrar == 0
      fec = @fecha_rechazo[6, 4] << '-' << @fecha_rechazo[3,2] << '-' << @fecha_rechazo[0, 2]
      @rechazo_cobranza = ViewRechazoCobranzaAplicada.find(:all, :conditions=> "fecha_rechazo = '#{fec}'")
      if @rechazo_cobranza.length > 0 
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
    @form_title = I18n.t('Sistema.Body.Controladores.CobranzaAplicada.FormTitlesRechazo.form_title_record')
    @form_title_record = I18n.t('Sistema.Body.Controladores.CobranzaAplicada.FormTitlesRechazo.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.CobranzaAplicada.FormTitlesRechazo.form_title_records')
    @width_layout = '1200'
  end
    
end
