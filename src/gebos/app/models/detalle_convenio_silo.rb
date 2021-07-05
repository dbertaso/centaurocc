# encoding: utf-8
class DetalleConvenioSilo < ActiveRecord::Base
  
  self.table_name = 'detalle_convenio_silo'
  
  attr_accessible :id,
    :convenio_silo_id,
    :actividad_id,
    :usuario_id,
    :tipo_clase_grado,
    :valor 
  
  belongs_to :convenio_silo
  belongs_to :actividad

  validates :actividad_id, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.actividad')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :tipo_clase_grado, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.DetalleConvenioSilo.Etiquetas.tipo_clase_grado')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :valor, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.DetalleConvenioSilo.Etiquetas.precio_bs_kg')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}


    
  validate :before_save

  def before_save
    if self.id.nil?
      detalle_convenio_silo = DetalleConvenioSilo.count_by_sql("select count(cs.id)from convenio_silo cs left join detalle_convenio_silo dc on dc.convenio_silo_id = cs.id where cs.status = true and dc.actividad_id = #{self.actividad_id} and tipo_clase_grado = '#{self.tipo_clase_grado}'")
      unless detalle_convenio_silo == 0
        errors.add(:detalle_convenio_silo,"#{I18n.t('Sistema.Body.Vistas.General.actividad')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}")
        return false
      end
    else
      detalle_convenio_silo = DetalleConvenioSilo.count_by_sql("select count(cs.id)from convenio_silo cs left join detalle_convenio_silo dc on dc.convenio_silo_id = cs.id where cs.status = true and dc.actividad_id = #{self.actividad_id} and tipo_clase_grado = '#{self.tipo_clase_grado}' and dc.id <> #{self.id}")
      unless detalle_convenio_silo == 0
        errors.add(:detalle_convenio_silo,"#{I18n.t('Sistema.Body.Vistas.General.actividad')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}")
        return false
      end
    end
  end

  def eliminar(id)
    begin
      detalle_convenio_silo = DetalleConvenioSilo.find(id)
      transaction do
        detalle_convenio_silo.destroy
        return true
      end
    rescue
      errors.add(:detalle_convenio_silo, I18n.t('Sistema.Body.Modelos.Errores.item_utilizado'))
      return false
    end
  end

  def nombre_compuesto
    detalle_convenio_silo = DetalleConvenioSilo.find_by_id(self.id)
    nombre = detalle_convenio_silo.actividad.nombre + " #{I18n.t('Sistema.Body.Vistas.General.tipo')} " + detalle_convenio_silo.tipo_clase_grado
    return nombre
  end

  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
      :conditions => search, :order => sort, :include=>[:convenio_silo]
  end


end




# == Schema Information
#
# Table name: detalle_convenio_silo
#
#  id               :integer         not null, primary key
#  convenio_silo_id :integer         not null
#  actividad_id     :integer         not null
#  usuario_id       :integer         not null
#  tipo_clase_grado :string(1)       not null
#  valor            :decimal(16, 2)  default(0.0), not null
#

