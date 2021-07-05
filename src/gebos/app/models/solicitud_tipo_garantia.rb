# encoding: utf-8

class SolicitudTipoGarantia < ActiveRecord::Base
  
  self.table_name = 'solicitud_tipo_garantia'
  
  attr_accessible :id,
    :solicitud_id,
    :tipo_garantia_id,
    :estatus,
    :programa_tipo_garantia_id,
    :relacion_garantia,
    :estatus_w

  has_many :solicitud_avaluo
  has_many :solicitud_avaluo_imagen
  has_many :solicitud_avaluo_prenda_semoviente
  has_many :solicitud_avaluo_mobiliario_tipos

  belongs_to :solicitud
  belongs_to :tipo_garantia
  
  validates :solicitud_id, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.Form.solicitud')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :programa_tipo_garantia_id, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.SolicitudTipoGarantia.Errores.tipo_garantia')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  
  def self.crear_registro(dato, solicitud_id)
    solicitud_tipo_garantia = SolicitudTipoGarantia.new()
    programa_tipo_garantia = ProgramaTipoGarantia.find(dato[0])
    solicitud_tipo_garantia.programa_tipo_garantia_id = programa_tipo_garantia.id
    solicitud_tipo_garantia.tipo_garantia_id = programa_tipo_garantia.tipo_garantia_id
    solicitud_tipo_garantia.relacion_garantia = dato[1]
    solicitud_tipo_garantia.solicitud_id = solicitud_id
    #    solicitud_tipo_garantia = SolicitudTipoGarantia.new(programa_tipo_garantia_id, relacion_garantia, solicitud_id)
    logger.info"XXXXXXX==========================>>>>"<<solicitud_tipo_garantia.inspect
    #solicitud_tipo_garantia.solicitud_id = solicitud_id
    if solicitud_tipo_garantia.save
      return true
    else
      errores = ''
      solicitud_tipo_garantia.errors.full_messages.each { |e|
        errores << "<li>" + e + "</li>"
      }
      return errores
    end
  end

  def estatus_w
    if self.estatus == 'P'
      return 'Por Constituir'
    elsif self.estatus == 'C'
      return 'Constituida'
    elsif self.estatus == 'D'
      return 'Eliminada'
    end
  end

  def constituir
    solicitud_tipo_garantia = SolicitudTipoGarantia.find(self.id)
    unless SolicitudConstitucionGarantia.count(:conditions=>['solicitud_tipo_garantia_id = ?', self.id]) > 0
      #errores << "<li> #{I18n.t('Sistema.Body.Modelos.SolicitudTipoGarantia.Errores.completar_informacion_constitucion_garantia')} </li>"
      errors.add(:solicitud_tipo_garantia, I18n.t('Sistema.Body.Modelos.SolicitudTipoGarantia.Errores.completar_informacion_constitucion_garantia'))
    else
      solicitud_constitucion_garantia = SolicitudConstitucionGarantia.find(:first, :conditions=>['solicitud_tipo_garantia_id = ?', self.id])
      if solicitud_constitucion_garantia.fecha_protocolizacion.nil? || solicitud_constitucion_garantia.fecha_protocolizacion.to_s.empty?
        #errores << "<li>#{I18n.t('Sistema.Body.Modelos.SolicitudTipoGarantia.Errores.protocolizacion_fecha_requerida')}"
        errors.add(:solicitud_tipo_garantia, I18n.t('Sistema.Body.Modelos.SolicitudTipoGarantia.Errores.protocolizacion_fecha_requerida'))
      end
      if solicitud_constitucion_garantia.registro.nil? || solicitud_constitucion_garantia.registro.empty?
        #errores << "<li>#{I18n.t('Sistema.Body.Modelos.SolicitudTipoGarantia.Errores.protocolizacion_registro_requerida')}"
        errors.add(:solicitud_tipo_garantia, I18n.t('Sistema.Body.Modelos.SolicitudTipoGarantia.Errores.protocolizacion_registro_requerida'))
      end
      if solicitud_constitucion_garantia.numero.nil? || solicitud_constitucion_garantia.numero.empty?
        #errores << "<li>#{I18n.t('Sistema.Body.Modelos.SolicitudTipoGarantia.Errores.protocolizacion_numero_requerido')}"
        errors.add(:solicitud_tipo_garantia, I18n.t('Sistema.Body.Modelos.SolicitudTipoGarantia.Errores.protocolizacion_numero_requerido'))
      end
      if solicitud_constitucion_garantia.tomo.nil? || solicitud_constitucion_garantia.tomo.empty?
        #errores << "<li>#{I18n.t('Sistema.Body.Modelos.SolicitudTipoGarantia.Errores.protocolizacion_tomo_requerido')}"
        errors.add(:solicitud_tipo_garantia, I18n.t('Sistema.Body.Modelos.SolicitudTipoGarantia.Errores.protocolizacion_tomo_requerido'))
      end
      if solicitud_constitucion_garantia.protocolo.nil? || solicitud_constitucion_garantia.protocolo.empty?
        #errores << "<li>#{I18n.t('Sistema.Body.Modelos.SolicitudTipoGarantia.Errores.protocolizacion_protocolo_requerido')}"
        errors.add(:solicitud_tipo_garantia, I18n.t('Sistema.Body.Modelos.SolicitudTipoGarantia.Errores.protocolizacion_protocolo_requerido'))
      end
      #solicitud_tipo_garantia = SolicitudTipoGarantia.find(self.id)
      logger.info"XXXXXXX=============id=========>>>>"<<solicitud_tipo_garantia.errors.inspect
      solicitud_avaluo = SolicitudAvaluo.find(:first, :conditions=>"solicitud_tipo_garantia_id = #{solicitud_tipo_garantia.id} and estatus = 'V'")
      solicitud = Solicitud.find(solicitud_tipo_garantia.solicitud_id)
      monto = (solicitud_tipo_garantia.relacion_garantia * solicitud.monto_solicitado)
      if solicitud_tipo_garantia.tipo_garantia.tipo == "M"
        solicitud_avaluo_mobiliario = SolicitudAvaluoMobiliario.find(:first, :conditions=>"solicitud_avaluo_id = #{solicitud_avaluo.id}")
        valor_avaluo = solicitud_avaluo_mobiliario.valor_avaluo_mobiliario
      elsif solicitud_tipo_garantia.tipo_garantia.tipo == "I"
        solicitud_avaluo_inmobiliario = SolicitudAvaluoInmobiliario.find(:first, :conditions=>"solicitud_avaluo_id = #{solicitud_avaluo.id}")
        valor_avaluo = solicitud_avaluo_inmobiliario.valor_avaluo_inmobiliario
      elsif solicitud_tipo_garantia.tipo_garantia.tipo == "P"
        solicitud_avaluo_prenda = SolicitudAvaluoPrenda.find(:first, :conditions=>"solicitud_avaluo_id = #{solicitud_avaluo.id}")
        valor_avaluo = solicitud_avaluo_prenda.valor_avaluo_prenda
      elsif solicitud_tipo_garantia.tipo_garantia.tipo == "F"
#        solicitud_avaluo_fianza = SolicitudAvaluoFianza.find(:first, :conditions=>"solicitud_avaluo_id = #{solicitud_avaluo.id}")
        valor_avaluo = monto.to_f
      end
      if valor_avaluo.to_f < monto.to_f
        errors.add(:solicitud_tipo_garantia, "El Valor de avaluo no puede ser Menor al monto de la garantia")
      end
    end
    logger.info"XXXXXXX=========================>>>>>"<<solicitud_tipo_garantia.errors.inspect
    return solicitud_tipo_garantia
  end

  def self.get_valor(id)
    valori = SolicitudAvaluoInmobiliario.sum(:valor_avaluo_inmobiliario, :conditions=>['solicitud_avaluo_id in (select id from solicitud_avaluo where solicitud_id = ?)', id])
    valorm = SolicitudAvaluoMobiliario.sum(:valor_avaluo_mobiliario, :conditions=>['solicitud_avaluo_id in (select id from solicitud_avaluo where solicitud_id = ?)', id])
    valorp = SolicitudAvaluoPrenda.sum(:valor_avaluo_prenda, :conditions=>['solicitud_avaluo_id in (select id from solicitud_avaluo where solicitud_id = ?)', id])
    valorf = SolicitudAvaluo.sum(:valor_avaluo, :conditions=>["solicitud_id = ? and solicitud_tipo_garantia_id in (select id from solicitud_tipo_garantia where tipo_garantia_id in (select id from tipo_garantia where tipo = 'F'))", id])
    valor_total = 0.0
    unless valori.nil?
      valor_total += valori
    end
    unless valorm.nil?
      valor_total += valorm
    end
    unless valorp.nil?
      valor_total += valorp
    end
    unless valorf.nil?
      valor_total += valorf
    end
    if valor_total > 0
      solicitud = Solicitud.find(id)
      return [valor_total / solicitud.monto_solicitado, valor_total]
    end
  end

  def self.validar_garantia(id)
    solicitud_tipo_garantia = SolicitudTipoGarantia.find(id)
    unless SolicitudAvaluo.count(:conditions=>['solicitud_id = ? and solicitud_tipo_garantia_id = ?', solicitud_tipo_garantia.solicitud_id, solicitud_tipo_garantia.id]) > 0
      return false
    end
    solicitud_avaluo = SolicitudAvaluo.find(:first, :conditions=>['solicitud_id = ? and solicitud_tipo_garantia_id = ?', solicitud_tipo_garantia.solicitud_id, solicitud_tipo_garantia.id])
    if solicitud_tipo_garantia.tipo_garantia.tipo == "M"
      unless SolicitudAvaluoMobiliario.count(:conditions=>['solicitud_avaluo_id = ? ', solicitud_avaluo.id]) > 0
        return false
      end
    elsif solicitud_tipo_garantia.tipo_garantia.tipo == "I"
      unless SolicitudAvaluoInmobiliario.count(:conditions=>['solicitud_avaluo_id = ? ', solicitud_avaluo.id]) > 0
        return false
      end
    elsif solicitud_tipo_garantia.tipo_garantia.tipo == 'P'
      unless SolicitudAvaluoPrenda.count(:conditions=>['solicitud_avaluo_id = ? ', solicitud_avaluo.id]) > 0
        return false
      end
    elsif solicitud_tipo_garantia.tipo_garantia.tipo == 'F'
      unless SolicitudAvaluoFianza.count(:conditions=>['solicitud_avaluo_id = ? ', solicitud_avaluo.id]) > 0
        return false
      end
    end
    return true
  end
  
  def self.indice_garantia(relacion, monto)
    valor = 0.0.to_d
    valor = (relacion * monto)
    return valor
  end

end
# == Schema Information
#
# Table name: solicitud_tipo_garantia
#
#  id                        :integer         not null, primary key
#  solicitud_id              :integer         not null
#  tipo_garantia_id          :integer
#  estatus                   :string(1)       default("P")
#  comentario                :text
#  relacion_garantia         :float           default(0.0)
#  programa_tipo_garantia_id :integer
#

