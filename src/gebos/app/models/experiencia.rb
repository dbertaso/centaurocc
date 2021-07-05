# encoding: utf-8

#
# autor: Marvin Alfonzo
# clase: Experiencia
# descripción: Migración a Rails 3
#

class Experiencia < ActiveRecord::Base

  self.table_name = 'experiencia'

  attr_accessible :id,
                  :nombre

  has_many :unidad_negocio

  validates_uniqueness_of :nombre,
    :message => I18n.t('Sistema.Body.Vistas.General.nombre') << " " <<I18n.t('Sistema.Body.Modelos.Errores.ya_existe')

  validates_length_of :nombre, :within => 4..100, :allow_nil => false,
    :too_short => I18n.t('Sistema.Body.Vistas.General.nombre') << " " <<I18n.t('errors.messages.too_short.other'),
    :too_long => I18n.t('Sistema.Body.Vistas.General.nombre') << " " <<I18n.t('errors.messages.too_long.other')

  validate :validate
  def validate
    unless self.nombre.nil? || self.nombre.empty?
      a = self.nombre[/^[a-z0-9A-ZñÑáÁéÉíÍóÓúÚüÜÇ'\- ]+$/]
      if a.nil?
        errors.add(:experiencia, I18n.t('Sistema.Body.Vistas.General.nombre')<< " " << I18n.t('Sistema.Body.Modelos.Errores.es_invalido') )
      end
    end
  end
  
  
  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
      :conditions => search, :order => sort
  end
end

# == Schema Information
#
# Table name: experiencia
#
#  id     :integer         not null, primary key
#  nombre :string(100)     not null
#

