# encoding: utf-8

#
# autor: Diego Bertaso
# clase: ControlCobranza
# descripción: Inclusión y Migración a Rails 3

require "find"
require "fileutils"

class ControlCobranza < ActiveRecord::Base

  self.table_name = 'control_cobranza'

  attr_accessible :id,
                  :fecha,
                  :archivo,
                  :procesamiento,
                  :numero_procesado,
                  :monto_procesado,
                  :numero_leido,
                  :monto_leido,
                  :fecha_cierre,
                  :entidad_financiera_id,
                  :numero_cuenta,
                  :tipo_cuenta

  belongs_to :entidad_financiera

  @rechazo_cobranza = RechazoCobranza
  @prestamo1 = Prestamo
  @solicitud1 = Solicitud
  @cliente1 = Cliente
  @clienteempresa = ClienteEmpresa
  @clientepersona = ClientePersona
  @tasa = Tasa
  @tipo_credito = TipoCredito
  @producto = Producto
  @oficina = Oficina
  @programa = Programa
  

  def self.search(search, page, sort)

    paginate :per_page => @records_by_page, :page => page,
             :conditions => search, :order => sort
  end

  #Definición de métodos no presentes en la base de datos (columnas calculadas)

  def tipo_cuenta_w

    case tipo_cuenta
      when 'C'
        I18n.t('Sistema.Body.Vistas.General.corriente')
      when 'A'
        I18n.t('Sistema.Body.Vistas.General.ahorro')
    else
        I18n.t('Sistema.Body.Vistas.General.corriente')
    end 
  end

  def estado

    case self.procesamiento

    when 0
      I18n.t('Sistema.Body.Modelos.ControlEnvioCobranzas.Estatus.por_procesar')
    when 1
      I18n.t('Sistema.Body.Modelos.ControlEnvioCobranzas.Estatus.en_proceso')
    when 2
      I18n.t('Sistema.Body.Modelos.ControlEnvioCobranzas.Estatus.procesado')
    end
    
  end


  def cantidad_rechazos

    self.numero_leido - self.numero_procesado
    
  end

  def cantidad_rechazos_fm

    unless self.cantidad_rechazos.nil?
      format_int(self.cantidad_rechazos)
    end

  end

  def numero_leido_fm

    unless self.numero_leido.nil?
      format_int(self.numero_leido)
    end

  end

  def numero_procesado_fm

    unless self.numero_procesado.nil?
      format_int(self.numero_procesado)
    end

  end

  def monto_rechazos

    self.monto_leido - self.monto_procesado

  end

  def monto_rechazos_fm

    unless self.monto_rechazos.nil?
      format_fm(self.monto_rechazos)
    end

  end

  def monto_leido_fm

    unless self.monto_leido.nil?
      format_fm(self.monto_leido)
    end

  end

  def monto_procesado_fm

    unless self.monto_procesado.nil?
      format_fm(self.monto_procesado)
    end

  end

  def self.verifica_archivo_procesado(nombrearchivo,fecha,fecha_valor,entidad_financiera_id,cuenta_matriz,tipo)

   controlcobranza = ControlCobranza.first(:conditions=>['fecha_cierre =  ? and numero_cuenta =  ? and entidad_financiera_id =  ? and archivo = ?', fecha_valor,cuenta_matriz,entidad_financiera_id,nombrearchivo] )
   #controlcobranza = ControlCobranza.find_by_archivo(nombrearchivo)
   logger.info "CONTROL COBRANZA ===============> #{controlcobranza.inspect}"
   error = "0"

   if controlcobranza.nil?

      @controlcobranza = ControlCobranza.new( :fecha=>fecha,
                                              :entidad_financiera_id=>entidad_financiera_id,
                                              :numero_cuenta=>cuenta_matriz,
                                              :tipo_cuenta=>tipo,
                                              :fecha_cierre=>fecha_valor,
                                              :archivo=>nombrearchivo)
      return error

    else

      @controlcobranza = controlcobranza

      if @controlcobranza.procesamiento == 2

        error = "<li>#{I18n.t('Sistema.Body.Modelos.ControlCobranzas.Errores.el_archivo')} #{nombrearchivo} #{I18n.t('Sistema.Body.Modelos.ControlCobranzas.Errores.ya_fue_procesado')}</li>"

        #puts controlcobranza.inspect
        return error
      elsif @controlcobranza.procesamiento == 1

        error = "<li>#{I18n.t('Sistema.Body.Modelos.ControlCobranzas.Errores.el_archivo')} #{nombrearchivo} #{I18n.t('Sistema.Body.Modelos.ControlCobranzas.Errores.en_proceso')}</li>"
        return error
      else

         @numeros_leidos_anteriores = @controlcobranza.numero_leido
         @monto_leidos = @controlcobranza.monto_leido

      end

    end

    return error

  end


  def self.ejecutar_cobranzas_banfoandes(archivo,fecha,usuario_id,cuenta_matriz,entidad_financiera_id,tipo)

    #require 'fill_common.rb'
    #require "find"
    respuesta = ""
    logger.info "Fecha modelo ============>" << fecha.to_s
    logger.info "Archivo  modelo ============>" << archivo.inspect
    nombre_archivo = archivo[:datafile].original_filename.to_s
    fecha1 = fecha.split('-')
    logger.info "Fecha 1 ============>" << fecha1.inspect

    fecha_proc = fecha
    logger.info "Fecha Proc ====> " << fecha_proc.to_s

    fecha_valor = fecha_proc
    fecha_proc = Time.new.strftime("%Y-%m-%d")

    #sh = Shell.new
    name = /^[a-z]+.TXT/
    @numero_procesado = 0
    @monto_procesado = 0.00
    @numero_leidos = 0
    @monto_leido = 0.00
    @numeros_leidos_anteriores = 0
    archivonumero = 0

    entidad = EntidadFinanciera.find(entidad_financiera_id)

    #Find.find("#{Rails.public_path}/documentos/cobranza/recepcion") do |path|

      #logger.info "Path =====> " << path.to_s
      #Find.prune if [".txt",".",".."].include? path

        #if File.basename(path) == archivo

          #logger.info "Path ======> " << path.inspect
          #archivo = File.basename(path)
          #logger.info "Archivo <=========> #{archivo.inspect}"
          @archivomov = archivo

          logger.info "Entra a verificar archivo ===========> #{nombre_archivo} <---> #{fecha_proc} <----> #{fecha_valor} <----> #{entidad_financiera_id.to_s} <----> #{cuenta_matriz} <----> #{tipo}"
          respuesta = self.verifica_archivo_procesado(nombre_archivo,fecha_proc,fecha_valor,entidad_financiera_id,cuenta_matriz,tipo)

          if respuesta != "0"

            return respuesta

          end

          logger.info "El archivo para abrir es ===================> #{nombre_archivo}"
          directory = "tmp"
          count = 0
          path = File.join(directory, nombre_archivo)
          #logger.debug "esto " << path.class.to_s << path.to_s << archivo[:datafile].tempfile.to_s             

          File.open(path, "wb") { |f| f.write(archivo[:datafile].read) } 

          transaction do

            File.foreach(path) do |line|

              logger.info 'Abrio Archivo'

              logger.info "Linea =======> #{line.inspect}"

              #contador_linea += 1

              linea = line
              linea = line.gsub("\r\n", "").to_s
              linea = linea.gsub(/[áÁäÄ]/, 'a')
              linea = linea.gsub(/[éÉëË]/, 'e')
              linea = linea.gsub(/[íÍïÏ]/, 'i')
              linea = linea.gsub(/[óÓöÖ]/, 'o')
              linea = linea.gsub(/[úÚüÜ]/, 'u')
              linea = linea.gsub(/[ñÑ]/, 'ñ')
              linea = linea.gsub(/[#°ººÂÃ@]/, ' ')
              linea = linea.delete('"')

              constante = linea[0,3]
              cuenta = linea[3,20]
              prestamo = linea[23,11]
              cuota = linea[34,15]
              relleno = linea[49,12]
              cobro = linea[61,1]
              descripcion = linea[62,31]
              codigo = linea[93,2]

              cuota = cuota.to_f / 100

              @numero_leidos += 1
              @monto_leido += cuota

              if @numero_leidos > @numeros_leidos_anteriores

                if cobro.to_i == 1

                  logger.info "Numero Leidos =======> #{@numero_leidos.to_s}"
                  campos_excepcion = Hash.new
                  campos_excepcion["fecha"] = Time.now.strftime("%Y-%m-%d")
                  campos_excepcion["archivo"] = archivo
                  campos_excepcion["monto_pago"] = cuota.to_f
                  campos_excepcion["prestamo_numero"] = prestamo.to_i
                  campos_excepcion["entidad_financiera_id"] = entidad_financiera_id.to_i

                  logger.info "Numero prestamo <<<<<========>>>>> #{prestamo}"
                  nro = prestamo.to_i
                  @prestamocobro = @prestamo1.find_by_numero(nro)
                  logger.info "PRESTAMO ==========> #{@prestamocobro.inspect}"
                  if @prestamocobro.nil?

                    campos_excepcion["codigo_error"] = 20
                    campos_excepcion["descripcion_error"] = I18n.t('Sistema.Body.Modelos.ControlCobranzas.Errores.prestamo_no_existe')
                    @rechazo_cobranza.graba_excepcion(campos_excepcion)
                    break
                  end

                  @solicitud = @solicitud1.find(@prestamocobro.solicitud_id)
                  logger.info "Solicitud ==========> #{@solicitud.inspect}"
                  if @solicitud.nil?

                    campos_excepcion["solicitud_numero"] = @prestamocobro.solicitud_id.to_i
                    campos_excepcion["codigo_error"] = 21
                    campos_excepcion["descripcion_error"] = I18n.t('Sistema.Body.Modelos.ControlCobranzas.Errores.solicitud_no_existe')
                    @rechazo_cobranza.graba_excepcion(campos_excepcion)
                    break
                  end

                  @cliente = @cliente1.find(@solicitud.cliente_id)
                  logger.info "Cliente ==========> #{@cliente.inspect}"
                  if @cliente.nil?

                    campos_excepcion["cliente_id"] = @solicitud.cliente_id.to_i
                    campos_excepcion["codigo_error"] = 22
                    campos_excepcion["descripcion_error"] = I18n.t('Sistema.Body.Modelos.ControlCobranzas.Errores.cliente_no_existe')
                    @rechazo_cobranza.graba_excepcion(campos_excepcion)
                    break

                  end

                  numero_voucher = Time.now.strftime("%Y%m%d") << @numero_procesado.to_s
                  cheques = Hash.new
                  cheques["forma"] = 0.to_s
                  cheques["entidad_financiera_id"] = entidad.id.to_s
                  cheques["referencia"] = numero_voucher.to_s
                  cheques["monto"] = cuota.to_s
                  cheques = {}
                  #exito = @prestamocobro.ejecutar_pago(@cliente.id, cheques,' ',@prestamocobro.id, 'O', cuota, 1, Time.now.strftime("%Y-%m-%d"), Time.now.strftime("%Y-%m-%d"), numero_voucher, 150, cuota, false, 383)
                  logger.info "Entrando a ejecutar_pago"
                  #logger.info "Responde a ========> #{@prestamocobro.respond_to?(ejecutar_pago)}"
                  comando = "@prestamocobro.ejecutar_pago(#{@cliente.id.to_s}, #{cheques},' ',#{@prestamocobro.id}, 'O', #{cuota}, #{@solicitud.oficina_id.to_s}, #{fecha_proc}, #{fecha_proc}, #{numero_voucher}, #{150}, #{cuota}, false, 564, false, 'Pago Domiciliado', 1,false, 0)"
                  logger.info "Comando  =======> #{comando}"
                  oficina = Oficina.find(@solicitud.oficina_id)
                  exito = @prestamocobro.ejecutar_pago(@cliente.id, 
                                                        cheques,
                                                        ' ',
                                                        @prestamocobro.id, 
                                                        'D', 
                                                        cuota, 
                                                        oficina, 
                                                        fecha_proc, 
                                                        fecha_proc, 
                                                        numero_voucher, 
                                                        entidad.id, 
                                                        cuota, 
                                                        false, 
                                                        usuario_id,
                                                        false, 
                                                        'Pago Domiciliado', 
                                                        1,
                                                        false, 
                                                        0)

                  logger.info "Exito ==========> #{exito}"
                  if exito
                    @numero_procesado += 1
                    @monto_procesado += cuota
                  end

                else

                  campos_excepcion = Hash.new
                  campos_excepcion["fecha"] = Time.now.strftime("%Y-%m-%d")
                  campos_excepcion["archivo"] = nombre_archivo
                  campos_excepcion["monto_pago"] = cuota.to_f
                  campos_excepcion["prestamo_numero"] = prestamo.to_i
                  campos_excepcion["codigo_error"] = codigo
                  campos_excepcion["descripcion_error"] = descripcion
                  campos_excepcion["entidad_financiera_id"] = entidad.id
                  @rechazo_cobranza.graba_excepcion(campos_excepcion)

                end         # if cobro == 1

              end           # if @numero_leidos > @numeros_leidos_anteriores

              #puts "constante 1 ---> " << constante.to_s
              #puts "cuenta 2 ---> " << cuenta.to_s
              #puts "prestamo 3 ---> " << prestamo.to_s
              #puts "cuota 4 ---> " << cuota.to_s
              #puts "relleno 5 ---> " << relleno.to_s
              #puts "cobro 6 ---> " << cobro.to_s
              #puts "descripcion 7 ---> " << descripcion.to_s
              #puts "codigo 8 ---> " << codigo.to_s
              #puts "Número procesado ====> " << @numero_procesado.to_s


            end         # ---> File.foreach(path) do |line|

          end   #Fin trasaction do
          # if !archivo.nil?
          #   FileUtils.mv("#{path}","#{Rails.public_path}/documentos/cobranza/procesado", :verbose=>true)
          # end


        #end             # ---. if archivo == "banfoandes.TXT"

      if !@controlcobranza.nil?

        @controlcobranza.procesamiento = 2
        @controlcobranza.numero_procesado = @numero_procesado
        @controlcobranza.monto_procesado = @monto_procesado
        @controlcobranza.numero_leido = @numero_leidos
        @controlcobranza.monto_leido = @monto_leido
        @controlcobranza.save

      end

    #end   # ---> ---> Find.find("/home/dbertaso/sandboxes/banmujer/db") do |path|
    return respuesta

  end

  def self.ejecutar_cobranzas_caroni(archivo,fecha,usuario_id,cuenta_matriz,entidad_financiera_id,tipo)

    #require 'fill_common.rb'
    #require "find"
    respuesta = ""
    logger.info "Fecha modelo ============>" << fecha.to_s
    logger.info "Archivo  modelo ============>" << archivo.inspect
    fecha1 = fecha.split('-')
    nombre_archivo = archivo[:datafile].original_filename.to_s
    logger.info "Fecha 1 ============>" << fecha1.inspect

    fecha_proc = fecha
    logger.info "Fecha Proc ====> " << fecha_proc

    fecha_archivo = fecha_proc
    fecha_proc = Time.new.strftime("%Y-%m-%d")

    #sh = Shell.new
    name = /^[a-z]+.TXT/
    @numero_procesado = 0
    @monto_procesado = 0.00
    @numero_leidos = 0
    @monto_leido = 0.00
    @numeros_leidos_anteriores = 0
    archivonumero = 0

    entidad = EntidadFinanciera.find(entidad_financiera_id.to_i)

    #Find.find("#{Rails.public_path}/documentos/cobranza/recepcion") do |path|

      Find.prune if [".","..","txt"].include? path

      logger.info "basename =========> " << path.to_s

      #if File.basename(path) == archivo

        logger.info "PATH =========> " << path.to_s
          
        #archivo = File.basename(path)
          
        #if archivonumero == 0

          respuesta = self.verifica_archivo_procesado(nombre_archivo,fecha_proc,fecha_valor,entidad_financiera_id,cuenta_matriz,tipo)

          if respuesta != "0"

            return respuesta
          end

          #Dir.chdir("#{Rails.public_path}/documentos/cobranza/recepcion")
          logger.info "Archivo Cobranzas =======> #{archivo}"
          directory = "tmp"
          count = 0
          path = File.join(directory, nombre_archivo)
          #logger.debug "esto " << path.class.to_s << path.to_s << archivo[:datafile].tempfile.to_s             

          File.open(path, "wb") { |f| f.write(data[:datafile].read) } 

          transaction do 
            File.foreach(path) do |line|

              linea = line.gsub("\r\n", "").to_s
              linea = linea.gsub(/[áÁäÄ]/, 'a')
              linea = linea.gsub(/[éÉëË]/, 'e')
              linea = linea.gsub(/[íÍïÏ]/, 'i')
              linea = linea.gsub(/[óÓöÖ]/, 'o')
              linea = linea.gsub(/[úÚüÜ]/, 'u')
              linea = linea.gsub(/[ñÑ]/, 'ñ')
              linea = linea.gsub(/[#°ººÂÃ@]/, ' ')
              linea = linea.delete('"')

              constante = linea[0,3]
              cuenta = linea[3,20]
              prestamo = linea[23,11]
              cuota = linea[34,15]
              relleno = linea[49,12]
              cobro = linea[61,1]
              descripcion = linea[62,31]
              codigo = linea[93,2]

              if constante == 2

                @numero_leidos += 1
                cuota = cuota.to_f / 100
                @monto_leido += cuota

              end

              if @numero_leidos > @numeros_leidos_anteriores

                if cobro.to_i == 0 &&
                  constante == 2

                  campos_excepcion = Hash.new
                  campos_excepcion["fecha"] = Time.now.strftime("%Y-%m-%d")
                  campos_excepcion["archivo"] = archivo
                  campos_excepcion["monto_pago"] = cuota.to_f
                  campos_excepcion["prestamo_numero"] = prestamo.to_i
                  campos_excepcion["entidad_financiera_id"] = entidad_financiera_id.to_i

                  nro = prestamo.to_i
                  @prestamocobro = @prestamo1.find_by_numero(nro)

                  if @prestamocobro.nil?

                    campos_excepcion["codigo_error"] = 20
                    campos_excepcion["descripcion_error"] = 'Préstamo No existe'
                    @rechazo_cobranza.graba_excepcion(campos_excepcion)
                    break
                  end

                  @solicitud = @solicitud1.find(@prestamocobro.solicitud_id)


                  if @solicitud.nil?

                    campos_excepcion["solicitud_numero"] = @prestamocobro.solicitud_id.to_i
                    campos_excepcion["codigo_error"] = 21
                    campos_excepcion["descripcion_error"] = 'Solicitud No existe'
                    @rechazo_cobranza.graba_excepcion(campos_excepcion)
                    break
                  end

                  @cliente = @cliente1.find(@solicitud.cliente_id)

                  if @cliente.nil?

                    campos_excepcion["cliente_id"] = @solicitud.cliente_id.to_i
                    campos_excepcion["codigo_error"] = 22
                    campos_excepcion["descripcion_error"] = 'Cliente relacionado con el crédito No existe'
                    @rechazo_cobranza.graba_excepcion(campos_excepcion)
                    break

                  end

                  numero_voucher = Time.now.strftime("%Y%m%d") << @numero_procesado.to_s
                  cheques = Hash.new
                  cheques["forma"] = 0.to_s
                  cheques["entidad_financiera_id"] = entidad.id.to_s
                  cheques["referencia"] = numero_voucher.to_s
                  cheques["monto"] = cuota.to_s
                  cheques = nil
                  #exito = @prestamocobro.ejecutar_pago(@cliente.id, cheques,' ',@prestamocobro.id, 'O', cuota, 1, Time.now.strftime("%Y-%m-%d"), Time.now.strftime("%Y-%m-%d"), numero_voucher, 150, cuota, false, 383)
                  oficina = Oficina.find(@solicitud.oficina_id)
                  exito = @prestamocobro.ejecutar_pago( @cliente.id, 
                                                        cheques,
                                                        ' ',
                                                        @prestamocobro.id, 
                                                        'D', 
                                                        cuota, 
                                                        oficina, 
                                                        fecha_proc, 
                                                        fecha_proc, 
                                                        numero_voucher, 
                                                        entidad_id, 
                                                        cuota, 
                                                        false, 
                                                        usuario_id,
                                                        false, 
                                                        'Pago Domiciliado', 
                                                        1,
                                                        false, 
                                                        0)

                  if exito

                    @numero_procesado += 1
                    @monto_procesado += cuota
                  end

                else

                  campos_excepcion = Hash.new
                  campos_excepcion["fecha"] = Time.now.strftime("%Y-%m-%d")
                  campos_excepcion["archivo"] = archivo
                  campos_excepcion["monto_pago"] = cuota.to_f
                  campos_excepcion["prestamo_numero"] = prestamo.to_i
                  campos_excepcion["codigo_error"] =  codigo
                  campos_excepcion["descripcion_error"] = descripcion
                  campos_excepcion["entidad_financiera_id"] = entidad.id
                  @rechazo_cobranza.graba_excepcion(campos_excepcion)

                end         # if cobro == 1

              end           # if @numero_leidos > @numeros_leidos_anteriores

            end         # ---> File.foreach(archivo) do |line|

          end  #fin transaction do
          
            # if !archivo.nil?
            #   FileUtils.mv("#{path}","#{Rails.public_path}/documentos/cobranza/procesado", :verbose=>true)
            # end
        
        #end           # ---> if archivonumero == 0

      #end             # ---. if archivo == "banfoandes.TXT"

      if !@controlcobranza.nil?

        @controlcobranza.procesamiento = 2
        @controlcobranza.numero_procesado = @numero_procesado
        @controlcobranza.monto_procesado = @monto_procesado
        @controlcobranza.numero_leido = @numero_leidos
        @controlcobranza.monto_leido = @monto_leido

        @controlcobranza.save
          
      end

    #end   # ---> ---> Find.find("/home/dbertaso/sandboxes/banmujer/db") do |path|

    return respuesta
  end

end

# == Schema Information
#
# Table name: control_cobranza
#
#  id                    :integer         not null, primary key
#  fecha                 :date            default(Mon, 01 Jan 1900)
#  archivo               :string(100)
#  procesamiento         :integer         default(0)
#  numero_procesado      :integer         default(0)
#  monto_procesado       :decimal(, )
#  numero_leido          :integer         default(0)
#  monto_leido           :decimal(16, 2)  default(0.0)
#  fecha_cierre          :date            default(Mon, 01 Jan 1900)
#  entidad_financiera_id :integer
#  numero_cuenta         :string(20)
#  tipo_cuenta           :string(1)
#

