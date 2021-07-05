# encoding: utf-8
#
# autor: Diego Bertaso
# clase: Prestamos::ControlCobranzaController
# descripción: Inclusión y Migración a Rails 3
#

require 'rubygems'
#require 'jcode'
#$KCODE = 'u'
require "fileutils"

class Prestamos::ControlCobranzaController < FormTabsController

  skip_before_filter :set_charset, :only=>[:entidad_financiera_change]

  def index
  	#@feedback=""
    @entidad_financiera_list = EntidadFinanciera.all(:conditions=>'activo=true', :order=>'nombre')
    @cuenta_bcv_fondas=[]
    list
  end

  def list

    params['sort'] = "fecha desc" unless params['sort']
    fecha = Time.now.strftime("%Y/%m/%d")
    conditions = "fecha <= '#{fecha}'"
    
    @list = ControlCobranza.search(conditions, params[:page], params['sort'])    
    @total = @list.count

    form_list

  end

  def confirmar

    @mensaje = ""
    if params[:fecha] == ""
      @mensaje += "<li> #{I18n.t('Sistema.Body.Controladores.ControlCobranzas.Mensajes.fecha_invalida')} </li>"
      #render :template => "prestamos/control_cobranza/index"
    end

    unless params[:fecha] == ""

      fecha_array = params[:fecha].split("/")
      fecha = Date.new(fecha_array[2].to_i,fecha_array[1].to_i,fecha_array[0].to_i)
      fecha = fecha.strftime("%Y%m%d")
      if fecha > Time.now.strftime("%Y%m%d")
        @mensaje += "<li> #{I18n.t('Sistema.Body.Controladores.ControlCobranzas.Mensajes.fecha_no_puede_ser_mayor')}"
      end
    end


    if params[:entidad_financiera][:entidad_financiera_id].nil? or params[:entidad_financiera][:entidad_financiera_id] == ""

      @mensaje += "<li>#{I18n.t('Sistema.Body.Controladores.EnvioCobranzas.Errores.debe_seleccionar_entidad')}</li>"

    end

    if  params[:cuenta_bcv_fondas_sel][0] == ""
      @mensaje += "<li>#{I18n.t('Sistema.Body.Controladores.EnvioCobranzas.Errores.debe_seleccionar_cuenta')}</li>"
    end

    if !params[:upload].nil?
      @archivo = params[:upload]
      #logger.info "Archivo ======> #{FileUtils.pwd}/#{archivo['datafile'].original_filename}"
      if @archivo['datafile'].original_filename.length == 0
        @mensaje += "<li> #{I18n.t('Sistema.Body.Controladores.ControlCobranzas.Mensajes.debe_seleccionar_archivo')} </li>"
      end

      # Se verifica que el archivo exista en el Control de Envio de Cobranzas
      if @archivo['datafile'].original_filename.length  > 0

        cuenta_matriz = params[:cuenta_bcv_fondas_sel][0]
        tipo_cuenta = cuenta_matriz[0,1]
        cuenta_matriz = cuenta_matriz[2, (cuenta_matriz.size - 2)]
        if params[:fecha] == ""
          fecha_valor = '1900-01-01'
          fecha = ""
        else
          fecha_valor = params[:fecha].to_datetime.strftime("%Y-%m-%d")
          fecha = params[:fecha].to_datetime.strftime("%d-%m-%Y")
        end
        nombre_archivo = @archivo['datafile'].original_filename
        nombre_archivo = nombre_archivo[0, (nombre_archivo.size - 4)]
        entidad_financiera_id = params[:entidad_financiera][:entidad_financiera_id]
        entidad = EntidadFinanciera.find(entidad_financiera_id)

        unless entidad.nil?
          entidad_nombre = entidad.nombre
        else
          entidad_nombre = 'N/A'
        end

        logger.info "Nombre Archivo =========> '#{nombre_archivo}'"
        logger.info "Fecha Valor ============> #{fecha_valor}"
        logger.info "Entidad financiera =====> #{entidad_financiera_id.to_s}"
        logger.info "cuenta_matriz  =========> '#{cuenta_matriz}'"
        control_envio_cobranza = ControlEnvioCobranza.first(:conditions=>['fecha =  ? and numero_cuenta =  ? and entidad_financiera_id =  ? and archivo = ? and estatus_proceso = 2', fecha_valor,cuenta_matriz,entidad_financiera_id,nombre_archivo] )

        logger.info "Control Envio Cobranza =========> #{control_envio_cobranza.inspect}"
        if control_envio_cobranza.nil?
          nombre_archivo = "<b>#{nombre_archivo}</b>"
          @mensaje += "<li>#{I18n.t('Sistema.Body.Controladores.ControlCobranzas.Errores.archivo_invalido', archivo: nombre_archivo, entidad_financiera: entidad_nombre, fecha_valor: fecha)}</li>"
        end
      end

    else
      @mensaje += "<li>#{I18n.t('Sistema.Body.Controladores.ControlCobranzas.Mensajes.debe_seleccionar_archivo')}</li>"
    end

    if @mensaje != ""
      render 'prestamos/control_cobranza/mensaje'
      return
    end
    
    if entidad_financiera_id.to_i == 465 or entidad_financiera_id == 13
      #nombre = nombre[0,10]
      fecha = fecha.to_s
      archivo1 = "ControlCobranza.ejecutar_cobranzas_banfoandes(\"#{params[:upload]}\",\"#{fecha_valor}\",\"#{session[:id].to_s}\",\"#{cuenta_matriz}\",\"#{entidad_financiera_id.to_s}\",\"#{tipo_cuenta}\")"
      logger.info "Archivo 1 ======> " << archivo1.to_s
      resultado = ControlCobranza.ejecutar_cobranzas_banfoandes(params[:upload],fecha_valor,session[:id],cuenta_matriz, entidad_financiera_id, tipo_cuenta)
      #{}`rails r '#{archivo1}'`
    end

    if entidad_financiera_id.to_i == 5
      #nombre = nombre[0,6]
      fecha = fecha.to_s
      #logger.info "Nombre archivo ===> " << nombre[0,6].downcase
      #archivo1 = "ControlCobranza.ejecutar_cobranzas_caroni(\"#{archivo}\",\"#{data}\",\"#{fecha_valor}\",\"#{session[:id].to_s}\",\"#{cuenta_matriz}\",\"#{entidad_financiera_id.to_s}\",\"#{tipo_cuenta}\")"
      logger.info "Archivo 1 nooooooo ======> " << "ControlCobranza.ejecutar_cobranzas_caroni(\"#{nombre_archivo}\",\"#{fecha_valor}\",\"#{session[:id].to_s}\",\"#{cuenta_matriz}\",\"#{entidad_financiera_id.to_s}\",\"#{tipo_cuenta}\")"
      resultado = ControlCobranza.ejecutar_cobranzas_banfoandes(params[:upload],fecha_valor,session[:id],cuenta_matriz, entidad_financiera_id, tipo_cuenta)
      #`rails r '#{archivo1}'`
    end

    logger.info "Resultado <----------> #{resultado.inspect}"
    if resultado == "0"
      @entidad_financiera_list = EntidadFinanciera.all(:conditions=>'activo=true', :order=>'nombre')
      @cuenta_bcv_fondas=[]
    else
      @mensaje = resultado
      render '/prestamos/control_cobranza/mensaje'
      return
    end


  end

  
  def aplicar

    logger.info "PARAMETROS ==============> #{params.inspect}"
    archivo = params[:archivo]
    data = params[:data]
    fecha = params[:fecha].gsub('/','-')

    logger.info "Nombre ====> " << archivo.inspect
    logger.info "DATA ====> " << data.inspect
    logger.info "Fecha =====> " << fecha
    logger.info " parametros aplicar ====> " << params.inspect
   
    #logger.info "ControlCobranza.ejecutar_cobranzas_banfoandes(#{archivo[:datafile].original_filename})"
    cuenta_matriz = params[:cuenta_bcv_fondas_sel][0]
    tipo_cuenta = cuenta_matriz[0,1]
    cuenta_matriz = cuenta_matriz[2, (cuenta_matriz.size - 2)]
    fecha_valor = params[:fecha].to_datetime.strftime("%Y-%m-%d")
    nombre_archivo = archivo
    nombre_archivo = nombre_archivo[0, (nombre_archivo.size - 4)]
    entidad_financiera_id = params[:entidad_financiera][:entidad_financiera_id]
    entidad = EntidadFinanciera.find(entidad_financiera_id)

    logger.info "Entidad Financiera =======>  #{entidad_financiera_id}"
    control = ControlCobranza.first(:conditions=>['fecha =  ? and numero_cuenta =  ? and entidad_financiera_id =  ? and archivo = ? and procesamiento = 2', fecha_valor,cuenta_matriz,entidad_financiera_id,nombre_archivo] )
    #control = ControlCobranza.find_by_sql("select * from control_cobranza where archivo = \'#{nombre}\' and procesamiento = 2")

    logger.info "Control ===============> " << control.inspect

    if !control.nil? 
      @mensaje = "#{I18n.t('Sistema.Body.Controladores.ControlCobranzas.Mensajes.el_archivo')} #{nombre_archivo} #{I18n.t('Sistema.Body.Controladores.ControlCobranzas.Mensajes.ya_fue_procesado')}"

       render :template => "prestamos/control_cobranza/mensaje"

      return
    end
    logger.info "Control ====> " << control.inspect

#    if control.size > 0
#      @controlerror = ControlCobranza.new
#      @controlerror.errors.add_to_base("El archivo ya fue procesado")
#      render :update do |page|
#        page.form_error
#      end
#      return
#    end
    
    if entidad_financiera_id.to_i == 465 or entidad_financiera_id == 13
      #nombre = nombre[0,10]
      fecha = fecha.to_s
      archivo1 = "ControlCobranza.ejecutar_cobranzas_banfoandes(\"#{archivo}\",\"#{data[:datafile]}\",\"#{fecha_valor}\",\"#{session[:id].to_s}\",\"#{cuenta_matriz}\",\"#{entidad_financiera_id.to_s}\",\"#{tipo_cuenta}\")"
      logger.info "Archivo 1 ======> " << archivo1.to_s
      #`rails r '#{archivo1}'`
    end

    if entidad_financiera_id.to_i == 5
      #nombre = nombre[0,6]
      fecha = fecha.to_s
      logger.info "Nombre archivo ===> " << nombre[0,6].downcase
      archivo1 = "ControlCobranza.ejecutar_cobranzas_caroni(\"#{archivo}\",\"#{data}\",\"#{fecha_valor}\",\"#{session[:id].to_s}\",\"#{cuenta_matriz}\",\"#{entidad_financiera_id.to_s}\",\"#{tipo_cuenta}\")"
      logger.info "Archivo 1 nooooooo ======> " << "ControlCobranza.ejecutar_cobranzas_caroni(\"#{nombre_archivo}\",\"#{fecha_valor}\",\"#{session[:id].to_s}\",\"#{cuenta_matriz}\",\"#{entidad_financiera_id.to_s}\",\"#{tipo_cuenta}\")"
     #`rails r '#{archivo1}'`
    end
    
  end

  def entidad_financiera_change    
    unless params[:id].to_s ==''
      @cuenta_bcv_fondas = CuentaBcv.find(:all, :conditions=>"activo=true and entidad_financiera_id = #{params[:id]} and tipo <> 'F'", :order=> "numero")
    else
      @cuenta_bcv_fondas =[]
    end
    render :update do |page|
      page.replace_html 'cuenta_bcv-select', :partial => 'cuenta_bcv_select'
    end
  end

  def preparar_error(object)

    @mensaje = ""
    object.errors.each do |error|
      @mensaje = "<li> #{error.full_message} </li>"
    end

  end
  
  protected

  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.ControlCobranzas.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.ControlCobranzas.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.ControlCobranzas.FormTitles.form_title_records')
    @form_entity = 'control_cobranza'
    @form_identity_field = 'id'
    @width_layout = '1500'
  end


end
