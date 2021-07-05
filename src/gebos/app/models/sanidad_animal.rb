# encoding: utf-8
class SanidadAnimal < ActiveRecord::Base

  self.table_name = 'sanidad_animal'
  
  attr_accessible :id, 
    :seguimiento_visita_id,
    :examenes_laboratorio,
    :resultados,
    :tipo_examen,
    :plan_vacunacion_vigente

  belongs_to :seguimiento_visita
  has_many :vacunacion, :class_name=>'Vacunacion'

  #  validates_presence_of :examenes_laboratorio,
  #    :message => "^ ¿El Productor ha realizado Exámenes de Laboratorio? es requerido"


end

# == Schema Information
#
# Table name: sanidad_animal
#
#  id                      :integer         not null, primary key
#  seguimiento_visita_id   :integer         not null
#  examenes_laboratorio    :boolean         default(FALSE), not null
#  resultados              :text
#  tipo_examen             :string(100)
#  plan_vacunacion_vigente :boolean         default(TRUE)
#

