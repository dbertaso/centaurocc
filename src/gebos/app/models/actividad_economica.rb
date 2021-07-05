# encoding: utf-8

#
# autor: Diego Bertaso
# clase: ActividadEconomica
# descripción: Migración a Rails 3
#
class ActividadEconomica < ActiveRecord::Base
  
  self.table_name = 'actividad_economica'
  
  attr_accessible   :ciiu,
                    :descripcion,
                    :sector_economico_id,
                    :sector_tipo_id

  belongs_to :sector_economico
  belongs_to :UnidadNegocio
  
  has_many :rama_actividad_economica
  has_many :Persona
  belongs_to :SectorTipo

  validates_uniqueness_of :descripcion, :scope => :sector_economico_id,
    :message => " ya existe"
    
  validates_length_of :descripcion, :within => 1..500, :allow_nil => false
    
  validates_length_of :ciiu, :within => 1..4, :allow_nil => false

  def before_destroy()
    @actividad_economica = ActividadEconomica.find(self.id, :include=>:rama_actividad_economica)
    @rama_actividad = @actividad_economica.rama_actividad_economica
    if @rama_actividad.size > 0
      errors.add(:actividad_economica, I18n.t('Sistema.Body.Modelos.ActividadEconomica.Errores.actividad_económica no puede ser eliminada'))
      return false
    end    
  end
  
end


# == Schema Information
#
# Table name: actividad_economica
#
#  id                  :integer         not null, primary key
#  ciiu                :string(4)       not null
#  descripcion         :string(500)     not null
#  sector_economico_id :integer         not null
#  sector_tipo_id      :integer
#

