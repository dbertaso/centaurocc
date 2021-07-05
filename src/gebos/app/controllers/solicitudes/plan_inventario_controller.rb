# encoding: utf-8

#
# autor: Marvin Alfonzo
# clase: Solicitudes::PlanInventarioController
# descripción: Migración a Rails 3
#

class Solicitudes::PlanInventarioController < FormTabsController

skip_before_filter :set_charset, :only=>[:list_catalogo_asignado,:asignar_catalogo,:delete,:clase_search]

  layout 'solicitudes/plan_inversion'

  def edit

    @solicitud = Solicitud.find(params[:id])
    @form_entity = 'plan_inventario'
    @contrato_maquinaria_equipo = ContratoMaquinariaEquipo.find(:all)
    @tipo_maquinaria            = TipoMaquinaria.find(:all, :conditions=>'activo=true', :order=>'nombre asc')
    @clase                      = Clase.find(:all)
    @width_layout = '1110'

  end

  def list
    conditions=" estatus='L' "

    params['sort'] = "serial" unless params['sort']

    unless params[:catalogo][:contrato_maquinaria_equipo_id].nil? || params[:catalogo][:contrato_maquinaria_equipo_id].to_s.empty?
      contrato_maquinaria_equipo_id = params[:catalogo][:contrato_maquinaria_equipo_id].to_s
      #contrato = ContratoMaquinariaEquipo.find(contrato_maquinaria_equipo_id)
      conditions = " #{conditions} AND contrato_maquinaria_equipo_id = " + contrato_maquinaria_equipo_id
      #@form_search_expression << "Contrato es igual '#{contrato.nombre}'"
    end


    unless params[:tipo_maquinaria_otra][:id].nil? || params[:tipo_maquinaria_otra][:id].to_s.empty?
      tipo_id = params[:tipo_maquinaria_otra][:id].to_s
      #tipomaquinaria = TipoMaquinaria.find(tipo_id)
      conditions = " #{conditions} AND clase.tipo_maquinaria_id = " + tipo_id
      #@form_search_expression << "Tipo es igual '#{tipomaquinaria.nombre}'"
    end

    unless params[:catalogo][:clase_id].nil? || params[:catalogo][:clase_id].to_s.empty?
      clase_id = params[:catalogo][:clase_id].to_s
      #clase = Clase.find(clase_id)
      conditions = " #{conditions} AND clase_id = " + clase_id
      #@form_search_expression << "Clase es igual '#{clase.nombre}'"
    end
    
    unless params[:catalogo][:serial].nil? || params[:catalogo][:serial].to_s.empty?
      conditions = " #{conditions} AND (lower(serial) = lower('#{params[:catalogo][:serial]}') or chasis = lower('#{params[:catalogo][:serial]}'))"
      #@form_search_expression << "Serial Motor es igual '#{params[:catalogo][:serial]}' o Serial Chasis es igual '#{params[:catalogo][:serial]}"
    end

    
    @list = Catalogo.search_especial(conditions, params[:page], params[:sort]," INNER JOIN clase ON clase.id = catalogo.clase_id INNER JOIN tipo_maquinaria ON  tipo_maquinaria.id=clase.tipo_maquinaria_id ", 'catalogo.*,clase.tipo_maquinaria_id')
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
      page.replace_html 'message_inventario', I18n.t('Sistema.Body.Modelos.General.se_elimino_item')
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
#       :order_by => params['sort']
#      )
      #####################
      @prestamo = Prestamo.find_by_solicitud_id(params[:solicitud_id])

      tipo_maquinaria=TipoMaquinaria.find(:all, :conditions=>'activo=true', :order=>'nombre asc')
      mensaje = ""
      if @catalogo_serial_agregar.length > 0
        mensaje = "#{I18n.t('Sistema.Body.Modelos.General.se_agrego_item_tramite')}  <br/>"
      end
      if @error.length > 0
        mensaje << "#{I18n.t('Sistema.Body.Modelos.Errores.no_se_pudo_agregar_item_serial')}: << <span style='color:red;'>#{@error.to_s}</span> >> #{I18n.t('Sistema.Body.Modelos.Errores.ya_el_estatus_es')} <span style='color:red;'>#{I18n.t('Sistema.Body.Vistas.General.reservado')}</span>".html.safe
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
        page.alert I18n.t('Sistema.Body.Modelos.Errores.debe_configurar_condiciones_financiamiento') 
      end
    end
  end


  def list_catalogo
    
    @list_catalogo = Catalogo.search_especial_include(conditions, params[:page], params['contrato_maquinaria_equipo.nombre'],"INNER JOIN tipo_maquinaria ON tipo_maquinaria.id = clase.tipo_maquinaria_id", '')
    
=begin
    @list_catalogo = paginate(:catalogo, :class_name => 'Catalogo',
                           :joins => "INNER JOIN tipo_maquinaria ON tipo_maquinaria.id = clase.tipo_maquinaria_id",
                           :include=>['contrato_maquinaria_equipo','clase'],
                           #:per_page => @records_by_page,
                           #:select=>'clase.*,catalogo.*,tipo_maquinaria.*',
                           :order_by => params['contrato_maquinaria_equipo.nombre'])
=end                           
  end


  def list_catalogo_asignado
    
    @list_catalogo = Catalogo.search_especial_include(conditions, params[:page], params['contrato_maquinaria_equipo.nombre'],"INNER JOIN tipo_maquinaria ON tipo_maquinaria.id = clase.tipo_maquinaria_id", '')
    
=begin
    @list_catalogo = paginate(:catalogo, :class_name => 'Catalogo',
                             :joins => "INNER JOIN tipo_maquinaria ON tipo_maquinaria.id = clase.tipo_maquinaria_id",
                             :include=>['contrato_maquinaria_equipo','clase'],
                             #:per_page => @records_by_page,
                             #:select=>'clase.*,catalogo.*,tipo_maquinaria.*',
                             :order_by => params['contrato_maquinaria_equipo.nombre'])
=end                             
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
      render :update do |page|
        page.hide 'tr_clase_search'
      end
    end
  end

  private

  def actualiza_prestamo(solicitud)
    sras_primer_ano = 0.00
    sras_anos_siguen = 0.00
    sras_total = 0.00

    begin

      @solicitud = solicitud
      prestamo = Prestamo.find_by_solicitud_id(solicitud.id)
      @plan_inversion = PlanInversion.find_by_solicitud_id(solicitud.id)

      #Buscando condiciones de financiamiento

      @condiciones = CondicionesFinanciamiento.find_by_sector_id_and_sub_sector_id_and_rubro_id(solicitud.sector_id,
                                                                                                solicitud.sub_sector_id,
                                                                                                solicitud.rubro_id)
      #Buscando tasa beneficiario

      tasa = Tasa.find_by_tipo_cliente_id(solicitud.cliente.tipo_cliente_id)
      @tasa_valor = TasaValor.find_by_tasa_id(tasa.id)
      monto_prestamo = PlanInversion.sum(:monto_financiamiento,:conditions=>"solicitud_id=#{solicitud.id}")
      @plan_inversion = PlanInversion.find(:all, :conditions=>"solicitud_id = #{solicitud.id}",:order =>"estado_nombre,oficina_nombre,sector_nombre,tipo_item")

      solicitud.monto_solicitado = monto_prestamo.to_f

      solicitud.hectareas_recomendadas = 0.00
      solicitud.semovientes_recomendados = 0.00

      if solicitud.rubro.paquetizado

        solicitud.hectareas_recomendadas = @plan_inversion[0].cantidad
        solicitud.semovientes_recomendados = 0.00
      else
        solicitud.hectareas_recomendadas = PlanInversion.sum(:cantidad, :conditions=>"solicitud_id = #{solicitud.id}")
        solicitud.semovientes_recomendados = 0.00
      end

      solicitud.semovientes_recomendados = 0.00

      solicitud.semovientes_recomendados = PlanInversion.sum(:cantidad, :conditions=>"(partida_nombre like \'\%SEMOVIENTES\%\' or partida_nombre like \'\%TORO REPRODUCTOR\%\') and solicitud_id = #{solicitud.id.to_s}")
      if solicitud.semovientes_recomendados.nil?
        solicitud.semovientes_recomendados = 0.00
      end

      solicitud.save

      monto_prestamo = PlanInversion.sum(:monto_financiamiento,:conditions=>"solicitud_id=#{solicitud.id}")
      monto_banco = PlanInversion.sum(:monto_financiamiento, :conditions=>"solicitud_id=#{solicitud.id} and tipo_item = 'B'")
      monto_insumo = PlanInversion.sum(:monto_financiamiento, :conditions=>"solicitud_id=#{solicitud.id} and tipo_item = 'I'")

      if prestamo.nil?

        @producto = Producto.find_by_programa_id_and_sector_id_and_sub_sector_id(solicitud.programa_id, solicitud.sector_id, solicitud.sub_sector_id)

        @prestamo = Prestamo.new(:solicitud=>solicitud, :producto=>@producto, :oficina=>session[:oficina], :destinatario=>"E")

        @prestamo.monto_solicitado = monto_prestamo.to_f

        #logger.info "PRESTAMO ====> " << @prestamo.inspect

        # ------------------------------------
        # Calculo del sras
        # ------------------------------------

        parametro = ParametroGeneral.find(1)
        factor_mensual_primer_ano = parametro.porcentaje_sras_primer_ano / 1200
        factor_mensual_anos_siguen = parametro.porcentaje_sras_anos_subsiguientes / 1200

        if @prestamo.plazo <= 12
          sras_primer_ano = (@prestamo.monto_solicitado * factor_mensual_primer_ano) * 12
          sras_anos_siguen = 0.00
        end

        if @prestamo.plazo > 12
          sras_primer_ano = (@prestamo.monto_solicitado * factor_mensual_primer_ano) * 12
          sras_anos_siguen = (@prestamo.monto_solicitado * factor_mensual_anos_siguen) * (@prestamo.plazo - 12)
        end

        sras_total = sras_primer_ano + sras_anos_siguen

        @prestamo.monto_sras_primer_ano = sras_primer_ano
        @prestamo.monto_sras_anos_subsiguientes = sras_anos_siguen
        @prestamo.monto_sras_total = sras_total
        @prestamo.monto_banco = monto_banco.to_f
        @prestamo.monto_insumos = monto_insumo.to_f

        if @prestamo.save

          if solicitud.rubro.paquetizado
             message = flash[:notice] = "#{I18n.t('Sistema.Body.Modelos.General.el_plan_inversion_tramite')}: #{solicitud.numero.to_s} #{I18n.t('Sistema.Body.Modelos.General.se_actualizo_exito')}"
             render :update do |page|
#              page.replace_html 'message', message
#              page.show 'message'
#              page.replace_html 'plan-inversion', :partial => 'plan_inversion_vegetal'
#              page.<< "window.scrollTo(0,0);"
               page.redirect_to :action => "edit", :id => solicitud.id
            end
            return
          else
             flash[:notice] = "#{I18n.t('Sistema.Body.Modelos.General.el_plan_inversion_tramite')}: #{solicitud.numero.to_s} #{I18n.t('Sistema.Body.Modelos.General.se_actualizo_exito')}"
             render :update do |page|
              #page.show 'message'
              #page.hide 'plan-inversion-animal-inicial'
              #page.show 'plan-inversion-animal-actualizado'
              #page.replace_html 'plan-inversion-animal-actualizado', :partial => 'plan_inversion_animal_view'
              #page.<< "window.scrollTo(0,0);"
              page.redirect_to :action => "edit", :id => solicitud.id, :ed=>1
            end
            return
          end

        else

          render :update do |page|
            page.form_error
            page.<< "window.scrollTo(0,0);"
          end

        end

      else

        #logger.info "PRESTAMO ====> " << @prestamo.inspect

        # ------------------------------------
        # Calculo del sras
        # ------------------------------------

        parametro = ParametroGeneral.find(1)
        factor_mensual_primer_ano = parametro.porcentaje_sras_primer_ano / 1200
        factor_mensual_anos_siguen = parametro.porcentaje_sras_anos_subsiguientes / 1200

        monto_prestamo = PlanInversion.sum(:monto_financiamiento,:conditions=>"solicitud_id=#{solicitud.id}")
        monto_banco = PlanInversion.sum(:monto_financiamiento, :conditions=>"solicitud_id=#{solicitud.id} and tipo_item = 'B'")
        monto_insumo = PlanInversion.sum(:monto_financiamiento, :conditions=>"solicitud_id=#{solicitud.id} and tipo_item = 'I'")

        if prestamo.plazo <= 12
          sras_primer_ano = (monto_prestamo.to_f * factor_mensual_primer_ano) * 12
          sras_anos_siguen = 0.00
        end

        if prestamo.plazo > 12
          sras_primer_ano = (monto_prestamo.to_f * factor_mensual_primer_ano) * 12
          sras_anos_siguen = (monto_prestamo.to_f * factor_mensual_anos_siguen) * (prestamo.plazo - 12)
        end

        sras_total = sras_primer_ano + sras_anos_siguen

        prestamo.monto_sras_primer_ano = sras_primer_ano
        prestamo.monto_sras_anos_subsiguientes = sras_anos_siguen
        prestamo.monto_sras_total = sras_total
        prestamo.monto_banco = monto_banco.to_f
        prestamo.monto_insumos = monto_insumo.to_f
        prestamo.monto_solicitado = monto_prestamo.to_f

        if prestamo.save

          if solicitud.rubro.paquetizado
             flash[:notice] = "#{I18n.t('Sistema.Body.Modelos.General.el_plan_inversion_tramite')}: #{solicitud.numero.to_s} #{I18n.t('Sistema.Body.Modelos.General.se_actualizo_exito')}"
             render :update do |page|
              #page.show 'message'
              #page.hide 'plan-inversion-animal-inicial'
              #page.show 'plan-inversion-animal-actualizado'
              #page.replace_html 'plan-inversion-animal-actualizado', :partial => 'plan_inversion_animal_view'
              #page.<< "window.scrollTo(0,0);"
              page.redirect_to :action => "edit", :id => solicitud.id
            end
            return
          else
             flash[:notice] = "#{I18n.t('Sistema.Body.Modelos.General.el_plan_inversion_tramite')}: #{solicitud.numero.to_s} #{I18n.t('Sistema.Body.Modelos.General.se_actualizo_exito')}"
             render :update do |page|
              #page.show 'message'
              #page.hide 'plan-inversion-animal-inicial'
              #page.show 'plan-inversion-animal-actualizado'
              #page.replace_html 'plan-inversion-animal-actualizado', :partial => 'plan_inversion_animal_view'
              #page.<< "window.scrollTo(0,0);"
              page.redirect_to :action => "edit", :id => solicitud.id
            end
            return
          end

        else

          render :update do |page|
            page.alert(prestamo.errors.full_messages)
          end
          return

        end

      end

  return true

  rescue =>detail

    render :update do |page|
      page.alert(detail.message + detail.backtrace.to_s)
    end
    return


    end

  end
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Vistas.General.plan_inversion') #'Plan de Inversión'
    @form_title_record = I18n.t('Sistema.Body.Vistas.General.plan_inversion') #'Plan de Inversión'
    @form_title_records = I18n.t('Sistema.Body.Vistas.General.plan_inversion') #'Plan de Inversión'
    @form_entity = 'plan_inversion'
    @form_identity_field = 'id'
    @width_layout = '900'
  end

end
