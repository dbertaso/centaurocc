
  require 'prawn-rails'

   prestamo_id = params[:prestamo_id]
   
   datos_iniciales = []
   datos_generales = []
   datos_desembolso = [] 
   datos_situacion = []
   datos_pago = []
   datos_cronograma_pagos = []
   datos_excedente = []
   datos_excedente_pagado = []
   datos_estadisticas = []
   datos_orden_despacho = []
   datos_firma = []
   data_encabezado = []
   header_desembolsos = []
   header_cronograma_pagos = []
   header_pagos = []
   header_excedentes = []
   numero_cuenta = ""
   banco = ""
   fecha_fin = ""
   tipo_desembolso = ""
   referencia = ""
   plazo = ""
   
   monto_desembolsos = 0.00
   
   #DATOS TRAIDOS DE BASE DE DATOS

   @prestamo = Prestamo.find(prestamo_id)
   
   #Se recuperan los desembolsos efectuados
    
   @facturas_desembolso = Factura.find( :all, 
                                        :select=> 'fecha_realizacion,
                                                     fecha,
                                                     fecha_contable,
                                                     monto_banco,
                                                     monto_insumos,
                                                     monto_inventario,
                                                     monto_sras,
                                                     monto_gastos,
                                                     monto,
                                                     numero,
                                                     desembolso_id
                                                     prestamo_id',
                                        :conditions=>['prestamo_id = ? and tipo = ?',prestamo_id, 'D'], :order=>'fecha_realizacion desc')
    
    #Se recuperan los pagos efectuados
    
    @facturas_pago = ViewPagosEstadoCuenta.find(:all, 
                                                :conditions=>["prestamo_id = ? ",prestamo_id], :order=>'fecha_realizacion desc')
                                                
    #Se recuperan los excedentes pagados
    
    @pago_excedentes = ViewExcedenteArrime.find(:all, :select=>'fecha_abono_cuenta,
                                                                fecha_registro_cheque,
                                                                tipo_cheque,
                                                                monto_abono,
                                                                referencia,
                                                                tipo,
                                                                numero_cuenta,
                                                                banco',
                                                    :conditions=>["prestamo_id = ? and (fecha_abono_cuenta is not null or fecha_registro_cheque is not null)", prestamo_id],
                                                    :order=>'fecha_abono_cuenta desc')
                                                  
    #Se recupera la tabla de amortización del financiamiento
    
    @cronograma_pagos = ViewCronogramaPagos.find(:all, :conditions=>["prestamo_id = ? and activo = true", prestamo_id], 
                                                       :order => 'tipo_cuota desc,
                                                                  numero')
    
    #Se recupera las ordenes de despacho confirmadas del financiamiento
     
    @facturas = FacturaOrdenDespacho.find(:all,:conditions=>"emitida=true and confirmada = true and orden_despacho_detalle_id in (select id from orden_despacho_detalle where orden_despacho_id in (select id from orden_despacho where solicitud_id = #{@prestamo.solicitud_id}))",:select=>"distinct numero_factura, sum (monto_factura) as monto_total_factura,sum (cantidad_factura) as cantidad_total_factura,casa_proveedora_id,sucursal_casa_proveedora_id,emitida,confirmada,fecha_factura,fecha_emision,factura_estatus_id,secuencia",:group=>"numero_factura,casa_proveedora_id,sucursal_casa_proveedora_id,emitida,confirmada,fecha_factura,fecha_emision,factura_estatus_id,secuencia",:order=>"secuencia")
     
    @cliente = @prestamo.cliente
    solicitud = @prestamo.solicitud

    parameters = {:p_prestamo=> [@prestamo.numero, "Long"] }


    #DEFINICION FILAS CORRESPONDIENTES A HEADER, CUERPO, FOOTER

    header_desembolsos = [

              t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.fecha_valor'),
              t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.tipo'),
              t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.entidad_financiera'),
              t('Sistema.Body.Vistas.General.referencia'),
              t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.monto_banco'),
              t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.monto_insumos'),
              t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.monto_inventario'),
              t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.monto_sras'),
              t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.monto_gastos'),
              "#{t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.total')} #{t('Sistema.Body.Vistas.Form.desembolso')}"
    ]
    
    header_pagos = [

              "#{t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.tipo')} #{t('Sistema.Body.Vistas.General.de')} #{t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.pago')}",
              t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.fecha_pago') ,
              t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.fecha_valor'),
              t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.monto_pago'),
              t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.interes_mora'),
              t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.interes_diferido'),
              t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.intereses'),
              t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.capital'),
              t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.saldo_favor'),
              t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.abono_capital')
    ]
    
    header_cronograma_pagos = [

              t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.tipo_cuota'),
              t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.numero_cuota'),
              t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.fecha_pagar'),
              t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.monto_cuota'),
              t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.interes_cuota'),
              t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.capital_cuota'),
              t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.interes_diferido'),
              t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.interes_mora'),
              "#{t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.total')} #{t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.pagar')}",
              t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.saldo_deudor'),
              t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.estatus_cuota')

    ]
    
    header_excedentes = [
    
                t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.fecha_pago'),
                t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.forma_pago'),
                t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.monto_pagado')
    ]
    
    header_orden_despacho = [
                              "#{t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.numero_factura')}",
                              "#{t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.casa_proveedora')}",
                              "#{t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.sucursal')} #{t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.casa_proveedora')}",
                              "#{t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.cantidad_items_facturados')}",
                              "#{t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.fecha_emision')}",
                              "#{t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.fecha_factura')}",
                              "#{t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.monto_total_factura')}"
                            ]
                            
    header_datos = [
                  "#{t('Sistema.Body.Vistas.ConsultaPrestamo.Separadores.datos_generales')}"
    ]
     
    plan = PlanPago.find_by_prestamo_id_and_activo(@prestamo.id, true)
  
    if !plan.nil?
      fecha_fin = plan.fecha_fin.strftime("%d/%m/%Y")
    else
      fecha_fin = ""
    end
    #logger.info parameters.inspect
    #send_doc(nombre_reporte, parameters, nombre_carpeta,  "#{t('Sistema.Body.Vistas.ConsultaPrestamo.Etiquetas.estado_cuenta')} " + :prestamo_id.to_s, "pdf" )

    cuenta = CuentaBancaria.find_by_cliente_id_and_activo(@prestamo.solicitud.cliente_id,true)
  
    if cuenta.nil?
      numero_cuenta = ""
      banco = ""
    else
      numero_cuenta = cuenta.tipo_w + '-' + cuenta.numero
      banco = cuenta.entidad_financiera.nombre
    end

    if @cliente.class.to_s == 'ClientePersona'
      tipo_persona = t('Sistema.Body.Vistas.General.persona_natural')
      documento = @cliente.persona.cedula_nacionalidad + '-' + @cliente.persona.cedula.to_s
    else
      tipo_persona = t('Sistema.Body.Vistas.General.persona_juridica')
      documento = @cliente.empresa.rif
    end
    
    
    datos_iniciales <<  [
                          "#{I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.fecha_corte')}:                  ", solicitud.programa.fecha_cierre.strftime("%d/%m/%Y"),
                          "#{I18n.t('Sistema.Body.Vistas.Form.numero_tramite')}:               ", solicitud.numero.to_s
                        ]
                
    datos_iniciales <<  [
                          "#{I18n.t('Sistema.Body.Vistas.VisitaSolicitud.Etiquetas.cedula_rif')}                  ", documento,
                          "#{I18n.t('Sistema.Body.Vistas.Form.numero_financiamiento')}:        ", @prestamo.numero.to_s
                        ]
    datos_iniciales <<  [
                          "#{I18n.t('Sistema.Body.Vistas.General.beneficiario')}:                 ", solicitud.cliente.nombre,
                          "#{I18n.t('Sistema.Body.Vistas.General.tipo')} #{t('Sistema.Body.Vistas.General.persona')}:                ", tipo_persona
                        ]

    plazo = "#{(@prestamo.plazo).to_s} #{t('Sistema.Body.General.meses')}"
    
    datos_generales = []

    datos_generales <<  [
                          "#{I18n.t('Sistema.Body.Vistas.General.programa')}:                     ", @prestamo.solicitud.programa.nombre,
                          "#{I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.monto_aprobado')}:               ", @prestamo.monto_solicitado_fm
                        ]
                
    datos_generales <<  [
                          "#{I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.origen')}:                        ", @prestamo.banco_origen,
                          "#{I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.monto_banco')}:                  ", @prestamo.monto_banco_fm
                        ]
    datos_generales <<  [
                          "#{I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.status')}:                      ", @prestamo.estatus_w,
                          "#{I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.monto_insumos')}:                ", @prestamo.monto_insumos_fm
                        ]
                     
    datos_generales <<  [
                          "#{I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.cantidad_cuotas_vencidas')}:     ", @prestamo.cantidad_cuotas_vencidas,
                          "#{I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.monto_sras')}:                   ", @prestamo.monto_sras_total_fm
                        ]
  
    datos_generales <<  [
                          "#{I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.dias_mora')}:                 ", @prestamo.dias_mora,
                          "#{I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.monto_gastos')}: ", @prestamo.monto_gasto_total_fm
                        ]

    datos_generales <<  [
                          "#{I18n.t('Sistema.Body.Vistas.Form.rubro')}:                        ", @prestamo.solicitud.rubro.nombre,
                          "#{I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.monto_credito')}:            ", @prestamo.total_financiamiento_fm
                        ]
                    
  
    datos_generales << [
                          "#{I18n.t('Sistema.Body.Vistas.General.estado')}:                       ", @prestamo.solicitud.unidad_produccion.ciudad.estado.nombre, 
                          "#{I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.monto_despachado')}:             ", @prestamo.monto_despachado_fm
                      
                        ]
        
    datos_generales <<  [

                          "#{I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.tasa_vigente')}:                 ", @prestamo.tasa_vigente_fm,
                          "#{I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.monto_despachar')}:          ", @prestamo.monto_por_despachar_fm
                        
                        ]

    datos_generales <<  [
                          "#{I18n.t('Sistema.Body.General.plazo')}:                        ", plazo,
                          "#{I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.monto_liquidado')}:              ", @prestamo.monto_liquidado_fm
                            
                        ]

    datos_generales <<  [
                          "#{I18n.t('Sistema.Body.General.frecuencia_pago')}:           ", @prestamo.frecuencia_pago_w,
                          "#{I18n.t('Sistema.Body.Vistas.ConsultaPrestamo.Etiquetas.monto_por_liquidar')}:           ", @prestamo.monto_por_liquidar_fm
                                            
                        ]
                   
    datos_generales <<  [
                          "#{I18n.t('Sistema.Body.General.cuenta')}:                       ", numero_cuenta,
                          "#{I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.monto_facturado')}:              ", @prestamo.monto_facturado_fm
                        ]           

    datos_generales <<  [
                          "#{I18n.t('Sistema.Body.Vistas.General.banco')}:                        ", banco,
                          "                              ", "                 "
                        ] 
                          
    datos_generales <<  [
                      
                          "#{I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.fecha_liquidacion')}:            ", @prestamo.fecha_liquidacion_f,
                          "                              ", "                 "
                        ]      

    datos_generales <<  [
                          "#{I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.fecha_vencimiento')}:            ", fecha_fin,
                          "                              ", "          "
                        ]  

    datos_situacion <<  [
                          "#{I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.saldo_deudor')}:                   ", @prestamo.saldo_insoluto_total_fm, 
                          "#{I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.capital_vencido')}:                ", @prestamo.capital_vencido_fm
                        ]
                        
    datos_situacion <<  [
                          "#{I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.intereses')}:           ", @prestamo.interes_vencido_fm, 
                          "#{I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.intereses')} #{I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.vencidos')}:  ", @prestamo.interes_vencido_fm
                        ]
                        
    datos_situacion <<  [
                          "#{I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.interes_diferido')}:               ", @prestamo.interes_diferido_por_vencer_fm, 
                          "#{I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.interes_diferido')} #{I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.vencido')}:       ", @prestamo.interes_diferido_vencido_fm
                        ]
                        
    datos_situacion <<  [
                          "#{I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.interes_mora')}:                ", @prestamo.monto_mora_fm, 
                          "#{I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.interes_mora')}:                ", @prestamo.monto_mora_fm
                        ]

    datos_situacion <<  [
                          "#{I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.interes_devengado')}:   ", @prestamo.causado_no_devengado_fm, 
                          "(-) #{I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.saldo_favor')}:              ", @prestamo.remanente_por_aplicar_fm 
                        ]
                        
    datos_situacion <<  [
                          "(-) #{I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.saldo_favor')}:              ", @prestamo.remanente_por_aplicar_fm, 
                          "#{I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.fecha_estado_cuenta')}:            ", @prestamo.solicitud.programa.fecha_ultimo_cierre_f
                        ]

    datos_situacion <<  [ 
                          "#{I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.total')} #{I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.deuda')}:                    ", @prestamo.total_deuda_fm, 
                          "#{I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.total')} #{I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.exigible')}:                 ", @prestamo.exigible_fm
                        ]

    datos_excedente <<  [ 
                          "#{I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.excedente')} #{I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.pagar')}:            ", @prestamo.remanente_por_aplicar_fm, 
                        ]
 
 
    datos_estadisticas <<  [
                          "#{I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.dias_en_vigente')}:                ", @prestamo.dias_vigente, 
                          "#{I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.total')} #{I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.capital_pagado')}:           ", @prestamo.capital_pagado_fm
                        ]
                        
    datos_estadisticas <<  [
                          "#{I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.dias_en_vencido')}:                ", @prestamo.dias_vencido, 
                          "#{I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.total')} #{I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.interes_pagado')}:           ", @prestamo.intereses_pagados_fm
                        ]
                        
    datos_estadisticas <<  [
                          "#{I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.cuotas_pagadas')}:                 ", @prestamo.cuotas_pagadas, 
                          "#{I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.total')} #{I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.mora_pagada')}:              ", @prestamo.mora_pagada_fm
                        ]
                        
    datos_estadisticas <<  [
                          "#{I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.cuotas_vencidas')}:                ", @prestamo.cantidad_cuotas_vencidas, 
                          "                                 ", "                "
                        ]

    datos_estadisticas <<  [
                          "#{I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.cuotas_por_vencer')}:              ", @prestamo.cuotas_pendientes, 
                          "                                 ", "                " 
                        ]
                        
    datos_estadisticas <<  [
                          "#{I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.cuotas_especiales_pagadas')}:       ", @prestamo.cuotas_especiales_vencidas, 
                          "                                 ", "                "
                        ]
                       
    datos_desembolso = datos_desembolso << header_desembolsos    

    logger.info "datos desembolso =========> #{datos_desembolso.inspect}"

    for factura in @facturas_desembolso
   
      #no tiene sentido, esto puede dar nil y ademas no se utiliza mas adelante en el codigo desembolso = Desembolso.find(factura.desembolso_id)
      monto_desembolsos += factura.monto
    
      unless factura.desembolso.nil?
        case factura.desembolso.tipo_cheque
          when 'F'
            tipo_desembolso = t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.desembolso_cheque_fondas')
          when 'G'
            tipo_desembolso = t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.desembolso_cheque_gerencia')
        else
          tipo_desembolso = t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.transferencia')
        end
      else
        tipo_desembolso = t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.desembolso_solo_insumos')
      end
    
      unless factura.desembolso.nil?
        entidad=factura.desembolso.entidad_financiera.nombre.strip
        if  factura.desembolso.tipo_cheque == 'G' ||
            factura.desembolso.tipo_cheque == 'P'
          referencia = factura.desembolso.referencia.strip
        else
          referencia = factura.desembolso.numero_cuenta.strip
        end
      else
        entidad=''
        referencia = factura.prestamo.nil? ? '' : (factura.prestamo.orden_despacho.nil? ? '' : factura.prestamo.orden_despacho.numero.strip)
      end            

      datos_desembolso << [

          factura.fecha_realizacion.strftime("%d/%m/%Y"),
          tipo_desembolso,
          entidad,
          referencia,
          factura.monto_banco_fm,
          factura.monto_insumos_fm,
          factura.monto_inventario_fm, 
          factura.monto_sras_fm,
          factura.monto_gastos_fm,
          factura.monto_fm,
        ]
    end

       
    datos_desembolso << ["", "","","","","","","","#{t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.total').upcase} #{t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Separadores.desembolsos').upcase}", 
                      format_fm(monto_desembolsos)
                     ]
                     
    #Creación Tabla de pagos
    
    monto_pago = 0.00 
    monto_mora = 0.00
    monto_diferido = 0.00
    monto_ordinario = 0.00
    monto_capital = 0.00
    monto_abono_capital = 0.00 
    monto_remanente = 0.00
    pago_tipo = ""

    datos_pago = datos_pago << header_pagos

    for pago in @facturas_pago
    
        case pago.tipo
            when 'R'
              pago_tipo = t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.pago_arrime')
            when 'P'
              pago_tipo = t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.pago_deposito')
            when 'P'
        end
          
      monto_pago += pago.monto_pago.to_f
      monto_abono_capital += pago.abono_capital.to_f
      monto_mora += pago.pago_interes_mora.to_f
      monto_diferido += pago.pago_interes_diferido.to_f
      monto_ordinario += pago.pago_interes.to_f
      monto_capital += pago.pago_capital.to_f
      monto_remanente += pago.remanente_por_aplicar.to_f 

      
      datos_pago << [

                      pago_tipo,
                      pago.fecha.strftime("%d/%m/%Y"),
                      pago.fecha_realizacion.strftime("%d/%m/%Y"),
                      pago.monto_pago_fm,         
                      pago.pago_interes_mora_fm,
                      pago.pago_interes_diferido_fm,
                      pago.pago_interes_fm,
                      pago.pago_capital_fm,
                      pago.remanente_por_aplicar_fm,
                      pago.abono_capital_fm
                      
                    ]
                    

    end
    
    datos_pago << [
      
                    "",
                    "",
                    "#{t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.totales').upcase}:",
                    sprintf('%01.2f', monto_pago).sub('.', ',').to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1."),
                    sprintf('%01.2f', monto_mora).sub('.', ',').to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1."),
                    sprintf('%01.2f', monto_diferido).sub('.', ',').to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1."),
                    sprintf('%01.2f', monto_ordinario).sub('.', ',').to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1."),
                    sprintf('%01.2f', monto_capital).sub('.', ',').to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1."),
                    "",
                    sprintf('%01.2f', monto_abono_capital).sub('.', ',').to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")

                  ]

    monto_total = 0.00
    fecha = ""
    forma_pago = ""
    
    datos_excedente_pagado = datos_excedente_pagado << header_excedentes
    for excedente in @pago_excedentes
      monto_total += excedente.monto_abono
      if !excedente.tipo_cheque.nil?
        fecha = excedente.fecha_registro_cheque.strftime("%d/%m/%Y")
      else
        fecha = excedente.fecha_abono_cuenta.strftime("%d/%m/%Y")
      end
      if excedente.numero_cuenta != nil
        forma_pago = "#{t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.transferencia')}\n #{excedente.banco}\n"
        if excedente.tipo.upcase == 'C' 
           forma_pago += "#{t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.cuenta_corriente')}" 
        else 
           forma_pago += "#{t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.cuenta_ahorro')}" 
        end
      else
        if excedente.tipo_cheque.upcase == 'G' 
          forma_pago = "#{t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.cheque_gerencia')}\n"
        else 
          forma_pago = "#{t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.cuenta_propio')}\n"
        end
          forma_pago += excedente.referencia
      end
      
      datos_excedente_pagado << [
      
                            fecha,
                            forma_pago,
                            sprintf('%01.2f', excedente.monto_abono).sub('.', ',').to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
                          ]

    end
    
    datos_excedente_pagado << [
    
                          "",
                          "#{t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.total')} #{t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.abonos')}:",
                          sprintf('%01.2f', monto_total).sub('.', ',').to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
                        ]

    # Tabla de cronograma de pagos
    cuota = 0

    datos_cronograma_pagos = datos_cronograma_pagos << header_cronograma_pagos

    for cronograma in @cronograma_pagos
          
      datos_cronograma_pagos << [
                                  cronograma.tipo,
                                  cuota += 1,
                                  cronograma.fecha.strftime("%d/%m/%Y"),
                                  cronograma.valor_cuota_fm,
                                  cronograma.interes_corriente_fm,
                                  cronograma.capital_fm,
                                  cronograma.interes_diferido_fm,
                                  cronograma.interes_mora_fm,
                                  cronograma.total_pagar_fm,
                                  cronograma.saldo_insoluto_fm,
                                  cronograma.estatus
                                ]
    end
 
    #Carga de la tabla de Ordenes de Despacho
    
    casa_proveedora = ""
    sucursal_casa_proveedora = ""
    datos_orden_despacho = datos_orden_despacho << header_orden_despacho

    for factura in @facturas
      unless factura.casa_proveedora.nil?
        casa_proveedora = factura.casa_proveedora.nombre.strip.upcase
      else
        casa_proveedora = ""
      end
      
      unless factura.sucursal_casa_proveedora.nil?
        sucursal_casa_proveedora = factura.sucursal_casa_proveedora.nombre.strip.upcase
      else
        sucursal_casa_proveedora = ""
      end
      
      datos_orden_despacho << [
      
                                factura.numero_factura,
                                casa_proveedora,
                                sucursal_casa_proveedora,
                                sprintf('%01.2f', factura.cantidad_total_factura.to_f).sub('.', ',').to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1."),
                                factura.fecha_emision_f,
                                factura.fecha_factura_f,
                                sprintf('%01.2f', factura.monto_total_factura).sub('.', ',').to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
                              ]
    end
    
    #APERTURA DEL PDF
    
    logger.info "Datos Iniciales #{datos_iniciales.inspect}"
    #pdf = Prawn::Document.new
    # Prawn::Document.generate "assignment.pdf" do |pdf|
    #   pdf.font "Times-Roman"
    #   pdf.draw_text content, :at => [200,720], :size => 32
    # end

    #pdf = Prawn::Document.generate('implicit.pdf', {page_size: "LETTER", page_layout: :portrait}) do

    archivo = "estado_cuenta_#{Time.now.strftime("%Y%m%d%H%M%S")}.pdf"
    
    #pdf = Prawn::Document.generate(archivo, {page_size: "LETTER", page_layout: :portrait}) do
    prawn_document(filename: archivo, disposition: "attachment", page_size: "LETTER", page_layout: :portrait) do |pdf|
      #font "Times-Roman"
      string = "#{I18n.t('Sistema.Body.Vistas.Helpers.Mensajes.pagina')} <page> #{I18n.t('Sistema.Body.Vistas.General.de')} <total>"
      #DEFINICION DEL HEADER

      #repeat(:all) do

      # bounding_box([1,5], :width=>530, :height => 100) do
      #     logo = "#{Rails.root}/app/assets/images/#{I18n.t('Sistema.Body.Imagenes.agricultura_tierras')}"
      #     image logo, :position => :left, :vposition => :top, :width => 30
      #     logo2 = "#{Rails.root}//app/assets/images/#{I18n.t('Sistema.Body.Imagenes.logo_reporte')}"
      #     image logo2, :position => :right, :vposition => :top, :width => 30
      #     move_up(20)
      #     text "#{I18n.t('Sistema.Body.General.gerencia_cobranzas')}", 
      #          :size => 10, :style => :bold, :align => :center
      #     move_down(2)
      #     text "#{I18n.t('Sistema.Body.General.estado_cuenta').upcase} #{I18n.t('Sistema.Body.Vistas.General.del').upcase} #{I18n.t('Sistema.Body.Vistas.General.financiamiento').upcase} #{solicitud.programa.fecha_cierre.strftime("%d/%m/%Y")}", 
      #          :size => 10, :style => :bold, :align => :center
      # end


      #DEFINICION DEL BOUNDING BOX CONTENEDOR DEL CUERPO
      bounding_box([5,650], :width => 530, :height => 550, :border_width=>1) do

          logo = "#{Rails.root}/app/assets/images/#{I18n.t('Sistema.Body.Imagenes.agricultura_tierras')}"
          pdf.image logo, :position => :left, :vposition => :top, :width => 30
          logo2 = "#{Rails.root}//app/assets/images/#{I18n.t('Sistema.Body.Imagenes.logo_reporte')}"
          pdf.image logo2, :position => :right, :vposition => :top, :width => 30
          pdf.move_up(20)
          pdf.text "#{I18n.t('Sistema.Body.General.gerencia_cobranzas')}", 
               :size => 10, :style => :bold, :align => :center
          pdf.move_down(2)
          pdf.text "#{I18n.t('Sistema.Body.General.estado_cuenta').upcase} #{I18n.t('Sistema.Body.Vistas.General.del').upcase} #{I18n.t('Sistema.Body.Vistas.General.financiamiento').upcase} #{solicitud.programa.fecha_cierre.strftime("%d/%m/%Y")}", 
               :size => 10, :style => :bold, :align => :center
        
        pdf.table datos_iniciales,
          :row_colors => ["F0F0F0", "FFFFCC"],
          :cell_style => {:borders => [:left, :right, :top, :bottom],
                         :border_widths => [0.5, 0.5, 0.5, 0.5],
                         :size => 8, :overflow => :shrink_to_fit},                      
          :width => 500,
          :column_widths => {0 => 130, 1=>130, 2 => 130, 3 => 110}
            
        pdf.move_down(20)   
                 
        pdf.text I18n.t('Sistema.Body.Vistas.ConsultaPrestamo.Separadores.datos_generales').upcase,
          :text_color => '000000',
          :font_size => 9,
          :width => 500,
          :align => :center,
          :style => :bold
        
        pdf.move_down(10)
          
        pdf.table(datos_generales,
          :row_colors => ["F0F0F0", "FFFFCC"],
          :cell_style => {:borders => [:left, :right, :top, :bottom], 
                          :border_widths => [0.5, 0.5, 0.5, 0.5],
                          :font_style => :bold, 
                          :size => 8, :overflow => :shrink_to_fit},
          :width => 500,
          :column_widths => {0 => 130, 1 => 130, 2 => 130, 3 => 110})

      end     # =====> fin del bounding_box
          
      pdf.move_down(200)
      
      pdf.text I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.deuda').upcase,                                                          #{t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.exigible').upcase}",
        :text_color => '000000',
        :font_size => 9,
        :width => 500,
        :align => :center,
        :style => :bold,
        :border => 1
      
      pdf.move_down(20)
          
      pdf.table(datos_situacion,
        :row_colors => ["F0F0F0", "FFFFCC"],
        :cell_style => {:borders => [:left, :right, :top, :bottom], 
                        :border_widths => [0.5, 0.5, 0.5, 0.5],
                        :font_style => :bold, 
                        :size => 8, :overflow => :shrink_to_fit},
        :width => 500,
        :column_widths => {0 => 130, 1 => 130, 2 => 130, 3 => 110})

               
      move_down(40)
          
      pdf.start_new_page

      pdf.text I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Separadores.desembolsos').upcase,
        :text_color => '000000',
        :font_size => 9,
        :width => 500,
        :align => :center,
        :style => :bold
        
      pdf.move_down(10)
      
      pdf.table(datos_desembolso,
        :row_colors => ["F0F0F0", "FFFFCC"],
        :cell_style => {:borders => [:left, :right, :top, :bottom], 
                        :border_widths => [0.5, 0.5, 0.5, 0.5],
                        :font_style => :bold, :size => 6, 
                        :overflow => :shrink_to_fit},
        :width => 510,
        :header => true,
        :column_widths => {0 => 40, 1 => 50, 2 => 60, 3 => 70, 4 =>40, 5 => 50, 6 => 50, 7 => 50, 8 => 50, 9 => 50})
        
      pdf.move_down(10)
          
      pdf.text I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.pagos').upcase,
        :text_color => '000000',
        :font_size => 9,
        :width => 510,
        :align => :center,
        :style => :bold

      pdf.move_down(10)
        
      unless datos_pago.nil?
        pdf.table(datos_pago,
          :row_colors => ["F0F0F0", "FFFFCC"],
          :cell_style => {:borders => [:left, :right, :top, :bottom],
                          :border_widths => [0.5, 0.5, 0.5, 0.5],
                          :font_style => :bold, 
                          :size => 7, :overflow => :shrink_to_fit},

          :width => 510,
          :header => true,
          :column_widths  => {0 => 50, 1 => 50, 2 => 50, 3 => 50, 4 =>50, 5 => 50, 6 => 50, 7 => 50, 8 => 60, 9 => 50})
      else
      
        pdf.text I18n.t('Sistema.Body.General.no_hay_pagos').upcase,
          :text_color => '1E90FF',
          :font_size => 3,
          :width => 510,
          :align => :center,
          :style => :bold
      end

      pdf.move_down(10)
          
      pdf.text "#{I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.excedentes').upcase} #{I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.por_pagar').upcase}",
        :text_color => '000000',
        :font_size => 9,
        :width => 510,
        :align => :center,
        :style => :bold
        
      pdf.move_down(10)
      
      pdf.table(datos_excedente,
        :row_colors => ["F0F0F0", "FFFFCC"],
        :cell_style => {:borders => [:left, :right, :top, :bottom], 
                        :border_widths => [0.5, 0.5, 0.5, 0.5],
                        :font_style => :bold, 
                        :size => 7, :overflow => :shrink_to_fit},
        :width => 510,
        :column_widths  => {0 => 255, 1 => 255})
          
      pdf.move_down(10)

      pdf.text "#{I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.excedentes').upcase} #{I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Etiquetas.pagados').upcase}",
        :text_color => '000000',
        :font_size => 9,
        :width => 510,
        :align => :center,
        :style => :bold
        
      pdf.move_down(10)
          
      unless datos_excedente_pagado.nil?
        pdf.table(datos_excedente_pagado,
          :row_colors => ["F0F0F0", "FFFFCC"],
          :cell_style => {:borders => [:left, :right, :top, :bottom], 
                          :border_widths => [0.5, 0.5, 0.5, 0.5],
                          :font_style => :bold,
                          :size => 7, :overflow => :shrink_to_fit},

          :width => 510,
          :header => true,
          :column_widths  => {0 => 120, 1 => 270, 2 => 120})
      else
        pdf.text I18n.t('Sistema.Body.General.no_hay_pagos_excedentes').upcase,
          :text_color => '1E90FF',
          :size => 7,
          :width => 510,
          :align => :center,
          :style => :bold
      end
            
      pdf.start_new_page
      
      pdf.move_down(10)
      
      pdf.text I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Separadores.cronograma_pagos').upcase,
        :text_color => '000000',
        :font_size => 9,
        :width => 510,
        :align => :center,
        :style => :bold

      pdf.move_down(10)
          
      unless datos_cronograma_pagos.nil? || datos_cronograma_pagos.empty?
        pdf.table(datos_cronograma_pagos,
          :row_colors => ["F0F0F0", "FFFFCC"],
          :cell_style => {:borders => [:left, :right, :top, :bottom], 
                          :border_widths => [0.5, 0.5, 0.5, 0.5],
                          :font_style => :bold,
                          :size => 7, :overflow => :shrink_to_fit},

          :width => 510,
          :header => true,
          :column_widths  => {0 => 50, 1 => 30, 2 => 50, 3 => 50, 4 =>50, 5 => 40, 6 => 60, 7 => 45, 8 => 45, 9 => 45, 10=>45})
      else
        pdf.text I18n.t('Sistema.Body.General.no_hay_cronograma').upcase,
          :text_color => '1E90FF',
          :size => 7,
          :width => 510,
          :align => :center,
          :style => :bold
      end   
                   
      pdf.move_down(10)
      
      pdf.text I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Separadores.ordenes_despacho_confirmadas').upcase,
        :text_color => '000000',
        :font_size => 9,
        :width => 510,
        :align => :center,
        :style => :bold

      pdf.move_down(10)
          
      unless datos_orden_despacho.empty?
        pdf.table(datos_orden_despacho,
          :row_colors => ["F0F0F0", "FFFFCC"],
          :cell_style => {:borders => [:left, :right, :top, :bottom], 
                          :border_widths => [0.5, 0.5, 0.5, 0.5],
                          :font_style => :bold, 
                          :size => 7, :overflow => :shrink_to_fit},
          :width => 510,
          :header => true,
          :column_widths  => {0 => 70, 1 => 70, 2 => 90, 3 => 70, 4 =>70, 5 => 70, 6 => 70})
      else
      
        pdf.text I18n.t('Sistema.Body.General.no_hay_ordenes_confirmadas').upcase,
          :text_color => '1E90FF',
          :font_size => 3,
          :width => 510,
          :align => :center,
          :style => :bold
      end
          
      pdf.move_down(20)

      pdf.text I18n.t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Separadores.estadisticas').upcase,                                               #{t('Sistema.Body.Vistas.ConsultaPrestamoSituacion.Separadores.montos_recuperados').upcase}",
        :text_color => '000000',
        :font_size => 9,
        :width => 510,
        :align => :center,
        :font_style => :bold,
        :border => 1
      
      pdf.move_down(10)
      
      pdf.table datos_estadisticas,
        :row_colors => ["F0F0F0", "FFFFCC"],
        :cell_style => {:borders => [:left, :right, :top, :bottom], 
                        :border_widths => [0.5, 0.5, 0.5, 0.5],
                        :font_style => :bold,
                        :size => 8, :overflow => :shrink_to_fit},
        :width => 500,
        :column_widths => {0 => 125, 1 => 125, 2 => 125, 3 => 125}
          
        
      pdf.move_down(30)
      pdf.bounding_box([5,75], :width => 530, :height => 75, :border_width=>0.2) do
        
        pdf.stroke_bounds
        
        pdf.move_down(20)
        
        pdf.text_box I18n.t('Sistema.Body.General.importante').upcase,
          :text_color => '000000',
          :size => 9,
          :at => [10,60],
          :width => 510,
          :align => :center,
          :style => :bold,
          :border_width => 0.5
          
       pdf.move_down(5)
       
       pdf.text_box I18n.t('Sistema.Body.General.texto_cobranzas'),
        :text_color => '000000',
        :at => [10,50],
        :size => 6,
        :width => 510,
        :align => :left,
        :style => :bold,
        :overflow => :shrink_to_fit,
        :border_width => 0.5
        
      end

      # Green page numbers 1 to 7
      options = { :at => [bounds.right - 150, 0],
                  :width => 150,
                  :align => :right,
                  :page_filter => (1..7),
                  :start_count_at => 1,
                  :color => "007700" }

      pdf.number_pages string, options

      logger.info "PDF ============> #{pdf.inspect}"
    end
      #pdf.render_file "#{Rails.root}/public/documentos/pdf/#{archivo}"
      #send_file "#{Rails.root}/public/documentos/pdf/#{archivo}"

    #@archivo = "estado_cuenta_#{Time.now.strftime("%Y%m%d%H%M%S")}.pdf"
    #render nothing: true
  #end
