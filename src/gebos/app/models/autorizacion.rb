# encoding: utf-8
class Autorizacion < ActiveRecord::Base
  
  self.table_name = 'autorizacion'
  
  attr_accessible  :id,
    :usuario_id,
    :creacion,
    :vencimiento,
    :estatus,
    :descripcion,
    :opcion_accion_id,
    :referencia_id,
    :usuario_aprobo_id,
    :observaciones,
    :monto,
    :prestamo_numero,
    :monto_f,
    :creacion_f,
    :vencimiento_f
  
  
  belongs_to :usuario
  belongs_to :usuario_aprobo, :class_name=>"Usuario"
  belongs_to :opcion_accion
  
  validates :usuario, :presence => {
    :message => "#{I18n.t('Sistema.Body.Controladores.Usuario.FormTitles.form_title_record')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :opcion_accion, :presence => {
    :message => "#{I18n.t('Sistema.Body.Controladores.OpcionAccionAutorizacion.FormTitles.form_title_record')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :estatus, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.Form.estatus')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  def creacion_f=(creacion)
    self.creacion = creacion
  end

  def creacion_f
    self.creacion.strftime(I18n.t('time.formats.gebos_large')) unless self.creacion.nil?
  end
  
  def vencimiento_f=(vencimiento)
    self.vencimiento = vencimiento
  end

  def vencimiento_f
    self.vencimiento.strftime(I18n.t('time.formats.gebos_large')) unless self.vencimiento.nil?
  end

  after_initialize :inicializar
  before_create :crear_varios
  

  #  def after_initialize
  def inicializar
    self.monto = 0.0 unless self.monto
    self.prestamo_numero = 0 unless self.prestamo_numero
    self.referencia_id = 0 unless self.referencia_id
  end    
    
  def crear_varios
    self.estatus = 'E'
    self.creacion = Time.now
    segundos = 0
    case self.opcion_accion.autorizacion_tiempo_tipo
    when 'M'
      segundos = self.opcion_accion.autorizacion_tiempo * 60
    when 'H'
      segundos = self.opcion_accion.autorizacion_tiempo * 60 * 60
    when 'D'
      segundos = self.opcion_accion.autorizacion_tiempo * 60 * 60 * 24
    end
    self.vencimiento = Time.now + segundos
  end
 
  def monto_f=(valor)
    self.monto = valor.sub(',', '.')
  end
    
  def monto_f
    sprintf('%01.2f', self.monto).sub('.', ',') unless self.monto.nil?
  end
    
  def monto_fm
    unless self.monto.nil?
      valor = sprintf('%01.2f', self.monto).sub('.', ',')
      valor.to_s.gsub(/#{I18n.t('Sistema.Body.General.ExpresionesRegulares.gsub')}/, "\\1.")
    end
  end
 
  def vencida
    Time.now > self.vencimiento
  end
 
  def para_aprobar
    self.estatus == 'E' && !self.vencida
  end
    
  def estatus_w
    case self.estatus
    when 'E'
      return I18n.t('Sistema.Body.Modelos.PrecioGaceta.Estatus.vencida') if vencida 
      return I18n.t('Sistema.Body.General.espera')
    when 'A'
      return I18n.t('Sistema.Body.General.aprobado')
    when 'R'
      return I18n.t('Sistema.Body.General.rechazado')
    when 'V'
      return I18n.t('Sistema.Body.Modelos.PrecioGaceta.Estatus.vencida')
    end
  end
  
  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
      :conditions => search, :order => sort
  end
  
end



# == Schema Information
#
# Table name: autorizacion
#
#  id                :integer         not null, primary key
#  usuario_id        :integer
#  creacion          :datetime
#  vencimiento       :datetime
#  estatus           :string(1)       default("E")
#  descripcion       :string(300)
#  opcion_accion_id  :integer
#  referencia_id     :integer
#  usuario_aprobo_id :integer
#  observaciones     :string(300)
#  monto             :float
#  prestamo_numero   :integer
#

