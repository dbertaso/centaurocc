class EncuestaVisita < ActiveRecord::Base

  self.table_name = 'encuesta_visita'
  
  belongs_to :analisis_conclusion
  belongs_to :seguimientovisita
  
  validates_presence_of :analisis_conclusion_id, :seguimiento_visita_id,
    :message => " es requerido"

  def clonar(seguimiento_visita_id)
    analisis_conclusion = AnalisisConclusion.find(:all, :conditions=>['activo = true'])
    analisis_conclusion.each{|i|
      encuesta_visita = EncuestaVisita.new
      encuesta_visita.analisis_conclusion_id = i.id
      encuesta_visita.seguimiento_visita_id = seguimiento_visita_id
      encuesta_visita.save
    }
  end
end

# == Schema Information
#
# Table name: encuesta_visita
#
#  id                     :integer         not null, primary key
#  analisis_conclusion_id :integer         not null
#  respuesta              :boolean
#  seguimiento_visita_id  :integer         not null
#

