# encoding: utf-8

#
# autor: Luis Rojas
# clase: TipoGarantia
# descripción: Migración a Rails 3
#
class TipoGarantia < ActiveRecord::Base

  self.table_name = 'tipo_garantia'
  
  attr_accessible :id, :nombre, :descripcion, :activo, :tipo
  
  has_many :solicitud_tipo_garantia
  has_many :solicitud_avaluo_prenda_semoviente
  has_many :garantia_sector
  has_many :programa_tipo_garantia

  validates :nombre, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :format => {:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio_numero_puntuacion')}/, 
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}"}
  
  validates :descripcion, :presence => {:message => "#{I18n.t('Sistema.Body.General.descripcion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :format => {:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio_numero_puntuacion')}/, 
    :message => "#{I18n.t('Sistema.Body.General.descripcion')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}"}
    
  validates_length_of :nombre, :within => 4..40, :allow_blank => true
      
  validates_length_of :descripcion, :within => 5..300, :allow_blank => true
      
  validates_uniqueness_of :nombre, 
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"
  
  
  def eliminar(id)
    begin
      solicitud_tipo_garantia = SolicitudTipoGarantia.count(:conditions=>"tipo_garantia_id = #{self.id}")
      if solicitud_tipo_garantia > 0
        errors.add(:tipo_garantia, I18n.t('Sistema.Body.Controladores.TipoGarantia.Etiquetas.no_se_puede_eliminar'))
        return false
      else
        tipo_garantia = TipoGarantia.find(id)
        transaction do
          tipo_garantia.destroy
          return true
        end
      end
    rescue
      errors.add(:tipo_garantia, I18n.t('Sistema.Body.Controladores.TipoGarantia.Etiquetas.no_se_puede_eliminar'))
      return false
    end
  end
  
  
 
  def self.search(search, page, sort)

    paginate  :per_page => @records_by_page, :page => page,
      :conditions => search, :order => sort
    
#    joins = 'INNER JOIN programa_tipo_garantia ON programa_tipo_garantia.tipo_garantia_id = tipo_garantia.id'
#    paginate  :per_page => @records_by_page, :page => page,
#      :conditions => search, :order => sort, :joins=>joins

  end
end

# == Schema Information
#
# Table name: tipo_garantia
#
#  id          :integer         not null, primary key
#  nombre      :string(40)      not null
#  descripcion :string(300)     not null
#  activo      :boolean         default(TRUE)
#  tipo        :string(1)
#

