# encoding: utf-8

#
# autor: Diego Bertaso
# clase: GestionCobranzas
# creado con Rails 3
#

class GestionCobranzas < ActiveRecord::Base

  self.table_name = 'gestion_cobranzas'

  attr_accessible :id,
                  :analista_cobranza_id,
                  :prestamo_id,
                  :fecha_registro,
                  :tipo_gestion_cobranza_id,
                  :estatus,
                  :saldo_insoluto,
                  :deuda,
                  :exigible,
                  :cantidad_cuotas_prestamo,
                  :cantidad_cuotas_vencidas,
                  :monto_capital_vencido,
                  :monto_interes_vencido,
                  :monto_interes_diferido_vencido,
                  :monto_interes_mora,
                  :monto_capital_pagado,
                  :monto_interes_pagado,
                  :monto_interes_diferido_pagado,
                  :monto_interes_mora_pagado,
                  :monto_liquidado,
                  :estatus_prestamo,
                  :cantidad_veces_vigente,
                  :cantidad_veces_mora,
                  :cantidad_dias_mora_acumulados,
                  :confirmada,
                  :fecha_confirmacion,
                  :hora_confirmacion,
                  :activo,
                  :hora_registro,
                  :texto_enviar

  belongs_to :tipo_gestion_cobranzas
  belongs_to :prestamo
  belongs_to :analista_cobranzas, :foreign_key =>'analista_cobranza_id'

  validates :analista_cobranza_id, :presence => {:message => "#{I18n.t('Sistema.Body.Modelos.GestionCobranzas.Errores.analista_cobranzas')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}


  validates :prestamo_id, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.financiamiento')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}


  validates :tipo_gestion_cobranza_id, :presence => {:message => "#{I18n.t('Sistema.Body.Modelos.GestionCobranzas.Errores.tipo_gestion_cobranzas')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :mensaje,
    :presence => {:if => Proc.new {|a| a.tipo_gestion_cobranza_id == 1 || a.tipo_gestion_cobranza_id == 2}, :message => I18n.t('Sistema.Body.Modelos.GestionCobranzas.Errores.mensaje_requerido')}

  def self.search_hc(conditions, page, sort, inc_tablas, seleccion)
   # Paginación de historico de cobranzas

    unless conditions.nil?

      paginate  :per_page => @records_by_page,
                :page => page,
                :conditions => conditions,
                :order => sort,
                :joins => inc_tablas,
                :select => seleccion
    else

      paginate  :per_page => @records_by_page,
                :page => page,
                :order => sort,
                :joins => inc_tablas,
                :select => seleccion

   end

  end

  def self.agregar_gestion(campos, analista, usuario, prestamo)

    logger.info "AGREGAR GESTION ===========> #{campos.inspect}"

    begin

      GestionCobranzas.transaction do

        logger.info "fecha registro ====> #{campos[:gestion_cobranzas][:fecha_registro]}"
        raise ActiveRecord::RecordNotFound if analista.nil?
        raise ActiveRecord::RecordNotFound if prestamo.nil?

        gestion = GestionCobranzas.new
        
        gestion.analista_cobranza_id = analista.id
        gestion.prestamo_id = prestamo.id
        gestion.fecha_registro = "'" + campos[:gestion_cobranzas][:fecha_registro] + "'"
        logger.info "fecha registro gestion =====> #{gestion.fecha_registro.strftime("%d-%m-%Y")}"
        gestion.hora_registro  = "'" + campos[:gestion_cobranzas][:hora_registro]  + "'"
        gestion.tipo_gestion_cobranza_id = campos[:tipo_gestion_cobranza_id]
        gestion.saldo_insoluto = prestamo.saldo_insoluto_total
        gestion.deuda = prestamo.deuda
        gestion.exigible = prestamo.exigible

        if prestamo.frecuencia_pago == 0

          gestion.cantidad_cuotas_prestamo = 1
        else
          gestion.cantidad_cuotas_prestamo = prestamo.plazo / prestamo.frecuencia_pago
        end

        gestion.cantidad_cuotas_vencidas = prestamo.cantidad_cuotas_vencidas
        gestion.monto_capital_vencido = prestamo.capital_vencido
        gestion.monto_interes_vencido = prestamo.interes_vencido
        gestion.monto_interes_diferido_vencido = prestamo.interes_diferido_vencido
        gestion.monto_interes_mora = prestamo.monto_mora
        gestion.monto_capital_pagado = prestamo.capital_pagado
        gestion.monto_interes_pagado = prestamo.intereses_pagados
        gestion.monto_interes_diferido_pagado = 0
        gestion.monto_interes_mora_pagado = prestamo.mora_pagada
        gestion.monto_liquidado = prestamo.monto_liquidado
        gestion.estatus_prestamo = prestamo.estatus
        gestion.cantidad_veces_vigente = prestamo.cantidad_veces_vigente
        gestion.cantidad_veces_mora = prestamo.cantidad_veces_mora
        gestion.cantidad_dias_mora_acumulados = prestamo.cantidad_dias_mora_acumulados

        correo = ''
        if campos[:tipo_gestion_cobranza_id] == "1"

          gestion.mensaje = campos[:mensaje]
          correo = campos[:email]

        end
      
        if campos[:tipo_gestion_cobranza_id] == "2"

           gestion.mensaje = campos[:mensaje_sms]

        end
      
        gestion.save!

        if campos[:tipo_gestion_cobranza_id] == "3"
          
          telecobranzas = Telecobranzas.new
          telecobranzas.gestion_cobranzas_id = gestion.id

          cliente = Cliente.find(prestamo.cliente_id)

          raise ActiveRecord::RecordNotFound if cliente.nil?

          if cliente.class.to_s == "ClientePersona"

            telefono = PersonaTelefono.find(campos[:telecobranzas][:telefono_id])
            logger.info "TELEFONO =======>  #{telefono.inspect}"
            direccion = PersonaDireccion.find_by_persona_id(telefono.persona_id)
          else
            telefono = EmpresaTelefono.find(campos[:telecobranzas][:telefono_id])
            direccion = EmpresaDireccion.find(telefono.empresa_id)
          end

          raise ActiveRecord::RecordNotFound if direccion.nil?
          raise ActiveRecord::RecordNotFound if telefono.nil?

          telecobranzas.direccion_id = direccion.id
          telecobranzas.estatus = "C"
          telecobranzas.update_attributes!(campos[:telecobranzas])

          performance_cobranzas = PerformanceCobranzas.find_by_prestamo_id(prestamo.id)
          per_cobranzas_analista = PerformanceAnalistaCobranza.find_by_analista_cobranzas_id_and_fecha(analista.id, campos[:gestion_cobranzas][:fecha_registro])

          if per_cobranzas_analista.nil?
            per_cobranzas_analista = PerformanceAnalistaCobranza.new
            per_cobranzas_analista.analista_cobranzas_id = analista.id
            per_cobranzas_analista.fecha = gestion.fecha_registro
          end

          per_cobranzas_analista.cantidad_intentos += 1

          # -----------------------------------------------------------------------------
          # Actualización de estadisticas y porcentajes en tabla performance_cobranzas
          # -----------------------------------------------------------------------------

          if campos[:telecobranzas][:llamada_infructuosa_id].to_i == 1
            if campos[:telecobranzas][:persona_atendio_id].to_i == 1

              per_cobranzas_analista.cantidad_contactos += 1
              per_cobranzas_analista.cantidad_contactos_exitosos += 1
            end

            if  campos[:telecobranzas][:persona_atendio_id].to_i == 2 or
                campos[:telecobranzas][:persona_atendio_id].to_i == 3 or
                campos[:telecobranzas][:persona_atendio_id].to_i == 4 

                per_cobranzas_analista.cantidad_contactos += 1
            end
          else
            if  campos[:telecobranzas][:llamada_infructuosa_id].to_i == 4

                per_cobranzas_analista.cantidad_contactos += 1
            end
          end

          if campos[:telecobranzas][:senal_compromiso] == "true"
            per_cobranzas_analista.cantidad_promesas_pago += 1
          end

          if per_cobranzas_analista.cantidad_contactos_exitosos > 0
            per_cobranzas_analista.porcentaje_promesas_pago = per_cobranzas_analista.cantidad_promesas_pago.to_f / per_cobranzas_analista.cantidad_contactos_exitosos.to_f * 100
          end

          if per_cobranzas_analista.cantidad_intentos > 0
            per_cobranzas_analista.porcentaje_contactos = per_cobranzas_analista.cantidad_contactos.to_f / per_cobranzas_analista.cantidad_intentos.to_f * 100
          else
            per_cobranzas_analista.porcentaje_contactos = 0.00
          end
          if per_cobranzas_analista.cantidad_contactos > 0
            per_cobranzas_analista.porcentaje_contactos_exitosos = per_cobranzas_analista.cantidad_contactos_exitosos.to_f / per_cobranzas_analista.cantidad_contactos.to_f * 100
          else
            per_cobranzas_analista.porcentaje_contactos_exitosos = 0.00
          end
          per_cobranzas_analista.save!

          if performance_cobranzas.nil?
            performance_cobranzas = PerformanceCobranzas.new
            performance_cobranzas.prestamo_id = prestamo.id
            performance_cobranzas.cliente_id = prestamo.cliente_id
          end

          performance_cobranzas.cantidad_intentos += 1

          #logger.info "Cantidad Intentos: ==========> #{campos[:performance_cobranzas][:cantidad_intentos].to_i}"

          # -----------------------------------------------------------------------------
          # Actualización de estadisticas y porcentajes en tabla performance_cobranzas
          # -----------------------------------------------------------------------------

          if campos[:telecobranzas][:llamada_infructuosa_id].to_i == 1
            if campos[:telecobranzas][:persona_atendio_id].to_i == 1

              performance_cobranzas.cantidad_contactos += 1
              performance_cobranzas.cantidad_contactos_exitosos += 1
            end

            if  campos[:telecobranzas][:persona_atendio_id].to_i == 2 or
                campos[:telecobranzas][:persona_atendio_id].to_i == 3 or
                campos[:telecobranzas][:persona_atendio_id].to_i == 4 

                performance_cobranzas.cantidad_contactos += 1
            end
          else
            if campos[:telecobranzas][:llamada_infructuosa_id].to_i == 4

              performance_cobranzas.cantidad_contactos += 1
            end
          end

          if campos[:telecobranzas][:senal_compromiso] == "true"
            performance_cobranzas.cantidad_promesas_pago += 1
          end

          if performance_cobranzas.cantidad_contactos_exitosos > 0
            performance_cobranzas.porcentaje_promesas_pago = performance_cobranzas.cantidad_promesas_pago.to_f / performance_cobranzas.cantidad_contactos_exitosos.to_f * 100
          end

          if performance_cobranzas.cantidad_intentos > 0
            performance_cobranzas.porcentaje_contactos = performance_cobranzas.cantidad_contactos.to_f / performance_cobranzas.cantidad_intentos.to_f * 100
          else
            performance_cobranzas.porcentaje_contactos = 0.00
          end

          if performance_cobranzas.cantidad_contactos > 0 
            performance_cobranzas.porcentaje_contactos_exitosos = performance_cobranzas.cantidad_contactos_exitosos.to_f / performance_cobranzas.cantidad_contactos.to_f * 100
          else 
            performance_cobranzas.porcentaje_contactos_exitosos = 0.00
          end

          performance_cobranzas.save!

          if telecobranzas.senal_compromiso

            compromiso_pago = CompromisoPago.new

            compromiso_pago.estatus = 'E'
            compromiso_pago.telecobranzas_id = telecobranzas.id
            compromiso_pago.prestamo_id = prestamo.id

            compromiso_pago.fecha_limite_pago = campos[:fecha_limite_pago]
            compromiso_pago.monto_pago = campos[:monto_pago].to_f
            compromiso_pago.update_attributes!(campos[:compromiso_pago])
          end

        end       #========> fin del if campos[:tipo_gestion_cobranza_id] == "3"

        if campos[:tipo_gestion_cobranza_id] == "1"

          performance_cobranzas = PerformanceCobranzas.find_by_prestamo_id(prestamo.id)
          per_cobranzas_analista = PerformanceAnalistaCobranza.find_by_analista_cobranzas_id_and_fecha(analista.id, campos[:gestion_cobranzas][:fecha_registro])

          if per_cobranzas_analista.nil?
            per_cobranzas_analista = PerformanceAnalistaCobranza.new
            per_cobranzas_analista.fecha = gestion.fecha_registro
            per_cobranzas_analista.analista_cobranzas_id = analista.id
          end

          per_cobranzas_analista.cantidad_email_enviados += 1
          per_cobranzas_analista.save!

          if performance_cobranzas.nil?
            performance_cobranzas = PerformanceCobranzas.new
            performance_cobranzas.prestamo_id = prestamo.id
            performance_cobranzas.cliente_id = prestamo.cliente_id
          end

          performance_cobranzas.cantidad_email_enviados += 1
          performance_cobranzas.save!

        end       #=====> fin del if campos[:tipo_gestion_cobranza_id] == "1"

        if campos[:tipo_gestion_cobranza_id] == "2"

          performance_cobranzas = PerformanceCobranzas.find_by_prestamo_id(prestamo.id)
          per_cobranzas_analista = PerformanceAnalistaCobranza.find_by_analista_cobranzas_id_and_fecha(analista.id, campos[:gestion_cobranzas][:fecha_registro])

          if per_cobranzas_analista.nil?
            per_cobranzas_analista = PerformanceAnalistaCobranza.new
            per_cobranzas_analista.fecha = gestion.fecha_registro
            per_cobranzas_analista.analista_cobranzas_id = analista.id
          end

          per_cobranzas_analista.cantidad_sms_enviados += 1
          per_cobranzas_analista.save!

          if performance_cobranzas.nil?
            performance_cobranzas = PerformanceCobranzas.new
            performance_cobranzas.prestamo_id = prestamo.id
            performance_cobranzas.cliente_id = prestamo.cliente_id
          end

          performance_cobranzas.cantidad_sms_enviados += 1
          performance_cobranzas.save!

        end       #=====> fin del if campos[:tipo_gestion_cobranza_id] == "1"

        #------------------------------------------------------------------------------------------
        # Actualizando fecha de confirmación y hora de confirmación en la tabla gestion_cobranzas
        #------------------------------------------------------------------------------------------


        gestion.fecha_confirmacion = Time.now.strftime("%Y/%m/%d")
        gestion.hora_confirmacion  = Time.now.strftime("%H:%M:%S")

        gestion.save!

        #prestamo = Prestamo.find_by_sql("update prestamo set analista_cobranzas_id = null where id = #{gestion.prestamo_id}")

        return gestion.id
      end       #======> fin de GestionCobranzas.transaction do

    rescue Exception => exception

      logger.info "Excepcion ====== #{exception.message}"

      @error = "\t\t<h2>#{I18n.t('Sistema.Body.Vistas.Form.error_general')} </h2>\n"
      @error << "\t\t<ul>\n"
      @error << "\t\t\t<li><b>#{exception.message}</b></li>\n"
      @error << "\t\t<ul>\n"
      return @error

    end         #======> Fin del begin

  end           #======> Fin del método agregar_gestion

  #se usa para mostrar el estatus del prestamo al momento de registrar la gestión de cobranza

  def estatus_w
    case self.estatus_prestamo
      when 'S'
        I18n.t('Sistema.Body.Modelos.Prestamo.Estatus.en_solicitud')
      when 'D'
        I18n.t('Sistema.Body.Modelos.Prestamo.Estatus.en_espera_por_desembolsos')
      when 'V'
        I18n.t('Sistema.Body.Modelos.Prestamo.Estatus.vigente')
      when 'E'
        I18n.t('Sistema.Body.Modelos.Prestamo.Estatus.vencido')
      when 'F'
        I18n.t('Sistema.Body.Modelos.Prestamo.Estatus.cancelado_reestructuracion') #Reestructuración Financiera
      when 'A'
        I18n.t('Sistema.Body.Modelos.Prestamo.Estatus.cancelado_ampliacion') #Reestructuración Financiera
      when 'L'
        I18n.t('Sistema.Body.Modelos.Prestamo.Estatus.litigio')
      when 'C'
        I18n.t('Sistema.Body.Modelos.Prestamo.Estatus.cancelado')
      when 'P'
        I18n.t('Sistema.Body.Modelos.Prestamo.Estatus.vigente') # En el periodo de gracia de la mora
      when 'J'
        I18n.t('Sistema.Body.Modelos.Prestamo.Estatus.consultoria_juridica') # Condición especial incluida para reestructuracion
      when 'H'
        I18n.t('Sistema.Body.Modelos.Prestamo.Estatus.vigente_demorado')
      when 'K'
        I18n.t('Sistema.Body.Modelos.Prestamo.Estatus.castigado')
     end
  end

  def self.quitar_asignacion_analista(id, analista_cobranzas_id)

    transaction do

      prestamo = Prestamo.find_by_id_and_analista_cobranzas_id(id,analista_cobranzas_id)

      unless prestamo.nil?
        prestamo.analista_cobranzas_id = nil
        unless prestamo.save
          analista = AnalistaCobranzas.find(analista_cobranzas_id)
          unless analista.nil?
            errors.add(:gestion_cobranzas, I18n.t('Sistema.Body.Modelos.GestionCobranzas.Errores.problemas_quitando_asignacion_analista', :analista=>analista.analista))
          else
            errors.add(:gestion_cobranzas, I18n.t('Sistema.Body.Modelos.GestionCobranzas.Errores.problemas_quitando_asignacion_analista', :analista=>I18n.t('Sistema.Body.Modelos.GestionCobranzas.Errores.analista_no_existe')))
          end
        end
      end
    end
  end

end

# == Schema Information
#
# Table name: gestion_cobranzas
#
#  id                             :integer         not null, primary key
#  analista_cobranza_id           :integer         not null
#  prestamo_id                    :integer         not null
#  fecha_registro                 :date            not null
#  tipo_gestion_cobranza_id       :integer         not null
#  saldo_insoluto                 :decimal(16, 2)  default(0.0), not null
#  deuda                          :decimal(16, 2)  default(0.0), not null
#  exigible                       :decimal(16, 2)  default(0.0), not null
#  cantidad_cuotas_prestamo       :integer         default(0), not null
#  cantidad_cuotas_vencidas       :integer         default(0), not null
#  monto_capital_vencido          :decimal(16, 2)  default(0.0), not null
#  monto_interes_vencido          :decimal(16, 2)  default(0.0), not null
#  monto_interes_diferido_vencido :decimal(16, 2)  default(0.0), not null
#  monto_interes_mora             :decimal(16, 2)  default(0.0), not null
#  monto_capital_pagado           :decimal(16, 2)  default(0.0), not null
#  monto_interes_pagado           :decimal(16, 2)  default(0.0), not null
#  monto_interes_diferido_pagado  :decimal(16, 2)  default(0.0), not null
#  monto_interes_mora_pagado      :decimal(16, 2)  default(0.0), not null
#  monto_liquidado                :decimal(16, 2)  default(0.0), not null
#  estatus_prestamo               :string(1)       not null
#  cantidad_veces_vigente         :integer         default(0), not null
#  cantidad_veces_mora            :integer         default(0), not null
#  cantidad_dias_mora_acumulados  :integer         default(0), not null
#  fecha_confirmacion             :date
#  hora_confirmacion              :time(6)
#  activo                         :boolean         default(TRUE), not null
#  hora_registro                  :time(6)
#  mensaje                        :text
#

