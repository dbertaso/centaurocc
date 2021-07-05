# encoding: utf-8

#
# autor: Diego Bertaso
# clase: UnidadMedida
# descripción: Migración a Rails 3
#

class UnidadMedida < ActiveRecord::Base
  
  self.table_name = 'unidad_medida'
  
  attr_accessible :id,
                  :nombre,
                  :abreviatura
  
  validate :validate
  
  validates_presence_of :nombre, 
  :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"

  validates_length_of :nombre, :within => 1..30, :allow_nil => false,
  :too_short => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('errors.messages.too_short')}",
  :too_long => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('errors.messages.too_long')}"
  
  validates_length_of :abreviatura, :within => 1..10, :allow_nil => false,
  :too_short => "#{I18n.t('Sistema.Body.Modelos.UnidadMedida.Columnas.abreviatura')} #{I18n.t('errors.messages.too_short')}",
  :too_long => "#{I18n.t('Sistema.Body.Modelos.UnidadMedida.Columnas.abreviatura')} #{I18n.t('errors.messages.too_long')}"
  
  validates_uniqueness_of :nombre,
  :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"
  
  def validate
    unless self.nombre.nil? || self.nombre.empty?
      expr = /^[a-zA-ZñÑáÁéÉíÍóÓúÚüÜÇ' ]+$/
      a = expr.match(self.nombre)
      if a.nil?
        logger.error a.inspect
        errors.add(:unidad_medida, "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalido')}")
      end
    end
    unless self.abreviatura.nil? || self.abreviatura.empty?
      a = self.abreviatura[/^[a-zA-ZñÑáÁéÉíÍóÓúÚüÜÇ' ]+$/]
      if a.nil?
        errors.add(:unidad_medida, "#{I18n.t('Sistema.Body.Modelos.UnidadMedida.Columnas.abreviatura')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalida')}")
      end
    end 
  end

  def self.search(search, page, sort)

    paginate :per_page => @records_by_page, :page => page,
             :conditions => search, :order => sort

  end
  
  def before_destroy
    
    retorno = true
    
    item = Item.find_by_unidad_medida_id(self.id)
    
    unless item.nil?
      errors.add(:unidad_medida, "#{I18n.t('Sistema.Body.Modelos.UnidadMedida.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.usaoo_item')}")
      retorno = false
    end
    
    configurador = Configurador.find_by_unidad_medida_id(self.id)
    
    unless configurador.nil?
      errors.add(:unidad_medida, "#{I18n.t('Sistema.Body.Modelos.UnidadMedida.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.usaoo_configurador')}")
      retorno = false
    end
    
    return retorno
    
  end    
end

# == Schema Information
#
# Table name: unidad_medida
#
#  id          :integer         not null, primary key
#  nombre      :string(30)      default("Metros"), not null
#  abreviatura :string(10)      default("Mts"), not null
#

