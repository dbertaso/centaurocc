# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Formacion
# descripción: Migración a Rails 3
#

class Formacion < ActiveRecord::Base

  self.table_name = 'formacion'

  attr_accessible :id,
                  :nombre

  has_many :unidad_negocio

  validate :validate

  validates_uniqueness_of :nombre,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"

  validates_length_of :nombre, :within => 1..100, :allow_nil => false,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('errors.messages.too_long.other')}"

  def validate
    unless self.nombre.nil? || self.nombre.empty?
      expr = /^[a-zA-ZñÑáÁéÉíÍóÓúÚüÜÇ' ]+$/
      a = expr.match(self.nombre)
      if a.nil?
        errors.add(:formacion, "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}")
      end
    end
  end

  def self.search(search, page, sort)

    paginate  :per_page => @records_by_page, :page => page,
              :conditions => search, :order => sort
  end

end

# == Schema Information
#
# Table name: formacion
#
#  id     :integer         not null, primary key
#  nombre :string(100)     not null
#

