# encoding: UTF-8

#
# autor: Luis Rojas
# clase: Solicitudes::PlanInversionController
# descripción: Migración a Rails 3
#
class Solicitudes::PlanInversionController < FormTabsController
  skip_before_filter :set_charset, :only=>[:actualiza_plan, :delete_maquinaria, :save_maquinaria, :clase_search, :confirmar, :delete_confirmado]
  
  layout 'solicitudes/plan_inversion'

  def edit

    @solicitud = Solicitud.find(params[:id])

    if @solicitud.sub_sector.nemonico == 'MA'
      @form_entity = 'plan_inventario'
      @contrato_maquinaria_equipo = ContratoMaquinariaEquipo.find(:all)
      @tipo_maquinaria            = TipoMaquinaria.find(:all, :conditions=>'activo=true', :order=>'nombre asc')
      @clase                      = Clase.all
      @marca_maquinaria_list      = MarcaMaquinaria.find(:all, :conditions=>'activo=true', :order=>'nombre asc')
      @modelo_list                = Modelo.find(:all, :conditions=>'activo=true', :order=>'nombre asc')
      @solicitud_maquinaria_list = SolicitudMaquinaria.find(:all, :conditions => ["estatus is null and solicitud_id = ?", @solicitud.id])
      @solicitud_maquinaria_confirmado = SolicitudMaquinaria.find(:all, :conditions => ["estatus in ('P', 'I') and solicitud_id = ?", @solicitud.id], :order => 'estatus')
      @solicitud_maquinaria = SolicitudMaquinaria.new
      #@width_layout = '1110'

    else
=begin

  Este método crea el plan de inversión si no existe y posteriormente lee este
  para poblar el grid y permitir las modificaciones pertinentes.

  Si existe simplemente llena el grid para permitir modificaciones.
=end

      #lectura del plan de inversión para verificar existencia


      plan_inversion = PlanInversion.find_by_solicitud_id(params[:id])

      if plan_inversion.nil?
        logger.info "Oficina =========> #{session[:oficina].inspect}"
        result = PlanInversion.nuevo_plan(params[:id], session[:oficina])
        if !result
          render :template => "solicitudes/plan_inversion/error"
          return
        end
      end

      if !params[:ed].nil?
        @ed = params[:ed].to_i
      else
        @ed = 0
      end

      @solicitud = Solicitud.find(params[:id])

      unless @solicitud.nil?

        condicion = " solicitud_id = #{@solicitud.id}"

        @plan_inversion = PlanInversion.find(:all,:conditions=>condicion,
          :order =>"estado_nombre,oficina_nombre,sector_nombre,sub_sector_nombre,rubro_nombre,sub_rubro_nombre,actividad_nombre,partida_nombre,item_nombre,tipo_item",
          :include=>[:unidad_medida])

        if @plan_inversion.nil? || @plan_inversion.empty?

          @mensaje1 = "#{I18n.t('Sistema.Body.Modelos.PlanInversion.Errores.problemas_registro')}: #{@solicitud.sector.nombre} y sub_sector: #{@solicitud.sub_sector.nombre}"
          render :template => "solicitudes/plan_inversion/error"
          return

        end

        logger.info "Plan Inversion ========> #{@plan_inversion.inspect}"
        @plan = @plan_inversion[0]

        #Buscando condiciones de financiamiento

        @condiciones = CondicionesFinanciamiento.find_by_programa_id_and_sector_id_and_sub_sector_id_and_rubro_id_and_sub_rubro_id_and_actividad_id(@solicitud.programa_id,
          @solicitud.sector_id,
          @solicitud.sub_sector_id,
          @solicitud.rubro_id,
          @solicitud.sub_rubro_id,
          @solicitud.actividad_id)

        if @condiciones.nil?

          #solicitud.erorrs_add_to_base(nil,"No existe estructura de costos para el rubro")
          @mensaje1 = "#{t('Sistema.Body.Modelos.PlanInversion.Errores.no_existe_condiciones_financiamiento')}: #{@solicitud.sector.nombre} #{t('Sistema.Body.Modelos.PlanInversion.Errores.sub_sector')}: #{@solicitud.sub_sector.nombre}"
          render :template => "solicitudes/plan_inversion/error"
          return

        end

        # Buscando tasa beneficiario

        # tasa = Tasa.find_by_tipo_cliente_id(@solicitud.cliente.tipo_cliente_id)

        # ----------------------------------------------------------------------
        # Ajuste para ubicar la tasa segun el subrubro y no por el tipo cliente
        # Efectuado por Alexander Cioffi 18-04-2012
        # ----------------------------------------------------------------------

        tasa = Tasa.find_by_sub_rubro_id(@solicitud.sub_rubro_id)

        if tasa.nil?

          #solicitud.erorrs_add_to_base(nil,"No existe estructura de costos para el rubro")
          @mensaje1 = "#{t('Sistema.Body.Modelos.PlanInversion.Errores.no_existe_tasa')}: #{@solicitud.rubro.nombre}"
          render :template => "solicitudes/plan_inversion/error"
          return

        end

        @tasa_valor = TasaValor.find_by_sql("Select * from tasa_valor where tasa_id = #{tasa.id} order by id desc LIMIT 1")
        @tasa_valor = @tasa_valor[0]

        #logger.info "SECTOR PRODUCTIVO =========>  " << @solicitud.sector.nombre

        if @solicitud.sub_sector.nemonico == 'VE'

          @caracterizacion = UnidadProduccionCaracterizacion.find_by_solicitud_id_and_unidad_produccion_id(@solicitud.id,@solicitud.unidad_produccion_id)

          if @caracterizacion.nil?

            #solicitud.erorrs_add_to_base(nil,"No existe estructura de costos para el rubro")
            @mensaje1 = "#{t('Sistema.Body.Modelos.PlanInversion.Errores.no_existe_caracterizacion')}: #{@solicitud.numero}"
            render :template => "solicitudes/plan_inversion/error"
            return

          end

          #logger.info "CARACTERIZACION =========> " << @caracterizacion.inspect

        end   #Fin if @solicitud.sub_sector.nemonico == 'VE'

      end     #Fin unless @solicitud.nil?

    end       #Fin if @solicitud.por_inventario == true

    #Calculo del Sras

    unless @solicitud.nil?

      monto = 0.00
      monto = monto.to_d
      @monto_prestamo = 0.00
      @monto_banco = 0.00
      @monto_insumo = 0.00
      @monto_total_gasto = 0.00
      @sras_primer_ano = 0.00
      @sras_anos_siguen = 0.00

      @monto_prestamo = @monto_prestamo.to_d
      @monto_banco = @monto_banco.to_d
      @monto_insumo = @monto_insumo.to_d
      @monto_total_gasto = @monto_total_gasto.to_d
      @sras_primer_ano = @sras_primer_ano.to_d
      @sras_anos_siguen = @sras_anos_siguen.to_d

      parametro = ParametroGeneral.find(1)
      logger.info "Parametro General =======> #{parametro.inspect}"
      factor_mensual_primer_ano = parametro.porcentaje_sras_primer_ano / 1200
      factor_mensual_anos_siguen = parametro.porcentaje_sras_anos_subsiguientes / 1200

      condiciones = CondicionesFinanciamiento.find_by_programa_id_and_sector_id_and_sub_sector_id_and_rubro_id_and_sub_rubro_id_and_actividad_id(@solicitud.programa_id,
          @solicitud.sector_id,
          @solicitud.sub_sector_id,
          @solicitud.rubro_id,
          @solicitud.sub_rubro_id,
          @solicitud.actividad_id)

      if condiciones.nil?
        @mensaje1 = "#{t('Sistema.Body.Modelos.PlanInversion.Errores.no_existe_condiciones_para actividad')}: #{@solicitud.actividad.nombre}"
        render :template => "solicitudes/plan_inversion/error"
        return
      end

      @monto_prestamo = PlanInversion.sum(:monto_financiamiento,:conditions=>"solicitud_id=#{@solicitud.id}")
      @monto_banco = PlanInversion.sum(:monto_financiamiento, :conditions=>"solicitud_id=#{@solicitud.id} and tipo_item = 'B'")
      @monto_insumo = PlanInversion.sum(:monto_financiamiento, :conditions=>"solicitud_id=#{@solicitud.id} and tipo_item = 'I'")

      logger.info "Monto Prestamo --> #{@monto_prestamo.class.to_s}"
      logger.info "Monto Banco --> #{@monto_banco.class.to_s}"
      logger.info "Monto insumo --> #{@monto_insumo.class.to_s}"

      if @monto_prestamo.nil?
        @monto_prestamo = 0.00
      end

      if @monto_banco.nil?
        @monto_banco = 0.00
      end

      if @monto_insumo.nil?
        @monto_insumo = 0.00
      end

      plazo_total = condiciones.plazo + condiciones.periodo_gracia

      if plazo_total <= 12
        @sras_primer_ano = (@monto_prestamo * factor_mensual_primer_ano) * 12
        @sras_anos_siguen = 0.00
      end

      if plazo_total > 12
        @sras_primer_ano = (@monto_prestamo * factor_mensual_primer_ano) * 12
        @sras_anos_siguen = (@monto_prestamo * factor_mensual_anos_siguen) * (plazo_total - 12)
      end

      @sras_total = @sras_primer_ano + @sras_anos_siguen

      #Calculo de los gastos

      @gastos = ProgramaTipoGasto.find_by_programa_id_and_tipo_gasto_id(@solicitud.programa_id, 1)
      logger.debug "GASTOS==============> "<<@gastos.inspect
      total_gasto = 0.00

      logger.info "@gastos_porcentaje =====> "
      unless (@gastos.nil?)
        if @gastos.porcentaje > 0
            monto = ((@monto_banco + @monto_insumo)*(@gastos.porcentaje/100))
        else
            monto = @gastos.monto_fijo
        end
        total_gasto = monto
        @monto_gasto_total = total_gasto
      end

      logger.info "Monto Gasto Total =========> #{@monto_gasto_total.to_s}"
      @total_financiamiento = @monto_prestamo + @sras_total + @monto_gasto_total
    end

  end

  def confirmar
    maquinaria = SolicitudMaquinaria.find(:all, :conditions => "estatus is null and solicitud_id = #{params[:solicitud_id]}")
    unless maquinaria.length > 0
      render :update do |page|
        page.alert(t('Sistema.Body.Modelos.PlanInversion.Errores.para_confirmar_plan_inversion'))
      end
    else
      result = SolicitudMaquinaria.confirmar(maquinaria)
      if result.length > 0
        render :update do |page|
          page.form_error
        end
        return
      else
        @solicitud_maquinaria_list = SolicitudMaquinaria.find(:all, :conditions => ["estatus is null and solicitud_id = ?", params[:solicitud_id]])
        @solicitud_maquinaria_confirmado = SolicitudMaquinaria.find(:all, :conditions => ["estatus in ('P', 'I') and solicitud_id = ?", params[:solicitud_id]], :order => 'estatus')
        render :update do |page|
          page.replace_html 'message', t('Sistema.Body.Modelos.PlanInversion.Mensajes.confirmacion_exitosa')
          page.replace_html 'list_confirmado', :partial => 'list_confirmado'
          page.replace_html 'list', :partial => 'list'
          page.show 'list'
          page.show 'list_confirmado'
          page.show 'message'
        end
      end
    end
  end
  
  def save_maquinaria
    @solicitud_maquinaria = SolicitudMaquinaria.new(params[:solicitud_maquinaria])
    @solicitud_maquinaria.solicitud_id = params[:solicitud_id]
    if @solicitud_maquinaria.save == true
      @solicitud_maquinaria_list = SolicitudMaquinaria.find(:all, :conditions => ["estatus is null and solicitud_id = ?", params[:solicitud_id]])
      render :update do |page|
        message = "#{I18n.t('Sistema.Body.Vistas.General.el')} #{I18n.t('Sistema.Body.Vistas.General.registro')} #{I18n.t('Sistema.Body.Controladores.Mensaje.insercion')}"
    		page.hide 'error'
        page.replace_html 'message', message
        page.replace_html 'list', :partial=>'list'
        page.show 'message'
        page.<< 'document.getElementById("solicitud_maquinaria_tipo_maquinaria_id").value = "";document.getElementById("solicitud_maquinaria_marca_maquinaria_id").value = "";document.getElementById("solicitud_maquinaria_modelo_id").value = "";document.getElementById("solicitud_maquinaria_clase_id").value = "";document.getElementById("solicitud_maquinaria_cantidad").value = "";'
		  end
    else
      render :update do |page|
        page.form_error
      end
    end
  end

  def delete_maquinaria
    solicitud_maquinaria = SolicitudMaquinaria.find(params[:id])
    if solicitud_maquinaria.class.name == "SolicitudMaquinaria"
      solicitud_maquinaria.destroy
    end
    @solicitud_maquinaria_list = SolicitudMaquinaria.find(:all, :conditions => ["estatus is null and solicitud_id = ?", params[:solicitud_id]])
    render :update do |page|
        message = t('Sistema.Body.Modelos.PlanInversion.Mensajes.item_eliminado')
    		page.hide 'error'
        page.replace_html 'message', message
        page.replace_html 'list', :partial=>'list'
        page.show 'message'
    end
  end
  
  def delete_confirmado
    solicitud_maquinaria = SolicitudMaquinaria.find(params[:id])
    if solicitud_maquinaria.estatus == 'I'
      solicitud_maquinaria.catalogo.solicitud_id = nil
      solicitud_maquinaria.catalogo.estatus = 'L'
      solicitud_maquinaria.catalogo.save
    else
      unless solicitud_maquinaria.proforma_id.nil? || solicitud_maquinaria.proforma_id.to_s.empty?
        proforma = Proforma.find(solicitud_maquinaria.proforma_id)
        render :update do |page|
          page.alert("#{I18n.t('Sistema.Body.Modelos.Errores.debe_eliminar_registro_proforma')} #{proforma.numero}")
        end
        return false
      end
    end
    solicitud_maquinaria.destroy
    @solicitud_maquinaria_confirmado = SolicitudMaquinaria.find(:all, :conditions => ["estatus in ('P', 'I') and solicitud_id = ?", params[:solicitud_id]])
    render :update do |page|
      message = "#{I18n.t('Sistema.Body.Vistas.General.el').capitalize} #{I18n.t('Sistema.Body.Vistas.General.registro')} #{I18n.t('Sistema.Body.Controladores.Mensaje.eliminacion')}"
        page.hide 'error'
        page.replace_html 'message', message
        page.replace_html 'list_confirmado', :partial => 'list_confirmado'
        page.show 'message'
        page.show 'list_confirmado'
    end
  end

  def actualiza_plan

=begin

  Método que actualiza el plan de inversión según parametros suministrados por el usuario
  y dependiendo el tipo de sector productivo (VEGETAL, ANIMAL, ACUICOLA)
=end


    #logger.debug "PARAMETROS =======> " << params.inspect

    @ed = 1
    logger.info "@ED ====================> " << @ed.to_s
    @plan_inversion = PlanInversion.find(:all, :conditions=>"solicitud_id = #{params[:id]}",:order =>"estado_nombre,oficina_nombre,sector_nombre,tipo_item")
    @plan = @plan_inversion[0]


    # Actualización del plan de inversión cuando el rubro es automático y el sector es vegetal

    solicitud = Solicitud.find(params[:id])

    if solicitud.actividad.paquetizado

      caracterizacion = UnidadProduccionCaracterizacion.find_by_solicitud_id_and_unidad_produccion_id(solicitud.id, solicitud.unidad_produccion_id)

      logger.info "Cantidad ===> #{params[:cantidad].to_f.to_s} Aprovechable ===> #{caracterizacion.superficie_aprovechable.to_f.to_s}"
      if params[:cantidad].to_f > caracterizacion.superficie_aprovechable.to_f

        caracterizacion.errors.add(:caracterizacion,"La cantidad de hectáreas es mayor que la superficie aprovechable recomendada\n")
        render :update do |page|
          page.<< "varEnviado=false "
          page.alert caracterizacion.errors.full_messages.to_s
          page.<< "window.scrollTo(0,0);"
        end
        return false
      end

      if params[:cantidad].to_f > 0

        if !@plan.actualizar_plan_vegetal(@plan.solicitud_id, params[:cantidad].to_f,session[:oficina])

          render :update do |page|
            page.alert @plan.errors.full_messages.to_s
          end
          return false

         else
          render :update do |page|
            page.alert "El plan de inversión del trámite número: #{solicitud.numero.to_s} se realizó con éxito."
            page.redirect_to  :action => 'edit', :id=>solicitud.id
          end
        end

      else

        render :update do |page|
          page.alert "La cantidad debe ser mayor que 0"
        end
        return false

      end

    else

      errores = @plan.actualizar_plan_general(@plan.solicitud_id, params,session[:oficina])

      if errores.class.to_s == 'String'
        if errores != ''
          mensaje = ""
          error = errores.split('|')
          error.each do |err|
            mensaje = mensaje + err.to_s + "\n"
          end
          render :update do |page|
            logger.debug "PASO POR ERRORES DE ACTUALIZACION ANIMAL"
            page.alert mensaje
          end
          return false
        end
      end

      if errores
        render :update do |page|
          page.alert "#{t('Sistema.Body.Modelos.PlanInversion.Mensajes.plan_inversion_tramite')}: #{solicitud.numero.to_s} #{t('Sistema.Body.Modelos.PlanInversion.Errores.realizado')}"
          page.redirect_to  :action => 'edit', :id=>solicitud.id
        end
      end

    end       # Fin if solicitud.actividad.paquetizado

  end

  def error

  end

  def list
    conditions=" estatus='L' "

    params['sort'] = "serial" unless params['sort']

    unless params[:catalogo][:contrato_maquinaria_equipo_id].nil? || params[:catalogo][:contrato_maquinaria_equipo_id].to_s.empty?
      contrato_maquinaria_equipo_id = params[:catalogo][:contrato_maquinaria_equipo_id].to_s
      contrato = ContratoMaquinariaEquipo.find(contrato_maquinaria_equipo_id)
      conditions = " #{conditions} AND contrato_maquinaria_equipo_id = " + contrato_maquinaria_equipo_id
      @form_search_expression << "Contrato es igual '#{contrato.nombre}'"
    end if !params[:catalogo].nil?


    unless params[:tipo_maquinaria][:id].nil? || params[:tipo_maquinaria][:id].to_s.empty?
      tipo_id = params[:tipo_maquinaria][:id].to_s
      tipomaquinaria = TipoMaquinaria.find(tipo_id)
      conditions = " #{conditions} AND clase.tipo_maquinaria_id = " + tipo_id
      @form_search_expression << "Tipo es igual '#{tipomaquinaria.nombre}'"
    end if !params[:tipo_maquinaria].nil?

    unless params[:catalogo][:clase_id].nil? || params[:catalogo][:clase_id].to_s.empty?
      clase_id = params[:catalogo][:clase_id].to_s
      clase = Clase.find(clase_id)
      conditions = " #{conditions} AND clase_id = " + clase_id
      @form_search_expression << "Clase es igual '#{clase.nombre}'"
    end if !params[:catalogo].nil?

    #@total = Catalogo.count(:conditions=>conditions,:joins => " INNER JOIN clase ON clase.id = catalogo.clase_id INNER JOIN tipo_maquinaria ON  tipo_maquinaria.id=clase.tipo_maquinaria_id")

    #@pages, @list = paginate(:catalogo, :class_name => 'Catalogo',
      #:joins => " INNER JOIN clase ON clase.id = catalogo.clase_id INNER JOIN tipo_maquinaria ON  tipo_maquinaria.id=clase.tipo_maquinaria_id ",
      #:conditions=>conditions,
      #:select=>'catalogo.*,clase.tipo_maquinaria_id',
      #:per_page => @records_by_page,
      #:order_by => @params['sort'])

    @list = Catalogo.search(conditions, params[:page], params['sort'])
    @total=@list.count

    form_list

  end

  def delete
    @catalogo_serial = Catalogo.find_by_id(params[:catalogo_id]).serial
    PlanInventario.actualizar_prestamo(params[:catalogo_id])
    @prestamo = Prestamo.find_by_solicitud_id(params[:solicitud_id])

    tipo_maquinaria=TipoMaquinaria.find(:all, :conditions=>'activo=true', :order=>'nombre asc')
    render :update do |page|
      tipo_maquinaria.each { |x|
        joins= " INNER JOIN clase ON clase.id=catalogo.clase_id and clase.tipo_maquinaria_id=#{x.id.to_s} "
        @catalogo = Catalogo.find(:all,:joins=>joins, :conditions=>["solicitud_id=#{params[:solicitud_id]}"] ,:include=>['contrato_maquinaria_equipo','clase'])
        @nombre_tipo_maquinaria=TipoMaquinaria.find_by_id(@catalogo[0].clase.tipo_maquinaria_id.to_i).nombre if !@catalogo[0].nil?
        page.replace_html 'list-inventario-' + x.id.to_s, :partial => 'list_inventario'
      }
      page.replace_html 'total-prestamo', :partial=>'total_prestamo'
      #      page.remove "row_#{params[:catalogo_id]}"
      page.replace_html 'message_inventario', t('Sistema.Body.Modelos.PlanInversion.Mensajes.item_eliminado')
      page.show 'message_inventario'
      page.hide 'message_catalogo'
    end
  end

  def asignar_catalogo
    if PlanInventario.validar(params[:solicitud_id]) == true
      @error = PlanInventario.validar_libres(params)
      @catalogo_serial_agregar = PlanInventario.asignar_catalogo_inventario(params,session)
      #####################
      #      @total = Catalogo.count(:conditions=>"estatus='L'")
      #      @pages, @list = paginate(:catalogo, :class_name => 'Catalogo',
      #       :conditions=>"estatus='L'",
      #       :per_page => @records_by_page,
      #       :order_by => @params['sort']
      #      )
      #####################
      @prestamo = Prestamo.find_by_solicitud_id(params[:solicitud_id])

      tipo_maquinaria=TipoMaquinaria.find(:all, :conditions=>'activo=true', :order=>'nombre asc')
      mensaje = ""
      if @catalogo_serial_agregar.length > 0
        mensaje = I18n.t('Sistema.Body.Modelos.General.se_agrego_item_tramite')
      end
      if @error.length > 0
        mensaje << "#{I18n.t('Sistema.Body.Modelos.Errores.no_se_pudo_agregar_item_serial')}: << <span style='color:red;'>#{@error.to_s}</span> >> ya que el estatus es <span style='color:red;'>Reservado</span>"
      end
      catalogo_id = params[:catalogo_id].to_s.split(",")
      render :update do |page|
        #page.replace_html 'list', :partial => 'list'
        tipo_maquinaria.each { |x|
          joins= " INNER JOIN clase ON clase.id=catalogo.clase_id and clase.tipo_maquinaria_id=#{x.id.to_s} "
          @catalogo = Catalogo.find(:all,:joins=>joins, :conditions=>["solicitud_id=#{params[:solicitud_id]}"] ,:include=>['contrato_maquinaria_equipo','clase'])
          @nombre_tipo_maquinaria=TipoMaquinaria.find_by_id(@catalogo[0].clase.tipo_maquinaria_id.to_i).nombre if !@catalogo[0].nil?
          page.replace_html 'list-inventario-' + x.id.to_s, :partial => 'list_inventario'
          page.replace_html 'total-prestamo', :partial=>'total_prestamo'
        }
        catalogo_id.each{ |e|
          page.remove "row_#{e}"
        }
        if mensaje.length > 0
          page.replace_html 'message_catalogo', mensaje
          page.show 'message_catalogo'
          page.hide 'message_inventario'
        end
      end
    else
      render :update do |page|
        page.alert I18n.t('Sistema.Body.Modelos.Errores.se_presentaron_siguientes_errores')
      end
    end
  end

  def list_catalogo
    @list_catalogo = Catalogo.find(:all, :conditions => "")
    
    @list_catalogo = paginate(:catalogo, :class_name => 'Catalogo',
      :joins => "INNER JOIN tipo_maquinaria ON tipo_maquinaria.id = clase.tipo_maquinaria_id",
      :include=>['contrato_maquinaria_equipo','clase'],
      #:per_page => @records_by_page,
      #:select=>'clase.*,catalogo.*,tipo_maquinaria.*',
      :order_by => @params['contrato_maquinaria_equipo.nombre'])
  end

  def list_catalogo_asignado
    @list_catalogo = paginate(:catalogo, :class_name => 'Catalogo',
      :joins => "INNER JOIN tipo_maquinaria ON tipo_maquinaria.id = clase.tipo_maquinaria_id",
      :include=>['contrato_maquinaria_equipo','clase'],
      #:per_page => @records_by_page,
      #:select=>'clase.*,catalogo.*,tipo_maquinaria.*',
      :order_by => @params['contrato_maquinaria_equipo.nombre']
    )
    render :update do |page|
      page.replace_html 'list-catalogo-asignado', :partial => 'list_catalogo_asignado'
    end
  end

  def clase_search
    if !params[:id].nil? && !params[:id].empty?
      @clase = Clase.find(:all, :conditions=>["tipo_maquinaria_id = ?", params[:id].to_s],:order=>"nombre",:select=>"id,nombre,activo")
      render :update do |page|
        page.replace_html 'clase-search', :partial => 'clase_search'
        page.show 'tr_clase_search'
      end
    else
      @clase = []
      render :update do |page|
        page.hide 'tr_clase_search'
      end
    end
  end

  private

  def actualiza_prestamo(solicitud)

=begin

   Método que genera el préstamo después de haber actualizado el plan de inversión

=end
    oficina = Oficina.find(session[:oficina])
    result = PlanInversion.actualiza_prestamo(solicitud,oficina)
          
    if result.class.to_s != 'String'
     
      if result
    
        if solicitud.actividad.paquetizado
          message = flash[:notice] = "#{I18n.t('Sistema.Body.Modelos.General.el_plan_inversion_tramite')}: #{solicitud.numero.to_s} #{I18n.t('Sistema.Body.Modelos.General.se_actualizo_exito')}"
          render :update do |page|
            page.redirect_to :action => "edit", :id => solicitud.id
          end
          return
          
        else
          flash[:notice] = "#{I18n.t('Sistema.Body.Modelos.General.el_plan_inversion_tramite')}: #{solicitud.numero.to_s} #{I18n.t('Sistema.Body.Modelos.General.se_actualizo_exito')}"
          render :update do |page|
            page.redirect_to :action => "edit", :id => solicitud.id, :ed=>1
          end
          return
        end

      else

        PlanInversion.find_by_sql("delete from plan_inversion where solicitud_id = #{solicitud.id}")
        flash[:notice] = "#{I18n.t('Sistema.Body.Modelos.General.el_plan_inversion_tramite')}: #{result.to_s} #{I18n.t('Sistema.Body.Vistas.General.favor_revisar')}"
        render :update do |page|
          page.redirect_to :action => "edit", :id => solicitud.id, :ed=>1
        end
      end
    else
      flash[:notice] = "#{I18n.t('Sistema.Body.Modelos.Errores.se_presentaron_siguientes_errores')}: #{result.to_s} "
      render :update do |page|
        page.redirect_to :action => "edit", :id => solicitud.id, :ed=>1
      end
      return
    end

  end
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.PlanInversion.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.PlanInversion.FormTitles.form_title')
    @form_title_records = I18n.t('Sistema.Body.Controladores.PlanInversion.FormTitles.form_title')
    @form_entity = 'plan_inversion'
    @form_identity_field = 'id'
    @width_layout = '1000'
  end
end