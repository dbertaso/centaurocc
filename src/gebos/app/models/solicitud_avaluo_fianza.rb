# encoding: utf-8

class SolicitudAvaluoFianza < ActiveRecord::Base

  self.table_name = 'solicitud_avaluo_fianza'
  
  attr_accessible :id,
  :cedula,
  :nombre,
  :nacionalidad_id,
  :estado_civil,
  :domicilio,
  :estado_id,
  :cedula_conyugue,
  :nombre_conyugue,
  :nacionalidad_conyugue_id,
  :estado_civil_conyugue,
  :domicilio_conyugue,
  :estado_conyugue_id,
  :solicitud_avaluo_id,
  :estado_civil_w,
  :estado_civil_conyugue_w,
  :nacionalidad,
  :estado,
  :estado_civil_w,
  :estado_civil_conyugue_w

  
  belongs_to :solicitud_avaluo
  
  
  validates :solicitud_avaluo_id, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.SolicitudAvaluoMobiliario.Errores.solicitud_avaluo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :cedula, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.cedula')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :numericality =>{:numericality => true, :message => I18n.t('Sistema.Body.Modelos.Errores.cedula_sin_decimales') }
#    :format =>{:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.validar_rif')}/, :allow_blank =>true,
#      :message => "#{I18n.t('Sistema.Body.Vistas.General.cedula')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalido')}"}
    
  validates :cedula_conyugue, :numericality =>{:numericality => true, :only_integer => true, :allow_blank => true,
    :message => I18n.t('Sistema.Body.Modelos.Errores.cedula_sin_decimales')}
#    :format =>{:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.validar_rif')}/, :allow_blank =>true,
#      :message => "#{I18n.t('Sistema.Body.Modelos.SolicitudAvaluoFianza.Errores.informacion_conyugue_cedula')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalido')}"}
  
validates :nombre, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :length => { :in => 3..100, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.nombre')}  #{I18n.t('errors.messages.too_long.other')}"},
    :format =>{:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.validar_nombre')}/, :allow_blank =>true, 
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalido')}"}
  


validate :validate

  def validate
    unless self.cedula.nil?
      if self.cedula < 1
        errors.add(:solicitud_avaluo_fianza, "#{I18n.t('Sistema.Body.Vistas.General.cedula')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_mayor_cero')}")
      end
    end

    unless self.cedula_conyugue.nil?
      if self.cedula_conyugue < 1
        errors.add(nil, "#{I18n.t('Sistema.Body.Modelos.SolicitudAvaluoFianza.Errores.informacion_conyugue_cedula')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_mayor_cero')}")
      end
    end
  end

  def estado_civil_w
    if self.estado_civil == 'S'
      return 'Soltero'
    elsif self.estado_civil == 'C'
      return 'Casado'
    elsif self.estado_civil == 'O'
      return 'Concubino'
    elsif self.estado_civil == 'V'
      return 'Viudo'
    elsif self.estado_civil == 'D'
      return 'Divorciado'
    end
  end

  def estado_civil_conyugue_w
    if self.estado_civil_conyugue == 'S'
      return 'Soltero'
    elsif self.estado_civil_conyugue == 'C'
      return 'Casado'
    elsif self.estado_civil_conyugue == 'O'
      return 'Concubino'
    elsif self.estado_civil_conyugue == 'V'
      return 'Viudo'
    elsif self.estado_civil_conyugue == 'D'
      return 'Divorciado'
    end
  end

  def self.nacionalidad(id)
    unless id.nil? && id.to_s.length < 1
      nacionalidad = Nacionalidad.find(id)
      return nacionalidad.masculino
    end
  end

  def self.estado(id)
    unless id.nil? && id.to_s.length < 1
      estado = Estado.find(id)
      return estado.nombre
    end
  end

end
# == Schema Information
#
# Table name: solicitud_avaluo_fianza
#
#  id                       :integer         not null, primary key
#  cedula                   :integer         not null
#  nombre                   :string(100)     not null
#  nacionalidad_id          :integer
#  estado_civil             :string(1)
#  domicilio                :string(500)
#  estado_id                :integer
#  cedula_conyugue          :integer
#  nombre_conyugue          :string(100)
#  nacionalidad_conyugue_id :integer
#  estado_civil_conyugue    :string(1)
#  domicilio_conyugue       :string(500)
#  estado_conyugue_id       :integer
#  solicitud_avaluo_id      :integer         not null
#

