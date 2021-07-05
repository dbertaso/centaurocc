# encoding: utf-8
class DesembolsoDetalle < ActiveRecord::Base

  self.table_name = 'desembolso_detalle'

  attr_accessible :id,
    :desembolso_id,
    :plan_inversion_id,
    :monto

  belongs_to :desembolso
  belongs_to :plan_inversion
  
  validates :monto, :numericality =>{:numericality => true, :message => "#{I18n.t('Sistema.Body.Vistas.General.monto')} #{I18n.t('errors.messages.invalid')}" }
  
  
  def agregar_detalle(user, session)
    logger.debug "DesembolsoDetalle.agregar_detalle"
    success = true
    begin
      transaction do
        seguimiento = desembolso.desembolso_seguimiento
        prestamo = desembolso.prestamo
        monto_desembolsado = prestamo.monto_desembolsado_rubro self.rubro_id
        monto_maximo = prestamo.prestamo_rubros.find_by_rubro_id(self.rubro_id).valor_total
        monto_restante = monto_maximo - monto_desembolsado
        if self.monto.to_f > monto_restante.to_f
          rubro = Rubro.find self.rubro_id
          errors.add(:desembolso_detalle, "#{I18n.t('Sistema.Body.Modelos.DesembolsoDetalle.Errores.monto_supera_cantidad')} #{rubro.nombre} #{I18n.t('Sistema.Body.Modelos.DesembolsoDetalle.Errores.monto_supera_cantidad')} #{format_fm(monto_restante)}")
          raise I18n.t('Sistema.Body.Modelos.DesembolsoDetalle.Errores.monto_supera_monto_asignado')
        end
        desembolso.detalles << self
        seguimiento.concepto_aplicado = true

        success = self.actualizar_monto_desembolso
        raise I18n.t('Sistema.Body.Modelos.DesembolsoDetalle.Errores.error_actualizar_monto_desembolso') unless success

        success &&= self.valid?
        raise I18n.t('Sistema.Body.Modelos.DesembolsoDetalle.Errores.error_al_validar_detalle_desembolso') unless success

        success &&= desembolso.save!
        raise I18n.t('Sistema.Body.Modelos.DesembolsoDetalle.Errores.error_guardar_desembolso') unless success

        success &&= seguimiento.save!
        raise I18n.t('Sistema.Body.Modelos.DesembolsoDetalle.Errores.error_actualizar_seguimiento') unless success

        return success
      end
    rescue Exception => e
      logger.error e.message
      logger.error e.backtrace.join("\n")
      return false
    end
  end

  def eliminar_detalle(user, session)
    success = true
    begin
      transaction do
        logger.debug "DesembolsoDetalle.eliminar_detalle"
        desembolso = self.desembolso
        desembolso.monto -= self.monto
        if desembolso.monto == 0
          #se restituye el monto del desembolso por el monto original: monto por liquidar
          desembolso.monto = desembolso.prestamo.monto_por_liquidar
        end
        self.destroy
        raise I18n.t('Sistema.Body.Modelos.DesembolsoDetalle.Errores.error_actualizar_monto_detalle') unless success
        success &&= desembolso.save!
        raise I18n.t('Sistema.Body.Modelos.DesembolsoDetalle.Errores.error_guardar_desembolso') unless success
        return success
      end
    rescue Exception => e
      logger.error e.message
      logger.error e.backtrace.join("\n")
      return false
    end
  end

  def actualizar_monto_desembolso
    if self.desembolso.detalles.size == 0
      self.desembolso.monto = 0
    else
      monto_total = 0.00
      self.desembolso.detalles.each do |det|
        monto_total += det.monto.to_f
      end
      self.desembolso.monto = format_f(monto_total) 
    end
  end



  def monto_fm
    format_fm(self.monto)
  end



  #  def validate
  #    if monto <= 0
  #      errors.add(:detalle_desembolso, I18n.t('Sistema.Body.Modelos.DesembolsoDetalle.Errores.monto_debe_ser_mayor_cero'))
  #    end
  #
  #    if rubro_id.nil?
  #      errors.add(:detalle_desembolso, I18n.t('Sistema.Body.Modelos.DesembolsoDetalle.Errores.rubro_es_obligatorio'))
  #    end
  #    desembolso = Desembolso.find(self.desembolso_id)
  #    unless desembolso.detalles.size ==  0
  #      total_detalle = 0.00
  #      monto_total = 0.00
  #      self.desembolso.detalles.each do |det|
  #        total_detalle += det.monto.to_f
  #      end
  #      por_liquidar = format_f(desembolso.prestamo.monto_por_liquidar)
  #      if (total_detalle > por_liquidar)
  #        errors.add(:detalle_desembolso, (:detalle_desembolso, I18n.t('Sistema.Body.Modelos.DesembolsoDetalle.Errores.monto_supera_cantidad'))
  #      end
  #    end
  #  end
  

end


# == Schema Information
#
# Table name: desembolso_detalle
#
#  id                :integer         not null, primary key
#  desembolso_id     :integer         not null
#  plan_inversion_id :integer         not null
#  monto             :decimal(16, 2)  not null
#

