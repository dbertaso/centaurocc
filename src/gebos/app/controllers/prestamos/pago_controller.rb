# encoding: utf-8

class Prestamos::PagoController < FormTabsController

  layout 'form_basic'

  skip_before_filter :set_charset, :only=>[:agregar_cheque, :exigible_change, :modalidad_change, :calendar_date_select, :eliminar_cheque, :ejecutar_pago, :entidad_change]

  def index
    @cuenta_bcv_select = []
    @tipo_cartera = TipoCartera.find(:all, :order=>'nombre')
  end

  def list

    params['sort'] = "nombre_cliente" unless params['sort']

    conditions = ""
    unless params[:identificacion].nil? or params[:identificacion] == ""

      if conditions.empty? 
        conditions << " identificacion LIKE \'%#{params[:tipo]+params[:identificacion].strip}%\'"
      else
        conditions << " and identificacion LIKE \'%#{params[:tipo]+params[:identificacion].strip}%\'"
      end
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.cedula_rif_contenga')} '#{params[:tipo]+params[:identificacion]}'"
    end
    unless params[:numero].nil? || params[:numero].to_i <= 0

      if conditions.empty?
        conditions << " numero = #{params[:numero].to_s}" 
      else
        conditions << " and numero = #{params[:numero].to_s}"
      end
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.numero_tramite')} '#{params[:numero]}'"
    end

    unless params[:moneda_id].nil? 
      unless params[:moneda_id][0].to_s==''      
        moneda = Moneda.find(params[:moneda_id][0].to_s)
        if conditions.empty?    
          conditions << " moneda_id = #{params[:moneda_id][0].to_s} "
        else
          conditions << " and moneda_id = #{params[:moneda_id][0].to_s} "
        end

        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.moneda_igual')} '#{moneda.nombre}'"
      end
    end

    unless params[:numero_solicitud].nil? || params[:numero_solicitud].to_i <= 0
      #conditions = "#{conditions} AND (numero_helper =  #{@params[:numero].to_i} OR origen_helper = #{@params[:numero].to_i})"
      if conditions.empty?
        conditions << " numero_solicitud = #{params[:numero_solicitud].to_s} OR numero_origen = #{params[:numero_solicitud].to_s}"
      else
        conditions << " and numero_solicitud = #{params[:numero_solicitud].to_s} OR numero_origen = #{params[:numero_solicitud].to_s}"
      end

      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.numero_tramite')} '#{params[:numero_solicitud]}'"
    end

    unless params[:nombre].nil? or params[:nombre] == ""
      if conditions.empty?
        conditions << " LOWER(nombre_cliente) LIKE \'%#{params[:nombre].strip.downcase}%\'"
      else
        conditions << " and LOWER(nombre_cliente) LIKE \'%#{params[:nombre].strip.downcase}%\'"
      end

      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.nombre_apellido')} '#{params[:nombre]}'"
    end

    logger.info "Conditions =====> #{conditions}"
    
    
    @list = ViewConsultaPrestamos.search(conditions, params[:page], params[:sort])
    @total=@list.count
    @pages = @list

    form_list

  end

  def pagar
    @monto_pago = 0
    
    @cuenta_bcv_select = []
    @check_exigible = false
    @prestamo_list = Prestamo.find(:all,
      :conditions=>["id = ?", params[:prestamo_id]], :order=>'prestamo.numero')
    @prestamo_pago = Prestamo.find(params[:prestamo_id])
     #@prestamo.ejecutar_cierre_diario(Time.now.strftime("%Y-%m-%d"),@prestamo.id)

  end

  def agregar_cheque
    @cheque_contador = Time.now.to_f
    #@cheque_contador = @cheque_contador + 1
#    if @prestamo.tipo_credito == 2
#      @entidad_financiera_select = EntidadFinanciera.find(:all, :order=>'nombre', :conditions=>'id='+@prestamo.entidad_financiera.id.to_s)
#    else
#      @entidad_financiera_select = EntidadFinanciera.find(:all, :order=>'nombre')
#    end
    render :update do |page|
#      if params[:tipo]== 'taquilla'
#        page.insert_html :bottom, 'lista_cheque_taquilla' , :partial => 'cheque'
#      elsif params[:tipo]== 'cuenta_recaudadora'
#        page.insert_html :bottom, 'lista_cheque_cuenta_recaudadora' , :partial => 'cheque'
#      elsif params[:tipo]== 'banco_intermediado'
#        page.insert_html :bottom, 'lista_cheque_banco_intermediado' , :partial => 'cheque'
#      end
      #page.<< "window.scrollTo(0,1500);"
      page.insert_html :bottom, 'lista_cheque' , :partial => 'cheque'
      
    end
  end

  def eliminar_cheque
    render :update do |page|
      page.remove "cheque_#{params[:cheque_contador]}"
    end
  end

  def ejecutar_pago

    total_prestamos = 0
    entidad_financiera_id = 0

    if !params[:fecha_realizacion].nil?
     fecha_realizacion = params[:fecha_realizacion]
    end

    #logger.info "PRESTAMO CLIENTE ======> " << @prestamo.cliente.inspect

    logger.info "Prestamo =======> " << @prestamo.inspect

    logger.info "Parametros =====> " << params.inspect
    cliente = @prestamo.cliente

    logger.info "CLIENTE ==========> " << cliente.inspect

    oficina = Oficina.find(:first, :conditions => "id = #{@usuario.oficina_id}")

    if params[:exonerar_mora] == '1'
      exonerar_mora = true
    else
      exonerar_mora = false
    end
    total_prestamos = params[:monto_pago].to_f

    logger.info "TOTAL PRESTAMOS ===> " << params[:monto_pago].to_s
    total_cheques = 0
    efectivo = 0

     #temporal
     #for prestamo in params[:prestamo]
     #  total_prestamos += prestamo[1][:monto].to_f
    # end
    fecha_sistema = params[:fecha_sistema].split('/')
    fecha_sistema = (fecha_sistema[2] + '-' + fecha_sistema[1] + '-' + fecha_sistema[0]).to_date
    fecha_realizacion = params[:fecha_realizacion].split('/')
    fecha_realizacion = (fecha_realizacion[2] + '-' + fecha_realizacion[1] + '-' + fecha_realizacion[0]).to_date

    hoy = (Time.now.year.to_s + '-' + Time.now.month.to_s + '-' + Time.now.day.to_s).to_date

    ultimo_cerrado = TablaCuadre.find(:first, :order=>'ano desc, mes desc')

    if fecha_sistema > hoy
      render :update do |page|
        page.alert I18n.t('Sistema.Body.Controladores.Pago.Errores.fecha_contable_no_mayor_hoy')
        page.<< "varEnviado=false;$('button_save').disabled=false"
      end
      return
    end

    if fecha_realizacion > hoy
      render :update do |page|
        page.alert I18n.t('Sistema.Body.Controladores.Pago.Errores.fecha_deposito_no_mayor_hoy')
        page.<< "varEnviado=false;$('button_save').disabled=false"
      end
      return
    end

    if params[:fecha_realizacion].to_datetime > params[:fecha_sistema].to_datetime
      render :update do |page|
        page.alert I18n.t('Sistema.Body.Controladores.Pago.Errores.fecha_deposito_no_mayor_fecha_contable')
        page.<< "varEnviado=false;$('button_save').disabled=false"
      end
      return
    end

    if !ultimo_cerrado.nil?

      mes_cerrado_adelantado = ultimo_cerrado.mes.to_i + 2
      if mes_cerrado_adelantado > 12
        mes_cerrado_adelantado = mes_cerrado_adelantado.to_i - 12
        ano_cerrado_adelantado = ultimo_cerrado.ano + 1
    else
        ano_cerrado_adelantado = ultimo_cerrado.ano.to_i
      end

      if fecha_sistema.month == ultimo_cerrado.mes && fecha_sistema.year == ultimo_cerrado.ano
        render :update do |page|
          page.alert I18n.t('Sistema.Body.Controladores.Pago.Errores.fecha_no_puede_pertenecer_mes_cerrado')
          page.<< "varEnviado=false;$('button_save').disabled=false"
        end
        return
      end

      if fecha_sistema.month > mes_cerrado_adelantado
        if fecha_sistema.year >= ano_cerrado_adelantado
          render :update do |page|
            page.alert I18n.t('Sistema.Body.Controladores.Pago.Errores.fecha_no_puede_ser_mayor_ultimo_cierre')
            page.<< "varEnviado=false;$('button_save').disabled=false"
          end
          return
        end
      end

    end

    logger.info "PARAMETROS DEL CHEQUE ==========> #{params.inspect}"
  
    if !params[:cheque].nil?
      for cheque in params[:cheque]
        logger.info "Contenido de cheque =======> #{cheque.inspect}"
        
        total_cheques += cheque[1][:monto].to_f
        pago_forma = PagoForma.find_by_referencia(cheque[1][:referencia]);
        if pago_forma
          render :update do |page|
            page.alert "#{t('Sistema.Body.Controladores.Pago.Errores.cheque_numero')} #{cheque[1][:referencia]} #{t('Sistema.Body.Controladores.Pago.Errores.ya_registrado')}"
            page.<< "varEnviado=false;$('button_save').disabled=false"
          end
          return
        end
      end
    end

    if params[:modalidad] == 'A' and (params[:otros_arrimes].nil? || params[:otros_arrimes].empty?)

      boleta = BoletaArrime.find(:first, :conditions=>"solicitud_id = #{@prestamo.solicitud_id}  and guia_movilizacion = \'#{params[:numero_voucher_arrime]}\'")
      if boleta.nil?
        render :update do |page|
          page.alert "#{t('Sistema.Body.Controladores.Pago.Errores.no_existe_boleta_arrime')}: #{params[:numero_voucher_arrime]}"
          page.<< "varEnviado=false;$('button_save').disabled=false"
        end
        return
      end

      if boleta.valor_arrime.to_f != params[:monto_pago].to_f
        render :update do |page|
          page.alert "#{t('Sistema.Body.Controladores.Pago.Errores.monto_pago_diferente')}: #{boleta.valor_arrime_fm}"
          page.<< "varEnviado=false;$('button_save').disabled=false"
        end
        return
      end

      if boleta.estatus == 'A'
        render :update do |page|
          page.alert "#{t('Sistema.Body.Controladores.Pago.Errores.boleta_arrime_numero')}: #{params[:numero_voucher_arrime]} #{t('Sistema.Body.Controladores.Pago.Errores.ya_fue_cancelada')}"
          page.<< "varEnviado=false;$('button_save').disabled=false"
        end
        return
      end

      if boleta.confirmacion == false
        render :update do |page|
          page.alert "#{t('Sistema.Body.Controladores.Pago.Errores.boleta_arrime_numero')}: #{params[:numero_voucher_arrime]} #{t('Sistema.Body.Controladores.Pago.Errores.no_esta_confirmada')}"
          page.<< "varEnviado=false;$('button_save').disabled=false"
        end
        return
      end

      if boleta.fecha_entrada != fecha_realizacion
        render :update do |page|
          page.alert "#{t('Sistema.Body.Controladores.Pago.Errores.fecha_del_arrime_es_diferente')}: #{boleta.fecha_confirmacion.strftime("%d-%m-%Y")}"
          page.<< "varEnviado=false;$('button_save').disabled=false"
        end
        return
      end

    end            #=====> params[:modalidad] == 'A' and params[:otros_arrimes] == '0'

   if params[:modalidad] == 'A' and params[:otros_arrimes] == '1'

      boleta = OtroArrime.find(:first, :conditions=>"solicitud_id = #{@prestamo.solicitud_id}  and guia_movilizacion = \'#{params[:numero_voucher_arrime]}\'")
      if boleta.nil?
        render :update do |page|
          page.alert "#{t('Sistema.Body.Controladores.Pago.Errores.no_existe_boleta_arrime')}: #{params[:numero_voucher_arrime]}"
          page.<< "varEnviado=false;$('button_save').disabled=false"
        end
        return
      end

      if boleta.monto_arrime.to_f != params[:monto_pago].to_f
        render :update do |page|
          page.alert "#{t('Sistema.Body.Controladores.Pago.Errores.monto_pago_diferente')}: #{boleta.monto_arrime_f}"
          page.<< "varEnviado=false;$('button_save').disabled=false"
        end
        return
      end

      if boleta.estatus == 'A'
        render :update do |page|
          page.alert "#{t('Sistema.Body.Controladores.Pago.Errores.boleta_arrime_numero')}: #{params[:numero_voucher_arrime]} #{t('Sistema.Body.Controladores.Pago.Errores.ya_fue_cancelada')}"
          page.<< "varEnviado=false;$('button_save').disabled=false"
        end
        return
      end

      if boleta.confirmacion == false
        render :update do |page|
          page.alert "#{t('Sistema.Body.Controladores.Pago.Errores.boleta_arrime_numero')}: #{params[:numero_voucher_arrime]} #{t('Sistema.Body.Controladores.Pago.Errores.no_esta_confirmada')}"
          page.<< "varEnviado=false;$('button_save').disabled=false"
        end
        return
      end

      if boleta.fecha_entrada != fecha_realizacion
        render :update do |page|
          page.alert "#{t('Sistema.Body.Controladores.Pago.Errores.fecha_del_arrime_es_diferente')}: #{boleta.fecha_confirmacion.strftime("%d-%m-%Y")}"
          page.<< "varEnviado=false;$('button_save').disabled=false"
        end
        return
      end

    end            #=====> params[:modalidad] == 'A' and params[:otros_arrimes] == '1'

    if params[:modalidad]=='R'
      efectivo += params[:monto_efectivo].to_f
    end

    logger.info 'cheques ' << (total_cheques).to_s
    logger.info 'efectivo ' << (efectivo).to_s
    total = total_cheques + efectivo

    logger.info "Confirmacion ======> " << params[:confirmacion].to_s

    if params[:confirmacion] != 'true'

      logger.info 'cheques + efectivo ' << (total_cheques+efectivo).to_s
      
      if @prestamo.estatus == 'C' && params[:modalidad] == 'R'

        render :update do |page|
          page.alert t('Sistema.Body.Controladores.Pago.Errores.no_se_puede_pagar_prestamos_cancelados_por_recaudadora')
          page.<< "varEnviado=false;$('button_save').disabled=false"
        end
        return
      end

      if total_cheques != total_prestamos && params[:modalidad] == 'O'
        render :update do |page|
          page.alert t('Sistema.Body.Controladores.Pago.Errores.monto_pago_diferente_suma_cheques')
          page.<< "varEnviado=false;$('button_save').disabled=false"
        end
        return
      #logger.info "ENTRO EN EL PRIMER ELSEIF"
      elsif

        (total_cheques+efectivo).to_s != total_prestamos.to_s && params[:modalidad] == 'R'
        render :update do |page|
          page.alert t('Sistema.Body.Controladores.Pago.Errores.monto_pago_diferente_suma_cheques_efectivo')
          page.<< "varEnviado=false;$('button_save').disabled=false"
        end
        return
      #logger.info "ENTRO EN EL SEGUNDO ELSEIF"
      elsif params[:modalidad]=='R' && (params[:numero_voucher].nil? || params[:numero_voucher].empty?)
        render :update do |page|
          page.alert params.inspect
          page.alert t('Sistema.Body.Controladores.Pago.Errores.numero_voucher_requerido')
          page.<< "varEnviado=false;$('button_save').disabled=false"
        end
        return
      #logger.info "ENTRO EN EL TERCER ELSEIF"
      elsif params[:modalidad] == 'R' && (params[:cuenta_bcv_id] == '0' || params[:cuenta_bcv_id].nil?)
         render :update do |page|
          page.alert t('Sistema.Body.Controladores.Pago.Errores.numero_cuenta_recaudadora_requerido')
          page.<< "varEnviado=false;$('button_save').disabled=false"
        end
        return     
      elsif params[:modalidad] && params[:numero_voucher] && !params[:numero_voucher].nil? && !params[:numero_voucher].empty?
        pago_cliente = PagoCliente.find_by_numero_voucher(params[:numero_voucher])
       if pago_cliente
          render :update do |page|
            page.alert t('Sistema.Body.Controladores.Pago.Errores.voucher') + params[:numero_voucher] + t('Sistema.Body.Controladores.Pago.Errores.voucher')
            page.<< "varEnviado=false;$('button_save').disabled=false"
          end
          return
        end
      #logger.info "ENTRO EN EL CUARTO ELSEIF"
      elsif params[:fecha_realizacion].nil? || params[:fecha_realizacion].empty?
        render :update do |page|
          page.alert t('Sistema.Body.Controladores.Pago.Errores.fecha_realizacion_es_requerida')
          page.<< "varEnviado=false;$('button_save').disabled=false"
        end
        #logger.info "EJECUTO EL RETURN "
        return


      #logger.info "DEUDA MAYOR O IGUAL ====> " << total_prestamos.to_s << "   " << @prestamo.deuda.to_s

      #elsif total_prestamos > @prestamo.deuda
        #render :update do |page|
          #page.alert t('Sistema.Body.Controladores.Pago.Errores.monto_pago_no_puede_superar_deuda')
          #page.<< "varEnviado=false;$('button_save').disabled=false"
        #end
        #return
      end

     #if total_prestamos >= @prestamo.deuda.to_f

      #logger.info "ENTRO POR ELSIF ====> " << total_prestamos.to_s << "   " << @prestamo.deuda.to_s
      #plan_pago = PlanPago.find_by_prestamo_id_and_activo(@prestamo.id,true)

      #cuotas_pagadas = PlanPagoCuota.count(:conditions=>" plan_pago_id = #{plan_pago.id} and estatus_pago = 'T' and tipo_cuota = 'C'")
      #cuotas_totales = PlanPagoCuota.count(:conditions=>" plan_pago_id = #{plan_pago.id}  and tipo_cuota = 'C'")

      #cuotas_pendientes = cuotas_totales - cuotas_pagadas

      #logger.info "ENTRO AL IF CUOTAS PENDIENTES  ====> " << cuotas_pendientes.to_s

      #if cuotas_pendientes.to_i > 1

        #render :update do |page|
          #page.alert t('Sistema.Body.Controladores.Pago.Errores.mensaje_cancelacion')
          #page.<< "varEnviado=false;$('button_save').disabled=false"
        #end
        #return
      #end
     #end
      render :update do |page|
        logger.info "Entro en confirmar pago"
        page.<< "confirmar_pago('#{@prestamo.cliente.nombre}','#{@prestamo.solicitud.rubro.nombre}','#{@prestamo.numero}','#{format_fm total_prestamos} Bs.','#{params[:fecha_realizacion]}','#{@prestamo.id.to_s}', '#{@prestamo.cliente.id.to_s}');"
      end
    else
      fecha_realizacion = params[:fecha_realizacion].split('/')
      #fecha_realizacion = Time.gm(fecha_realizacion[2].to_i, fecha_realizacion[1].to_i, fecha_realizacion[0].to_i, 0, 0, 0)
      fecha_realizacion = Date.new(fecha_realizacion[2].to_i, fecha_realizacion[1].to_i, fecha_realizacion[0].to_i)
      fecha_sistema = params[:fecha_sistema].split('/')
      #fecha_sistema = Time.gm(fecha_sistema[2].to_i, fecha_sistema[1].to_i, fecha_sistema[0].to_i, 0, 0, 0)
      fecha_sistema = Date.new(fecha_sistema[2].to_i, fecha_sistema[1].to_i, fecha_sistema[0].to_i)

      if params[:consultoria_juridica].nil? || params[:consultoria_juridica].empty?

        consultoria_juridica = false
      else
        consultoria_juridica = params[:consultoria_juridica]
      end

      if params[:recuperaciones].nil? || params[:recuperaciones].empty?

        recuperaciones = false
      else
        recuperaciones = params[:recuperaciones]
      end

      logger.info "Entidad Cuenta Recaudadora #{params[:entidad_financiera_id].inspect}"
      entidad_financiera_id = params[:entidad_financiera_id]
      

      if params[:modalidad] == 'A'
      
        boleta = BoletaArrime.find(:first, :conditions=>"solicitud_id = #{@prestamo.solicitud_id}  and guia_movilizacion = \'#{params[:numero_voucher_arrime]}\'")
      
        if boleta.nil?
          boleta = OtroArrime.find(:first, :conditions=>"solicitud_id = #{@prestamo.solicitud_id}  and guia_movilizacion = \'#{params[:numero_voucher_arrime]}\'")
        end
    
        if !boleta.nil?
          entidad_financiera_id = boleta.silo_id
        else
          entidad_financiera_id = 0
        end
      end

      logger.info "Cliente Antes de Ejecutar Funcion de pago  =======> " << cliente.inspect << " Id cliente ====> " << cliente.id.to_s
      logger.info "PARAMETROS =========> #{params.inspect}"
      resultado = @prestamo.ejecutar_pago @prestamo.cliente_id, params[:cheque], params[:prestamo], @prestamo.id, params[:modalidad],
        total_prestamos, oficina, fecha_realizacion, fecha_sistema, params[:modalidad]=='R' ? params[:numero_voucher] : params[:numero_voucher_arrime], entidad_financiera_id, efectivo,   exonerar_mora, @usuario.id, consultoria_juridica, params[:comentario_analista], session[:id], recuperaciones, params[:cuenta_bcv_id]

      logger.info "Resultado =======> #{resultado.inspect}"
      if  resultado == 'Correcto'
        render :update do |page|
          page.redirect_to :action=>'resumen', :cliente_id=>params[:cliente_id], :prestamo_id=>params[:prestamo_id]
        end
      elsif resultado == 'No hay autorizacion'
        render :update do |page|
          page.alert t('Sistema.Body.Controladores.Pago.Errores.no_existe_autorizacion_exoneracion_mora')
          page.<< "varEnviado=false;$('button_save').disabled=false"
        end
      elsif resultado == 'sin monto cheque'
        render :update do |page|
          page.alert 'No se pudo procesar el pago debido a que algun cheque tiene monto cero'
          params[:confirmacion] = 'false'
          page.<< "varEnviado=false;$('button_save').disabled=false;$('confirmacion').value = '0';"
        end      
      else
        render :update do |page|
          page.alert t('Sistema.Body.Controladores.Pago.Errores.requiere_autorizacion_no_existe')
          page.<< "varEnviado=false;$('button_save').disabled=false"
        end
      end
    end
  end


  def resumen


    @cliente =  @prestamo.cliente

    @prestamo_list = Prestamo.find(:all,
      :conditions=>["id = ? ", params[:prestamo_id]], :order=>'prestamo.numero')

  end
  
  def entidad_change
  
    logger.info "Parametros ==========> #{params.inspect}"
    @cuenta_bcv_select = CuentaBcv.all(:select=> 'id, case when tipo = \'A\' then \'Ahorro-\' else \'Corriente-\' end || numero as numero_cuenta', :order=>'numero_cuenta', :conditions=>"recaudador = true and activo = true and entidad_financiera_id = #{params[:entidad]}")
    
    render :update do |page|
      page.replace_html "cuentas_recaudadoras", :partial => "cuenta_recaudadora"
    end
  
  end
  
  def exigible_change

    @prestamo = Prestamo.find(params[:prestamo_id])

    if params[:valor] == 'true'
      #puts "pasa por aqui parte 1"
      @monto_pago = @prestamo.exigible
    else
    #puts "pasa por aqui parte 2"
      @monto_pago = 0
    end
    render :update do |page|
      page.replace_html "monto_pagar", :partial => "monto_pagar"
    end


  end

  def modalidad_change

    render :update do |page|

      page.hide 'cuenta_recaudadora'
      page.hide 'banco_intermediado'
      page.hide 'taquilla'
      page.hide 'arrime'
      page.hide 'cheques'

      if params[:modalidad] == 'T'
        #if @prestamo.tipo_credito.id==1
         if params[:tipo_credito_id].to_i==1
          page.show 'taquilla'
          page.show 'cheques'
        else
          page.alert t('Sistema.Body.Controladores.Pago.Errores.prestamo_intermediado_seleccione_modalidad')
        end
      elsif params[:modalidad] == 'R'
        #if @prestamo.tipo_credito.id==1
        if params[:tipo_credito_id].to_i==1
          page.show 'cuenta_recaudadora'
          page.show 'cheques'
          page.hide 'arrime'
        else
          page.alert t('Sistema.Body.Controladores.Pago.Errores.prestamo_intermediado_seleccione_modalidad')
        end
      elsif params[:modalidad] == 'A'
        page.show 'arrime'
        page.hide 'cuenta_recaudadora'
        page.hide 'cheques'
      elsif params[:modalidad] == 'O' 
        page.hide 'taquilla'
        page.hide 'cheques'
        page.hide 'cuenta_recaudadora'
        page.hide 'arrime'
      end
      
    end     # -------> Fin de render :update
    
  end


  protected
  def common
    super
    @form_title = t('Sistema.Body.Controladores.Pago.FormTitles.form_title')
    @form_title_record = t('Sistema.Body.Controladores.Pago.FormTitles.form_title_record')
    @form_title_records = t('Sistema.Body.Controladores.Pago.FormTitles.form_title_records')
    @form_entity = 'pago_cliente'
    @form_identity_field = 'numero'
    @records_by_page = 50
    
    @width_layout=1000;
    @entidad_financiera_cheque = EntidadFinanciera.all(:conditions=>'entidad_financiera.activo=true', :select=> 'entidad_financiera.id, entidad_financiera.nombre', :order=>'nombre')
    if params[:prestamo_id]
      @prestamo = Prestamo.find(params[:prestamo_id])
      if @prestamo.tipo_credito.id==2
        @entidad_financiera_select = EntidadFinanciera.all(:conditions=>'entidad_financiera.activo=true', :order=>'nombre', :conditions=>'id='+@prestamo.entidad_financiera.id.to_s+' and recaudador = true')
      else
        @entidad_financiera_select = EntidadFinanciera.all(:conditions=>'entidad_financiera.activo=true', :order=>'nombre')
      end
    end
    sentencia="SELECT mon.id AS id, mon.abreviatura,mon.nombre,        
                    CASE
                      WHEN 
                          mon.id = par.moneda_id 
                      THEN 
                          '1'::text
                      ELSE 
                          '0'::text
                    END 
                        AS no_va
              FROM moneda mon,parametro_general par 
              where mon.activo=true order by no_va desc, nombre;"
    @moneda_list=Moneda.find_by_sql(sentencia) 
  end

end

