# encoding: utf-8

class SolicitudConstitucionGarantia < ActiveRecord::Base

  self.table_name = 'solicitud_constitucion_garantia'
  
  attr_accessible :id,
    :concepto,
    :monto,
    :validacion_futura,
    :fecha_futura,
    :fecha_auteticacion,
    :notaria,
    :direccion_notaria,
    :estado_id,
    :municipio_id,
    :fecha_protocolizacion,
    :registro,
    :direccion_registro,
    :tomo,
    :protocolo,
    :folio,
    :comentarios,
    :solicitud_tipo_garantia_id,
    :constituir,
    :etiqueta_tomo,
    :etiqueta_protocolo,
    :etiqueta_folio,
    :numero,
    :trimestre,
    :numero_autenticacion,
    :folio_autenticacion,
    :tomo_autenticacion,
    :observacion,
    :observacion_autenticacion,
    :monto_f,
    :fecha_futura_f,
    :fecha_auteticacion_f,
    :fecha_protocolizacion_f
    

  
  belongs_to :solicitud_tipo_garantia
  belongs_to :estado
  belongs_to :municipio

  
  validates :solicitud_tipo_garantia_id, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.SolicitudTipoGarantia.Errores.solicitud_tipo_garantia')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :concepto, :presence => {
    :message => "#{I18n.t('Sistema.Body.General.concepto')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :monto, :numericality =>{:numericality => true, :only_integer => false, :allow_blank=>true, 
    :message => "#{I18n.t('Sistema.Body.Vistas.General.monto')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}"}
 
  validates :fecha_futura, :allow_blank => true,
    :date => {:message => "#{I18n.t('Sistema.Body.Modelos.SolicitudConstitucionGarantia.Errores.fecha_futura')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalida')}"}
    #:before => Proc.new { 0 }, :message => I18n.t('Sistema.Body.Modelos.SolicitudConstitucionGarantia.Errores.fecha_constitucion_debe_ser_posterior')}

  validates :fecha_auteticacion, :allow_blank => true,
    :date => {:message => "#{I18n.t('Sistema.Body.Modelos.SolicitudConstitucionGarantia.Errores.fecha_autenticacion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalida')}",
    :before => Proc.new { 1.day.from_now.to_date }, :message => I18n.t('Sistema.Body.Modelos.SolicitudConstitucionGarantia.Errores.fecha_autenticacion_no_debe_ser_posterior')}

  validates :fecha_protocolizacion, :allow_blank => true,
    :date => {:message => "#{I18n.t('Sistema.Body.Modelos.SolicitudConstitucionGarantia.Errores.fecha_protocolizacion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalida')}",
    :before => Proc.new { 1.day.from_now.to_date }, :message => I18n.t('Sistema.Body.Modelos.SolicitudConstitucionGarantia.Errores.fecha_protocolizacion_no_debe_ser_posterior')}

  
  

  

  def monto_f=(valor)
    self.monto = format_valor(valor)
  end

  def monto_f
    format_f(self.monto)
  end

  def fecha_futura_f=(fecha)
    self.fecha_futura = fecha
  end

  def fecha_futura_f
    format_fecha(self.fecha_futura)
  end

  def fecha_auteticacion_f=(fecha)
    self.fecha_auteticacion = fecha
  end

  def fecha_auteticacion_f
    format_fecha(self.fecha_auteticacion)
  end

  def fecha_protocolizacion_f=(fecha)
    self.fecha_protocolizacion = fecha
  end

  def fecha_protocolizacion_f
    format_fecha(self.fecha_protocolizacion)
  end

  def self.crear_registro(parametros, solicitud_tipo_garantia_id)
    solicitud_constitucion_garantia = SolicitudConstitucionGarantia.new(parametros)
    solicitud_constitucion_garantia.solicitud_tipo_garantia_id = solicitud_tipo_garantia_id
    if solicitud_constitucion_garantia.save
      return true
    else
      errores = ''
      solicitud_constitucion_garantia.errors.full_messages.each { |e|
        errores << "<li>" + e + "</li>"
      }
      return errores
    end
  end

  def self.editar_registro(parametros, id)
    solicitud_constitucion_garantia = SolicitudConstitucionGarantia.find(:first, :conditions=>['solicitud_tipo_garantia_id = ?',id])
    if solicitud_constitucion_garantia.update_attributes(parametros)
      return true
    else
      errores = ''
      solicitud_constitucion_garantia.errors.full_messages.each { |e|
        errores << "<li>" + e + "</li>"
      }
      return errores
    end
  end

  def self.validar_constituir(id)
    if SolicitudAvaluo.count(:conditions=>['solicitud_tipo_garantia_id = ?', id]) > 0
      return true
    else
      return false
    end
  end
  
end
# == Schema Information
#
# Table name: solicitud_constitucion_garantia
#
#  id                         :integer         not null, primary key
#  concepto                   :string(100)
#  monto                      :float
#  validacion_futura          :boolean
#  fecha_futura               :date
#  fecha_auteticacion         :date
#  notaria                    :string(100)
#  direccion_notaria          :string(250)
#  estado_id                  :integer
#  municipio_id               :integer
#  fecha_protocolizacion      :date
#  registro                   :string(500)
#  direccion_registro         :string(250)
#  tomo                       :string(10)
#  protocolo                  :string(10)
#  folio                      :string(10)
#  comentarios                :string(1000)
#  solicitud_tipo_garantia_id :integer
#  constituir                 :boolean         default(FALSE)
#  etiqueta_tomo              :string(30)
#  etiqueta_protocolo         :string(30)
#  etiqueta_folio             :string(30)
#  numero                     :string(10)
#  trimestre                  :integer
#  numero_autenticacion       :string(10)
#  folio_autenticacion        :string          default("10")
#  tomo_autenticacion         :string
#  observacion                :string(1000)
#  observacion_autenticacion  :string(1000)
#

