# encoding: utf-8
class ActaSilo < ActiveRecord::Base
  
  self.table_name = 'acta_silo'
    
  attr_accessible   :silo_id,
    :ciclo_productivo_id,
    :nro_acta,
    :fecha_inicio,
    :fecha_fin,
    :status,
    :actividad_id,
    :fecha_fin_f,
    :fecha_inicio_f
                      
  belongs_to :silo
  belongs_to :actividad
  belongs_to :ciclo_productivo

                  
  validates :fecha_inicio, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.Errores.fecha_inicio')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :actividad_id, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.Form.actividad')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :ciclo_productivo_id, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.ciclo')} #{I18n.t('Sistema.Body.Vistas.General.Productivo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  def fecha_inicio_f=(fecha)
    self.fecha_inicio = fecha
  end

  def fecha_inicio_f
    format_fecha(self.fecha_inicio)
  end

  def fecha_fin_f=(fecha)
    self.fecha_fin = fecha
  end

  def fecha_fin_f
    format_fecha(self.fecha_fin)
  end

  
  validates :fecha_inicio,
    :date => {:message =>"#{I18n.t('Sistema.Body.Vistas.ActaSilo.Etiquetas.fecha_inicio')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalida')}",
    :before => Proc.new { 1.day.from_now.to_date }, :message => I18n.t('Sistema.Body.Modelos.Errores.fecha_fin_no_posterior')}
            
  validates :fecha_fin, :allow_blank =>true,
    :date => {:message => "#{I18n.t('Sistema.Body.Vistas.ActaSilo.Etiquetas.fecha_cierre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalida')}",
    :before => Proc.new { 0.day.from_now.to_date }, :message => I18n.t('Sistema.Body.Modelos.Errores.fecha_fin_no_posterior')}
 
  before_save :before_save
  
  def before_save
    unless (self.fecha_fin.nil? || self.fecha_fin.to_s.empty?)
      self.status = false
    end
    
    if (self.fecha_fin.nil? || self.fecha_fin.to_s.empty?)
      self.status = true
    end
    
    unless (self.fecha_fin.nil? || self.fecha_fin.to_s.empty?)
      unless fecha_fin > fecha_inicio
        errors.add(:acta_silo, I18n.t('Sistema.Body.Modelos.ActaSilo.Errores.error_fecha_cierre_no_menor'))
        return false
      end
    end
    
    if self.id.nil?
      count = ActaSilo.count(:conditions=>"silo_id = #{self.silo_id} and actividad_id = #{self.actividad_id} and status = true and ciclo_productivo_id = #{self.ciclo_productivo_id}")
      unless count == 0
        errors.add(:acta_silo, I18n.t('Sistema.Body.Modelos.ActaSilo.Errores.ya_existe_acta_abierta_para_rubro'))
        return false
      end
    else
      count = ActaSilo.count(:conditions=>"silo_id = #{self.silo_id} and actividad_id = #{self.actividad_id} and status = true and ciclo_productivo_id = #{self.ciclo_productivo_id} and id <> #{self.id}")
      unless count == 0
        errors.add(:acta_silo, I18n.t('Sistema.Body.Modelos.ActaSilo.Errores.ya_existe_acta_abierta_para_rubro'))
        return false
      end
    end
  end

  after_save :after_save

  def after_save
   if self.nro_acta.nil? || self.nro_acta.to_s.empty?
      silo = Silo.find_by_id(self.silo_id)
      nro_acta = (silo.nro_acta) + 1
      rif = silo.rif
      riff = rif.to_s.split('-')
      rif_1 = riff[0]
      rif_2 = riff[1]
      rif_3 = riff[2]
      silo.update_attributes(:nro_acta=>nro_acta,:rif=>silo.rif, :rif_1=>rif_1, :rif_2=>rif_2, :rif_3=>rif_3)
      self.nro_acta = nro_acta
      self.save
    end
  end

  def nombre
    silo = Silo.find_by_id(self.silo_id)
    nombre = silo.nombre
    return nombre
  end

  def eliminar(id)
    begin
      acta_silo = ActaSilo.find(id)
      transaction do
        acta_silo.destroy
        return true
      end
    rescue
      errors.add(:acta_silo, I18n.t('Sistema.Body.Modelos.ActaSilo.Errores.acta_silo_no_puede_ser_eliminada'))
      return false
    end
  end
  
  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
      :conditions => search, :order => sort,
      :select=>'acta_silo.*',
      :include=>['silo']
  end

end




# == Schema Information
#
# Table name: acta_silo
#
#  id                  :integer         not null, primary key
#  silo_id             :integer         not null
#  ciclo_productivo_id :integer         not null
#  nro_acta            :integer
#  fecha_inicio        :date            not null
#  fecha_fin           :date
#  status              :boolean
#  actividad_id        :integer
#

