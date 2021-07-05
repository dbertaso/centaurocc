# encoding: utf-8
#
# autor: Luis Rojas
# clase: Nemonico
# descripción: Migración a Rails 3
# fecha: 2014-02-13
#

class Nemonico < ActiveRecord::Base


  self.table_name = 'nemonico'

  attr_accessible :id,
                  :nemonico,
                  :nombre,
                  :descripcion
                
  validates :nemonico,
    :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.nemonico')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :length => { :in => 2..2, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.nemonico')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.nemonico')}  #{I18n.t('errors.messages.too_long.other')}"},
    :format =>{:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras')}/, :allow_blank =>true, 
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nemonico')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalido')}"},
    :uniqueness => {:message => "#{I18n.t('Sistema.Body.Vistas.General.nemonico')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"}

  validates :nombre,
    :presence => { :message => I18n.t('Sistema.Body.Modelos.Errores.nombre_requerido')},
    :format =>{:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio')}/, :allow_blank =>true, 
    :message => I18n.t('Sistema.Body.Modelos.Errores.nombre_invalido')},
    :uniqueness => {:message => "#{I18n.t('Sistema.Body.Vistas.Form.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"}

  validates :descripcion,
    :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.descripcion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerida')}"}
  
  before_save :before_save

  def before_save
    self.nemonico = self.nemonico.upcase
  end

  def self.search(search, page, sort)

    paginate :per_page => @records_by_page, :page => page,
             :conditions => search, :order => sort
  end

end
# == Schema Information
#
# Table name: nemonico
#
#  id          :integer         not null, primary key
#  nemonico    :string(2)       not null
#  nombre      :string(50)      not null
#  descripcion :string(250)     not null
#

