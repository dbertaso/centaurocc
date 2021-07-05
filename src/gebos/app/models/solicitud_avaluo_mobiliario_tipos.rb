# encoding: utf-8

class SolicitudAvaluoMobiliarioTipos < ActiveRecord::Base
  
  self.table_name = 'solicitud_avaluo_mobiliario_tipos'
  
  attr_accessible :id,
    :tipo,
    :modelo,
    :marca,
    :serial,
    :hipoteca,
    :ubicacion,
    :solicitud_tipo_garantia_id,
    :hipoteca_f

  belongs_to :solicitud_tipo_garantia
  
  validates :solicitud_tipo_garantia_id, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.SolicitudTipoGarantia.Errores.solicitud_tipo_garantia')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :marca, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.marca')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :modelo, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.modelo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :tipo, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.tipo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :serial, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.serial')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :hipoteca, :numericality =>{:numericality => true, :only_integer=>false, :allow_blank=>true, 
    :message => "#{I18n.t('Sistema.Body.Vistas.General.hipoteca')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}"}

validate :block_validate
  
  def block_validate
    unless self.hipoteca.nil?
      if self.hipoteca < 1
        errors.add(:solicitud_avaluo_mobiliario_tipos, "#{I18n.t('Sistema.Body.Vistas.General.hipoteca')} #{I18n.t('Sistema.Body.Modelos.General.debe_ser_mayor_cero')}")
      end
    end
  end

  def hipoteca_f=(valor)
    self.hipoteca = format_valor(valor)
  end

  def hipoteca_f
    format_f(self.hipoteca)
  end

  def self.create_new(parametros, solicitud_tipo_garantia_id)
    solicitud_avaluo_mobiliario_tipos = SolicitudAvaluoMobiliarioTipos.new(parametros)
    solicitud_avaluo_mobiliario_tipos.solicitud_tipo_garantia_id = solicitud_tipo_garantia_id
    if solicitud_avaluo_mobiliario_tipos.save
      return true
    else
      errores = ''
      solicitud_avaluo_mobiliario_tipos.errors.full_messages.each { |e|
        errores << "<li>" + e + "</li>"
      }
      return errores
    end
  end

  def self.delete_registro(id)
    solicitud_avaluo_mobiliario_tipos = SolicitudAvaluoMobiliarioTipos.find(id)
    solicitud_avaluo_mobiliario_tipos.destroy
    return true
  end

end
# == Schema Information
#
# Table name: solicitud_avaluo_mobiliario_tipos
#
#  id                         :integer         not null, primary key
#  tipo                       :string(50)
#  modelo                     :string(50)
#  marca                      :string(50)
#  serial                     :string(30)
#  hipoteca                   :float
#  ubicacion                  :string(1)       not null
#  solicitud_tipo_garantia_id :integer         not null
#

