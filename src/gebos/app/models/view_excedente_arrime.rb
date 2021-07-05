# encoding: utf-8

#
# autor: Marvin Alfonzo
# clase: ViewExcedenteArrime
# descripcion: Migracion a Rails 3




require 'rubygems'
require 'fastercsv'
require 'csv'

class ViewExcedenteArrime < ActiveRecord::Base

self.table_name = 'view_excedente_arrime'
  
attr_accessible :oficina_id,
                :beneficiario,
                :email,
                :cedula_rif,
                :solicitud_id,
                :nro_tramite,
                :unidad_produccion_id,
                :ciudad_id,
                :ciudad,
                :estado_id,
                :estado,
                :sector_id,
                :sector,
                :rubro,
                :rubro_id,
                :estatus,
                :monto_banco,
                :monto_liquidado,
                :prestamo_id,
                :nro_prestamo,
                :orden_abono_excedente_arrime_id,
                :monto_abono,
                :estatus_excedente,
                :fecha_envio,
                :fecha_envio_banco,
                :fecha_valor,
                :fecha_abono_cuenta,
                :tipo_cheque,
                :referencia,
                :fecha_registro_cheque,
                :tipo,
                :numero_cuenta,
                :banco,
                :cod_swift,
                :entidad_financiera_id,
                :sub_rubro,
                :sub_rubro_id,
                :actividad,
                :actividad_id,
                :sub_sector_id

  @transaccion_id = 0

  def ViewExcedenteArrime.iniciar_transaccion(nombre_transaccion,usuario)


    logger.info "NOMBRE TRANSACCION #{nombre_transaccion}"
    logger.info "USUARIO #{usuario.inspect.to_s}"
    
    fecha = Time.now
    meta = MetaTransaccion.find_by_nombre(nombre_transaccion)
   
    transaccion = Transaccion.new
    
    transaccion.prestamo_id = 0
    transaccion.meta_transaccion_id = meta.id
    transaccion.usuario_id = usuario
    transaccion.fecha = fecha
    transaccion.tipo = 'L'
    transaccion.descripcion = meta.descripcion
    transaccion.monto = 0
    transaccion.save
    
    logger.debug "Errores >>>>>>> " << transaccion.errors.full_messages.to_s << " clase " << transaccion.errors.full_messages.class.to_s
    if transaccion.errors.full_messages.length > 0 
      @msg = transaccion.errors.full_messages.to_s      
      return @msg
    else
      @transaccion_id = transaccion.id
      return @transaccion_id
    end
  
  end


  def generar_transferencias(entidad_financiera_id, tipo_archivo, condiciones, cuenta_bcv_fondas, fecha_valor,items)

    logger.debug 'Entrando GenerarTransferencia DE RAFAEL=====> ' << entidad_financiera_id.to_s
    logger.info 'entidad_financiera_id ===>' << entidad_financiera_id.to_s
    logger.info 'tipo_archivo =>' << tipo_archivo.to_s
    logger.info 'condiciones =>' << condiciones.to_s
    logger.info 'cuenta_bcv_fondas =>' << cuenta_bcv_fondas.to_s
    logger.info 'fecha_valor =>' << fecha_valor.to_s
    logger.info 'items =>' << items.to_s

    case entidad_financiera_id.to_i

      when 8
                  logger.debug 'Ingreso en el 8 =====> '
                  generar_archivo_vzla(tipo_archivo, condiciones, cuenta_bcv_fondas, fecha_valor,items)
      when 465

                  logger.debug 'Ingreso en el 465  ==== => BANCO BICENTENARIO '
                  #self.generar_archivo_vzla(tipo_archivo, condiciones, cuenta_bcv_fondas, fecha_valor,items)
    end

  end
  
  
  def generar_archivo_vzla(tipo_archivo, condiciones, cuenta_bcv_fondas, fecha_valor,items)

      nro_lote = ''       
        
        fecha_valor_formato =format_fecha_conversion(fecha_valor)
        
  ##### ==========CONDICION SI ES GENERACION DEL ARCHIVO POR SELECCION SEGUN FILTRO, ES DECIR EL PRIMER BOTON==============
      if items==''

        nombre =I18n.t('Sistema.Body.Modelos.Desembolso.Txt.nombre_archivo_excedente_arrime') + Time.now.strftime("#{I18n.t('time.formats.gebos_txt_banco')}") + Time.now.strftime("-#{I18n.t('time.formats.hora_banco')}")
        @total = ViewExcedenteArrime.count(:conditions=>condiciones)
        logger.info "CONTADOR=======>"  << @total.to_s
        @valores = ViewExcedenteArrime.find_by_sql("select * from view_excedente_arrime where " << condiciones)
        logger.info "VALORESS==========>>" << @valores.inspect
        logger.info "CLASE DE VSLORES===>" << @valores.class.to_s
        @cuenta_fondas = CuentaBcv.find_by_numero(cuenta_bcv_fondas)
        entidad_financiera_id = @cuenta_fondas.entidad_financiera_id

        if tipo_archivo == "txt"
            documento = 'public/documentos/finanzas/abono_excedente/' << nombre << '.txt'
            logger.info "tipo_archivo " << tipo_archivo
            logger.info "documento " << documento
            
            CSV.open(documento,'w+',{:col_sep => "|" , :row_sep => "\r\n"}) do |csv|

              datos =''
              @contador = 0

              @nro_lote = ParametroGeneral.find(1)
              nro_lote = @nro_lote.nro_lote
              datos << ('0' * (8 - (@nro_lote.nro_lote.to_i + 1).to_s.length)) << (@nro_lote.nro_lote.to_i + 1).to_s
              @nro_lote.nro_lote = datos
              @nro_lote.save

              @header ="#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.header')}" + nro_lote.to_s + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.codigo_excel')}" + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.codigo')}" + fecha_valor + format_fecha(Time.now)

              logger.debug "header " << @header.inspect

              csv << @header.gsub(34.chr,'').parse_csv #imprimiendo linea

              @total_monto=0.00

              begin

                logger.info "TOTAL ============> " << @total.to_s
                while( @contador < @total)

                  logger.info "VALORESS========>>" << @valores[@contador].inspect
                  logger.info "CONTADORR=====>" << @contador.to_s

                  if(@valores[@contador].tipo == 'C')
                    tipo_cuenta_bef = '00'
                  else
                    tipo_cuenta_bef = '01'
                  end

                  if(@cuenta_fondas.tipo == 'C')
                    tipo_cuenta_fon = '00'
                  else
                    tipo_cuenta_fon = '01'
                  end

                  if (@valores[@contador].numero_cuenta[0,4] == '0102')
                    tipo_pago_bef = '10'
                  else
                    tipo_pago_bef = '00'
                  end


                  debito_monto = @valores[@contador].monto_abono.nil? ? format_f('0') : format_f(@valores[@contador].monto_abono)
                  credito_monto = @valores[@contador].monto_abono.nil? ? format_f('0') : format_f(@valores[@contador].monto_abono)

                  nro_solicitud = ('0' * (8 - @valores[@contador].nro_tramite.to_s.length)) + @valores[@contador].nro_tramite.to_s
                  nro_cuenta_fon = ('0' * (20 - cuenta_bcv_fondas.to_s.length)) + cuenta_bcv_fondas.to_s
                  monto_debito = ('0' * (18 - debito_monto.to_s.length)) + debito_monto.to_s #verificar si los montos necesitan los to_s

                  if(@valores[@contador].cedula_rif[0,1] == I18n.t('Sistema.Body.General.TipoDocumento.venezolano') || @valores[@contador].cedula_rif[0,1] == I18n.t('Sistema.Body.General.TipoDocumento.extranjero'))
                    @valores[@contador].cedula_rif.gsub!(' ', '')
                    cedula_rif = @valores[@contador].cedula_rif[0,1]+('0' * (9 - (@valores[@contador].cedula_rif[1,9]).to_s.length)) + (@valores[@contador].cedula_rif[1,9]).to_s
                  else
                    cedula_rif = ('0' * (10 - (@valores[@contador].cedula_rif[0,1]+@valores[@contador].cedula_rif[2,8]+@valores[@contador].cedula_rif[11,1]).to_s.length)) + (@valores[@contador].cedula_rif[0,1]+@valores[@contador].cedula_rif[2,8]+@valores[@contador].cedula_rif[11,1]).to_s
                  end

                  nombre_beneficiario =   @valores[@contador].beneficiario.to_s[0,29]
                  nombre_beneficiario = nombre_beneficiario + (" " * (30 - nombre_beneficiario.to_s.length))

                  nro_cuenta_bef = ('0' * (20 - @valores[@contador].numero_cuenta.to_s.length)) + @valores[@contador].numero_cuenta.to_s
                  monto_credito = ('0' * (18 - credito_monto.to_s.length)) + credito_monto.to_s
                  cod_swift = ('0' * (12 - @valores[@contador].cod_swift.to_s.length)) + @valores[@contador].cod_swift.to_s
                  email_bef =  @valores[@contador].email.to_s + (" " * (50 - @valores[@contador].email.to_s.length))

                  @debito ="#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.debito')}" + nro_solicitud + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.codigo')}" + I18n.t('Sistema.Body.Modelos.Desembolso.Txt.nombre') + fecha_valor + tipo_cuenta_fon + nro_cuenta_fon + monto_debito + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.veb')}" + '40'
                  @credito ="#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.credito')}" + nro_solicitud + cedula_rif + nombre_beneficiario + tipo_cuenta_bef + nro_cuenta_bef + monto_credito + tipo_pago_bef + cod_swift + '000' + '0000' + email_bef
                  @total_monto = @total_monto + credito_monto.to_f  # sumando los monto de los creditos realizados

                  csv << @debito.gsub(34.chr,'').parse_csv  #imprimiendo linea
                  csv << @credito.gsub(34.chr,'').parse_csv   #imprimiendo linea

                  logger.debug "debito " << @debito.inspect
                  logger.debug "credito " << @credito.inspect
                  logger.debug "CSV ========> " << csv.inspect
                  @contador += 1

                end
                rescue Exception => x
                  logger.error x.message
                  logger.error x.backtrace.join("\n")
                  return false
                end

                valor =format_f(@total_monto)

                cantidad_debito = ('0' * (5 - @total.to_s.length)) + @total.to_s
                cantidad_credito = ('0' * (5 - @total.to_s.length)) + @total.to_s

                total_monto_lote = ('0' * (18 - valor.to_s.length)) + valor.to_s
                @totales ="#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.total')}" + cantidad_debito + cantidad_credito + total_monto_lote
                csv << @totales.gsub(34.chr,'').parse_csv #imprimiendo linea

                logger.debug "MONTOSSSSS======>>>>>>>"  << valor.inspect
              end

              @control = ControlEnvioAbonoExcedenteCosecha.new(:fecha=>Time.now, :archivo=>nombre + '.txt', :estatus=>1, :numero_procesado=>@total, :monto_procesado=>@total_monto, :entidad_financiera_id=>entidad_financiera_id, :numero_lote=>nro_lote)
              @control.save
              @control_id = @control.id

              logger.info "Control =====> " << @valores.inspect
              puts "Documento ====> " << documento.to_s

              @contador = 0

             begin
                  transaction do
                      while( @contador < @total)
                        unless @valores[@contador].orden_abono_excedente_arrime_id.nil?
                             @orden_abono_excedente_arrime = OrdenAbonoExcedenteArrime.find(@valores[@contador].orden_abono_excedente_arrime_id)
                             @orden_abono_excedente_arrime.estatus_id = 30050
                             @orden_abono_excedente_arrime.fecha_envio_banco = Time.now
                             @orden_abono_excedente_arrime.fecha_valor = fecha_valor_formato
                             @orden_abono_excedente_arrime.entidad_financiera_liquidadora_id = @cuenta_fondas.entidad_financiera_id
                             @orden_abono_excedente_arrime.numero_cuenta_liquidadora = @cuenta_fondas.numero
                             @orden_abono_excedente_arrime.entidad_financiera_cliente_id = @valores[@contador].entidad_financiera_id
                             @orden_abono_excedente_arrime.numero_cuenta_cliente = @valores[@contador].numero_cuenta
                             @orden_abono_excedente_arrime.numero_lote = nro_lote
                             @orden_abono_excedente_arrime.save
                        end
                        @contador+= 1
                      end
                  end
                  rescue Exception => x
                  logger.error x.message
                  logger.error x.backtrace.join("\n")
                  return false
              end

              #@control = ControlEnvioDesembolso.find(@control_id)
              #@control.estatus = 2
              #@control.save

        else #======================================GENERANDO EL ARCHIVO  EXCEL SEGUN FILTRO=================================

          documento = 'public/documentos/finanzas/abono_excedente/' << nombre << '.csv'
          CSV.open(documento,'w+',{:col_sep => "·" , :row_sep => "\r\n"}) do |csv|

          datos =''
          @contador = 0

          @nro_lote = ParametroGeneral.find(1)
          nro_lote = @nro_lote.nro_lote
          datos << ('0' * (8 - (@nro_lote.nro_lote.to_i + 1).to_s.length)) << (@nro_lote.nro_lote.to_i + 1).to_s
          @nro_lote.nro_lote = datos
          @nro_lote.save

          @header ="#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.header')}" + ';' + nro_lote.to_s + ';' + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.codigo_excel')}" + ';' + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.codigo')}" + ';' + fecha_valor + ';' + format_fecha(Time.now)

          csv << @header.sub(34.chr,'').parse_csv #imprimiendo linea

          @total_monto=0.00
          while( @contador < @total)
            if(@valores[@contador].tipo == 'C')
                tipo_cuenta_bef = '00'
            else
                tipo_cuenta_bef = '01'
            end
            if(@cuenta_fondas.tipo == 'C')
                tipo_cuenta_fon = '00'
            else
                tipo_cuenta_fon = '01'
            end

            if (@valores[@contador].numero_cuenta[0,4] == '0102')
                tipo_pago_bef = '10'
            else
                tipo_pago_bef = '00'
            end
            
            debito_monto = @valores[@contador].monto_abono.nil? ? format_f('0') : format_f(@valores[@contador].monto_abono)
            credito_monto = @valores[@contador].monto_abono.nil? ? format_f('0') : format_f(@valores[@contador].monto_abono)

            nro_solicitud = ('0' * (8 - @valores[@contador].nro_tramite.to_s.length)) + @valores[@contador].nro_tramite.to_s
            nro_cuenta_fon = ('0' * (20 - cuenta_bcv_fondas.to_s.length)) + cuenta_bcv_fondas.to_s
            monto_debito = ('0' * (18 - debito_monto.to_s.length)) + debito_monto.to_s #verificar si los montos necesitan los to_s

            if(@valores[@contador].cedula_rif[0,1] == I18n.t('Sistema.Body.General.TipoDocumento.venezolano') || @valores[@contador].cedula_rif[0,1] == I18n.t('Sistema.Body.General.TipoDocumento.extranjero'))

                cedula_rif = @valores[@contador].cedula_rif[0,1]+('0' * (9 - (@valores[@contador].cedula_rif[1,10]).to_s.length)) + (@valores[@contador].cedula_rif[1,10]).to_s

            else

                cedula_rif = ('0' * (10 - (@valores[@contador].cedula_rif[0,1]+@valores[@contador].cedula_rif[2,8]+@valores[@contador].cedula_rif[11,1]).to_s.length)) + (@valores[@contador].cedula_rif[0,1]+@valores[@contador].cedula_rif[2,8]+@valores[@contador].cedula_rif[11,1]).to_s

            end

            nombre_beneficiario =   @valores[@contador].beneficiario.to_s + (" " * (30 - @valores[@contador].beneficiario.to_s.length))

            nro_cuenta_bef = ('0' * (20 - @valores[@contador].numero_cuenta.to_s.length)) + @valores[@contador].numero_cuenta.to_s
            monto_credito = ('0' * (18 - credito_monto.to_s.length)) + credito_monto.to_s
            cod_swift = ('0' * (12 - @valores[@contador].cod_swift.to_s.length)) + @valores[@contador].cod_swift.to_s
            email_bef =  @valores[@contador].email.to_s + (" " * (50 - @valores[@contador].email.to_s.length))


            @debito = "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.debito')}" + ';' + nro_solicitud + ';' +  "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.codigo')}" + ';' + I18n.t('Sistema.Body.Modelos.Desembolso.Txt.nombre') + ';' + fecha_valor + ';' + tipo_cuenta_fon + ';' + nro_cuenta_fon + ';' + monto_debito + ';' + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.veb')}" + ';' + '40'
            @credito ="#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.credito')}" + ';' + nro_solicitud + ';' + cedula_rif + ';' + nombre_beneficiario + ';' + tipo_cuenta_bef + ';' + nro_cuenta_bef + ';' + monto_credito + ';' + tipo_pago_bef + ';' + cod_swift + ';' + '000' + ';' + '0000' + ';' + email_bef
            @total_monto = @total_monto + @valores[@contador].monto_abono.to_f  # sumando los monto de los creditos realizados

            csv << @debito.sub(34.chr,'').parse_csv  #imprimiendo linea
            csv << @credito.sub(34.chr,'').parse_csv   #imprimiendo linea
            @contador += 1

          end

          valor = format_f(@total_monto)

          cantidad_debito = ('0' * (5 - @total.to_s.length)) + @total.to_s
          cantidad_credito = ('0' * (5 - @total.to_s.length)) + @total.to_s

          total_monto_lote = ('0' * (18 - valor.to_s.length)) + valor.to_s

          @totales= "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.total')}" + ';' + cantidad_debito + ';' + cantidad_credito + ';' + total_monto_lote

          csv << @totales.sub(34.chr,'').parse_csv   #imprimiendo linea
        end


        @control = ControlEnvioAbonoExcedenteCosecha.new(:fecha=>Time.now, :archivo=>nombre + '.csv', :estatus=>1, :numero_procesado=>@total, :monto_procesado=>@total_monto, :entidad_financiera_id=>entidad_financiera_id, :numero_lote=>nro_lote)
        @control.save
        @control_id = @control.id

        logger.info "Control =====> " << @valores.inspect
        puts "Documento ====> " << documento.to_s

        @contador = 0

       begin
            transaction do
                while( @contador < @total)
                  unless @valores[@contador].orden_abono_excedente_arrime_id.nil?
                       @orden_abono_excedente_arrime = OrdenAbonoExcedenteArrime.find(@valores[@contador].orden_abono_excedente_arrime_id)
                       @orden_abono_excedente_arrime.estatus_id = 30050
                       @orden_abono_excedente_arrime.fecha_envio_banco = Time.now
                       @orden_abono_excedente_arrime.fecha_valor = fecha_valor_formato
                       @orden_abono_excedente_arrime.entidad_financiera_liquidadora_id = @cuenta_fondas.entidad_financiera_id
                       @orden_abono_excedente_arrime.numero_cuenta_liquidadora = @cuenta_fondas.numero
                       @orden_abono_excedente_arrime.entidad_financiera_cliente_id = @valores[@contador].entidad_financiera_id
                       @orden_abono_excedente_arrime.numero_cuenta_cliente = @valores[@contador].numero_cuenta
                       @orden_abono_excedente_arrime.numero_lote = nro_lote
                       @orden_abono_excedente_arrime.save
                  end
                  @contador+= 1
                end
            end
            rescue Exception => x
            logger.error x.message
            logger.error x.backtrace.join("\n")
            return false
        end

        #@control = ControlEnvioDesembolso.find(@control_id)
        #@control.estatus = 2
        #@control.save
        
      end
  #CONDICION CUANDO SI EXITEN LOS ITEMS
      else

  ##### AQUI EMPIEZA EL ELSE DE LA MEGA CONDICION DEL ITEM

    item_aux=items.split(',')
    item_formateado=''
    fre=0
    while (fre<item_aux.length)
      if (item_aux[fre]!='')
        item_formateado+=item_aux[fre]+','
      end
      fre+=1
    end

    if item_aux.length > 0
      item_formateado=item_formateado[0,(item_formateado.length)-1]
    end


      otra_condicion=condiciones + ' and orden_abono_excedente_arrime_id in (' + item_formateado + ')'

      logger.info "OTRA CONDICION ========> " << otra_condicion.to_s
      nombre =I18n.t('Sistema.Body.Modelos.Desembolso.Txt.nombre_archivo_excedente_arrime') + Time.now.strftime("#{I18n.t('time.formats.gebos_txt_banco')}") + Time.now.strftime("-#{I18n.t('time.formats.hora_banco')}")

      @total = ViewExcedenteArrime.count(:conditions=>otra_condicion)

      @valores = ViewExcedenteArrime.find_by_sql("select * from view_excedente_arrime where " << otra_condicion)

      @cuenta_fondas = CuentaBcv.find_by_numero(cuenta_bcv_fondas)
      entidad_financiera_id = @cuenta_fondas.entidad_financiera_id

     #============================ TXT SEGUN SELECCION=====================================================


     if tipo_archivo == "txt"

        documento = 'public/documentos/finanzas/abono_excedente/' << nombre << '.txt'
        CSV.open(documento,'w+',{:col_sep => "·" , :row_sep => "\r\n"}) do |csv|
          datos =''
          @contador = 0

          @nro_lote = ParametroGeneral.find(1)
          nro_lote = @nro_lote.nro_lote
          datos << ('0' * (8 - (@nro_lote.nro_lote.to_i + 1).to_s.length)) << (@nro_lote.nro_lote.to_i + 1).to_s
          @nro_lote.nro_lote = datos
          @nro_lote.save

          @header ="#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.header')}" + nro_lote.to_s + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.codigo_excel')}" + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.codigo')}" + fecha_valor + format_fecha(Time.now)
          csv << @header.sub(34.chr,'').parse_csv  #imprimiendo linea

          @total_monto=0.00
          while( @contador < @total)
            logger.info "BUSCANDO TIPO DE CUENTA "
            if(@valores[@contador].tipo == 'C')
              tipo_cuenta_bef = '00'
            else
              tipo_cuenta_bef = '01'
            end

            if(@cuenta_fondas.tipo == 'C')
              tipo_cuenta_fon = '00'
            else
              tipo_cuenta_fon = '01'
            end

            if (@valores[@contador].numero_cuenta[0,4] == '0102')
              tipo_pago_bef = '10'
            else
              tipo_pago_bef = '00'
            end

            debito_monto = @valores[@contador].monto_abono.nil? ? format_f('0') : format_f(@valores[@contador].monto_abono)
            credito_monto = @valores[@contador].monto_abono.nil? ? format_f('0') : format_f(@valores[@contador].monto_abono)
            nro_solicitud = ('0' * (8 - @valores[@contador].nro_tramite.to_s.length)) + @valores[@contador].nro_tramite.to_s
            nro_cuenta_fon = ('0' * (20 - cuenta_bcv_fondas.to_s.length)) + cuenta_bcv_fondas.to_s
            monto_debito = ('0' * (18 - debito_monto.to_s.length)) + debito_monto.to_s #verificar si los montos necesitan los to_s

            if(@valores[@contador].cedula_rif[0,1] == I18n.t('Sistema.Body.General.TipoDocumento.venezolano') || @valores[@contador].cedula_rif[0,1] == I18n.t('Sistema.Body.General.TipoDocumento.extranjero'))
                @valores[@contador].cedula_rif.gsub!(' ', '')
                cedula_rif = @valores[@contador].cedula_rif[0,1]+('0' * (9 - (@valores[@contador].cedula_rif[1,9]).to_s.length)) + (@valores[@contador].cedula_rif[1,9]).to_s
            else
                cedula_rif = ('0' * (10 - (@valores[@contador].cedula_rif[0,1]+@valores[@contador].cedula_rif[2,8]+@valores[@contador].cedula_rif[11,1]).to_s.length)) + (@valores[@contador].cedula_rif[0,1]+@valores[@contador].cedula_rif[2,8]+@valores[@contador].cedula_rif[11,1]).to_s
            end

            nombre_beneficiario =   @valores[@contador].beneficiario.to_s[0,29]
            nombre_beneficiario = nombre_beneficiario + (" " * (30 - nombre_beneficiario.to_s.length))

            nro_cuenta_bef = ('0' * (20 - @valores[@contador].numero_cuenta.to_s.length)) + @valores[@contador].numero_cuenta.to_s
            monto_credito = ('0' * (18 - credito_monto.to_s.length)) + credito_monto.to_s
            cod_swift = ('0' * (12 - @valores[@contador].cod_swift.to_s.length)) + @valores[@contador].cod_swift.to_s
            email_bef =  @valores[@contador].email.to_s + (" " * (50 - @valores[@contador].email.to_s.length))

            @debito = "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.debito')}" + nro_solicitud +  "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.codigo')}" + I18n.t('Sistema.Body.Modelos.Desembolso.Txt.nombre') + fecha_valor + tipo_cuenta_fon + nro_cuenta_fon + monto_debito + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.veb')}" + '40'
            @credito ="#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.credito')}" + nro_solicitud + cedula_rif + nombre_beneficiario + tipo_cuenta_bef + nro_cuenta_bef + monto_credito + tipo_pago_bef + cod_swift + '000' + '0000' + email_bef
            @total_monto = @total_monto  + @valores[@contador].monto_abono.to_f  # sumando los monto de los creditos realizados

            logger.debug "TOTAL-MONTO============>>>>>>>" << @total_monto.to_s
            csv << @debito.sub(34.chr,'').parse_csv  #imprimiendo linea
            csv << @credito.sub(34.chr,'').parse_csv   #imprimiendo linea
            @contador += 1

          end

          valor = format_f(@total_monto)
          cantidad_debito = ('0' * (5 - @total.to_s.length)) + @total.to_s
          cantidad_credito = ('0' * (5 - @total.to_s.length)) + @total.to_s
          total_monto_lote = ('0' * (18 - valor.to_s.length)) + valor.to_s
          @totales= "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.total')}" + cantidad_debito + cantidad_credito + total_monto_lote
          csv << @totales.sub(34.chr,'').parse_csv   #imprimiendo linea
        end

        @control = ControlEnvioAbonoExcedenteCosecha.new(:fecha=>Time.now, :archivo=>nombre + '.txt', :estatus=>1, :numero_procesado=>@total, :monto_procesado=>@total_monto, :entidad_financiera_id=>entidad_financiera_id, :numero_lote=>nro_lote)
        @control.save
        @control_id = @control.id
        
        logger.info "Control =====> " << @valores.inspect
        puts "Documento ====> " << documento.to_s

        @contador = 0

       begin
            transaction do
                while( @contador < @total)
                  unless @valores[@contador].orden_abono_excedente_arrime_id.nil?
                       @orden_abono_excedente_arrime = OrdenAbonoExcedenteArrime.find(@valores[@contador].orden_abono_excedente_arrime_id)
                       @orden_abono_excedente_arrime.estatus_id = 30050
                       @orden_abono_excedente_arrime.fecha_envio_banco = Time.now
                       @orden_abono_excedente_arrime.fecha_valor = fecha_valor_formato
                       @orden_abono_excedente_arrime.entidad_financiera_liquidadora_id = @cuenta_fondas.entidad_financiera_id
                       @orden_abono_excedente_arrime.numero_cuenta_liquidadora = @cuenta_fondas.numero
                       @orden_abono_excedente_arrime.entidad_financiera_cliente_id = @valores[@contador].entidad_financiera_id
                       @orden_abono_excedente_arrime.numero_cuenta_cliente = @valores[@contador].numero_cuenta
                       @orden_abono_excedente_arrime.numero_lote = nro_lote
                       @orden_abono_excedente_arrime.save
                  end
                  @contador+= 1
                end
            end
            rescue Exception => x
            logger.error x.message
            logger.error x.backtrace.join("\n")
            return false
        end

        #@control = ControlEnvioDesembolso.find(@control_id)
        #@control.estatus = 2
        #@control.save

     else #=====================GENERANDO EL ARCHIVO  EXCEL SEGUN SELECCION=============================

       documento = 'public/documentos/finanzas/abono_excedente/' << nombre << '.csv'
       CSV.open(documento,'w+',{:col_sep => "·" , :row_sep => "\r\n"}) do |csv|

          datos =''
          @contador = 0
          #fecha_valor= '10/09/2011'
          @nro_lote = ParametroGeneral.find(1)
          nro_lote = @nro_lote.nro_lote
          datos << ('0' * (8 - (@nro_lote.nro_lote.to_i + 1).to_s.length)) << (@nro_lote.nro_lote.to_i + 1).to_s
          @nro_lote.nro_lote = datos
          @nro_lote.save

          @header ="#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.header')}" + ';' + nro_lote.to_s + ';' + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.codigo_excel')}" + ';' + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.codigo')}" + ';' + fecha_valor + ';' + format_fecha(Time.now)

          csv << @header.sub(34.chr,'').parse_csv #imprimiendo linea

          @total_monto=0.00
        while( @contador < @total)

            if(@valores[@contador].tipo == 'C')

              tipo_cuenta_bef = '00'
            else
              tipo_cuenta_bef = '01'
            end

             if(@cuenta_fondas.tipo == 'C')

              tipo_cuenta_fon = '00'
            else
              tipo_cuenta_fon = '01'
            end

            if (@valores[@contador].numero_cuenta[0,4] == '0102')
              tipo_pago_bef = '10'
            else
              tipo_pago_bef = '00'
            end


          debito_monto = @valores[@contador].monto_abono.nil? ? format_f('0') : format_f(@valores[@contador].monto_abono)
          credito_monto = @valores[@contador].monto_abono.nil? ? format_f('0') : format_f(@valores[@contador].monto_abono)

          nro_solicitud = ('0' * (8 - @valores[@contador].nro_tramite.to_s.length)) + @valores[@contador].nro_tramite.to_s
          nro_cuenta_fon = ('0' * (20 - cuenta_bcv_fondas.to_s.length)) + cuenta_bcv_fondas.to_s
          monto_debito = ('0' * (18 - debito_monto.to_s.length)) + debito_monto.to_s #verificar si los montos necesitan los to_s

          if(@valores[@contador].cedula_rif[0,1] == I18n.t('Sistema.Body.General.TipoDocumento.venezolano') || @valores[@contador].cedula_rif[0,1] == I18n.t('Sistema.Body.General.TipoDocumento.extranjero'))
            @valores[@contador].cedula_rif.gsub!(' ', '')
            cedula_rif = @valores[@contador].cedula_rif[0,1]+('0' * (9 - (@valores[@contador].cedula_rif[1,9]).to_s.length)) + (@valores[@contador].cedula_rif[1,9]).to_s
          else
            cedula_rif = ('0' * (10 - (@valores[@contador].cedula_rif[0,1]+@valores[@contador].cedula_rif[2,8]+@valores[@contador].cedula_rif[11,1]).to_s.length)) + (@valores[@contador].cedula_rif[0,1]+@valores[@contador].cedula_rif[2,8]+@valores[@contador].cedula_rif[11,1]).to_s
          end

          nombre_beneficiario =   @valores[@contador].beneficiario.to_s + (" " * (30 - @valores[@contador].beneficiario.to_s.length))

          nro_cuenta_bef = ('0' * (20 - @valores[@contador].numero_cuenta.to_s.length)) + @valores[@contador].numero_cuenta.to_s
          monto_credito = ('0' * (18 - credito_monto.to_s.length)) + credito_monto.to_s
          cod_swift = ('0' * (12 - @valores[@contador].cod_swift.to_s.length)) + @valores[@contador].cod_swift.to_s
          email_bef =  @valores[@contador].email.to_s + (" " * (50 - @valores[@contador].email.to_s.length))


          @debito = "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.debito')}" + ';' + nro_solicitud + ';' +  "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.codigo')}" + ';' + I18n.t('Sistema.Body.Modelos.Desembolso.Txt.nombre') + ';' + fecha_valor + ';' + tipo_cuenta_fon + ';' + nro_cuenta_fon + ';' + monto_debito + ';' + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.veb')}" + ';' + '40'
          @credito ="#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.credito')}" + ';' + nro_solicitud + ';' + cedula_rif + ';' + nombre_beneficiario + ';' + tipo_cuenta_bef + ';' + nro_cuenta_bef + ';' + monto_credito + ';' + tipo_pago_bef + ';' + cod_swift + ';' + '000' + ';' + '0000' + ';' + email_bef
          @total_monto = @total_monto + @valores[@contador].monto_abono.to_f  # sumando los monto de los creditos realizados

          csv << @debito.sub(34.chr,'').parse_csv  #imprimiendo linea
          csv << @credito.sub(34.chr,'').parse_csv   #imprimiendo linea
          @contador += 1

        end

        valor = format_f(@total_monto)
        cantidad_debito = ('0' * (5 - @total.to_s.length)) + @total.to_s
        cantidad_credito = ('0' * (5 - @total.to_s.length)) + @total.to_s
        total_monto_lote = ('0' * (18 - valor.to_s.length)) + valor.to_s
        @totales= "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.total')}" + ';' + cantidad_debito + ';' + cantidad_credito + ';' + total_monto_lote

        csv << @totales.sub(34.chr,'').parse_csv   #imprimiendo linea
        end
        
        @control = ControlEnvioAbonoExcedenteCosecha.new(:fecha=>Time.now, :archivo=>nombre + '.csv', :estatus=>1, :numero_procesado=>@total, :monto_procesado=>@total_monto, :entidad_financiera_id=>entidad_financiera_id, :numero_lote=>nro_lote)
        @control.save
        @control_id = @control.id

        logger.info "Control =====> " << @control.inspect

        puts "Documento ====> " << documento.to_s

        @contador = 0
       begin

            transaction do
                while( @contador < @total)
                  unless @valores[@contador].orden_abono_excedente_arrime_id.nil?
                       @orden_abono_excedente_arrime = OrdenAbonoExcedenteArrime.find(@valores[@contador].orden_abono_excedente_arrime_id)
                       @orden_abono_excedente_arrime.estatus_id = 30050
                       @orden_abono_excedente_arrime.fecha_envio_banco = Time.now
                       @orden_abono_excedente_arrime.fecha_valor = fecha_valor_formato
                       @orden_abono_excedente_arrime.entidad_financiera_liquidadora_id = @cuenta_fondas.entidad_financiera_id
                       @orden_abono_excedente_arrime.numero_cuenta_liquidadora = @cuenta_fondas.numero
                       @orden_abono_excedente_arrime.entidad_financiera_cliente_id = @valores[@contador].entidad_financiera_id
                       @orden_abono_excedente_arrime.numero_cuenta_cliente = @valores[@contador].numero_cuenta
                       @orden_abono_excedente_arrime.numero_lote = nro_lote
                       @orden_abono_excedente_arrime.save
                  end
                  @contador+= 1
                end
            end
            rescue Exception => x
            logger.error x.message
            logger.error x.backtrace.join("\n")
            return false

        end


      end


    end
  end
    

  def ViewExcedenteArrime.save_montos( archivo, fecha, usuario_id )
        logger.debug "parametros de save_montos en ViewExcedenteArrime " << archivo.to_s << " " << fecha.inspect.to_s << " " << usuario_id.to_s
    @total = 0
    @ids= ''
    @fecha_valor = '01/01/1900'
    @msg = []
    @monto_total_abonos = 0.00
    
    
    logger.info "TRANSACCION_ID ========> #{@transaccion_id.to_s}"
    if @msg.empty?
      logger.info "TRANSACCION_ID ========> #{@transaccion_id.to_s}"
    else
      return @msg
    end

    begin
    
      transaction do
      
        @transaccion_id = ViewExcedenteArrime.iniciar_transaccion('p_abono_excedente_arrime',usuario_id)
        logger.debug "llegue aqui >>>> " << archivo['datafile'].to_s 
        name = archivo[:datafile].original_filename.to_s
        
        unless name.nil? || name.empty?
          ext  =  name[(name.length - 3),name.length]
          
          unless ext == 'txt'
            @msg << I18n.t('Sistema.Body.Modelos.Desembolso.Errores.formato_txt_incorrecto')
            @clase = "error"
            if fecha==''
              @msg << I18n.t('Sistema.Body.Modelos.ViewExcedenteArrime.Errores.fecha_real_pago_excedente_requerida')
            end
            
          else       

            if fecha==''
              @msg << I18n.t('Sistema.Body.Modelos.ViewExcedenteArrime.Errores.fecha_real_pago_excedente_requerida')
              return
            end
            
            fecha =format_fecha_conversion(fecha)
            
            #fecha = (fecha[6,4].to_s << "-" << fecha[3,2].to_s << "-" << fecha[0,2].to_s) unless fecha.nil?            
            
            directory = "public/documentos/finanzas/confirmacion_abono_exedente/"
            count = 0
            path = File.join(directory, name)

            #File.open(path, "wb") { |f| f.write(archivo['datafile'].read) }
            File.open(path, "wb") { |file| file.write(archivo[:datafile].read) }
            count = 0

            File.foreach(path) do |row|

              count = count + 1
              contenido = row.gsub("\r\n", "").to_s
              contenido = contenido.gsub(/[áÁäÄ]/, 'a')
              contenido = contenido.gsub(/[éÉëË]/, 'e')
              contenido = contenido.gsub(/[íÍïÏ]/, 'i')
              contenido = contenido.gsub(/[óÓöÖ]/, 'o')
              contenido = contenido.gsub(/[úÚüÜ]/, 'u')
              contenido = contenido.gsub(/[ñÑ]/, 'ñ')
              contenido = contenido.gsub(/[#°ººÂÃ@]/, ' ')
              contenido = contenido.delete('"')
         

              #if row.to_s.gsub("\n", "").length == 199 || row.to_s.gsub("\n", "").length == 139 || row.to_s.gsub("\n", "").length == 250 || row.to_s.gsub("\n", "").length == 102 || row.to_s.gsub("\n", "").length == 87 || row.to_s.gsub("\n", "").length == 36
              if row.to_s.gsub("\r\n", "").length.to_s == "200" || row.to_s.gsub("\r\n", "").length.to_s == "138" || row.to_s.gsub("\r\n", "").length.to_s == "251" || row.to_s.gsub("\r\n", "").length.to_s == "103" || row.to_s.gsub("\r\n", "").length.to_s == "88" || row.to_s.gsub("\r\n", "").length.to_s == "37"
                
                if row.to_s.gsub("\r\n", "").length.to_s == "138"
                  @fecha_valor = contenido[34,10]
                  logger.debug "Fecha Valor ===>" << @fecha_valor
                  @fecha_valor1 = @fecha_valor.split("/")
                  logger.debug "Fecha Valor1 ===>" << @fecha_valor1.to_s         
                  @fecha_valor = @fecha_valor1[2].to_s + "/" + @fecha_valor1[1].to_s + "/" + @fecha_valor1[0].to_s
                  logger.debug "Fecha Valor ===>" << @fecha_valor
                    
                end
                    
                if row.to_s.gsub("\r\n", "").length == 251

                  nro_solicitud = contenido[8,8]
                  ci_rif = contenido[16,10]
                  monto = contenido[78,18]
                  status = contenido[167,4]
                  des_status = contenido[171,80]
                      
                      
                  if ci_rif[0,1] == I18n.t('Sistema.Body.General.TipoDocumento.juridico') || ci_rif[0,1] == I18n.t('Sistema.Body.General.TipoDocumento.gobierno')
                    ci_rif=ci_rif[0,1] << "-" << ci_rif[1,8] << "-" << ci_rif[9,1]
                  else
                    ci_rif= ci_rif[1,9]
                  end
                 
                  monto= monto.to_f/100
                   
                  result = true
                  
                  if status != 'VE6 '

                    result2 = false

                  else
                    result2 = true
                  end

                  if result and result2

                    #@total = @total + 1
                    cliente = Cliente.find_by_sql("select id from cliente where persona_id in (select id from persona where cedula = #{ci_rif.to_i})  or empresa_id in (select id from empresa where rif like '%#{ci_rif}')")
                    unless cliente.nil?
                    
                      logger.debug "cliente===>" << cliente[0].id.inspect << "nro " << nro_solicitud.inspect
                      solicitud = Solicitud.find_by_numero(nro_solicitud.to_i)
                      unless solicitud.nil? 
                                 
                        orden_abono_excedente_arrime = OrdenAbonoExcedenteArrime.find(:first, :conditions=>['solicitud_id = ? and fecha_valor = ? ',solicitud.id,@fecha_valor])
                          
                          
                        if !orden_abono_excedente_arrime.nil?
                          
                          if orden_abono_excedente_arrime.estatus_id == 30050
                          
                            orden_abono_excedente_arrime.estatus_id = 30100
                            orden_abono_excedente_arrime.fecha_abono_cuenta = fecha
                            orden_abono_excedente_arrime.save
                            orden_abono_excedente_arrime.contabilizar_pago_excedente(solicitud, monto,fecha,@transaccion_id,I18n.t('Sistema.Body.Modelos.ViewExcedenteArrime.Mensajes.abono_excedente_beneficiario'))
                            @total = @total + 1
                            @monto_total_abonos = @monto_total_abonos + monto
                            
                            # aqui guardo el historico
                            @control = ControlEnvioAbonoExcedenteCosecha.new()
                            @control.fecha = Time.now
                            @control.archivo = name
                            @control.estatus = 2
                            @control.numero_procesado = @total
                            @control.monto_procesado = @monto_total_abonos
                            #@control.entidad_financiera_id=>entidad_financiera_id)
                            @control.save
                            
                          else
                            @msg << I18n.t('Sistema.Body.Modelos.ViewExcedenteArrime.Errores.orden_abono_para_tramite_ya_fue_procesada',:numero=>solicitud.numero,:ci_rif=>ci_rif)
                          end     #Fin if orden_abono_excedente_arrime.estatus_id == 30050
                          
                        else
                          @msg << I18n.t('Sistema.Body.Modelos.ViewExcedenteArrime.Errores.no_existe_orden_abono_para_tramite',:numero=>solicitud.numero,:ci_rif=>ci_rif)
                        end     #Fin if !orden_abono_excedente_arrime.nil?
                  
                        if @ids.length > 0
                          @ids = @ids << ',' << solicitud.id.to_s
                        else
                          @ids = solicitud.id.to_s
                        end     #Fin if @ids.length > 0
                      else
                        @msg << "#{I18n.t('Sistema.Body.Modelos.Desembolso.Errores.la_solicitud')} #{count} #{I18n.t('Sistema.Body.Modelos.Desembolso.Errores.estatus_adecuado')}"
                      end       #Fin unless solicitud.nil?
                      
                      else
                        @msg << "#{I18n.t('Sistema.Body.Modelos.Desembolso.Errores.la_cedula')} #{count} #{I18n.t('Sistema.Body.Modelos.Desembolso.Errores.registrada_en_la_base_datos')}"
                      end   #Fin unless cliente.nil?
                      
                  end    # Fin  if result and result2     
                      
                  if result2 == false
                    
                    solicitud = Solicitud.find_by_numero(nro_solicitud.to_i)
                      
                    orden_abono_excedente_arrime = OrdenAbonoExcedenteArrime.find(:first, :conditions=>['solicitud_id = ? and fecha_valor = ? ',solicitud.id,@fecha_valor])
                      
                    if !orden_abono_excedente_arrime.nil?
                      orden_abono_excedente_arrime.estatus_id = 30150
                      orden_abono_excedente_arrime.save
                               
                      @rechazo = RechazoExcedenteAbonoArrime.new()
                               
                      @rechazo.fecha = fecha
                      @rechazo.archivo = name
                      @rechazo.prestamo_numero = orden_abono_excedente_arrime.prestamo.numero
                      @rechazo.solicitud_numero = orden_abono_excedente_arrime.solicitud.numero
                      @rechazo.cliente_id = orden_abono_excedente_arrime.solicitud.cliente_id
                      @rechazo.monto_pago = orden_abono_excedente_arrime.monto_abono
                      @rechazo.codigo_error = status
                      @rechazo.descripcion_error = des_status
                      @rechazo.entidad_financiera_id = orden_abono_excedente_arrime.entidad_financiera_liquidadora_id
                      @rechazo.procesado = false
                      @rechazo.save
                      @total = @total + 1
                               
                    else
                      @msg << I18n.t('Sistema.Body.Modelos.ViewExcedenteArrime.Errores.no_existe_orden_abono_para_tramite',:numero=>solicitud.numero,:ci_rif=>ci_rif)
                    end   #Fin if !orden_abono_excedente_arrime.nil?
                      
                  end   #Fin if result2 == false

                else
                  
  #               @msg << "La línea #{count} no tiene el formato adecuado."
                  result = false
                  logger.info "REsult ultimo al finalizar la actualizacion"
                      
                end   #Fin if row.to_s.length == 250
                  
                    logger.info "Resultadossssss =====> " << result.to_s << " " << result2.to_s
              else
                logger.debug "NO INGRESO============>>>>>" << row.to_s.gsub("\r\n", "") << "CANTIDAD " << row.to_s.gsub("\r\n", "").length.to_s
                  
              end   # Fin if row.to_s.gsub("\n", "").length.to_s == "199" || row.to_s.gsub("\n", "").length.to_s == "139" || row.to_s.gsub("\n", "").length.to_s == "250" || row.to_s.gsub("\n", "").length.to_s == "102" || row.to_s.gsub("\n", "").length.to_s == "87" || row.to_s.gsub("\n", "").length.to_s == "36"
                
            end     # Fin CSV.foreach(path) do |row|
            
            transaccion = Transaccion.find(@transaccion_id)
            
            logger.info "TRansaccion =====> #{transaccion.inspect}"
            logger.info "transaccion id =====> #{@transaccion_id.to_s}"
            logger.info "Monto total =====> #{@monto_total_abonos}"
            transaccion.monto = @monto_total_abonos
            transaccion.save     
              
          end   # fin unless ext == 'txt'

        ## quite aqui      
        
          
        else
        
          @msg << I18n.t('Sistema.Body.Modelos.Desembolso.Errores.cargar_archivo_procesar')
          if fecha==''
            @msg << I18n.t('Sistema.Body.Modelos.Desembolso.Errores.fecha_real')
          end
            
        end   #Fin unless name.nil? || name.empty?
          
        total = @total
        logger.info "TOTALLLL ======>>>>>>>>" << @total.to_s
        logger.info " TOOOOOOTALL ======>>>>>>>> " << total.to_s
        logger.info " IDS============>>>>> " << @ids.inspect
        
        ids = @ids
        return total, ids, @msg
                   
      end  #Fin transaction do

    end  #Fin Begin

      iniciar_transaccion(0, 'p_dummy', 'L', I18n.t('Sistema.Body.Modelos.ViewExcedenteArrime.Errores.iniciar_transaccion'), usuario_id,@total_monto.to_f)

  end
      

  def generar_cheque(entidad_financiera_id, modalidad, condiciones, cuenta_bcv_fondas,items)

      logger.debug 'Entrando GenerarCheque =====> ' << entidad_financiera_id.to_s
      logger.info 'entidad_financiera_id ===>' << entidad_financiera_id.to_s
      logger.info 'modalidad =>' << modalidad.to_s
      logger.info 'condiciones =>' << condiciones.to_s
      logger.info 'cuenta_bcv_fondas =>' << cuenta_bcv_fondas.to_s
      logger.info 'items =>' << items.to_s
      
      case entidad_financiera_id.to_i
        when 8
          logger.debug 'Ingreso en el 8 =====> '
          generar_txt_cheque_vzla(modalidad, condiciones, cuenta_bcv_fondas, items)
      end # when

    end


    def generar_txt_cheque_vzla(modalidad, condiciones, cuenta_bcv_fondas, items)

      #--------------------- CONDICION SI ES GENERACION DEL ARCHIVO SEGUN FILTRO------------
      nro_lote = ''
       if modalidad == 'propio' 
        tipo_cheque = 'P' 
       end
        if modalidad == 'gerencia' 
         tipo_cheque = 'G'
        end
      

      if items ==''

        @total = ViewExcedenteArrime.count(:conditions=>condiciones)
        @valores = ViewExcedenteArrime.find_by_sql("select * from view_excedente_arrime where " << condiciones)
        @cuenta_fondas = CuentaBcv.find_by_numero(cuenta_bcv_fondas)
        entidad_financiera_id = @cuenta_fondas.entidad_financiera_id

        if modalidad == 'gerencia'
          nombre = I18n.t('Sistema.Body.Modelos.Desembolso.Txt.nombre_archivo_excedente_arrime_cheque_gerencia') + Time.now.strftime("#{I18n.t('time.formats.gebos_txt_banco')}") + Time.now.strftime("-#{I18n.t('time.formats.hora_banco')}")
        else
          nombre = I18n.t('Sistema.Body.Modelos.Desembolso.Txt.nombre_archivo_excedente_arrime_cheque_propio') + Time.now.strftime("#{I18n.t('time.formats.gebos_txt_banco')}") + Time.now.strftime("-#{I18n.t('time.formats.hora_banco')}")
        end

        documento = 'public/documentos/finanzas/abono_excedente_cheque/' << nombre << '.txt'
        CSV.open(documento,'w+',{:col_sep => "|" , :row_sep => "\r\n"}) do |csv|
        datos = ''
        @contador = 0

        montos_creditos = 0.00
        cantidad_credito = ''
        creditos_montos = ''

        @nro_lote = ParametroGeneral.find(1)
        nro_lote = @nro_lote.nro_lote
        datos = ('0' * (15 - (@nro_lote.nro_lote.to_i + 1).to_s.length)) << (@nro_lote.nro_lote.to_i + 1).to_s
        numero = ('0' * (8 - (@nro_lote.nro_lote.to_i + 1).to_s.length)) << (@nro_lote.nro_lote.to_i + 1).to_s
      
        @nro_lote.nro_lote =  numero
        @nro_lote.save
     
        cantidad_credito = ('0' * (15 - @total.to_s.length)) + @total.to_s
        montos_creditos = ViewExcedenteArrime.sum(:monto_abono, :conditions=>condiciones)
        montos_credito = montos_creditos.nil? ? format_f('0') : format_f(montos_creditos)
        creditos_montos = ('0' * (17 - montos_credito.length)) << montos_credito.to_s

        @header ="#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.cabecera_cheque')}" + ' ' + '01' + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.codigo')}" + I18n.t('Sistema.Body.Modelos.Desembolso.Txt.nombre') + nro_lote.to_s + Time.now.strftime("#{I18n.t('time.formats.gebos_txt_banco')}") + '000000000000001' + cantidad_credito + creditos_montos
        csv << @header.sub(34.chr,'').parse_csv # imprimiendo linea

        nro_cuenta_fon = ('0' * (20 - cuenta_bcv_fondas.to_s.length)) + cuenta_bcv_fondas.to_s
        

        @debito ="#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.cabecera_cheque')}" + ' ' + '02' + Time.now.strftime("#{I18n.t('time.formats.gebos_txt_banco')}") + '03292' + nro_lote.to_s + creditos_montos + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.veb')}" + '  ' + nro_cuenta_fon + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.bschveca')}" + '006' + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.cheques_manuales')}"
        csv << @debito.sub(34.chr,'').parse_csv # imprimiendo linea
        
        begin
          incremental = 0
          while ( @contador < @total)

                
                cod_swift = ''
                cod_swift = @valores[@contador].cod_swift.to_s + (" " * (12 - @valores[@contador].cod_swift.to_s.length )) #CAMBIAR EL Q ESTA EN LA TRANSFERENCIA

                credito_monto = @valores[@contador].monto_abono.nil? ? format_f('0') : format_f(@valores[@contador].monto_abono)
                monto_credito = ('0' * (17 - credito_monto.to_s.length)) + credito_monto.to_s

                if(@valores[@contador].cedula_rif[0,1] == I18n.t('Sistema.Body.General.TipoDocumento.venezolano') || @valores[@contador].cedula_rif[0,1] == I18n.t('Sistema.Body.General.TipoDocumento.extranjero'))

                  @valores[@contador].cedula_rif.gsub!(' ', '')
                  cedula_rif = @valores[@contador].cedula_rif[0,1]+('0' * (9 - (@valores[@contador].cedula_rif[1,9]).to_s.length)) + (@valores[@contador].cedula_rif[1,9]).to_s
                  espacio = ' '

                else

                  cedula_rif = ('0' * (10 - (@valores[@contador].cedula_rif[0,1]+@valores[@contador].cedula_rif[2,8]+@valores[@contador].cedula_rif[11,1]).to_s.length)) + (@valores[@contador].cedula_rif[0,1]+@valores[@contador].cedula_rif[2,8]+@valores[@contador].cedula_rif[11,1]).to_s
                  espacio = ''

                end #fin de if para validar cirif

                nombre_benef = @valores[@contador].beneficiario.to_s[0,54]
                nombre_benef = nombre_benef + (" " * (55 - nombre_benef.to_s.length))

                incremental = incremental + 1
                incremental1 = ('0' * (8 - incremental.to_s.length) << incremental.to_s)
                incremental2 = ('0' * (15 - incremental.to_s.length) << incremental.to_s)

                @credito = "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.cabecera_cheque')}" << ' ' << '03' << '03292' << incremental1 << monto_credito << "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.veb')}" << '20' << '  ' << '                     ' << "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.bschveca')}" << '501  ' << cedula_rif << espacio << nombre_benef << '              ' << incremental2
                csv << @credito.sub(34.chr,'').parse_csv  #imprimiendo linea
                @contador += 1

          end #fin del while
          rescue Exception => x
            logger.info x.message
            logger.info x.backtrace.join("\n")
            return false
        end # fin de begin
        
        @control = ControlEnvioAbonoExcedenteCosecha.new(:fecha=>Time.now, :archivo=>nombre + '.txt', :estatus=>1, :numero_procesado=>@total, :monto_procesado=>montos_creditos, :entidad_financiera_id=>entidad_financiera_id, :numero_lote=>nro_lote)
        @control.save
        @control_id = @control.id
        @contador = 0

            #---------------ACTUALIZANDO DESEMBOLSO------------
            begin

              transaction do

                while( @contador < @total)
                  unless @valores[@contador].orden_abono_excedente_arrime_id.nil? # unless 1

                     @orden_abono_excedente_arrime = OrdenAbonoExcedenteArrime.find(@valores[@contador].orden_abono_excedente_arrime_id)
                     @orden_abono_excedente_arrime.estatus_id = 30060
                     @orden_abono_excedente_arrime.numero_lote = nro_lote
                     @orden_abono_excedente_arrime.fecha_envio_banco = Time.now
                     @orden_abono_excedente_arrime.fecha_valor = Time.now
                     @orden_abono_excedente_arrime.entidad_financiera_liquidadora_id = @cuenta_fondas.entidad_financiera_id
                     @orden_abono_excedente_arrime.numero_cuenta_liquidadora = @cuenta_fondas.numero
                     @orden_abono_excedente_arrime.tipo_cheque = tipo_cheque
                     @orden_abono_excedente_arrime.save

                  end #fin del unless 1
                  @contador+= 1
                end #fin segundo while
              end # fin transaction

              rescue Exception => x
              logger.error x.message
              logger.error x.backtrace.join("\n")
              return false

            end # fin begin

          end # del do

      else # Items =================SEGUN  SELECCION====================

        item_aux=items.split(',')
        item_formateado=''
        fre=0
        while (fre<item_aux.length)
          if (item_aux[fre]!='')
            item_formateado+=item_aux[fre]+','
          end
          fre+=1
        end

        if item_aux.length > 0
          item_formateado=item_formateado[0,(item_formateado.length)-1]
        end

        otra_condicion=condiciones + ' and orden_abono_excedente_arrime_id in (' + item_formateado + ')'
        nombre =I18n.t('Sistema.Body.Modelos.Desembolso.Txt.nombre_archivo_excedente_arrime_cheque') + Time.now.strftime("#{I18n.t('time.formats.gebos_txt_banco')}") + Time.now.strftime("#{I18n.t('time.formats.hora_banco')}")

        @total = ViewExcedenteArrime.count(:conditions=>otra_condicion)
        @valores = ViewExcedenteArrime.find_by_sql("select * from view_excedente_arrime where " << otra_condicion)
        @cuenta_fondas = CuentaBcv.find_by_numero(cuenta_bcv_fondas)
        entidad_financiera_id = @cuenta_fondas.entidad_financiera_id

        if modalidad == 'gerencia'
        nombre =I18n.t('Sistema.Body.Modelos.Desembolso.Txt.nombre_archivo_excedente_arrime_cheque_gerencia') + Time.now.strftime("#{I18n.t('time.formats.gebos_txt_banco')}") + Time.now.strftime("#{I18n.t('time.formats.hora_banco')}")
        else
        nombre =I18n.t('Sistema.Body.Modelos.Desembolso.Txt.nombre_archivo_excedente_arrime_cheque_propio') + Time.now.strftime("#{I18n.t('time.formats.gebos_txt_banco')}") + Time.now.strftime("#{I18n.t('time.formats.hora_banco')}")
        end

          logger.info "modalidad " << modalidad.to_s
          documento = 'public/documentos/finanzas/abono_excedente_cheque/' << nombre << '.txt'

          CSV.open(documento,'w+',{:col_sep => "|" , :row_sep => "\r\n"}) do |csv|

            logger.info "Entro a creación de archivo =================> "
            datos = ''
            @contador = 0
            numero = ''
            montos_creditos = 0.00           
            cantidad_credito = ''
            creditos_montos = ''

            @nro_lote = ParametroGeneral.find(1)

            nro_lote = @nro_lote.nro_lote
            datos << ('0' * (15 - (@nro_lote.nro_lote.to_i + 1).to_s.length)) << (@nro_lote.nro_lote.to_i + 1).to_s
            numero << ('0' * (8 - (@nro_lote.nro_lote.to_i + 1).to_s.length)) << (@nro_lote.nro_lote.to_i + 1).to_s

            @nro_lote.nro_lote =  numero
            @nro_lote.save

            cantidad_credito = ('0' * (15 - @total.to_s.length)) + @total.to_s
            montos_creditos = ViewExcedenteArrime.sum(:monto_abono, :conditions=>otra_condicion)
            montos_credito = montos_creditos.nil? ? format_f('0') : format_f(montos_creditos)
            creditos_montos = ('0' * (17 - montos_credito.length)) << montos_credito.to_s

            #PRIMER LINEA------------------------------
            @header ="#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.cabecera_cheque')}" + ' ' + '01' + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.codigo')}" + I18n.t('Sistema.Body.Modelos.Desembolso.Txt.nombre') + nro_lote.to_s + Time.now.strftime("#{I18n.t('time.formats.gebos_txt_banco')}") + '000000000000001' + cantidad_credito + creditos_montos

            logger.debug "HEADER    " << @header.to_s

            csv << @header.sub(34.chr,'').parse_csv # imprimiendo linea

            nro_cuenta_fon = ('0' * (20 - cuenta_bcv_fondas.to_s.length)) + cuenta_bcv_fondas.to_s
            cod_swift = @valores[@contador].cod_swift.to_s + (" " * (12 - @valores[@contador].cod_swift.to_s.length )) #CAMBIAR EL Q ESTA EN LA TRANSFERENCIA

            logger.info "codigo wift   " << @valores[@contador].cod_swift.to_s

            #SEGUNDA LINEA------------------------------
            @debito ="#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.cabecera_cheque')}" + ' ' + '02' + Time.now.strftime("#{I18n.t('time.formats.gebos_txt_banco')}") + '03292' + nro_lote.to_s + creditos_montos + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.veb')}" + '  ' + nro_cuenta_fon + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.bschveca')}" + '006' + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.cheques_manuales')}"

            csv << @debito.sub(34.chr,'').parse_csv # imprimiendo linea

            logger.debug "DEBITO    " << @debito.inspect

            #TERCERA LINEA------------------------------
            begin
              incremental = 0
              while ( @contador < @total)

                
                cod_swift = ''

                credito_monto = @valores[@contador].monto_abono.nil? ? format_f('0') : format_f(@valores[@contador].monto_abono)
                monto_credito = ('0' * (17 - credito_monto.to_s.length)) + credito_monto.to_s

                if(@valores[@contador].cedula_rif[0,1] == I18n.t('Sistema.Body.General.TipoDocumento.venezolano') || @valores[@contador].cedula_rif[0,1] == I18n.t('Sistema.Body.General.TipoDocumento.extranjero'))

                  @valores[@contador].cedula_rif.gsub!(' ', '')
                  cedula_rif = @valores[@contador].cedula_rif[0,1]+('0' * (9 - (@valores[@contador].cedula_rif[1,9]).to_s.length)) + (@valores[@contador].cedula_rif[1,9]).to_s
                  espacio = ' '

                else

                  cedula_rif = ('0' * (10 - (@valores[@contador].cedula_rif[0,1]+@valores[@contador].cedula_rif[2,8]+@valores[@contador].cedula_rif[11,1]).to_s.length)) + (@valores[@contador].cedula_rif[0,1]+@valores[@contador].cedula_rif[2,8]+@valores[@contador].cedula_rif[11,1]).to_s
                  espacio = ''

                end #fin de if para validar cirif

                nombre_benef = @valores[@contador].beneficiario.to_s[0,54]
                nombre_benef = nombre_benef + (" " * (55 - nombre_benef.to_s.length))

                incremental += 1
                incremental1 = ('0' * (8 - incremental.to_s.length) << incremental.to_s)
                incremental2 = ('0' * (15 - incremental.to_s.length) << incremental.to_s)

                @credito = "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.cabecera_cheque')}" << ' ' << '03' << '03292' << incremental1 << monto_credito << "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.veb')}" << '20' << '  ' << '                     ' << "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.bschveca')}" << '501  ' << cedula_rif << espacio << nombre_benef << '              ' << incremental2
                csv << @credito.sub(34.chr,'').parse_csv  #imprimiendo linea

                @contador += 1

              end #fin del while
              rescue Exception => x
                logger.info x.message
                logger.info x.backtrace.join("\n")
              return false
            end # fin de begin
            
            @control = ControlEnvioAbonoExcedenteCosecha.new(:fecha=>Time.now, :archivo=>nombre + '.txt', :estatus=>1, :numero_procesado=>@total, :monto_procesado=>montos_creditos, :entidad_financiera_id=>entidad_financiera_id, :numero_lote=>nro_lote)
            @control.save
            @control_id = @control.id
            @contador = 0

            #---------------ACTUALIZANDO DESEMBOLSO------------
            begin
              transaction do
                while( @contador < @total)
                  unless @valores[@contador].orden_abono_excedente_arrime_id.nil? # unless 1

                     @orden_abono_excedente_arrime = OrdenAbonoExcedenteArrime.find(@valores[@contador].orden_abono_excedente_arrime_id)
                     @orden_abono_excedente_arrime.estatus_id = 30060
                     @orden_abono_excedente_arrime.numero_lote = nro_lote
                     @orden_abono_excedente_arrime.fecha_envio_banco = Time.now
                     @orden_abono_excedente_arrime.fecha_valor = Time.now
                     @orden_abono_excedente_arrime.entidad_financiera_liquidadora_id = @cuenta_fondas.entidad_financiera_id
                     @orden_abono_excedente_arrime.numero_cuenta_liquidadora = @cuenta_fondas.numero
                     @orden_abono_excedente_arrime.tipo_cheque = tipo_cheque
                     @orden_abono_excedente_arrime.save

                  end #fin del unless 1

                  @contador+= 1

                end #fin segundo while

              end # fin transaction

              rescue Exception => x
              logger.error x.message
              logger.error x.backtrace.join("\n")
              return false

            end # fin begin
          end # del do
      end # Items
    end    
        
        
        
        
# VALIDACION Y REGISTRO DE CHEQUES PARA PAGO POR EXCEDENTE EN ARRIME
  def validar(orden_abono_excedente_arrime, fecha_registro_cheque, numero_cheque)
    logger.debug "ENTRE A LA VALIDACION EN MI MODELOS  ---- " << orden_abono_excedente_arrime.inspect.to_s
    logger.debug "ENTRE A LA VALIDACION EN MI MODELOS  ---- " << orden_abono_excedente_arrime_id.inspect.to_s
    
    logger.debug "Parametros  ---- " << fecha_registro_cheque.to_s << " - " << numero_cheque.to_s
    
    msj = ""

    orden_abono_excedente_arrime = OrdenAbonoExcedenteArrime.find(orden_abono_excedente_arrime_id)
    solicitud = Solicitud.find(orden_abono_excedente_arrime.solicitud_id)

    logger.debug "cheque  ---- " << numero_cheque.to_s
    logger.debug "fecha   ---- " << fecha_registro_cheque.to_s
    if numero_cheque.to_s==''
      msj << I18n.t('Sistema.Body.Modelos.ViewExcedenteArrime.Errores.numero_cheque_obligatorio',:numero=>solicitud.numero) 
    end

    if fecha_registro_cheque.to_s==''
      msj << I18n.t('Sistema.Body.Modelos.ViewExcedenteArrime.Errores.fecha_registro_invalida',:numero=>solicitud.numero)
    end

    if msj.length > 0
      return msj
    else
      return ''
    end
  end


  def registrar_cheque(params,usuario_id)

    #--------------------------------------------------------
    # Método para registrar el número del cheque
    # y la fecha de cobro del abono por excedente en arrime
    # de 1 o varios trámites según selección del usuario
    #---------------------------------------------------------

    id = params[:orden_abono_excedente_arrime_id]
    id = id.gsub('%252C',',')
    id = id[0,(id.length-1)]
    ids = id.split(',')
    numeros = ''
    total_abono = 0.00
    monto_desembolso = 0.00
    monto_insumos = 0.00
    id = []
    contador = 0
    
    begin
      transaction do
    
        usuario = Usuario.find(usuario_id)
        
        @transaccion_id = ViewExcedenteArrime.iniciar_transaccion('p_pago_excedente_arrime', usuario)

        ids.each do |orden_abono_excedente_arrime_id|
        
          orden_abono_excedente_arrime = OrdenAbonoExcedenteArrime.find(orden_abono_excedente_arrime_id)
          solicitud = Solicitud.find(orden_abono_excedente_arrime.solicitud_id)
          orden_abono_excedente_arrime.estatus_id = 30110
          orden_abono_excedente_arrime.referencia = params["numero_cheque_#{orden_abono_excedente_arrime_id}"]
        
          fecha_registro = params["fecha_registro_cheque_#{orden_abono_excedente_arrime_id}"]
          
          fecha =format_fecha_conversion(fecha_registro)
          
          orden_abono_excedente_arrime.fecha_registro_cheque = fecha
          orden_abono_excedente_arrime.save
          orden_abono_excedente_arrime.contabilizar_pago_excedente(solicitud, orden_abono_excedente_arrime.monto_abono,fecha,@transaccion_id,I18n.t('Sistema.Body.Modelos.Desembolso.Txt.pago_excedente_beneficiario'))
          total_abono += orden_abono_excedente_arrime.monto_abono
          id << orden_abono_excedente_arrime.id
      
        end 
      end
    end
    
    transaccion = Transaccion.find(@transaccion_id)
    transaccion.monto = total_abono
    transaccion.save
    
    iniciar_transaccion(0, 'p_dummy', 'L', I18n.t('Sistema.Body.Modelos.ViewExcedenteArrime.Errores.transaccion_dummy'), usuario_id,0)

    return id

  end

  def self.search(search, page, orden)    
    paginate :per_page=>@records_by_page, :page=>page, :conditions=>search, :order=>orden
  end

end


# == Schema Information
#
# Table name: view_excedente_arrime
#
#  oficina_id                      :integer
#  beneficiario                    :string
#  email                           :string(80)
#  cedula_rif                      :string
#  solicitud_id                    :integer
#  nro_tramite                     :integer
#  unidad_produccion_id            :integer
#  ciudad_id                       :integer
#  ciudad                          :string(40)
#  estado_id                       :integer
#  estado                          :string(40)
#  sector_id                       :integer
#  sector                          :string(100)
#  rubro                           :string(100)
#  rubro_id                        :integer
#  estatus                         :integer
#  monto_banco                     :decimal(16, 2)
#  monto_liquidado                 :decimal(16, 2)
#  prestamo_id                     :integer
#  nro_prestamo                    :integer(8)
#  orden_abono_excedente_arrime_id :integer
#  monto_abono                     :decimal(16, 2)
#  estatus_excedente               :integer
#  fecha_envio                     :date
#  fecha_envio_banco               :date
#  fecha_valor                     :date
#  fecha_abono_cuenta              :date
#  tipo_cheque                     :string(1)
#  referencia                      :string(30)
#  fecha_registro_cheque           :date
#  tipo                            :string(1)
#  numero_cuenta                   :string(20)
#  banco                           :string(80)
#  cod_swift                       :string(12)
#  entidad_financiera_id           :integer
#  sub_rubro                       :string(100)
#  sub_rubro_id                    :integer
#  actividad                       :string(150)
#  actividad_id                    :integer
#  sub_sector_id                   :integer
#

