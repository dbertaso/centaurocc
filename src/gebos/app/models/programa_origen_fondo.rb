# encoding: utf-8

#
# autor: Diego Bertaso
# clase: ProgramaOrigenFondo
# descripción: Migración a Rails 3
#
class ProgramaOrigenFondo < ActiveRecord::Base

  self.table_name = 'programa_origen_fondo'

  attr_accessible :id,
                  :programa_id,
                  :origen_fondo_id,
                  :cuenta_contable_ingreso_interes_id,
                  :cuenta_contable_capital_id,
                  :cuenta_contable_capital_vencido_id

  belongs_to :programa
  belongs_to :origen_fondo
  belongs_to :cuenta_contable_ingreso_interes, :foreign_key=>"cuenta_contable_ingreso_interes_id", :class_name=>'CuentaContable'
  belongs_to :cuenta_contable_capital, :foreign_key=>"cuenta_contable_capital_id", :class_name=>'CuentaContable'
  belongs_to :cuenta_contable_capital_vencido, :foreign_key=>"cuenta_contable_capital_vencido_id", :class_name=>'CuentaContable'

  validates :programa,
  :presence => { :message => "#{I18n.t('Sistema.Body.Controladores.Programa.FormTitles.form_title_record')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates_uniqueness_of :programa_id,
  :scope => [:origen_fondo_id],
  :message => "#{I18n.t('Sistema.Body.Controladores.Programa.FormTitles.form_title_record')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"

  def self.search(search, page, sort)

    unless search.nil?
      paginate  :per_page => @records_by_page, :page => page,
                :conditions => search, :order => sort, :include=>[:origen_fondo]
    else
      paginate  :per_page => @records_by_page, :page => page,
                :order => sort, :include=>[:origen_fondo]

    end

  end

  def after_initialize
  end
end

# == Schema Information
#
# Table name: programa_origen_fondo
#
#  id                                 :integer         not null, primary key
#  programa_id                        :integer         not null
#  origen_fondo_id                    :integer         not null
#  cuenta_contable_ingreso_interes_id :integer
#  cuenta_contable_capital_id         :integer
#  cuenta_contable_capital_vencido_id :integer
#

