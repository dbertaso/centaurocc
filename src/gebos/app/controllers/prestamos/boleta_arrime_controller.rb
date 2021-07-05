# encoding: utf-8
class Prestamos::BoletaArrimeController < FormTabTabsController

  skip_before_filter :set_charset, :only=>[:tabs, :precio_gaceta_change, :precio_gaceta_script, :silo_change, :save_new_arrime_conjunto, :delete_arrime_conjunto, :imprimir, :confirmar ]
  
  def index
    @view_boleta_arrime = ViewBoletaArrime.find_by_solicitud_id(params[:solicitud_id])
    @municipio = Municipio.find(Oficina.find(session[:oficina]).municipio_id.to_s)
    list
  end

  def list
    conditions = "solicitud_id = #{params[:solicitud_id]}"
    params['sort'] = "solicitud_id" unless params['sort']
    conditions  << " and solicitud_id > 0 and silo_id in (select id from silo where estado_id = #{@municipio.estado_id.to_s})"
    
    @list = BoletaArrime.search(conditions, params[:page], params[:sort])
    @total=@list.count
    form_list
  end

  def new
    @view_boleta_arrime = ViewBoletaArrime.find_by_solicitud_id(params[:solicitud_id])
    @formato_boleta = FormatoBoleta.find_by_actividad_id(@view_boleta_arrime.actividad_id)
    @cliente= Cliente.find(@view_boleta_arrime.cliente_id)
    @rubro = Rubro.find(@view_boleta_arrime.rubro_id)
    @boleta_arrime = BoletaArrime.new
    hora = Time.now.strftime("%X,%p")
    @boleta_arrime.hora_registro_f = hora
    @municipio = Municipio.find(Oficina.find(session[:oficina]).municipio_id.to_s)
    @view_acta_silo = ViewActaSilo.find(:all,
      :conditions=>["actividad_id = #{@view_boleta_arrime.actividad_id} and status = true and estado_id = #{@municipio.estado_id.to_s} and fecha_fin is null"])
        
    @ciclo_productivo = CicloProductivo.find(:all, :order=>'nombre')

  end

  def precio_gaceta_change
    concat = params[:id].to_s.split(';')
    @view_precio1 = ViewConvenioSilo.find(:first, :conditions=>["status = true and convenio = true and actividad_id = #{params[:actividad_id]} and tipo_clase = '#{params[:id]}' and silo_id = #{params[:silo_id]}"])
    if (@view_precio1.nil? || @view_precio1.to_s.empty?)
      @view_precio2 = ViewPrecioGaceta.find(:first, :conditions=>["actividad_id =#{params[:actividad_id]} and tipo_clase = '#{params[:id]}'"])
      @view_precio_gaceta = @view_precio2
      @referencia = nil
    else 
      @view_precio_gaceta = @view_precio1
      @referencia = ViewPrecioGaceta.find(:first, :conditions=>["actividad_id =#{params[:actividad_id]} and tipo_clase = '#{params[:id]}'"])
    end 

    if @view_precio_gaceta.nil?
      @calculo_valor = nil
      render :update do |page|
        page.replace_html 'referencia-gaceta', :partial => 'referencia_gaceta'
        page.replace_html 'precio-gaceta', :partial => 'precio_pago'
        page.replace_html 'valor-arrime', :partial => 'valor_arrime'
        page.alert" #{I18n.t('Sistema.Body.Modelos.BoletaArrime.Errores.no_posee_precio_en_gaceta')} "
      end
    else
      @calculo_valor = "%0.2f" % (params[:peso].to_f * @view_precio_gaceta.valor.to_f)
      render :update do |page|
        page.replace_html 'referencia-gaceta', :partial => 'referencia_gaceta'
        page.replace_html 'precio-gaceta', :partial => 'precio_pago'
        page.replace_html 'valor-arrime', :partial => 'valor_arrime'
      #  page.alert"Ejecutando calculo"
      end
    end
  end

  def precio_gaceta_script
    concat = params[:id].to_s.split('=')
    @view_precio1 = ViewConvenioSilo.find(:first, :conditions=>["status = true and convenio = true and actividad_id = #{concat[2]} and tipo_clase = '#{concat[0]}' and silo_id = #{concat[3]}"])
    if (@view_precio1.nil? || @view_precio1.to_s.empty?)
      @view_precio2 = ViewPrecioGaceta.find(:first, :conditions=>["actividad_id =#{concat[2]} and tipo_clase = '#{concat[0]}'"])
      @view_precio_gaceta = @view_precio2
    else 
      @view_precio_gaceta = @view_precio1
    end 
  
    if @view_precio_gaceta.nil?
      @calculo_valor = nil
      render :update do |page|
        page.replace_html 'precio-gaceta', :partial => 'precio_pago'
        page.replace_html 'valor-arrime', :partial => 'valor_arrime'
        page.alert" #{I18n.t('Sistema.Body.Modelos.BoletaArrime.Errores.no_posee_precio_en_gaceta')} "
      end
    else
      @calculo_valor = "%0.2f" % (concat[1].to_f * @view_precio_gaceta.valor.to_f)
    end
    render :update do |page|
      page.replace_html 'precio-gaceta', :partial => 'precio_pago'
      page.replace_html 'valor-arrime', :partial => 'valor_arrime'
    end
  end

  def silo_change
    @view_acta_silo_list = ViewActaSilo.find(:first, :conditions=>"id = #{params[:id]} and actividad_id = #{params[:actividad_id]} and status = true")
    actividad = Actividad.find(params[:actividad_id])
    if actividad.nombre.downcase.match('algodon').to_s.length > 0
      @condicion_saco_list = CondicionSaco.find(:all, :conditions=>"acta_silo_id = #{@view_acta_silo_list.acta_silo_id} and silo_id = #{params[:id]} and activo = true")
      logger.info"XXXXXXXXXXXXXXX-@condicion_saco_list-XXXXXXXXXXXXX"<<@condicion_saco_list.inspect
      render :update do |page|
        page.replace_html 'acta-silo', :partial => 'silo_change'
        page.replace_html 'rif-silo', :partial => 'rif_silo'
        page.replace_html 'condicion-saco', :partial => 'condicion_saco'
        page.show 'acta-silo'
      end
    else
      render :update do |page|
        page.replace_html 'acta-silo', :partial => 'silo_change'
        page.replace_html 'rif-silo', :partial => 'rif_silo'
        page.show 'acta-silo'
      end
    end
  end


  def save_new
    @view_boleta_arrime = ViewBoletaArrime.find_by_solicitud_id(params[:solicitud_id])
    logger.info"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX>>>>>>>>>>"<<params.inspect
 
    if (params[:laboratorio].nil? || params[:laboratorio].to_s.empty?)
      laboratorio = nil
      parametros_laboratorio = nil
    else
      laboratorio = params[:laboratorio]
      clase_nombre = Object.const_get(laboratorio).table_name
      parametros_laboratorio = params[(clase_nombre).to_sym]
    end
    #end
    clas = params[:boleta_arrime][:clase]
    clas = clas.to_s.split(';')
    clase = clas[0]
    params[:boleta_arrime][:clase] = clase
    arrime = params[:boleta_arrime][:arrime_conjunto]
    if arrime.nil?
      arrime = false
    end
    params[:boleta_arrime][:arrime_conjunto] = arrime
    boleta_arrime = params[:boleta_arrime]
    rubro_id = @view_boleta_arrime.rubro_id
    sub_rubro_id = @view_boleta_arrime.sub_rubro_id
    actividad_id = @view_boleta_arrime.actividad_id
    solicitud_id = params[:solicitud_id]
    cliente_id = @view_boleta_arrime.cliente_id
    errores = BoletaArrime.create(params[:boleta_arrime], rubro_id, actividad_id, sub_rubro_id, solicitud_id, cliente_id, laboratorio, parametros_laboratorio)
    if errores.class.name == 'BoletaArrime'
      boleta_arrime = BoletaArrime.find(errores.id)
      flash[:notice] = I18n.t('Sistema.Body.Modelos.BoletaArrime.Messages.boleta_se_guardo_con_exito')
      render :update do |page|
        new_options = {:action=>'edit', :id=>boleta_arrime.id}
        page.redirect_to new_options
      end
    else
      render :update do |page|
        page.hide 'message'
        page.replace_html 'errorExplanation',"<h2> #{I18n.t('Sistema.Body.General.ocurrio_error')} </h2><p><UL>" << errores << '</UL></p>'
        page.show 'errorExplanation'
        page.<< "window.scrollTo(0,0);"
        page.<< "varEnviado = false;"
      end
    end
  end

  def edit
    @boleta_arrime = BoletaArrime.find(params[:id])
    @formato_boleta = FormatoBoleta.find_by_actividad_id(@boleta_arrime.actividad_id)
    solicitud = Solicitud.find(@boleta_arrime.solicitud_id)
    fill_silo(@boleta_arrime.silo_id, @boleta_arrime.resultado)
    @cliente = Cliente.find(solicitud.cliente_id)
    @rubro = Rubro.find(:all, :order => 'nombre')
    @view_boleta_arrime = ViewBoletaArrime.find_by_solicitud_id(@boleta_arrime.solicitud_id)
    @municipio = Municipio.find(Oficina.find(session[:oficina]).municipio_id.to_s)
    @view_acta_silo = ViewActaSilo.find_by_sql("select * from view_acta_silo where actividad_id = #{@boleta_arrime.actividad_id} and estado_id = #{@municipio.estado_id.to_s} and status = true
                                                and fecha_fin is null and id <> #{@boleta_arrime.silo_id} union select * from view_acta_silo
                                                where actividad_id = #{@boleta_arrime.actividad_id} and estado_id = #{@municipio.estado_id.to_s} and id = #{@boleta_arrime.silo_id} and nro_acta = #{@boleta_arrime.numero_acta}")
    @ciclo_productivo = CicloProductivo.find(:all, :order=>'nombre')

  end

  def fill_silo(silo_id, resultado)
    @view_acta_silo_list = ViewActaSilo.find_by_acta_silo_id_and_nro_acta(@boleta_arrime.acta_silo_id, @boleta_arrime.numero_acta)
    if @boleta_arrime.actividad.nombre.downcase.match('algodon').to_s.length > 0
      if @boleta_arrime.acta_silo_id.nil?
        @condicion_saco_list = nil
      else
        @condicion_saco_list = CondicionSaco.find(:all, :conditions=>"acta_silo_id = #{@boleta_arrime.acta_silo_id} and silo_id = #{@boleta_arrime.silo_id}")
      end
    else
      @condicion_saco_list = nil
    end
    if resultado == 'A'
      #CONSULTA CUANDO LA GACETA NO HA CAMBIADO NI EL PRECIO
      
      if (@boleta_arrime.detalle_convenio_silo_id.nil? || @boleta_arrime.detalle_convenio_silo_id.to_s.empty?)
        @view_precio2 = ViewPrecioGaceta.find_by_id(@boleta_arrime.detalle_precio_gaceta_id)
        @view_precio_gaceta = @view_precio2
        @referencia = nil
      else 
        @view_precio1 = ViewConvenioSilo.find_by_detalle_convenio_silo_id(@boleta_arrime.detalle_convenio_silo_id)
        @view_precio_gaceta = @view_precio1
        unless @view_precio1.to_s.empty?
          @referencia = ViewPrecioGaceta.find(:first, :conditions=>["actividad_id =#{@boleta_arrime.actividad_id.to_s} and tipo_clase = '#{@boleta_arrime.clase.to_s}'"])
        end
      end
   
      if (@view_precio_gaceta.nil? and (@boleta_arrime.detalle_convenio_silo_id.nil? || @boleta_arrime.detalle_convenio_silo_id.to_s.empty?))
        #LA GACETA FINALIZO Y SE PROCEDE A RECALCULAR SEGUN GACETA NUEVA "SI POSEE PRECIO CARGADO"
        @view_precio_gaceta = DetallePrecioGaceta.find_by_sql("select dp.id, pg.id as precio_gaceta_id, pg.gaceta_oficial, pg.status, dp.actividad_id, dp.valor from detalle_precio_gaceta
                          dp left join precio_gaceta pg ON pg.id = dp.precio_gaceta_id where pg.status = 'false' and dp.id = #{@boleta_arrime.detalle_precio_gaceta_id}")
        @view_precio_gaceta = @view_precio_gaceta[0]
        @referencia = nil
      elsif (@view_precio_gaceta.nil? and (@boleta_arrime.detalle_precio_gaceta_id.nil? || @boleta_arrime.detalle_precio_gaceta_id.to_s.empty?))
        @view_precio1 = ViewConvenioSilo.find(:first, :conditions=>["detalle_convenio_silo_id =#{@boleta_arrime.detalle_convenio_silo_id} and status = false and convenio = false"])
        @view_precio_gaceta = @view_precio1
        @referencia = ViewPrecioGaceta.find(:first, :conditions=>["actividad_id =#{@boleta_arrime.actividad_id.to_s} and tipo_clase = '#{@boleta_arrime.clase.to_s}'"])
      end
      @calculo_valor = @boleta_arrime.valor_arrime
      @arrime_conjunto_boleta_arrime_list = ArrimeConjunto.find(:all, :conditions=>["boleta_arrime_id = ?", @boleta_arrime.id])
      @total_acondicionado = ArrimeConjunto.find_by_sql("select sum(peso_condicionado) as total_peso_acondicionado from arrime_conjunto where boleta_arrime_id = #{@boleta_arrime.id}")
      
    end
  end

  def save_edit
    @boleta_arrime = BoletaArrime.find(params[:id])
    id = params[:id]
    clas = params[:boleta_arrime][:clase]
    clas = clas.to_s.split(';')
    clase = clas[0]
    params[:boleta_arrime][:clase] = clase
    parametros = params[:boleta_arrime]
 
    if (params[:laboratorio].nil? || params[:laboratorio].to_s.empty?)
      laboratorio = nil
      parametros_laboratorio = nil
    else
      laboratorio = params[:laboratorio]
      clase_nombre = Object.const_get(laboratorio).table_name
      parametros_laboratorio = params[(clase_nombre).to_sym]
    end
    
    errores = BoletaArrime.update(parametros, laboratorio, parametros_laboratorio, id)
    if errores.class.name == 'BoletaArrime'
      boleta_arrime = BoletaArrime.find(errores.id)
      flash[:notice] = I18n.t('Sistema.Body.Modelos.BoletaArrime.Messages.boleta_se_actualizo_con_exito')
      render :update do |page|
        new_options = {:action=>'edit', :id=>boleta_arrime.id}
        page.redirect_to new_options
      end
    else
      render :update do |page|
        page.hide 'message'
        page.replace_html 'errorExplanation',"<h2> #{I18n.t('Sistema.Body.General.ocurrio_error')} </h2><p><UL>" << errores << '</UL></p>'
        page.show 'errorExplanation'
        page.<< "window.scrollTo(0,0);"
        page.<< "varEnviado = false;"
      end
    end
  end
  
  def view
    @boleta_arrime = BoletaArrime.find(params[:id])
    @vista_view = FormatoBoleta.find_by_actividad_id(@boleta_arrime.actividad_id)
    @view_boleta_arrime = ViewBoletaArrime.find_by_solicitud_id(params[:solicitud_id])
    
    if (@boleta_arrime.detalle_convenio_silo_id.nil? || @boleta_arrime.detalle_convenio_silo_id.to_s.empty?)
      @view_precio2 =  DetallePrecioGaceta.find_by_sql("select dp.id, pg.id as precio_gaceta_id, pg.gaceta_oficial, pg.status, dp.actividad_id, dp.tipo_clase, dp.valor from detalle_precio_gaceta
                          dp left join precio_gaceta pg ON pg.id = dp.precio_gaceta_id where dp.id = #{@boleta_arrime.detalle_precio_gaceta_id}")
      @view_precio_gaceta = @view_precio2[0]
      @referencia = nil
    else 
      @view_precio1 = ViewConvenioSilo.find_by_detalle_convenio_silo_id(@boleta_arrime.detalle_convenio_silo_id)
      @view_precio_gaceta = @view_precio1
      @referencia = DetallePrecioGaceta.find_by_sql("select dp.id, pg.id as precio_gaceta_id, pg.gaceta_oficial, pg.status, dp.actividad_id, dp.tipo_clase, dp.valor from detalle_precio_gaceta
                          dp left join precio_gaceta pg ON pg.id = dp.precio_gaceta_id where dp.id = #{@boleta_arrime.detalle_precio_gaceta_id}")
    end
    
    @arrime_conjunto_boleta_arrime_list = ArrimeConjunto.find(:all, :conditions=>["boleta_arrime_id = ?", params[:id]])
    @total_acondicionado = ArrimeConjunto.find_by_sql("select sum(peso_condicionado) as total_peso_acondicionado from arrime_conjunto where boleta_arrime_id = #{params[:id]}")
 
  end

  def delete
    @boleta_arrime = BoletaArrime.find(params[:id])
    errores = BoletaArrime.delete(@boleta_arrime.id)
    if errores == false
      render :update do |page|
        page.form_error
      end
      return
    else
      render :update do |page|
        page.form_delete @boleta_arrime, 'boleta_arrime'
      end
    end
  end

  def cancel_new
		form_cancel_new
  end
  
  def save_new_arrime_conjunto
    @persona = Persona.find(:first, :conditions=>"cedula = #{params[:arrime_conjunto][:cedula]} and cedula_nacionalidad = '#{params[:arrime_conjunto][:letra_cedula]}'")
    unless @persona.nil?
      @cliente = Cliente.find(:first, :conditions=>["persona_id = ?",@persona.id])
      unless @cliente.nil?
        @prestamo = Prestamo.count(:conditions=>"cliente_id = #{@cliente.id}")
        if @prestamo == 0
          params[:arrime_conjunto][:financiamiento_fondas] = false
        else
          params[:arrime_conjunto][:financiamiento_fondas] = true
        end
      else
        params[:arrime_conjunto][:financiamiento_fondas] = false
      end
    else
      params[:arrime_conjunto][:financiamiento_fondas] = false
    end
    errores = ArrimeConjunto.create_new(params[:arrime_conjunto], params[:boleta_arrime_id])
    if errores == true
      @boleta_arrime = BoletaArrime.find(params[:boleta_arrime_id])
      @arrime_conjunto_boleta_arrime_list = ArrimeConjunto.find(:all, :conditions=>["boleta_arrime_id = ?", params[:boleta_arrime_id]])
      @total_acondicionado = ArrimeConjunto.find_by_sql("select sum(peso_condicionado) as total_peso_acondicionado from arrime_conjunto where boleta_arrime_id = #{params[:boleta_arrime_id]}")
      render :update do |page|
        page.hide 'errorExplanation'
        page.replace_html 'arrime-conjunto', :partial => 'arrime_conjunto'
        page.replace_html 'message', I18n.t('Sistema.Body.Modelos.BoletaArrime.Messages.arrime_conjunto_se_guardo_con_exito')
        page.show 'arrime-conjunto'
        page.show 'message'
      end
    else
      render :update do |page|
        page.hide 'message'
        page.replace_html 'errorExplanation',"<h2> #{I18n.t('Sistema.Body.General.ocurrio_error')} </h2><p><UL>" << errores << '</UL></p>'
        page.show 'errorExplanation'
        page.<< "document.getElementById('agregar_arrime').style.display= '';"
      end
    end
  end

  def delete_arrime_conjunto
    ArrimeConjunto.delete(params[:id])
    @boleta_arrime = BoletaArrime.find(params[:boleta_arrime_id])
    @arrime_conjunto_boleta_arrime_list = ArrimeConjunto.find(:all, :conditions=>["boleta_arrime_id = ?", params[:boleta_arrime_id]])
    @total_acondicionado = ArrimeConjunto.find_by_sql("select sum(peso_condicionado) as total_peso_acondicionado from arrime_conjunto where boleta_arrime_id = #{params[:boleta_arrime_id]}")
    render :update do |page|
      page.hide 'errorExplanation'
      page.replace_html 'arrime-conjunto', :partial => 'arrime_conjunto'
      page.replace_html 'message', I18n.t('Sistema.Body.Modelos.BoletaArrime.Messages.se_elimino_con_exito')
      page.show 'arrime-conjunto'
      page.show 'message'
    end
  end
  
  def imprimir
    @form_title = ''
    @boleta_arrime = BoletaArrime.find(params[:id])
    @vista = FormatoBoleta.find_by_actividad_id(@boleta_arrime.actividad_id)
    @view_boleta_arrime = ViewBoletaArrime.find_by_solicitud_id(params[:solicitud_id])
    
    if (@boleta_arrime.detalle_convenio_silo_id.nil? || @boleta_arrime.detalle_convenio_silo_id.to_s.empty?)
      @view_precio2 =  DetallePrecioGaceta.find_by_sql("select dp.id, pg.id as precio_gaceta_id, pg.gaceta_oficial, pg.status, dp.actividad_id, dp.tipo_clase, dp.valor from detalle_precio_gaceta
                          dp left join precio_gaceta pg ON pg.id = dp.precio_gaceta_id where dp.id = #{@boleta_arrime.detalle_precio_gaceta_id}")
      @view_precio_gaceta = @view_precio2[0]
    else 
      @view_precio1 = ViewConvenioSilo.find_by_detalle_convenio_silo_id(@boleta_arrime.detalle_convenio_silo_id)
      @view_precio_gaceta = @view_precio1
    end
   
    @cuenta_bancaria = CuentaBancaria.find_by_cliente_id(@boleta_arrime.cliente_id)
    if @cuenta_bancaria.nil?
      @entidad_financiera = nil
    else
      @entidad_financiera = EntidadFinanciera.find_by_id(@cuenta_bancaria.entidad_financiera_id)
    end
   
  end

  def confirmar
    @boleta_arrime = BoletaArrime.find(params[:id])
    @view_boleta_arrime = ViewBoletaArrime.find_by_cliente_id(@boleta_arrime.cliente_id)
    parametros = @boleta_arrime
    cliente_ci = @view_boleta_arrime.cedula_rif
    errores = BoletaArrime.check(parametros, cliente_ci)
    if errores == true
      parametros = {"conjunto_verificado"=>"true"}
      id = @boleta_arrime.id
      errores_update = BoletaArrime.confirmacion(id, parametros)
      if errores_update == true
        flash[:notice] = I18n.t('Sistema.Body.Modelos.BoletaArrime.Messages.arrime_conjunto_se_guardo_con_exito')
        render :update do |page|
          new_options = {:action=>'index', :id=>params[:id],
            :solicitud_id=> @boleta_arrime.solicitud_id, :productor=>params[:productor], :nro_solicitud =>params[:nro_solicitud]}
          page.redirect_to new_options
        end
      else
        render :update do |page|
          page.hide 'message'
          page.replace_html 'errorExplanation',"<h2> #{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL>" << errores << '</UL></p>'
          page.show 'errorExplanation'
          page.<< "window.scrollTo(0,0);"
        end
      end
    else
      render :update do |page|
        page.hide 'message'
        page.replace_html 'errorExplanation',"<h2> #{I18n.t('Sistema.Body.General.ocurrio_error')} </h2><p><UL>" << errores << '</UL></p>'
        page.show 'errorExplanation'
        page.<< "window.scrollTo(0,0);"
      end
    end
  end

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.BoletaArrime.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.BoletaArrime.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.BoletaArrime.FormTitles.form_title_records')
    @form_entity = 'boleta_arrime'
    @form_identity_field = 'id'
    @width_layout = '1000'
  end

end

