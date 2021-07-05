# encoding: utf-8

#
# autor: Diego Bertaso
# clase: HierroFondas
# descripción: Migración a Rails 3
#

class HierroFondas < ActiveRecord::Base
 
  self.table_name = 'hierro_fondas'
  
  attr_accessible :id,
                  :nombre_registro,
                  :estado_id,
                  :ciudad_id,
                  :municipio_id,
                  :fecha_registro,
                  :numero,
                  :tomo,
                  :protocolo,
                  :activo,
                  :fecha_registro_f
                  
  belongs_to :estado
  belongs_to :ciudad
  belongs_to :municipio

  validate :validate
  
  validates_presence_of :nombre_registro,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Vistas.General.registro')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"

  validates_presence_of :estado_id,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.estado')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"
    
  validates_presence_of :tomo,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.tomo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"

  validates_uniqueness_of :nombre_registro,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Vistas.General.registro')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"

  validates_numericality_of :numero, :only_integer=>true, :allow_nil => true,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.numero')} #{I18n.t('Sistema.Body.Vistas.General.registro')} #{I18n.t('errors.messages.not_an_integer')}"
  
  validates_numericality_of :protocolo, :only_integer=>true, :allow_nil => true,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.protocolo')} #{I18n.t('errors.messages.not_an_integer')}"
  
  validates_numericality_of :tomo, :only_integer=>true, :allow_nil => true,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.tomo')} #{I18n.t('errors.messages.not_an_integer')}"
  
  validates_length_of :numero, :within => 1..20, :allow_nil =>false,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.numero')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.numero')} #{I18n.t('errors.messages.too_long.other')}"

  validates_length_of :protocolo, :within => 1..20, :allow_nil =>false,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.protocolo')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.protocolo')} #{I18n.t('errors.messages.too_long.other')}"
    
  validates :fecha_registro,
    :date => {:message => I18n.t('Sistema.Body.Modelos.Errores.fecha_invalida')}

  def validate
    unless self.nombre_registro.nil? || self.nombre_registro.empty?
      expr = /^[a-zA-ZñÑáÁéÉíÍóÓúÚüÜÇ' ]+$/
      a = expr.match(self.nombre_registro)
      if a.nil?
        errors.add(:hierro_fondas, "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Vistas.General.registro')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}")
      end
    end
  end
  
  def self.search(search, page, sort)

    paginate :per_page => @records_by_page, :page => page,
           :conditions => search, :order => sort, :include=>[:estado]

  end
  
  def after_initialize
    self.activo = true
  end

  def fecha_registro_f=(fecha)
    self.fecha_registro = fecha
  end

  def fecha_registro_f
    self.fecha_registro.strftime('%d/%m/%Y') unless self.fecha_registro.nil?
  end
end


# == Schema Information
#
# Table name: hierro_fondas
#
#  id              :integer         not null, primary key
#  nombre_registro :string(100)
#  estado_id       :integer
#  ciudad_id       :integer
#  municipio_id    :integer
#  fecha_registro  :date
#  numero          :string(100)
#  tomo            :integer
#  protocolo       :string(100)
#  activo          :boolean
#

