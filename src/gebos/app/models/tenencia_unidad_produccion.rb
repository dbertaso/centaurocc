# encoding: utf-8
class TenenciaUnidadProduccion < ActiveRecord::Base
  
  self.table_name = 'tenencia_unidad_produccion'
    
  has_many :unidad_negocio
  has_many :registro_mercantil
  
  attr_accessible :id,
                  :nombre

#  validates_uniqueness_of :nombre,
#    :message => I18n.t('Sistema.Body.Modelos.Errores.ya_existe')
  
  validates :nombre, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.Filtros.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :format =>{:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio_numero_otro')}/, :allow_blank =>true, :message =>"#{I18n.t('Sistema.Body.Vistas.Form.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalido')}"},
    :length => { :in => 3..100, :allow_blank => false,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.Filtros.nombre')} es demasiado corto (mínimo %{count})",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.Filtros.nombre')}  es demasiado largo (máximo %{count})"},
    :uniqueness =>{:uniqueness => true, :message => "#{I18n.t('Sistema.Body.Vistas.MotivoVisita.Etiquetas.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"}

    
#  validates_length_of :nombre, :within => 1..100, :allow_nil => false, :allow_blank => true
      
  
  def eliminar(id)
    begin
      registro_mercantil = RegistroMercantil.count(:conditions=>"tenencia_unidad_produccion_id = #{self.id}")
      if registro_mercantil > 0
        errors.add(:tenencia_unidad_produccion, I18n.t('Sistema.Body.Modelos.AlmacenMaquinaria.Errores.item_utilizado'))
        return false
      else
        tenencia_unidad_produccion = TenenciaUnidadProduccion.find(id)
        transaction do
          tenencia_unidad_produccion.destroy
          return true
        end
      end
    rescue
      errors.add(:tenencia_unidad_produccion, I18n.t('Sistema.Body.Modelos.AlmacenMaquinaria.Errores.item_utilizado'))
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
# Table name: tenencia_unidad_produccion
#
#  id     :integer         not null, primary key
#  nombre :string(100)     not null
#

