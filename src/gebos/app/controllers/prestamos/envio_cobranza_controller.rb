# encoding: utf-8
#
# autor: Diego Bertaso
# clase: Prestamos::EnvioCobranzaController
# descripción: Inclusión y Migración a Rails 3
#

require 'rubygems'
require 'csv'

class Prestamos::EnvioCobranzaController < FormTabsController

  skip_before_filter :set_charset, :only=>[:preparar_cobranzas, :list_view, :entidad_financiera_change]

  layout 'form_basic'

  def mensaje

  end

  def index
    @entidad_financiera_list = EntidadFinanciera.all(:conditions=>'activo=true and convenio_domiciliacion = true', :order=>'nombre')
    @cuenta_bcv_fondas=[]
  end
 
  def list
    params['sort'] = "fecha desc"

    condition = "estatus_proceso <= 1 "
    @list = ControlEnvioCobranza.search(condition, params[:page], params['sort'])    
    @total = @list.count

    form_list

  end

  def list_view

    params['sort'] = "fecha desc"

    condition = "estatus_proceso = 2 "
    @list = ControlEnvioCobranza.search(condition, params[:page], params['sort'])    
    @total = @list.count

    form_list_view

  end

  def preparar_cobranzas

    nombre = ''

    if params[:tipo_cobro] == "0"

      @mensaje1 = I18n.t('Sistema.Body.Controladores.EnvioCobranzas.Errores.debe_seleccionar_tipo_cobro')

      render :update do |page|
        page.replace_html 'error', @mensaje1.html_safe
        page.show 'error'
        page.hide 'mensaje'
        page.<< "window.scrollTo(0,0);"
        page.<< "this.disabled=false;"
        #page.form_error
      end
      return

    end

    if params[:fecha_valor_f].nil? or params[:fecha_valor_f] == ""

      @mensaje1 = I18n.t('Sistema.Body.Controladores.EnvioCobranzas.Errores.debe_seleccionar_fecha_valor')

      render :update do |page|
        page.replace_html 'error', @mensaje1.html_safe
        page.show 'error'
        page.hide 'mensaje'
        page.<< "window.scrollTo(0,0);"
        page.<< "this.disabled=false;"
        #page.form_error
      end
      return      

    end

    if params[:entidad_financiera][:entidad_financiera_id].nil? or params[:entidad_financiera][:entidad_financiera_id] == ""

      @mensaje1 = I18n.t('Sistema.Body.Controladores.EnvioCobranzas.Errores.debe_seleccionar_entidad')

      render :update do |page|
        page.replace_html 'error', @mensaje1.html_safe
        page.show 'error'
        page.hide 'mensaje'
        page.<< "window.scrollTo(0,0);"
        page.<< "this.disabled=false;"
        #page.form_error
      end
      return      

    end

    if params[:fecha_valor_f].to_datetime < Time.now.strftime("%d/%m/%Y").to_datetime

      @mensaje1 = I18n.t('Sistema.Body.Controladores.EnvioCobranzas.Errores.fecha_menor_fecha_sistema')

      render :update do |page|
        page.replace_html 'error', @mensaje1.html_safe
        page.show 'error'
        page.hide 'mensaje'
        page.<< "window.scrollTo(0,0);"
        page.<< "this.disabled=false;"
        #page.form_error
      end
      return  

    end

    if  params[:cuenta_bcv_fondas_sel][0] == ""


      @mensaje1 = I18n.t('Sistema.Body.Controladores.EnvioCobranzas.Errores.debe_seleccionar_cuenta')

      render :update do |page|
        page.replace_html 'error', @mensaje1.html_safe
        page.show 'error'
        page.hide 'mensaje'
        page.<< "window.scrollTo(0,0);"
        page.<< "this.disabled=false;"
        #page.form_error
      end
      return  

    end

    entidad = EntidadFinanciera.find(params[:entidad_financiera][:entidad_financiera_id].to_i)

    if entidad.nil?
      nombre = "#{entidad.alias}COBRANZAS#{params[:fecha_valor_f].to_datetime.strftime("%d%m%Y")}"
    end

    # case params[:entidad_financiera][:entidad_financiera_id].to_i

    #   when 5
    #     nombre ='bivcobranzas' + Time.now.strftime("%d%m%Y")
    #   when 13
    #     nombre ='caronicobranzas' + Time.now.strftime("%d%m%Y")
    #   when 465
    #     nombre ='bicentenariocobranzas' + Time.now.strftime("%d%m%Y")

    # end


    logger.info 'Archivo      ====> ' << nombre.to_s

    cuenta_matriz = params[:cuenta_bcv_fondas_sel][0]
    tipo_cuenta = cuenta_matriz[0,1]
    cuenta_matriz = cuenta_matriz[2, ]
    fecha_valor = params[:fecha_valor_f]
    entidad_financiera = params[:entidad_financiera]
    entidad_financiera_id = params[:entidad_financiera][:entidad_financiera_id]
    tipo_cobro = params[:tipo_cobro]

    control = ControlEnvioCobranza.first(:conditions=>['archivo = ? and fecha = ? and numero_cuenta = ? and entidad_financiera_id = ? and estatus_proceso = 2',nombre,fecha_valor.to_datetime.strftime("%Y-%m-%d"),cuenta_matriz,entidad_financiera_id.to_i])

    logger.info "Control ===============> " << control.to_s

    if !control.nil?

      logger.info "Entro en el if control.size > 0"
      @mensaje1 = "#{I18n.t('Sistema.Body.Modelos.ControlEnvioCobranzas.Errores.el_archivo')} #{nombre} #{I18n.t('Sistema.Body.Modelos.ControlEnvioCobranzas.Errores.ya_fue_generado')}"
      render :update do |page|
        page.replace_html 'error', @mensaje1.html_safe
        page.show 'error'
        page.hide 'mensaje'
        page.<< "window.scrollTo(0,0);"
        page.<< "this.disabled=false;"
        #page.form_error
      end
      return  
    end


    logger.info 'Entidad Financiera ====> ' << entidad_financiera_id.to_s
    logger.info 'Tipo de Cobro      ====> ' << tipo_cobro.to_s
    logger.info "Parametros ===> " << params.inspect
    logger.info "Entidad Financiera =====> #{params[:entidad_financiera][:entidad_financiera_id]}"
    logger.info "Cuenta Seleccionada =====> #{params[:cuenta_bcv_fondas_sel][0]}"
    logger.info "Cuenta Seleccionada Clase =====> #{params[:cuenta_bcv_fondas_sel].class.to_s}"
    logger.info "Fecha Valor =====> #{params[:fecha_valor_f]}"

    logger.info "Entrando al rails runner con ====> " << "EnvioCobranza.generar_cobranzas(#{entidad_financiera_id.to_s},#{tipo_cobro.to_s},\'#{cuenta_matriz.to_s}\',#{fecha_valor.to_s})"
    resultado = EnvioCobranza.generar_cobranzas(entidad_financiera_id.to_i,tipo_cobro,params[:cuenta_bcv_fondas_sel][0],fecha_valor)
      
    #EnvioCobranza.generar_cobranzas(entidad_financiera_id, tipo_cobro, cuenta_matriz, fecha_valor)

    if resultado == "0"
      params['sort'] = "fecha desc"
      condition = "estatus_proceso = 2 "
      @list = ControlEnvioCobranza.search(condition, params[:page], params['sort'])    
      @total = @list.count
      render :update do |page|
        page.replace_html 'list', :partial => 'list_view'
      end
      return
    else
      @mensaje1 = resultado
      render :update do |page|
        page.replace_html 'error', @mensaje1.html_safe
        page.show 'error'
        page.hide 'mensaje'
        page.<< "window.scrollTo(0,0);"
        page.<< "this.disabled=false;"
        #page.form_error
      end
      return  
    end
    
  end

  def entidad_financiera_change    
    unless params[:id].to_s ==''
      @cuenta_bcv_fondas = CuentaBcv.find(:all, :conditions=>"activo=true and entidad_financiera_id = #{params[:id]}", :order=> "numero")
    else
      @cuenta_bcv_fondas =[]
    end
    render :update do |page|
      page.replace_html 'cuenta_bcv-select', :partial => 'cuenta_bcv_select'
    end
  end

  def resultado
    @resultado = params[:result]
  end
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.EnvioCobranzas.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.EnvioCobranzas.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.EnvioCobranzas.FormTitles.form_title_records')
    @form_entity = 'Envio Cobranza'
    @form_identity_field = 'id'
    @width_layout = '960'
  end 
  
  private
  

end