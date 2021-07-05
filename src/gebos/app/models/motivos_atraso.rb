# encoding: utf-8

#
# autor: Diego Bertaso
# clase: MotivosAtraso
# creado en rails 3
#

class MotivosAtraso < ActiveRecord::Base

  self.table_name = 'motivos_atraso'

  attr_accessible :id,
                  :descripcion,
                  :activo

  validates_presence_of :descripcion,
    :message => "#{I18n.t('Sistema.Body.General.descripcion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}",
    :uniqueness=>{:message =>I18n.t('Sistema.Body.General.descripcion') << " " <<I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}    

  after_initialize :after_initialize

  def after_initialize
    self.activo = true
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
  
end

# == Schema Information
#
# Table name: motivos_atraso
#
#  id          :integer         not null, primary key
#  descripcion :text            not null
#  activo      :boolean         default(TRUE), not null
#

