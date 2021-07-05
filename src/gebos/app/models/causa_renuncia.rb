# encoding: UTF-8

#
# autor: Marvin Alfonzo
# clase: Basico::CausaRenuncia
# descripción: Migración a Rails 3
#
class CausaRenuncia < ActiveRecord::Base

  self.table_name = 'causa_renuncia'
  
  attr_accessible :id,
				  :nombre,
				  :descripcion,
				  :activo,
				  :nombre_f,
				  :descripcion_f

  validates_presence_of :nombre, 
    :message => I18n.t('Sistema.Body.Vistas.General.nombre') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerido')

  validates_presence_of :descripcion, 
    :message => I18n.t('Sistema.Body.Vistas.Form.descripcion') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerida')
      
  validates_length_of :nombre, :within => 0..80, :allow_nil => false,
  :too_short => I18n.t('Sistema.Body.Vistas.General.nombre') << " " << I18n.t('errors.messages.too_short.other'),
  :too_long => I18n.t('Sistema.Body.Vistas.General.nombre') << " " << I18n.t('errors.messages.too_long.other')
  
  validates_length_of :descripcion, :within => 0..200, :allow_nil => true,
  :too_short => I18n.t('Sistema.Body.Vistas.Form.descripcion') << " " << I18n.t('errors.messages.too_short.other'),
  :too_long => I18n.t('Sistema.Body.Vistas.Form.descripcion') << " " << I18n.t('errors.messages.too_long.other')
    
  validates_uniqueness_of :nombre,
    :message => I18n.t('Sistema.Body.Vistas.General.nombre') << " " << I18n.t('Sistema.Body.Modelos.Errores.ya_existe')
  
  validates_uniqueness_of :descripcion,
    :message => I18n.t('Sistema.Body.Vistas.Form.descripcion') << " " << I18n.t('Sistema.Body.Modelos.Errores.ya_existe')
  
  
  validate :validate
  
  def validate
    unless self.nombre.nil? || self.nombre.empty?
      a = self.nombre[/^[0-9a-zA-Z°;:,.\/ñÑáÁéÉíÍóÓúÚüÜÇ' ]+$/]
      if a.nil?
        errors.add(:causa_renuncia, I18n.t('Sistema.Body.Modelos.Actividad.Errores.nombre_invalido'))
      end
    end
    unless self.descripcion.nil? || self.descripcion.empty?
      a = self.descripcion[/^[0-9a-zA-Z°;:,.\/ñÑáÁéÉíÍóÓúÚüÜÇ' ]+$/]
      if a.nil?
        errors.add(:causa_renuncia, I18n.t('Sistema.Body.Modelos.Actividad.Errores.descripcion_invalida'))
      end
    end 
  end
    
  def nombre_f=(nombre)
    self.nombre = nombre.upcase
  end
    
  def nombre_f
    self.nombre.upcase unless self.nombre.nil?
  end

  def descripcion_f=(descripcion)
    self.descripcion = descripcion.upcase
  end
    
  def descripcion_f
    self.descripcion.upcase unless self.descripcion.nil?
  end
  
  def self.search(search, page, orden)    

    conditions=search
    
  
    logger.info "Conditions ===> " << conditions.to_s
    paginate :per_page=>@records_by_page, :page=>page, :conditions=>conditions, :order=>orden
  end
  
end

# == Schema Information
#
# Table name: causa_renuncia
#
#  id          :integer         not null, primary key
#  nombre      :string(80)      not null
#  descripcion :string(200)     not null
#  activo      :boolean         not null
#

