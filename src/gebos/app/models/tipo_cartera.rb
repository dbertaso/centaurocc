# encoding: utf-8

#
# autor: Diego Bertaso
# clase: TipoCartera
# descripción: Migración a Rails 3
#

class TipoCartera < ActiveRecord::Base
  
  self.table_name = 'tipo_cartera'
  
  attr_accessible :id,
                  :nombre
                  
  validates :nombre,
    :uniqueness => {:message => "#{I18n.t('Sistema.Body.Vistas.Form.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"},
    :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.Form.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}


  def self.get_nombre(id)
    tipo_cartera = TipoCartera.find(id)
    return tipo_cartera.nombre
  end
  
end

# == Schema Information
#
# Table name: tipo_cartera
#
#  id     :integer         not null, primary key
#  nombre :string(50)
#

