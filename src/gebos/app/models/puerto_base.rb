# encoding: utf-8

#
# autor: Luis Rojas
# clase: PuertoBase
# descripción: Migración a Rails 3
#
class PuertoBase < ActiveRecord::Base
  
  self.table_name = 'puerto_base'

  attr_accessible :id, :nombre_puerto, :unidad_produccion_id

  belongs_to :unidad_produccion

  validates :nombre_puerto, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  def self.create_new(parametros, unidad_produccion_id)
    puerto_base = PuertoBase.new(parametros)
    puerto_base.unidad_produccion_id = unidad_produccion_id
    if puerto_base.save
      return true
    else
      errores = ''
      puerto_base.errors.each { |e|
        errores << "<li>" + e[1] + "</li>"
      }
      return errores
    end
  end

  def self.delete(id)
    puerto_base = PuertoBase.find(id)
    puerto_base.destroy
    return true
  end
  
end
# == Schema Information
#
# Table name: puerto_base
#
#  id                   :integer         not null, primary key
#  nombre_puerto        :string(200)     not null
#  unidad_produccion_id :integer         not null
#

