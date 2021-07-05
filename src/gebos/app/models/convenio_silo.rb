# encoding: utf-8
class ConvenioSilo < ActiveRecord::Base
  
  self.table_name = 'convenio_silo'
  
  attr_accessible :id,
    :silo_id,
    :usuario_id,
    :ciclo_productivo_id,
    :numero_memorandum,
    :fecha_memorandum,
    :fecha_registro,
    :fecha_cierre,
    :observacion,
    :status,
    :fecha_memorandum_f, 
    :fecha_cierre_f


  belongs_to :silo
  belongs_to :ciclo_productivo
  has_many :detalle_convenioSilo

  
  validates :numero_memorandum, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.ConvenioSilo.Etiquetas.numero_memorandum')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :uniqueness =>{:uniqueness => true, :message => "#{I18n.t('Sistema.Body.Vistas.ConvenioSilo.Etiquetas.numero_memorandum')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"}

  validates :ciclo_productivo_id, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.ActaSilo.Etiquetas.ciclo_productivo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  
  validates :fecha_memorandum, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.ConvenioSilo.Etiquetas.fecha_memorandum')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalida')}"},
    :date => {:message => I18n.t('Sistema.Body.Modelos.Errores.fecha_invalida'),
    :before => Proc.new { 1.day.from_now.to_date }, :message => "#{I18n.t('Sistema.Body.Vistas.ConvenioSilo.Etiquetas.fecha_memorandum')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_ser_posterior_fecha_actual')}"}

      
  validates_uniqueness_of :numero_memorandum,
    :message => " ya existe"
  
  def fecha_memorandum_f=(fecha)
    self.fecha_memorandum = fecha
  end
  
  def fecha_memorandum_f
    format_fecha(self.fecha_memorandum)
  end
  
  validates :fecha_cierre, :allow_blank=>true,
    :date => {:message => "#{I18n.t('Sistema.Body.Vistas.ActaSilo.Etiquetas.fecha_cierre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalida')}",
    :before => Proc.new { 1.day.from_now.to_date }, :message => "#{I18n.t('Sistema.Body.Vistas.ConvenioSilo.Etiquetas.fecha_memorandum')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_ser_posterior_fecha_actual')}"}

  def fecha_cierre_f=(fecha)
    self.fecha_cierre = fecha
  end
  
  def fecha_cierre_f
    format_fecha(self.fecha_cierre)
  end
  
  validates :fecha_registro, :allow_blank=>true,
    :date => {:message => "#{I18n.t('Sistema.Body.Vistas.General.fecha_registro')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalida')}",
    :before => Proc.new {1.day.from_now.to_date }, :message => "#{I18n.t('Sistema.Body.Vistas.General.fecha_registro')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_ser_posterior_fecha_actual')}"}

  def fecha_registro_f=(fecha)
    self.fecha_registro = fecha
  end
  
  def fecha_registro_f
    format_fecha(self.fecha_registro)
  end

  def before_save
    unless (self.fecha_cierre.nil? || self.fecha_cierre.to_s.empty?)
      self.status = false
    end
    if (self.fecha_cierre.nil? || self.fecha_cierre.to_s.empty?)
      self.status = true
    end
    unless (self.fecha_cierre.nil? || self.fecha_cierre.to_s.empty?)
      unless self.fecha_cierre > self.fecha_memorandum
        errors.add(:convenio_silo, I18n.t('Sistema.Body.Vistas.ConvenioSilo.Etiquetas.fecha_cierre_no_posterior_o_igual_fecha_memorandum'))
        return false
      end
    end
          
  end

  def eliminar(id)
    begin
      convenio_silo = ConvenioSilo.find(id)
      transaction do
        convenio_silo.destroy
        return true
      end
    rescue
      errors.add(:convenio_silo, I18n.t('Sistema.Body.Modelos.Errores.item_utilizado'))
      return false
    end
  end
  
  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
      :conditions => search, :order => sort
  end
  
end




# == Schema Information
#
# Table name: convenio_silo
#
#  id                  :integer         not null, primary key
#  silo_id             :integer         not null
#  usuario_id          :integer         not null
#  ciclo_productivo_id :integer         not null
#  numero_memorandum   :string(25)      not null
#  fecha_memorandum    :date
#  fecha_registro      :date
#  fecha_cierre        :date
#  observacion         :text
#  status              :boolean
#

