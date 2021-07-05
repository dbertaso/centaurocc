# encoding: utf-8
require 'rubygems'
require 'fastercsv'
require 'csv'

class Desembolso < ActiveRecord::Base

  self.table_name = 'desembolso'

attr_accessible :id,
                :numero,
                :prestamo_id,
                :solicitud_id,
                :modalidad,
                :monto,
                :fecha_valor,
                :fecha_envio,
                :fecha_recepcion,
                :entidad_financiera_id,
                :tipo_cuenta,
                :numero_cuenta,
                :realizado,
                :usuario_id,
                :seguimiento_visita_id,
                :observacion,
                :tipo_cheque,
                :referencia,
                :confirmado,
                :fecha_registro,
                :fecha_valor_f,
                :fecha_ultimo_devengo_f,
                :monto_fm,
                :monto_f,
                :fecha_valor_f
                    

  belongs_to :estado
  belongs_to :sector
  belongs_to :rubro
  belongs_to :oficina

  belongs_to :seguimiento_visita


  belongs_to :prestamo

  belongs_to :entidad_financiera_cliente,
             :class_name => "EntidadFinanciera",
             :foreign_key => "entidad_financiera_cliente_id"

#  has_and_belongs_to_many :documentos, :class_name=>'Documento', :join_table=>'desembolso_documentos'

  belongs_to :entidad_financiera

 # has_many :condicionamiento_desembolsos, :class_name=>'CondicionamientoDesembolso'

 # has_many :desembolso_pagos, :class_name=>'DesembolsoPago'

  has_many :detalles, :class_name=>'DesembolsoDetalle'

#  has_many :gastos, :class_name=>'DesembolsoGasto'

#  has_one :desembolso_seguimiento, :class_name=>'DesembolsoSeguimiento'

#  has_one :comentario, :class_name=>'DesembolsoComentario'

#  has_one :informe, :class_name=>'InformeSeguimiento'

  validates :prestamo, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.ConsultarTransaccion.Etiquetas.prestamo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

#  validates_presence_of :tipo_desembolso, :modalidad,
#    :message => " es requerido"
##    :if => Proc.new { |desembolso| desembolso.prestamo && desembolso.prestamo.estatus_desembolso == 'S' }
#
#  validates_length_of :numero_voucher, :within => 0..20,
#    :allow_nil => true,
#    :too_short => " es demasiado corto (mínimo %d)",
#    :too_long => " es demasiado largo (máximo %d)"
#
#  validates_length_of :numero_cuenta, :within => 0..20,
#    :allow_nil => true,
#    :too_short => " es demasiado corto (mínimo %d)",
#    :too_long => " es demasiado largo (máximo %d)"
#




  attr_accessor :usuario
  attr_accessor :ip_address
  attr_accessor :validar_pago

  #****************************************************************************
  # actualizar_pago (08-02-2010)
  #****************************************************************************
  # Método que invoca el registro y actualización de la infirmación de
  # pago para un desembolso
  #
  # Params:
  #  desembolso: hash con información de los campos de desembolso
  #  comentarios: hash con información correspondiente al comentario
  #  gastos: hash con información de los gastos que aplican al desembolso
  #  pagos: hash con información del detalle del pago
  #
  # Autor: Alex Belisario
  #
  #****************************************************************************
#  def actualizar_pago(user, session, desembolso, comentarios, gastos, pagos)
#    success = true
#    begin
#       transaction do
#        logger.debug "Desembolso.actualizar_pago"
#        self.modalidad = 'P'
#        self.tipo_desembolso = 'D'
#        self.usuario = user
#        self.ip_address = session[:ip_address]
#        #self.fecha_realizacion = Time.now
#        #self.fecha_valor = Date.strptime(desembolso[:fecha_valor_f], '%d/%m/%Y') unless desembolso[:fecha_valor_f] == ''
#        #Se registran los gastos aplicados para este desembolso
#        self.gastos.destroy_all
#        gastos.each do |gasto|
#          programa_gasto = ProgramaTipoGasto.find(gasto[0])
#          desembolso_gasto = DesembolsoGasto.new(
#            :tipo_gasto_id => programa_gasto.tipo_gasto_id,
#            :porcentaje       => programa_gasto.porcentaje,
#            :monto_fijo       => programa_gasto.monto_fijo
#          )
#          self.gastos << desembolso_gasto
#        end
#
#        #Se eliminan los pagos anteriores
#        #self.desembolso_pagos.delete_all
#        self.desembolso_pagos.destroy_all
#
#        #Se registra el detalle del pago para este desembolso
#        pagos.each do |clave, pago|
#          if  pago.size > 1
#            #fecha_sp = pago[:fecha_f].split('/')
#            #pago[:fecha_f] = "#{fecha_sp[2]}-#{fecha_sp[1]}-#{fecha_sp[0]}"
#            pago[:entidad_financiera_id] = CuentaBcv.find(pago[:cuenta_bcv_comercial_id]).entidad_financiera_id
#            desembolso_pago = DesembolsoPago.new(pago)
#            #Se verifica la imputación de gasto
#            if desembolso_pago.gasto_imputado
#              desembolso_pago.monto_comision = self.total_comision
#              #desembolso_pago.monto -= self.total_comision
#            end
#            self.desembolso_pagos << desembolso_pago
#          end
#        end
#
#        #Actualización de comentario
#        unless self.comentario.nil?
#          self.comentario.update_attributes(comentarios)
#        else
#          self.comentario = DesembolsoComentario.new(comentarios)
#        end
#
#        #Actualización del préstamo
#        self.prestamo.solicitud.estatus = 'P'
#        self.prestamo.solicitud.estatus_desembolso_id = 10
#
#        #Registro del evento
#        solicitud = self.prestamo.solicitud
#        SolicitudEvento.create(
#              :solicitud_id=>solicitud.id,
#              :estatus=>solicitud.estatus,
#              :usuario_id=>user.id,
#              :ip_address=>self.ip_address,
#              :observaciones=>@observaciones)
#        success &&= solicitud.save!
#        raise Exception, "Error al guardar la solicitud" unless success
#
#        #Se actualizan los atributos propios del desembolso XX/XX/XXXX
#        fecha_f = desembolso[:fecha_valor_f]
#        desembolso[:fecha_valor_f] = "#{fecha_f[6..9]}-#{fecha_f[3..4]}-#{fecha_f[0..1]}"
#        desembolso[:usuario_id] = self.usuario.id
#        logger.debug "DES " << desembolso.inspect
#        success = self.update_attributes(desembolso)
#        success &&= self.save!
#        raise Exception, "Error al guardar el desembolso" unless success
#        return success
#      end
#    rescue Exception => e
#      logger.error e.message
#      logger.error e.backtrace.join("\n")
#      return false
#    end
#  end

  #****************************************************************************
  # solicitar_pago (24-03-2010)
  #****************************************************************************
  # Método registra la solicitud de pago para un desembolso
  #
  # Autor: Alex Belisario
  #
  #****************************************************************************
  def solicitar_pago(user, session)
    success = true
    begin
       transaction do
        logger.debug "Desembolso.solicitar_pago"
        prestamo = self.prestamo

        #Enviado al Area de Operaciones Financieras
        prestamo.estatus_desembolso = 'F'

        success &&= prestamo.save!
        raise I18n.t('Sistema.Body.Modelos.Desembolso.Errores.error_guardar_prestamo') unless success

        #success &&= enterar_ultrasec user, session
        #raise Exception, "Error al de sincronización con Ultrasec" unless success

        txt_comentario = "#{I18n.t('Sistema.Body.Vistas.ConsultarTransaccion.Etiquetas.prestamo')} #{self.prestamo.numero} / #{self.prestamo.estatus_desembolso_w}"
        # Crea un nuevo registro en la tabla control_solicitud
        success &&= ControlSolicitud.create_new(self.prestamo.solicitud.id, 10015, user.id, "#{I18n.t('Sistema.Body.Vistas.General.avanzar')}", 10015, txt_comentario)
        raise I18n.t('Sistema.Body.Modelos.Desembolso.Errores.registrar_traza_seguimiento') unless success

        return success
      end
    rescue Exception => e
      logger.error e.message
      logger.error e.backtrace.join("\n")
      return false
    end
  end

  #****************************************************************************
  # procesar_disponibilidad_financiera (04-03-2010)
  #****************************************************************************
  # Método que procesa la disponibilidad financiera para un desembolso
  #
  # Params:
  #  fecha_estimada: Fecha para la cual se solicita disponibilidad a tesorería
  #
  # Autor: Alex Belisario
  #
  #****************************************************************************
  def procesar_disponibilidad_financiera(user, session, fecha_estimada)
    begin
      transaction do
       valid = true
        logger.debug "Desembolso.procesar_disponibilidad_financiera"

        self.fecha_est_disp_financiera = format_fecha(fecha_estimada)
        self.prestamo.estatus_desembolso = 'T'
        valid = self.prestamo.save
        unless valid
          errors.add(:desembolso, I18n.t('Sistema.Body.Modelos.Desembolso.Errores.actualizar_datos_prestame'))
          raise I18n.t('Sistema.Body.Modelos.Desembolso.Errores.error_guardar_prestamo')
        end
        valid = self.validate
        unless valid
          errors.add(:desembolso, I18n.t('Sistema.Body.Modelos.Desembolso.Errores.actualizar_datos_desembolso'))
          raise I18n.t('Sistema.Body.Modelos.Desembolso.Errores.error_guardar_desemboldo')
        else
          self.save
        end

        txt_comentario = "#{I18n.t('Sistema.Body.Vistas.ConsultarTransaccion.Etiquetas.prestamo')} #{self.prestamo.numero} / #{self.prestamo.estatus_desembolso_w}"
        # Crea un nuevo registro en la tabla control_solicitud
        valid &&= ControlSolicitud.create_new(self.prestamo.solicitud.id, 10015, user.id, "#{I18n.t('Sistema.Body.Vistas.General.avanzar')}", 10015, txt_comentario)
        raise I18n.t('Sistema.Body.Modelos.Desembolso.Errores.registrar_traza_seguimiento') unless valid

        return self.prestamo.numero
      end
    rescue Exception => e
      logger.error e.message
      logger.error e.backtrace.join("\n")
      return false
    end

  end

  #****************************************************************************
  # aplicar_disponibilidad_financiera (08-03-2010)
  #****************************************************************************
  # Método que aplica la disponibilidad financiera para un desembolso
  #
  # Params:
  #  fecha_estimada: Fecha para la cual se solicita disponibilidad a tesorería
  #
  # Autor: Alex Belisario
  #
  #****************************************************************************
#  def aplicar_disponibilidad_financiera(user, session, disponibilidad)
#    begin
#      transaction do
#        prestamo = self.prestamo
#        if (disponibilidad.monto_comprometido + self.monto) <= disponibilidad.monto
#          #Monto de desembolso disponible
#          self.fecha_real_disp_financiera = disponibilidad.fecha_real
#          unless disponibilidad.fecha_procesado.nil?
#            self.fecha_procesado = disponibilidad.fecha_procesado
#          else
#            self.fecha_procesado = disponibilidad.fecha_real
#          end
#          disponibilidad.monto_comprometido += self.monto
#          disponibilidad.save
#          self.save!
#          return [prestamo.numero, true]
#        else
#          #Monto del desembolso supera la disponibilidad
#          return [prestamo.numero, false]
#        end
#      end
#    rescue Exception => e
#      logger.error e.message
#      logger.error e.backtrace.join("\n")
#      return false
#    end
#
#  end

  #****************************************************************************
  # deshacer_disponibilidad_financiera (09-03-2010)
  #****************************************************************************
  # Método que deshace la disponibilidad financiera aplicada un desembolso
  #
  # Params:
  #  fecha_estimada: Fecha para la cual se solicita disponibilidad a tesorería
  #
  # Autor: Alex Belisario
  #
  #****************************************************************************
#  def deshacer_disponibilidad_financiera(user, session)
#    begin
#      transaction do
#        logger.debug "Desembolso.deshacer_disponibilidad_financiera"
#        if !self.fecha_real_disp_financiera.nil?
#          #Disponibilidad ya aplicada. Se reversa el monto aplicado
#          disponibilidad = DisponibilidadTesoreria.find(:first, :conditions => ["fecha_solicitud=? and fecha_real=?",self.fecha_est_disp_financiera, self.fecha_real_disp_financiera])
#          disponibilidad.monto_comprometido -= self.monto
#          disponibilidad.save
#        end
#        #solicitud = self.prestamo.solicitud
#        self.fecha_est_disp_financiera = nil
#        self.fecha_real_disp_financiera = nil
#        self.fecha_procesado = nil
#        self.fecha_valor = nil
#        self.disp_financiera = false
#        self.save
#        return true
#      end
#    rescue Exception => e
#      logger.error e.message
#      logger.error e.backtrace.join("\n")
#      return false
#    end
#
#  end

    #****************************************************************************
  # materializar_desembolso (25-03-2010)
  #****************************************************************************
  # Operación que materializa el desembolso para ser procesado por cobranzas
  #
  # Params:
  #  fecha_estimada: Fecha para la cual se solicita disponibilidad a tesorería
  #
  # Autor: Alex Belisario
  #
  #****************************************************************************
  def materializar_desembolso(user, session)
    success = true
    begin
      Desembolso.transaction do
        Prestamo
          logger.debug "Desembolso.materializar_desembolso"
          prestamo = self.prestamo

          #estatus_destino = ConfiguracionAvance.find_by_estatus_origen_id(solicitud.estatus_id).estatus_destino_id
          #solicitud.estatus_id = estatus_destino

          #solicitud = self.prestamo.solicitud
          #success &&= solicitud.save
          prestamo.avanzar_estatus_desembolso(user, session)
          raise I18n.t('Sistema.Body.Modelos.Desembolso.Errores.actualizar_datos_solicitud') unless success

          return true
      end
    rescue Exception => e
      logger.error e.message
      logger.error e.backtrace.join("\n")
      return false
    end
  end

  #****************************************************************************
  # enterar_ultrasec (22-07-2010)
  #****************************************************************************
  # Operación establece comunicación con Ultrasec para enterar los pagos
  #
  # Autor: Alex Belisario
  #
  #****************************************************************************
  def enterar_ultrasec(user, session)
    success = true
    usec = false
    usec_pabos = nil
    usec_dswift = nil
    begin
      Desembolso.transaction do
          logger.debug "Desembolso.enterar_ultrasec"
          solicitud = self.prestamo.solicitud
          prestamo = self.prestamo

          self.desembolso_pagos.each do |pago|
            #fecha_disponibilidad, cod_corresponsal, concepto, monto, forma_pago
            str_concepto = pago.forma_pago == 'C' ? I18n.t('Sistema.Body.Modelos.Desembolso.Txt.transferencia_emision_cheque') : I18n.t('Sistema.Body.Modelos.Desembolso.Txt.pago_por_transferencia')
            pabo = {
              :fecha_disponibilidad => self.fecha_procesado,
              :cod_corresponsal => pago.cuenta_corresponsal.nucorrespo_usec,
              :concepto => "#{str_concepto}/#{I18n.t('Sistema.Body.Vistas.General.desembolso')} #{self.informe.numero_desembolso}/#{solicitud.cliente.nombre}",
              :monto => pago.monto - pago.monto_comision,
              :forma_pago => pago.forma_pago
            }
            #co_clave, beneficiario, cuenta, banco, monto, rif

            if pago.forma_pago == 'T'
              #Pago por transferencia
              if pago.beneficiario_solicitante
                beneficiario = pago.desembolso.prestamo.solicitud.cliente.nombre
                rif = pago.desembolso.prestamo.solicitud.cliente.identificador
              else
                 beneficiario = pago.beneficiario_tercero
                 rif = pago.beneficiario_rif
              end
            elsif pago.forma_pago == 'C'
              #Pago cheque
             beneficiario = Etiquetas.etiqueta(8) #RIF Nombre Institución
             rif = Etiquetas.etiqueta(14) #RIF Institución
            end
            dswift = {
              :beneficiario => beneficiario,
              :cuenta => pago.forma_pago == 'C'? pago.numero_referencia : pago.cuenta_operaciones,
              :banco => pago.entidad_financiera.codban_usec,
              :monto => pago.monto,
              :rif => rif

            }
            res = Ultrasec.registrar_transaccion pabo, dswift
            usec_pabos = res[0]
            usec_dswift = res[1]
            usec = true
            success &&= (res != false && res.size > 0)
            raise I18n.t('Sistema.Body.Modelos.Desembolso.Errores.registrar_transaccion_ultrasec') unless success

            pago.copaso_usec = usec_pabos.nu_paso

            success &&= pago.save!
            raise I18n.t('Sistema.Body.Modelos.Desembolso.Errores.actualizar_datos_pago') unless success
          end

          success &&= self.save!
          raise I18n.t('Sistema.Body.Modelos.Desembolso.Errores.actualizar_datos_desembolso') unless success

          #Registro del evento
          success &&= SolicitudEvento.create(
                :solicitud_id=>solicitud.id,
                :estatus=>solicitud.estatus,
                :usuario_id=>user.id,
                :ip_address=>self.ip_address,
                :observaciones=>'Notificación Ultrasec')

          raise I18n.t('Sistema.Body.Modelos.Desembolso.Errores.registrar_traza_seguimiento') unless success

          return true
      end
    rescue Exception => e
      if usec
        logger.debug "Reversando transacciones UltraSec"
        usec_pabos.destroy
        usec_dswift.destroy
      end
      errors.add(:desembolso, I18n.t('Sistema.Body.Modelos.Desembolso.Errores.comunicacion_ultrafloc'))
      logger.error e.message
      logger.error e.backtrace.join("\n")
      return false
    end
  end

  def total_comision
    monto_comision = 0
    self.gastos.each do |gasto|
      if gasto.porcentaje > 0
        monto_comision += self.monto * (gasto.porcentaje / 100)
      elsif gasto.monto_fijo > 0
        monto_comision += gasto.monto_fijo
      end
    end
    return monto_comision
  end

  def validate
    isValid = true
    logger.debug "Desembolso.validate"
    #Validaciones del desembolso

#    monto11 = self.monto.to_f
#    montoli = self.prestamo.monto_por_liquidar.to_f.round
#
#    if self.monto.to_f  > self.prestamo.monto_por_liquidar.to_f.round
#      logger.debug " --> Monto del desembolso > monto pendiente por desembolsar"
#      errors.add(nil, "El monto del desembolso, supera el monto pendiente por desembolsar para este préstamo")
#       isValid = false
#    end


#    monto11 = self.monto.to_f
#    montoli = self.prestamo.monto_por_liquidar.to_f.round
#
#    if self.monto.to_f  > self.prestamo.monto_por_liquidar.to_f.round
#      logger.debug " --> Monto del desembolso > monto pendiente por desembolsar"
#      errors.add(nil, "El monto del desembolso, supera el monto pendiente por desembolsar para este préstamo")
#       isValid = false
#    end


    if self.prestamo && self.prestamo.estatus_desembolso == 'S'

      if self.prestamo.monto_por_liquidar > 0 && self.monto <=0
        errors.add(:desembolso,  I18n.t('Sistema.Body.Modelos.Desembolso.Errores.monto_mayor_cero'))
      end
#      if self.tipo_desembolso=='E' && self.fecha_evento_especial.nil?
#        errors.add(nil, "La fecha del evento es requerida")
#      end
      #TODO: Se valida el campo entidad_financiera_id en cliente. El mismo no está actualizado
#      if self.tipo_desembolso=='D'
#        if self.prestamo.solicitud.cliente.entidad_financiera.nil?
#          errors.add(nil, "El " + Etiquetas.etiqueta(9) + " no posee información bancaria")
#        end
#      end
    end

    #Validaciones del detalle de pagos. Solo aplica para solicitud de pago
#    if self.validar_pago == true
#
#      if self.monto <= 0
#        errors.add(nil, "El monto del desembolso debe ser mayor a 0")
#        isValid = false
#      end
#
#      if total_comision > 0
#        if self.desembolso_pagos.count('gasto_imputado = true') != 1
#          errors.add(nil, "El gasto sólo puede ser imputado a un pago")
#          isValid = false
#        end
#      end
#      pagos_monto = 0.00
#      pagos_comision = 0.00
#      if self.fecha_valor.nil?
#        errors.add(nil, "Debe asignar una Fecha para cada cheque/transferencia")
#        isValid = false
#      else
#        fecha_actual_d =Date.today
#        errors.add(nil, "Fecha Valor para cada cheque/transferencia debe ser mayor o igual a la fecha actual") if fecha_actual_d > self.fecha_valor
#        isValid = false
#      end
#
#      self.desembolso_pagos.each do |pago|
#        if !pago.new_record?
#          pagos_monto += pago.monto unless pago.monto.nil?
#          pagos_comision += pago.monto_comision unless pago.monto_comision.nil?
#        end
#
#        #Valicación del pago
#        if pago.entidad_financiera_id.nil?
#          errors.add(nil, "Debe seleccionar una Entidad Financiera para cada cheque/transferencia")
#          isValid = false
#        end
#
#        if pago.cuenta_corresponsal_id.nil?
#          errors.add(nil, "Debe seleccionar la Cuenta a Debitar BCV para cada cheque/transferencia")
#          isValid = false
#        end
#
#        if pago.beneficiario_solicitante == false
#           if pago.beneficiario_tercero.length == 0
#              errors.add(nil, "Debe suministrar el nombre del Beneficiario para cada cheque/transferencia")
#              isValid = false
#           end
#            if pago.beneficiario_rif.length == 0
#              errors.add(nil, "Debe suministrar el rif del Beneficiario para cada cheque/transferencia")
#              isValid = false
#           end
#        end
#
#        if pago.forma_pago == 'C'
#          #Validación de Datos de cheque
#          if pago.cuenta_bcv_comercial_id.nil?
#            errors.add(nil, "Debe seleccionar una Cuenta a Acreditar BCV para cada cheque")
#            isValid = false
#          end
#        elsif pago.forma_pago == 'T'
#          #Validación de Datos de transferencia
#          cuenta_bancaria = CuentaBancaria.find_by_numero_and_cliente_id(pago.cuenta_operaciones, self.prestamo.solicitud.cliente_id)
#          if !cuenta_bancaria.nil?
#            cuenta_bcv = CuentaBcv.find(pago.cuenta_bcv_comercial_id)
#            if cuenta_bancaria.entidad_financiera_id != cuenta_bcv.entidad_financiera_id
#              errors.add(nil, "Las cuentas a acreditar deben pertenecer al mismo banco")
#              isValid = false
#            end
#          end
#          if pago.numero_referencia.nil?
#            errors.add(nil, "Debe asignar un Número de Referencia para cada transferencia")
#            isValid = false
#          end
#        end
#      end
#
#      if self.monto.to_f  != pagos_monto
#        errors.add(nil, "El monto del desembolso no coincide con la suma de los cheques y comisiones")
#         isValid = false
#      end
#    end
    return true
  end

  def validate_detalle
      monto_total = 0
      self.detalles.each do |det|
        monto_total += det.monto.to_f
      end
      if self.monto > 0 && self.detalles.size > 0 && self.monto != monto_total
      #if self.detalles.size == 0
        errors.add(:desembolso, I18n.t('Sistema.Body.Modelos.Desembolso.Errores.completar_informacion_desembolso'))
         return false
      end
      return true
  end

#  def before_save
#    logger.debug "Desembolso.before_save"
#    if self.prestamo && self.prestamo.estatus_desembolso == 'S'
#      self.prestamo.monto_liquidado += self.monto
#      self.prestamo.update
#      if (self.prestamo.solicitud.total_desembolsos)==(self.prestamo.solicitud.total_prestamos)
#        self.prestamo.solicitud.estatus='Q'
#        #self.prestamo.estatus_desembolso='E'
#      else
#        self.prestamo.solicitud.estatus = 'L'
#        #self.prestamo.estatus_desembolso='E'
#      end
#      self.prestamo.solicitud.usuario = @usuario
#      self.prestamo.solicitud.ip_address = @ip_address
#    end
#    sdfsdf
#  end

  def modalidad_w
    case self.modalidad
      when 'A'
        I18n.t('Sistema.Body.Vistas.General.anticipo')
      when 'D'
        I18n.t('Sistema.Body.Modelos.Desembolso.Modalidad.adelanto')
      when 'R'
        I18n.t('Sistema.Body.Modelos.Desembolso.Modalidad.reembolso')
      when 'O'
        I18n.t('Sistema.Body.Vistas.General.otro')
      when 'P'
        I18n.t('Sistema.Body.Modelos.Desembolso.Modalidad.programado')
    end
  end

  def tipo_desembolso_w
    case self.tipo_desembolso
      when 'E'
        I18n.t('Sistema.Body.Modelos.Desembolso.TipoDesembolso.evento_especial')
      when 'D'
        I18n.t('Sistema.Body.Modelos.Desembolso.TipoDesembolso.deposito_cuenta')
      when 'R'
        I18n.t('Sistema.Body.Modelos.Desembolso.TipoDesembolso.retiro_caja')
    end
  end

  def tipo_w
   case self.tipo_cheque
      when 'F'
        I18n.t('Sistema.Body.Modelos.Desembolso.TipoCheque.cheque_fondas')
      when 'G'
        I18n.t('Sistema.Body.Modelos.Desembolso.TipoCheque.desembolso_cheque_gerencia')
      else
        I18n.t('Sistema.Body.Modelos.Desembolso.TipoCheque.desembolso_transferencia_cuenta')
    end
  end

  after_initialize :initializar_monto
  def initializar_monto 
    #SE RENOMBRE EL METODO after_initialize POR initializar_monto
  #def after_initialize
   self.monto = 0 unless self.monto
   #self.interes_gracia = 0 unless self.interes_gracia
  end

  def interes_desembolso_f=(valor)
    self.interes_desembolso = format_valor(valor)
  end

  def interes_desembolso_f
    format_f(self.interes_desembolso.to_s.to_f)
  end

  def interes_desembolso_fm
    format_fm(self.interes_desembolso.to_s.to_f)
  end

  def monto_f=(valor)
    format_valor(self.monto.to_s.to_f)
  end

  def monto_f
    format_f(self.monto.to_s.to_f)
  end

  def monto_fm
    format_fm(self.monto.to_s.to_f)
  end

  def fecha_valor_f=(fecha)
    self.fecha_valor = fecha
  end

  def fecha_valor_f
    format_fecha(self.fecha_valor)
  end

 # Métodos nuevos necesarios para mostrar los intereses de gracia y los devengos
  def interes_devengado_mes_f
    format_f(self.interes_devengado_mes.to_s.to_f)
  end

  def interes_devengado_mes_fm
    format_fm(self.interes_devengado_mes.to_s.to_f)
  end


  def interes_dif_gracia_devengado_mes_f
    format_f(self.interes_dif_gracia_devengado_mes.to_s.to_f)
  end

  def interes_dif_gracia_devengado_mes_fm
    format_fm(self.interes_dif_gracia_devengado_mes.to_s.to_f)
  end

  def interes_ordinario
    self.interes_devengado_mes - self.interes_dif_gracia_devengado_mes
  end

  def interes_ordinario_f
    format_f(self.interes_ordinario.to_s.to_f)
  end

  def interes_ordinario_fm
    format_fm(self.interes_ordinario.to_s.to_f)
  end

  def tasa_desembolso_f
    format_f(self.tasa.to_s.to_f)
  end

  def tasa_desembolso_fm
    format_fm(self.tasa.to_s.to_f)
  end

  def fecha_ultimo_devengo_f
    format_fecha(self.fecha_devengado)
  end

  def interes_devengado_acum_f
    format_f(self.interes_devengado_acum.to_s.to_f)
  end

  def interes_devengado_acum_fm
   format_fm(self.interes_devengado_acum.to_s.to_f)
  end

  def interes_gracia_f
    format_f(self.interes_gracia.to_s.to_f)
  end

  def interes_gracia_fm
    format_fm(self.interes_gracia.to_s.to_f)
  end

  def desembolso_pago_cheques
    return self.desembolso_pagos.find(:all, :conditions=>"forma_pago='C'")
  end

  def desembolso_pago_transferencias
    return self.desembolso_pagos.find(:all, :conditions=>"forma_pago='T'")
  end

  def add_documento(documento)
    if documentos.find documento.id
      errors.add(:desembolso, I18n.t('Sistema.Body.Modelos.Desembolso.Errores.documento_solicitado'))
      return false
    end
    rescue
      documentos << documento
  end

  def save_fecha(fecha)
    begin
      transaction do
        if fecha.empty? && self.fecha_realizacion.nil?
          errors.add(:desembolso, I18n.t('Sistema.Body.Modelos.Desembolso.Errores.fecha_efectiva'))
          raise I18n.t('Sistema.Body.Modelos.Desembolso.Errores.fecha_nil')
        else
          return self.save!
        end
      end
      rescue => detail
        errores = ""
        self.errors.each { |e|
        errores << "<li>" + e[1] + "</li>"
      }
      return errores
    end
  end


  # ======================================GENERANDO TXT VZLA==================================
  #                                      ANDREINA SARMIENTO
  #==========================================================================================


  def generar_archivo_vzla(tipo_archivo, condiciones, cuenta_bcv_fondas, fecha_valor,items,usuario_id)

    logger.debug 'Entrando GenerarArchivoVzla =====> ' << condiciones


=begin
      -------------------------------------
      Generación del archivo según filtro
      -------------------------------------
=end

    if items == ''

      # Asignación del nombre de archivo

      nombre ='PROV' +'_' + Time.now.strftime("%Y%m%d") + '_' + Time.now.strftime(I18n.t('time.formats.hora_banco'))

      @total = ViewListDesembolso.count(:conditions=>condiciones)

      logger.info "CONTADOR=======>"  << @total.to_s

      @valores = ViewListDesembolso.find_by_sql("select * from view_list_desembolso where " << condiciones)

      logger.info "VALORESS==========>>" << @valores.inspect

      logger.info "CLASE DE VSLORES===>" << @valores.class.to_s

      @cuenta_fondas = CuentaBcv.find_by_numero(cuenta_bcv_fondas)
      entidad_financiera_id = @cuenta_fondas.entidad_financiera_id


    if tipo_archivo == "txt"

      documento = 'public/documentos/desembolso/envio/' << nombre << '.txt'
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

        @header ='HEADER  ' + nro_lote.to_s + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.codigo_excel')}" + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.codigo')}" + fecha_valor + Time.now.strftime(I18n.t('time.formats.gebos_short'))

        logger.debug "header " << @header.inspect

        csv << @header.gsub(34.chr,'').parse_csv #imprimiendo linea

        @total_monto=0

      begin

        logger.info "TOTAL ============> " << @total.to_s
        while( @contador < @total)

            logger.info "VALORESS========>>" << @valores[@contador].inspect
            logger.info "CONTADORR=====>" << @contador.to_s

          if(@valores[@contador].tipo_cuenta == 'C')

            tipo_cuenta_bef = '00'

          else

            tipo_cuenta_bef = '01'
          end

          logger.info "tipo de cuentaaaa    ===="  << tipo_cuenta_bef.to_s

          if(@cuenta_fondas.tipo == 'C')

              tipo_cuenta_fon = '00'
          else

              tipo_cuenta_fon = '01'
          end

           logger.info "tipo de cuentaaaa fondas   ===== "  << tipo_cuenta_fon.to_s


          if (@valores[@contador].numero_cuenta[0,4] == '0102')

              tipo_pago_bef = '10'

          else

              tipo_pago_bef = '00'

          end

              logger.info "tipo de pago   ===== "  << tipo_pago_bef.to_s

          debito_monto = @valores[@contador].monto_liquidar.nil? ? format_f('0'.to_f) : format_f(@valores[@contador].monto_liquidar.to_s.to_f)
          credito_monto = @valores[@contador].monto_liquidar.nil? ? format_f('0'.to_f) : format_f(@valores[@contador].monto_liquidar.to_s.to_f)
#          debito_monto = @valores[@contador].monto_liquidar.nil? ? sprintf('%01.2f', '0.00'.to_s).sub('.' , ',') : @valores[@contador].monto_liquidar.to_s.sub('.' , ',')
#          credito_monto = @valores[@contador].monto_liquidar.nil? ? sprintf('%01.2f', '0.00'.to_s).sub('.' , ',') : @valores[@contador].monto_liquidar.to_s.sub('.' , ',')

          nro_solicitud = ('0' * (8 - @valores[@contador].nro_tramite.to_s.length)) + @valores[@contador].nro_tramite.to_s
          nro_cuenta_fon = ('0' * (20 - cuenta_bcv_fondas.to_s.length)) + cuenta_bcv_fondas.to_s
#          monto_debito = ('0' * (18 - debito_monto.to_s.length)) + debito_monto.to_s
          monto_debito = ('0' * (18 - debito_monto.to_s.length)) + debito_monto #verificar si los montos necesitan los to_s
          if(@valores[@contador].cedula_rif[0,1] == 'V' || @valores[@contador].cedula_rif[0,1] == 'E')

              @valores[@contador].cedula_rif.gsub!(' ', '')
              cedula_rif = @valores[@contador].cedula_rif[0,1]+('0' * (9 - (@valores[@contador].cedula_rif[1,9]).to_s.length)) + (@valores[@contador].cedula_rif[1,9]).to_s

          else

              cedula_rif = ('0' * (10 - (@valores[@contador].cedula_rif[0,1]+@valores[@contador].cedula_rif[2,8]+@valores[@contador].cedula_rif[11,1]).to_s.length)) + (@valores[@contador].cedula_rif[0,1]+@valores[@contador].cedula_rif[2,8]+@valores[@contador].cedula_rif[11,1]).to_s

          end

          nombre_beneficiario =   @valores[@contador].beneficiario.to_s[0,29]
          nombre_beneficiario = nombre_beneficiario + (" " * (30 - nombre_beneficiario.to_s.length))

          nro_cuenta_bef = ('0' * (20 - @valores[@contador].numero_cuenta.to_s.length)) + @valores[@contador].numero_cuenta.to_s
          monto_credito = ('0' * (18 - credito_monto.to_s.length)) + credito_monto.to_s

          cod_swift = @valores[@contador].cod_swift.to_s + (" " * ( 12 - @valores[@contador].cod_swift.to_s.length))
#          cod_swift = ('0' * (12 - @valores[@contador].cod_swift.to_s.length)) + @valores[@contador].cod_swift.to_s
          email_bef =  @valores[@contador].email.to_s + (" " * (50 - @valores[@contador].email.to_s.length))


          @debito ="#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.debito')}" + nro_solicitud + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.codigo')}" + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.nombre')}" + fecha_valor + tipo_cuenta_fon + nro_cuenta_fon + monto_debito + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.veb')}" + '40'

          @credito ="#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.credito')}" + nro_solicitud + cedula_rif + nombre_beneficiario + tipo_cuenta_bef + nro_cuenta_bef + monto_credito + tipo_pago_bef + cod_swift + '   ' + '    ' + email_bef

          @total_monto = @total_monto + credito_monto.to_s.to_f  # sumando los monto de los creditos realizados



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

      valor =format_f(@total_monto.to_s.to_f)

      cantidad_debito = ('0' * (5 - @total.to_s.length)) + @total.to_s
      cantidad_credito = ('0' * (5 - @total.to_s.length)) + @total.to_s

      total_monto_lote = ('0' * (18 - valor.to_s.length)) + valor

      @totales ="#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.total')}" + cantidad_debito + cantidad_credito + total_monto_lote

      csv << @totales.gsub(34.chr,'').parse_csv #imprimiendo linea

  logger.debug "MONTOSSSSS======>>>>>>>"  << valor.inspect
    end

      @control = ControlEnvioDesembolso.new(:fecha=>Time.now.strftime("%Y-%m-%d"), :archivo=>nombre+"."+tipo_archivo, :estatus=>1, :numero_procesado=>@total, :monto_procesado=>@total_monto, :entidad_financiera_id=>entidad_financiera_id)

      @control.save
      @control_id = @control.id



  logger.info "Control =====> " << @control.inspect

      puts "Documento ====> " << documento.to_s

      @contador = 0


#### codigo de prueba -----------------


             
      iniciar_transaccion(0, 'p_genera_archivo_vzla_transferencia', 'L', "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.titulo_inicio_transaccion')}", usuario_id, @total_monto.to_f)

#      iniciar_transaccion(0, 'p_genera_archivo_vzla_transferencia', 'L', "Actualización del reverso de la liquidación por transferencia con modalidad archivo txt segun filtro ", usuario_id, @total_monto.to_f)



#### fin codigo de prueba -----------------



      begin

          transaction do
              while( @contador < @total)

                unless @valores[@contador].desembolso_id.nil?

         logger.debug "VALORESSSSS DE TOTAL =====>" <<  @total.to_s

         logger.debug "ENTRO ACTUALIZAR DESEMBOLSO ======>"

                    @desembolso = Desembolso.find(@valores[@contador].desembolso_id)
                    @desembolso.fecha_valor = fecha_valor[6,4] << '-' << fecha_valor[3,2] << '-' << fecha_valor[0,2]
                    @desembolso.fecha_envio = Time.now.strftime(I18n.t('time.formats.gebos_short2'))
                    @desembolso.entidad_financiera_id = entidad_financiera_id
                    @desembolso.numero_cuenta = @valores[@contador].numero_cuenta.to_s
                    @desembolso.tipo_cuenta = @valores[@contador].tipo_cuenta.to_s
                    @desembolso.save!



                    logger.info "FECHA VALO ============>>>>" << @desembolso.fecha_envio.to_s
                    logger.debug "Estatus =======>" << @valores[@contador].estatus.to_s

                    if @valores[@contador].estatus.to_i == 10050

                        @solicitud= Solicitud.find(@valores[@contador].solicitud_id)
                        @solicitud.estatus_id = 10057
                        @solicitud.save!
                  logger.debug "ACTUALIZADOOOOO =====================>"  << @solicitud.estatus_id.to_s
                    end
                 logger.debug "Solicitud ======> " << @solicitud.inspect
                    #          @desembolso.update_attributes(:fecha_valor=> fecha_valor)
                    #          @desembolso.update_attributes(:fecha_envio=> format_fecha_inv2(Time.now))
                    #          @desembolso.update_attributes(:entidad_financiera_id=> entidad_financiera_id)
                    #          @desembolso.update_attributes(:numero_cuenta=> @valores[@contador].numero_cuenta)
                    #          @desembolso.update_attributes(:tipo_cuenta=> @valores[@contador].tipo_cuenta)
                end

                @contador+= 1

              end
          end
          rescue Exception => x
          logger.error x.message
          logger.error x.backtrace.join("\n")
          return false

      end

      @control = ControlEnvioDesembolso.find(@control_id)
#      @control.update_attributes(:estatus=>2)

      @control.estatus = 2
      @control.save

logger.info "CONTROL ESTATUSS ========>>>>>>" << @control.estatus.to_s

#### codigo de prueba  -----------------


        iniciar_transaccion(0, 'p_dummy', 'L', "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.transaccion_dummy')}", usuario_id,@total_monto.to_f)



#### fin codigo de prueba -----------------




   else #======================================GENERANDO EL ARCHIVO  EXCEL SEGUN FILTRO=================================

    documento = 'public/documentos/desembolso/envio/' << nombre << '.csv'
    CSV.open(documento,'w+',{:col_sep => "·" , :row_sep => "\r\n"}) do |csv|

        datos =''
        @contador = 0

        @nro_lote = ParametroGeneral.find(1)
        nro_lote = @nro_lote.nro_lote
        datos << ('0' * (8 - (@nro_lote.nro_lote.to_i + 1).to_s.length)) << (@nro_lote.nro_lote.to_i + 1).to_s
        @nro_lote.nro_lote = datos
        @nro_lote.save

        @header ='HEADER  ' + ';' + nro_lote.to_s + ';' + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.codigo_excel')}" + ';' + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.codigo')}" + ';' + fecha_valor + ';' + Time.now.strftime(I18n.t('time.formats.gebos_short'))

        csv << @header.sub(34.chr,'').parse_csv #imprimiendo linea

        @total_monto=0
      while( @contador < @total)

          if(@valores[@contador].tipo_cuenta == 'C')

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


        debito_monto = @valores[@contador].monto_liquidar.nil? ? format_f('0'.to_f) : format_f(@valores[@contador].monto_liquidar.to_s.to_f)
        credito_monto = @valores[@contador].monto_liquidar.nil? ? format_f('0'.to_f) : format_f(@valores[@contador].monto_liquidar.to_s.to_f)

        nro_solicitud = ('0' * (8 - @valores[@contador].nro_tramite.to_s.length)) + @valores[@contador].nro_tramite.to_s
        nro_cuenta_fon = ('0' * (20 - cuenta_bcv_fondas.to_s.length)) + cuenta_bcv_fondas.to_s
        monto_debito = ('0' * (18 - debito_monto.to_s.length)) + debito_monto #verificar si los montos necesitan los to_s

        if(@valores[@contador].cedula_rif[0,1] == 'V' || @valores[@contador].cedula_rif[0,1] == 'E')

              cedula_rif = @valores[@contador].cedula_rif[0,1]+('0' * (9 - (@valores[@contador].cedula_rif[1,10]).to_s.length)) + (@valores[@contador].cedula_rif[1,10]).to_s

        else

              cedula_rif = ('0' * (10 - (@valores[@contador].cedula_rif[0,1]+@valores[@contador].cedula_rif[2,8]+@valores[@contador].cedula_rif[11,1]).to_s.length)) + (@valores[@contador].cedula_rif[0,1]+@valores[@contador].cedula_rif[2,8]+@valores[@contador].cedula_rif[11,1]).to_s

        end

        nombre_beneficiario =   @valores[@contador].beneficiario.to_s + (" " * (30 - @valores[@contador].beneficiario.to_s.length))

        nro_cuenta_bef = ('0' * (20 - @valores[@contador].numero_cuenta.to_s.length)) + @valores[@contador].numero_cuenta.to_s
#        monto_credito = ('0' * (18 - credito_monto.to_s.length)) + credito_monto.to_s
        monto_credito = ('0' * (18 - credito_monto.to_s.length)) + credito_monto
        cod_swift = @valores[@contador].cod_swift.to_s + (" " * ( 12 - @valores[@contador].cod_swift.to_s.length))
#        cod_swift = ('0' * (12 - @valores[@contador].cod_swift.to_s.length)) + @valores[@contador].cod_swift.to_s
        email_bef =  @valores[@contador].email.to_s + (" " * (50 - @valores[@contador].email.to_s.length))


        @debito = "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.debito')}" + ';' + nro_solicitud + ';' +  "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.codigo')}" + ';' + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.nombre')}" + ';' + fecha_valor + ';' + tipo_cuenta_fon + ';' + nro_cuenta_fon + ';' + monto_debito + ';' + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.veb')}" + ';' + '40'
        @credito ="#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.credito')}" + ';' + nro_solicitud + ';' + cedula_rif + ';' + nombre_beneficiario + ';' + tipo_cuenta_bef + ';' + nro_cuenta_bef + ';' + monto_credito + ';' + tipo_pago_bef + ';' + cod_swift + ';' + '   ' + ';' + '    ' + ';' + email_bef
        @total_monto = @total_monto + @valores[@contador].monto_liquidar.to_s.to_f  # sumando los monto de los creditos realizados

        csv << @debito.sub(34.chr,'').parse_csv  #imprimiendo linea
        csv << @credito.sub(34.chr,'').parse_csv   #imprimiendo linea
        @contador += 1

      end

      valor = format_f(@total_monto.to_s.to_f)

      cantidad_debito = ('0' * (5 - @total.to_s.length)) + @total.to_s
      cantidad_credito = ('0' * (5 - @total.to_s.length)) + @total.to_s

      total_monto_lote = ('0' * (18 - valor.to_s.length)) + valor

      @totales= 'TOTAL   ' + ';' + cantidad_debito + ';' + cantidad_credito + ';' + total_monto_lote

      csv << @totales.sub(34.chr,'').parse_csv   #imprimiendo linea



      end

      @control = ControlEnvioDesembolso.new(:fecha=>Time.now.strftime("%Y-%m-%d"), :archivo=>nombre+"."+tipo_archivo, :estatus=>1, :numero_procesado=>@total, :monto_procesado=>@total_monto, :entidad_financiera_id=>entidad_financiera_id)

      @control.save
      @control_id = @control.id



      logger.info "Control =====> " << @control.inspect

      puts "Documento ====> " << documento.to_s

      @contador = 0


#### codigo de prueba -----------------

              
                iniciar_transaccion(0, 'p_genera_archivo_vzla_transferencia', 'L', "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.actualizar_revcerso_segun_csv')}", usuario_id, @total_monto.to_f)

#                iniciar_transaccion(0, 'p_genera_archivo_vzla_transferencia', 'L', "Actualización del reverso de la liquidación por transferencia con modalidad archivo csv segun filtro ", usuario_id, @total_monto.to_f)

#### fin codigo de prueba -----------------



      begin

          transaction do
              while( @contador < @total)

                unless @valores[@contador].desembolso_id.nil?

                    logger.debug "ENTRO ACTUALIZAR DESEMBOLSO ======>"
                    @desembolso = Desembolso.find(@valores[@contador].desembolso_id)
                    @desembolso.fecha_valor= fecha_valor
                    @desembolso.fecha_envio = Time.now.strftime(I18n.t('time.formats.gebos_short2'))
                    @desembolso.entidad_financiera_id = entidad_financiera_id
                    @desembolso.numero_cuenta = @valores[@contador].numero_cuenta
                    @desembolso.tipo_cuenta = @valores[@contador].tipo_cuenta
                    @desembolso.save

                    logger.debug "Estatus =======>" << @valores[@contador].estatus.to_s
                    if @valores[@contador].estatus == 10050

                        @solicitud= Solicitud.find(@valores[@contador].solicitud_id)
                        @solicitud.estatus_id = 10057
                        @solicitud.save
                    end
                    logger.debug "Solicitud ======> " << @solicitud.inspect
                    #          @desembolso.update_attributes(:fecha_valor=> fecha_valor)
                    #          @desembolso.update_attributes(:fecha_envio=> format_fecha_inv2(Time.now))
                    #          @desembolso.update_attributes(:entidad_financiera_id=> entidad_financiera_id)
                    #          @desembolso.update_attributes(:numero_cuenta=> @valores[@contador].numero_cuenta)
                    #          @desembolso.update_attributes(:tipo_cuenta=> @valores[@contador].tipo_cuenta)
                end

                @contador+= 1

              end
          end
          rescue Exception => x
          logger.error x.message
          logger.error x.backtrace.join("\n")
          return false

      end

      @control = ControlEnvioDesembolso.find(@control_id)
#      @control.update_attributes(:estatus=>2)

      @control.estatus = 2
      @control.save


#### codigo de prueba  -----------------


        iniciar_transaccion(0, 'p_dummy', 'L', "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.actualizar_revcerso_segun_csv')}", usuario_id,@total_monto.to_f)



#### fin codigo de prueba -----------------



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


    otra_condicion=condiciones + ' and desembolso_id in (' + item_formateado + ')'

    logger.info "OTRA CONDICION ========> " << otra_condicion.to_s
    nombre ="#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.prov')}" + '_' + Time.now.strftime(I18n.t('time.formats.gebos_txt_banco')) + '_' + Time.now.strftime(I18n.t('time.formats.hora_banco'))

    @total = ViewListDesembolso.count(:conditions=>otra_condicion)

    @valores = ViewListDesembolso.find_by_sql("select * from view_list_desembolso where " << otra_condicion)

    @cuenta_fondas = CuentaBcv.find_by_numero(cuenta_bcv_fondas)
    entidad_financiera_id = @cuenta_fondas.entidad_financiera_id

   #============================ TXT SEGUN SELECCION=====================================================


   if tipo_archivo == "txt"

      documento = 'public/documentos/desembolso/envio/' << nombre << '.txt'
       logger.info "tipo_archivo " << tipo_archivo

       logger.info "documento " << documento


      CSV.open(documento,'w+',{:col_sep => "·" , :row_sep => "\r\n"}) do |csv|

        logger.info "  INGRESA AQUIIIIIIIIIIIII"
        datos =''
        @contador = 0
        #fecha_valor= '10/09/2011'
        @nro_lote = ParametroGeneral.find(1)
        nro_lote = @nro_lote.nro_lote
        datos << ('0' * (8 - (@nro_lote.nro_lote.to_i + 1).to_s.length)) << (@nro_lote.nro_lote.to_i + 1).to_s
        @nro_lote.nro_lote = datos
        @nro_lote.save

        @header ='HEADER  ' + nro_lote.to_s + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.codigo_excel')}" + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.codigo')}" + fecha_valor + Time.now.strftime(I18n.t('time.formats.gebos_short'))

        csv << @header.sub(34.chr,'').parse_csv  #imprimiendo linea
         logger.debug "header " << @header.inspect

        @total_monto=0
        logger.info "TOTAL ============> " << @total.to_s
      while( @contador < @total)

          if(@valores[@contador].tipo_cuenta == 'C')

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


        debito_monto = @valores[@contador].monto_liquidar.nil? ? format_f('0'.to_f) : format_f(@valores[@contador].monto_liquidar.to_s.to_f)
        credito_monto = @valores[@contador].monto_liquidar.nil? ? format_f('0'.to_f) : format_f(@valores[@contador].monto_liquidar.to_s.to_f)

        nro_solicitud = ('0' * (8 - @valores[@contador].nro_tramite.to_s.length)) + @valores[@contador].nro_tramite.to_s
        nro_cuenta_fon = ('0' * (20 - cuenta_bcv_fondas.to_s.length)) + cuenta_bcv_fondas.to_s
        monto_debito = ('0' * (18 - debito_monto.to_s.length)) + debito_monto #verificar si los montos necesitan los to_s

        if(@valores[@contador].cedula_rif[0,1] == 'V' || @valores[@contador].cedula_rif[0,1] == 'E')

              @valores[@contador].cedula_rif.gsub!(' ', '')
              cedula_rif = @valores[@contador].cedula_rif[0,1]+('0' * (9 - (@valores[@contador].cedula_rif[1,9]).to_s.length)) + (@valores[@contador].cedula_rif[1,9]).to_s

          else

              cedula_rif = ('0' * (10 - (@valores[@contador].cedula_rif[0,1]+@valores[@contador].cedula_rif[2,8]+@valores[@contador].cedula_rif[11,1]).to_s.length)) + (@valores[@contador].cedula_rif[0,1]+@valores[@contador].cedula_rif[2,8]+@valores[@contador].cedula_rif[11,1]).to_s

          end

        nombre_beneficiario =   @valores[@contador].beneficiario.to_s[0,29]
        nombre_beneficiario = nombre_beneficiario + (" " * (30 - nombre_beneficiario.to_s.length))

        nro_cuenta_bef = ('0' * (20 - @valores[@contador].numero_cuenta.to_s.length)) + @valores[@contador].numero_cuenta.to_s
        monto_credito = ('0' * (18 - credito_monto.to_s.length)) + credito_monto.to_s
        cod_swift = @valores[@contador].cod_swift.to_s + (" " * ( 12 - @valores[@contador].cod_swift.to_s.length))
#        cod_swift = ('0' * (12 - @valores[@contador].cod_swift.to_s.length)) + @valores[@contador].cod_swift.to_s
        email_bef =  @valores[@contador].email.to_s + (" " * (50 - @valores[@contador].email.to_s.length))


        @debito = "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.debito')}" + nro_solicitud +  "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.codigo')}" + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.nombre')}" + fecha_valor + tipo_cuenta_fon + nro_cuenta_fon + monto_debito + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.veb')}" + '40'
        @credito ="#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.credito')}" + nro_solicitud + cedula_rif + nombre_beneficiario + tipo_cuenta_bef + nro_cuenta_bef + monto_credito + tipo_pago_bef + cod_swift + '   ' + '    ' + email_bef
        @total_monto = @total_monto + @valores[@contador].monto_liquidar.to_s.to_f  # sumando los monto de los creditos realizados


       logger.debug "TOTAL-MONTO============>>>>>>>" << @total_monto.to_s
        csv << @debito.sub(34.chr,'').parse_csv  #imprimiendo linea
        csv << @credito.sub(34.chr,'').parse_csv   #imprimiendo linea

        logger.debug "debito " << @debito.inspect

        logger.debug "credito " << @credito.inspect

        logger.debug "CSV ========> " << csv.inspect
        @contador += 1

      end

      valor = format_f(@total_monto.to_s.to_f)

      cantidad_debito = ('0' * (5 - @total.to_s.length)) + @total.to_s
      cantidad_credito = ('0' * (5 - @total.to_s.length)) + @total.to_s

      total_monto_lote = ('0' * (18 - valor.to_s.length)) + valor

      @totales= "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.total')}" + cantidad_debito + cantidad_credito + total_monto_lote

      csv << @totales.sub(34.chr,'').parse_csv   #imprimiendo linea
      logger.debug "MONTOSSSSS======>>>>>>>"  << valor.inspect
      end

      @control = ControlEnvioDesembolso.new(:fecha=>Time.now.strftime("%Y-%m-%d"), :archivo=>nombre+"."+tipo_archivo, :estatus=>1, :numero_procesado=>@total, :monto_procesado=>@total_monto, :entidad_financiera_id=>entidad_financiera_id)

      @control.save
      @control_id = @control.id



      logger.info "Control =====> " << @control.inspect

      puts "Documento ====> " << documento.to_s


      @contador = 0

#### codigo de prueba -----------------
              
                iniciar_transaccion(0, 'p_genera_archivo_vzla_transferencia', 'L', "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.actualizar_reverso_transferencia_segun_seleccion')}", usuario_id, @total_monto.to_f)

#                iniciar_transaccion(0, 'p_genera_archivo_vzla_transferencia', 'L', "Actualización del reverso de la liquidación por transferencia con modalidad archivo txt segun seleccion de items ", usuario_id, @total_monto.to_f)

#### fin codigo de prueba -----------------



     begin

          transaction do



              while( @contador < @total)

                unless @valores[@contador].desembolso_id.nil?




                    logger.debug "ENTRO ACTUALIZAR DESEMBOLSO ======>"
                    @desembolso = Desembolso.find(@valores[@contador].desembolso_id)
                    @desembolso.fecha_valor= fecha_valor
                    @desembolso.fecha_envio = Time.now.strftime(I18n.t('time.formats.gebos_short2'))
                    @desembolso.entidad_financiera_id = entidad_financiera_id
                    @desembolso.numero_cuenta = @valores[@contador].numero_cuenta
                    @desembolso.tipo_cuenta = @valores[@contador].tipo_cuenta
                    @desembolso.save


                    logger.debug "Estatus =======>" << @valores[@contador].estatus.to_s
                    if @valores[@contador].estatus == 10050

                        @solicitud= Solicitud.find(@valores[@contador].solicitud_id)
                        @solicitud.estatus_id = 10057
                        @solicitud.save
                    logger.debug "ACTUALIZADOOOOO =====================>"  << @solicitud.estatus_id.to_s
                    end
                    logger.debug "Solicitud ======> " << @solicitud.inspect
                    #          @desembolso.update_attributes(:fecha_valor=> fecha_valor)
                    #          @desembolso.update_attributes(:fecha_envio=> format_fecha_inv2(Time.now))
                    #          @desembolso.update_attributes(:entidad_financiera_id=> entidad_financiera_id)
                    #          @desembolso.update_attributes(:numero_cuenta=> @valores[@contador].numero_cuenta)
                    #          @desembolso.update_attributes(:tipo_cuenta=> @valores[@contador].tipo_cuenta)




                end

                @contador+= 1

              end
          end
          rescue Exception => x
          logger.error x.message
          logger.error x.backtrace.join("\n")
          return false

      end





      @control = ControlEnvioDesembolso.find(@control_id)
#      @control.update_attributes(:estatus=>2)

      @control.estatus = 2
      @control.save
logger.info "CONTROL ------> #{@control.inspect}"

###ddddd

#### codigo de prueba  -----------------


        iniciar_transaccion(0, 'p_dummy', 'L', "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.transaccion_dummy_reverso_transferencia_segun_seleccion')}", usuario_id,@total_monto.to_f)



#### fin codigo de prueba -----------------





   else #=====================GENERANDO EL ARCHIVO  EXCEL SEGUN SELECCION=============================

     documento = 'public/documentos/desembolso/envio/' << nombre << '.csv'
     CSV.open(documento,'w+',{:col_sep => "·" , :row_sep => "\r\n"}) do |csv|

        datos =''
        @contador = 0
        #fecha_valor= '10/09/2011'
        @nro_lote = ParametroGeneral.find(1)
        nro_lote = @nro_lote.nro_lote
        datos << ('0' * (8 - (@nro_lote.nro_lote.to_i + 1).to_s.length)) << (@nro_lote.nro_lote.to_i + 1).to_s
        @nro_lote.nro_lote = datos
        @nro_lote.save

        @header ='HEADER  ' + ';' + nro_lote.to_s + ';' + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.codigo_excel')}" + ';' + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.codigo')}" + ';' + fecha_valor + ';' + Time.now.strftime(I18n.t('time.formats.gebos_short'))

        csv << @header.sub(34.chr,'').parse_csv #imprimiendo linea

        @total_monto=0
      while( @contador < @total)

          if(@valores[@contador].tipo_cuenta == 'C')

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


        debito_monto = @valores[@contador].monto_liquidar.nil? ? format_f('0'.to_f) : format_f(@valores[@contador].monto_liquidar.to_s.to_f)
        credito_monto = @valores[@contador].monto_liquidar.nil? ? format_f('0'.to_f) : format_f(@valores[@contador].monto_liquidar.to_s.to_f)

        nro_solicitud = ('0' * (8 - @valores[@contador].nro_tramite.to_s.length)) + @valores[@contador].nro_tramite.to_s
        nro_cuenta_fon = ('0' * (20 - cuenta_bcv_fondas.to_s.length)) + cuenta_bcv_fondas.to_s
        monto_debito = ('0' * (18 - debito_monto.to_s.length)) + debito_monto #verificar si los montos necesitan los to_s

        if(@valores[@contador].cedula_rif[0,1] == 'V' || @valores[@contador].cedula_rif[0,1] == 'E')
          cedula_rif = @valores[@contador].cedula_rif[0,1]+('0' * (9 - (@valores[@contador].cedula_rif[1,10]).to_s.length)) + (@valores[@contador].cedula_rif[1,10]).to_scedula_rif = ('0' * (10 - (@valores[@contador].cedula_rif[0,1]+@valores[@contador].cedula_rif[2,10]).to_s.length)) + (@valores[@contador].cedula_rif[0,1]+@valores[@contador].cedula_rif[2,10]).to_s
        else
          cedula_rif = ('0' * (10 - (@valores[@contador].cedula_rif[0,1]+@valores[@contador].cedula_rif[2,8]+@valores[@contador].cedula_rif[11,1]).to_s.length)) + (@valores[@contador].cedula_rif[0,1]+@valores[@contador].cedula_rif[2,8]+@valores[@contador].cedula_rif[11,1]).to_s
        end

        nombre_beneficiario =   @valores[@contador].beneficiario.to_s + (" " * (30 - @valores[@contador].beneficiario.to_s.length))

        nro_cuenta_bef = ('0' * (20 - @valores[@contador].numero_cuenta.to_s.length)) + @valores[@contador].numero_cuenta.to_s
        monto_credito = ('0' * (18 - credito_monto.to_s.length)) + credito_monto.to_s
        cod_swift = @valores[@contador].cod_swift.to_s + (" " * ( 12 - @valores[@contador].cod_swift.to_s.length))
#        cod_swift = ('0' * (12 - @valores[@contador].cod_swift.to_s.length)) + @valores[@contador].cod_swift.to_s
        email_bef =  @valores[@contador].email.to_s + (" " * (50 - @valores[@contador].email.to_s.length))


        @debito = "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.debito')}" + ';' + nro_solicitud + ';' +  "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.codigo')}" + ';' + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.nombre')}" + ';' + fecha_valor + ';' + tipo_cuenta_fon + ';' + nro_cuenta_fon + ';' + monto_debito + ';' + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.veb')}" + ';' + '40'
        @credito ="#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.credito')}" + ';' + nro_solicitud + ';' + cedula_rif + ';' + nombre_beneficiario + ';' + tipo_cuenta_bef + ';' + nro_cuenta_bef + ';' + monto_credito + ';' + tipo_pago_bef + ';' + cod_swift + ';' + '   ' + ';' + '    ' + ';' + email_bef
        @total_monto = @total_monto + @valores[@contador].monto_liquidar.to_s.to_f  # sumando los monto de los creditos realizados

        csv << @debito.sub(34.chr,'').parse_csv  #imprimiendo linea
        csv << @credito.sub(34.chr,'').parse_csv   #imprimiendo linea
        @contador += 1

      end

      valor = format_f(@total_monto.to_s.to_f)

      cantidad_debito = ('0' * (5 - @total.to_s.length)) + @total.to_s
      cantidad_credito = ('0' * (5 - @total.to_s.length)) + @total.to_s

      total_monto_lote = ('0' * (18 - valor.to_s.length)) + valor.to_s

      @totales= "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.total')}" + ';' + cantidad_debito + ';' + cantidad_credito + ';' + total_monto_lote

      csv << @totales.sub(34.chr,'').parse_csv   #imprimiendo linea
      end

      @control = ControlEnvioDesembolso.new(:fecha=>Time.now.strftime("%Y-%m-%d"), :archivo=>nombre+"."+tipo_archivo, :estatus=>1, :numero_procesado=>@total, :monto_procesado=>@total_monto, :entidad_financiera_id=>entidad_financiera_id)

      @control.save
      @control_id = @control.id



      logger.info "Control =====> " << @control.inspect

      puts "Documento ====> " << documento.to_s

      @contador = 0


#### codigo de prueba -----------------

                iniciar_transaccion(0, 'p_genera_archivo_vzla_transferencia', 'L', "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.actualizar_reverso_transferencia_csv_segun_seleccion')}", usuario_id, @total_monto.to_f)


#### fin codigo de prueba -----------------



     begin

          transaction do

              while( @contador < @total)

                unless @valores[@contador].desembolso_id.nil?

                    logger.debug "ENTRO ACTUALIZAR DESEMBOLSO ======>"
                    @desembolso = Desembolso.find(@valores[@contador].desembolso_id)
                    @desembolso.fecha_valor= fecha_valor
                    @desembolso.fecha_envio = Time.now.strftime(I18n.t('time.formats.gebos_short2'))
                    @desembolso.entidad_financiera_id = entidad_financiera_id
                    @desembolso.numero_cuenta = @valores[@contador].numero_cuenta
                    @desembolso.tipo_cuenta = @valores[@contador].tipo_cuenta
                    @desembolso.save

                    logger.debug "Estatus =======>" << @valores[@contador].estatus.to_s
                    if @valores[@contador].estatus == 10050

                        @solicitud= Solicitud.find(@valores[@contador].solicitud_id)
                        @solicitud.estatus_id = 10057
                        @solicitud.save
                    end
                    logger.debug "Solicitud ======> " << @solicitud.inspect
                    #          @desembolso.update_attributes(:fecha_valor=> fecha_valor)
                    #          @desembolso.update_attributes(:fecha_envio=> format_fecha_inv2(Time.now))
                    #          @desembolso.update_attributes(:entidad_financiera_id=> entidad_financiera_id)
                    #          @desembolso.update_attributes(:numero_cuenta=> @valores[@contador].numero_cuenta)
                    #          @desembolso.update_attributes(:tipo_cuenta=> @valores[@contador].tipo_cuenta)
                end

                @contador+= 1

              end
          end
          rescue Exception => x
          logger.error x.message
          logger.error x.backtrace.join("\n")
          return false

      end # begin

      @control = ControlEnvioDesembolso.find(@control_id)
#      @control.update_attributes(:estatus=>2)

      @control.estatus = 2
      @control.save

#### codigo de prueba  -----------------


        iniciar_transaccion(0, 'p_dummy', 'L', "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.transaccion_dummy_reverso_transferencia_csv_segun_seleccion')}", usuario_id,@total_monto.to_f)



#### fin codigo de prueba -----------------



    end


end
  end

  def generar_transferencias(entidad_financiera_id, tipo_archivo, condiciones, cuenta_bcv_fondas, fecha_valor,items,usuario_id)

    logger.debug 'Entrando GenerarTransferencia =====> ' << entidad_financiera_id.to_s
    logger.info 'entidad_financiera_id ===>' << entidad_financiera_id.to_s
    logger.info 'tipo_archivo =>' << tipo_archivo.to_s
    logger.info 'condiciones =>' << condiciones.to_s
    logger.info 'cuenta_bcv_fondas =>' << cuenta_bcv_fondas.to_s
    logger.info 'fecha_valor =>' << fecha_valor.to_s
    logger.info 'items =>' << items.to_s
    logger.info 'usuario =>' << usuario_id.to_s
#    fecha_valor1 = fecha_valor[6,4] << '-' << fecha_valor[3,2] << '-' << fecha_valor[0,2]

    case entidad_financiera_id

      when 8

        logger.debug 'Ingreso en el 8 =====> '
        generar_archivo_vzla(tipo_archivo, condiciones, cuenta_bcv_fondas, fecha_valor,items,usuario_id)
    end

  end


  def generar_detalle_desembolso_v(items, user)
    success = true
    begin
      transaction do
        items = items.split(',')
        items.each { |i|
        plan = PlanInversion.find(i)
        montodes = (plan.monto_financiamiento - plan.monto_desembolsado)
        montoxrec = (self.seguimiento_visita.seguimiento_cultivo.superficie_recomendada * plan.costo_real)
        if (montodes < montoxrec)
          montoxrec = montodes
        end
        logger.debug "Item nro. "<< plan.id.to_s
        success &&= DesembolsoDetalle.create!(
          :desembolso_id=>self.id,
          :plan_inversion_id=>plan.id,
          :monto=> montoxrec
          )
          raise Exception, "Error al Crear el Detalle del Desembolso del Item #{plan.id}" unless success
        }
        monto_total_desembolso = DesembolsoDetalle.sum(:monto, :conditions=>"desembolso_id = #{self.id}")
        self.monto = monto_total_desembolso
        success &&= self.save!
        raise I18n.t('Sistema.Body.Modelos.Desembolso.Errores.actualizar_datos_desembolso') unless success

##        # ruta donde debe avanzar el credito
##        solicitud = Solicitud.find(self.solicitud_id)
##        estatus_id_inicial = solicitud.estatus_id
##        #BUSQUEDA DE NUEVO ESTATUS DEPENDIENDO SI TIENE EL DESEMBOLSO ES CON CHEQUE O TRANSFERENCIA
##
##        @cuenta_bancaria = CuentaBancaria.find(:first, :conditions=>['cliente_id = ?',solicitud.cliente.id])
##        if @cuenta_bancaria == nil
##          estatus_id_final = 10055
##        end
##        if @cuenta_bancaria != nil
##          estatus_id_final = 10050
##        end
##
##        fecha_evento = Time.now
##        solicitud.estatus_id = estatus_id_final
##        solicitud.fecha_actual_estatus = fecha_evento.strftime("%Y/%m/%d")
##        success = solicitud.save
##        if !success
##            errors.add(nil, "No es posible actualizar el trámite #{solicitud.numero}")
##        else
##        #----------- GUARDANDO AVANCE DE SOLICITUD ---------------------
##
##          success = ControlSolicitud.create_new(solicitud.id, estatus_id_final, user.id, 'Avanzar', estatus_id_inicial, '')
##          if !success
##            errors.add(nil, "No es posible registrar la traza del tramite #{solicitud.numero}")
##          end
##        end
##
##        raise Exception, "Error al guardar la solicitud" unless success
        # Crea un nuevo registro en la tabla control_solicitud
        #success &&= ControlSolicitud.create_new(solicitud.id, estatus_id_final, @usuario.id, 'Avanzar', estatus_id_inicial, '')
        #raise Exception, "Error al registrar la traza de seguimiento" unless success
        ####

        return success
      end #do
      rescue Exception => e
      logger.error e.message
      logger.error e.backtrace.join("\n")
      return false
    end #begin
  end


#=========================== METODO PARA LA RECEPCION DE ARCHIVO TXT DEL BANCO===============================================

  def actualizar_desembolso(params, usuario_id)

=begin

  -------------------------------------------------------------------------
  Este método ademas de actualizar los desembolsos también
  genera al mismo tiempo la tabla de amortización del financiamiento
  asociado al trámite, determinando si es el primer desembolso.
  Al momento del primer desembolso se le suma al saldo del préstamo
  el monto de la orden de despacho, el monto del SRAS y el monto del
  desembolso (banco).

  En los desembolsos siguientes solo se suma el monto de la orden de
  despacho el monto del desembolso (banco).

  Esta transacción puede ser reversada utilizado el mecanismo de los
  reversos implementados en el sistema GeBos.

  Este método funciona para uno (1) o varios trámites.
  -------------------------------------------------------------------------
=end

    begin

      monto_lote = 0
      id = params[:cuenta_id]
      id = id.slice(0,(id.length - 1))
      ids = params[:cuenta_id].split(',')
      monto_sras = 0

      logger.info "ids -------> " << ids.to_s
      numeros = ''
      #logger.info "ids -------> " << ids.class_to_s

      if id.class.to_s == 'String'

        prestamo = Prestamo.find(id.to_i)
        numeros << prestamo.numero.to_s

      else

        ids.each do |prestamo_id|

                  prestamo = Prestamo.find(prestamo_id)
                  numeros << prestamo.numero.to_s << ','

               end
        numeros = numeros.slice(0,(numeros.length - 1))
      end

      id=id[0,id.length-1]

      logger.info "otros id <<<<" << id.to_s
      total_desembolso = Desembolso.sum('monto', :conditions=>"prestamo_id in (#{id}) and realizado = false")
      total_insumos = OrdenDespacho.sum('monto', :conditions=>"prestamo_id in (#{id}) and realizado = false")
      prestamos = Prestamo.find(:all, :conditions=>"id in (#{id})")

      if total_desembolso.nil?
        total_desembolso = 0
      end

      if total_insumos.nil?
        total_insumos = 0
      end

      logger.info "TOTAL DESEMBOLSO =======> " << total_desembolso.to_s
      logger.info "TOTAL INSUMOS =======> " << total_insumos.to_s

      if !prestamos.empty?

        prestamos.each do |p|

          plan = PlanPago.find_by_prestamo_id_and_activo(p.id,true)

          if plan.nil?
            monto_sras += p.monto_sras_total
          end
        end

      end

      monto_lote = total_desembolso + total_insumos + monto_sras

      transaction do


        iniciar_transaccion(self.prestamo_id, 'p_generar_lote', 'L', "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.codigo_excel')}  #{numeros}", usuario_id, monto_lote)

        logger.info "NUMEROS ===========> " << numeros

        ids.each do |prestamo_id|

          logger.info "prestamo id -------> " << prestamo_id.to_s

          prestamo = Prestamo.find(prestamo_id)

          logger.info "prestamo -------> "  << prestamo.inspect
          logger.info "prestamo_id -------> "  << prestamo.id.to_s

          logger.info " solicitud_iddd ======>" << prestamo.solicitud_id.to_s

          solicitud = Solicitud.find(prestamo.solicitud_id)
          desembolso = Desembolso.find_by_prestamo_id_and_realizado(prestamo.id,false)
          orden_despacho = OrdenDespacho.find_by_prestamo_id_and_solicitud_id_and_estatus_id_and_realizado(prestamo.id,solicitud_id,20000,false)
          estatus_id_inicial = solicitud.estatus_id
          hoy = Time.now

          Prestamo.find_by_sql("update prestamo set estatus_desembolso = 'S' where id = #{prestamo.id}")
          fecha = Date.new(solicitud.fecha_liquidacion.year,solicitud.fecha_liquidacion.month,solicitud.fecha_liquidacion.day)

          logger.info "Fecha Actualizada ------------> " << fecha.to_s

          logger.info "FechaLiquidacion =========>" << solicitud.fecha_liquidacion.to_s

          desembolso.fecha_recepcion = solicitud.fecha_liquidacion
          desembolso.save

          logger.info "Desembolso despues de save en fecha_liquidacion ------------> " << desembolso.inspect

          fecha_evento = Time.now
          logger.info "Variable prestamo_id --------> " << prestamo_id.to_s
          desembolso = Desembolso.find_by_prestamo_id_and_realizado(prestamo_id.to_i,false)
          logger.info "Desembolso ============>  " << desembolso.inspect

          logger.info "Liquidación Préstamo"

          retorno = prestamo.liquidar(desembolso, nil, usuario_id, orden_despacho)
          logger.info "retorno -----> " << retorno.to_s


          estatus_id_inicial = solicitud.estatus_id
          if prestamo.monto_banco_fm == prestamo.monto_liquidado_fm
            condicionado = false
          else
            condicionado = true
          end

					#==================================================================================
					# LLAMADA DEL CAUSADO PARA SIGA ELABORADO POR ALEX CIOFFI 24/04/2013
					begin
						transaction do
							SigaCausado.generar(solicitud,prestamo,desembolso,'C','T')
						end
					end
					#==================================================================================
					# LLAMADA DEL PAGADO PARA SIGA ELABORADO POR ALEX CIOFFI 25/04/2013
					begin
						transaction do
							SigaPagado.generar(solicitud,prestamo,desembolso,'P','T')
						end
					end
					#==================================================================================



          # busco la ruta donde debe avanzar el credito

          @configuracion_avance = ConfiguracionAvance.find(:first, :conditions=>['estatus_origen_id = ? and condicionado = ?', estatus_id_inicial, condicionado])
          estatus_id_final = @configuracion_avance.estatus_destino_id
          solicitud.estatus_id =  estatus_id_final
          solicitud.save

          desembolso.realizado = true
          desembolso.save

          # Crea un nuevo registro en la tabla control_solicitud
          unless estatus_id_final.nil?
            ControlSolicitud.create(
             :solicitud_id=>solicitud.id,
             :estatus_id=>estatus_id_final,
             :usuario_id=>usuario_id,
             :fecha => fecha_evento,
             :estatus_origen_id => estatus_id_inicial
            )
          end

          id << prestamo_id

            #solicitud.estatus_id = 10070 if solicitud.estatus_id == 99
            #solicitud.estatus_id = 10090 if solicitud.estatus_id != 10080
            #solicitud.control = false
            #solicitud.fecha_actual_estatus = hoy
            #solicitud.save
            #control_solicitud = ControlSolicitud.new
            #control_solicitud.fecha = hoy
            #control_solicitud.estatus_id = solicitud.estatus_id
            #control_solicitud.estatus_origen_id = estatus_id_inicial
            #control_solicitud.solicitud_id = solicitud.id
            #control_solicitud.usuario_id = usuario_id
            #control_solicitud.save

        end    # Fin del ids.each

      end        # Fin transaction do

      #Fin de la transacción en la base de datos

      iniciar_transaccion(self.prestamo_id, 'p_dummy', 'L', "Transaccion Dummy", usuario_id, monto_lote)

      logger.info "ids ===========> " << prestamo_id.to_s

    end          # Fin del Begin

  end            # Fin del método actualizar_desembolso

  def Desembolso.reversar(params)

    begin

      transaction do
        ids = params[:cuenta_id1].split(',')
        ids.each {|id|
            solicitud = Solicitud.find(id)
            estatus_id_inicial = solicitud.estatus_id
            hoy = Time.now
            solicitud.estatus_id = 10057 if !solicitud.estatus_id = 10070
            solicitud.control = true
            solicitud.fecha_actual_estatus = hoy
            solicitud.fecha_liquidacion = nil
            solicitud.save
            control_solicitud = ControlSolicitud.new
            control_solicitud.fecha = hoy
            control_solicitud.estatus_id = 10057
            control_solicitud.estatus_origen_id = estatus_id_inicial
            control_solicitud.solicitud_id = solicitud.id
            control_solicitud.usuario_id = @usuario.id
            control_solicitud.save
        }
      end
    end
  end

  def Desembolso.save_montos( archivo, fecha, usuario_id )
    @total = 0
    @ids= ''
    @msg=[]
    begin

      transaction do

        name =  archivo[:datafile].original_filename.to_s
        logger.debug "archivo nombre " << name.to_s
        unless name.nil? || name.empty?
          ext  =  name[(name.length - 3),name.length]
            logger.debug "extension " << ext
          if ext.downcase != 'txt'
            @msg << I18n.t('Sistema.Body.Modelos.Desembolso.Errores.formato_txt_incorrecto')
            @clase = "error"
            if fecha.nil? || fecha.empty?
              @msg << I18n.t('Sistema.Body.Modelos.Desembolso.Errores.fecha_real')
            end
            return @total, @ids, @msg

          else

            if fecha.nil? || fecha.empty?
              @msg << I18n.t('Sistema.Body.Modelos.Desembolso.Errores.fecha_real')
              return @total, @ids, @msg
            end
            logger.debug "la fecha es " << fecha.to_s
            
              fecha =format_fecha_conversion(fecha)  
            
            #fecha = fecha[0][6,4] << '-' << fecha[0][3,2] << '-' << fecha[0][0,2]
            directory = "tmp"
            count = 0
            path = File.join(directory, name)
            #logger.debug "esto " << path.class.to_s << path.to_s << archivo[:datafile].tempfile.to_s             

            File.open(path, "wb") { |f| f.write(archivo[:datafile].read) } 
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

              logger.debug "COUNTTT ===>>>>>>" << count.to_s << " row " << row.to_s << " clase #{row.class.to_s}" << " tamaño #{row.gsub(/\r\n/, "").length.to_s} otra #{row.gsub("\r\n", "").length.to_s}"
              if row.to_s.gsub("\r\n", "").length == 200 || row.to_s.gsub("\r\n", "").length == 138 || row.to_s.gsub("\r\n", "").length == 251 || row.to_s.gsub("\r\n", "").length == 103 || row.to_s.gsub("\r\n", "").length == 88 || row.to_s.gsub("\r\n", "").length == 37
              # se quito if row.to_s.gsub("\r\n", "").length == 199 || row.to_s.gsub("\r\n", "").length == 138 || row.to_s.gsub("\r\n", "").length == 250 || row.to_s.gsub("\r\n", "").length == 102 || row.to_s.gsub("\r\n", "").length == 87 || row.to_s.gsub("\r\n", "").length == 36

                logger.info "LONGITUD=====>" << row.to_s.length.to_s

                if row.gsub("\r\n", "").to_s.length == 251

                  nro_solicitud = contenido[8,8]
                  ci_rif = contenido[16,10]
                  monto = contenido[78,18]
                  status = contenido[167,4]
                  des_status = contenido[171,80]

                  if ci_rif[0,1] == 'J' || ci_rif[0,1] == 'G'
                    ci_rif=ci_rif[0,1] << "-" << ci_rif[1,8] << "-" << ci_rif[9,1]
                  else

                    ci_rif= ci_rif[1,9]

                  end

                  logger.info "primer monto ====>>> " << monto.to_s

                  monto= monto.to_f/100

                  logger.info "Monto Dividido====>>" << monto.to_s

                  logger.info "ROWWW=====>>>>>>>>>>" << row.to_s
                  logger.debug "NRO SOLICITUD====>" << nro_solicitud.inspect
                  logger.debug "CIRIF========>" << ci_rif.inspect
                  logger.debug "estatus =====>" << status.inspect
                  logger.debug "descripcion ===>" << des_status.inspect
                  logger.info "MONTO=======> " << monto.to_s


                  result = true

                  if status != 'VE6 '

                    result2 = false

                  else
                    result2 = true
                  end

                  if result and result2

                    logger.info "Result entrando =====> " << result.to_s << " " << result2.to_s


                    @total = @total + 1
                    logger.info "TOTALLLL ======>>>>>>>>" << @total.inspect
                    # cliente = Cliente.find(:conditions=>"persona_id in (select id from persona where cedula = #{ci_rif.to_i}) or empresa_id in (select id from empresa where rif like '%#{ci_rif}')")
                    cliente = Cliente.find_by_sql("select id from cliente where persona_id in (select id from persona where cedula = #{ci_rif.to_i})  or empresa_id in (select id from empresa where rif like '%#{ci_rif}')")
                    unless cliente[0].nil?
                      # solicitud = Solicitud.find(:conditions=>"(estatus_id in(10060)) and cliente_id = #{cliente.id}")
                      logger.debug "cliente===>" << cliente[0].id.inspect << "nro " << nro_solicitud.inspect
                      solicitud = Solicitud.find_by_numero_and_estatus_id(nro_solicitud.to_i, 10057)

                      estatus_id_inicial = solicitud.estatus_id
                      fecha_evento = Time.now

                      logger.info "FECHAA=====>>>>>>>>>> " << fecha.inspect


                      unless solicitud.nil?
                        solicitud.fecha_liquidacion = fecha

                        if solicitud.estatus_id == 10057
                          solicitud.estatus_id = 10070

                        elsif solicitud.estatus_desembolso_id == 1
                          solicitud.estatus_desembolso_id = 2
                        end

                        prestamo = Prestamo.find_by_solicitud_id(solicitud.id)
                        if !prestamo.nil?
                          desembolso = Desembolso.find_by_prestamo_id_and_realizado(prestamo.id, false)#VERIFICAR ¿?

                          logger.debug "Prestamo====>" << solicitud.id.inspect << "nro " << nro_solicitud.inspect
                          #prestamo = Prestamo.find_by_sql("select * from prestamo where (solicitud_id = #{solicitud.id} and #{solicitud.numero}= #{nro_solicitud.to_i}) ") #VERIFICAR ¿?


                          #prestamo.monto_liquidado = prestamo.monto_liquidado.to_f + monto.to_f

                          #prestamo.save


                          logger.debug "Desembolso Detalle =====>>" << desembolso.id.inspect

                          desembolso.fecha_valor = fecha
                          desembolso.tipo_cheque = 'T'     #Desembolso por transferencia
                          desembolso.save

                          desembolso_detalle= DesembolsoDetalle.find(:all, :conditions=>"desembolso_id = #{desembolso.id}")

                          logger.info "DETALLE====> " << desembolso_detalle.id.to_s

                          if !desembolso_detalle.nil?

                            desembolso_detalle.each do |detalle|

                              plan_inversion= PlanInversion.find(detalle.plan_inversion_id)

                              logger.debug "DETALLE DESEMBOLSO ====> " << detalle.inspect
                              logger.debug "PLAN INVERSION========>>>>>>" << detalle.plan_inversion_id.to_s
                              logger.debug "MONTO DESEMBOLSO DETALLE ========>>>>>>" << detalle.monto.to_s
                              logger.debug "MONTOOOOOO DESEMBOLSADO ANTES ========>>>>>>" << plan_inversion.monto_desembolsado.to_s

                              plan_inversion.monto_desembolsado = plan_inversion.monto_desembolsado + detalle.monto

                              logger.debug "MONTOOOOOO DESEMBOLSADO DESPUES========>>>>>>" << plan_inversion.monto_desembolsado.to_s

                              plan_inversion.save

                            end     # fin de desembolso_detalle.each do |detalle|

                          else      # fin de if !desembolso_detalle.nil?

                            @msg << I18n.t('Sistema.Body.Modelos.Prestamo.Errores.detalle_desembolso_no_puede_ser_vacio')

                          end       # fin de if !desembolso_detalle.nil?

                        end     # fin de if !prestamo.nil?

                        #--------------------- ACTUALIZANDO LA TABLA HISTORICO LIQUIDACION TRANSFERENCIA ------------------------------------------

                        historico_transferencia = HistoricoLiquidacionTransferencia.new
                        historico_transferencia.solicitud_id  = solicitud.id
                        historico_transferencia.prestamo_id = prestamo.id
                        historico_transferencia.cliente_id = cliente[0].id
                        historico_transferencia.fecha_liquidacion =  fecha
                        historico_transferencia.archivo = name
                        historico_transferencia.monto_liquidacion = monto
                        #historico_transferencia.entidad_financiera_liquidadora_id =
                        #historico_transferencia.numero_cuenta_liquidadora =
                        historico_transferencia.entidad_financiera_cliente_id = desembolso.entidad_financiera_id
                        historico_transferencia.numero_cuenta_cliente = desembolso.numero_cuenta
                        historico_transferencia.save

                        #solicitud[0].estatus_id = 99
                        solicitud.control = true
                        solicitud.save
                        control_solicitud = ControlSolicitud.new
                        control_solicitud.fecha = fecha_evento
                        control_solicitud.estatus_id = 10070
                        control_solicitud.estatus_origen_id = estatus_id_inicial
                        control_solicitud.solicitud_id = solicitud.id
                        control_solicitud.usuario_id = usuario_id
                        control_solicitud.save

                        if @ids.length > 0
                          @ids = @ids << ',' << solicitud.id.to_s
                        else
                          @ids = solicitud.id.to_s
                        end

                      else     #unless solicitud.nil?
                  
                        @msg << "#{I18n.t('Sistema.Body.Modelos.Desembolso.Errores.la_solicitud')} #{count} #{I18n.t('Sistema.Body.Modelos.Desembolso.Errores.estatus_adecuado')}"
                  

                      end      # fin unless solicitud.nil?

                    else        # unless cliente[0].nil?

                
                      @msg << "#{I18n.t('Sistema.Body.Modelos.Desembolso.Errores.la_cedula')} #{count} #{I18n.t('Sistema.Body.Modelos.Desembolso.Errores.registrada_en_la_base_datos')}"
                      

                    end       # #unless cliente[0].nil?

                  end     # if result and result2

                  if !result2

                    @total = @total + 1
                    #cliente = Cliente.find(:conditions=>"persona_id in (select id from persona where cedula = #{ci_rif.to_i}) or empresa_id in (select id from empresa where rif like '%#{ci_rif}')")
                    cliente = Cliente.find_by_sql("select id from cliente where persona_id in (select id from persona where cedula = #{ci_rif.to_i})  or empresa_id in (select id from empresa where rif like '%#{ci_rif}')")
                    unless cliente[0].nil?
                      #solicitud = Solicitud.find(:conditions=>"(estatus_id in(10060)) and cliente_id = #{cliente.id}")
                      solicitud = Solicitud.find_by_numero(nro_solicitud.to_i)
                      estatus_id_inicial = solicitud.estatus_id
                      fecha_evento = Time.now
                      unless solicitud.nil?
                        solicitud.fecha_liquidacion = fecha
                        if solicitud.estatus_id == 10057
                          solicitud.estatus_id = 10080
                        elsif solicitud.estatus_desembolso_id == 10057
                          solicitud.estatus_desembolso_id = 10080
                        end

                        prestamo = Prestamo.find_by_solicitud_id(solicitud.id)
                        desembolso = Desembolso.find_by_prestamo_id_and_realizado(prestamo.id, false)#VERIFICAR ¿?

                        rechazo= RechazoLiquidacion.new(:fecha=>fecha, :archivo=> name, :prestamo_numero=>prestamo.numero, :solicitud_numero=> solicitud.numero, :cliente_id=>cliente[0].id, :monto_pago=>monto.to_f,:codigo_error=>status, :descripcion_error=>des_status, :entidad_financiera_id=>desembolso.entidad_financiera_id  )
                        rechazo.save

                        # solicitud[0].estatus_id = 99
                        solicitud.control = true
                        solicitud.save
                        control_solicitud = ControlSolicitud.new
                        control_solicitud.fecha = fecha_evento
                        control_solicitud.estatus_id = 10080
                        control_solicitud.estatus_origen_id = estatus_id_inicial
                        control_solicitud.solicitud_id = solicitud.id
                        control_solicitud.usuario_id = usuario_id
                        control_solicitud.save

                      end   # fin unless solicitud.nil?

                    end     # fin unless cliente[0].nil?

                  end      # if !result2

                else       # if row.to_s.length == 250

                  # @msg << "La línea #{count} no tiene el formato adecuado."
                  result = false

                  logger.info "REsult ultimo al finalizar la actualizacion"

                end     # fin if row.to_s.length == 250

                  logger.info "Resultadossssss =====> " << result.to_s << " " << result2.to_s

              else    #if row.to_s.gsub("\n", "").length == 199 || row.to_s.gsub("\n", "").length == 138 || row.to_s.gsub("\n", "").length == 250 || row.to_s.gsub("\n", "").length == 102 || row.to_s.gsub("\n", "").length == 87 || row.to_s.gsub("\n", "").length == 36
                logger.debug "NO INGRESO============>>>>>" << row.to_s.gsub("\r\n", "") << " CANTIDAD " << row.to_s.gsub("\r\n", "").length.to_s 
              end     # fin if row.to_s.gsub("\n", "").length == 199 || row.to_s.gsub("\n", "").length == 138 || row.to_s.gsub("\n", "").length == 250 || row.to_s.gsub("\n", "").length == 102 || row.to_s.gsub("\n", "").length == 87 || row.to_s.gsub("\n", "").length == 36

            end  # FasterCSV.foreach(path) do |row|

          end    #unless ext == 'txt'

        else  # unless name.nil? || name.empty?
          @msg << I18n.t('Sistema.Body.Modelos.Desembolso.Errores.cargar_archivo_procesar')
          if fecha.nil? || fecha.empty?
            @msg << I18n.t('Sistema.Body.Modelos.Desembolso.Errores.fecha_real')
          end

        end # unless name.nil? || name.empty?

        logger.info "TOTALLLL ======>>>>>>>>" << @total.to_s
        total = @total
        logger.info " TOOOOOOTALL ======>>>>>>>> " << total.to_s
        logger.info " IDS============>>>>> " << @ids.inspect
        ids = @ids
        return total, ids, @msg

      end   # fin transaction do

    end   # fin begin

  end
#=============================================================================================================================================

  def generar_detalle_desembolso_g(items, params, user)
    success = true
    begin
      transaction do
        items = items.split(',')
        items.each { |i|
        plan = PlanInversion.find(i)
        logger.debug "Item nro. "<< plan.id.to_s
        success &&= DesembolsoDetalle.create!(
          :desembolso_id=>self.id,
          :plan_inversion_id=>plan.id,
          :monto=> params[:"monto_recomendado_#{plan.id}"].to_f
          )
          raise "#{I18n.t('Sistema.Body.Modelos.Desembolso.Errores.crear_detalle_desembolso')} #{plan.id}" unless success
        }
        monto_total_desembolso = DesembolsoDetalle.sum(:monto, :conditions=>"desembolso_id = #{self.id}")
        self.monto = monto_total_desembolso
        success &&= self.save!
        raise I18n.t('Sistema.Body.Modelos.Desembolso.Errores.actualizar_datos_desembolso') unless success

##        # ruta donde debe avanzar el credito
##        solicitud = Solicitud.find(self.solicitud_id)
##        estatus_id_inicial = solicitud.estatus_id
##        #BUSQUEDA DE NUEVO ESTATUS DEPENDIENDO SI TIENE EL DESEMBOLSO ES CON CHEQUE O TRANSFERENCIA
##
##        @cuenta_bancaria = CuentaBancaria.find(:first, :conditions=>['cliente_id = ?',solicitud.cliente.id])
##        if @cuenta_bancaria == nil
##          estatus_id_final = 10055
##        end
##        if @cuenta_bancaria != nil
##          estatus_id_final = 10050
##        end
##
##        fecha_evento = Time.now
##        solicitud.estatus_id = estatus_id_final
##        solicitud.fecha_actual_estatus = fecha_evento.strftime("%Y/%m/%d")
##
##        success = solicitud.save
##        if !success
##            errors.add(nil, "No es posible actualizar el trámite #{solicitud.numero}")
##        else
##        #----------- GUARDANDO AVANCE DE SOLICITUD ---------------------
##
##          success = ControlSolicitud.create_new(solicitud.id, estatus_id_final, user.id, 'Envío de inf Desembolso', estatus_id_inicial, '')
##          if !success
##            errors.add(nil, "No es posible registrar la traza del tramite #{solicitud.numero}")
##          end
##        end
##        raise Exception, "Error al guardar la solicitud" unless success
##        # Crea un nuevo registro en la tabla control_solicitud
##        #success &&= ControlSolicitud.create_new(solicitud.id, estatus_id_final, @usuario.id, 'Avanzar', estatus_id_inicial, '')
##        #raise Exception, "Error al registrar la traza de seguimiento" unless success
##        ####

        return success
      end
      rescue Exception => e
      logger.error e.message
      logger.error e.backtrace.join("\n")
      return false

    end
  end

  def confirmar_desembolso(user, seguimiento)
      begin
      transaction do
        # ruta donde debe avanzar el credito
        solicitud = Solicitud.find(self.solicitud_id)
        estatus_id_inicial = solicitud.estatus_id
        #BUSQUEDA DE NUEVO ESTATUS DEPENDIENDO SI TIENE EL DESEMBOLSO ES CON CHEQUE O TRANSFERENCIA

        @cuenta_bancaria = CuentaBancaria.find(:first, :conditions=>['cliente_id = ?',solicitud.cliente.id])
        if @cuenta_bancaria == nil
          self.modalidad = 'C'
          estatus_id_final = 10055
        end
        if @cuenta_bancaria != nil
          self.modalidad = 'T'
          estatus_id_final = 10050
        end
        success_final = true
        logger.info"XXXXXX=========SEGUIMIENTO=========>>>>>>>>>>>>"<<seguimiento.inspect
        segui = SeguimientoVisita.find(seguimiento.id.to_s)
        segui.confirmada = true
        success_final &&=segui.save
        logger.info "INSPECT SEGUIMIENTO VISITA DENTRO DE VALIDAR DESEMBOLSO"<< segui.to_s.inspect
        logger.info "============================"
        logger.info "Errores en Seguimiento " << segui.errors.full_messages.to_s

        if !success_final
            errors.add(:desembolso, "#{I18n.t('Sistema.Body.Modelos.Desembolso.Errores.actualizar_tramite')} #{solicitud.numero} " << segui.errors.full_messages.to_s)
            return false
        else
            self.save
            fecha_evento = Time.now
            solicitud.estatus_id = estatus_id_final
            solicitud.fecha_actual_estatus = fecha_evento.strftime("%Y/%m/%d")

            success = solicitud.save
            if !success
                errors.add(:desembolso, "#{I18n.t('Sistema.Body.Modelos.Desembolso.Errores.actualizar_tramite')} #{solicitud.numero}")
            else

              #----------- GUARDANDO AVANCE DE SOLICITUD ---------------------

              success = ControlSolicitud.create_new(solicitud.id, estatus_id_final, user.id, I18n.t('Sistema.Body.Modelos.Desembolso.Errores.envio_informacion_desembolso') , estatus_id_inicial, '')
              if !success
                errors.add(:desembolso, "#{I18n.t('Sistema.Body.Modelos.Desembolso.Errores.traza_tramite')} #{solicitud.numero}")
              else
                self.confirmado = true
                self.save
              end
            end
            return success
        end
     end
     rescue Exception => e
     logger.error e.message
     logger.error e.backtrace.join("\n")
     return false
    end
  end


#=====================================Archivo txt para CHEQUE ============================

  def generar_txt_cheque_vzla(modalidad, condiciones, cuenta_bcv_fondas, items,usuario_id)

    #--------------------- CONDICION SI ES GENERACION DEL ARCHIVO SEGUN FILTRO------------
    logger.info "MODALIDADDDDDDDDDDDDD  ============>" << modalidad.to_s
    tipo_archivo="txt"
    if items ==''


      logger.info "CODNDICIONES =========> " << condiciones.to_s
      @total = ViewListDesembolsoCheque.count(:conditions=>condiciones)

      @valores = ViewListDesembolsoCheque.find_by_sql("select * from view_list_desembolso_cheque where " << condiciones)

      logger.info "Cuenta BCV FONDAS ========================> " << cuenta_bcv_fondas.to_s
      @cuenta_fondas = CuentaBcv.find_by_numero(cuenta_bcv_fondas)
      entidad_financiera_id = @cuenta_fondas.entidad_financiera_id

      logger.info "MODALIDADDDDD =========> " << modalidad.to_s

      if modalidad == 'gerencia'
        nombre = "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.venezuela_cheque_gerencia')}" + Time.now.strftime(I18n.t('time.formats.gebos_short2')) + Time.now.strftime("-#{I18n.t('time.formats.hora_banco')}")

      else
        nombre = "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.venezuela_cheque_propio')}" + Time.now.strftime(I18n.t('time.formats.gebos_short2')) + Time.now.strftime("-#{I18n.t('time.formats.hora_banco')}")

      end

        logger.info "modalidad " << modalidad.to_s
        documento = 'public/documentos/desembolso/envio_cheque/' << nombre << '.txt'

        logger.info "DOCUMENTO =================> " << documento.to_s

        CSV.open(documento,'w+',{:col_sep => "|" , :row_sep => "\r\n"}) do |csv|

          logger.info "Entro a creación de archivo =================> "
          datos = ''
          @contador = 0
          numero = ''
          montos_creditos = 0
         # montos_credito = ''
          cantidad_credito = ''
          creditos_montos = ''

          @nro_lote = ParametroGeneral.find(1)
          logger.info "Numero de lote leido =================> " << @nro_lote.inspect
          nro_lote = @nro_lote.nro_lote
          datos << ('0' * (15 - (@nro_lote.nro_lote.to_i + 1).to_s.length)) << (@nro_lote.nro_lote.to_i + 1).to_s
          numero << ('0' * (8 - (@nro_lote.nro_lote.to_i + 1).to_s.length)) << (@nro_lote.nro_lote.to_i + 1).to_s
          logger.debug "Numero de lote ===============> " << datos.to_s
          @nro_lote.nro_lote =  numero
          @nro_lote.save
          logger.info "Numero de lote despues save =================> " << @nro_lote.inspect

          cantidad_credito = ('0' * (15 - @total.to_s.length)) + format_valor(@total.to_s)

          montos_creditos = ViewListDesembolsoCheque.sum(:monto_liquidar, :conditions=>condiciones)

          #montos_credito =  @montos_credito.montos_credito

          montos_credito = montos_creditos.nil? ? format_f('0'.to_f) : format_f(montos_creditos.to_s.to_f)
          logger.info "longitud montos credito  "  << montos_credito.length.to_s
          #logger.info "Monto credito nil   "  << montos_credito.nil?
          logger.info "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU"
          logger.info "Montos Credito ========> " << montos_credito.to_s

          creditos_montos = ('0' * (17 - montos_credito.length)) << montos_credito.to_s

          logger.info "Creditos Montos ========> " << creditos_montos.to_s

  #        montos_creditos = @valores[@contador].monto_liquidar.nil? ? sprintf('%01.2f', '0.00'.to_s).sub('.' , ',') : @valores[@contador].monto_liquidar.to_s.sub('.' , ',')

          #PRIMER LINEA------------------------------
          @header ="#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.cabecera_cheque')}" + ' ' + '01' + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.codigo')}" + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.nombre')}" + nro_lote.to_s + Time.now.strftime(I18n.t('time.formats.gebos_short2')) + '000000000000001' + cantidad_credito + creditos_montos

          logger.debug "HEADER    " << @header.to_s

          csv << @header.sub(34.chr,'').parse_csv # imprimiendo linea


          nro_lote = ('0' * (8 - (@nro_lote.nro_lote.to_i).to_s.length)) << (@nro_lote.nro_lote.to_i + 1).to_s
          nro_cuenta_fon = ('0' * (20 - cuenta_bcv_fondas.to_s.length)) + cuenta_bcv_fondas.to_s
          

          #SEGUNDA LINEA------------------------------
          @debito ="#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.cabecera_cheque')}" + ' ' + '02' + Time.now.strftime(I18n.t('time.formats.gebos_short2')) + '03292' + nro_lote.to_s + creditos_montos + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.veb')}" + '  ' + nro_cuenta_fon + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.bschveca')}" + '006' + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.cheques_manuales')}"

          csv << @debito.sub(34.chr,'').parse_csv # imprimiendo linea

          logger.debug "DEBITO    " << @debito.inspect

          #TERCERA LINEA------------------------------
          begin

            incremental = 0
            while ( @contador < @total)

              cod_swift = ''

              credito_monto = @valores[@contador].monto_liquidar.nil? ? format_f('0'.to_f) : format_f(@valores[@contador].monto_liquidar.to_s.to_f)
              monto_credito = ('0' * (17 - credito_monto.to_s.length)) + credito_monto.to_s

              if(@valores[@contador].cedula_rif[0,1] == 'V' || @valores[@contador].cedula_rif[0,1] == 'E')

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

              logger.info "Icremental1  " << incremental1.to_s
              logger.info "incremental " << incremental.to_s.length.to_s

              incremental2 = ('0' * (15 - incremental.to_s.length) << incremental.to_s)

              @credito = "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.cabecera_cheque')}" << ' ' << '03' << '03292' << incremental1 << monto_credito << "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.veb')}" << '20' << '  ' << '                     ' << "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.bschveca')}" << '501  ' << cedula_rif << espacio << nombre_benef << '              ' << incremental2

              csv << @credito.sub(34.chr,'').parse_csv  #imprimiendo linea

              logger.debug "CREDITO    " << @credito.inspect

              @contador += 1

            end #fin del while
            rescue Exception => x
              logger.info x.message
              logger.info x.backtrace.join("\n")
            return false


          end # fin de begin

          @control = ControlEnvioDesembolso.new(:fecha=>Time.now.strftime("%Y-%m-%d"), :archivo=>nombre+"."+tipo_archivo, :estatus=>1, :numero_procesado=>@total, :monto_procesado=>montos_creditos, :entidad_financiera_id=>entidad_financiera_id)

          @control.save
          @control_id = @control.id


          logger.info "Control =====> " << @control.inspect

          puts "Documento ====> " << documento.to_s

          @contador = 0


#### codigo de prueba -----------------

        iniciar_transaccion(0, 'p_genera_archivo_vzla_cheque', 'L', "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.actualizacion_reverso_cheque_con_modalidad')} #{modalidad} ", usuario_id, montos_creditos.to_f)


#### fin codigo de prueba -----------------


          #---------------ACTUALIZANDO DESEMBOLSO------------
          begin

            transaction do

              while( @contador < @total)

                unless @valores[@contador].desembolso_id.nil? # unless 1


                    @desembolso = Desembolso.find(@valores[@contador].desembolso_id)
                    @desembolso.fecha_valor = Time.now.strftime(I18n.t('time.formats.gebos_short2'))
                    @desembolso.fecha_envio = Time.now.strftime(I18n.t('time.formats.gebos_short2'))
                    @desembolso.entidad_financiera_id = entidad_financiera_id
                    if modalidad == 'gerencia'
                      @desembolso.tipo_cheque = 'G'
                    else
                      @desembolso.tipo_cheque = 'P'
                    end
                    @desembolso.save

                    if @valores[@contador].estatus == 10055

                        @solicitud= Solicitud.find(@valores[@contador].solicitud_id)
                        @solicitud.estatus_id = 10060
                        @solicitud.save
                        logger.debug "ACTUALIZADOOOOO =====================>"  << @solicitud.estatus_id.to_s
                    end

                end #fin del unless 1

                @contador+= 1

              end #fin segundo while

            end # fin transaction

            rescue Exception => x
            logger.error x.message
            logger.error x.backtrace.join("\n")
            return false

          end # fin begin

          @control = ControlEnvioDesembolso.find(@control_id)
   #      @control.update_attributes(:estatus=>2)

          @control.estatus = 2
          @control.save

#### codigo de prueba  -----------------


        iniciar_transaccion(0, 'p_dummy', 'L', "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.transaccion_dummy_reverso_cheque_con_modalidad')} #{modalidad}  ", usuario_id,montos_creditos.to_f)



#### fin codigo de prueba -----------------


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

      otra_condicion=condiciones + ' and desembolso_id in (' + item_formateado + ')'

      logger.info "OTRA CONDICION ========> " << otra_condicion.to_s
      nombre ="#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.venezuela_cheque')}" + Time.now.strftime(I18n.t('time.formats.gebos_txt_banco')) + Time.now.strftime(I18n.t('time.formats.hora_banco'))

      @total = ViewListDesembolsoCheque.count(:conditions=>otra_condicion)

      @valores = ViewListDesembolsoCheque.find_by_sql("select * from view_list_desembolso_cheque where " << otra_condicion)

      @cuenta_fondas = CuentaBcv.find_by_numero(cuenta_bcv_fondas)
      entidad_financiera_id = @cuenta_fondas.entidad_financiera_id

      if modalidad == 'gerencia'
      nombre = "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.venezuela_cheque_gerencia')}" + Time.now.strftime(I18n.t('time.formats.gebos_short2')) + Time.now.strftime(I18n.t('time.formats.hora_banco'))
      else
      nombre ="#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.venezuela_cheque_propio')}" + Time.now.strftime(I18n.t('time.formats.gebos_short2')) + Time.now.strftime(I18n.t('time.formats.hora_banco'))
      end

        logger.info "modalidad " << modalidad.to_s
        documento = 'public/documentos/desembolso/envio_cheque/' << nombre << '.txt'

        logger.info "DOCUMENTO =================> " << documento.to_s

        CSV.open(documento,'w+',{:col_sep => "|" , :row_sep => "\r\n"}) do |csv|

          logger.info "Entro a creación de archivo =================> "
          datos = ''
          @contador = 0
          numero = ''
          montos_creditos = 0
         # montos_credito = ''
          cantidad_credito = ''
          creditos_montos = ''

          @nro_lote = ParametroGeneral.find(1)
          logger.info "Numero de lote leido =================> " << @nro_lote.inspect
          nro_lote = @nro_lote.nro_lote
          datos << ('0' * (15 - (@nro_lote.nro_lote.to_i + 1).to_s.length)) << (@nro_lote.nro_lote.to_i + 1).to_s
          numero << ('0' * (8 - (@nro_lote.nro_lote.to_i + 1).to_s.length)) << (@nro_lote.nro_lote.to_i + 1).to_s
          logger.debug "Numero de lote ===============> " << datos.to_s
          @nro_lote.nro_lote =  numero
          @nro_lote.save
          logger.info "Numero de lote despues save =================> " << @nro_lote.inspect

          cantidad_credito = ('0' * (15 - @total.to_s.length)) + format_valor(@total.to_s)

          montos_creditos = ViewListDesembolsoCheque.sum(:monto_liquidar, :conditions=>otra_condicion)


          #montos_credito =  @montos_credito.montos_credito

          montos_credito = montos_creditos.nil? ? format_f('0'.to_f) : format_f(montos_creditos.to_s.to_f)
          logger.info "longitud montos credito  "  << montos_credito.length.to_s
          #logger.info "Monto credito nil   "  << montos_credito.nil?
          
          logger.info "Montos Credito ========> " << montos_credito.to_s

          creditos_montos = ('0' * (17 - montos_credito.length)) << montos_credito.to_s

          logger.info "Creditos Montos ========> " << creditos_montos.to_s

  #        montos_creditos = @valores[@contador].monto_liquidar.nil? ? sprintf('%01.2f', '0.00'.to_s).sub('.' , ',') : @valores[@contador].monto_liquidar.to_s.sub('.' , ',')

          #PRIMER LINEA------------------------------
          @header ="#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.cabecera_cheque')}" + ' ' + '01' + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.codigo')}" + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.nombre')}" + nro_lote.to_s + Time.now.strftime(I18n.t('time.formats.gebos_txt_banco')) + '000000000000001' + cantidad_credito + creditos_montos

          logger.debug "HEADER    " << @header.to_s

          csv << @header.sub(34.chr,'').parse_csv # imprimiendo linea


          nro_lote = ('0' * (8 - (@nro_lote.nro_lote.to_i).to_s.length)) << (@nro_lote.nro_lote.to_i + 1).to_s
          nro_cuenta_fon = ('0' * (20 - cuenta_bcv_fondas.to_s.length)) + cuenta_bcv_fondas.to_s
          
          #SEGUNDA LINEA------------------------------
          @debito ="#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.cabecera_cheque')}" + ' ' + '02' + Time.now.strftime(I18n.t('time.formats.gebos_txt_banco')) + '03292' + nro_lote.to_s + creditos_montos + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.veb')}" + '  ' + nro_cuenta_fon + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.bschveca')}" + '006' + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.cheques_manuales')}"

          csv << @debito.sub(34.chr,'').parse_csv # imprimiendo linea

          logger.debug "DEBITO    " << @debito.inspect

          #TERCERA LINEA------------------------------
          begin


            incremental = 0
            while ( @contador < @total)


              cod_swift = ''

              credito_monto = @valores[@contador].monto_liquidar.nil? ? format_f('0'.to_f) : format_f(@valores[@contador].monto_liquidar.to_s.to_f)
              monto_credito = ('0' * (17 - credito_monto.to_s.length)) + credito_monto

              if(@valores[@contador].cedula_rif[0,1] == 'V' || @valores[@contador].cedula_rif[0,1] == 'E')

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

              logger.info "Icremental1  " << incremental1.to_s
              logger.info "incremental " << incremental.to_s.length.to_s

              incremental2 = ('0' * (15 - incremental.to_s.length) << incremental.to_s)

              @credito = "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.cabecera_cheque')}" << ' ' << '03' << '03292' << incremental1 << monto_credito << "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.veb')}"  << '20' << '  ' << '                     ' << "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.bschveca')}" << '501  ' << cedula_rif << espacio << nombre_benef << '              ' << incremental2

              csv << @credito.sub(34.chr,'').parse_csv  #imprimiendo linea

              logger.debug "CREDITO    " << @credito.inspect

              @contador += 1

            end #fin del while
            rescue Exception => x
              logger.info x.message
              logger.info x.backtrace.join("\n")
            return false


          end # fin de begin

#          @control = ControlEnvioDesembolso.new(:fecha=>Time.now.strftime(I18n.t('time.formats.gebos_short2')), :archivo=>nombre, :estatus=>1, :numero_procesado=>@total, :monto_procesado=>montos_creditos, :entidad_financiera_id=>entidad_financiera_id)

          @control = ControlEnvioDesembolso.new(:fecha=>Time.now.strftime("%Y-%m-%d"), :archivo=>nombre+"."+tipo_archivo, :estatus=>1, :numero_procesado=>@total, :monto_procesado=>montos_creditos, :entidad_financiera_id=>entidad_financiera_id)

          @control.save
          @control_id = @control.id


          logger.info "Control =====> " << @control.inspect

          puts "Documento ====> " << documento.to_s

          @contador = 0

#### codigo de prueba -----------------

                iniciar_transaccion(0, 'p_genera_archivo_vzla_cheque', 'L', "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.actualizacion_reverso_cheque_con_modalidad')} #{modalidad}  ", usuario_id, montos_creditos.to_f)


#### fin codigo de prueba -----------------



          #---------------ACTUALIZANDO DESEMBOLSO------------
          begin

            transaction do

              while( @contador < @total)

                unless @valores[@contador].desembolso_id.nil? # unless 1


                    @desembolso = Desembolso.find(@valores[@contador].desembolso_id)
                    @desembolso.fecha_valor = Time.now.strftime(I18n.t('time.formats.gebos_short2'))
                    @desembolso.fecha_envio = Time.now.strftime(I18n.t('time.formats.gebos_short2'))
                    @desembolso.entidad_financiera_id = entidad_financiera_id
                    if modalidad == 'gerencia'
                    @desembolso.tipo_cheque = 'G'
                    else
                    @desembolso.tipo_cheque = 'P'
                    end
                    @desembolso.save

                    if @valores[@contador].estatus == 10055

                        @solicitud= Solicitud.find(@valores[@contador].solicitud_id)
                        @solicitud.estatus_id = 10060
                        @solicitud.save
                        logger.debug "ACTUALIZADOOOOO =====================>"  << @solicitud.estatus_id.to_s
                    end

                end #fin del unless 1

                @contador+= 1

              end #fin segundo while

            end # fin transaction

            rescue Exception => x
            logger.error x.message
            logger.error x.backtrace.join("\n")
            return false

          end # fin begin

          @control = ControlEnvioDesembolso.find(@control_id)
   #      @control.update_attributes(:estatus=>2)

          @control.estatus = 2
          @control.save

#### codigo de prueba  -----------------


        iniciar_transaccion(0, 'p_dummy', 'L', "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.transaccion_dummy_reverso_cheque_con_modalidad')} #{modalidad} ", usuario_id,montos_creditos.to_f)



#### fin codigo de prueba -----------------



        end # del do

    end # Items

  end


  def generar_cheque(entidad_financiera_id, modalidad, condiciones, cuenta_bcv_fondas,items,usuario_id)

    logger.debug 'Entrando GenerarCheque =====> ' << entidad_financiera_id.to_s
    logger.info 'entidad_financiera_id ===>' << entidad_financiera_id.to_s
    logger.info 'modalidad =>' << modalidad.to_s
    logger.info 'condiciones =>' << condiciones.to_s
    logger.info 'cuenta_bcv_fondas =>' << cuenta_bcv_fondas.to_s
    logger.info 'items =>' << items.to_s
    logger.info 'usuario =>' << usuario_id.to_s
#    fecha_valor1 = fecha_valor[6,4] << '-' << fecha_valor[3,2] << '-' << fecha_valor[0,2]

    case entidad_financiera_id

      when 8

        logger.debug 'Ingreso en el 8 =====> '
        generar_txt_cheque_vzla(modalidad, condiciones.gsub("%25","%"), cuenta_bcv_fondas, items,usuario_id)
    end # when

  end


end


# == Schema Information
#
# Table name: desembolso
#
#  id                    :integer         not null, primary key
#  numero                :integer         not null
#  prestamo_id           :integer         not null
#  solicitud_id          :integer         not null
#  modalidad             :string(1)
#  monto                 :float
#  fecha_valor           :date
#  fecha_envio           :date
#  fecha_recepcion       :date
#  entidad_financiera_id :integer
#  tipo_cuenta           :string(1)
#  numero_cuenta         :string(20)
#  realizado             :boolean         default(FALSE)
#  usuario_id            :integer
#  seguimiento_visita_id :integer         not null
#  observacion           :text
#  tipo_cheque           :string(1)
#  referencia            :string(30)
#  confirmado            :boolean         default(FALSE)
#  fecha_registro        :date
#


