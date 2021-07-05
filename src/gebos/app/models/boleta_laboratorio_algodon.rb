# encoding: utf-8

class BoletaLaboratorioAlgodon < ActiveRecord::Base

  self.table_name = 'boleta_laboratorio_algodon'
  
  attr_accessible :id,
  :boleta_arrime_id,
  :humedad,
  :humedad_absoluta,
  :impureza,
  :impureza_absoluta 

  
  belongs_to :solicitud
  belongs_to :silo
  belongs_to :rubro
  belongs_to :cliente
  #belongs_to :BoletaArrime

  validates :boleta_arrime_id, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.boleta_arrime_id')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :humedad, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.humedad')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :impureza, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.impureza')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :humedad_absoluta, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.humedad_absoluta')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :impureza_absoluta, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.impureza_absoluta')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}



  def self.check(id)
    parametros = BoletaLaboratorioMaiz.find_by_boleta_arrime_id(id)

    if parametros.humedad.nil? || parametros.humedad.to_f < 0
      errores = ''
      errores << "<li> Debe ingresar el porcentaje de humeda para confirmar </li>"
      return errores

    elsif parametros.impureza.nil? || parametros.impureza.to_f < 0
      errores = ''
      errores << "<li> Debe ingresar el porcentaje de impurezas para confirmar </li>"
      return errores
    end
    return true
  end


end

# == Schema Information
#
# Table name: boleta_laboratorio_algodon
#
#  id                :integer         not null, primary key
#  boleta_arrime_id  :integer         not null
#  humedad           :decimal(16, 2)  default(0.0), not null
#  humedad_absoluta  :decimal(16, 2)  default(0.0), not null
#  impureza          :decimal(16, 2)  default(0.0), not null
#  impureza_absoluta :decimal(16, 2)  default(0.0), not null
#

