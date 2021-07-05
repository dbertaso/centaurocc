# encoding: utf-8

#
# autor: Diego Bertaso
# clase: EnvioCobranza
# descripción: Inclusión y Migración a Rails 3

# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'rubygems'
require 'csv'

class EnvioCobranza < ActiveRecord::Base

  self.table_name = 'envio_cobranza'
  @viewencabezadoporcuotas = ViewEncabezadoPorCuotas
  @viewencabezadoporexigible = ViewEncabezadoPorExigible
  @viewcuotasexigibles = ViewCuotasExigibles
  @viewprestamoexigible= ViewPrestamoExigible
  @controlenviocobranza = ControlEnvioCobranza
  @parametrogeneral = ParametroGeneral
  
  def initialize
    
  end
  
  def self.generar_cobranzas(entidad_financiera_id, tipo_cobro, cuenta_matriz, fecha_valor)
    
    logger.info "Entro en generar_cobranzas"

    logger.info "Entro en generar_cobranzas EF #{entidad_financiera_id}"
    logger.info "Entro en generar_cobranzas TC #{tipo_cobro}"
    logger.info "Entro en generar_cobranzas CM #{cuenta_matriz}"
    logger.info "Entro en generar_cobranzas FV #{fecha_valor}"

    case entidad_financiera_id.to_i
      
      when 13
        self.generar_archivo_biv(entidad_financiera_id,tipo_cobro.to_i, cuenta_matriz, fecha_valor)
      when 5
        self.generar_archivo_caroni(entidad_financiera_id,tipo_cobro.to_i, cuenta_matriz, fecha_valor)
      when 465
        logger.info "Entro a generar archivo banfoandes"
        self.generar_archivo_banfoandes(entidad_financiera_id,tipo_cobro.to_i, cuenta_matriz, fecha_valor)

    end
    
  end

  def self.verifica_archivo_procesado(nombrearchivo,fecha,fecha_valor,entidad_financiera_id,cuenta_matriz,tipo)

   controlenviocobranza = ControlEnvioCobranza.first(:conditions=>['fecha =  ? and numero_cuenta =  ? and entidad_financiera_id =  ? and archivo = ?', fecha_valor,cuenta_matriz,entidad_financiera_id,nombrearchivo] )
   #controlcobranza = ControlCobranza.find_by_archivo(nombrearchivo)
   logger.info "CONTROL COBRANZA ===============> #{controlenviocobranza.inspect}"
   error = "0"

   if controlenviocobranza.nil?

      @controlenviocobranza = ControlEnvioCobranza.new(:fecha=>fecha_valor, 
                                                  :fecha_proceso=>fecha, 
                                                  :numero_cuenta=>cuenta_matriz, 
                                                  :tipo_cuenta => tipo, 
                                                  :archivo=>nombrearchivo, 
                                                  :entidad_financiera_id=>entidad_financiera_id, 
                                                  :estatus_proceso=>1)
      @controlenviocobranza.save
      return error

    else

      @controlenviocobranza = controlenviocobranza

      if @controlenviocobranza.estatus_proceso == 2

        error = "<li>#{I18n.t('Sistema.Body.Modelos.ControlCobranzas.Errores.el_archivo')} #{nombrearchivo} #{I18n.t('Sistema.Body.Modelos.ControlEnvioCobranzas.Errores.ya_fue_generado')}</li>"

        #puts controlcobranza.inspect
        return error
      elsif @controlenviocobranza.estatus_proceso == 1

        error = "<li>#{I18n.t('Sistema.Body.Modelos.ControlCobranzas.Errores.el_archivo')} #{nombrearchivo} #{I18n.t('Sistema.Body.Modelos.ControlCobranzas.Errores.en_proceso')}</li>"
        return error
      else

         @numeros_leidos_anteriores = @controlenviocobranza.numero_procesado
         @monto_leidos = @controlenviocobranza.monto_procesado

      end

    end

    return error

  end

  def self.generar_archivo_caroni(entidad_financiera_id, tipo_cobro, cuenta_matriz, fecha_valor)

    respuesta = "0"

    entidad = EntidadFinanciera.find(entidad_financiera_id)
    unless entidad.nil?
      nombre = "#{entidad.alias}COBRANZAS#{fecha_valor.to_s.gsub("/", "")}"
    else
      nombre = 'caronicobranzas' + fecha_valor.to_s.gsub("/", "")
    end
    
    documento = "#{Rails.public_path}/documentos/cobranza/envio/#{nombre}.txt"

    logger.info "Documento ==> " << documento.to_s

    tipo_cuenta = cuenta_matriz[0,1]
    cuenta_matriz = cuenta_matriz[2,(cuenta_matriz.size - 2)]

    fecha = Time.now.strftime("%Y-%m-%d")
    @parametro = @parametrogeneral.find(1)
    if @parametro.nil?
      cuotas_cobro = 0
    else
      cuotas_cobro = @parametro.cuotas_envio_cobro
    end

    logger.info "Tipo de Cobro ======> " << tipo_cobro.to_s

    respuesta = self.verifica_archivo_procesado(nombre,fecha,fecha_valor,entidad_financiera_id,cuenta_matriz,tipo_cuenta)

    if respuesta != "0"
      return respuesta
    end

    @control = ControlEnvioCobranza.first(:conditions=>['fecha =  ? and numero_cuenta =  ? and entidad_financiera_id =  ? and archivo = ? and estatus_proceso = 1', fecha_valor,cuenta_matriz,entidad_financiera_id,nombre] )

    if tipo_cobro.to_i == 1

      # Seleccion del encabezado para el archivo de cobranzas por cuotas

      @encabezado = @viewencabezadoporcuotas.find_by_sql("select * from view_encabezado_por_cuotas")

      logger.info "Encabezado =====> " << @encabezado.inspect
      
      if @encabezado[0].nil? || 
         @encabezado.empty?

          respuesta = "<li>#{I18n.t('Sistema.Body.Controladores.EnvioCobranzas.Errores.sin_registros')}</li>"
          return respuesta
      end

      # Seleccion cuotas vencidas para el archivo de envio de cobranzas

      @cuotas = @viewcuotasexigibles.find_by_sql("select * from view_cuotas_exigibles")

      logger.info "Cuotas =====> " << @cuotas.inspect

      if  @cuotas[0].nil? ||
          @cuotas.empty?
          respuesta = "<li>#{I18n.t('Sistema.Body.Controladores.EnvioCobranzas.Errores.sin_registros')}</li>"
          return respuesta
      end

    else

      # Seleccion del encabezado para el archivo de cobranzas por exigible

      @encabezado = @viewencabezadoporexigible.find_by_sql("select * from view_encabezado_por_exigible")

      logger.info "Encabezado =====> " << @encabezado.inspect

      if @encabezado[0].nil? ||
         @encabezado.empty?
        
          respuesta = "<li>#{I18n.t('Sistema.Body.Controladores.EnvioCobranzas.Errores.sin_registros')}</li>"
          return respuesta

      end

      # Seleccion cuotas vencidas para el archivo de envio de cobranzas

      @cuotas = @viewprestamoexigible.find_by_sql("select * from view_prestamo_exigible")

      logger.info "Cuotas =====> " << @cuotas.inspect

      if  @cuotas[0].nil? || 
          @cuotas.empty?
          respuesta = "<li>#{I18n.t('Sistema.Body.Controladores.EnvioCobranzas.Errores.sin_registros')}</li>"
          return respuesta
      end
       
   end

   #-------------------------------------------------------------
   # Primer recorrido para determinar los campos del encabezado
   #-------------------------------------------------------------

   @cantidad_cuota = 0
   @total_cuota = 0.00
   @prestamoleido = 0
   @contar = 0

   @total_cuota = @total_cuota.to_d

   if tipo_cobro.to_i == 2

      @cuotas.each { |cuota|

        @cantidad_cuota += 1
        @total_cuota += cuota.exigible

      }    #====> @cuotas.each

   end 

   if tipo_cobro.to_i == 1

      @cuotas.each { |cuota|

        if cuota.prestamo_numero != @prestamoleido
          @contar = 0
          @prestamoleido = cuota.prestamo_numero
        end

        if @contar <= cuotas_cobro

          @contar += 1
          @cantidad_cuota += 1

          @total_cuota += cuota.monto_cuota

        end

      }    #====> @cuotas.each

   end 

  CSV.open(documento,'w+',{:row_sep => "\r\n"}) do |csv|

    #------------------------
    #Grabando el encabezado
    #------------------------

    datos = ''
    @encabezado.each { |head|
        # if head.cuenta_matriz.nil?
        #   cuenta_matriz = ''
        # else
        #   cuenta_matriz = head.cuenta_matriz
        # end
        datos = ''
        datos = '01'
        datos << "#{I18n.t('Sistema.Body.General.nombre_institucion')}#{(' ' * (40 - I18n.t('Sistema.Body.General.nombre_institucion').length))}"
        datos << cuenta_matriz
        datos << ('0' * (5 - @cantidad_cuota.to_s.length)) << @cantidad_cuota.to_s
        monto = @total_cuota.to_s
        logger.info "Total Cuota <<<<<============>>>>>> #{@total_cuota.to_s}"
        logger.info "Longitud    <<<<<============>>>>>> #{(15 - monto.length).to_s}"
        monto = monto.gsub('.','')
        datos << ('0' * (15 - monto.length)) << monto
        datos << fecha_valor
        csv << [datos]
      }

      cantidad = 0
      totalmonto = 0.0
      
      datos = ''
      correlativo = rand(31*Math.log(Time.now.to_f))

      @contar = 0
      @prestamoleido = 0

      #---------------------
      #Grabando las cuotas
      #---------------------

      if tipo_cobro.to_i == 2

        @cuotas.each { |cuota|

          logger.info "Entro el loop de exigibles ==========> "
          correlativo += 1
          cantidad += 1

          total_monto += cuota.monto_exigible

          datos = '02'
          datos << cuota.numero_cuenta.to_s
          monto = cuota.exigible
          monto = monto.to_s.gsub(".",'')
         
          datos << ('0' * (15 - monto.length)) << monto
          datos << (' ' * 36)
          datos << ('0' * (12 - cuota.prestamo_numero.to_s.length)) << cuota.prestamo_numero.to_s
          datos << '1'
          datos << ('0' * (8 - correlativo.to_s.length)) << correlativo.to_s
          datos << '1670'
          csv << [datos]
          logger.info "Datos Cuotas =========> #{datos.inspect}"
        }

      end

      if tipo_cobro.to_i == 1

        @cuotas.each { |cuota|

          logger.info "Entro el loop de @cuotas ==========> "
          correlativo += 1
          cantidad += 1

          totalmonto += cuota.monto_cuota

          if cuota.prestamo_numero != @prestamoleido
            @contar = 0
            @prestamoleido = cuota.prestamo_numero
          end

          if @contar <= cuotas_cobro

            @contar += 1

            datos = '02'
            datos << cuota.numero_cuenta.to_s

            monto = cuota.monto_cuota
            monto = monto.to_s.gsub(".",'')

            datos << ('0' * (15 - monto.length)) << monto
            datos << (' ' * 36)
            datos << ('0' * (12 - cuota.prestamo_numero.to_s.length)) << cuota.prestamo_numero.to_s
            datos << '1'
            datos << ('0' * (8 - correlativo.to_s.length)) << correlativo.to_s
            datos << '1670'
            csv << [datos]

            logger.info "Datos Cuotas =========> #{datos.inspect}"
          end

        }

      end

      @control.estatus_proceso = 2    #archivo procesado
      @control.numero_procesado = cantidad
      @control.monto_procesado = totalmonto
      @control.save

   end    # =========== fin del do de fastercsv open

   return respuesta

  end

  def self.generar_archivo_banfoandes(entidad_financiera_id, tipo_cobro, cuenta_matriz, fecha_valor)

    begin

      logger.info "Entro a generar archivo banfoandes "
      entidad = EntidadFinanciera.find(entidad_financiera_id)
      unless entidad.nil?
        nombre = "#{entidad.alias}COBRANZAS#{fecha_valor.to_s.gsub("/", "")}"
      else
        nombre = 'bicentenariocobranzas' + fecha_valor.to_s.gsub("/", "")
      end

      logger.info "Nombre archivo =====> #{nombre}"

      tipo_cuenta = cuenta_matriz[0,1]
      cuenta_matriz = cuenta_matriz[2, (cuenta_matriz.size - 2)]
      fecha_valor = fecha_valor.to_datetime.strftime("%Y-%m-%d")

      fecha = Time.now.strftime("%Y-%m-%d")
      @parametro = @parametrogeneral.find(1)
      if @parametro.nil?
        cuotas_cobro = 0
      else
        cuotas_cobro = @parametro.cuotas_envio_cobro
      end


      respuesta = self.verifica_archivo_procesado(nombre,fecha,fecha_valor,entidad_financiera_id,cuenta_matriz,tipo_cuenta)

      logger.info "RESPUESTA <<========================>> #{respuesta}"
      if respuesta != "0"
        return respuesta
      end

      @control = ControlEnvioCobranza.first(:conditions=>['fecha =  ? and numero_cuenta =  ? and entidad_financiera_id =  ? and archivo = ? and estatus_proceso = 1', fecha_valor,cuenta_matriz,entidad_financiera_id,nombre] )

      logger.info "CONTROL <<================>> #{@control.inspect}"
      documento = "#{Rails.public_path}/documentos/cobranza/envio/#{nombre}.txt".to_s

      logger.info "Documento =====> #{documento}"

      if tipo_cobro.to_i == 1

        # Seleccion del encabezado para el archivo de cobranzas por cuotas

        @encabezado = @viewencabezadoporcuotas.find_by_sql("select * from view_encabezado_por_cuotas")

        logger.info "Encabezado =====> " << @encabezado.inspect

        if @encabezado[0].nil? ||
          @encabezado.empty?

            respuesta = "<li>#{I18n.t('Sistema.Body.Controladores.EnvioCobranzas.Errores.sin_registros')}</li>"
            return respuesta
        end

        #Seleccion cuotas vencidas para el archivo de envio de cobranzas

        @cuotas = @viewcuotasexigibles.find_by_sql("select * from view_cuotas_exigibles")

        #logger.info "Cuotas =====> " << @cuotas.inspect

        if  @cuotas[0].nil? ||
            @cuotas.empty?
            respuesta = "<li>#{I18n.t('Sistema.Body.Controladores.EnvioCobranzas.Errores.sin_registros')}</li>"
            return respuesta
        end

      else

        # Seleccion del encabezado para el archivo de cobranzas por prestamo

        @encabezado = @viewencabezadoporexigible.find_by_sql("select * from view_encabezado_por_exigible")

        if @encabezado[0].nil? ||
           @encabezado.empty?
          
          respuesta = "<li>#{I18n.t('Sistema.Body.Controladores.EnvioCobranzas.Errores.sin_registros')}</li>"
          return respuesta
        end

        # Seleccion cuotas vencidas para el archivo de envio de cobranzas

        @cuotas = @viewprestamoexigible.find_by_sql("select * from view_prestamo_exigible")

        logger.info "Cuotas =====> " << @cuotas.inspect

        if  @cuotas[0].nil? ||
          @cuotas.empty?

          respuesta = "<li>#{I18n.t('Sistema.Body.Controladores.EnvioCobranzas.Errores.sin_registros')}</li>"
          return respuesta
        end

      end

      logger.info "Documento ====> " << documento.to_s


      #-------------------------------------------------------------
      # Primer recorrido para determinar los campos del encabezado
      #-------------------------------------------------------------

      @cantidad_cuota = 0
      @total_cuota = 0.00
      @prestamoleido = 0
      @contar = 0
      @total_cuota = @total_cuota.to_d

      logger.info "cuotas_cobro ======> " << cuotas_cobro.to_s
      logger.info "Tipo de cobro <<===================>> #{tipo_cobro.to_s}"

      if tipo_cobro.to_i == 2

        @cuotas.each { |cuota|

          @cantidad_cuota += 1
          @total_cuota += cuota.exigible

        }    #====> @cuotas.each

      end 

      if tipo_cobro.to_i == 1

        @cuotas.each { |cuota|

          logger.info "Cuotas   <<============================================>> #{cuota.inspect}"

          if cuota.prestamo_numero != @prestamoleido
            @contar = 0
            @prestamoleido = cuota.prestamo_numero
          end

          if @contar < cuotas_cobro

            @contar += 1
            @cantidad_cuota += 1

            @total_cuota += cuota.monto_cuota

            logger.info "Monto Cuota <<====================>> #{cuota.monto_cuota.to_s}"
            logger.info "Cantidad    <<====================>> #{@cantidad_cuota.to_s}"
            logger.info "Total Cuota <<====================>> #{@total_cuota.to_s}"


          end

        }    #====> @cuotas.each

      end 

      logger.info "total cuota ========> #{format_fm(@total_cuota)}"


      logger.info "documento ========> #{documento}"

      CSV.open(documento,'w+',{:row_sep => "\r\n"}) do |csv|

          logger.info "Abrio el archivo y entro en el DO del CSV.open =======> #{documento}"
        datos = ''

        logger.info "Clases de Variables de consulta =======> #{@encabezado.class.to_s} <====> #{@cuotas.class.to_s}"


        @encabezado.each { |head|

          # if head.cuenta_matriz.nil?
          #   cuenta_matriz = ''
          # else
          #   cuenta_matriz = head.cuenta_matriz
          # end

          logger.info "Entro al encabezado =======> #{@encabezado.class.to_s}"
          datos = '01'
          datos << "#{I18n.t('Sistema.Body.General.nombre_institucion')}#{(' ' * (40 - I18n.t('Sistema.Body.General.nombre_institucion').length))}"
          datos << cuenta_matriz
          datos << ('0' * (5 - @cantidad_cuota.to_s.length)) << @cantidad_cuota.to_s
          logger.info "Datos despues cuenta matriz ===========> #{datos.inspect}"
          monto = @total_cuota.to_s
          monto = monto.gsub('.','')
          logger.info "monto ===> " << monto
          #datos << ('0' * (15 - head.total_cuota.to_s.gsub('.','').length)) << head.total_cuota.to_s.gsub('.','').to_s
          datos << ('0' * (15 - monto.length)) << monto
          datos << fecha_valor
          csv << [datos]
         }

         logger.info "Datos ===========> #{datos.inspect}"

         datos = ''
         cantidad = 0
         totalmonto = 0.0
         totalmonto = totalmonto.to_d
         correlativo = rand(31*Math.log(Time.now.to_f))

         @prestamoleido = 0
         @contar = 0

         #logger.info "cuotas ======> " << @cuotas.inspect

        if tipo_cobro == 2

          @cuotas.each { |cuota|

            logger.info "Entro el loop de exigibles ==========> "
            correlativo += 1
            cantidad += 1

            totalmonto += cuota.monto_exigible

            datos = '02'
            datos << cuota.numero_cuenta.to_s
            monto = cuota.exigible
            monto = monto.to_s.gsub(".",'')
           
            datos << ('0' * (15 - monto.length)) << monto
            datos << (' ' * 36)
            datos << ('0' * (12 - cuota.prestamo_numero.to_s.length)) << cuota.prestamo_numero.to_s
            datos << '1'
            datos << ('0' * (8 - correlativo.to_s.length)) << correlativo.to_s
            datos << '1670'
            csv << [datos]
            logger.info "Datos Cuotas =========> #{datos.inspect}"
          }

        end

        if tipo_cobro.to_i == 1

          @cuotas.each { |cuota|

            logger.info "Entro el loop de @cuotas ==========> "
            correlativo += 1
            cantidad += 1

            totalmonto += cuota.monto_cuota

            logger.info "Monto cuota en loop cuotas <<==========>>  #{cuota.monto_cuota.to_s}"
            logger.info "Cantidad en loop cuotas <<=============>>  #{cantidad.to_s}"
            logger.info "TotalMonto en loop cuotas <<============>> #{totalmonto.to_s}"

            if cuota.prestamo_numero != @prestamoleido
              @contar = 0
              @prestamoleido = cuota.prestamo_numero
            end

            if @contar < cuotas_cobro

              @contar += 1

              datos = '02'
              datos << cuota.numero_cuenta.to_s

              monto = cuota.monto_cuota
              monto = monto.to_s.gsub(".",'')

              datos << ('0' * (15 - monto.length)) << monto
              datos << (' ' * 36)
              datos << ('0' * (12 - cuota.prestamo_numero.to_s.length)) << cuota.prestamo_numero.to_s
              datos << '1'
              datos << ('0' * (8 - correlativo.to_s.length)) << correlativo.to_s
              datos << '1670'
              csv << [datos]

              logger.info "Datos Cuotas =========> #{datos.inspect}"
            end

          }
        end

        logger.info "Cantidad <<===========>> #{cantidad.to_s}"
        logger.info "Monto <<==============>> #{totalmonto.to_s}"
        @control.estatus_proceso = 2    #archivo procesado
        @control.numero_procesado = cantidad
        @control.monto_procesado = totalmonto
        @control.save

        logger.info "Control ========> #{@control.inspect}"

      end    # =========== fin del do de fastercsv open

    rescue => exception
      logger.info "Errorrrrrr =======> #{exception.message} - #{exception.backtrace.to_s}"

      respuesta = "<li>#{exception.message}</li>"
    end # fin del begin

    return respuesta

  end

  def self.generar_archivo_biv(entidad_financiera_id, tipo_cobro, cuenta_matriz, fecha_valor)

    entidad = EntidadFinanciera.find(entidad_financiera_id)
    unless entidad.nil?
      nombre = "#{entidad.alias}COBRANZAS#{fecha_valor.to_s.gsub("/", "")}"
    else
      nombre = 'biv' + fecha_valor.to_s.gsub("/", "")
    end

    #nombre = 'bivecobranzas' + fecha_valor.to_s.gsub("/", "")

    tipo_cuenta = cuenta_matriz[0,1]
    cuenta_matriz = cuenta_matriz[2,(cuenta_matriz.size - 2)]

    @parametro = @parametrogeneral.find(1)
    if @parametro.nil?
     cuotas_cobro = 0
    else
     cuotas_cobro = @parametro.cuotas_envio_cobro
    end

    fecha = Time.now.strftime("%Y-%m-%d")
    documento = "#{Rails.public_path}/documentos/cobranza/envio/#{nombre}.txt"

    logger.info "Documento =====> #{documento}"

    respuesta = self.verifica_archivo_procesado(nombre,fecha,fecha_valor,entidad_financiera_id,cuenta_matriz,tipo_cuenta)

    if respuesta != "0"
      return respuesta
    end

    @control = ControlEnvioCobranza.first(:conditions=>['fecha =  ? and numero_cuenta =  ? and entidad_financiera_id =  ? and archivo = ? and estatus_proceso = 1', fecha_valor,cuenta_matriz,entidad_financiera_id,nombre] )

    if tipo_cobro == 1

      # Seleccion del encabezado para el archivo de cobranzas por cuotas

      @encabezado = @viewencabezadoporcuotas.find_by_sql("select * from view_encabezado_por_cuotas")

      logger.info "Encabezado =====> " << @encabezado.inspect

      if @encabezado[0].nil? ||
         @encabezado.empty?

          respuesta = "<li>#{I18n.t('Sistema.Body.Controladores.EnvioCobranzas.Errores.sin_registros')}</li>"
          return respuesta
      end


      # Seleccion cuotas vencidas para el archivo de envio de cobranzas

      @cuotas = @viewcuotasexigibles.find_by_sql("select * from view_cuotas_exigibles")

      logger.info "Cuotas =====> " << @cuotas.inspect

      if  @cuotas[0].nil? ||
          @cuotas.empty?

          respuesta = "<li>#{I18n.t('Sistema.Body.Controladores.EnvioCobranzas.Errores.sin_registros')}</li>"
          return respuesta
      end

    else

      # Seleccion del encabezado para el archivo de cobranzas por prestamo

      @encabezado = @viewencabezadoporexigible.find_by_sql("select * from view_encabezado_por_exigible")

      logger.info "Encabezado Exigible =====> #{@encabezado.inspect}"

      if @encabezado[0].nil? ||
         @encabezado.empty?

          respuesta = "<li>#{I18n.t('Sistema.Body.Controladores.EnvioCobranzas.Errores.sin_registros')}</li>"
          return respuesta
      end

      # Seleccion cuotas vencidas para el archivo de envio de cobranzas

      @cuotas = @viewprestamoexigible.find_by_sql("select * from view_prestamo_exigible")

      logger.info "Cuotas =====> " << @cuotas.inspect

      if  @cuotas[0].nil? ||
          @cuotas.empty?
          respuesta = "<li>#{I18n.t('Sistema.Body.Controladores.EnvioCobranzas.Errores.sin_registros')}</li>"
          return respuesta
      end

   end

   logger.info "Documento ====> " << documento.to_s


   #-------------------------------------------------------------
   # Primer recorrido para determinar los campos del encabezado
   #-------------------------------------------------------------

   @cantidad_cuota = 0
   @total_cuota = 0.00
   @total_cuota = @total_cuota.to_d
   @prestamoleido = 0
   @contar = 0

   if tipo_cobro == 2

      @cuotas.each { |cuota|

        @cantidad_cuota += 1
        @total_cuota += cuota.exigible

      }    #====> @cuotas.each

   end 

   if tipo_cobro == 1

      @cuotas.each { |cuota|

        if cuota.prestamo_numero != @prestamoleido
          @contar = 0
          @prestamoleido = cuota.prestamo_numero
        end

        if @contar < cuotas_cobro

          @contar += 1
          @cantidad_cuota += 1

          @total_cuota += cuota.monto_cuota

        end

      }    #====> @cuotas.each

   end 


   begin

     CSV.open(documento,'w+',{:row_sep => "\r\n"}) do |csv|

         datos = ''
         @encabezado.each { |head|
          cuenta = ''
           datos = '01'
           datos << "#{I18n.t('Sistema.Body.General.nombre_institucion')}#{(' ' * (40 - I18n.t('Sistema.Body.General.nombre_institucion').length))}"

           # if head.cuenta_matriz.nil?
           #  cuenta = '00000000000000000000'
           # else
           #  cuenta = head.cuenta_matriz
           # end

          datos << cuenta_matriz
          datos << ('0' * (5 - @cantidad_cuota.to_s.length)) << @cantidad_cuota.to_s
          monto = @total_cuota.to_s
          monto = monto.gsub('.','')
          puts "monto ===> " << monto
          datos << ('0' * (15 - head.total_cuota.to_s.gsub('.','').length)) << head.total_cuota.to_s.gsub('.','').to_s
          datos << fecha_valor
          csv << [datos]
         }

         datos = ''
         cantidad = 0
         totalmonto = 0.0
         correlativo = rand(31*Math.log(Time.now.to_f))

         @prestamoleido = 0
         @contar = 0

         logger.info "cuotas ======> " << @cuotas.inspect

        if tipo_cobro == 2

          @cuotas.each { |cuota|

            logger.info "Entro el loop de exigibles ==========> "
            correlativo += 1
            cantidad += 1

            total_monto += cuota.monto_exigible

            datos = '02'
            datos << cuota.numero_cuenta.to_s
            monto = cuota.exigible
            monto = monto.to_s.gsub(".",'')
           
            datos << ('0' * (15 - monto.length)) << monto
            datos << (' ' * 36)
            datos << ('0' * (12 - cuota.prestamo_numero.to_s.length)) << cuota.prestamo_numero.to_s
            datos << '1'
            datos << ('0' * (8 - correlativo.to_s.length)) << correlativo.to_s
            datos << '1670'
            csv << [datos]
            logger.info "Datos Cuotas =========> #{datos.inspect}"
          }

        end

        if tipo_cobro == 1

          @cuotas.each { |cuota|

            logger.info "Entro el loop de @cuotas ==========> "
            correlativo += 1
            cantidad += 1

            totalmonto += cuota.monto_cuota

            if cuota.prestamo_numero != @prestamoleido
              @contar = 0
              @prestamoleido = cuota.prestamo_numero
            end

            if @contar < cuotas_cobro

              @contar += 1

              datos = '02'
              datos << cuota.numero_cuenta.to_s

              monto = cuota.monto_cuota
              monto = monto.to_s.gsub(".",'')

              datos << ('0' * (15 - monto.length)) << monto
              datos << (' ' * 36)
              datos << ('0' * (12 - cuota.prestamo_numero.to_s.length)) << cuota.prestamo_numero.to_s
              datos << '1'
              datos << ('0' * (8 - correlativo.to_s.length)) << correlativo.to_s
              datos << '1670'
              csv << [datos]

              logger.info "Datos Cuotas =========> #{datos.inspect}"
            end

          }
        end

        @control.estatus_proceso = 2    #archivo procesado
        @control.numero_procesado = cantidad
        @control.monto_procesado = totalmonto
        @control.save

     end    # =========== fin del do de fastercsv open

    rescue => detail

      logger.info "Errrrorrrrrrrrr ======> #{detail.message}\n"
      logger.error "Backtrace ======> #{detail.backtrace.join}\n"

      respuesta = "<li>#{detail.message}</li>"

    end

    return respuesta
  end

end
