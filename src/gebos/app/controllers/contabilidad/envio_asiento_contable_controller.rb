# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Contabilidad::EnvioAsientoContableController
# descripción: Migración a Rails 3

require 'rubygems'
require 'csv'

class Contabilidad::EnvioAsientoContableController < FormClassicController
 
  skip_before_filter :set_charset, :only=>[:enviados]

  def index
    hoy = Time.now.strftime("%d/%m/%Y")
    #@mes = Time.now.month
    #@ano = Time.now.year
  end 

  def enviados

    if params[:confirmacion] != 'true'
      logger.info "\nParametros ====> " << params.inspect
      @fecha_inicio = params[:fecha_desde]
      @fecha_fin = params[:fecha_hasta]

      if @fecha_inicio.blank?
        render :update do |page|
          page.alert I18n.t('Sistema.Body.Controladores.EnvioAsientoContable.Errores.fecha_desde_requerida')
        end
        return
      end

      if @fecha_fin.blank?
        render :update do |page|
          page.alert I18n.t('Sistema.Body.Controladores.EnvioAsientoContable.Errores.fecha_hasta_requerida')
        end
        return
      end
    
      if !fecha?(@fecha_inicio)
        render :update do |page|
          page.alert I18n.t('Sistema.Body.Controladores.EnvioAsientoContable.Errores.fecha_desde_no_valida')
        end
        return    
      end
    
      if !fecha?(@fecha_fin)
        render :update do |page|
          page.alert I18n.t('Sistema.Body.Controladores.EnvioAsientoContable.Errores.fecha_hasta_no_valida')
        end
        return    
      end
    
      if conversionfecha(@fecha_fin) < conversionfecha(@fecha_inicio)
    
        logger.info "Paso por validacion de fechas"
        render :update do |page|
          page.alert I18n.t('Sistema.Body.Controladores.EnvioAsientoContable.Errores.fecha_hasta_mayor_desde')
        end

        return
      end

      fecha = params[:fecha_desde].split("/")
      fecha_inicio = fecha[2] + "-" + fecha[1] + "-"  + fecha[0]
      fecha_inicio_rep = fecha[0] + "-" + fecha[1] + "-" + fecha[2]
      fecha = ''
      fecha = params[:fecha_hasta].split("/")
      fecha_fin = fecha[2] + "-" + fecha[1] + "-" + fecha[0]
      fecha_fin_rep = fecha[0] + "-" + fecha[1] + "-" + fecha[2]


      control_envio = ControlEnvioContabilidad.where(["fecha_inicio = ? and fecha_fin <= ?",fecha_inicio,fecha_fin])

      if control_envio.length > 0

        mensaje = I18n.t 'Sistema.Body.Vistas.EnvioAsientoContable.Etiquetas.ya_fueron_enviados_comprobantes', :fecha_inicio=> fecha_inicio_rep, :fecha_fin=> fecha_fin_rep
        mensaje += " " + I18n.t('Sistema.Body.Vistas.EnvioAsientoContable.Etiquetas.desea_generarlo')
        logger.info "Mensaje ========> #{mensaje}"
        render :update do |page|
          logger.info "Entro en confirmar archivo"
          page.<< "confirmar_envio('#{mensaje}','#{fecha_inicio}','#{fecha_fin}');"
        end
      else
        @comprobantes_contables = ViewEnvioComprobanteContable.where(["fecha_comprobante >= ? and fecha_comprobante <= ?",fecha_inicio,fecha_fin]).order("fecha_comprobante")
        unless @comprobantes_contables.nil?
          result = ComprobanteContable.envio_comprobante(@comprobantes_contables, fecha_inicio, fecha_fin, session[:id])

          unless result == ''
            render :update do |page|
              page.alert result
            end
            return
          end

        end

        @comprobantes_enviados = ControlEnvioContabilidad.where("id > 0").order("fecha_inicio")

        render :update do |page|
          page.redirect_to :action=>'consulta_envio'
        end
        return

      end
    else

      fecha = params[:fecha_desde].split("/")
      fecha_inicio = fecha[2] + "/" + fecha[1] + "/"  + fecha[0]
      fecha_inicio_rep = fecha[0] + "_" + fecha[1] + "_" + fecha[2]
      fecha_inicio_rep1 = fecha[0] + "/" + fecha[1] + "/" + fecha[2]
      fecha = ''
      fecha = params[:fecha_hasta].split("/")
      fecha_fin = fecha[2] + "/" + fecha[1] + "/" + fecha[0]
      fecha_fin_rep = fecha[0] + "_" + fecha[1] + "_" + fecha[2]
      fecha_fin_rep1 = fecha[0] + "/" + fecha[1] + "/" + fecha[2]    
      @comprobantes_contables = ViewEnvioComprobanteContable.where(["fecha_comprobante >= ? and fecha_comprobante <= ?",fecha_inicio,fecha_fin]).order("fecha_comprobante")

      unless @comprobantes_contables.nil?
        result = ComprobanteContable.envio_comprobante(@comprobantes_contables, fecha_inicio, fecha_fin, session[:id])

        unless result == ''
          render :update do |page|
            page.alert result
          end
          return
        end

      end

      @comprobantes_enviados = ControlEnvioContabilidad.where("id > 0").order("fecha_inicio")

      render :update do |page|
        page.redirect_to :action=>'consulta_envio'
      end
      return
    end         #========> Fin if params[:confirmacion] != 'true'

  end     
  
  def consulta_envio

    @comprobantes_enviados = ControlEnvioContabilidad.where("id > 0").order("fecha_inicio desc")

  end

  def consulta_rechazos
    @comprobantes_rechazo = RechazoEnvioComprobante.where("id > 0").order("fecha_comprobante")
  end

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.Contabilidad.EnvioAsientoContable.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.Contabilidad.EnvioAsientoContable.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.Contabilidad.EnvioAsientoContable.FormTitles.form_title_records')
    @width_layout = '1100'
   
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
