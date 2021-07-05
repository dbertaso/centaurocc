# encoding: utf-8

class DetalleReestructuracion < ActiveRecord::Base

self.table_name = 'detalle_reestructuracion'

  attr_accessible :id,
                  :fecha,
                  :estatus_id,
                  :solicitud_id,
                  :motivo,
                  :observaciones,
                  :causa_renuncia_id,
                  :causa_reestructuracion_id,
                  :prestamo_id,
                  :numero_acta,
                  :motivo_w,
                  :causa_renuncia_w

  def motivo_w
    case self.motivo
      when 'C'
        I18n.t('Sistema.Body.Controladores.DetalleReestructuracion.Mensajes.cambio_estatus')
      when 'M'
        I18n.t('Sistema.Body.Controladores.DetalleReestructuracion.Mensajes.renuncia_prestamo')
      when 'F'
        I18n.t('Sistema.Body.Controladores.DetalleReestructuracion.Mensajes.reestructuracion_financiera')
      when 'A'
        I18n.t('Sistema.Body.Controladores.DetalleReestructuracion.Mensajes.renuncia_desembolso')
      when 'T'
        I18n.t('Sistema.Body.Controladores.DetalleReestructuracion.Mensajes.exoneracion_interes_moratorios')
      when 'P'
        I18n.t('Sistema.Body.Controladores.DetalleReestructuracion.Mensajes.activacion_calculo')
      when 'R'
        I18n.t('Sistema.Body.Controladores.DetalleReestructuracion.Mensajes.reformulacion_error')
    end
  end

  def causa_renuncia_w
    if !self.causa_renuncia_id.nil? && !self.causa_renuncia_id == '0'
      causa = CausaRenuncia.find(self.causa_renuncia_id)
      return causa.nombre
    elsif !self.causa_reestructuracion_id.nil?
      case self.causa_reestructuracion_id
        when 1
          I18n.t('Sistema.Body.Controladores.DetalleReestructuracion.Mensajes.cambio_condiciones')
        when 2
          I18n.t('Sistema.Body.Controladores.DetalleReestructuracion.Mensajes.extension_periodo_muerto')
        when 3
          I18n.t('Sistema.Body.Controladores.DetalleReestructuracion.Mensajes.cambio_tasa')
      end
    else
      return I18n.t('Sistema.Body.Controladores.DetalleReestructuracion.Mensajes.no_aplica_abreviatura')
    end
  end
end

# == Schema Information
#
# Table name: detalle_reestructuracion
#
#  id                        :integer         not null, primary key
#  fecha                     :datetime        not null
#  estatus_id                :integer         not null
#  solicitud_id              :integer         not null
#  motivo                    :string(1)       not null
#  observaciones             :string(400)
#  causa_renuncia_id         :integer
#  causa_reestructuracion_id :integer
#  prestamo_id               :integer
#  numero_acta               :integer
#

