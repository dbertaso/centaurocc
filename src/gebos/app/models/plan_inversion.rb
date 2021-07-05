# encoding: utf-8

#
# 
# clase: PlanInversion
# descripción: Migración a Rails 3
#

class PlanInversion < ActiveRecord::Base

  self.table_name = 'plan_inversion'
  
  attr_accessible :id,
				  :solicitud_id,
				  :estado_nombre,
				  :oficina_nombre,
				  :sector_nombre,
				  :sub_sector_nombre,
				  :rubro_nombre,
				  :partida_nombre,
				  :item_nombre,
				  :unidad_medida_id,
				  :numero_desembolso,
				  :costo_real,
				  :cantidad,
				  :monto_financiamiento,
				  :monto_desembolsado,
				  :seriales,
				  :marcas,
				  :tipo_item,
				  :cantidad_por_hectarea,
				  :costo_minimo,
				  :costo_maximo,
				  :cantidad_liquidada,
				  :sub_rubro_nombre,
				  :actividad_nombre,
				  :inventario,
          :solicitud,
          :oficina,
          :producto,
          :prestamo,
          :serial_motor,
          :serial_chasis,
          :casa_proveedora_id,
          :moneda

  belongs_to :configurador
  belongs_to :unidad_medida
  belongs_to :solicitud 
  belongs_to :casa_proveedora 


  def costo_real_f
    format_f(self.costo_real)
  end

  def costo_real_fm
    format_fm(self.costo_real)
  end

  def monto_financiamiento_f
    format_f(self.monto_financiamiento)
  end

  def monto_financiamiento_fm
    format_fm(self.monto_financiamiento)
  end


  def monto_desembolsado_f
    format_f(self.monto_desembolsado)
  end

  def monto_desembolsado_fm
    format_fm(self.monto_desembolsado)
  end

  def monto_por_desembolsar_fm
    unless self.monto_desembolsado.nil? || self.monto_financiamiento.nil?
      valor = self.monto_financiamiento - self.monto_desembolsado
      #format_fm(valor)
    end
  end

  def cantidad_f
    format_f3(self.cantidad)
  end

  def cantidad_fm
    format_fm3(self.cantidad)
  end

  def cantidad_por_hectarea_f
    format_f(self.cantidad_por_hectarea)
  end

  def cantidad_por_hectarea_fm
    format_fm(self.cantidad_por_hectarea)
  end

  def costo_minimo_f
    format_f(self.costo_minimo)
  end

  def costo_minimo_fm
    format_fm(self.costo_minimo)
  end

  def costo_maximo_f
    format_f(self.costo_maximo)
  end

  def costo_maximo_fm
    format_fm(self.costo_maximo)
  end

  def actualizar_plan_vegetal(solicitud_id,cantidad,oficina)

    logger.debug "Actualizando Plan Vegetal ===============> "
    oficina_id = oficina
    oficina = Oficina.find(oficina_id)
    @plan_inversion = PlanInversion.find(:all,:conditions=>"solicitud_id = #{solicitud_id}",
                                              :order =>"estado_nombre,oficina_nombre,sector_nombre,tipo_item",
                                              :include=>[:unidad_medida])


    begin

      PlanInversion.transaction do

          params = {
            :p_solicitud_id=>solicitud_id,
            :p_cantidad=>cantidad
          }
          
          ejecutar = execute_sp('actualizar_plan_inversion_costo_fijo', params.values_at(
                :p_solicitud_id,
                :p_cantidad))
                

          solicitud = Solicitud.find(solicitud_id)

          if !solicitud.nil?
            solicitud.hectareas_recomendadas = cantidad
            solicitud.save
          end
        #@plan_inversion.each do |plan|

          #plan.cantidad = cantidad
          #plan.monto_financiamiento = cantidad * plan.costo_real
          #plan.save!

          #if plan.errors.size > 1

             #logger.debug "Errores ========> " << plan.errors.full_messages.to_s
          #end

        #end

        # logger.debug "Actualizo plan de inversión vegetal "

        # sras_primer_ano = 0.00
        # sras_anos_siguen = 0.00
        # sras_total = 0.00
        # plazo_total = 0

        # #Prestamo.transaction do

        #   @solicitud = Solicitud.find(solicitud_id)
        #   @prestamo = Prestamo.find_by_solicitud_id(solicitud_id)
        #   logger.info "Prestamo Leido ==============> #{@prestamo.inspect}"
        #   @plan_inversion = PlanInversion.find_by_solicitud_id(solicitud_id)

        #   #Buscando condiciones de financiamiento

        #   @condiciones = CondicionesFinanciamiento.find_by_programa_id_and_sector_id_and_sub_sector_id_and_rubro_id(@solicitud.programa_id,
        #                                                                                             @solicitud.sector_id,
        #                                                                                             @solicitud.sub_sector_id,
        #                                                                                             @solicitud.rubro_id)
        #   #Buscando tasa beneficiario

        #   #tasa = Tasa.find_by_tipo_cliente_id(solicitud.cliente.tipo_cliente_id)

        #   # ----------------------------------------------------------------------
        #   # Ajuste para ubicar la tasa segun el subrubro y no por el tipo cliente
        #   # Efectuado por Alexander Cioffi 18-04-2012
        #   # ----------------------------------------------------------------------
        #   tasa = Tasa.find_by_sub_rubro_id(@solicitud.sub_rubro_id)
        #   @tasa_valor = TasaValor.find_by_sql("Select * from tasa_valor where tasa_id = #{tasa.id} order by id desc LIMIT 1")
        #   @tasa_valor = @tasa_valor[0]


        #   monto_prestamo = PlanInversion.sum(:monto_financiamiento,:conditions=>"solicitud_id=#{@solicitud.id}")
        #   @plan_inversion = PlanInversion.find(:all, :conditions=>"solicitud_id = #{@solicitud.id}",:order =>"estado_nombre,oficina_nombre,sector_nombre,tipo_item")

        #   @solicitud.hectareas_recomendadas = 0.00
        #   @solicitud.semovientes_recomendados = 0.00

        #   if @solicitud.actividad.paquetizado

        #     @solicitud.hectareas_recomendadas = cantidad
        #     @solicitud.semovientes_recomendados = 0.00
        #   else
        #     @solicitud.hectareas_recomendadas = 0.00
        #     @solicitud.semovientes_recomendados = 0.00
        #   end

        #   @solicitud.semovientes_recomendados = 0.00

        #   @solicitud.semovientes_recomendados = PlanInversion.sum(:cantidad, :conditions=>"(partida_nombre like \'\%SEMOVIENTES\%\' or partida_nombre like \'\%TORO REPRODUCTOR\%\') and solicitud_id = #{@solicitud.id.to_s}")
        #   if @solicitud.semovientes_recomendados.nil?
        #     @solicitud.semovientes_recomendados = 0.00
        #   end

        #   @solicitud.save

        #   monto_prestamo = PlanInversion.sum(:monto_financiamiento,:conditions=>"solicitud_id=#{@solicitud.id}")
        #   monto_banco = PlanInversion.sum(:monto_financiamiento, :conditions=>"solicitud_id=#{@solicitud.id} and tipo_item = 'B'")
        #   monto_insumo = PlanInversion.sum(:monto_financiamiento, :conditions=>"solicitud_id=#{@solicitud.id} and tipo_item = 'I'")

        #   if @prestamo.nil?

        #     @producto = Producto.find_by_programa_id_and_sector_id_and_sub_sector_id(@solicitud.programa_id, @solicitud.sector_id, @solicitud.sub_sector_id)

        #     prestamo = Prestamo.new(:solicitud=>@solicitud, :producto=>@producto, :oficina=>oficina, :destinatario=>"E")

        #     prestamo.monto_solicitado = monto_prestamo.to_f

        #     # ----------------------------------------------------------------------
        #     # Ajuste para ubicar la tasa segun el subrubro y no por el tipo cliente
        #     # Efectuado por Alexander Cioffi 18-04-2012
        #     # ----------------------------------------------------------------------

        #     logger.info "Monto Prestamo =========> #{monto_prestamo.to_s}"
        #     logger.info "Monto Banco =========> #{monto_banco.to_s}"
        #     logger.info "Monto Insumos =========> #{monto_insumo.to_s}"

        #     prestamo.tasa_inicial = @tasa_valor.valor
        #     prestamo.tasa_vigente = @tasa_valor.valor
        #     prestamo.tasa_valor = @tasa_valor.valor
        #     prestamo.tasa_referencia_inicial = @tasa_valor.valor
        #     prestamo.tasa_id = tasa.id

        #     prestamo.monto_banco = monto_banco.to_f
        #     prestamo.monto_insumos = monto_insumo.to_f
            
        #     # -----------------------------------------
        #     # Calculo del sras
        #     # ---------------------rubro---------------

        #     parametro = ParametroGeneral.find(1)
        #     factor_mensual_primer_ano = parametro.porcentaje_sras_primer_ano / 1200
        #     factor_mensual_anos_siguen = parametro.porcentaje_sras_anos_subsiguientes / 1200

        #     plazo_total = prestamo.plazo + prestamo.meses_gracia
        #     if plazo_total <= 12
        #       sras_primer_ano = (prestamo.monto_solicitado * factor_mensual_primer_ano) * 12
        #       sras_anos_siguen = 0.00
        #     end

        #     if plazo_total > 12
        #       sras_primer_ano = (prestamo.monto_solicitado * factor_mensual_primer_ano) * 12
        #       sras_anos_siguen = (prestamo.monto_solicitado * factor_mensual_anos_siguen) * (plazo_total - 12)
        #     end

        #     sras_total = sras_primer_ano + sras_anos_siguen

        #     logger.info "Monto sras primer ======> #{sras_primer_ano.to_s}"
        #     logger.info "Monto sras siguen ======> #{sras_anos_siguen.to_s"
        #     logger.info "Monto sras total ======> #{sras_total.to_s}"

        #     prestamo.monto_sras_primer_ano = sras_primer_ano
        #     prestamo.monto_sras_anos_subsiguientes = sras_anos_siguen
        #     prestamo.monto_sras_total = sras_total
            
        #     logger.info "Monto Sras Total ======> #{prestamo.monto_sras_total.to_s}"
            
        #     #-----------------------------------------------------------------
        #     # Inicio de la Rutina para ajustar el total gastos en el prestamo
        #     # Alexander Cioffi 14/03/2012
        #     #-----------------------------------------------------------------

        #     #logger.debug "Rutina de Gastos al crear el prestamo"
        #     gastos = ProgramaTipoGasto.find_by_programa_id_and_tipo_gasto_id(@solicitud.programa_id, 1)
        #     #logger.debug "GASTOS==============> "<<@gastos.inspect

        #     total_gasto = 0.00
        #     unless (gastos.nil?)
        #       if gastos.porcentaje > 0
        #           monto = ((prestamo.monto_banco + prestamo.monto_insumos)*(gastos.porcentaje/100))
        #       else
        #           monto = gastos.monto_fijo
        #       end
        #       total_gasto = monto
        #     end
        #     prestamo.monto_gasto_total = total_gasto.to_f

        #     #-----------------------------------------------------------------
        #     # Fin  de la Rutina para ajustar el total gastos en el prestamo
        #     #-----------------------------------------------------------------
        #     #-----------------------------------------------------------------
        #     # Inicio de la Rutina para ajustar el monto solicitado en la solicitud
        #     # Luis Rojas / Alexander Cioffi 14/03/2012 y 15/03/2012
        #     #-----------------------------------------------------------------

        #     @solicitud.monto_solicitado = prestamo.monto_banco + prestamo.monto_insumos + prestamo.monto_sras_total + prestamo.monto_gasto_total
        #     @solicitud.monto_aprobado = @solicitud.monto_solicitado
        #     @solicitud.save

        #     #-----------------------------------------------------------------
        #     # Fin  de la Rutina para ajustar el monto solicitado en la solicitud
        #     #-----------------------------------------------------------------

        #     prestamo.save
        #     logger.info "Save despues de insert #{prestamo.errors.full_messages.to_s}"

        #     if prestamo.errors.size == 0
        #       return true
        #     else
        #       return false
        #     end

        #   else
        #     # ----------------------------------------------------------------------
        #     # Ajuste para ubicar la tasa segun el subrubro y no por el tipo cliente
        #     # Efectuado por Alexander Cioffi 18-04-2012
        #     # ----------------------------------------------------------------------

        #     logger.info "Entro por else =======> #{@prestamo.inspect}"
        #     @prestamo.tasa_inicial = @tasa_valor.valor
        #     @prestamo.tasa_vigente = @tasa_valor.valor
        #     @prestamo.tasa_valor = @tasa_valor.valor
        #     @prestamo.tasa_referencia_inicial = @tasa_valor.valor
        #     @prestamo.tasa_id = tasa.id

        #     # ------------------------------------
        #     # Calculo del sras
        #     # ------------------------------------

        #     parametro = ParametroGeneral.find(1)
        #     logger.info "Parametro General =======> #{parametro.inspect}"
        #     logger.info "Prestamo ================> #{@prestamo.inspect}"
        #     factor_mensual_primer_ano = parametro.porcentaje_sras_primer_ano / 1200
        #     factor_mensual_anos_siguen = parametro.porcentaje_sras_anos_subsiguientes / 1200

        #     monto_prestamo = PlanInversion.sum(:monto_financiamiento,:conditions=>"solicitud_id=#{@solicitud.id}")
        #     monto_banco = PlanInversion.sum(:monto_financiamiento, :conditions=>"solicitud_id=#{@solicitud.id} and tipo_item = 'B'")
        #     monto_insumo = PlanInversion.sum(:monto_financiamiento, :conditions=>"solicitud_id=#{@solicitud.id} and tipo_item = 'I'")

        #     plazo_total = @prestamo.plazo + @prestamo.meses_gracia

        #     if plazo_total <= 12
        #       sras_primer_ano = (monto_prestamo.to_f * factor_mensual_primer_ano) * 12
        #       sras_anos_siguen = 0.00
        #     end

        #     if plazo_total > 12
        #       sras_primer_ano = (monto_prestamo.to_f * factor_mensual_primer_ano) * 12
        #       sras_anos_siguen = (monto_prestamo.to_f * factor_mensual_anos_siguen) * (plazo_total - 12)
        #     end

        #     sras_total = sras_primer_ano + sras_anos_siguen

        #     @prestamo.monto_sras_primer_ano = sras_primer_ano
        #     @prestamo.monto_sras_anos_subsiguientes = sras_anos_siguen
        #     @prestamo.monto_sras_total = sras_total
        #     @prestamo.monto_banco = monto_banco.to_f
        #     @prestamo.monto_insumos = monto_insumo.to_f
        #     @prestamo.monto_solicitado = monto_prestamo.to_f

        #     #-----------------------------------------------------------------
        #     # Inicio de la Rutina para ajustar el total gastos en el prestamo
        #     # Alexander Cioffi 14/03/2012
        #     #-----------------------------------------------------------------

        #     #logger.debug "Rutina de Gastos al modificar el prestamo"
        #     @gastos = ProgramaTipoGasto.find_by_programa_id_and_tipo_gasto_id(@solicitud.programa_id, 1)
        #     #logger.debug "GASTOS==============> "<<@gastos.inspect
        #     total_gasto = 0.00

        #     unless (@gastos.nil?)
        #       if @gastos.porcentaje > 0
        #           monto = ((@prestamo.monto_banco + @prestamo.monto_insumos)*(@gastos.porcentaje/100))
        #       else
        #           monto = @gastos.monto_fijo
        #       end
        #       total_gasto = monto
        #     end
        #     @prestamo.monto_gasto_total = total_gasto.to_f

        #     #-----------------------------------------------------------------
        #     # Fin  de la Rutina para ajustar el total gastos en el prestamo
        #     #-----------------------------------------------------------------
        #     #-----------------------------------------------------------------
        #     # Inicio de la Rutina para ajustar el monto solicitado en la solicitud
        #     # Luis Rojas / Alexander Cioffi 14/03/2012 y 15/03/2012
        #     #-----------------------------------------------------------------
        #     @solicitud.monto_solicitado = @prestamo.monto_banco + @prestamo.monto_insumos + @prestamo.monto_sras_total + @prestamo.monto_gasto_total
        #     @solicitud.monto_aprobado = @solicitud.monto_solicitado
        #     @solicitud.save

        #     #-----------------------------------------------------------------
        #     # Fin  de la Rutina para ajustar el monto solicitado en la solicitud
        #     #-----------------------------------------------------------------
        #     @prestamo.save
        #     logger.info "Save despues de actualizacion #{@prestamo.errors.full_messages.to_s}"
        #     if @prestamo.errors.size == 0
        #       return true
        #     else
        #       return false
        #     end

        #   end

        # #end     # ----> Fin Prestamo.transaction do

      end   #Fin PlanInversion.transaction do
      
    rescue Exception => e

      logger.info "Entro en rescue #{e.message}"
      errors.add(:plan_inversion, I18n.t('Sistema.Body.Modelos.Errores.registro_bloqueado'))
      return false

    end

    return true

  end

  def self.crear_prestamo(solicitud_id)

    begin

      Prestamo.transaction do

        logger.debug "Actualizo plan de inversión vegetal "

        sras_primer_ano = 0.00
        sras_anos_siguen = 0.00
        sras_total = 0.00
        monto_prestamo = 0.00
        monto_banco = 0.00
        monto_insumo = 0.00
        monto = 0.00
        gasto_total = 0.00

        sras_primer_ano = sras_primer_ano.to_d
        sras_anos_siguen = sras_anos_siguen.to_d
        sras_total = sras_total.to_d
        monto_prestamo = monto_prestamo.to_d
        monto_banco = monto_banco.to_d
        monto_insumo = monto_insumo.to_d
        monto = monto.to_d
        gasto_total = gasto_total.to_d


        @solicitud = Solicitud.find(solicitud_id)
        oficina = Oficina.find(@solicitud.oficina_id)
        @prestamo = Prestamo.find_by_solicitud_id(solicitud_id)
        logger.info "Prestamo Leido ==============> #{@prestamo.inspect}"
        @plan_inversion = PlanInversion.find_by_solicitud_id(solicitud_id)

        #Buscando condiciones de financiamiento

        @condiciones = CondicionesFinanciamiento.find_by_programa_id_and_sector_id_and_sub_sector_id_and_rubro_id_and_actividad_id(@solicitud.programa_id,
                                                                                                  @solicitud.sector_id,
                                                                                                  @solicitud.sub_sector_id,
                                                                                                  @solicitud.rubro_id,
                                                                                                  @solicitud.sub_rubro_id,
                                                                                                  @solicitud.actividad_id)
        #Buscando tasa beneficiario

        #tasa = Tasa.find_by_tipo_cliente_id(solicitud.cliente.tipo_cliente_id)

        # ----------------------------------------------------------------------
        # Ajuste para ubicar la tasa segun el subrubro y no por el tipo cliente
        # Efectuado por Alexander Cioffi 18-04-2012
        # ----------------------------------------------------------------------

        tasa = Tasa.find_by_sub_rubro_id(@solicitud.sub_rubro_id)
        @tasa_valor = TasaValor.find_by_sql("Select * from tasa_valor where tasa_id = #{tasa.id} order by id desc LIMIT 1")
        @tasa_valor = @tasa_valor[0]


        monto_prestamo = PlanInversion.sum(:monto_financiamiento,:conditions=>"solicitud_id=#{@solicitud.id}")
        @plan_inversion = PlanInversion.find(:all, :conditions=>"solicitud_id = #{@solicitud.id}",:order =>"estado_nombre,oficina_nombre,sector_nombre,tipo_item")

        # #@solicitud.hectareas_recomendadas = 0.00
        # @solicitud.semovientes_recomendados = 0.00

        # if @solicitud.actividad.paquetizado

        #   #@solicitud.hectareas_recomendadas = cantidad
        #   #@solicitud.semovientes_recomendados = 0.00
        # else
        #   @solicitud.hectareas_recomendadas = 0.00
        #   @solicitud.semovientes_recomendados = 0.00
        # end

        @solicitud.semovientes_recomendados = 0.00

        @solicitud.semovientes_recomendados = PlanInversion.sum(:cantidad, :conditions=>"(partida_nombre like \'\%SEMOVIENTES\%\' or partida_nombre like \'\%TORO REPRODUCTOR\%\') and solicitud_id = #{@solicitud.id.to_s}")
        if @solicitud.semovientes_recomendados.nil?
          @solicitud.semovientes_recomendados = 0.00
        end

        @solicitud.save

        monto_prestamo = PlanInversion.sum(:monto_financiamiento,:conditions=>"solicitud_id=#{@solicitud.id}")
        monto_banco = PlanInversion.sum(:monto_financiamiento, :conditions=>"solicitud_id=#{@solicitud.id} and tipo_item = 'B'")
        monto_insumo = PlanInversion.sum(:monto_financiamiento, :conditions=>"solicitud_id=#{@solicitud.id} and tipo_item = 'I'")

        if @prestamo.nil?

          @producto = Producto.find_by_programa_id_and_sector_id_and_sub_sector_id(@solicitud.programa_id, @solicitud.sector_id, @solicitud.sub_sector_id)

          prestamo = Prestamo.new(:solicitud=>@solicitud, :producto=>@producto, :oficina=>oficina, :destinatario=>"E")

          prestamo.monto_solicitado = monto_prestamo

          # ----------------------------------------------------------------------
          # Ajuste para ubicar la tasa segun el subrubro y no por el tipo cliente
          # Efectuado por Alexander Cioffi 18-04-2012
          # ----------------------------------------------------------------------

          logger.info "Monto Prestamo =========> #{monto_prestamo.to_s}"
          logger.info "Monto Banco =========> #{monto_banco.to_s}"
          logger.info "Monto Insumos =========> #{monto_insumo.to_s}"

          prestamo.tasa_inicial = @tasa_valor.valor
          prestamo.tasa_vigente = @tasa_valor.valor
          prestamo.tasa_valor = @tasa_valor.valor
          prestamo.tasa_referencia_inicial = @tasa_valor.valor
          prestamo.tasa_id = tasa.id

          prestamo.monto_banco = monto_banco
          prestamo.monto_insumos = monto_insumo
          
          # -----------------------------------------
          # Calculo del sras
          # ---------------------rubro---------------

          parametro = ParametroGeneral.find(1)
          factor_mensual_primer_ano = parametro.porcentaje_sras_primer_ano / 1200
          factor_mensual_anos_siguen = parametro.porcentaje_sras_anos_subsiguientes / 1200

          plazo_total = prestamo.plazo + prestamo.meses_gracia
          if plazo_total <= 12
            sras_primer_ano = (prestamo.monto_solicitado * factor_mensual_primer_ano) * 12
            sras_anos_siguen = 0.00
          end

          if plazo_total > 12
            sras_primer_ano = (prestamo.monto_solicitado * factor_mensual_primer_ano) * 12
            sras_anos_siguen = (prestamo.monto_solicitado * factor_mensual_anos_siguen) * (plazo_total - 12)
          end

          sras_total = sras_primer_ano + sras_anos_siguen

          logger.info "Monto sras primer ======> #{sras_primer_ano.to_s}"
          logger.info "Monto sras siguen ======> #{sras_anos_siguen.to_s}"
          logger.info "Monto sras total ======> #{sras_total.to_s}"

          prestamo.monto_sras_primer_ano = sras_primer_ano
          prestamo.monto_sras_anos_subsiguientes = sras_anos_siguen
          prestamo.monto_sras_total = sras_total
          
          logger.info "Monto Sras Total ======> #{prestamo.monto_sras_total.to_s}"
          
          #-----------------------------------------------------------------
          # Inicio de la Rutina para ajustar el total gastos en el prestamo
          # Alexander Cioffi 14/03/2012
          #-----------------------------------------------------------------

          #logger.debug "Rutina de Gastos al crear el prestamo"
          gastos = ProgramaTipoGasto.find_by_programa_id_and_tipo_gasto_id(@solicitud.programa_id, 1)
          #logger.debug "GASTOS==============> "<<@gastos.inspect

          unless (gastos.nil?)
            if gastos.porcentaje > 0
                monto = ((prestamo.monto_banco + prestamo.monto_insumos)*(gastos.porcentaje/100))
            else
                monto = gastos.monto_fijo
            end
            total_gasto = monto
          end
          prestamo.monto_gasto_total = total_gasto

          #-----------------------------------------------------------------
          # Fin  de la Rutina para ajustar el total gastos en el prestamo
          #-----------------------------------------------------------------
          #-----------------------------------------------------------------
          # Inicio de la Rutina para ajustar el monto solicitado en la solicitud
          # Luis Rojas / Alexander Cioffi 14/03/2012 y 15/03/2012
          #-----------------------------------------------------------------

          prestamo.save
          logger.info "Save despues de insert #{prestamo.errors.full_messages.to_s}"

          if prestamo.errors.size == 0
            @solicitud = Solicitud.find(solicitud_id)
            prestamo = Prestamo.find_by_solicitud_id(@solicitud.id)
            unless prestamo.nil?
              unless @solicitud.nil?
                @solicitud.monto_solicitado = (monto_banco + monto_insumo + sras_total + total_gasto)
                logger.info "Monto Solicitado ===========> #{format_fm(@solicitud.monto_solicitado)}"
                logger.info "Suma Montos ==============> #{format_fm((monto_banco + monto_insumo + sras_total + total_gasto))}"
                @solicitud.monto_aprobado = @solicitud.monto_solicitado
                @solicitud.save
              else
                errors.add(:prestamo. I18n.t('Sistema.Body.Modelos.ControlCobranzas.Errores.solicitud_no_existe'))
                raise ActiveRecord::Rollback
                return false
              end
            else
              errors.add(:prestamo. I18n.t('Sistema.Body.Modelos.ControlCobranzas.Errores.prestamo_no_existe'))
              raise ActiveRecord::Rollback
              return false
            end
            return true
          else
            return false
          end

          #-----------------------------------------------------------------
          # Fin  de la Rutina para ajustar el monto solicitado en la solicitud
          #-----------------------------------------------------------------

        end   #---------> Fin if prestamo.nil?

      end     # ----> Fin Prestamo.transaction do

    rescue Exception => e

      logger.info "Entro en rescue #{e.message}"
      errors.add(:prestamo, I18n.t('Sistema.Body.Modelos.Errores.registro_bloqueado'))
      return false

    end       # ----> Fin del begin

  end         # ----> Fin Crear Prestamo

  def actualizar_plan_general(solicitud_id,params,oficina_id)

    oficina = Oficina.find(oficina_id)
    logger.debug "Actualizando Plan general ===============> #{solicitud_id.to_s}"
    #logger.debug "PARAMETROS                ===============> " << params.inspect

    @errores = ''
    @plan_inversion = PlanInversion.find(:all,:conditions=>"solicitud_id = #{solicitud_id}",
                                              :order =>"estado_nombre,oficina_nombre,sector_nombre,tipo_item",
                                              :include=>[:unidad_medida])

    @errores = ''

    begin

      # Creación del arreglo de los id del plan de inversion
      
      lista_id = Array.new
      params.each do |k,v|
      
        sep = k.split("_")
        
        if sep[0] == 'cantidad' or sep[0] == 'monto'
        
          if v.to_f > 0 
          
            lista_id << sep[1]
          end
          
        end
        
      end
      
      lista_id.uniq!
      
      #Validación de cantidades y montos que se actualizarán en el plan de inversión
      
      @errores = ''
      
      if !lista_id.empty?
      
        lista_id.each do |id|
        

          if params[:"cantidad_#{id}"].to_f > 0 and params[:"monto_#{id}"].to_f == 0
            @errores << "#{I18n.t('Sistema.Body.Modelos.PlanInversion.Errores.cantidad_mayor_que_cero_costo_no_puede_ser_cero')} #{PlanInversion.find(id).item_nombre}" << '|'

          end
          
          logger.info "id #{id.to_s})"
          logger.info "Params monto #{params[:"monto_#{id}"].to_d.to_s} format: #{format_fm(params[:"monto_#{id}"])}"
          logger.info "Monto plan   #{PlanInversion.find(id).costo_maximo.to_s} format: #{PlanInversion.find(id).costo_maximo.to_d.to_s}"
          if params[:"monto_#{id}"].to_d > PlanInversion.find(id).costo_maximo

            @errores << "#{I18n.t('Sistema.Body.Modelos.PlanInversion.Errores.monto_asignado_mayor_que_costo_maximo')} #{PlanInversion.find(id).item_nombre}" << '|'
          end
          
        end
      else
        @errores << I18n.t('Sistema.Body.Modelos.PlanInversion.Errores.debe_tener_al_menos_un_item_con_cantidad_monto')
      end
      
      if !@errores.empty?
      
        return @errores
      end
      
      #Se crea el arreglo de cantidades y montos para pasarlo a la función
      #que actualiza el plan de inversion
      
      if !params.nil?
      
        items_plan = '{'
        primero = true
        if lista_id.empty?
          items_plan = nil
        end
        if !lista_id.empty?
          lista_id.each { |x|  items_plan += ( primero ? '' : ',' ) + '{"' + x.to_s +
          '","' + params["cantidad_#{x}".to_s] +
          '","' + params["monto_#{x}".to_s] + '"}'; primero = false }
        end
        hay_items = true
        items_plan += "}"
      else
        items_plan = '{'
        items_plan += "}"
        hay_items = false
      end
      
      logger.info "Items Plan: ================> #{items_plan.inspect}"
      
      PlanInversion.transaction do

        #Se invoca la función de actualización del plan de inversión
        
        params = {
          :p_solicitud_id=>solicitud_id,
          :p_items_plan =>items_plan,
          :p_hay_items =>hay_items
        }
        
        ejecutar = execute_sp('actualizar_plan_inversion_costo_variable', params.values_at(
              :p_solicitud_id,
              :p_items_plan,
              :p_hay_items))

        #@plan_inversion.each do |plan|

          #if params[:"cantidad_#{plan.id}"].to_f > 0 and params[:"monto_#{plan.id}"].to_f == 0

            #@errores << "Si la cantidad es mayor que cero el costo no puede ser cero #{plan.item_nombre}" << '|'

          #end

          #if params[:"monto_#{plan.id}"].to_f <= plan.costo_maximo.to_f

            ##logger.debug "CANTIDAD #{plan.id} =======> " << params[:"cantidad_#{plan.id}"].to_s
            #logger.debug "MONTO #{plan.id} =======> " << params[:"monto_#{plan.id}"].to_f.to_s
            #logger.debug "MONTO CONFIGURADOR  =======> " << plan.costo_maximo.to_f.to_s

            #plan.cantidad = params[:"cantidad_#{plan.id}"].to_f
            #plan.costo_real = params[:"monto_#{plan.id}"].to_f
            #plan.monto_financiamiento = plan.cantidad.to_f * plan.costo_real.to_f
            #plan.save!

          #else
            #logger.debug "Monto mayor que máximo establecido #{plan.item_nombre}"
            #@errores << "Monto asignado mayor que costo máximo en #{plan.item_nombre}" << '|'
          #end     #===> Fin if params["monto_"]

        #end
        
        #======================================
        # Actualización/Creación del préstamo
        #======================================
        
        # #Prestamo.transaction do

        #   @solicitud = Solicitud.find(solicitud_id)
        #   @prestamo = Prestamo.find_by_solicitud_id(@solicitud.id)
        #   logger.info "Prestamo Leido ==============> #{@prestamo.inspect}"
        #   @plan_inversion = PlanInversion.find_by_solicitud_id(@solicitud.id)

        #   #Buscando condiciones de financiamiento

        #   @condiciones = CondicionesFinanciamiento.find_by_programa_id_and_sector_id_and_sub_sector_id_and_rubro_id(@solicitud.programa_id,
        #                                                                                             @solicitud.sector_id,
        #                                                                                             @solicitud.sub_sector_id,
        #                                                                                             @solicitud.rubro_id)
        #   #Buscando tasa beneficiario

        #   #tasa = Tasa.find_by_tipo_cliente_id(solicitud.cliente.tipo_cliente_id)

        #   # ----------------------------------------------------------------------
        #   # Ajuste para ubicar la tasa segun el subrubro y no por el tipo cliente
        #   # Efectuado por Alexander Cioffi 18-04-2012
        #   # ----------------------------------------------------------------------
        #   tasa = Tasa.find_by_sub_rubro_id(@solicitud.sub_rubro_id)
        #   @tasa_valor = TasaValor.find_by_sql("Select * from tasa_valor where tasa_id = #{tasa.id} order by id desc LIMIT 1")
        #   @tasa_valor = @tasa_valor[0]


        #   monto_prestamo = PlanInversion.sum(:monto_financiamiento,:conditions=>"solicitud_id=#{@solicitud.id}")
        #   @plan_inversion = PlanInversion.find(:all, :conditions=>"solicitud_id = #{@solicitud.id}",:order =>"estado_nombre,oficina_nombre,sector_nombre,tipo_item")

        #   @solicitud.hectareas_recomendadas = 0.00
        #   @solicitud.semovientes_recomendados = 0.00

        #   if @solicitud.actividad.paquetizado

        #     @solicitud.hectareas_recomendadas = 0
        #     @solicitud.semovientes_recomendados = 0.00
        #   else
        #     @solicitud.hectareas_recomendadas = 0.00
        #     @solicitud.semovientes_recomendados = 0.00
        #   end

        #   @solicitud.semovientes_recomendados = 0.00

        #   @solicitud.semovientes_recomendados = PlanInversion.sum(:cantidad, :conditions=>"(partida_nombre like \'\%SEMOVIENTES\%\' or partida_nombre like \'\%TORO REPRODUCTOR\%\') and solicitud_id = #{@solicitud.id.to_s}")
        #   if @solicitud.semovientes_recomendados.nil?
        #     @solicitud.semovientes_recomendados = 0.00
        #   end

        #   @solicitud.save

        #   monto_prestamo = PlanInversion.sum(:monto_financiamiento,:conditions=>"solicitud_id=#{@solicitud.id}")
        #   monto_banco = PlanInversion.sum(:monto_financiamiento, :conditions=>"solicitud_id=#{@solicitud.id} and tipo_item = 'B'")
        #   monto_insumo = PlanInversion.sum(:monto_financiamiento, :conditions=>"solicitud_id=#{@solicitud.id} and tipo_item = 'I'")

        #   if @prestamo.nil?

        #     logger.info "Entro por prestamo nil ===========================>"
        #     @producto = Producto.find_by_programa_id_and_sector_id_and_sub_sector_id(@solicitud.programa_id, @solicitud.sector_id, @solicitud.sub_sector_id)

        #     prestamo = Prestamo.new(:solicitud=>@solicitud, :producto=>@producto, :oficina=>oficina, :destinatario=>"E")

        #     prestamo.monto_solicitado = monto_prestamo.to_f
            
        #     # -----------------------------------------
        #     # Calculo del sras
        #     # ---------------------rubro---------------

        #     parametro = ParametroGeneral.find(1)
        #     factor_mensual_primer_ano = parametro.porcentaje_sras_primer_ano / 1200
        #     factor_mensual_anos_siguen = parametro.porcentaje_sras_anos_subsiguientes / 1200

        #     plazo_total = prestamo.plazo + prestamo.meses_gracia
        #     if plazo_total <= 12
        #       sras_primer_ano = (monto_prestamo * factor_mensual_primer_ano) * 12
        #       sras_anos_siguen = 0.00
        #     end

        #     if plazo_total > 12
        #       sras_primer_ano = (monto_prestamo * factor_mensual_primer_ano) * 12
        #       sras_anos_siguen = (monto_prestamo * factor_mensual_anos_siguen) * (plazo_total - 12)
        #     end

        #     sras_total = sras_primer_ano + sras_anos_siguen

        #     prestamo.monto_sras_primer_ano = sras_primer_ano
        #     prestamo.monto_sras_anos_subsiguientes = sras_anos_siguen
        #     prestamo.monto_sras_total = sras_total

        #     # ----------------------------------------------------------------------
        #     # Ajuste para ubicar la tasa segun el subrubro y no por el tipo cliente
        #     # Efectuado por Alexander Cioffi 18-04-2012
        #     # ----------------------------------------------------------------------

        #     prestamo.tasa_inicial = @tasa_valor.valor
        #     prestamo.tasa_vigente = @tasa_valor.valor
        #     prestamo.tasa_valor = @tasa_valor.valor
        #     prestamo.tasa_referencia_inicial = @tasa_valor.valor
        #     prestamo.tasa_id = tasa.id

        #     prestamo.monto_banco = monto_banco.to_f
        #     prestamo.monto_insumos = monto_insumo.to_f

        #     #-----------------------------------------------------------------
        #     # Inicio de la Rutina para ajustar el total gastos en el prestamo
        #     # Alexander Cioffi 14/03/2012
        #     #-----------------------------------------------------------------

        #     logger.debug "Rutina de Gastos al crear el prestamo"
        #     gastos = ProgramaTipoGasto.find_by_programa_id_and_tipo_gasto_id(@solicitud.programa_id, 1)
        #     logger.debug "GASTOS==============> "<<@gastos.inspect

        #     total_gasto = 0.00
        #     unless (gastos.nil?)
        #       if gastos.porcentaje > 0
        #           monto = ((prestamo.monto_banco + prestamo.monto_insumos)*(gastos.porcentaje/100))
        #       else
        #           monto = gastos.monto_fijo
        #       end
        #       total_gasto = monto
        #     end
        #     prestamo.monto_gasto_total = total_gasto.to_f

        #     #-----------------------------------------------------------------
        #     # Fin  de la Rutina para ajustar el total gastos en el prestamo
        #     #-----------------------------------------------------------------
        #     #-----------------------------------------------------------------
        #     # Inicio de la Rutina para ajustar el monto solicitado en la solicitud
        #     # Luis Rojas / Alexander Cioffi 14/03/2012 y 15/03/2012
        #     #-----------------------------------------------------------------

        #     @solicitud.monto_solicitado = prestamo.monto_banco + prestamo.monto_insumos + prestamo.monto_sras_total + prestamo.monto_gasto_total
        #     @solicitud.monto_aprobado = @solicitud.monto_solicitado
        #     @solicitud.save

        #     #-----------------------------------------------------------------
        #     # Fin  de la Rutina para ajustar el monto solicitado en la solicitud
        #     #-----------------------------------------------------------------

        #     prestamo.save
        #     logger.info "Save despues de insert #{prestamo.errors.full_messages.to_s}"

        #     if prestamo.errors.size == 0
        #       return true
        #     else
        #       return false
        #     end

        #   else
        #     # ----------------------------------------------------------------------
        #     # Ajuste para ubicar la tasa segun el subrubro y no por el tipo cliente
        #     # Efectuado por Alexander Cioffi 18-04-2012
        #     # ----------------------------------------------------------------------

        #     logger.info "Entro por else =======> #{@prestamo.inspect}"
        #     @prestamo.tasa_inicial = @tasa_valor.valor
        #     @prestamo.tasa_vigente = @tasa_valor.valor
        #     @prestamo.tasa_valor = @tasa_valor.valor
        #     @prestamo.tasa_referencia_inicial = @tasa_valor.valor
        #     @prestamo.tasa_id = tasa.id


        #     # ------------------------------------
        #     # Calculo del sras
        #     # ------------------------------------

        #     parametro = ParametroGeneral.find(1)
        #     logger.info "Parametro General =======> #{parametro.inspect}"
        #     logger.info "Prestamo ================> #{prestamo.inspect}"
        #     factor_mensual_primer_ano = parametro.porcentaje_sras_primer_ano / 1200
        #     factor_mensual_anos_siguen = parametro.porcentaje_sras_anos_subsiguientes / 1200

        #     monto_prestamo = PlanInversion.sum(:monto_financiamiento,:conditions=>"solicitud_id=#{@solicitud.id}")
        #     monto_banco = PlanInversion.sum(:monto_financiamiento, :conditions=>"solicitud_id=#{@solicitud.id} and tipo_item = 'B'")
        #     monto_insumo = PlanInversion.sum(:monto_financiamiento, :conditions=>"solicitud_id=#{@solicitud.id} and tipo_item = 'I'")

        #     plazo_total = @prestamo.plazo + @prestamo.meses_gracia

        #     if plazo_total <= 12
        #       sras_primer_ano = (monto_prestamo.to_f * factor_mensual_primer_ano) * 12
        #       sras_anos_siguen = 0.00
        #     end

        #     if plazo_total > 12
        #       sras_primer_ano = (monto_prestamo.to_f * factor_mensual_primer_ano) * 12
        #       sras_anos_siguen = (monto_prestamo.to_f * factor_mensual_anos_siguen) * (plazo_total - 12)
        #     end

        #     sras_total = sras_primer_ano + sras_anos_siguen

        #     @prestamo.monto_sras_primer_ano = sras_primer_ano
        #     @prestamo.monto_sras_anos_subsiguientes = sras_anos_siguen
        #     @prestamo.monto_sras_total = sras_total
        #     @prestamo.monto_banco = monto_banco.to_f
        #     @prestamo.monto_insumos = monto_insumo.to_f
        #     @prestamo.monto_solicitado = monto_prestamo.to_f

        #     #-----------------------------------------------------------------
        #     # Inicio de la Rutina para ajustar el total gastos en el prestamo
        #     # Alexander Cioffi 14/03/2012
        #     #-----------------------------------------------------------------

        #     #logger.debug "Rutina de Gastos al modificar el prestamo"
        #     @gastos = ProgramaTipoGasto.find_by_programa_id_and_tipo_gasto_id(@solicitud.programa_id, 1)
        #     #logger.debug "GASTOS==============> "<<@gastos.inspect
        #     total_gasto = 0.00

        #     unless (@gastos.nil?)
        #       if @gastos.porcentaje > 0
        #           monto = ((@prestamo.monto_banco + @prestamo.monto_insumos)*(@gastos.porcentaje/100))
        #       else
        #           monto = @gastos.monto_fijo
        #       end
        #       total_gasto = monto
        #     end
        #     @prestamo.monto_gasto_total = total_gasto.to_f

        #     #-----------------------------------------------------------------
        #     # Fin  de la Rutina para ajustar el total gastos en el prestamo
        #     #-----------------------------------------------------------------
        #     #-----------------------------------------------------------------
        #     # Inicio de la Rutina para ajustar el monto solicitado en la solicitud
        #     # Luis Rojas / Alexander Cioffi 14/03/2012 y 15/03/2012
        #     #-----------------------------------------------------------------
        #     @solicitud.monto_solicitado = @prestamo.monto_banco + @prestamo.monto_insumos + @prestamo.monto_sras_total + @prestamo.monto_gasto_total
        #     @solicitud.monto_aprobado = @solicitud.monto_solicitado
        #     @solicitud.save

        #     #-----------------------------------------------------------------
        #     # Fin  de la Rutina para ajustar el monto solicitado en la solicitud
        #     #-----------------------------------------------------------------
        #     @prestamo.save
        #     logger.info "Save despues de actualizacion #{@prestamo.errors.full_messages.to_s}"
        #     if @prestamo.errors.size == 0
        #       return true
        #     else
        #       return false
        #     end

        #   end

        #end     # ----> Fin Prestamo.transaction do
        
      end         #===> Fin PlanInversion.transaction do

    rescue => detail

      logger.info "Errorressssssss ====> #{@errores.to_s + detail.message + detail.backtrace.to_s}"
      return @errores + detail.message
    end

    if @errores.empty?
      @errores = true
    end
    return @errores
  end

  def PlanInversion.nuevo_plan(solicitud_id, oficina)


    plan_inversion = PlanInversion.find_by_solicitud_id(solicitud_id)
    
    PlanInversion.transaction do

=begin

  Si el plan de inversión para el trámite no existe se crea a partir del archivo de estructura de costos
  (Configurador)
=end

      logger.info "@ED (edit) ====================> " << @ed.to_s
      if plan_inversion.nil? 

        @solicitud = Solicitud.find(solicitud_id)
        unidad_produccion = UnidadProduccion.find(@solicitud.unidad_produccion_id)
        @oficina_id = oficina
        estado = Estado.find(unidad_produccion.estado_id)
        sector = Sector.find(@solicitud.rubro.sector_id)

        condicion = " estado_id = #{estado.id} and oficina_id = #{@oficina_id} and "
        condicion += "sector_id = #{@solicitud.sector_id} and sub_sector_id = #{@solicitud.sub_sector_id} "
        condicion += " and rubro_id = #{@solicitud.rubro_id} and sub_rubro_id = #{@solicitud.sub_rubro_id} "
        condicion += "and actividad_id = #{@solicitud.actividad_id} and moneda_id = #{@solicitud.moneda_id} "
        condicion += "and moneda_id = #{@solicitud.moneda_id}"

        logger.debug "Condiciones ======> " << condicion.to_s

        configuradores  = Configurador.find(:all, :conditions=>condicion, :order=> "estado_id, oficina_id, sector_id, sub_sector_id, rubro_id,sub_rubro_id,actividad_id")

        logger.info 'Configuradores =========> #{}'

        if configuradores.nil? || configuradores.empty?

          #solicitud.erorrs_add_to_base(nil,"No existe estructura de costos para el rubro")
          @mensaje1 = "#{I18n.t('Sistema.Body.Modelos.PlanInversion.Errores.no_existe_estructura_costos')}: #{@solicitud.actividad.nombre}"
          raise ActiveRecord::Rollback
          return false

        end

          #Creación del plan de inversión a partir del archivo de estructura de costos (Configurador)

          configuradores.each do |configurador|
            reg_plan = Hash.new
            reg_plan["solicitud_id"] = @solicitud.id
            reg_plan["estado_nombre"] = configurador.estado.nombre
            reg_plan["oficina_nombre"] = configurador.oficina.nombre
            reg_plan["sector_nombre"] = configurador.sector.nombre
            reg_plan["sub_sector_nombre"] = configurador.sub_sector.nombre
            reg_plan["rubro_nombre"] = configurador.rubro.nombre
            reg_plan["partida_nombre"] = configurador.partida.nombre
            reg_plan["sub_rubro_nombre"] = configurador.sub_rubro.nombre
            reg_plan["actividad_nombre"] = configurador.actividad.nombre
            reg_plan["item_nombre"] = configurador.item.nombre

            if configurador.tipo_item.nil? || configurador.tipo_item == ''

              reg_plan["tipo_item"] = configurador.item.tipo_item
            else
              reg_plan["tipo_item"] = configurador.tipo_item
            end

            reg_plan["unidad_medida_id"] = configurador.item.unidad_medida_id
            reg_plan["numero_desembolso"] = configurador.numero_desembolso
            reg_plan["cantidad_por_hectarea"] = configurador.item.cantidad_por_hectarea
            reg_plan["costo_minimo"] = configurador.costo_minimo
            reg_plan["costo_maximo"] = configurador.costo_maximo
            reg_plan["moneda"] = @solicitud.moneda.abreviatura

            if @solicitud.actividad.paquetizado
              reg_plan["costo_real"] = configurador.costo_fijo
            else
              reg_plan["costo_real"] = 0.00
            end
            
            PlanInversion.connection.execute("LOCK plan_inversion in ACCESS EXCLUSIVE MODE;")
            plan_inversion = PlanInversion.create(reg_plan)

          end   # Fin del each do

      end       # Fin del if plan_inversion.nil?

    end         # Fin de transaction do

  end

  def PlanInversion.actualiza_prestamo(solicitud,oficina_id)

=begin

   Método que genera el préstamo después de haber actualizado el plan de inversión

=end
    sras_primer_ano = 0.00
    sras_anos_siguen = 0.00
    sras_total = 0.00
    plazo_total = 0
    
    begin

      Prestamo.transaction do

        oficina = Oficina.find(oficina_id)
        @solicitud = solicitud
        prestamo = Prestamo.find_by_solicitud_id(solicitud.id)
        @plan_inversion = PlanInversion.find_by_solicitud_id(solicitud.id)

        #Buscando condiciones de financiamiento

        @condiciones = CondicionesFinanciamiento.find_by_programa_id_and_sector_id_and_sub_sector_id_and_rubro_id(solicitud.programa_id,
                                                                                                  solicitud.sector_id,
                                                                                                  solicitud.sub_sector_id,
                                                                                                  solicitud.rubro_id)
        #Buscando tasa beneficiario

        #tasa = Tasa.find_by_tipo_cliente_id(solicitud.cliente.tipo_cliente_id)

        # ----------------------------------------------------------------------
        # Ajuste para ubicar la tasa segun el subrubro y no por el tipo cliente
        # Efectuado por Alexander Cioffi 18-04-2012
        # ----------------------------------------------------------------------
        tasa = Tasa.find_by_sub_rubro_id(solicitud.sub_rubro_id)
        @tasa_valor = TasaValor.find_by_sql("Select * from tasa_valor where tasa_id = #{tasa.id} order by id desc LIMIT 1")
        @tasa_valor = @tasa_valor[0]


        monto_prestamo = PlanInversion.sum(:monto_financiamiento,:conditions=>"solicitud_id=#{solicitud.id}")
        @plan_inversion = PlanInversion.find(:all, :conditions=>"solicitud_id = #{solicitud.id}",:order =>"estado_nombre,oficina_nombre,sector_nombre,tipo_item")

        solicitud.hectareas_recomendadas = 0.00
        solicitud.semovientes_recomendados = 0.00

        if solicitud.actividad.paquetizado

          solicitud.hectareas_recomendadas = @plan_inversion[0].cantidad
          solicitud.semovientes_recomendados = 0.00
        else
          solicitud.hectareas_recomendadas = 0.00
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

        if @prestamo.nil?

          @producto = Producto.find_by_programa_id_and_sector_id_and_sub_sector_id(solicitud.programa_id, solicitud.sector_id, solicitud.sub_sector_id)

          prestamo = Prestamo.new(:solicitud=>solicitud, :producto=>@producto, :oficina=>oficina, :destinatario=>"E")

          prestamo.monto_solicitado = monto_prestamo.to_f

          # ----------------------------------------------------------------------
          # Ajuste para ubicar la tasa segun el subrubro y no por el tipo cliente
          # Efectuado por Alexander Cioffi 18-04-2012
          # ----------------------------------------------------------------------

          prestamo.tasa_inicial = @tasa_valor.valor
          prestamo.tasa_vigente = @tasa_valor.valor
          prestamo.tasa_valor = @tasa_valor.valor
          prestamo.tasa_referencia_inicial = @tasa_valor.valor
          prestamo.tasa_id = tasa.id

          prestamo.monto_banco = monto_banco.to_f
          prestamo.monto_insumos = monto_insumo.to_f

          #-----------------------------------------------------------------
          # Inicio de la Rutina para ajustar el total gastos en el prestamo
          # Alexander Cioffi 14/03/2012
          #-----------------------------------------------------------------

          #logger.debug "Rutina de Gastos al crear el prestamo"
          gastos = ProgramaTipoGasto.find_by_programa_id_and_tipo_gasto_id(@solicitud.programa_id, 1)
          #logger.debug "GASTOS==============> "<<@gastos.inspect
          
          total_gasto = 0.00
          unless (gastos.nil?)
            if gastos.porcentaje > 0
                monto = ((prestamo.monto_banco + prestamo.monto_insumos)*(gastos.porcentaje/100))
            else
                monto = gastos.monto_fijo
            end
            total_gasto = monto
          end
          prestamo.monto_gasto_total = total_gasto.to_f

          #-----------------------------------------------------------------
          # Fin  de la Rutina para ajustar el total gastos en el prestamo
          #-----------------------------------------------------------------
          # Inicio de la Rutina para ajustar el monto solicitado en la solicitud 
          # Luis Rojas / Alexander Cioffi 14/03/2012 y 15/03/2012                                    
          #-----------------------------------------------------------------
          # Inicio de la Rutina para ajustar el monto solicitado en la solicitud
          # Luis Rojas / Alexander Cioffi 14/03/2012 y 15/03/2012
          #-----------------------------------------------------------------

          solicitud.monto_solicitado = prestamo.monto_banco + prestamo.monto_insumos + prestamo.monto_sras_total + prestamo.monto_gasto_total
          solicitud.monto_aprobado = solicitud.monto_solicitado
          solicitud.save
          
          #-----------------------------------------------------------------  
          # Fin  de la Rutina para ajustar el monto solicitado en la solicitud 
          #-----------------------------------------------------------------

          @prestamo.save
          
          if @prestamo.errors.size == 0 
            return true
          else
            return false
          end

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


          # ------------------------------------
          # Calculo del sras
          # ------------------------------------

          parametro = ParametroGeneral.find(1)
          factor_mensual_primer_ano = parametro.porcentaje_sras_primer_ano / 1200
          factor_mensual_anos_siguen = parametro.porcentaje_sras_anos_subsiguientes / 1200

          monto_prestamo = PlanInversion.sum(:monto_financiamiento,:conditions=>"solicitud_id=#{solicitud.id}")
          monto_banco = PlanInversion.sum(:monto_financiamiento, :conditions=>"solicitud_id=#{solicitud.id} and tipo_item = 'B'")
          monto_insumo = PlanInversion.sum(:monto_financiamiento, :conditions=>"solicitud_id=#{solicitud.id} and tipo_item = 'I'")

          plazo_total = @prestamo.plazo + @prestamo.meses_gracia

          if plazo_total <= 12
            sras_primer_ano = (monto_prestamo.to_f * factor_mensual_primer_ano) * 12
            sras_anos_siguen = 0.00
          end

          if plazo_total > 12
            sras_primer_ano = (monto_prestamo.to_f * factor_mensual_primer_ano) * 12
            sras_anos_siguen = (monto_prestamo.to_f * factor_mensual_anos_siguen) * (plazo_total - 12)
          end

          sras_total = sras_primer_ano + sras_anos_siguen

          @prestamo.monto_sras_primer_ano = sras_primer_ano
          @prestamo.monto_sras_anos_subsiguientes = sras_anos_siguen
          @prestamo.monto_sras_total = sras_total
          @prestamo.monto_banco = monto_banco.to_f
          @prestamo.monto_insumos = monto_insumo.to_f
          @prestamo.monto_solicitado = monto_prestamo.to_f

          #-----------------------------------------------------------------
          # Inicio de la Rutina para ajustar el total gastos en el prestamo 
          # Alexander Cioffi 14/03/2012                                     
          #-----------------------------------------------------------------
          
          #logger.debug "Rutina de Gastos al modificar el prestamo"
          @gastos = ProgramaTipoGasto.find_by_programa_id_and_tipo_gasto_id(@solicitud.programa_id, 1)
          #logger.debug "GASTOS==============> "<<@gastos.inspect
          total_gasto = 0.00
          
          unless (@gastos.nil?)        
              if @gastos.porcentaje > 0
                  monto = ((prestamo.monto_banco + prestamo.monto_insumos)*(@gastos.porcentaje/100))
              else
                  monto = @gastos.monto_fijo 
              end
              total_gasto = monto
          end
          @prestamo.monto_gasto_total = total_gasto.to_f

          #-----------------------------------------------------------------  
          # Fin  de la Rutina para ajustar el total gastos en el prestamo 
          #-----------------------------------------------------------------
          #-----------------------------------------------------------------
          # Inicio de la Rutina para ajustar el monto solicitado en la solicitud 
          # Luis Rojas / Alexander Cioffi 14/03/2012 y 15/03/2012                                    
          #-----------------------------------------------------------------
          solicitud.monto_solicitado = @prestamo.monto_banco + @prestamo.monto_insumos + @prestamo.monto_sras_total + @prestamo.monto_gasto_total
          solicitud.monto_aprobado = solicitud.monto_solicitado
          solicitud.save
          
          #-----------------------------------------------------------------  
          # Fin  de la Rutina para ajustar el monto solicitado en la solicitud 
          #-----------------------------------------------------------------
          # Fin  de la Rutina para ajustar el monto solicitado en la solicitud
          #-----------------------------------------------------------------
          @prestamo.save

          if @prestamo.errors.size == 0
            return true
          else
            return false
          end

      end
      
    end     # ----> En transaction do

  rescue =>detail

    #render :update do |page|
      @error = detail.message + detail.backtrace.to_s
      logger.info "Errrrrooooooorrrrrrrr ====> #{@error}"
    #end
    return @error

    end
  end

end


# == Schema Information
#
# Table name: plan_inversion
#
#  id                    :integer         not null, primary key
#  solicitud_id          :integer         not null
#  estado_nombre         :string(100)     not null
#  oficina_nombre        :string(100)     not null
#  sector_nombre         :string(100)     not null
#  sub_sector_nombre     :string(100)     not null
#  rubro_nombre          :string(100)     not null
#  partida_nombre        :string(100)     not null
#  item_nombre           :string(100)     not null
#  unidad_medida_id      :integer         not null
#  numero_desembolso     :integer         default(0), not null
#  costo_real            :decimal(16, 2)  default(0.0), not null
#  cantidad              :decimal(16, 3)  default(0.0)
#  monto_financiamiento  :decimal(16, 2)  default(0.0)
#  monto_desembolsado    :decimal(16, 2)  default(0.0)
#  seriales              :string
#  marcas                :string
#  tipo_item             :string(1)
#  cantidad_por_hectarea :decimal(16, 2)  default(0.0), not null
#  costo_minimo          :decimal(16, 2)  default(0.0), not null
#  costo_maximo          :decimal(16, 2)  default(0.0), not null
#  cantidad_liquidada    :decimal(16, 2)  default(0.0), not null
#  sub_rubro_nombre      :string(100)
#  actividad_nombre      :string(100)
#  inventario            :boolean         default(FALSE)
#  serial_motor          :string(50)
#  serial_chasis         :string(50)
#  casa_proveedora_id    :integer
#  moneda                :string(5)
#

# == Schema Information
#
# Table name: plan_inversion
#
#  id                    :integer         not null, primary key
#  solicitud_id          :integer         not null
#  estado_nombre         :string(100)     not null
#  oficina_nombre        :string(100)     not null
#  sector_nombre         :string(100)     not null
#  sub_sector_nombre     :string(100)     not null
#  rubro_nombre          :string(100)     not null
#  partida_nombre        :string(100)     not null
#  item_nombre           :string(100)     not null
#  unidad_medida_id      :integer         not null
#  numero_desembolso     :integer         default(0), not null
#  costo_real            :decimal(16, 2)  default(0.0), not null
#  cantidad              :decimal(16, 3)  default(0.0)
#  monto_financiamiento  :decimal(16, 2)  default(0.0)
#  monto_desembolsado    :decimal(16, 2)  default(0.0)
#  seriales              :string
#  marcas                :string
#  tipo_item             :string(1)
#  cantidad_por_hectarea :decimal(16, 2)  default(0.0), not null
#  costo_minimo          :decimal(16, 2)  default(0.0), not null
#  costo_maximo          :decimal(16, 2)  default(0.0), not null
#  cantidad_liquidada    :decimal(16, 2)  default(0.0), not null
#  sub_rubro_nombre      :string(100)
#  actividad_nombre      :string(100)
#  inventario            :boolean         default(FALSE)
#

