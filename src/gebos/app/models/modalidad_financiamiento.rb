# encoding: utf-8

#
# autor: Diego Bertaso
# clase: ModalidadFinanciamiento
# descripción: Migración a Rails 3
#

class ModalidadFinanciamiento < ActiveRecord::Base

  self.table_name = 'modalidad_financiamiento'

  attr_accessible :id,
                  :nombre,
                  :descripcion,
                  :activo,
                  :codigo_d3

  validate :validate

  validates :nombre,
    :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :descripcion,
    :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.Form.descripcion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates_length_of :nombre, :within => 1..40, :allow_nil => false,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('errors.messages.too_long.other')}"

  validates_length_of :descripcion, :within => 1..300, :allow_nil => false,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.Form.descripcion')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.descripcion')} #{I18n.t('errors.messages.too_long.other')}"

  validates_uniqueness_of :nombre,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"

  def validate
    unless self.nombre.nil? || self.nombre.empty?
      expr = /^[a-zA-ZñÑáÁéÉíÍóÓúÚüÜÇ' ]+$/
      a = expr.match(self.nombre)
      if a.nil?
        errors.add(:modalidad_financiamiento, "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}")
      end
    end
  end

  def self.search(search, page, sort)

    unless search.nil?
      paginate  :per_page => @records_by_page, :page => page,
                :joins=>'INNER JOIN programa_modalidad_financiamiento ON programa_modalidad_financiamiento.modalidad_financiamiento_id = modalidad_financiamiento.id',
                :conditions => search, :order => sort
    else
      paginate  :per_page => @records_by_page, :page => page,
                :order => sort, :joins=>joins

    end

  end

end

# == Schema Information
#
# Table name: modalidad_financiamiento
#
#  id          :integer         not null, primary key
#  nombre      :string(40)      not null
#  descripcion :string(300)     not null
#  activo      :boolean         default(TRUE)
#  codigo_d3   :string(20)
#

