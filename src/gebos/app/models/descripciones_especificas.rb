# encoding: utf-8
class DescripcionesEspecificas < ActiveRecord::Base
  
  self.table_name = 'descripciones_especificas'
  
  attr_accessible :id,
    :seguimiento_visita_id,
    :seguimiento_cultivo_id,
    :descripcion,
    :comportamiento_agronomico,
    :factores_condicionantes,
    :labores_beneficiario

  belongs_to :seguimiento_visita
  belongs_to :seguimiento_cultivo
  
  validates :seguimiento_visita_id, :presence => {
    :message => I18n.t('Sistema.Body.Modelos.DescripcionesEspecificas.Errores.presence_seguimiento_visita')}

  validates :seguimiento_cultivo_id, :presence => {
    :message => I18n.t('Sistema.Body.Modelos.DescripcionesEspecificas.Errores.presence_seguimiento_cultivo')}

  validates :descripcion, :presence => {
    :message => I18n.t('Sistema.Body.Modelos.DescripcionesEspecificas.Errores.descripcion')}

  validates :labores_beneficiario, :presence => {
    :message => I18n.t('Sistema.Body.Modelos.DescripcionesEspecificas.Errores.labores_beneficiario')}


end


# == Schema Information
#
# Table name: descripciones_especificas
#
#  id                        :integer         not null, primary key
#  seguimiento_visita_id     :integer
#  seguimiento_cultivo_id    :integer
#  descripcion               :text
#  comportamiento_agronomico :text
#  factores_condicionantes   :text
#  labores_beneficiario      :text
#

