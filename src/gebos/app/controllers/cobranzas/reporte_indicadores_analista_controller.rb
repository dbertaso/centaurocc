# encoding: utf-8

#
# autor: Luis Rojas
# clase: Cobranzas::ReporteIndicadoresAnalistaController
# descripción: Creado en Rails 3

class Cobranzas::ReporteIndicadoresAnalistaController < FormTabsController
 
  skip_before_filter :set_charset, :only=>[:reporte]

  def index
    @ruta = "#{request.protocol}#{request.host}:#{request.port}"
    logger.info "Ruta ====>>>>> #{@ruta}"
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
      @indicadores_analista = PerformanceAnalistaCobranza.count(:conditions=> "fecha >= '#{@fdesde}' and fecha <= '#{@fhasta}'")
      if @indicadores_analista == 0
        @mostrar = 3
      else
        @analistas = AnalistaCobranzas.find_by_sql("select a.id, u.primer_nombre, u.primer_apellido from usuario u inner join analista_cobranzas a on u.id = a.usuario_id order by u.primer_nombre, u.primer_apellido")
        unless @analistas.length > 0
          @mostrar = 3
        else
          @totales = PerformanceAnalistaCobranza.find_by_sql("select sum(cantidad_intentos) as tcantidad_intentos, sum(cantidad_contactos) as tcantidad_contactos, sum(cantidad_contactos_exitosos) as tcantidad_contactos_exitosos, sum(cantidad_promesas_pago) as tcantidad_promesas_pago,sum(porcentaje_contactos) as tporcentaje_contactos, sum(porcentaje_contactos_exitosos) as tporcentaje_contactos_exitosos, sum(porcentaje_promesas_pago) as tporcentaje_promesas_pago, sum(cantidad_email_enviados) as tcantidad_email_enviados, sum(cantidad_sms_enviados) as tcantidad_sms_enviados from performance_analista_cobranza where fecha >= '#{@fdesde}' and fecha <= '#{@fhasta}'")
        end
      end
    end
    
    render  :layout => 'form_reporte'
  end 
  
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Vistas.General.indicadores_gestion_analista')
    @form_title_record = I18n.t('Sistema.Body.Vistas.General.indicadores_gestion_analista')
    @form_title_records = I18n.t('Sistema.Body.Vistas.General.indicadores_gestion_analista')
    @width_layout = '1200'
  end

 end