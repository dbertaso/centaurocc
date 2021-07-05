# encoding: utf-8

#
# autor: Diego Bertaso
# clase: ProgramaTipoCliente
# descripción: Migración a Rails 3
#
class ProgramaTipoCliente < ActiveRecord::Base

  self.table_name = 'programa_tipo_cliente'

  attr_accessible :id,
                  :programa_id,
                  :tipo_cliente_id

  belongs_to :programa
  belongs_to :tipo_cliente

  validates :programa_id,
    :presence => {:message => "#{I18n.t('Sistema.Body.Controladores.Programa.FormTitles.form_title_record')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :tipo_cliente_id,
    :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.tipo_beneficiario')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates_uniqueness_of :tipo_cliente_id,
  :scope => [:programa_id],
  :message => "#{I18n.t('Sistema.Body.Vistas.General.tipo_beneficiario')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"

  def self.search(search, page, sort)

    unless search.nil?
      paginate  :per_page => @records_by_page, :page => page,
                :conditions => search, :order => sort, :include=>[:tipo_cliente]
    else
      paginate  :per_page => @records_by_page, :page => page,
                :order => sort, :include=>[:tipo_cliente]

    end

  end
end

# == Schema Information
#
# Table name: programa_tipo_cliente
#
#  id              :integer         not null, primary key
#  programa_id     :integer         not null
#  tipo_cliente_id :integer         not null
#

