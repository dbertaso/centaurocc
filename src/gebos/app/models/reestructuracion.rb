# encoding: utf-8

class Reestructuracion < ActiveRecord::Base

  self.table_name = 'reestructuracion'

  attr_accessible :id,
                  :fecha_impresion_formato_solicitud,
                  :estatus,
                  :solicitud_id,
                  :cliente_id,
                  :fecha_aprobacion_comite,
                  :fecha_envio_comite,
                  :referencia_abono,
                  :monto_abono,
                  :fecha_abono,
                  :interes_diferido,
                  :interes_ordinarios,
                  :interes_moratorio,
                  :interes_causado_no_devengado,
                  :exonerado_interes_diferido,
                  :exonerado_interes_ordinarios,
                  :exonerado_interes_moratorio,
                  :exonerado_interes_causado_no_devengado,
                  :deuda,
                  :monto_reestructurado,
                  :formula_id,
                  :frecuencia,
                  :plazo,
                  :tasa,
                  :programa_id,
                  :origen_fondo_id,
                  :unidad_produccion_id,
                  :modalidad_financiamiento_id,
                  :objetivo_proyecto,
                  :empresa_integrante_id,
                  :sector_id,
                  :sub_sector_id,
                  :rubro_id,
                  :sub_rubro_id,
                  :actividad_id,
                  :saldo_insoluto,
                  :fecha_impresion_propuesta,
                  :fecha_impresion_contrato,
                  :fecha_generacion_table,
                  :hectareas_solicitadas,
                  :semovientes_solicitados,
                  :por_inventario,
                  :fecha_valor,
                  :viable,
                  :entidad_financiera_id,
                  :tipo,
                  :numero_cuenta,
                  :fecha_valor_f,
                  :viable_f,
                  :frecuencia_w

  belongs_to :cliente
  belongs_to :formula
  #belongs_to :solicitud
  belongs_to :programa
  belongs_to :origen_fondo
  belongs_to :modalidad_financiamiento
  belongs_to :sector
  belongs_to :sub_sector
  belongs_to :rubro
  belongs_to :sub_rubro
  belongs_to :actividad
  belongs_to :unidad_produccion
  belongs_to :entidad_financiera

  has_many :reestructuracion_detalle, :class_name=>'ReestructuracionDetalle'

  #set_table_name :solicitud

  def fecha_valor_f=(fecha)
    self.fecha_valor = fecha
  end

  def fecha_valor_f
    format_fecha(self.fecha_valor)
  end

  def reestructurar(cliente)
    logger.debug "respuesta de busqueda 1"
    prestamos = Prestamo.find(:all, :conditions=>[" estatus = 'E' and cliente_id = ?",cliente.id])
    logger.debug "respuesta de busqueda 2"
    #eliminar reestructuracion anterior
    reestructuracion = Reestructuracion.find(:first, :conditions=>["cliente_id = ? and estatus = 1",cliente.id])
    logger.debug "respuesta de busqueda " << reestructuracion.inspect << "-"
    if reestructuracion == nil

      reestructuracion = Reestructuracion.new(
        :fecha_impresion_formato_solicitud =>Time.now,
        :estatus=>1,
        #:solicitud_id=>user.id,
        :cliente_id=>cliente.id)
      successDes = reestructuracion.save

      prestamos.each do |prestamo|
        reestructuracion_detalle = ReestructuracionDetalle.new()
        reestructuracion_detalle.reestructuracion_id = reestructuracion.id
        #reestructuracion_detalle.solicitud_nueva_id integer,
        reestructuracion_detalle.solicitud_origen_id = prestamo.solicitud_id
        reestructuracion_detalle.save
      end

    end

    return prestamos
  end

  def enviar_comite(reestructuracion)
    retorno = true

    return retorno
  end


  def validar_reestructuración(params)
    logger.info"XXXXXXXXXXXXX-PARAMS-xxxxxxxxxxxxxxxx"<<params.inspect

    success = true
    if params[:check_abono] == "true"
      unless params[:reestructuracion][:monto_abono].length > 0 and params[:reestructuracion][:referencia_abono].length > 0 and params[:reestructuracion][:fecha_abono].length > 0
        errors.add(:reestructuracion, I18n.t('Sistema.Body.Vistas.Reestructuracion.Errores.completar_datos_abono'))
      end
    end
    unless params[:reestructuracion][:formula_id].length > 0
      errors.add(:reestructuracion, "#{I18n.t('Sistema.Body.Vistas.Reestructuracion.Etiquetas.metodo_amortizacion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
    end
    unless params[:reestructuracion][:frecuencia].length > 0
      errors.add(:reestructuracion, "#{I18n.t('Sistema.Body.Vistas.Reestructuracion.Etiquetas.frecuencia')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
    end
    unless params[:reestructuracion][:plazo].length > 0
      errors.add(:reestructuracion, "#{I18n.t('Sistema.Body.Vistas.Reestructuracion.Etiquetas.plazo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
    end
    unless params[:reestructuracion][:tasa].length > 0
      errors.add(:reestructuracion, "#{I18n.t('Sistema.Body.Vistas.Reestructuracion.Etiquetas.tasa')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
    end
    unless params[:reestructuracion][:entidad_financiera_id].length > 0
      errors.add(:reestructuracion, "#{I18n.t('Sistema.Body.Vistas.Reestructuracion.Etiquetas.entidad_financiera')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
    end
    # unless params[:reestructuracion][:tipo].length > 0
    #   errors.add(:reestructuracion, "#{I18n.t('Sistema.Body.Vistas.Reestructuracion.Etiquetas.tipo_cuenta')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
    # end
    unless params[:reestructuracion][:numero_cuenta].length > 0
      errors.add(:reestructuracion, "#{I18n.t('Sistema.Body.Vistas.Reestructuracion.Etiquetas.numero_cuenta')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
    end
    unless params[:solicitud][:programa_id].length > 0
      errors.add(:reestructuracion, "#{I18n.t('Sistema.Body.Vistas.General.programa')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
    end
    unless params[:solicitud][:origen_fondo_id].length > 0
      errors.add(:reestructuracion,"#{I18n.t('Sistema.Body.Vistas.Reestructuracion.Etiquetas.origen_fondo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
    end
    unless params[:solicitud][:unidad_produccion_id].length > 0
      errors.add(:reestructuracion, "#{I18n.t('Sistema.Body.Vistas.General.unidad_produccion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
    end
    unless params[:solicitud][:modalidad_financiamiento_id].length > 0
      errors.add(:reestructuracion, "#{I18n.t('Sistema.Body.Vistas.Reestructuracion.Etiquetas.modalidad_financiamiento')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
    end
    unless params[:solicitud][:objetivo_proyecto].length > 0
      errors.add(:reestructuracion, "#{I18n.t('Sistema.Body.Vistas.General.objetivo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
    end
    unless params[:solicitud][:sector_id].length > 0
      errors.add(:reestructuracion, "#{I18n.t('Sistema.Body.Vistas.General.sector')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
    end
    unless params[:sub_sector_id].length > 0
      errors.add(:reestructuracion, "#{I18n.t('Sistema.Body.Vistas.General.sub_sector')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
    end
    unless params[:rubro_id].length > 0
      errors.add(:reestructuracion, "#{I18n.t('Sistema.Body.Vistas.General.rubro')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
    end
    unless params[:sub_rubro_id].length > 0
      errors.add(:reestructuracion, "#{I18n.t('Sistema.Body.Vistas.General.sub_rubro')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
    end
    unless params[:solicitud][:actividad_id].length > 0
      errors.add(:reestructuracion, "#{I18n.t('Sistema.Body.Vistas.General.actividad')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
    end
    unless params[:cliente][:viable].length > 0
      errors.add(:reestructuracion, "#{I18n.t('Sistema.Body.Vistas.Reestructuracion.Etiquetas.viabilidad_beneficiario')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
    end

    # unless params[:reestructuracion][:numero_cuenta].length < 0

    #   unless params[:reestructuracion][:numero_cuenta].length == 20
    #     errors.add(:reestructuracion, "#{I18n.t('Sistema.Body.Vistas.Reestructuracion.Etiquetas.digitos_numero_cuenta')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
    #   end
    # end

    fecha1 = params[:reestructuracion][:fecha_valor_f].split("/")
    fecha2 = Date.new(fecha1[2].to_i, fecha1[1].to_i, fecha1[0].to_i)

    fecha_val = format_fecha_inv(fecha2)

    if fecha_val > Time.now.strftime(I18n.t('time.formats.gebos_inverted'))
      errors.add(:Reestructuracion, I18n.t('Sistema.Body.Vistas.Reestructuracion.Etiquetas.digitos_numero_cuenta'))
    end

    if errors.size.to_i > 0
     success = false
    end
   return success
  end


  def generar_financiamiento(reestructuracion, oficina, usuario_id)
      retorno = true
      #logger.debug "USARIO >>>>>>>>>>>>>>>>>>>>>> "<< usuario_id.inspect
      @usuario = Usuario.find(usuario_id)

      begin
        transaction do
          prestamo_aux = Prestamo.find(:first, :conditions=>"solicitud_id = #{reestructuracion.reestructuracion_detalle[0].solicitud_origen_id}")
          iniciar_transaccion(prestamo_aux.id, 'p_reestructuracion', 'L', "#{I18n.t('Sistema.Body.Vistas.Reestructuracion.Etiquetas.cancelar_prestamos_reestructurados')}", usuario_id, 0)


          @solicitud = Solicitud.new(
            :cliente_id => reestructuracion.cliente_id,
            :programa_id => reestructuracion.programa_id,
            #:programa_id => nil,
            :fecha_solicitud => Time.now,
            :fecha_registro => Time.now,
            :monto_solicitado => reestructuracion.monto_reestructurado,           #ACTUALIZAR
            :monto_aprobado => reestructuracion.monto_reestructurado,            #ACTUALIZAR
            :objetivo_proyecto => reestructuracion.objetivo_proyecto,
            :justificacion => "#{I18n.t('Sistema.Body.Vistas.Reestructuracion.Etiquetas.creado_a_partir_reestructuracion')}",
            :estatus => 'T',
            :intermediado => false,
            :modalidad_financiamiento_id => reestructuracion.modalidad_financiamiento_id,
            :origen_fondo_id => reestructuracion.origen_fondo_id,
            :monto_cliente => 0,
            :liberada => false,
            :estatus_comite => 'N',
            :estatus_modificacion => 'N',
            :estatus_comite_temporal => 'N',
            :migrado_d3 => false,
            :codigo_presupuesto_d3 => '00',
            :descripcion_presupuesto_d3 => '-',
            :tipo_comite => 'D',
            :tir => 0,
            :van => 0,
            :tiempo_recuperacion => 0,
            :estatus_id => 10110,
            :fecha_actual_estatus => Time.now,
            :banco_origen => OrigenFondo.find(reestructuracion.origen_fondo_id).nombre,
            :transcriptor => @usuario.nombre_usuario,                #ACTUALIZAR
            :fecha_aprobacion => Time.now,
            :fecha_liquidacion => Time.now,
            :observacion => "#{I18n.t('Sistema.Body.Vistas.Reestructuracion.Etiquetas.creado_a_partir_reestructuracion')}",
            :numero_grupo => 0,
            :numero_empresa => 0,                      #PERO NO ESTOY SEGURO QUE SIGNIFICA,
            :control => false,
            :estatus_desembolso_id => 1,
            :certificado_presupuesto => false,
            :monto_analista => 0,
            :consultoria => true,                      #NO SE QUE ES
            :decision_final => false,
            :confirmacion => true,
            :avaluo_obra_civil => false,
            :oficina_id => oficina.id.to_i,
            :unidad_produccion_id => reestructuracion.unidad_produccion_id,
            :sector_id => reestructuracion.sector_id,
            :sub_sector_id =>reestructuracion.sub_sector_id,
            :rubro_id => reestructuracion.rubro_id,
            :sub_rubro_id => reestructuracion.sub_rubro_id,
            :actividad_id => reestructuracion.actividad_id,
            :decision_comite_estadal => 'A',
            :decision_comite_nacional => 'A',
            :comite_estadal_id => nil,
            :comentario_comite_estadal => "#{I18n.t('Sistema.Body.Vistas.Reestructuracion.Etiquetas.creado_a_partir_reestructuracion')}",
            :comentario_comite_nacional => "#{I18n.t('Sistema.Body.Vistas.Reestructuracion.Etiquetas.creado_a_partir_reestructuracion')}",
            :hectareas_recomendadas => reestructuracion.hectareas_solicitadas,
            :semovientes_recomendados => 0,
            :enviado_suscripcion => false,
            :hectareas_solicitadas => reestructuracion.hectareas_solicitadas,               #REVISAR,
            :semovientes_solicitados => reestructuracion.semovientes_solicitados,             #REVISAR ,
            :por_inventario => reestructuracion.por_inventario)

          if reestructuracion.hectareas_solicitadas == nil
             @solicitud.hectareas_solicitadas = 0
             @solicitud.hectareas_recomendadas = 0
          end

          if reestructuracion.cliente.class.to_s =='ClienteEmpresa'
            @solicitud.empresa_integrante_id = reestructuracion.empresa_integrante_id
          end

          parametro = ParametroGeneral.find(:first)

          if parametro.numero_solicitud_inicial_uea.nil?
              parametro.numero_solicitud_inicial_uea = 50000000
          end

          ultima_solicitud = parametro.numero_solicitud_inicial_uea + 1
          parametro.numero_solicitud_inicial_uea = ultima_solicitud
          parametro.save!

          @solicitud.numero = ultima_solicitud

          successNuevaSol =  @solicitud.save
          if successNuevaSol == false
            errors.add(:Reestructuracion, I18n.t('Sistema.Body.Vistas.Reestructuracion.Etiquetas.creado_a_partir_reestructuracion'))
            #return false
          end


          programa = Programa.find(reestructuracion.programa_id)
          producto = Producto.find_by_programa_id_and_sector_id_and_sub_sector_id(@solicitud.programa_id, @solicitud.sector_id, @solicitud.sub_sector_id)
          if producto.nil?
              errors.add(:Reestructuracion, I18n.t('Sistema.Body.Vistas.Reestructuracion.Etiquetas.no_hay_producto_registrado'))
          end
          @prestamo = Prestamo.new(
            :monto_solicitado => reestructuracion.monto_reestructurado,           #ACTUALIZAR
            :monto_aprobado => reestructuracion.monto_reestructurado,
            :fecha_aprobacion => Time.now,
            :formula_id =>  reestructuracion.formula_id,
            :tasa_fija => true,
            :tasa_referencia_inicial => 0,
            :plazo => reestructuracion.plazo,
            :meses_fijos_sin_cambio_tasa => 0,
            :meses_gracia_si => false,
            :meses_gracia => 0,
            :meses_muertos_si => false,
            :meses_muertos => 0,
            :cliente_id => @solicitud.cliente_id,
            :tipo_credito_id => programa.tipo_credito_id,           #bien? - lo buesco en programa
            :oficina_id => @solicitud.oficina_id,
            :solicitud_id => @solicitud.id,
            :estatus => 'V',
            :tasa_mora_id => 1,                                    #bien? - el programa la tiene como 0
            :forma_calculo_intereses => 'V',                       #bien? - al vencimiento
            :exonerar_intereses_mora => true,         #financiamiento reestructurado reestructuracion
            :base_cobro_mora => 'C',                  #character(1), -- C => Capital de la Cuota. V => Valor de la Cuota (capital + intereses)
            :diferir_intereses => false,              #no estoy seguro para que es y como se comporta por no cobrar intereses
            :exonerar_intereses_diferidos => true,    #financiamiento reestructurado reestructuracion
            :frecuencia_pago => reestructuracion.frecuencia,
            :tasa_valor => reestructuracion.tasa,
            :exonerar_intereses => true,              #financiamiento reestructurado reestructuracion
            :tasa_inicial => reestructuracion.tasa,
            :tasa_vigente => reestructuracion.tasa,
            :saldo_insoluto =>  reestructuracion.monto_reestructurado,
            :porcentaje_riesgo_foncrei =>  programa.porcentaje_riesgo_foncrei,                  #no debe aplicar pero lo busque en el programa
            :porcentaje_riesgo_intermediario => programa.porcentaje_riesgo_intermediario,       #no debe aplicar pero lo busque en el programa
            :porcentaje_tasa_foncrei => programa.porcentaje_tasa_foncrei,                       #no debe aplicar pero lo busque en el programa
            :porcentaje_tasa_intermediario => programa.porcentaje_tasa_intermediario,           #no debe aplicar pero lo busque en el programa
            :frecuencia_pago_intermediario =>  programa.frecuencia_pago_intermediario,          #no debe aplicar pero lo busque en el programa
            :intermediado => programa.intermediado,
            :tasa_cero => true,               #REVISAR
            :monto_liquidado => reestructuracion.monto_reestructurado,
            :fecha_liquidacion => reestructuracion.fecha_valor.strftime(I18n.t('time.formats.gebos_inverted2')),
            :reestructurado => 'N',              #character(1) DEFAULT 'N'::bpchar, -- N => No aplica, F => Reestructuracón Financiera, A => Reestructuración Administrativa
            ###prestamo_origen_id integer, -- Cuando el prestamo proviene de un prestamo que fue cancelado por reestructuración aqui se almacena la referencia del préstamo que fue cancelado
            ###prestamo_destino_id integer, -- Si este prestamo fue cancelado por reestructuración aqui se almaceca la referencia del préstamo que se originó a partir de este
            :ultimo_desembolso => 0,          #NO APLICA por defecto ponía 9
            :banco_origen => @solicitud.banco_origen,
            ###tipo_cartera_id integer DEFAULT 1,
            :porcentaje_diferimiento => 100,                         #revisar
            :monto_banco => 0,
            :monto_insumos => 0,
            :rubro_id => @solicitud.rubro_id,
            :producto_id => producto.id,
            :monto_sras_primer_ano => 0,
            :monto_sras_anos_subsiguientes => 0,
            :monto_sras_total => 0,
            :sub_rubro_id => @solicitud.sub_rubro_id,
            :actividad_id => @solicitud.actividad_id,
            :monto_gasto_total=>0.00)
            ########:monto_inventario => reestructuracion.monto_reestructurado,  SI ES MAQUINARIA


            successNuevoPrestamo =  @prestamo.save
            if successNuevoPrestamo == false
              errors.add(:Reestructuracion, I18n.t('Sistema.Body.Vistas.Reestructuracion.Etiquetas.no_es_posible_crear_nuevo_financiamiento'))
            end

            cliente = Cliente.find(@solicitud.cliente_id)
            cliente.moroso = false
            cliente.reestructurado = true
            if reestructuracion.viable
              cliente.viable = true
              cliente.moroso = false
              cliente.reestructurado = true
            else
              cliente.viable = false
            end

            cliente.save
            if cliente.errors.length > 0
              errors.add(:Reestructuracion, "#{I18n.t('Sistema.Body.Vistas.Reestructuracion.Etiquetas.no_es_posible_actualizar_cliente')} #{cliente.errors.full_message.to_s}")
            end

            tasa_valor = TasaValor.find(:first, :conditions=>"valor = #{reestructuracion.tasa}")
             @prestamo.tasa_id = tasa_valor.id.to_i
             @prestamo.tasa_cero = true
             @prestamo.tasa_inicial = reestructuracion.tasa
             @prestamo.tasa_vigente = reestructuracion.tasa
             @prestamo.tasa_valor = reestructuracion.tasa
             @prestamo.tasa_fija = true,
             @prestamo.tasa_referencia_inicial = reestructuracion.tasa,
             @prestamo.meses_fijos_sin_cambio_tasa = 0
             @prestamo.tasa_mora_id = tasa_valor.tasa_id
             @prestamo.meses_gracia_si = false,
             @prestamo.meses_gracia = 0,
             @prestamo.meses_muertos_si = false,
             @prestamo.meses_muertos = 0,
             @prestamo.plazo = reestructuracion.plazo
             @prestamo.meses_gracia = 0
             @prestamo.formula_id = reestructuracion.formula_id
             @prestamo.frecuencia_pago = reestructuracion.frecuencia
             @prestamo.save
             successNuevoPrestamo_act =  @prestamo.save
             if successNuevoPrestamo_act == false
               errors.add(:Reestructuracion, I18n.t('Sistema.Body.Vistas.Reestructuracion.Etiquetas.no_es_posible_actualizar_datos_referente_a_la_tasa'))
             end

          reestructuracion.estatus = 5
          reestructuracion.fecha_generacion_table = Time.now
          reestructuracion.solicitud_id = @solicitud.id

          successReestructuracion = reestructuracion.save
          if successReestructuracion == false
            errors.add(:Reestructuracion, I18n.t('Sistema.Body.Vistas.Reestructuracion.Etiquetas.no_es_posible_actualizar_informacion'))
          end

          logger.info "4 ---------------------- GUARDANDO CAMBIOS EN EL DETALLE DE LA REESTRUCTURACION "
          reestructuracion_detalle = ReestructuracionDetalle.find(:all, :conditions=>"reestructuracion_id = #{reestructuracion.id}")
          reestructuracion_detalle.each do |detalle|
            detalle.solicitud_nueva_id = @solicitud.id
            detalle.save

            logger.info "5 ---------------------- ACTUALIZANDO SOLICITUD VIEJAS " << detalle.id
            solicitud_origen = Solicitud.find(detalle.solicitud_origen_id)
            solicitud_origen.estatus_id = 10180
            solicitud_origen.save

            logger.info "6 ---------------------- ACTUALIZANDO PRESTAMOs VIEJOS " << detalle.id
            prestamo_origen = Prestamo.find_by_solicitud_id(solicitud_origen.id)
            prestamo_origen.reestructurado = 'F'
            prestamo_origen.estatus = 'F'
            prestamo_origen.prestamo_destino_id = @prestamo.id
            prestamo_origen.save

            #CREACION DE FACTURAS PARA PRESTAMO ORIGEN Y PRESTAMO DESTINO
            #logger.debug ""
            parametro_general = ParametroGeneral.find(1);

          logger.info "VOY A SALVAR FACTURA......PRESTAMO ORIGEN" << prestamo_origen.inspect

          factura_origen = Factura.new(:numero=>parametro_general.ultima_factura+1,
            :fecha=>Time.now.strftime(I18n.t('time.formats.gebos_short')),
            :fecha_realizacion=>Time.now.strftime(I18n.t('time.formats.gebos_short')),
            :tipo=>'W',
            #:monto=>prestamo_origen.monto,                  #REVISAR SI ES EL MONTO REESTRUCTURADO
            :monto=>prestamo_origen.deuda,                  #REVISAR SI ES EL MONTO REESTRUCTURADO
            :prestamo_id=>@prestamo.id,
            :prestamo_modificacion_id=>prestamo_origen.id)

            logger.info "VOY A SALVAR FACTURA......FACTURA" << factura_origen.inspect
            successFacturaOrigen = factura_origen.save!
            if successFacturaOrigen == false
              errors.add(:Reestructuracion, "#{I18n.t('Sistema.Body.Vistas.Reestructuracion.Etiquetas.no_crear_factura')} #{prestamo_origen.numero}")
            end

             parametro_general.ultima_factura += 1;
             parametro_general.save

          end


          parametro_general = ParametroGeneral.find(1);
          factura_destino = Factura.new(:numero=>parametro_general.ultima_factura+1,
            :fecha=>Time.now.strftime(I18n.t('time.formats.gebos_short')),
            :fecha_realizacion=>Time.now.strftime(I18n.t('time.formats.gebos_short')),
            :tipo=>'X',
            :monto=>reestructuracion.monto_reestructurado,                  #REVISAR SI ES EL MONTO REESTRUCTURADO
            :prestamo_id=>@prestamo.id)
            #:prestamo_modificacion_id=>prestamo_origen.id)
          successFacturaDestino = factura_destino.save
          if successFacturaDestino == false
            errors.add(:Reestructuracion, "#{I18n.t('Sistema.Body.Vistas.Reestructuracion.Etiquetas.no_crear_factura')} #{prestamo_origen.numero}")
          end

           parametro_general.ultima_factura += 1;
           parametro_general.save

          #@prestamo.generar_plan_pago_inicial(monto_liquidacion, fecha_aplicacion, desembolso.id, desembolso.monto, self.monto_sras_total, monto_insumos)
          @prestamo.generar_plan_pago_migracion(reestructuracion.monto_reestructurado, @prestamo.fecha_liquidacion, 0, 0)

          logger.debug "ERRORES DEL MODELO >>>>>>>>>>>>>>>>>>>> " << errors.inspect
          iniciar_transaccion(prestamo_aux.id, 'p_dummy', 'L', "Transaccion Dummy", usuario_id, 0)


          return true
        end
        rescue Exception => e
          logger.debug "RECUPERANDOOOO --------------------->>>>>>>>>>> "
          logger.error e.message
          logger.error e.backtrace.join("\n")
          return false
        end
      end

      def viable_f

        logger.info "Cliente Viable =====> #{self.cliente.viable.to_s}"
        if self.viable
          I18n.t('Sistema.Body.General.si')
        else
          I18n.t('Sistema.Body.Vistas.General.opc_no')
        end

      end

      def frecuencia_w
        case self.frecuencia
          when 0
            I18n.t('Sistema.Body.General.Periodos.pago_unico')
          when 2
            I18n.t('Sistema.Body.General.Periodos.bimestral')
          when 1
            I18n.t('Sistema.Body.General.Periodos.mensual')
          when 3
            I18n.t('Sistema.Body.General.Periodos.trimestral')
          when 5
            I18n.t('Sistema.Body.General.Periodos.pentamestral')
          when 6
            I18n.t('Sistema.Body.General.Periodos.semestral')
          when 12
            I18n.t('Sistema.Body.General.Periodos.anual')
        end
      end

   #id
   #numero
   #nombre_proyecto
   #aporte_social
   #monto_propuesta_social
   #numero_comite_estadal
   #numero_comite_nacional
   #fecha_comite_estadal
   #fecha_comite_nacional
   #fecha_solicitud_desembolso
   #comentario_directorio
   #causa_rechazo_id
   #causa_diferimiento_id
   #parroquia_id
   #ciudad_id
   #municipio_id
   #estatus_directorio
   #porcentaje_cooperativa
   #porcentaje_empresa
   #causa_liberacion
   #aumento_capital
   #causa_diferimiento_comite_id
   #causa_rechazo_comite_id
   #codigo_d3
   #fecha_firma_contrato
   #cuenta_matriz_id
   #numero_origen antes si se utilizaba para la reestructuracion
   #ups_id
   #mision_id
   #analista_consejo
   #comite_id
   #decision_comite
   #comentario_comite
   #numero_acta_resumen_comite
   #control_certificacion
   #control_disponibilidad
   #numero_acta_liquidacion
   #fecha_acta_liquidacion
   #region_id
   #scoring_aceptacion_id
   #monto_actuales
   #monto_proyecto
   #calificacion_cuantitativa
   #calificacion_cualitativa
   #calificacion_social
   #destino_credito
   #tipo_iniciativa_id
   #usuario_pre_evaluacion
   #partida_presupuestaria_id
   #usuario_resguardo
   #reestructuracion_solicitud_id
   #monto_ampliacion
   #no_visto
   #instancia_comite
   #folio_autenticacion  NO SE SI APLICA
   #tomo_autenticacion   NO SE SI APLICA
   #abogado_id           NO SE SI APLICA
   #codigo_sras          NO SE SI APLICA
   #ruta_contrato = null           NO SE SI APLICA
   #ruta_acta_entrega = NULL       NO SE SI APLICA
   #ruta_nota_autenticacion = NULL NO SE SI APLICA
   #fecha_nota_autenticacion       NO SE SI APLICA
   #fecha_a_entrega          NO SE SI APLICA
   #conf_maquinaria = false


end



# == Schema Information
#
# Table name: reestructuracion
#
#  id                                     :integer         not null, primary key
#  fecha_impresion_formato_solicitud      :date
#  estatus                                :integer
#  solicitud_id                           :integer
#  cliente_id                             :integer
#  fecha_aprobacion_comite                :date
#  fecha_envio_comite                     :date
#  referencia_abono                       :string
#  monto_abono                            :decimal(16, 2)  default(0.0)
#  fecha_abono                            :date
#  interes_diferido                       :decimal(16, 2)  default(0.0)
#  interes_ordinarios                     :decimal(16, 2)  default(0.0)
#  interes_moratorio                      :decimal(16, 2)  default(0.0)
#  interes_causado_no_devengado           :decimal(16, 2)  default(0.0)
#  exonerado_interes_diferido             :boolean
#  exonerado_interes_ordinarios           :boolean
#  exonerado_interes_moratorio            :boolean
#  exonerado_interes_causado_no_devengado :boolean
#  deuda                                  :decimal(16, 2)  default(0.0)
#  monto_reestructurado                   :decimal(16, 2)  default(0.0)
#  formula_id                             :integer
#  frecuencia                             :integer
#  plazo                                  :integer
#  tasa                                   :decimal(16, 2)  default(0.0)
#  programa_id                            :integer
#  origen_fondo_id                        :integer
#  unidad_produccion_id                   :integer
#  modalidad_financiamiento_id            :integer
#  objetivo_proyecto                      :string
#  empresa_integrante_id                  :integer
#  sector_id                              :integer
#  sub_sector_id                          :integer
#  rubro_id                               :integer
#  sub_rubro_id                           :integer
#  actividad_id                           :integer
#  saldo_insoluto                         :decimal(16, 2)  default(0.0)
#  fecha_impresion_propuesta              :date
#  fecha_impresion_contrato               :date
#  fecha_generacion_table                 :date
#  hectareas_solicitadas                  :decimal(14, 2)
#  semovientes_solicitados                :integer
#  por_inventario                         :boolean         default(FALSE)
#  fecha_valor                            :date
#  viable                                 :boolean         default(FALSE)
#  entidad_financiera_id                  :integer         default(0), not null
#  tipo                                   :string(1)
#  numero_cuenta                          :string(20)
#

