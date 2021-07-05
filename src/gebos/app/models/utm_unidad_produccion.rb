# encoding: utf-8

#
# autor: 
# clase: UtmUnidadProduccion
# descripción: Migración a Rails 3
#

class UtmUnidadProduccion < ActiveRecord::Base

  self.table_name = 'utm_unidad_produccion'
  
  attr_accessible :id,
				  :utm,
				  :unidad_produccion_id,
				  :ubicacion_geografica

  belongs_to :unidad_produccion

  validates :utm, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.utm')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :numericality => {:numericality => true, :message => "#{I18n.t('Sistema.Body.Vistas.General.utm')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}"},
    :length => { :in => 3..100, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.utm')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.utm')}  #{I18n.t('errors.messages.too_long.other')}"}

  validates :ubicacion_geografica, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.ubicacion')} #{I18n.t('Sistema.Body.Vistas.General.geografica')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  def self.create_new(parametros, unidad_produccion_id)
    utm_unidad_produccion = UtmUnidadProduccion.new(parametros)
    utm_unidad_produccion.unidad_produccion_id = unidad_produccion_id
    if utm_unidad_produccion.save
      return true
    else
      errores = ''
      utm_unidad_produccion.errors.full_messages.each do |error|
        errores << "<li>#{error}</li>"
      end
      return errores
    end
  end

  def self.delete(id)
    utm_unidad_produccion = UtmUnidadProduccion.find(id)
    utm_unidad_produccion.destroy
    return true
  end

  def ubicacion_geografica_w
    unless self.ubicacion_geografica.nil?
      if self.ubicacion_geografica == 'C'
        return I18n.t('Sistema.Body.Vistas.General.cuadrante')
      elsif self.ubicacion_geografica == 'E'
        return I18n.t('Sistema.Body.Vistas.General.este')
      elsif self.ubicacion_geografica == 'N'
        return I18n.t('Sistema.Body.Vistas.General.norte')
      elsif self.ubicacion_geografica == 'O'
        return I18n.t('Sistema.Body.Vistas.General.oeste')
      elsif self.ubicacion_geografica == 'S'
        return I18n.t('Sistema.Body.Vistas.General.sur')
      end
    end
  end

end

# == Schema Information
#
# Table name: utm_unidad_produccion
#
#  id                   :integer         not null, primary key
#  utm                  :string(100)     not null
#  unidad_produccion_id :integer         not null
#  ubicacion_geografica :string(1)
#

