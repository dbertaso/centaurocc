# encoding: UTF-8

#
# autor: Diego Bertaso
# clase: RiesgoSudeban
# descripción: Migración a Rails 3
#

class RiesgoSudeban < ActiveRecord::Base

  self.table_name = 'riesgo_sudeban'

  attr_accessible :id,
                  :dias_vencidos_cota_inferior,
                  :dias_vencidos_cota_superior,
                  :categoria,
                  :porcentaje_riesgo

  validates :dias_vencidos_cota_inferior, 
            :presence => {:message => "#{I18n.t('Sistema.Body.Modelos.RiesgoInstitucion.Columnas.dias_vencidos_cota_inferior')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
            :numericality => {:numericality => true, 
                              :only_integer=>true, 
                              :message => "#{I18n.t('Sistema.Body.Modelos.RiesgoInstitucion.Columnas.dias_vencidos_cota_inferior')} #{I18n.t('errors.messages.not_an_integer')}"}

  validates :dias_vencidos_cota_superior, 
            :presence => {:message => "#{I18n.t('Sistema.Body.Modelos.RiesgoInstitucion.Columnas.dias_vencidos_cota_superior')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
            :numericality => {:numericality => true, 
                              :only_integer=>true,
                              :message => "#{I18n.t('Sistema.Body.Modelos.RiesgoInstitucion.Columnas.dias_vencidos_cota_superior')} #{I18n.t('errors.messages.not_an_integer')}"}


  validates :porcentaje_riesgo, 
            :presence => {:message => "#{I18n.t('Sistema.Body.Modelos.RiesgoInstitucion.Columnas.porcentaje_riesgo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
                          :numericality => {:numericality => true, 
                          :message => "#{I18n.t('Sistema.Body.Modelos.RiesgoInstitucion.Columnas.porcentaje_riesgo')} #{I18n.t('errors.messages.not_a_number')}"}

  validates :categoria, 
            :presence => {:message => "#{I18n.t('Sistema.Body.Modelos.RiesgoInstitucion.Columnas.categoria')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
            :format => {:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.solo_letras')}/,
            :message => "#{I18n.t('Sistema.Body.Modelos.RiesgoInstitucion.Columnas.categoria')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener_espacios')}"}

  validate :validate

  def validate

    if self.porcentaje_riesgo < 0
      errors.add(:riesgo_sudeban, "#{I18n.t('Sistema.Body.Modelos.RiesgoInstitucion.Columnas.porcentaje_riesgo')} #{I18n.t('Sistema.Body.Modelos.RiesgoInstitucion.Errores.mayor_igual_cero')}")
    end
    if self.porcentaje_riesgo > 100
      errors.add(:riesgo_sudeban,"#{I18n.t('Sistema.Body.Modelos.RiesgoInstitucion.Columnas.porcentaje_riesgo')} #{I18n.t('Sistema.Body.Modelos.RiesgoInstitucion.Errores.menor_que_100')}")
    end
    if self.dias_vencidos_cota_inferior < 0
      errors.add(:riesgo_sudeban,"#{I18n.t('Sistema.Body.Modelos.RiesgoInstitucion.Columnas.dias_vencidos_cota_inferior')} #{I18n.t('Sistema.Body.Modelos.RiesgoInstitucion.Errores.mayor_igual_cero')}")
    end

    if self.dias_vencidos_cota_superior < 1
      errors.add(:riesgo_sudeban,"#{I18n.t('Sistema.Body.Modelos.RiesgoInstitucion.Columnas.dias_vencidos_cota_superior')} #{I18n.t('Sistema.Body.Modelos.RiesgoInstitucion.Errores.debe_ser_mayor_que_cero')}")
    end

    if self.dias_vencidos_cota_superior <= self.dias_vencidos_cota_inferior
      errors.add(:riesgo_sudeban,"#{I18n.t('Sistema.Body.Modelos.RiesgoInstitucion.Columnas.dias_vencidos_cota_superior')} #{I18n.t('Sistema.Body.Modelos.RiesgoInstitucion.Errores.debe_ser_mayor')} #{I18n.t('Sistema.Body.Modelos.RiesgoInstitucion.Columnas.dias_vencidos_cota_inferior')}")
    end

  end

  def self.search(search, page, sort)

    paginate :per_page => @records_by_page, :page => page,
             :conditions => search, :order => sort
  end

end

# == Schema Information
#
# Table name: riesgo_sudeban
#
#  id                          :integer         not null, primary key
#  dias_vencidos_cota_inferior :integer         default(0)
#  dias_vencidos_cota_superior :integer         default(0)
#  categoria                   :string(1)       not null
#  porcentaje_riesgo           :decimal(16, 6)  default(0.0)
#

