# encoding: utf-8

#
# 
# clase: PlanInventario
# descripción: Migración a Rails 3
#


class PlanInventario < ActiveRecord::Base

  self.table_name = 'plan_inventario'
  
  def self.validar_libres(params)
    array_catalogo = params[:catalogo_id].split(',')
    msj = ""
    array_catalogo.each { |x|
      catalogo = Catalogo.find_by_id(x)
      unless catalogo.estatus=='L'
        msj = catalogo.serial + "," + msj
      end
    }
    return msj.chop
  end

  def self.validar(solicitud_id)
    solicitud = Solicitud.find(solicitud_id)
    @producto = Producto.find_by_programa_id_and_sector_id_and_sub_sector_id(solicitud.programa_id, solicitud.sector_id, solicitud.sub_sector_id)
    unless @producto.class.name == 'NilClass'
      tasa = Tasa.find_by_sub_rubro_id(solicitud.sub_rubro_id)
      unless tasa.nil?
        return true
      else
        return false
      end
    else
      return false
    end
  end

  def self.asignar_catalogo_inventario params, session
    begin
    transaction do
      unless params[:catalogo_id].nil?
        seriales=""
        array_catalogo = params[:catalogo_id].split(',')
        array_catalogo.each { |x|
          catalogo = Catalogo.find_by_id(x)

            if catalogo.estatus=='L'      
                catalogo.solicitud_id = params[:solicitud_id]
                catalogo.estatus = 'R'
                catalogo.save!
                solicitud = Solicitud.find_by_id(params[:solicitud_id])
                seriales = catalogo.serial + "," + seriales

                prestamo = Prestamo.find_by_solicitud_id(params[:solicitud_id])
                parametro = ParametroGeneral.find(1)

                # ----------------------------------------------------------------------
                # Ajuste para ubicar la tasa segun el subrubro y no por el tipo cliente
                # Efectuado por Alexander Cioffi 18-04-2012
                # ----------------------------------------------------------------------
                tasa = Tasa.find_by_sub_rubro_id(solicitud.sub_rubro_id)
                @tasa_valor = TasaValor.find_by_sql("Select * from tasa_valor where tasa_id = #{tasa.id} order by id desc LIMIT 1")
                @tasa_valor = @tasa_valor[0]

                if prestamo.nil?
                  
                  numero = parametro.numero_prestamo_inicial + 1
                  parametro.numero_prestamo_inicial = numero
                  parametro.save!

                  #condiciones = CondicionesFinanciamiento.find_by_rubro_id(solicitud.rubro_id)

                  @producto = Producto.find_by_programa_id_and_sector_id_and_sub_sector_id(solicitud.programa_id, solicitud.sector_id, solicitud.sub_sector_id)

                  #tasa = Tasa.find_by_tipo_cliente_id(solicitud.cliente.tipo_cliente_id)

                  #@tasa_valor = TasaValor.find_by_tasa_id(tasa.id)

                  prestamo = Prestamo.new(:solicitud=>solicitud, :producto=>@producto, :oficina=>session[:oficina], :destinatario=>"E")
                  #prestamo.tasa_inicial=@tasa_valor.valor

                  # ----------------------------------------------------------------------
                  # Ajuste para ubicar la tasa segun el subrubro y no por el tipo cliente
                  # Efectuado por Alexander Cioffi 18-04-2012
                  # ----------------------------------------------------------------------

                  prestamo.tasa_inicial = @tasa_valor.valor
                  prestamo.tasa_vigente = @tasa_valor.valor
                  prestamo.tasa_valor = @tasa_valor.valor
                  prestamo.tasa_referencia_inicial = @tasa_valor.valor
                  prestamo.tasa_id = tasa.id

                  prestamo.monto_inventario=catalogo.monto
                  prestamo.monto_solicitado = catalogo.monto
                  prestamo.monto_aprobado = catalogo.monto
                  prestamo.save!
                else
                  # ----------------------------------------------------------------------
                  # Ajuste para ubicar la tasa segun el subrubro y no por el tipo cliente
                  # Efectuado por Alexander Cioffi 18-04-2012
                  # ----------------------------------------------------------------------

                  prestamo.tasa_inicial = @tasa_valor.valor
                  prestamo.tasa_vigente = @tasa_valor.valor
                  prestamo.tasa_valor = @tasa_valor.valor
                  prestamo.tasa_referencia_inicial = @tasa_valor.valor
                  prestamo.tasa_id = tasa.id

                  prestamo.monto_inventario= prestamo.monto_inventario + catalogo.monto
                  prestamo.monto_aprobado = prestamo.monto_inventario
                  prestamo.monto_solicitado = prestamo.monto_inventario
                  prestamo.save!
                  solicitud.monto_solicitado =  prestamo.monto_aprobado
                  solicitud.monto_aprobado = prestamo.monto_aprobado
                  solicitud.save!
                end
                sras_primer_ano = 0
                sras_anos_siguen = 0
                factor_mensual_primer_ano = parametro.porcentaje_sras_primer_ano / 1200
                factor_mensual_anos_siguen = parametro.porcentaje_sras_anos_subsiguientes / 1200
                if prestamo.plazo <= 12
                  sras_primer_ano = (prestamo.monto_solicitado * factor_mensual_primer_ano) * 12
                  sras_anos_siguen = 0.00
                end

                if prestamo.plazo > 12
                  sras_primer_ano = (prestamo.monto_solicitado * factor_mensual_primer_ano) * 12
                  sras_anos_siguen = (prestamo.monto_solicitado * factor_mensual_anos_siguen) * (prestamo.plazo - 12)
                end

                sras_total = sras_primer_ano + sras_anos_siguen

                prestamo.monto_sras_primer_ano = sras_primer_ano
                prestamo.monto_sras_anos_subsiguientes = sras_anos_siguen
                prestamo.monto_sras_total = sras_total
                #-----------------------------------------------------------------
                # Inicio de la Rutina para ajustar el total gastos en el prestamo 
                # Alexander Cioffi 23/03/2012                                     
                #-----------------------------------------------------------------
                @gastos = ProgramaTipoGasto.find_by_programa_id_and_tipo_gasto_id(solicitud.programa_id, 1)
                total_gasto = 0.00
                unless (@gastos.nil?)        
                    if @gastos.porcentaje > 0
                        monto = ((prestamo.monto_inventario)*(@gastos.porcentaje/100))
                    else
                        monto = @gastos.monto_fijo 
                    end
                    total_gasto = monto
                end
                prestamo.monto_gasto_total = total_gasto.to_f
                #-----------------------------------------------------------------  
                # Fin  de la Rutina para ajustar el total gastos en el prestamo 
                #-----------------------------------------------------------------
                prestamo.save!
                solicitud.monto_solicitado =  prestamo.monto_aprobado + prestamo.monto_sras_total + prestamo.monto_gasto_total
                solicitud.monto_aprobado = solicitud.monto_solicitado
                solicitud.save!
            end
        }
        return seriales.chop

      end
    end
    rescue 
      return ""
    end
  end

  def self.actualizar_prestamo catalogo_id

    transaction do
      parametro = ParametroGeneral.find(1)
      catalogo = Catalogo.find_by_id(catalogo_id)
      prestamo = Prestamo.find_by_solicitud_id(catalogo.solicitud_id)
      catalogo.estatus      = 'L'
      catalogo.solicitud_id = nil
      catalogo.save

      prestamo.monto_inventario = prestamo.monto_inventario.to_f - catalogo.monto.to_f
      prestamo.monto_aprobado = prestamo.monto_inventario
      prestamo.monto_solicitado = prestamo.monto_inventario

      sras_primer_ano = 0
      sras_anos_siguen = 0
      factor_mensual_primer_ano = parametro.porcentaje_sras_primer_ano / 1200
      factor_mensual_anos_siguen = parametro.porcentaje_sras_anos_subsiguientes / 1200
      logger.debug "sras_primer_ano " + sras_primer_ano.to_s
      if prestamo.plazo <= 12
        sras_primer_ano = (prestamo.monto_solicitado * factor_mensual_primer_ano) * 12
        sras_anos_siguen = 0.00
      end
      logger.debug "sras_primer_ano 2 " + sras_primer_ano.to_s
      if prestamo.plazo > 12
        sras_primer_ano = (prestamo.monto_solicitado * factor_mensual_primer_ano) * 12
        sras_anos_siguen = (prestamo.monto_solicitado * factor_mensual_anos_siguen) * (prestamo.plazo - 12)
      end
      logger.debug "sras_primer_ano 3 " + sras_primer_ano.to_s
      sras_total = sras_primer_ano + sras_anos_siguen

      prestamo.monto_sras_primer_ano = sras_primer_ano
      prestamo.monto_sras_anos_subsiguientes = sras_anos_siguen
      prestamo.monto_sras_total = sras_total
      #-----------------------------------------------------------------
      # Inicio de la Rutina para ajustar el total gastos en el prestamo 
      # Alexander Cioffi 23/03/2012                                     
      #-----------------------------------------------------------------
      logger.debug "Rutina de Gastos al crear el prestamo"
      @gastos = ProgramaTipoGasto.find_by_programa_id_and_tipo_gasto_id(prestamo.solicitud.programa_id, 1)
      logger.debug "GASTOS==============> "<<@gastos.inspect
      total_gasto = 0.00
      unless (@gastos.nil?)        
        if @gastos.porcentaje > 0
            monto = ((prestamo.monto_inventario)*(@gastos.porcentaje/100))
        else
            monto = @gastos.monto_fijo 
        end
        total_gasto = monto
      end
      prestamo.monto_gasto_total = total_gasto.to_f
      #-----------------------------------------------------------------  
      # Fin  de la Rutina para ajustar el total gastos en el prestamo 
      #-----------------------------------------------------------------
      prestamo.save
      prestamo.solicitud.monto_solicitado =  prestamo.monto_aprobado + prestamo.monto_sras_total + prestamo.monto_gasto_total
      prestamo.solicitud.monto_aprobado =  prestamo.solicitud.monto_solicitado
      prestamo.solicitud.save

    end
  end

  def self.prestamo solicitud_id

    prestamo = Prestamo.find_by_id(solicitud_id)

    #logger.debug "prestamo:....." << prestamo.inspect

    if prestamo.nil?

      parametro = ParametroGeneral.find(1)
      numero = parametro.numero_prestamo_inicial + 1
      parametro.numero_prestamo_inicial = numero
      parametro.save

      solicitud = Solicitud.find_by_id(solicitud_id)

      condiciones = CondicionesFinanciamiento.find_by_rubro_id(solicitud.rubro_id)

      #logger.debug "rubro id............" << solicitud.rubro_id.to_s

       #prestamo = Prestamo.new
      
      @producto = Producto.find_by_programa_id_and_sector_id_and_sub_sector_id(solicitud.programa_id, solicitud.sector_id, solicitud.sub_sector_id)

      @prestamo = Prestamo.new(:solicitud=>solicitud, :producto=>@producto, :oficina=>session[:oficina], :destinatario=>"E")

      #@prestamo.monto_solicitado = monto_prestamo.to_f

#      logger.debug "producto............." << @prestamo.inspect
      
#      prestamo.tasa_mora_id=1
#      prestamo.save
#
      #logger.debug "solicitud id......." << solicitud.id.to_s
      #logger.debug "condiciones:............." << condiciones.inspect
      #logger.debug "num prestamo......" << parametro.numero_prestamo_inicial.to_s      
#      self.rubro_id = self.solicitud.rubro_id
#      self.fecha_cambio_estatus = Time.now
#      numero = modulo11(numero)
#      self.numero = numero

    end

#    prestamo = Prestamo.find(solicitud_id)

#    logger.debug "prestamo inventario1.................." << prestamo.inspect

    parametro = ParametroGeneral.find(1)
    #condiciones = CondicionesFinanciamiento.find_by_rubro_id(self.solicitud.rubro.id)

  end

end
