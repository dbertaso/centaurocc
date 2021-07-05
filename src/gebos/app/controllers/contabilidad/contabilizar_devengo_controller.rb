# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Contabilidad::ContabilizarDevengoController
# descripción: Migración a Rails 3

class Contabilidad::ContabilizarDevengoController < FormTabsController

  def index
    hoy = Date.new(Time.now.year,Time.now.month,1) -1
    @fecha_f = hoy.strftime("%d/%m/%Y")

  end

  def contabilizar

    logger.info "\nParametros ====> " << params.inspect
    @tipo = params[:tipo]
    @fecha = params[:fecha_f]

    if @tipo.blank?
      flash[:error] = "El tipo de interés a contabilizar es requerido"
      render :action => "index"
      return
    end


    @mes = @fecha[3,2].to_i
    @ano = @fecha[6,4].to_i
    @dia = @fecha[0,2].to_i

    fecha_b = Date.new(@ano,@mes,@dia)

    @fecha = fecha_b.strftime("%Y-%m-%d")

    logger.info "@mes =====> " << @mes.to_s
    logger.info "@ano =====> " << @ano.to_s
    logger.info "@fecha =====> " << @fecha.to_s

    @mes_actual = Time.now.month

    if @mes > @mes_actual
      flash[:error] = "El mes de devengo de interes no puede ser mayor que el mes actual"
      render :update do |page|
       page.redirect_to :action=>'index'
      end
      return
    end

    dif = @mes_actual - @mes

    if dif > 1
     flash[:error] = "El mes de devengo de intereses no puede ser menor al mes anterior de la fecha actual"
     render :update do |page|
       page.redirect_to :action=>'index'
     end
     return
    end

    if @tipo == 'C'
      transaccion = 'DEVENGO INTERES ORDINARIO'
      descripcion = 'Devengo Interes Ordinario'
      error = 'Interés Ordinario'
    else
      transaccion = 'DEVENGO INTERES DIFERIDO'
      descripcion = 'Devengo Interes Diferido'
      error = 'Interes Diferido'
    end

    logger.info "@transaccion =====> " << transaccion.to_s

    if !DevengoMensual.verificar_devengos?(@tipo,@ano,@mes)
      flash[:error] = "No existen devengos de #{error} para el mes que esta procesano"
      render :update do |page|
        page.redirect_to :action=>'index'
      end
     return

    end


    comprobante = ComprobanteContable.find_by_fecha_comprobante_and_transaccion_contable_id(@fecha ,19)

    #logger.info "COMPROBANTE =====> " << comprobante.inspect

    if !comprobante.nil?

        logger.info "COMPROBANTE =====> " << comprobante.inspect

        render :update do |page|
          logger.info "Mes ========> " << @mes.to_s
          logger.info "Transaccion ===> " << transaccion.to_s
          page.<< "confirmar_contabilizacion('#{@tipo}','#{@ano}','#{@mes}','#{transaccion}','#{descripcion}','#{@fecha}');"
          #page.<< "alert('hola mundo')"
        end

    else
         ejecutar_contabilizacion_sin_eliminar(@ano,@mes,@tipo,transaccion,@fecha)
         return true
    end

  end

  def ejecutar_contabilizacion()

    logger.info "Parametros =========> " << params.inspect

    logger.info "Ano: ================> " << params[:ano].to_s
    logger.info "Mes: ================> " << params[:mes].to_s
    logger.info "Tipo: ================> " << params[:tipo].to_s
    logger.info "Transaccion: ================> " << params[:transaccion]
    logger.info "Fecha: ================> " << params[:fecha].to_s

    ComprobanteContable.elimina_comprobante_contable(params[:fecha], params[:transaccion])


    archivo1 = "DevengoMensual.contabilizar_devengos(\"#{params[:tipo]}\",#{params[:ano].to_i},#{params[:mes].to_i})"
    logger.info "Archivo 1 ======> " << archivo1.to_s
   `script/runner '#{archivo1}'`

    flash[:notice] = "El proceso de contabilización comenzó esto tardará algunos minutos puede continuar con su trabajo"
    render :update do |page|
      page.redirect_to :action=>'index'
    end

    #render :action => "index"

  end

    def ejecutar_contabilizacion_sin_eliminar(ano,mes,tipo,transaccion,fecha)

    logger.info "Ano: ================> " << ano.to_s
    logger.info "Mes: ================> " << mes.to_s
    logger.info "Tipo: ================> " << tipo.to_s
    logger.info "Transaccion: ================> " << transaccion.to_s
    logger.info "Fecha: ================> " << fecha.to_s

    archivo1 = "DevengoMensual.contabilizar_devengos(\"#{tipo}\",#{ano.to_i},#{mes.to_i})"
    logger.info "Archivo 1 ======> " << archivo1.to_s
   `script/runner '#{archivo1}'`

    flash[:notice] = "El proceso de contabilización comenzó esto tardará algunos minutos puede continuar con su trabajo"
    render :update do |page|
     page.redirect_to :action=>'index'
   end

  end

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.Contabilidad.ContabilizarDevengo.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.Contabilidad.ContabilizarDevengo.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.Contabilidad.ContabilizarDevengo.form_title_records')

  end


 end

