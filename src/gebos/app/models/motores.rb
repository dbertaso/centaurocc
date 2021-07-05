# encoding: utf-8
class Motores < ActiveRecord::Base
 
  self.table_name = 'motores'
  
  attr_accessible :id,
    :modelo_motor,
    :numero_serial,
    :cantidad_motores,
    :ano,
    :proveedor_marino_id,
    :arte_pesca_id,
    :seguimiento_visita_id,
    :embarcacion_id,
    :potencia,
    :condicion,
    :observacion,
    :es_propio,
    :tipo_motor_id,
    :potencia_f
  
  belongs_to :embarcacion
  belongs_to :tipo_motor
  belongs_to :proveedor_marino

  
#  validates :es_propio, :inclusion =>{:in=>[true, false], 
#    :message => I18n.t('Sistema.Body.Modelos.Motores.Columnas.es_propio')}

  validates :modelo_motor, :length => { :in => 1..160, :allow_blank => false,
    :too_short => "#{I18n.t('Sistema.Body.Modelos.Motores.Columnas.modelo_motor')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Modelos.Motores.Columnas.modelo_motor')}  #{I18n.t('errors.messages.too_long.other')}"}

  validates :numero_serial, :length => { :in => 1..100, :allow_blank => false,
    :too_short => "#{I18n.t('Sistema.Body.Modelos.Motores.Columnas.numero_serial')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Modelos.Motores.Columnas.numero_serial')}  #{I18n.t('errors.messages.too_long.other')}"}

  validates :cantidad_motores, :numericality =>{:numericality => true, :only_integer =>true, 
    :message => "#{I18n.t('Sistema.Body.Modelos.Motores.Columnas.cantidad_motores')} #{I18n.t('errors.messages.not_a_number')}"}#,
#    :inclusion =>{:in=>1..100, :message => "#{I18n.t('Sistema.Body.Modelos.Motores.Columnas.cantidad_motores')} #{I18n.t('errors.messages.inclusion')}"}
  
  validates :ano, :numericality =>{:numericality => true, :only_integer =>true, 
    :message => "#{I18n.t('Sistema.Body.Modelos.Motores.Columnas.ano')} #{I18n.t('errors.messages.not_a_number')}"}#,
#    :inclusion =>{:in=>1850..3000, :message => "#{I18n.t('Sistema.Body.Modelos.Motores.Columnas.ano')} #{I18n.t('errors.messages.inclusion')}"}

  validates :potencia, :numericality =>{:numericality => true, :only_integer =>true, 
    :message => "#{I18n.t('Sistema.Body.Modelos.Motores.Columnas.potencia')} #{I18n.t('errors.messages.not_a_number')}"}#,
#    :inclusion =>{:in=>0..1000000, :message => "#{I18n.t('Sistema.Body.Modelos.Motores.Columnas.potencia')} #{I18n.t('errors.messages.inclusion')}"}

  validates :embarcacion_id, :presence => {
    :message => "#{I18n.t('Sistema.Body.Controladores.Embarcacion.FormTitles.form_title')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :proveedor_marino_id, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.Motores.Columnas.proveedor_marino')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :tipo_motor_id, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.tipo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  
  #ojo arreglar este validate, siempre se dispara
  validates :condicion, :length => { :in => 1..20, :allow_blank => false,
    :too_short => "#{I18n.t('Sistema.Body.Modelos.Embarcacion.Columnas.condicion')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Modelos.Embarcacion.Columnas.condicion')}  #{I18n.t('errors.messages.too_long.other')}"}

  validates :observacion, :length => { :in => 1..180, :allow_blank => false,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.observacion')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.observacion')}  #{I18n.t('errors.messages.too_long.other')}"}


  def potencia_f=(valor)
    self.potencia = format_valor(valor)
  end

  def potencia_f
    format_f(self.potencia)
  end


  before_create :before_create

  def before_create

    retorno = true
    
    sereales = Motores.find_by_numero_serial(self.numero_serial)
    
    unless sereales.nil?
      if sereales.numero_serial!="***No-aplica***"
        errors.add(:metores, I18n.t('Sistema.Body.Modelos.Motores.Errores.serial_motor'))
        retorno = false
      end
    end  
    
    return retorno
  end

  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
      :conditions => search, :order => sort, :select=>'*'
  end


end




# == Schema Information
#
# Table name: motores
#
#  id                    :integer         not null, primary key
#  modelo_motor          :string(160)     not null
#  numero_serial         :string(100)     not null
#  cantidad_motores      :integer
#  ano                   :integer
#  proveedor_marino_id   :integer
#  tipo_motor_id         :integer
#  seguimiento_visita_id :integer
#  embarcacion_id        :integer
#  potencia              :float
#  condicion             :string(20)
#  observacion           :string(180)
#  es_propio             :boolean
#

