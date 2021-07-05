# encoding: utf-8

class SolicitudAvaluoPrendaSemoviente < ActiveRecord::Base

  self.table_name = 'solicitud_avaluo_prenda_semoviente'
  
  attr_accessible :id,
    :tipos_semovientes_id,
    :cantidad,
    :peso,
    :monto,
    :solicitud_tipo_garantia_id,
    :raza,
    :edad,
    :unidad_edad,
    :monto_f

  
  belongs_to :solicitud_tipo_garantia
  belongs_to :tipos_semovientes
  
  validates :solicitud_tipo_garantia_id, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.SolicitudTipoGarantia.Errores.solicitud_tipo_garantia')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :tipos_semovientes_id, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.SolicitudAvaluoPrendaSemoviente.Errores.tipo_semoviente')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}  

  validates :cantidad, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.cantidad')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :numericality =>{:numericality => true, :only_integer=>true, :allow_nil => true, :message => "#{I18n.t('Sistema.Body.Vistas.General.cantidad')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}" }

  validates :peso, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.peso')} #{I18n.t('Sistema.Body.Vistas.General.unitario')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :numericality =>{:numericality => true, :only_integer=>true, :allow_nil => true, :message => "#{I18n.t('Sistema.Body.Vistas.General.peso')} #{I18n.t('Sistema.Body.Vistas.General.unitario')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}" }
  
  validates :raza, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.raza')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}  

  validates :monto, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.monto')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :numericality =>{:numericality => true, :only_integer=>true, :allow_nil => true, :message => "#{I18n.t('Sistema.Body.Vistas.General.monto')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}" }

  validates :edad, :numericality =>{:numericality => true, :only_integer=>true, :allow_blank=>true, 
    :message => "#{I18n.t('Sistema.Body.Vistas.General.edad')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}"}



  def validate
    unless self.peso.nil?
      if self.peso < 1
        errors.add(:solicitud_avaluo_prenda_semoviente, "#{I18n.t('Sistema.Body.Vistas.General.peso')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_mayor_cero')}")
      end
    end

    unless self.cantidad.nil?
      if self.cantidad < 1
        errors.add(:solicitud_avaluo_prenda_semoviente, "#{I18n.t('Sistema.Body.Vistas.General.cantidad')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_mayor_cero')}")
      end
    end

    unless self.edad.nil?
      if self.edad < 1
        errors.add(:solicitud_avaluo_prenda_semoviente, "#{I18n.t('Sistema.Body.Vistas.General.edad')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_mayor_cero')}")
      end
    end

    unless self.monto.nil?
      if self.monto < 1
        errors.add(:solicitud_avaluo_prenda_semoviente, "#{I18n.t('Sistema.Body.Vistas.General.monto')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_mayor_cero')}")
      end
    end
  end

  def monto_f=(valor)
    self.monto = format_valor(valor)
  end
  
  def monto_f
    format_f(self.monto)
  end

  def self.create_new(parametros, id)
    solicitud_avaluo_prenda_semoviente = SolicitudAvaluoPrendaSemoviente.new(parametros)
    solicitud_avaluo_prenda_semoviente.solicitud_tipo_garantia_id = id
    if solicitud_avaluo_prenda_semoviente.save
      return true
    else
      errores = ''
      solicitud_avaluo_prenda_semoviente.errors.full_messages.each { |e|
        errores << "<li>" + e + "</li>"
      }
      return errores
    end
  end

  def self.delete_registro(id)
    solicitud_avaluo_prenda_semoviente = SolicitudAvaluoPrendaSemoviente.find(id)
    solicitud_avaluo_prenda_semoviente.destroy
    return true
  end

end
# == Schema Information
#
# Table name: solicitud_avaluo_prenda_semoviente
#
#  id                         :integer         not null, primary key
#  tipos_semovientes_id       :integer         not null
#  cantidad                   :integer         default(1)
#  peso                       :integer         not null
#  monto                      :float           not null
#  solicitud_tipo_garantia_id :integer         not null
#  raza                       :string(50)
#  edad                       :integer
#  unidad_edad                :string(10)
#

