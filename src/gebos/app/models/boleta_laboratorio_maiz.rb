# encoding: utf-8
class BoletaLaboratorioMaiz < ActiveRecord::Base

  self.table_name = 'boleta_laboratorio_maiz'

  attr_accessible :id,
  :boleta_arrime_id,
  :humedad,
  :impureza,
  :germinados_danados,
  :danados_insectos,
  :quemados,
  :danados_microorganismos,
  :partidos,
  :cristalizados,
  :amilaceos,
  :mezcla_color,
  :infectados,
  :danados_total,
  :semillas_objetables,
  :luv,
  :olor,
  :aspecto,
  :danados_calor,
  :aflatoxina,
  :sensorial,
  :hongos,
  :hibrido,
  :remolque,
  :motriz

 
  
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

  validates :germinados_danados, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.germinados_danados')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
 
  validates :danados_insectos, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.danados_insectos')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :quemados, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.quemados')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :danados_microorganismos, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.danados_microorganismos')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
 
  validates :partidos, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.partidos')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :cristalizados, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.cristalizados')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :amilaceos, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.amilaceos')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :mezcla_color, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.mezcla_color')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :infectados, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.infectados')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :danados_total, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.danados_total')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :semillas_objetables, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.semillas_objetables')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :luv, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.luv')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :olor, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.olor')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"} 
  
  validates :aspecto, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.aspecto')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :danados_calor, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.danados_calor')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :aflatoxina, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.aflatoxina')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :sensorial, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.sensorial')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :hongos, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.hongos')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :hibrido, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.hibrido')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :remolque, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.remolque')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :motriz, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.motriz')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}





  def self.check(id)
    parametros = BoletaLaboratorioMaiz.find_by_boleta_arrime_id(id)

    if parametros.humedad.nil? || parametros.humedad.to_f < 0
      errores = ''
      errores << "<li> #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Errores.debe_ingresar_porcentaje')} #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.humedad')} #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Errores.para_confirmar')} </li>"
      return errores

    elsif parametros.impureza.nil? || parametros.impureza.to_f < 0
      errores = ''
      errores << "<li> #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Errores.debe_ingresar_porcentaje')} #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.impureza')} #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Errores.para_confirmar')} </li>"
      return errores

    elsif parametros.germinados_danados.nil? || parametros.germinados_danados.to_f < 0
      errores = ''
      errores << "<li> #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Errores.debe_ingresar_porcentaje')} #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.germinados_danados')} #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Errores.para_confirmar')} </li>"
      return errores

    elsif parametros.danados_insectos.nil? || parametros.danados_insectos.to_f < 0
      errores = ''
      errores << "<li> #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Errores.debe_ingresar_porcentaje')} #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.danados_insectos')} #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Errores.para_confirmar')} </li>"
      return errores

    elsif parametros.quemados.nil? || parametros.quemados.to_f < 0
      errores = ''
      errores << "<li> #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Errores.debe_ingresar_porcentaje')} #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.quemados')} #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Errores.para_confirmar')} </li>"
      return errores

    elsif parametros.danados_microorganismos.nil? || parametros.danados_microorganismos.to_f < 0
      errores = ''
      errores << "<li> #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Errores.debe_ingresar_porcentaje')} #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.danados_microorganismos')} #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Errores.para_confirmar')} </li>"
      return errores

    elsif parametros.partidos.nil? || parametros.partidos.to_f < 0
      errores = ''
      errores << "<li> #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Errores.debe_ingresar_porcentaje')} #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.partidos')} #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Errores.para_confirmar')} </li>"
      return errores

    elsif parametros.cristalizados.nil? || parametros.cristalizados.to_f < 0
      errores = ''
      errores << "<li> #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Errores.debe_ingresar_porcentaje')} #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.cristalizados')} #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Errores.para_confirmar')} </li>"
      return errores

    elsif parametros.amilaceos.nil? || parametros.amilaceos.to_f < 0
      errores = ''
      errores << "<li> #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Errores.debe_ingresar_porcentaje')} #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.amilaceos')} #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Errores.para_confirmar')} </li>"
      return errores

    elsif parametros.mezcla_color.nil? || parametros.mezcla_color.to_f < 0
      errores = ''
      errores << "<li> #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Errores.debe_ingresar_porcentaje')} #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.mezcla_color')} #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Errores.para_confirmar')} </li>"
      return errores

    elsif parametros.infectados.nil? || parametros.infectados.to_f < 0
      errores = ''
      errores << "<li> #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Errores.debe_ingresar_porcentaje')} #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.infectados')} #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Errores.para_confirmar')} </li>"
      return errores

    elsif parametros.danados_total.nil? || parametros.danados_total.to_f < 0
      errores = ''
      errores << "<li> #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Errores.debe_ingresar_porcentaje')} #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Columnas.danados_total')} #{I18n.t('Sistema.Body.Modelos.BoletasLaboratorios.Errores.para_confirmar')} </li>"
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
# Table name: boleta_laboratorio_maiz
#
#  id                      :integer         not null, primary key
#  boleta_arrime_id        :integer         not null
#  humedad                 :decimal(16, 2)  default(0.0), not null
#  impureza                :decimal(16, 2)  default(0.0), not null
#  germinados_danados      :decimal(16, 2)  default(0.0), not null
#  danados_insectos        :decimal(16, 2)  default(0.0), not null
#  quemados                :decimal(16, 2)  default(0.0), not null
#  danados_microorganismos :decimal(16, 2)  default(0.0), not null
#  partidos                :decimal(16, 2)  default(0.0), not null
#  cristalizados           :decimal(16, 2)  default(0.0), not null
#  amilaceos               :decimal(16, 2)  default(0.0), not null
#  mezcla_color            :decimal(16, 2)  default(0.0), not null
#  infectados              :decimal(16, 2)  default(0.0), not null
#  danados_total           :decimal(16, 2)  default(0.0), not null
#  semillas_objetables     :decimal(16, 2)  default(0.0), not null
#  luv                     :string
#  olor                    :string(20)
#  aspecto                 :string(20)
#  danados_calor           :decimal(16, 2)  default(0.0)
#  aflatoxina              :string(6)
#  sensorial               :decimal(16, 2)  default(0.0)
#  hongos                  :decimal(16, 2)  default(0.0)
#  hibrido                 :decimal(16, 2)  default(0.0)
#  remolque                :decimal(16, 2)  default(0.0)
#  motriz                  :decimal(16, 2)  default(0.0)
#

