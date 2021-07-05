# encoding: utf-8
class BoletaLaboratorioArroz < ActiveRecord::Base

  self.table_name = "boleta_laboratorio_arroz"
  
  attr_accessible :id,
  :boleta_arrime_id,
  :humedad,
  :impureza,
  :blanco_total,
  :enteros,
  :yesosos,
  :panza_blanca,
  :punta_negra,
  :danados,
  :rojos,
  :verdes,
  :sin_cascara,
  :manchados,
  :infectados,
  :semillas_objetables,
  :luv,
  :olor,
  :aspecto,
  :rendimiento,
  :yesosos_panza_blanca,
  :partidos,
  :peso_especifico
  
  
  
  belongs_to :solicitud
  belongs_to :silo
  belongs_to :rubro
  belongs_to :cliente

  
  validates :boleta_arrime_id, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.boleta_arrime_id')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :humedad, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.humedad')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :impureza, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.impureza')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :blanco_total, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.blanco_total')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :enteros, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.enteros')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :yesosos, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.yesosos')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
   
  validates :panza_blanca, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.panza_blanca')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :punta_negra, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.punta_negra')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :danados, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.danados')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :rojos, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.rojos')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
 
  validates :verdes, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.verdes')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :sin_cascara, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.sin_cascara')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :manchados, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.manchados')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :infectados, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.infectados')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :semillas_objetables, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.semillas_objetables')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :luv, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.luv')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :olor, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.olor')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"} 
  
  validates :aspecto, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.aspecto')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :rendimiento, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.rendimiento')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"} 
  
  validates :yesosos_panza_blanca, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.yesosos_panza_blanca')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :partidos, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.partidos')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"} 
  
  validates :peso_especifico, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.peso_especifico')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}


  def self.check(id)
    parametros = BoletaLaboratorioArroz.find_by_boleta_arrime_id(id)

    if parametros.humedad.nil? || parametros.humedad.to_f < 0
      errores = ''
      errores << "<li> #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Errores.debe_ingresar_porcentaje')} #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.humedad')} #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Errores.para_confirmar')} </li>"
      return errores

    elsif parametros.impureza.nil? || parametros.impureza.to_f < 0
      errores = ''
      errores << "<li> #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Errores.debe_ingresar_porcentaje')} #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.impureza')} #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Errores.para_confirmar')} </li>"
      return errores

    elsif parametros.blanco_total.nil? || parametros.blanco_total.to_f < 0
      errores = ''
      errores << "<li> #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Errores.debe_ingresar_porcentaje')} #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.blanco_total')} #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Errores.para_confirmar')} </li>"
      return errores

    elsif parametros.enteros.nil? || parametros.enteros.to_f < 0
      errores = ''
      errores << "<li> #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Errores.debe_ingresar_porcentaje')} #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.enteros')} #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Errores.para_confirmar')} </li>"
      return errores

    elsif parametros.yesosos.nil? || parametros.yesosos.to_f < 0
      errores = ''
      errores << "<li> #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Errores.debe_ingresar_porcentaje')} #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.yesosos')} #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Errores.para_confirmar')} </li>"
      return errores

    elsif parametros.panza_blanca.nil? || parametros.panza_blanca.to_f < 0
      errores = ''
      errores << "<li> #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Errores.debe_ingresar_porcentaje')} #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.panza_blanca')} #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Errores.para_confirmar')} </li>"
      return errores

    elsif parametros.punta_negra.nil? || parametros.punta_negra.to_f < 0
      errores = ''
      errores << "<li> #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Errores.debe_ingresar_porcentaje')} #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.punta_negra')} #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Errores.para_confirmar')} </li>"
      return errores

    elsif parametros.danados.nil? || parametros.danados.to_f < 0
      errores = ''
      errores << "<li> #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Errores.debe_ingresar_porcentaje')} #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.danados')} #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Errores.para_confirmar')} </li>"
      return errores

    elsif parametros.rojos.nil? || parametros.rojos.to_f < 0
      errores = ''
      errores << "<li> #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Errores.debe_ingresar_porcentaje')} #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.rojos')} #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Errores.para_confirmar')} </li>"
      return errores

    elsif parametros.verdes.nil? || parametros.verdes.to_f < 0
      errores = ''
      errores << "<li> #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Errores.debe_ingresar_porcentaje')} #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.verdes')} #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Errores.para_confirmar')} </li>"
      return errores

    elsif parametros.sin_cascara.nil? || parametros.sin_cascara.to_f < 0
      errores = ''
      errores << "<li> #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Errores.debe_ingresar_porcentaje')} #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.sin_cascara')} #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Errores.para_confirmar')} </li>"
      return errores

    elsif parametros.manchados.nil? || parametros.manchados.to_f < 0
      errores = ''
      errores << "<li> #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Errores.debe_ingresar_porcentaje')} #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.manchados')} #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Errores.para_confirmar')} </li>"
      return errores

    elsif parametros.infectados.nil? || parametros.infectados.to_f < 0
      errores = ''
      errores << "<li> #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Errores.debe_ingresar_porcentaje')} #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.infectados')} #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Errores.para_confirmar')} </li>"
      return errores

    elsif parametros.semillas_objetables.nil? || parametros.semillas_objetables.to_f < 0
      errores = ''
      errores << "<li> #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Errores.debe_ingresar_porcentaje')} #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.semillas_objetables')} #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Errores.para_confirmar')} </li>"
      return errores

    elsif parametros.luv.nil?
      errores = ''
      errores << "<li> #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Errores.debe_ingresar_porcentaje')} #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.luv')} #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Errores.para_confirmar')} </li>"
      return errores
    end     
    return true
  end



end

# == Schema Information
#
# Table name: boleta_laboratorio_arroz
#
#  id                   :integer         not null, primary key
#  boleta_arrime_id     :integer         not null
#  humedad              :decimal(16, 2)  default(0.0), not null
#  impureza             :decimal(16, 2)  default(0.0), not null
#  blanco_total         :decimal(16, 2)  default(0.0), not null
#  enteros              :decimal(16, 2)  default(0.0), not null
#  yesosos              :decimal(16, 2)  default(0.0), not null
#  panza_blanca         :decimal(16, 2)  default(0.0), not null
#  punta_negra          :decimal(16, 2)  default(0.0), not null
#  danados              :decimal(16, 2)  default(0.0), not null
#  rojos                :decimal(16, 2)  default(0.0), not null
#  verdes               :decimal(16, 2)  default(0.0), not null
#  sin_cascara          :decimal(16, 2)  default(0.0), not null
#  manchados            :decimal(16, 2)  default(0.0), not null
#  infectados           :decimal(16, 2)  default(0.0), not null
#  semillas_objetables  :decimal(16, 2)  default(0.0), not null
#  luv                  :string
#  olor                 :string(20)
#  aspecto              :string(20)
#  rendimiento          :decimal(16, 2)  default(0.0)
#  yesosos_panza_blanca :decimal(16, 2)  default(0.0)
#  partidos             :decimal(16, 2)  default(0.0)
#  peso_especifico      :decimal(16, 2)  default(0.0)
#

