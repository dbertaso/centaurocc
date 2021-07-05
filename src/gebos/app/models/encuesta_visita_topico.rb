# encoding: utf-8
#
# autor: Luis Rojas
# clase: EncuestaVisitaTopico
# descripción: Migración a Rails 3
#
class EncuestaVisitaTopico < ActiveRecord::Base

  self.table_name = 'encuesta_visita_topico'
  
  attr_accessible :id,
				  :analisis_topico_id,
				  :respuesta,
				  :seguimiento_visita_id

  belongs_to :analisis_topico
  belongs_to :seguimiento_visita
  
  validates :analisis_topico_id, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.topico')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  def clonar(seguimiento_visita_id)
    analisis_topico = AnalisisTopico.find(:all, :conditions=>['activo = true'])
    analisis_topico.each{|i|
      encuesta_visita_topico = EncuestaVisitaTopico.new
      encuesta_visita_topico.analisis_topico_id = i.id
      encuesta_visita_topico.seguimiento_visita_id = seguimiento_visita_id
      encuesta_visita_topico.save
    }
  end
end

# == Schema Information
#
# Table name: encuesta_visita_topico
#
#  id                    :integer         not null, primary key
#  analisis_topico_id    :integer         not null
#  respuesta             :string(1)
#  seguimiento_visita_id :integer         not null
#

