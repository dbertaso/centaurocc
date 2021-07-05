# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Nacionalidad
# descripción: Migración a Rails 3
#

class Nacionalidad < ActiveRecord::Base

  self.table_name = 'nacionalidad'
  
  attr_accessible :id,
                  :masculino,
                  :femenino,
                  :masculino_f,
                  :femenino_f
                  
  has_many :persona

  validate :validate
  
  validates_presence_of :masculino,
  :message => "#{I18n.t('Sistema.Body.Vistas.General.masculino')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"

  validates_presence_of :femenino, 
  :message => "#{I18n.t('Sistema.Body.Vistas.General.femenino')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"
      
  validates_length_of :masculino, :within => 0..100, :allow_nil => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.masculino')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.masculino')} #{I18n.t('errors.messages.too_long.other')}"

  validates_length_of :femenino, :within => 0..100, :allow_nil => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.femenino')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.femenino')} #{I18n.t('errors.messages.too_long.other')}"
    
  validates_uniqueness_of :masculino,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.masculino')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"

  validates_uniqueness_of :femenino,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.femenino')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"
      
  def validate
    unless self.masculino.nil? || self.masculino.empty?
      expr = /^[a-zA-ZñÑáÁéÉíÍóÓúÚüÜÇ' ]+$/
      a = expr.match(self.masculino)
      if a.nil?
        errors.add(:nacionalidad, "#{I18n.t('Sistema.Body.Vistas.General.masculino')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}")
      end
    end
    unless self.femenino.nil? || self.femenino.empty?
      expr = /^[a-zA-ZñÑáÁéÉíÍóÓúÚüÜÇ' ]+$/
      a = expr.match(self.femenino)
      if a.nil?
        errors.add(nacionalidad, "#{I18n.t('Sistema.Body.Vistas.General.femenino')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}")
      end
    end 
  end

  def self.search(search, page, sort)

    unless search.nil?
      paginate  :per_page => @records_by_page, :page => page,
                :conditions => search, :order => sort
    else
      paginate  :per_page => @records_by_page, :page => page,
                :order => sort

    end

  end
      
  def masculino_f=(masculino)
    self.masculino = masculino.upcase
  end
    
  def masculino_f
    self.masculino.upcase unless self.masculino.nil?
  end
  
  def femenino_f=(femenino)
    self.femenino = femenino.upcase
  end
    
  def femenino_f
    self.femenino.upcase unless self.femenino.nil?
  end
    
  def registro_f
    self.femenino.upcase + "/" + self.masculino.upcase
  end
end



# == Schema Information
#
# Table name: nacionalidad
#
#  id        :integer         not null, primary key
#  masculino :string(100)     not null
#  femenino  :string(100)     not null
#

