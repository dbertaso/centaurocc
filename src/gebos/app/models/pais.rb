# encoding: utf-8

#
# autor: Diego Bertaso
# clase: pais
# descripción: Migración a Rails 3
#

class Pais < ActiveRecord::Base

  self.table_name = 'pais'

  attr_accessible :id,
                  :nombre,
                  :abreviacion

  has_many :region
  has_many :estado
  has_many :persona
  has_many :solicitud_producto

  validates_presence_of :nombre,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"

  validates_length_of :nombre, :within => 1..30, :allow_nil => false,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('errors.messages.too_long.other')}"

  validates_length_of :abreviacion, :within => 0..2, :allow_nil => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.abreviatura')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.abreviatura')} #{I18n.t('errors.messages.too_long.other')}"

  validates_uniqueness_of :nombre,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')}  #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"


  validate :validate

  def self.search(search, page, sort)

    unless search.nil?
      paginate  :per_page => @records_by_page, :page => page,
                :conditions => search, :order => sort
    else
      paginate  :per_page => @records_by_page, :page => page,
                :order => sort

    end

  end

  def validate
    unless self.nombre.nil? || self.nombre.empty?
      expr = /^[a-zA-ZñÑáÁéÉíÍóÓúÚüÜÇ' ]+$/
      a = expr.match(self.nombre)
      if a.nil?
        errors.add(:pais, I18n.t('Sistema.Body.Modelos.Actividad.Errores.nombre_invalido'))
      end
    end
    unless self.abreviacion.nil? || self.abreviacion.empty?
      expr = /^[a-zA-ZñÑáÁéÉíÍóÓúÚüÜÇ' ]+$/
      a = expr.match(self.abreviacion)
      if a.nil?
        errors.add(:pais, I18n.t('Sistema.Body.Vistas.General.abreviatura') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_invalida'))
      end
    end
  end

  def self.find_all
    self.find(:all, :order=>'nombre')
  end

  def self.find_by_nombre(nombre)
    self.find(:first,
      :conditions => [ 'LOWER(nombre) = ?',
      nombre.downcase ])
  end



end

# == Schema Information
#
# Table name: pais
#
#  id          :integer         not null, primary key
#  nombre      :string(50)      not null
#  abreviacion :string(2)
#

