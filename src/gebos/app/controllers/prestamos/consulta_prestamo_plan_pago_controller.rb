class Prestamos::ConsultaPrestamoPlanPagoController < FormTabTabsController


  skip_before_filter :set_charset, :only=>[:plan_pago_change, :calcular_prestamo, :calcular_cartera, :imprimir]

  include RjReport

  layout 'form'

  def index
    @plan_pago = PlanPago.find_by_prestamo_id_and_activo(params[:prestamo_id], true)
    @prestamo = @plan_pago.prestamo
    #@prestamo.ejecutar_cierre_diario(Time.now.strftime("%Y-%m-%d"),@prestamo.id)
    @tasa_historico = PrestamoTasaHistorico.find_by_sql("select * from prestamo_tasa_historico where prestamo_id = " << @prestamo.id.to_s << " order by fecha desc limit 1")
    @solicitud = Solicitud.find(@prestamo.solicitud_id)
    @programa = Programa.find(@solicitud.programa_id)
    @tasa_foncrei = @plan_pago.tasa * @programa.porcentaje_tasa_foncrei / 100
    @tasa_intermediario = @plan_pago.tasa - @tasa_foncrei
    logger.info @prestamo.intermediado.to_s
    @intermediado = @prestamo.intermediado
    fill_plan_pago
  end

  def plan_pago_change
    @plan_pago = PlanPago.find_by_id(params[:plan_pago_id])
    @prestamo = @plan_pago.prestamo
    render :update do |page|
      page.replace_html 'list', render(:partial=>'list')
    end
  end

  def calcular_prestamo
    fecha = params[:fecha_calculo_prestamo].split('/')
    fecha = Time.gm(fecha[2].to_i, fecha[1].to_i, fecha[0].to_i, 0, 0, 0)

    @plan_pago = PlanPago.find_by_id(params[:plan_pago_id])
    @prestamo = @plan_pago.prestamo

    if @prestamo.calcular_prestamo(fecha, false)
      @plan_pago = PlanPago.find_by_id(params[:plan_pago_id])
      @prestamo = @plan_pago.prestamo
      render :update do |page|
        page.hide 'error'
        page.replace_html 'list', render(:partial=>'list')
      end
    else
      render :update do |page|

        page.replace_html 'error', render(:partial=>'error')
        page.show 'error'
      end
    end
  end

  def calcular_cartera
    fecha = params[:fecha_calculo_cartera].split('/')
    fecha = Time.gm(fecha[2].to_i, fecha[1].to_i, fecha[0].to_i, 0, 0, 0)

    @plan_pago = PlanPago.find_by_id(params[:plan_pago_id])
    @prestamo = @plan_pago.prestamo

    if @prestamo.calcular_cartera(fecha, session[:oficina].id)
      render :update do |page|
        page.hide 'error'
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

    @prestamo = Prestamo.find(params[:prestamo_id]);
    @reporte = params[:reporte]

    parameters = {}
    parameters = {:p_prestamo=> [@prestamo.numero, "Long"] }

    #logger.info "reporte ---------- " + @reporte

    nombre_reporte = "plan_pago"
    nombre_carpeta = "prestamos"
    archivo = "PlanPago"

    #logger.info parameters.inspect
    send_doc(nombre_reporte, parameters, nombre_carpeta, archivo + @prestamo.numero.to_s, "pdf" )

  end

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.ConsultaPrestamoPlanPago.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.ConsultaPrestamoPlanPago.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.ConsultaPrestamoPlanPago.FormTitles.form_title_records')
    @form_entity = 'plan_pago'
    @form_identity_field = 'prestamo.numero'
    @width_layout = '1200'
  end

  def fill_plan_pago
    @plan_pago_select = PlanPago.find(:all, :conditions=>['prestamo_id = ? and proyeccion = false', @prestamo.id], :order=>'id desc')
    logger.info @plan_pago_select
  end


end

