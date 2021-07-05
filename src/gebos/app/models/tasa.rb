# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Tasa
# descripción: Migración a Rails 3
#
class Tasa < ActiveRecord::Base

  self.table_name = 'tasa'

  attr_accessible :id,
                  :nombre,
                  :descripcion,
                  :sector_id,
                  :sub_sector_id,
                  :rubro_id,
                  :sub_rubro_id

  has_many :tasas_valor, :class_name=>"TasaValor"
  belongs_to :sector
  belongs_to :sub_sector
  belongs_to :rubro
  belongs_to :sub_rubro

  validates :nombre,
    :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :descripcion,
    :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.Form.descripcion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :sector,
    :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.sector')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :sub_sector,
    :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.sector')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :rubro,
    :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.sector')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :sub_rubro,
    :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.sector')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates_length_of :nombre, :within => 1..40, :allow_nil => false,
    :too_long => "#{I18n.t('Sistema.Body.General.nombre')} #{I18n.t('es.errors.message.too_long.other')}",
    :too_short => "#{I18n.t('Sistema.Body.General.nombre')} #{I18n.t('es.errors.message.too_short.other')}"

  validates_length_of :descripcion, :within => 1..300, :allow_nil => false,
    :too_long => "#{I18n.t('Sistema.Body.Form.descripcion')} #{I18n.t('es.errors.message.too_long.other')}",
    :too_short => "#{I18n.t('Sistema.Body.Form.descripcion')} #{I18n.t('es.errors.message.too_short.other')}"

  validates_uniqueness_of :nombre,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.sector')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"

  validates_uniqueness_of :sub_rubro_id,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.sub_rubro')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"

  def self.search(search, page, sort)

    unless search.nil?
      paginate  :per_page => @records_by_page, :page => page,
                :conditions => search, :order => sort
    else
      paginate  :per_page => @records_by_page, :page => page,
                :order => sort

    end

  end

  def add_tasa_valor(tasa_valor)

    if TasaValor.find_by_fecha_resolucion_desde_and_tasa_id(tasa_valor.fecha_resolucion_desde, id)
      errors.add(:tasa, I18n.t('Sistema.Body.Modelos.Tasa.Errores.valor_tasa_fecha'))
      false
    else

      tasas_valor<<tasa_valor

    end
  end

  def valor_actual
    self.tasas_valor.find(:first, :order=>'fecha_actualizacion DESC') .valor
  end

end


# == Schema Information
#
# Table name: tasa
#
#  id            :integer         not null, primary key
#  nombre        :string(40)      not null
#  descripcion   :string(300)
#  sector_id     :integer
#  sub_sector_id :integer
#  rubro_id      :integer
#  sub_rubro_id  :integer
#

