# encoding: utf-8
class ArrimeConjunto < ActiveRecord::Base

  self.table_name = 'arrime_conjunto'
  
  attr_accessible :id,
    :letra_cedula,
    :cedula,
    :primer_nombre,
    :segundo_nombre,
    :primer_apellido,
    :segundo_apellido,
    :peso_condicionado,
    :boleta_arrime_id,
    :financiamiento_fondas
  
  belongs_to :boleta_arrime
  
  
  validates :letra_cedula, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nacionalidad')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :cedula, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.cedula')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :numericality =>{:numericality => true, :only_integer=>true, :message => I18n.t('Sistema.Body.Modelos.Errores.cedula_sin_decimales') }

  validates :primer_nombre, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.primer_nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :length => { :in => 4..60, :allow_blank => false,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.primer_nombre')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.primer_nombre')}  #{I18n.t('errors.messages.too_long.other')}"},
    :format =>{:with => /#{I18n.t('Sistema.Body.General.validar_nombre')}/, :allow_blank =>true, 
    :message => I18n.t('Sistema.Body.Modelos.Errores.primer_nombre_invalido')}
  
  validates :primer_apellido, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.primer_apellido')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :length => { :in => 4..60, :allow_blank => false,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.primer_apellido')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.primer_apellido')}  #{I18n.t('errors.messages.too_long.other')}"},
    :format =>{:with => /#{I18n.t('Sistema.Body.General.validar_nombre')}/, :allow_blank =>true, 
    :message => I18n.t('Sistema.Body.Modelos.Errores.primer_apellido_invalido')}
  
  validates :cedula, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletaArrime.Columnas.peso_condicionado')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :numericality =>{:numericality => true, :only_integer=>false, :message => "#{I18n.t('Sistema.Body.Modelos.BoletaArrime.Columnas.peso_condicionado')} #{I18n.t('errors.messages.not_a_number')}" }




  def before_save
    arrime_conjunto = ArrimeConjunto.find_by_cedula_and_boleta_arrime_id(self.cedula, self.boleta_arrime_id)
    unless arrime_conjunto.nil?
      errors.add(:arrime_conjunto, I18n.t('Sistema.Body.Modelos.Usuario.Errores.cedula_ya_existe'))
      return false
    end
  end

  def self.create_new(parametros, boleta_arrime_id)
    arrime_conjunto = ArrimeConjunto.new(parametros)
    arrime_conjunto.boleta_arrime_id = boleta_arrime_id
    if arrime_conjunto.save
      return true
    else
      errores = ''
      arrime_conjunto.errors.each { |e|
        errores << "<li>" + e[1] + "</li>"
      }
      return errores
    end
  end

  def self.delete(id)
    arrime_conjunto = ArrimeConjunto.find(id)
    arrime_conjunto.destroy
    return true
  end

end





# == Schema Information
#
# Table name: arrime_conjunto
#
#  id                    :integer         not null, primary key
#  letra_cedula          :string(1)
#  cedula                :integer
#  primer_nombre         :string(60)      not null
#  segundo_nombre        :string(60)
#  primer_apellido       :string(60)      not null
#  segundo_apellido      :string(60)
#  peso_condicionado     :decimal(16, 2)  default(0.0)
#  boleta_arrime_id      :integer         not null
#  financiamiento_fondas :boolean         default(FALSE)
#

