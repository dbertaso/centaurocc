# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Telecobranza
# creado con Rails 3
#

class Telecobranzas < ActiveRecord::Base

  self.table_name = 'telecobranzas'

  attr_accessible :id,
                  :gestion_cobranzas_id,
                  :direccion_id,
                  :telefono_id,
                  :senal_compromiso,
                  :motivos_atraso_id,
                  :persona_atendio_id,
                  :llamada_infructuosa_id,
                  :estatus,
                  :cantidad_intentos_fallidos,
                  :observacion

  belongs_to :gestion_cobranzas
  belongs_to :llamada_infructuosa
  belongs_to :persona_atendio
  belongs_to :motivos_atraso
  has_one :compromiso_pago,  :dependent=>:destroy

  validates :llamada_infructuosa_id, :presence => {:message => "#{I18n.t('Sistema.Body.Modelos.Telecobranzas.Columnas.codigo_llamada')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :persona_atendio_id, :presence => {:if => Proc.new {|a| a.llamada_infructuosa_id == 1 }, :message => "#{I18n.t('Sistema.Body.Modelos.Telecobranzas.Columnas.persona_atendio')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :motivos_atraso_id, 
    :presence => {:if => Proc.new {|a| a.persona_atendio_id == 1 }, :message => I18n.t('Sistema.Body.Modelos.Telecobranzas.Columnas.motivo_atraso')}

  validates :telefono_id, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.telefono')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :direccion_id, :presence => {:message => "#{I18n.t('Sistema.Body.General.direccion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

end

# == Schema Information
#
# Table name: telecobranzas
#
#  id                     :integer         not null, primary key
#  gestion_cobranzas_id   :integer         not null
#  direccion_id           :integer         not null
#  telefono_id            :integer         not null
#  senal_compromiso       :boolean         default(FALSE), not null
#  motivos_atraso_id      :integer
#  persona_atendio_id     :integer
#  llamada_infructuosa_id :integer         not null
#  estatus                :string(1)       not null
#  observacion            :text
#

