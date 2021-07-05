# encoding: utf-8
class DesvioSilo < ActiveRecord::Base

  self.table_name = 'desvio_silo'
  
  attr_accessible   :id,
    :solicitud_id,
    :silo_origen_id,
    :silo_destino_id,
    :cliente_id,
    :actividad_id,
    :hora_desvio,
    :placa_vehiculo,
    :letra_cedula_conductor,
    :cedula_conductor,
    :nombre_conductor,
    :guia_movilizacion,
    :numero_acta_desvio,
    :causa_desvio,
    :fecha_desvio,
    :usuario_id,
    :fecha_desvio_f,
    :hora_desvio_f,
    :nombre
  
  
  belongs_to :solicitud
  belongs_to :silo_origen, :class_name=>'Silo', :foreign_key =>'silo_origen_id'
  belongs_to :silo_destino, :class_name=>'Silo', :foreign_key =>'silo_destino_id'
  belongs_to :actividad
  belongs_to :cliente
  #belongs_to :silo
  #belongs_to :usuario


  validates :nombre_conductor, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Vistas.General.conductor')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :length => { :in => 3..100, :allow_blank => false,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.nombre')}  #{I18n.t('errors.messages.too_long.other')}"}
  
  validates :silo_origen_id, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.Form.silo')} #{I18n.t('Sistema.Body.Vistas.General.origen')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :silo_destino_id, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.Form.silo')} #{I18n.t('Sistema.Body.Vistas.Form.destino')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :letra_cedula_conductor, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nacionalidad')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :cedula_conductor, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.cedula')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :numericality =>{:numericality => true, :only_integer=>true, :message => I18n.t('Sistema.Body.Modelos.Errores.cedula_sin_decimales') }

  validates :placa_vehiculo, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.TecnicoCampo.Etiquetas.placa_vehiculo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :length => { :in => 5..7, :allow_blank => false,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.TecnicoCampo.Etiquetas.placa_vehiculo')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.TecnicoCampo.Etiquetas.placa_vehiculo')}  #{I18n.t('errors.messages.too_long.other')}"}

  validates :numero_acta_desvio, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.ActaSilo.Etiquetas.numero_acta')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :guia_movilizacion, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletaArrime.Columnas.guia_movilizacion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :uniqueness =>{:uniqueness => true, :message => "#{I18n.t('Sistema.Body.Modelos.BoletaArrime.Columnas.guia_movilizacion')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"}

  validates :fecha_desvio, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletaArrime.Columnas.fecha_desvio')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :date => {:message => I18n.t('Sistema.Body.Modelos.Errores.fecha_invalida'),
    :before => Proc.new { 0.day.from_now.to_date }, :message => I18n.t('Sistema.Body.Modelos.BoletaArrime.Errores.fecha_desvio')}

  validates :causa_desvio, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletaArrime.Columnas.causa_desvio')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  

  def fecha_desvio_f=(fecha)
    self.fecha_desvio = fecha
  end

  def fecha_desvio_f
    self.fecha_desvio.strftime('%d-%m-%Y') unless self.fecha_desvio.nil?
  end
  
  def hora_desvio_f=(time)
    self.hora_desvio = time
  end

  def hora_desvio_f
    format_hora(self.hora_desvio)
  end

  before_save :antes_guardar
 
  def antes_guardar
    if self.id.nil?
      desvio_silo = DesvioSilo.find_by_numero_acta_desvio_and_silo_origen_id(self.numero_acta_desvio, self.silo_origen_id)
      unless desvio_silo.nil?
        errors.add(:desvio_silo, I18n.t('Sistema.Body.Modelos.BoletaArrime.Errores.nro_acta_desvio_existe'))
        return false
      end
    end
    unless self.id.nil?
      desvio_silo = DesvioSilo.count(:conditions=>["silo_origen_id = #{self.silo_origen_id} and numero_acta_desvio = '#{self.numero_acta_desvio}' and id <> #{self.id}"])
      if desvio_silo > 0
        errors.add(:desvio_silo, I18n.t('Sistema.Body.Modelos.BoletaArrime.Errores.nro_acta_desvio_existe'))
        return false
      end
    end
  end

  def nombre
    nombre_cliente = ViewBoletaArrime.find_by_solicitud_id(self.solicitud_id)
    nombre = nombre_cliente.productor
    return nombre
  end

  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
      :conditions => search, :order => sort,
      :select=>'*'
  end
  
end
# == Schema Information
#
# Table name: desvio_silo
#
#  id                     :integer         not null, primary key
#  solicitud_id           :integer         not null
#  silo_origen_id         :integer         not null
#  silo_destino_id        :integer         not null
#  cliente_id             :integer         not null
#  actividad_id           :integer         not null
#  hora_desvio            :time
#  placa_vehiculo         :string(15)      not null
#  letra_cedula_conductor :string(1)       not null
#  cedula_conductor       :integer         not null
#  nombre_conductor       :string(100)     not null
#  guia_movilizacion      :string(20)      not null
#  numero_acta_desvio     :string(20)      not null
#  causa_desvio           :text
#  fecha_desvio           :date            not null
#  usuario_id             :integer
#

