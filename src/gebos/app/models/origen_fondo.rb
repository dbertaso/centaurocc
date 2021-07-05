# encoding: utf-8

#
# autor: Diego Bertaso
# clase: OrigenFondo
# descripción: Migración a Rails 3
#


class OrigenFondo < ActiveRecord::Base

  self.table_name = 'origen_fondo'

  attr_accessible :id,
                  :nombre,
                  :descripcion,
                  :activo,
                  :banco_origen,
                  :codigo_d3

  has_many :solicitud

  validate :validate
  validates_presence_of :nombre, 
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"
    
  validates_length_of :nombre, :within => 1..30, :allow_nil => false,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('errors.messages.too_long.other')}"
      
  validates_uniqueness_of :nombre, 
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"

  
  def validate
    unless self.nombre.nil? || self.nombre.empty?
      expr = /^[a-zA-ZñÑáÁéÉíÍóÓúÚüÜÇ' ]+$/ 
      a = expr.match(self.nombre)
      if a.nil?
        errors.add(:origen_fondo, "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}")
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
    
  def after_initialize
    self.activo = true unless self.activo
    self.banco_origen = 2 unless self.banco_origen
  end
  
end

# == Schema Information
#
# Table name: origen_fondo
#
#  id           :integer         not null, primary key
#  nombre       :string(40)      not null
#  descripcion  :string(300)     not null
#  activo       :boolean         default(TRUE)
#  banco_origen :integer
#  codigo_d3    :integer         default(0)
#

