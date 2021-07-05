# encoding: utf-8

class SolicitudAvaluoPrenda < ActiveRecord::Base

  self.table_name = 'solicitud_avaluo_prenda'
  
  attr_accessible :id,
    :nombre_perito,
    :fecha_avaluo_prenda,
    :valor_avaluo_prenda,
    :tipo_documento,
    :referencia_documento,
    :fecha_documento,
    :empresa_documento,
    :rif_empresa_documento,
    :referencia_definitivo,
    :fecha_factura,
    :rif_empresa_difinitivo,
    :solicitud_avaluo_id,
    :empresa_factura,
    :numero_sudeban_prenda,
    :valor_avaluo_prenda_f,
    :fecha_avaluo_prenda_f,
    :fecha_documento_f,
    :fecha_factura_f,
    :tipo_documento_w

  
  belongs_to :solicitud_avaluo
  
  validates :solicitud_avaluo_id, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.SolicitudAvaluoMobiliario.Errores.solicitud_avaluo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :nombre_perito, :presence => {:if => Proc.new {|a| a.tipo_documento.nil? || a.tipo_documento == 'N'},
    :message => "#{I18n.t('Sistema.Body.Modelos.SolicitudAvaluo.Errores.nombre_perito')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :fecha_avaluo_prenda, :presence => {:if => Proc.new {|a| a.tipo_documento.nil? || a.tipo_documento == 'N'},
    :message => "#{I18n.t('Sistema.Body.Modelos.SolicitudAvaluoMobiliario.Errores.fecha_avaluo_mobiliario')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :valor_avaluo_prenda, :presence => {:if => Proc.new {|a| a.tipo_documento.nil? || a.tipo_documento == 'N'},
    :message => "#{I18n.t('Sistema.Body.Modelos.SolicitudAvaluoMobiliario.Errores.valor_avaluo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :numericality =>{:numericality => true, :only_integer=>false, :allow_nil => true, :message => "#{I18n.t('Sistema.Body.Modelos.SolicitudAvaluoMobiliario.Errores.valor_avaluo')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}" }

  validates :fecha_avaluo_prenda, :allow_nil => true,
    :date => {:message => "#{I18n.t('Sistema.Body.Modelos.SolicitudAvaluoMobiliario.Errores.valor_avaluo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalida')}",
    :before => Proc.new { 1.day.from_now.to_date }, :message => "#{I18n.t('Sistema.Body.Modelos.SolicitudAvaluoMobiliario.Errores.valor_avaluo')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_ser_posterior_fecha_actual')}"}

  validates :fecha_documento, :allow_nil => true,
    :date => {:message => "#{I18n.t('Sistema.Body.Modelos.SolicitudAvaluoMobiliario.Errores.fecha_documento')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalida')}",
    :before => Proc.new { 1.day.from_now.to_date }, :message => "#{I18n.t('Sistema.Body.Modelos.SolicitudAvaluoMobiliario.Errores.fecha_documento')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_ser_posterior_fecha_actual')}"}

  validates :fecha_factura, :allow_nil => true,
    :date => {:message => "#{I18n.t('Sistema.Body.Modelos.SolicitudAvaluoPrenda.Errores.fecha_factura_formato')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalida')}",
    :before => Proc.new { 1.day.from_now.to_date }, :message => "#{I18n.t('Sistema.Body.Modelos.SolicitudAvaluoPrenda.Errores.fecha_factura_formato')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_ser_posterior_fecha_actual')}"}


  validate :block_validate

  
  def block_validate
    unless self.valor_avaluo_prenda.nil?
      if self.valor_avaluo_prenda < 1
        errors.add(:solicitud_avaluo_prenda, "#{I18n.t('Sistema.Body.Modelos.SolicitudAvaluoMobiliario.Errores.valor_avaluo')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_mayor_cero')}")
      end
    end

    unless self.rif_empresa_documento.nil? || self.rif_empresa_documento.empty?
      if (self.rif_empresa_documento =~ /#{I18n.t('Sistema.Body.ExpresionesRegulares.validar_rif')}/).nil?
        errors.add(:solicitud_avaluo_prenda,I18n.t('Sistema.Body.Modelos.SolicitudAvaluoMobiliario.Errores.documento_oferta'))
      end
    end

    unless self.rif_empresa_difinitivo.nil? || self.rif_empresa_difinitivo.empty?
      if (self.rif_empresa_difinitivo =~ /#{I18n.t('Sistema.Body.ExpresionesRegulares.validar_rif')}/).nil?
        errors.add(:solicitud_avaluo_prenda,I18n.t('Sistema.Body.Modelos.SolicitudAvaluoMobiliario.Errores.documento_definitivo'))
      end
    end
  end

  def valor_avaluo_prenda_f=(valor)
    self.valor_avaluo_prenda = format_valor(valor)
  end
  
  def valor_avaluo_prenda_f
    format_f(self.valor_avaluo_prenda)
  end

  def fecha_avaluo_prenda_f=(fecha)
    self.fecha_avaluo_prenda = fecha
  end

  def fecha_avaluo_prenda_f
    format_fecha(self.fecha_avaluo_prenda)
  end

  def fecha_documento_f=(fecha)
    self.fecha_documento = fecha
  end

  def fecha_documento_f
    format_fecha(self.fecha_documento)
  end

  def fecha_factura_f=(fecha)
    self.fecha_factura = fecha
  end

  def fecha_factura_f
    format_fecha(self.fecha_factura)
  end

  def tipo_documento_w
    if self.tipo_documento == 'P'
      return 'Presupuesto'
    elsif self.tipo_documento == 'C'
      return 'Cotización'
    elsif self.tipo_documento == 'F'
      return 'Factura ProForma'
    elsif self.tipo_documento == 'N'
      return 'No Aplica'
    end
  end

end
# == Schema Information
#
# Table name: solicitud_avaluo_prenda
#
#  id                     :integer         not null, primary key
#  nombre_perito          :string(100)
#  fecha_avaluo_prenda    :date
#  valor_avaluo_prenda    :float
#  tipo_documento         :string(1)
#  referencia_documento   :string(20)
#  fecha_documento        :date
#  empresa_documento      :string(100)
#  rif_empresa_documento  :string(12)
#  referencia_definitivo  :string(20)
#  fecha_factura          :date
#  rif_empresa_difinitivo :string(12)
#  solicitud_avaluo_id    :integer         not null
#  empresa_factura        :string(100)
#  numero_sudeban_prenda  :string(20)
#

