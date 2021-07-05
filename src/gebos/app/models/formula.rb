# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Formula
# descripción: Migración a Rails 3
#

class Formula < ActiveRecord::Base

  self.table_name = 'formula'

  attr_accessible :id,
                  :nombre,
                  :descripcion

  validates :nombre,
  :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :descripcion,
  :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.Form.descripcion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}


  validates_length_of :nombre, :within => 1..40, :allow_nil => false,
    :too_long => "#{I18n.t('Sistema.Body.General.nombre')} #{I18n.t('es.errors.message.too_long.other')}",
    :too_short => "#{I18n.t('Sistema.Body.General.nombre')} #{I18n.t('es.errors.message.too_short.other')}"

  validates_length_of :descripcion, :within => 1..300, :allow_nil => false,
    :too_long => "#{I18n.t('Sistema.Body.Form.descripcion')} #{I18n.t('es.errors.message.too_long.other')}",
    :too_short => "#{I18n.t('Sistema.Body.Form.descripcion')} #{I18n.t('es.errors.message.too_short.other')}"

  validates :nombre,
   :uniqueness => {:message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"}

  def self.search(search, page, sort)

    joins = 'INNER JOIN producto_formula ON producto_formula.formula_id = formula.id'
    unless search.nil?
      paginate  :per_page => @records_by_page, :page => page,
                :conditions => search, :order => sort, :joins=>joins
    else
      paginate  :per_page => @records_by_page, :page => page,
                :order => sort, :joins=>joins

    end

  end

end

# == Schema Information
#
# Table name: formula
#
#  id          :integer         not null, primary key
#  nombre      :string(40)      not null
#  descripcion :string(200)
#

