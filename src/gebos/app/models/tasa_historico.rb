# encoding: utf-8

#
# autor: Diego Bertaso
# clase: TasaHistorico
# descripción: Migración a Rails 3
#

class TasaHistorico < ActiveRecord::Base

  self.table_name = 'tasa_historico'

  attr_accessible :id,
                  :tasa_foncrei,
                  :tasa_intermediario,
                  :tasa_cliente,
                  :programa_id,
                  :tasa_valor_id

  belongs_to :tasa_valor
  belongs_to :programa

  validates_presence_of :tasa_foncrei,
    :message => "#{I18n.t('Sistema.Body.Vistas.TasaHistorico.Labels.tasa_foncrei')} #{I18n.t('Sistema.Head.title')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"

  validates_presence_of :tasa_intermediario,
    :message => "#{I18n.t('Sistema.Body.Vistas.TasaHistorico.Labels.tasa_intermediario')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"

  validates_presence_of :tasa_cliente,
    :message => "#{I18n.t('Sistema.Body.Vistas.TasaHistorico.Labels.tasa_cliente')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"

  validates_presence_of :programa,
    :message => "#{I18n.t('Sistema.Body.Controladores.Programa.FormTitles.form_title_record')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"

  validates_presence_of :tasa_valor_id,
    :message => "#{I18n.t('Sistema.Body.Vistas.TasaHistorico.Labels.tasa_referencia')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"

 def fecha_desde_f
   fecha_desde.strftime('%d/%m/%Y')
 end
 def fecha_hasta_f
   fecha_hasta.strftime('%d/%m/%Y')
 end
 def tasa_foncrei_f
   sprintf('%01.2f', self.tasa_foncrei).sub('.', ',') unless self.tasa_foncrei.nil?
 end
 def tasa_intermediario_f
   sprintf('%01.2f', self.tasa_intermediario).sub('.', ',') unless self.tasa_intermediario.nil?
 end
 def tasa_cliente_f
   sprintf('%01.2f', self.tasa_cliente).sub('.', ',') unless self.tasa_cliente.nil?
 end
end

# == Schema Information
#
# Table name: tasa_historico
#
#  id                 :integer         not null, primary key
#  tasa_foncrei       :float
#  tasa_intermediario :float
#  tasa_cliente       :float
#  programa_id        :integer         not null
#  tasa_valor_id      :integer         not null
#

