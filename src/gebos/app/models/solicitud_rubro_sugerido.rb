# encoding: utf-8
#
# autor: Luis Rojas
# clase: SolicitudRubroSugerido
# descripcion: Migracion a Rails 3
#
class SolicitudRubroSugerido < ActiveRecord::Base
  
  self.table_name = 'solicitud_rubro_sugerido'
  
  attr_accessible :id, :ector_id, :sub_sector_id, :rubro_id, :cantidad, :solicitud_id

  belongs_to :sector
  belongs_to :sub_sector
  belongs_to :rubro
  belongs_to :solicitud

  validates :sector_id, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.sector')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerida')}"}

  validates :sub_sector_id, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.sub_sector')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerida')}"}
  
  validates :rubro_id, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.rubro')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerida')}"}

  validates :cantidad, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.cantidad')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerida')}"},
    :numericality => {:numericality => true, :message => "#{I18n.t('Sistema.Body.Vistas.General.cantidad')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}", :allow_nil => true}

  def create_new(params)
    solicitud_rubro_sugerido = SolicitudRubroSugerido.new
    solicitud_rubro_sugerido.sector_id = params[:sector_id]
    solicitud_rubro_sugerido.sub_sector_id = params[:sub_sector_id]
    solicitud_rubro_sugerido.rubro_id = params[:rubro_id]
    solicitud_rubro_sugerido.cantidad = params[:cantidad]
    solicitud_rubro_sugerido.solicitud_id = params[:solicitud_id]
    if solicitud_rubro_sugerido.save
      return true
    else
      errores = ""
      solicitud_rubro_sugerido.errors.full_messages.each{ |e|
        errores << "<li>" + e + "</li>"
      }
      return errores
    end
  end
  
end

# == Schema Information
#
# Table name: solicitud_rubro_sugerido
#
#  id            :integer         not null, primary key
#  sector_id     :integer         not null
#  sub_sector_id :integer         not null
#  rubro_id      :integer         not null
#  cantidad      :float           not null
#  solicitud_id  :integer         not null
#

